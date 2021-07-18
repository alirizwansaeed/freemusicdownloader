class DurationToTime {
  static durationToTime(int value) {
    return '${Duration(seconds: value).inMinutes}:${Duration(seconds: value).inMilliseconds.toString().substring(0, 2)}';
  }
}
