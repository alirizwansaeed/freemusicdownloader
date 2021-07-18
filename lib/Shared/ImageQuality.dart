class ImageQuality {
  static String imageQuality({required String value, required int size}) {
    if (value.contains('-150x150.jpg')) {
      return '${value.replaceAll(RegExp(r'-150x150.jpg'), '-${size}x$size.jpg')}';
    } else if (value.contains('_150x150.jpg')) {
      return '${value.replaceAll(RegExp(r'_150x150.jpg'), '-${size}x$size.jpg')}';
    } else if (value.contains('-thumb.jpg')) {
      return value;
    } else
      return '${value.replaceAll(RegExp(r'.jpg'), '_${size}x$size.jpg')}';
  }
}
