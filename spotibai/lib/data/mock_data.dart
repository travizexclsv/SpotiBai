import 'package:flutter/material.dart';

import '../models/artist.dart';
import '../models/genre.dart';
import '../models/playlist.dart';
import '../models/song.dart';

/// All mock content for the prototype: 33 songs, 8 playlists, 4 albums,
/// 8 artists and 10 genres – a mix of OPM / Filipino and international acts.
class MockData {
  MockData._();

  // ---------------------------------------------------------------------------
  // SONGS
  // ---------------------------------------------------------------------------
  static const List<Song> songs = [
    // ---- OPM / Filipino ----
    Song(id: 's01', title: 'Kathang Isip', artist: 'Ben&Ben', album: 'Limasawa Street', durationSeconds: 255, color: Color(0xFFC0562F), tags: ['OPM', 'Chill', 'Love']),
    Song(id: 's02', title: 'Leaves', artist: 'Ben&Ben', album: 'Limasawa Street', durationSeconds: 270, color: Color(0xFFC0562F), tags: ['OPM', 'Chill']),
    Song(id: 's03', title: 'Araw-Araw', artist: 'Ben&Ben', album: 'Limasawa Street', durationSeconds: 265, color: Color(0xFFC0562F), tags: ['OPM', 'Love']),
    Song(id: 's04', title: 'Paubaya', artist: 'Moira Dela Torre', album: 'Malaya', durationSeconds: 280, color: Color(0xFF2E6F8E), tags: ['OPM', 'Love', 'Chill']),
    Song(id: 's05', title: 'Malaya', artist: 'Moira Dela Torre', album: 'Malaya', durationSeconds: 248, color: Color(0xFF2E6F8E), tags: ['OPM', 'Pop']),
    Song(id: 's06', title: 'Tagpuan', artist: 'Moira Dela Torre', album: 'Malaya', durationSeconds: 270, color: Color(0xFF2E6F8E), tags: ['OPM', 'Love']),
    Song(id: 's07', title: 'Ang Huling El Bimbo', artist: 'Eraserheads', album: 'Sticker Happy', durationSeconds: 450, color: Color(0xFF6B7F3A), tags: ['OPM', 'Rock']),
    Song(id: 's08', title: 'Pare Ko', artist: 'Eraserheads', album: 'Circus', durationSeconds: 225, color: Color(0xFF8F3B4A), tags: ['OPM', 'Rock']),
    Song(id: 's09', title: 'Tadhana', artist: 'Up Dharma Down', album: 'Capacities', durationSeconds: 295, color: Color(0xFF3B4A6B), tags: ['OPM', 'Indie', 'Chill', 'Focus']),
    Song(id: 's10', title: 'Sa Ngalan ng Pag-ibig', artist: 'December Avenue', album: 'Langit na Naman', durationSeconds: 250, color: Color(0xFF7A3E9D), tags: ['OPM', 'Rock', 'Love']),
    Song(id: 's11', title: 'Mundo', artist: 'IV of Spades', album: 'CLAPCLAPCLAP!', durationSeconds: 225, color: Color(0xFFD9A441), tags: ['OPM', 'Indie', 'Pop']),
    Song(id: 's12', title: 'Yugto', artist: 'Rico Blanco', album: 'Your Universe', durationSeconds: 255, color: Color(0xFF2E8B57), tags: ['OPM', 'Rock']),
    Song(id: 's13', title: 'Tingin', artist: 'Cup of Joe', album: 'Silakbo', durationSeconds: 245, color: Color(0xFFCF4F7A), tags: ['OPM', 'Pop', 'Love']),
    Song(id: 's14', title: 'Tala', artist: 'Sarah Geronimo', album: 'Tala', durationSeconds: 230, color: Color(0xFFE0654F), tags: ['OPM', 'Pop', 'Party']),
    Song(id: 's15', title: 'Gento', artist: 'SB19', album: 'Pagsibol', durationSeconds: 210, color: Color(0xFF7B2FD6), tags: ['OPM', 'Pop', 'Workout', 'Party']),
    Song(id: 's16', title: 'Give Me Your Forever', artist: 'Zack Tabudlo', album: 'Episode', durationSeconds: 225, color: Color(0xFF3E7CB1), tags: ['OPM', 'Love', 'Chill']),

    // ---- International ----
    Song(id: 's17', title: 'Blinding Lights', artist: 'The Weeknd', album: 'After Hours', durationSeconds: 200, color: Color(0xFFB3202A), tags: ['Pop', 'Party', 'Workout']),
    Song(id: 's18', title: 'Save Your Tears', artist: 'The Weeknd', album: 'After Hours', durationSeconds: 215, color: Color(0xFFB3202A), tags: ['Pop', 'Chill', 'Focus']),
    Song(id: 's19', title: 'Levitating', artist: 'Dua Lipa', album: 'Future Nostalgia', durationSeconds: 203, color: Color(0xFFB04DB3), tags: ['Pop', 'Party', 'Workout']),
    Song(id: 's20', title: 'Anti-Hero', artist: 'Taylor Swift', album: 'Midnights', durationSeconds: 200, color: Color(0xFF2C3E70), tags: ['Pop', 'Indie']),
    Song(id: 's21', title: 'Lavender Haze', artist: 'Taylor Swift', album: 'Midnights', durationSeconds: 202, color: Color(0xFF2C3E70), tags: ['Pop', 'Chill', 'Focus']),
    Song(id: 's22', title: 'Karma', artist: 'Taylor Swift', album: 'Midnights', durationSeconds: 204, color: Color(0xFF2C3E70), tags: ['Pop', 'Party']),
    Song(id: 's23', title: 'Shape of You', artist: 'Ed Sheeran', album: 'Divide', durationSeconds: 234, color: Color(0xFFE06C2C), tags: ['Pop', 'Party']),
    Song(id: 's24', title: 'bad guy', artist: 'Billie Eilish', album: 'When We All Fall Asleep, Where Do We Go?', durationSeconds: 194, color: Color(0xFF6E8B1F), tags: ['Pop', 'Indie', 'Chill']),
    Song(id: 's25', title: 'Locked Out of Heaven', artist: 'Bruno Mars', album: 'Unorthodox Jukebox', durationSeconds: 233, color: Color(0xFF2F9E9E), tags: ['Pop', 'Party']),
    Song(id: 's26', title: "God's Plan", artist: 'Drake', album: 'Scorpion', durationSeconds: 198, color: Color(0xFF8A7A2C), tags: ['Hip-Hop', 'Workout']),
    Song(id: 's27', title: 'HUMBLE.', artist: 'Kendrick Lamar', album: 'DAMN.', durationSeconds: 177, color: Color(0xFFB82B2B), tags: ['Hip-Hop', 'Workout']),
    Song(id: 's28', title: 'Yellow', artist: 'Coldplay', album: 'Parachutes', durationSeconds: 269, color: Color(0xFFD6B21D), tags: ['Rock', 'Chill', 'Indie', 'Focus']),
    Song(id: 's29', title: 'Believer', artist: 'Imagine Dragons', album: 'Evolve', durationSeconds: 204, color: Color(0xFF2F8F83), tags: ['Rock', 'Workout']),
    Song(id: 's30', title: 'Circles', artist: 'Post Malone', album: "Hollywood's Bleeding", durationSeconds: 215, color: Color(0xFF7B4B9E), tags: ['Hip-Hop', 'Chill', 'Pop']),
    Song(id: 's31', title: 'As It Was', artist: 'Harry Styles', album: "Harry's House", durationSeconds: 167, color: Color(0xFFD66F8C), tags: ['Pop', 'Indie']),
    Song(id: 's32', title: 'drivers license', artist: 'Olivia Rodrigo', album: 'SOUR', durationSeconds: 242, color: Color(0xFF6F4A9E), tags: ['Pop', 'Love', 'Chill']),
    Song(id: 's33', title: 'Paris in the Rain', artist: 'Lauv', album: 'I met you when I was 18.', durationSeconds: 197, color: Color(0xFF4A8FB8), tags: ['Chill', 'Pop', 'Love', 'Focus']),
  ];

