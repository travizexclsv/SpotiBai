# SpotiBai

A Spotify-inspired music streaming **UI prototype** built with Flutter. Everything runs on
mock data: no backend, no real audio. Playback is simulated with a `Timer`.

## Run it

1. Install Flutter (stable channel) and check it with `flutter doctor`.
2. From the repository root, install packages and run the app:

   ```bash
  cd spotibai
  flutter pub get
  flutter run
   ```

## Network access

Android internet access is declared in the main manifest for both debug and release builds.
If the device is offline, the app falls back to generated gradient covers and the system font.
To turn network cover art off entirely, set `AppConfig.useNetworkImages = false` in
`lib/data/app_config.dart`.

## Folder structure

```
lib/
  main.dart                  app entry, providers, theme
  theme/                     app_colors.dart, app_theme.dart
  models/                    song, playlist (also albums/artists/genres pages), artist, genre
  data/                      mock_data.dart (33 songs, 8 playlists, 4 albums, 8 artists, 10 genres)
  providers/
    player_provider.dart     queue, play/pause, next/prev, shuffle, repeat, fake timer
    library_provider.dart    liked songs, saved library items, downloads
  screens/                   splash, login, main (tabs), home, search, library, detail, now_playing
  widgets/                   SongTile, PlaylistCard, MediaCard, SectionHeader, MiniPlayer, ...
  utils/                     format helpers, page transitions, navigation helper
```

## Notes
- `just_audio` is left commented out in `pubspec.yaml`. To get real audio, replace the timer in
  `PlayerProvider` with a `just_audio` `AudioPlayer`.
- Song and artist names are real, but all data (durations, albums, listener counts) is mock.
