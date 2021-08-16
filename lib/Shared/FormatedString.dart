class FormatedString {
  static String formatedString(String value) {
    return '${value.replaceAll('&#039;', "\'").replaceAll('&quot;', '').replaceAll('&amp;', '&')}';
  }
}
