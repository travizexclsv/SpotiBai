import 'package:flutter/material.dart';

import '../models/playlist.dart';
import 'media_card.dart';

/// Card for a playlist or album, used in the horizontal Home sections.
class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
    this.width = 150,
  });

  final Playlist playlist;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final isAlbum = playlist.kind == CollectionKind.album;
    return MediaCard(
      title: playlist.name,
      subtitle: isAlbum ? 'Album • ${playlist.owner}' : playlist.description,
      seed: playlist.artSeed,
      color: playlist.color,
      width: width,
      onTap: onTap,
    );
  }
}
