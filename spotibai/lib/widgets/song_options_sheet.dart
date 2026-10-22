import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_colors.dart';
import 'cover_art.dart';

/// Bottom sheet opened by a song's 3-dot menu: like, add to queue, share.
Future<void> showSongOptions(BuildContext context, Song song) {
  final library = context.read<LibraryProvider>();
  final player = context.read<PlayerProvider>();
  final messenger = ScaffoldMessenger.of(context);

  void toast(String message) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ));
  }

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final liked = library.isLiked(song.id);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CoverArt(
                seed: song.artSeed,
                color: song.color,
                size: 48,
                radius: 4,
              ),
              title: Text(
                song.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                song.artist,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const Divider(height: 8),
            ListTile(
              leading: Icon(
                liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: liked ? AppColors.green : Colors.white,
              ),
              title: Text(liked ? 'Remove from Liked Songs' : 'Add to Liked Songs'),
              onTap: () {
                library.toggleLike(song.id);
                Navigator.pop(sheetContext);
                toast(liked ? 'Removed from Liked Songs' : 'Added to Liked Songs');
              },
            ),
            ListTile(
              leading: const Icon(Icons.queue_music_rounded),
              title: const Text('Add to queue'),
              onTap: () {
                player.addToQueue(song);
                Navigator.pop(sheetContext);
                toast('Added to queue');
              },
            ),
            ListTile(
              leading: const Icon(Icons.ios_share_rounded),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(sheetContext);
                toast('Link copied (mock)');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
