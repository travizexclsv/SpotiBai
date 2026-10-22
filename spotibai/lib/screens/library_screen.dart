import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../models/playlist.dart';
import '../providers/library_provider.dart';
import '../theme/app_colors.dart';
import '../utils/navigation.dart';
import 'search_screen.dart';
import '../widgets/cover_art.dart';
import '../widgets/media_card.dart';

/// Filter chips shown at the top of the library.
enum _LibraryFilter { playlists, artists, albums }

/// One row/cell of the library, built from a playlist, album or artist.
class _LibraryEntry {
  const _LibraryEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.collection,
    required this.filter,
    this.circular = false,
  });

  final String id;
  final String title;
  final String subtitle;

  /// What opens when tapped (artists are converted to a playlist of their songs).
  final Playlist collection;
  final _LibraryFilter filter;
  final bool circular;
}

/// Your Library tab: filter chips, a sort toggle and a list/grid switch.
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  static const Map<_LibraryFilter, String> _filterLabels = {
    _LibraryFilter.playlists: 'Playlists',
    _LibraryFilter.artists: 'Artists',
    _LibraryFilter.albums: 'Albums',
  };

  _LibraryFilter? _filter; // null = show everything
  bool _isGrid = false;
  bool _sortAlphabetical = false;

  /// Builds the visible entries: saved items only, filtered and sorted.
  List<_LibraryEntry> _buildEntries(LibraryProvider library) {
    final items = <_LibraryEntry>[];

    for (final p in MockData.playlists) {
      if (library.isSaved(p.id)) {
        items.add(_LibraryEntry(
          id: p.id,
          title: p.name,
          subtitle: 'Playlist • ${p.owner}',
          collection: p,
          filter: _LibraryFilter.playlists,
        ));
      }
    }
    for (final a in MockData.albums) {
      if (library.isSaved(a.id)) {
        items.add(_LibraryEntry(
          id: a.id,
          title: a.name,
          subtitle: 'Album • ${a.owner}',
          collection: a,
          filter: _LibraryFilter.albums,
        ));
      }
    }
    for (final artist in MockData.artists) {
      if (library.isSaved(artist.id)) {
        items.add(_LibraryEntry(
          id: artist.id,
          title: artist.name,
          subtitle: 'Artist',
          collection: MockData.artistPlaylist(artist),
          filter: _LibraryFilter.artists,
          circular: true,
        ));
      }
    }

    if (_filter != null) {
      items.removeWhere((e) => e.filter != _filter);
    }

    if (_sortAlphabetical) {
      items.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else {
      // "Recents": most recently saved first.
      final order = library.savedIds.toList().reversed.toList();
      items.sort((a, b) => order.indexOf(a.id).compareTo(order.indexOf(b.id)));
    }

    // "Liked Songs" is always pinned to the top (unless filtered out).
    if (_filter == null || _filter == _LibraryFilter.playlists) {
      final liked = library.likedPlaylist;
      items.insert(
        0,
        _LibraryEntry(
          id: LibraryProvider.likedId,
          title: liked.name,
          subtitle: 'Playlist • ${liked.songIds.length} songs',
          collection: liked,
          filter: _LibraryFilter.playlists,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final entries = _buildEntries(library);
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Header ----
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFE8115B),
                  child: Text(
                    'B',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your Library',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SearchScreen(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded, size: 30),
                  onPressed: () => ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Create playlist (mock)')),
                    ),
                ),
              ],
            ),
          ),

          // ---- Filter chips ----
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                for (final entry in _filterLabels.entries) ...[
                  _FilterChipButton(
                    label: entry.value,
                    selected: _filter == entry.key,
                    // Tapping the active chip clears the filter.
                    onTap: () => setState(
                      () => _filter = _filter == entry.key ? null : entry.key,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),

          // ---- Sort toggle + list/grid toggle ----
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () =>
                      setState(() => _sortAlphabetical = !_sortAlphabetical),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.swap_vert_rounded, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          _sortAlphabetical ? 'Alphabetical' : 'Recents',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: _isGrid ? 'Show as list' : 'Show as grid',
                  icon: Icon(
                    _isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded,
                    size: 22,
                  ),
                  onPressed: () => setState(() => _isGrid = !_isGrid),
                ),
              ],
            ),
          ),

          // ---- Content ----
          Expanded(
            child: entries.isEmpty
                ? const _EmptyLibrary()
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _isGrid
                        ? _buildGrid(entries)
                        : _buildList(entries),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<_LibraryEntry> entries) {
    return ListView.builder(
      key: const ValueKey('library-list'),
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final e = entries[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          leading: CoverArt(
            seed: e.collection.artSeed,
            color: e.collection.color,
            size: 56,
            radius: 4,
            circular: e.circular,
          ),
          title: Text(
            e.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            e.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          onTap: () => openCollection(context, e.collection),
        );
      },
    );
  }

  Widget _buildGrid(List<_LibraryEntry> entries) {
    return LayoutBuilder(
      key: const ValueKey('library-grid'),
      builder: (context, constraints) {
        const padding = 16.0;
        const gap = 12.0;
        final columns = constraints.maxWidth >= 600 ? 4 : 3;
        final cellWidth =
            (constraints.maxWidth - padding * 2 - gap * (columns - 1)) / columns;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(padding, 4, padding, 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: gap,
            mainAxisSpacing: gap,
            // Square art + title + one subtitle line (+ a little headroom).
            mainAxisExtent: cellWidth + 72,
          ),
          itemCount: entries.length,
          itemBuilder: (context, i) {
            final e = entries[i];
            return MediaCard(
              title: e.title,
              subtitle: e.subtitle,
              seed: e.collection.artSeed,
              color: e.collection.color,
              circular: e.circular,
              subtitleLines: 1,
              onTap: () => openCollection(context, e.collection),
            );
          },
        );
      },
    );
  }
}

/// Pill-shaped filter chip (green when selected).
class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.green,
      backgroundColor: AppColors.surfaceHigh,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      labelStyle: TextStyle(
        color: selected ? Colors.black : Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.library_music_outlined,
                size: 56, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Nothing here yet',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart on a playlist, album or artist to save it here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
