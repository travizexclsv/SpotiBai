import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/app_config.dart';

/// Rounded album / playlist artwork.
///
/// A generated gradient in the item's colour is always painted first. When
/// [AppConfig.useNetworkImages] is on, a photo is faded in on top (cached by
/// cached_network_image) and tinted with [color]. If the network is
/// unavailable the gradient simply stays – no broken images, ever.
///
/// Pass [size] for a fixed square, or leave it null to fill the available
/// width as a 1:1 square.
class CoverArt extends StatelessWidget {
  const CoverArt({
    super.key,
    required this.seed,
    required this.color,
    this.size,
    this.radius = 6,
    this.circular = false,
    this.icon = Icons.music_note_rounded,
  });

  final String seed;
  final Color color;
  final double? size;
  final double radius;
  final bool circular;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        circular ? BorderRadius.circular(999) : BorderRadius.circular(radius);

    final art = ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _GradientCover(color: color, icon: icon),
          if (AppConfig.useNetworkImages)
            CachedNetworkImage(
              imageUrl: 'https://picsum.photos/seed/$seed/400',
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 300),
              placeholder: (context, url) => const SizedBox.shrink(),
              errorWidget: (context, url, error) => const SizedBox.shrink(),
              // Tint the photo with the album colour so it matches gradients.
              imageBuilder: (context, imageProvider) => Stack(
                fit: StackFit.expand,
                children: [
                  Image(image: imageProvider, fit: BoxFit.cover),
                  ColoredBox(color: color.withValues(alpha: 0.55)),
                ],
              ),
            ),
        ],
      ),
    );

    if (size != null) return SizedBox(width: size, height: size, child: art);
    return AspectRatio(aspectRatio: 1, child: art);
  }
}

/// The always-available fallback cover: diagonal gradient + music note.
class _GradientCover extends StatelessWidget {
  const _GradientCover({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(color, Colors.white, 0.15)!,
            Color.lerp(color, Colors.black, 0.35)!,
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final iconSize = constraints.biggest.shortestSide * 0.4;
          return Center(
            child: Icon(
              icon,
              size: iconSize.isFinite ? iconSize : 24,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          );
        },
      ),
    );
  }
}
