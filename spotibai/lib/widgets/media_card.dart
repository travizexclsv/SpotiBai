import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'cover_art.dart';
import 'ripple_tap.dart';

/// Generic "artwork + title + subtitle" card. Used by [PlaylistCard], the
/// trending songs row and the Library grid.
///
/// Give it a [width] inside horizontal lists, or leave it null inside grids
/// so it fills its cell.
class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.seed,
    required this.color,
    required this.onTap,
    this.width,
    this.circular = false,
    this.subtitleLines = 2,
  });

  final String title;
  final String subtitle;
  final String seed;
  final Color color;
  final VoidCallback onTap;
  final double? width;
  final bool circular;
  final int subtitleLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final align = circular ? TextAlign.center : TextAlign.start;

    return SizedBox(
      width: width,
      child: RippleTap(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                circular ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              CoverArt(seed: seed, color: color, circular: circular),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: align,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: subtitleLines,
                overflow: TextOverflow.ellipsis,
                textAlign: align,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
