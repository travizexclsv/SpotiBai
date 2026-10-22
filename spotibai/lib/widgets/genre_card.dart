import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/genre.dart';
import '../models/song.dart';
import 'cover_art.dart';
import 'ripple_tap.dart';

/// Colourful "Browse all" card with a tilted cover peeking out of the corner.
class GenreCard extends StatelessWidget {
  const GenreCard({super.key, required this.genre, required this.onTap});

  final Genre genre;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(8);

    return ClipRRect(
      borderRadius: radius,
      child: RippleTap(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          color: genre.color,
          child: Stack(
            children: [
              Positioned(
                top: 12,
                left: 12,
                right: 48,
                child: Text(
                  genre.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Positioned(
                right: -12,
                bottom: -4,
                child: Transform.rotate(
                  angle: 25 * math.pi / 180,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x59000000),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CoverArt(
                      seed: seedFrom(genre.name),
                      color: genre.color,
                      size: 64,
                      radius: 6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
