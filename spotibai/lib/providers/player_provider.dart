import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/song.dart';

/// Repeat behaviour of the player.
enum RepeatMode { off, all, one }

/// A fake music player: it manages a queue and "plays" it by advancing a
/// timer. No audio is produced – swap the timer for `just_audio` later if you
/// want real playback.
///
/// The playback position lives in a [ValueNotifier] so that the seek bar and
/// mini player can repaint every tick without rebuilding the whole app.
class PlayerProvider extends ChangeNotifier {
  static const Duration _tick = Duration(milliseconds: 250);

  final Random _random = Random();

  /// Current playback position (updated every 250 ms while playing).
  final ValueNotifier<Duration> position = ValueNotifier<Duration>(Duration.zero);

  List<Song> _queue = [];
  List<Song> _originalQueue = []; // un-shuffled order, restored when shuffle is off
  int _index = -1;
  bool _isPlaying = false;
  bool _shuffle = false;
  RepeatMode _repeat = RepeatMode.off;
  String? _collectionId;
  String? _collectionName;
  Timer? _timer;

  // ---- Read-only state ------------------------------------------------------

  List<Song> get queue => List.unmodifiable(_queue);
  int get currentIndex => _index;
  Song? get currentSong =>
      (_index >= 0 && _index < _queue.length) ? _queue[_index] : null;
  bool get isPlaying => _isPlaying;
  bool get shuffle => _shuffle;
  RepeatMode get repeat => _repeat;

  /// Id / name of the playlist the queue was started from (for the UI).
  String? get collectionId => _collectionId;
  String? get collectionName => _collectionName;

  // ---- Starting playback ----------------------------------------------------

  /// Plays [songs] as the new queue.
  ///
  /// * [startIndex] – which song to start with (random when shuffling and null).
  /// * [shuffle] – overrides the current shuffle setting when non-null.
  void playQueue(
    List<Song> songs, {
    int? startIndex,
    String? collectionId,
    String? collectionName,
    bool? shuffle,
  }) {
    if (songs.isEmpty) return;
    if (shuffle != null) _shuffle = shuffle;

    _collectionId = collectionId;
    _collectionName = collectionName;
    _originalQueue = List<Song>.of(songs);
    _queue = List<Song>.of(songs);

    if (_shuffle) {
      _queue.shuffle(_random);
      if (startIndex != null) {
        // Keep the tapped song first, shuffle everything after it.
        final start = songs[min(max(startIndex, 0), songs.length - 1)];
        _queue
          ..remove(start)
          ..insert(0, start);
      }
      _index = 0;
    } else {
      _index = min(max(startIndex ?? 0, 0), songs.length - 1);
    }

    _startPlayback();
  }

  /// Plays a single song. If [queue] is given, the song is played in the
  /// context of that list so next/previous work.
  void playSong(
    Song song, {
    List<Song>? queue,
    String? collectionId,
    String? collectionName,
  }) {
    var list = queue ?? <Song>[song];
    var start = list.indexWhere((s) => s.id == song.id);
    if (start < 0) {
      list = [song, ...list];
      start = 0;
    }
    playQueue(
      list,
      startIndex: start,
      collectionId: collectionId,
      collectionName: collectionName,
    );
  }

  /// Jumps to an entry of the current queue (used by the queue sheet).
  void jumpTo(int index) {
    if (index < 0 || index >= _queue.length) return;
    _index = index;
    _startPlayback();
  }

  /// Inserts [song] right after the current one ("Add to queue").
  void addToQueue(Song song) {
    if (_queue.isEmpty) {
      playSong(song);
      return;
    }
    _queue.insert(_index + 1, song);
    _originalQueue.add(song);
    notifyListeners();
  }

  // ---- Transport controls ---------------------------------------------------

  void togglePlay() {
    if (currentSong == null) return;
    if (_isPlaying) {
      _pause();
    } else {
      _isPlaying = true;
      _startTimer();
    }
    notifyListeners();
  }

  void next() {
    if (_queue.isEmpty) return;
    _index = (_index + 1) % _queue.length;
    _startPlayback();
  }

  /// Restarts the song if more than 3 s in, otherwise goes to the previous one.
  void previous() {
    if (_queue.isEmpty) return;
    if (position.value > const Duration(seconds: 3)) {
      position.value = Duration.zero;
      return;
    }
    _index = (_index - 1 + _queue.length) % _queue.length;
    _startPlayback();
  }

  /// Moves the playhead (used by the seek bar).
  void seek(Duration target) {
    final song = currentSong;
    if (song == null) return;
    final ms = min(max(target.inMilliseconds, 0), song.duration.inMilliseconds);
    position.value = Duration(milliseconds: ms);
  }

  void toggleShuffle() {
    _shuffle = !_shuffle;
    final current = currentSong;
    if (current != null) {
      if (_shuffle) {
        // Current song stays first, the rest is shuffled.
        final rest = List<Song>.of(_originalQueue)
          ..remove(current)
          ..shuffle(_random);
        _queue = [current, ...rest];
        _index = 0;
      } else {
        // Restore the original order and keep playing the same song.
        _queue = List<Song>.of(_originalQueue);
        _index = max(_queue.indexWhere((s) => s.id == current.id), 0);
      }
    }
    notifyListeners();
  }

  /// off → all → one → off
  void cycleRepeat() {
    _repeat = RepeatMode.values[(_repeat.index + 1) % RepeatMode.values.length];
    notifyListeners();
  }

  // ---- Internals --------------------------------------------------------------

  void _startPlayback() {
    position.value = Duration.zero;
    _isPlaying = true;
    _startTimer();
    notifyListeners();
  }

  void _pause() {
    _isPlaying = false;
    _timer?.cancel();
    _timer = null;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_tick, (_) {
      final song = currentSong;
      if (song == null) {
        _pause();
        return;
      }
      final nextPosition = position.value + _tick;
      if (nextPosition >= song.duration) {
        _onTrackEnded();
      } else {
        position.value = nextPosition;
      }
    });
  }

  /// Called when the fake progress reaches the end of the current song.
  void _onTrackEnded() {
    if (_repeat == RepeatMode.one) {
      position.value = Duration.zero; // loop the same song
    } else if (_index < _queue.length - 1) {
      _index++;
      _startPlayback();
    } else if (_repeat == RepeatMode.all) {
      _index = 0;
      _startPlayback();
    } else {
      // End of the queue with repeat off: stop and rewind.
      _pause();
      position.value = Duration.zero;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    position.dispose();
    super.dispose();
  }
}
