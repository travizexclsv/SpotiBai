import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../screens/detail_screen.dart';

/// Opens the shared playlist / album / artist / genre detail screen.
void openCollection(BuildContext context, Playlist playlist) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DetailScreen(playlist: playlist),
    ),
  );
}
