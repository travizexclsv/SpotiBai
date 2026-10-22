import 'package:flutter/material.dart';

/// Turns any text into a stable, URL-safe seed for cover-art images.
String seedFrom(String text) =>
    text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

/// A single track in the mock catalogue.
@immutable
class Song {
  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.durationSeconds,
    required this.color,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String artist;
  final String album;
  final int durationSeconds;

  /// Dominant "album colour" – drives gradients on the player and mini player.
  final Color color;

  /// Genre / mood tags used by the Search screen's genre cards.
  final List<String> tags;

  Duration get duration => Duration(seconds: durationSeconds);

  /// Songs from the same album share the same cover art seed.
  String get artSeed => seedFrom(album);

  @override
  bool operator ==(Object other) => other is Song && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