  static final Map<String, Song> _songById = {
    for (final s in songs) s.id: s,
  };

  static Song? songById(String id) => _songById[id];

  /// Resolves a collection's `songIds` into real [Song] objects.
  static List<Song> songsFor(Playlist playlist) => [
        for (final id in playlist.songIds)
          if (_songById[id] case final song?) song,
      ];

  // ---------------------------------------------------------------------------
  // PLAYLISTS
  // ---------------------------------------------------------------------------
  static const List<Playlist> playlists = [
    Playlist(
      id: 'pl1',
      name: 'OPM Rewind',
      description: "The Filipino songs you can't stop singing along to.",
      owner: 'SpotiBai',
      color: Color(0xFFD35400),
      songIds: ['s01', 's04', 's07', 's09', 's10', 's11', 's12', 's13', 's16'],
    ),
    Playlist(
      id: 'pl2',
      name: 'Chill Vibes',
      description: 'Soft, slow and easy. Kick back and unwind.',
      owner: 'SpotiBai',
      color: Color(0xFF2E7D8C),
      songIds: ['s09', 's18', 's21', 's28', 's33', 's32', 's16', 's02', 's30'],
    ),
    Playlist(
      id: 'pl3',
      name: 'Hot Hits PH',
      description: "Today's biggest hits from the Philippines and beyond.",
      owner: 'SpotiBai',
      color: Color(0xFFE0245E),
      songIds: ['s15', 's14', 's13', 's11', 's17', 's19', 's23', 's25'],
    ),
    Playlist(
      id: 'pl4',
      name: 'Workout Beats',
      description: 'High-energy tracks to push you through every rep.',
      owner: 'SpotiBai',
      color: Color(0xFFC62828),
      songIds: ['s26', 's27', 's29', 's17', 's19', 's15', 's14', 's22'],
    ),
    Playlist(
      id: 'pl5',
      name: 'Late Night Drive',
      description: 'Windows down, city lights on. Moody tracks for the road.',
      owner: 'SpotiBai',
      color: Color(0xFF3F51B5),
      songIds: ['s17', 's18', 's20', 's24', 's30', 's31', 's09', 's32'],
    ),
    Playlist(
      id: 'pl6',
      name: 'Pinoy Pop Essentials',
      description: 'The new wave of Filipino pop, all in one place.',
      owner: 'SpotiBai',
      color: Color(0xFF8E44AD),
      songIds: ['s05', 's11', 's13', 's14', 's15', 's16', 's06', 's03'],
    ),
    Playlist(
      id: 'pl7',
      name: 'Daily Mix 1',
      description: 'Ben&Ben, The Weeknd, Taylor Swift and more.',
      owner: 'Made for you',
      color: Color(0xFF1E8E5A),
      songIds: ['s01', 's17', 's20', 's04', 's19', 's26', 's11'],
    ),
    Playlist(
      id: 'pl8',
      name: 'Discover Weekly',
      description: 'Your weekly mixtape of fresh music. Enjoy new finds.',
      owner: 'Made for you',
      color: Color(0xFF6C5CE7),
      songIds: ['s31', 's24', 's28', 's12', 's08', 's33', 's22', 's25'],
    ),
  ];

