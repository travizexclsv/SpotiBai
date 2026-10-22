import 'package:flutter/material.dart';

/// A "Browse all" card on the Search screen. [name] is also the tag that is
/// matched against `Song.tags`.
class Genre {
  const Genre({required this.name, required this.color});

  final String name;
  final Color color;
}
