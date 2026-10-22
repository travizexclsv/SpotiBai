import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../models/playlist.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import '../utils/navigation.dart';
import '../widgets/horizontal_section.dart';
import '../widgets/media_card.dart';
import '../widgets/playlist_card.dart';
import '../widgets/quick_access_tile.dart';

/// Home tab: time-based greeting, quick-access grid and horizontal sections.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final player = context.read<PlayerProvider>();
    final theme = Theme.of(context);

    // Card width scales with the screen so it works on small and large phones.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = (screenWidth * 0.38).clamp(120.0, 190.0).toDouble();

    // "Liked Songs" first, then the first five playlists = 6 quick tiles.
    final quickTiles = <Playlist>[
      library.likedPlaylist,
      ...MockData.playlists.take(5),
    ];
    final trending = MockData.trending;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E4D3A), AppColors.background],
          stops: [0, 0.35],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ---- Greeting + top icons ----
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        greetingForNow(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Notifications',
                      icon: const Icon(Icons.notifications_none_rounded),
                      onPressed: () => ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                          content: Text('No new notifications.'),
                        )),
                    ),
                    IconButton(
                      tooltip: 'Listening history',
                      icon: const Icon(Icons.history_rounded),
                      onPressed: () => ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                          content: Text('Listening history is not available in this demo.'),
                        )),
                    ),
                    IconButton(
                      tooltip: 'Settings',
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () => ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                          content: Text('Settings are not available in this demo.'),
                        )),
                    ),
                  ],
                ),
              ),
            ),

            // ---- 2-column quick-access grid ----
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 56,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => QuickAccessTile(
                    playlist: quickTiles[i],
                    onTap: () => openCollection(context, quickTiles[i]),
                  ),
                  childCount: quickTiles.length,
                ),
              ),
            ),

            // ---- Horizontal sections ----
            SliverToBoxAdapter(
              child: HorizontalSection(
                title: 'Recently played',
                children: [
                  for (final p in MockData.recentlyPlayed)
                    PlaylistCard(
                      playlist: p,
                      width: cardWidth,
                      onTap: () => openCollection(context, p),
                    ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: HorizontalSection(
                title: 'Made for you',
                children: [
                  for (final p in MockData.madeForYou)
                    PlaylistCard(
                      playlist: p,
                      width: cardWidth,
                      onTap: () => openCollection(context, p),
                    ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: HorizontalSection(
                title: 'Popular albums',
                children: [
                  for (final a in MockData.albums)
                    PlaylistCard(
                      playlist: a,
                      width: cardWidth,
                      onTap: () => openCollection(context, a),
                    ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: HorizontalSection(
                title: 'Trending now',
                children: [
                  for (final song in trending)
                    MediaCard(
                      title: song.title,
                      subtitle: song.artist,
                      seed: song.artSeed,
                      color: song.color,
                      width: cardWidth,
                      // Tapping a song plays it inside the trending queue.
                      onTap: () => player.playSong(
                        song,
                        queue: trending,
                        collectionId: 'trending',
                        collectionName: 'Trending now',
                      ),
                    ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