  // ---------------------------------------------------------------------------
  // ALBUMS
  // ---------------------------------------------------------------------------
  static const List<Playlist> albums = [
    Playlist(
      id: 'al1',
      name: 'Limasawa Street',
      description: 'Album • 2021',
      owner: 'Ben&Ben',
      color: Color(0xFFC0562F),
      kind: CollectionKind.album,
      songIds: ['s01', 's02', 's03'],
    ),
    Playlist(
      id: 'al2',
      name: 'Malaya',
      description: 'Album • 2018',
      owner: 'Moira Dela Torre',
      color: Color(0xFF2E6F8E),
      kind: CollectionKind.album,
      songIds: ['s04', 's05', 's06'],
    ),
    Playlist(
      id: 'al3',
      name: 'After Hours',
      description: 'Album • 2020',
      owner: 'The Weeknd',
      color: Color(0xFFB3202A),
      kind: CollectionKind.album,
      songIds: ['s17', 's18'],
    ),
    Playlist(
      id: 'al4',
      name: 'Midnights',
      description: 'Album • 2022',
      owner: 'Taylor Swift',
      color: Color(0xFF2C3E70),
      kind: CollectionKind.album,
      songIds: ['s20', 's21', 's22'],
    ),
  ];

  // ---------------------------------------------------------------------------
  // ARTISTS
  // ---------------------------------------------------------------------------
  static const List<Artist> artists = [
    Artist(id: 'ar1', name: 'Ben&Ben', color: Color(0xFFC0562F), monthlyListeners: '5.2M'),
    Artist(id: 'ar2', name: 'Moira Dela Torre', color: Color(0xFF2E6F8E), monthlyListeners: '3.8M'),
    Artist(id: 'ar3', name: 'Eraserheads', color: Color(0xFF6B7F3A), monthlyListeners: '2.1M'),
    Artist(id: 'ar4', name: 'Up Dharma Down', color: Color(0xFF3B4A6B), monthlyListeners: '1.4M'),
    Artist(id: 'ar5', name: 'The Weeknd', color: Color(0xFFB3202A), monthlyListeners: '96M'),
    Artist(id: 'ar6', name: 'Taylor Swift', color: Color(0xFF2C3E70), monthlyListeners: '110M'),
    Artist(id: 'ar7', name: 'Billie Eilish', color: Color(0xFF6E8B1F), monthlyListeners: '82M'),
    Artist(id: 'ar8', name: 'Dua Lipa', color: Color(0xFFB04DB3), monthlyListeners: '74M'),
  ];

