import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';
import '../theme/app_colors.dart';
import '../utils/navigation.dart';
import '../widgets/genre_card.dart';
import '../widgets/section_header.dart';
import '../widgets/song_tile.dart';

/// Search tab: a search bar, "Browse all" genre grid, and live song results.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSearching = _query.trim().isNotEmpty;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Search',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SearchField(
              controller: _controller,
              showClear: _query.isNotEmpty,
              onChanged: (value) => setState(() => _query = value),
              onClear: _clear,
            ),
          ),
          Expanded(
            child: isSearching ? _buildResults(context) : _buildBrowseAll(context),
          ),
        ],
      ),
    );
  }

  /// Genre cards shown while the search box is empty.
  Widget _buildBrowseAll(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Browse all'),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.7,
            ),
            itemCount: MockData.genres.length,
            itemBuilder: (context, i) {
              final genre = MockData.genres[i];
              return GenreCard(
                genre: genre,
                onTap: () =>
                    openCollection(context, MockData.genrePlaylist(genre)),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Live-filtered song list shown while typing.
  Widget _buildResults(BuildContext context) {
    final theme = Theme.of(context);
    final results = MockData.search(_query);

    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_rounded,
                  size: 56, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text(
                'No results found for "${_query.trim()}"',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Try a different song, artist, album or genre.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final player = context.read<PlayerProvider>();
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: results.length,
      itemBuilder: (context, i) {
        final Song song = results[i];
        return SongTile(
          song: song,
          // Play the tapped song inside the current result list.
          onTap: () => player.playSong(
            song,
            queue: results,
            collectionId: 'search',
            collectionName: 'Search results',
          ),
        );
      },
    );
  }
}

/// White, rounded Spotify-style search input.
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.showClear,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool showClear;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'What do you want to listen to?',
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        prefixIcon: const Icon(Icons.search_rounded, color: Colors.black87),
        suffixIcon: showClear
            ? IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.black87),
                onPressed: onClear,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
