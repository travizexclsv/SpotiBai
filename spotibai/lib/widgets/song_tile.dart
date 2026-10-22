import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_colors.dart';
import 'cover_art.dart';
import 'song_options_sheet.dart';

/// A song row: cover, title, artist and a 3-dot menu.
///
/// The title turns green (with an equalizer icon while playing) when this song
/// is the current one, and a small heart shows when it is liked. It uses
/// `select` so only the rows whose state changed are rebuilt.
class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
  });

  final Song song;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCurrent = context.select<PlayerProvider, bool>(
      (p) => p.currentSong?.id == song.id,
    );
    final isPlaying = context.select<PlayerProvider, bool>(
      (p) => p.currentSong?.id == song.id && p.isPlaying,
    );
    final isLiked = context.select<LibraryProvider, bool>(
      (l) => l.isLiked(song.id),
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            CoverArt(
              seed: song.artSeed,
              color: song.color,
              size: 48,
              radius: 4,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isCurrent ? AppColors.green : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (isLiked)
                        const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 14,
                            color: AppColors.green,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          song.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isPlaying)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.equalizer_rounded,
                    size: 20, color: AppColors.green),
              ),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              color: AppColors.textSecondary,
              tooltip: 'More options',
              onPressed: () => showSongOptions(context, song),
            ),
          ],
        ),
      ),
    );
  }
}