  /// Builds an artist page (top songs) as a [Playlist] so it can reuse the
  /// shared detail screen.
  static Playlist artistPlaylist(Artist artist) => Playlist(
        id: artist.id,
        name: artist.name,
        description: '${artist.monthlyListeners} monthly listeners',
        owner: artist.name,
        color: artist.color,
        kind: CollectionKind.artist,
        songIds: [
          for (final s in songs)
            if (s.artist == artist.name) s.id,
        ],
      );

  // ---------------------------------------------------------------------------
  // GENRES (Search → Browse all)
  // ---------------------------------------------------------------------------
  static const List<Genre> genres = [
    Genre(name: 'Pop', color: Color(0xFFE13300)),
    Genre(name: 'OPM', color: Color(0xFF1E3264)),
    Genre(name: 'Hip-Hop', color: Color(0xFFBA5D07)),
    Genre(name: 'Chill', color: Color(0xFF477D95)),
    Genre(name: 'Rock', color: Color(0xFFE91429)),
    Genre(name: 'Indie', color: Color(0xFF8D67AB)),
    Genre(name: 'Workout', color: Color(0xFF608108)),
    Genre(name: 'Party', color: Color(0xFFAF2896)),
    Genre(name: 'Love', color: Color(0xFFDC148C)),
    Genre(name: 'Focus', color: Color(0xFF503750)),
  ];

  /// Builds a genre page from every song carrying the matching tag.
  static Playlist genrePlaylist(Genre genre) => Playlist(
        id: 'genre_${seedFrom(genre.name)}',
        name: genre.name,
        description: 'The best ${genre.name} tracks, picked for you.',
        owner: 'SpotiBai',
        color: genre.color,
        kind: CollectionKind.genre,
        songIds: [
          for (final s in songs)
            if (s.tags.contains(genre.name)) s.id,
        ],
      );

  // ---------------------------------------------------------------------------
  // HOME SECTIONS
  // ---------------------------------------------------------------------------
  static List<Playlist> get recentlyPlayed => [
        playlists[1],
        albums[0],
        playlists[0],
        albums[2],
        playlists[4],
        albums[1],
      ];

  static List<Playlist> get madeForYou => [
        playlists[6],
        playlists[7],
        playlists[1],
        playlists[4],
      ];

  static List<Song> get trending => [
        for (final id in const [
          's17', 's15', 's20', 's04', 's19', 's27', 's11', 's31', 's24', 's09',
        ])
          _songById[id]!,
      ];

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------
  /// Case-insensitive match on title, artist, album or genre tag.
  static List<Song> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return songs.where((s) {
      return s.title.toLowerCase().contains(q) ||
          s.artist.toLowerCase().contains(q) ||
          s.album.toLowerCase().contains(q) ||
          s.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }
}
