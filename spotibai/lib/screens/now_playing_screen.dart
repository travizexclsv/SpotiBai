import 'dart:math' as math;

import 'package:flutter/material.dart' hide RepeatMode;
import 'package:provider/provider.dart';

import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/cover_art.dart';
import '../widgets/queue_sheet.dart';
import '../widgets/seek_bar.dart';
import '../widgets/song_options_sheet.dart';

/// Full-screen player. Opens from the mini player with a slide-up transition;
/// close it with the chevron or by swiping down.
class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;

    // Nothing is playing (should not happen): just show an empty page.
    if (song == null) return const Scaffold();

    final library = context.read<LibraryProvider>();
    final isLiked = context.select<LibraryProvider, bool>(
      (l) => l.isLiked(song.id),
    );
    final theme = Theme.of(context);

    return Scaffold(
      body: GestureDetector(
        // Swipe down to dismiss.
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 500) {
            Navigator.of(context).maybePop();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            // Gradient built from the album colour; animates between songs.
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.lerp(song.color, Colors.black, 0.2)!,
                Color.lerp(song.color, Colors.black, 0.8)!,
                AppColors.background,
              ],
              stops: const [0, 0.65, 1],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // ---- Top bar ----
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Close',
                        iconSize: 32,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'PLAYING FROM',
                              style: theme.textTheme.labelSmall?.copyWith(
                                letterSpacing: 1.2,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              player.collectionName ?? song.album,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'More',
                        icon: const Icon(Icons.more_vert_rounded),
                        onPressed: () => showSongOptions(context, song),
                      ),
                    ],
                  ),

                  // ---- Artwork (takes whatever height is left) ----
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final size = math.min(
                            math.min(constraints.maxWidth, constraints.maxHeight),
                            420.0,
                          );
                          return Center(
                            // Art shrinks slightly while paused, like Spotify.
                            child: AnimatedScale(
                              scale: player.isPlaying ? 1.0 : 0.9,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                child: Container(
                                  key: ValueKey(song.id),
                                  width: size,
                                  height: size,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.45),
                                        blurRadius: 30,
                                        offset: const Offset(0, 16),
                                      ),
                                    ],
                                  ),
                                  child: CoverArt(
                                    seed: song.artSeed,
                                    color: song.color,
                                    size: size,
                                    radius: 8,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ---- Title / artist / heart ----
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: isLiked ? 'Unlike' : 'Like',
                        iconSize: 28,
                        icon: Icon(
                          isLiked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isLiked ? AppColors.green : Colors.white,
                        ),
                        onPressed: () => library.toggleLike(song.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // ---- Seek bar + timestamps ----
                  const SeekBar(),
                  const SizedBox(height: 4),

                  // ---- Transport controls ----
                  _Controls(player: player),
                  const SizedBox(height: 8),

                  // ---- Bottom row: devices / queue ----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        tooltip: 'Devices',
                        icon: const Icon(Icons.devices_other_rounded),
                        color: Colors.white70,
                        onPressed: () => ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                            content: Text('No other playback devices are available.'),
                          )),
                      ),
                      IconButton(
                        tooltip: 'Queue',
                        icon: const Icon(Icons.queue_music_rounded),
                        color: Colors.white70,
                        onPressed: () => showQueueSheet(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shuffle, previous, play/pause, next and repeat.
class _Controls extends StatelessWidget {
  const _Controls({required this.player});

  final PlayerProvider player;

  @override
  Widget build(BuildContext context) {
    final repeatActive = player.repeat != RepeatMode.off;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: 'Shuffle',
          iconSize: 26,
          icon: const Icon(Icons.shuffle_rounded),
          color: player.shuffle ? AppColors.green : Colors.white,
          onPressed: player.toggleShuffle,
        ),
        IconButton(
          tooltip: 'Previous',
          iconSize: 42,
          icon: const Icon(Icons.skip_previous_rounded),
          onPressed: player.previous,
        ),
        // Big white play / pause button.
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: player.togglePlay,
            child: SizedBox(
              width: 68,
              height: 68,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  player.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  key: ValueKey(player.isPlaying),
                  size: 42,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: 'Next',
          iconSize: 42,
          icon: const Icon(Icons.skip_next_rounded),
          onPressed: player.next,
        ),
        IconButton(
          tooltip: switch (player.repeat) {
            RepeatMode.off => 'Repeat off',
            RepeatMode.all => 'Repeat all',
            RepeatMode.one => 'Repeat one',
          },
          iconSize: 26,
          icon: Icon(
            player.repeat == RepeatMode.one
                ? Icons.repeat_one_rounded
                : Icons.repeat_rounded,
          ),
          color: repeatActive ? AppColors.green : Colors.white,
          onPressed: player.cycleRepeat,
        ),
      ],
    );
  }
}
