import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import '../widgets/cover_art.dart';
import '../widgets/mini_player.dart';
import '../widgets/song_tile.dart';

/// Playlist / album / artist / genre page.
///
/// A pinned, collapsing header (gradient + cover art + info) is followed by a
/// row of actions (save, download, shuffle, play) and the song list.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    // "Liked Songs" is virtual – always read its latest state from the provider.
    final live = playlist.id == LibraryProvider.likedId
        ? context.watch<LibraryProvider>().likedPlaylist
        : playlist;
    final songs = MockData.songsFor(live);

    final topInset = MediaQuery.paddingOf(context).top;
    final width = MediaQuery.sizeOf(context).width;
    final coverSize = (width * 0.5).clamp(140.0, 230.0).toDouble();

    // Header geometry: toolbar + cover + info block (excluding the status bar).
    final expandedHeight = kToolbarHeight + coverSize + 124;
    final headerColor = Color.lerp(live.color, Colors.black, 0.4)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      // The mini player stays visible on detail pages too.
      bottomNavigationBar: const SafeArea(top: false, child: MiniPlayer()),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: expandedHeight,
            backgroundColor: headerColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                // t = 1 when fully expanded, 0 when collapsed to the toolbar.
                final maxHeight = expandedHeight + topInset;
                final minHeight = kToolbarHeight + topInset;
                final t = ((constraints.maxHeight - minHeight) /
                        (maxHeight - minHeight))
                    .clamp(0.0, 1.0)
                    .toDouble();

                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        headerColor,
                        // Fades into the page background as it expands and
                        // stays solid when collapsed.
                        Color.lerp(headerColor, AppColors.background, t)!,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Title appears in the toolbar once collapsed.
                      Positioned(
                        top: topInset,
                        left: 56,
                        right: 56,
                        height: kToolbarHeight,
                        child: Opacity(
                          opacity: ((0.3 - t) / 0.3).clamp(0.0, 1.0).toDouble(),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              live.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                      // Cover art (fades and shrinks while collapsing).
                      Positioned(
                        top: topInset + kToolbarHeight - 12,
                        left: 0,
                        right: 0,
                        child: Opacity(
                          opacity: t,
                          child: Transform.scale(
                            scale: 0.8 + 0.2 * t,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x73000000),
                                      blurRadius: 24,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: CoverArt(
                                  seed: live.artSeed,
                                  color: live.color,
                                  size: coverSize,
                                  radius: 6,
                                  circular: live.kind == CollectionKind.artist,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Title, description and meta line.
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 12,
                        child: Opacity(
                          opacity: t * t,
                          child: _HeaderInfo(playlist: live, songs: songs),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: _ActionRow(playlist: live, songs: songs)),

          if (songs.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(isLiked: live.id == LibraryProvider.likedId),
            )
          else
            SliverList.builder(
              itemCount: songs.length,
              itemBuilder: (context, i) {
                final song = songs[i];
                return SongTile(
                  song: song,
                  // Play from this song, with the whole list as the queue.
                  onTap: () => context.read<PlayerProvider>().playQueue(
                        songs,
                        startIndex: i,
                        collectionId: live.id,
                        collectionName: live.name,
                      ),
                );
              },
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

/// Title, description and "owner • N songs • length" shown in the header.
class _HeaderInfo extends StatelessWidget {
  const _HeaderInfo({required this.playlist, required this.songs});

  final Playlist playlist;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalSeconds = songs.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    final meta = songs.isEmpty
        ? '${playlist.typeLabel} • ${playlist.owner}'
        : '${playlist.owner} • ${songs.length} songs • ${formatTotalLength(totalSeconds)}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playlist.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          playlist.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.graphic_eq_rounded,
                size: 18, color: AppColors.green),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                meta,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Heart (save), download, more, shuffle and the big green play button.
class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.playlist, required this.songs});

  final Playlist playlist;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final player = context.watch<PlayerProvider>();

    final isCurrentCollection = player.collectionId == playlist.id;
    final isPlaying = isCurrentCollection && player.isPlaying;
    final isSaved = library.isSaved(playlist.id);
    final isDownloaded = library.isDownloaded(playlist.id);
    final canSave = playlist.kind != CollectionKind.genre &&
        playlist.id != LibraryProvider.likedId;
    final hasSongs = songs.isNotEmpty;

    void toast(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ));
    }

    void onPlayPressed() {
      if (!hasSongs) return;
      if (isCurrentCollection) {
        player.togglePlay(); // already the active list: just play/pause
      } else {
        player.playQueue(
          songs,
          collectionId: playlist.id,
          collectionName: playlist.name,
        );
      }
    }

    void onShufflePressed() {
      if (!hasSongs) return;
      if (isCurrentCollection) {
        player.toggleShuffle();
      } else {
        player.playQueue(
          songs,
          collectionId: playlist.id,
          collectionName: playlist.name,
          shuffle: true,
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Row(
        children: [
          if (canSave)
            IconButton(
              tooltip: isSaved ? 'Remove from Your Library' : 'Save to Your Library',
              icon: Icon(
                isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isSaved ? AppColors.green : AppColors.textSecondary,
              ),
              onPressed: () {
                library.toggleSaved(playlist.id);
                toast(isSaved
                    ? 'Removed from Your Library'
                    : 'Added to Your Library');
              },
            ),
          if (hasSongs)
            IconButton(
              tooltip: isDownloaded ? 'Remove download' : 'Download',
              icon: Icon(
                isDownloaded
                    ? Icons.download_for_offline_rounded
                    : Icons.download_for_offline_outlined,
                color: isDownloaded ? AppColors.green : AppColors.textSecondary,
              ),
              onPressed: () {
                library.toggleDownload(playlist.id);
                toast(isDownloaded ? 'Download removed' : 'Downloaded (mock)');
              },
            ),
          IconButton(
            tooltip: 'More',
            icon: const Icon(Icons.more_vert_rounded),
            color: AppColors.textSecondary,
            onPressed: () => toast('More options are not available in this demo.'),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Shuffle',
            iconSize: 28,
            icon: Icon(
              Icons.shuffle_rounded,
              color: (isCurrentCollection && player.shuffle)
                  ? AppColors.green
                  : Colors.white,
            ),
            onPressed: hasSongs ? onShufflePressed : null,
          ),
          const SizedBox(width: 4),
          Material(
            color: hasSongs ? AppColors.green : AppColors.surfaceHigh,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: hasSongs ? onPlayPressed : null,
              child: SizedBox(
                width: 56,
                height: 56,
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 34,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isLiked});

  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_off_rounded,
              size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(
            isLiked ? 'Songs you like will appear here' : 'No songs yet',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            isLiked
                ? 'Tap the heart on any song to save it.'
                : 'Check back soon for new music.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
