import 'package:flutter/material.dart';

/// Wraps [child] with a ripple that is drawn *on top* of it, so the touch
/// feedback stays visible even over opaque artwork.
///
/// Don't use this around children that have their own buttons (the overlay
/// would swallow their taps) – use a plain InkWell for those.
class RippleTap extends StatelessWidget {
  const RippleTap({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
