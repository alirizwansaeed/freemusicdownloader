import 'dart:convert';

import 'package:dart_des/dart_des.dart';

class DecryptUrl {
  static String decrpturl(String incryptedurl) {
    var key = '38346591';
    var des = DES(
        key: key.codeUnits,
        mode: DESMode.ECB,
        paddingType: DESPaddingType.PKCS7);
    var base64decode = base64Decode(incryptedurl);
    var decrypted = des.decrypt(base64decode);
    var decodedurl = utf8.decode(decrypted);
    return decodedurl;
  }
}
