import 'dart:convert';

import 'package:crypto/crypto.dart';

class Utils {

  static String hashPassword(String content){
    var bytes = utf8.encode(content); // data being hashed
    var digest = sha1.convert(bytes);

    return digest.toString();
  }

}