import 'package:flutter/material.dart';

import 'song.dart';

/// What kind of collection a [Playlist] object represents.
enum CollectionKind { playlist, album, artist, genre }

/// A playlist, album, artist page or genre page – they all share the same
/// shape (a title, a colour and a list of songs), so one model is enough and
/// one detail screen can display all of them.
class Playlist {
  const Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.owner,
    required this.color,
    required this.songIds,
    this.kind = CollectionKind.playlist,
  });

  final String id;
  final String name;
  final String description;
  final String owner;
  final Color color;
  final List<String> songIds;
  final CollectionKind kind;

  /// Albums use the same seed as their songs so the artwork matches.
  String get artSeed => kind == CollectionKind.album ? seedFrom(name) : id;

  String get typeLabel => switch (kind) {
        CollectionKind.playlist => 'Playlist',
        CollectionKind.album => 'Album',
        CollectionKind.artist => 'Artist',
        CollectionKind.genre => 'Genre',
      };
}
