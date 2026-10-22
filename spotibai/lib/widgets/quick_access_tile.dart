import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../theme/app_colors.dart';
import 'cover_art.dart';
import 'ripple_tap.dart';

/// Compact tile for the 2-column quick-access grid on Home.
/// Expects a tight height of 56 from its parent grid.
class QuickAccessTile extends StatelessWidget {
  const QuickAccessTile({
    super.key,
    required this.playlist,
    required this.onTap,
  });

  final Playlist playlist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(6);

    return RippleTap(
      borderRadius: radius,
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: radius,
        ),
        child: Row(
          children: [
            CoverArt(
              seed: playlist.artSeed,
              color: playlist.color,
              size: 56,
              radius: 0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                playlist.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
