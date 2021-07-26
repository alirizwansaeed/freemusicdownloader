class ImageQuality {
  static String imageQuality({required String value, required int size}) {
    if (value.contains(RegExp(
        r'-150x150.jpg|_150x150.jpg|-250x250.jpg|_250x250.jpg|-350x350.jpg|_350x350.jpg|-500x500.jpg|_500x500.jpg'))) {
      return '${value.replaceAll(RegExp(r'-150x150.jpg|_150x150.jpg|-250x250.jpg|_250x250.jpg|-350x350.jpg|_350x350.jpg|-500x500.jpg|_500x500.jpg'), '-${size}x$size.jpg')}';
    } else if (value.contains('-thumb.jpg')) {
      return value;
    } else
      return '${value.replaceAll(RegExp(r'.jpg'), '_${size}x$size.jpg')}';
  }
}
