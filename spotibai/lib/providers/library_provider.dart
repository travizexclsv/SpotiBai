import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/playlist.dart';
import '../models/song.dart';

/// Holds everything the user "owns": liked songs, saved library items and
/// downloads. All state is in memory (UI-only prototype).
class LibraryProvider extends ChangeNotifier {
  /// Id of the virtual "Liked Songs" playlist.
  static const String likedId = 'liked';

  // Sets keep insertion order, which we use for "newest first" sorting.
  final Set<String> _likedIds = {'s01', 's04', 's09', 's17', 's20'};
  late final Set<String> _savedIds = _initialSavedIds();
  final Set<String> _downloadedIds = {};

  /// Starts with every mock playlist, album and artist saved, interleaved so
  /// the "Recents" order looks natural.
  Set<String> _initialSavedIds() {
    final lists = <List<String>>[
      MockData.playlists.map((p) => p.id).toList(),
      MockData.artists.map((a) => a.id).toList(),
      MockData.albums.map((a) => a.id).toList(),
    ];
    final ordered = <String>{};
    var i = 0;
    var added = true;
    while (added) {
      added = false;
      for (final list in lists) {
        if (i < list.length) {
          ordered.add(list[i]);
          added = true;
        }
      }
      i++;
    }
    return ordered;
  }

  // ---- Liked songs ---------------------------------------------------------

  bool isLiked(String songId) => _likedIds.contains(songId);

  void toggleLike(String songId) {
    if (!_likedIds.remove(songId)) _likedIds.add(songId);
    notifyListeners();
  }

  /// Liked songs, most recently liked first.
  List<Song> get likedSongs => [
        for (final id in _likedIds.toList().reversed)
          if (MockData.songById(id) case final song?) song,
      ];

  /// The virtual "Liked Songs" playlist, rebuilt from the current likes.
  Playlist get likedPlaylist => Playlist(
        id: likedId,
        name: 'Liked Songs',
        description: 'Songs you love, all in one place.',
        owner: 'You',
        color: const Color(0xFF4C3FB8),
        songIds: likedSongs.map((s) => s.id).toList(),
      );

  // ---- Saved playlists / albums / artists -----------------------------------

  bool isSaved(String collectionId) => _savedIds.contains(collectionId);

  /// Saved ids in the order they were saved (newest last).
  Iterable<String> get savedIds => _savedIds;

  void toggleSaved(String collectionId) {
    if (!_savedIds.remove(collectionId)) _savedIds.add(collectionId);
    notifyListeners();
  }

  // ---- Downloads -------------------------------------------------------------

  bool isDownloaded(String collectionId) =>
      _downloadedIds.contains(collectionId);

  void toggleDownload(String collectionId) {
    if (!_downloadedIds.remove(collectionId)) _downloadedIds.add(collectionId);
    notifyListeners();
  }
}
