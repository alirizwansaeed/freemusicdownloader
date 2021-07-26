class DurationToTime {
  static String durationToTime(int value) {
    return '${Duration(milliseconds: value).inMinutes}:${Duration(milliseconds: value).inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}
