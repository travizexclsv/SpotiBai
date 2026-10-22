import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../screens/now_playing_screen.dart';
import '../theme/app_colors.dart';
import '../utils/routes.dart';
import 'cover_art.dart';

/// The persistent mini player. Hidden until a song has been started; tapping
/// it opens the Now Playing screen with a slide-up transition.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;
    if (song == null) return const SizedBox.shrink();

    final library = context.read<LibraryProvider>();
    final isLiked = context.select<LibraryProvider, bool>(
      (l) => l.isLiked(song.id),
    );
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          // A dark shade of the album colour, like Spotify's mini player.
          color: Color.lerp(song.color, Colors.black, 0.55),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              slideUpRoute<void>(const NowPlayingScreen()),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 4, 6),
                  child: Row(
                    children: [
                      CoverArt(
                        seed: song.artSeed,
                        color: song.color,
                        size: 44,
                        radius: 4,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: isLiked ? 'Unlike' : 'Like',
                        icon: Icon(
                          isLiked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isLiked ? AppColors.green : Colors.white,
                        ),
                        onPressed: () => library.toggleLike(song.id),
                      ),
                      IconButton(
                        tooltip: player.isPlaying ? 'Pause' : 'Play',
                        icon: Icon(
                          player.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 30,
                        ),
                        onPressed: player.togglePlay,
                      ),
                    ],
                  ),
                ),
                // Thin progress line driven by the fake timer.
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
                  child: ValueListenableBuilder<Duration>(
                    valueListenable: player.position,
                    builder: (context, position, _) {
                      final total = song.duration.inMilliseconds;
                      final value = total == 0
                          ? 0.0
                          : (position.inMilliseconds / total)
                              .clamp(0.0, 1.0)
                              .toDouble();
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 2,
                          backgroundColor: Colors.white24,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
