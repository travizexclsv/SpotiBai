import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/player_provider.dart';
import '../theme/app_colors.dart';
import 'cover_art.dart';

/// Bottom sheet that lists the current queue. Tap a row to jump to it.
Future<void> showQueueSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _QueueSheet(),
  );
}

class _QueueSheet extends StatelessWidget {
  const _QueueSheet();

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final queue = player.queue;
    final theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Queue',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                if (player.collectionName != null)
                  Text(
                    'Playing from ${player.collectionName}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: queue.length,
              itemBuilder: (context, i) {
                final song = queue[i];
                final isCurrent = i == player.currentIndex;
                return ListTile(
                  leading: CoverArt(
                    seed: song.artSeed,
                    color: song.color,
                    size: 44,
                    radius: 4,
                  ),
                  title: Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isCurrent ? AppColors.green : Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: isCurrent
                      ? const Icon(Icons.equalizer_rounded,
                          color: AppColors.green)
                      : null,
                  onTap: () => player.jumpTo(i),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
