import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/player_provider.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';

/// Seek slider with elapsed / total timestamps.
///
/// While the user drags, the slider shows the drag value and ignores the
/// timer; the seek is committed when the finger lifts.
class SeekBar extends StatefulWidget {
  const SeekBar({super.key});

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragMs;

  @override
  Widget build(BuildContext context) {
    final player = context.read<PlayerProvider>();
    final song = context.select<PlayerProvider, Song?>((p) => p.currentSong);
    if (song == null) return const SizedBox.shrink();

    final totalMs = song.duration.inMilliseconds.toDouble();
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        );

    return ValueListenableBuilder<Duration>(
      valueListenable: player.position,
      builder: (context, position, _) {
        final currentMs = (_dragMs ?? position.inMilliseconds.toDouble())
            .clamp(0.0, totalMs)
            .toDouble();

        return Column(
          children: [
            Slider(
              value: currentMs,
              min: 0,
              max: totalMs,
              onChanged: (value) => setState(() => _dragMs = value),
              onChangeEnd: (value) {
                player.seek(Duration(milliseconds: value.round()));
                setState(() => _dragMs = null);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(Duration(milliseconds: currentMs.round())),
                    style: labelStyle,
                  ),
                  Text(formatDuration(song.duration), style: labelStyle),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
