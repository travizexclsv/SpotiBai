import 'package:flutter/material.dart';

import 'section_header.dart';

/// A titled, horizontally scrolling row of cards. Its height follows its
/// children, so it never overflows with large text sizes.
class HorizontalSection extends StatelessWidget {
  const HorizontalSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final child in children)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: child,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
