import 'dart:convert';
import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/macs/hmac.dart';

class HmacSha512 {
  String hmacSha512(String message, String secret) {
    Uint8List hmacSHA512(Uint8List data, Uint8List key) {
      final _tmp = new HMac(new SHA512Digest(), 128)
        ..init(new KeyParameter(key));
      return _tmp.process(data);
    }

    Uint8List msg = utf8.encode(message);
    Uint8List key = utf8.encode(secret);
    var digest = hmacSHA512(msg, key);
    var signature = HEX.encode(digest);

    return signature;
  }
}
