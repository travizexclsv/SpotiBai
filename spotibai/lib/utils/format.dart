/// Formats a [Duration] as m:ss, e.g. `3:07`.
String formatDuration(Duration d) {
  final totalSeconds = d.inSeconds < 0 ? 0 : d.inSeconds;
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

/// Formats a total length in seconds as `1 hr 12 min` / `42 min`.
String formatTotalLength(int totalSeconds) {
  final minutes = (totalSeconds / 60).round();
  if (minutes >= 60) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h hr' : '$h hr $m min';
  }
  return '$minutes min';
}

/// "Good morning / afternoon / evening" based on the device clock.
String greetingForNow([DateTime? now]) {
  final hour = (now ?? DateTime.now()).hour;
  if (hour < 12) return 'Good morning';
  if (hour < 18) return 'Good afternoon';
  return 'Good evening';
}
