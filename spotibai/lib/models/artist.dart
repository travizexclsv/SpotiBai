import 'package:flutter/material.dart';

/// A music artist shown in the Your Library screen.
class Artist {
  const Artist({
    required this.id,
    required this.name,
    required this.color,
    required this.monthlyListeners,
  });

  final String id;
  final String name;
  final Color color;

  /// Pre-formatted mock number, e.g. "5.2M".
  final String monthlyListeners;
}
