import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;

const demo = 'https://openapi.youdao.com/asrapi';
const demodemo = '3b79db3846bd3ae7';
const demodemodemo = 'OBQrU64Knaxz4zgWzdkFBN6LRSDwAIif';

String truncate(String q) {
  if (q == null) {
    return "";
  }
  final size = q.length;
  return size <= 20
      ? q
      : '${q.substring(0, 10)}$size${q.substring(size - 10, size)}';
}

String computeHash(String input, Hash hash) {
  List<int> inputBytes = utf8.encode(input);
  List<int> hashedBytes = hash.convert(inputBytes).bytes;
  return hashedBytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join('');
}

String encodeSHA256(String input) {
  var bytes = utf8.encode(input); //将字符串转为字节数组
  var digest = sha256.convert(bytes); //使用sha256方法进行编码
  return digest.toString(); //将编码后的字节数组转为字符串
}

String encrypt(String signStr) {
  final hash = sha256.convert(signStr.codeUnits);
  return hash.toString();
}

Future<http.Response> doRequest(Map<String, String> data) {
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  return http.post(Uri.parse(demo), body: data, headers: headers);
}

Future<void> ASRRequest() async {
  final file = await rootBundle.load('wav/testwav.wav');
  final bytes = file.buffer.asUint8List();
  final q = base64.encode(bytes);

  // final file = File("C:/Users/31065/Desktop/testwav.wav");
  // // final fileExtension = path.extension(file);
  // // if (fileExtension != '.wav') {s
  // //   print('不支持的音频类型');
  // //   return;
  // // }
  // final bytes = await file.readAsBytes();
  // final q = base64.encode(bytes);

  const langType = 'zh-CHS';

  final curtime =
      (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString();
  print(curtime);
  // const hours8InMilliseconds = 8 * 60 * 60;
  //final curTime = cur - hours8InMilliseconds;
  // print(curTime);
  final salt = const Uuid().v1();
  String signStr = demodemo + truncate(q) + salt + curtime + demodemodemo;
  String sign = encodeSHA256(signStr);
  print(signStr);
  print(sign);
  // final signStr = '$demodemo${truncate(q)}$salt$curtime$demodemodemo';
  // final sign = encrypt(signStr);

  final data = <String, String>{
    'appKey': demodemo,
    'q': q,
    'salt': salt,
    'sign': sign,
    'signType': 'v2',
    'langType': langType,
    'rate': '16000',
    'format': 'wav',
    'channel': '1',
    'type': '1',
  };

  final response = await doRequest(data);
  final serverTime = response.headers['date'];
  print('服务器时间：$serverTime');
  print(response.body);
}
