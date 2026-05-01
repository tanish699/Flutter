
import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashUtil {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hashed = sha256.convert(bytes);
    return hashed.toString();
  }
}