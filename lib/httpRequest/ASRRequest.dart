import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;

const demo = 'https://openapi.youdao.com/asrapi';
const APP_KEY = '';
const APP_SECRET = '';

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

Future<Response> doRequest(Map<String, String> data) async {
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  final dio = Dio();
  final response =
      await dio.post(demo, data: data, options: Options(headers: headers));
  return response;
}

Future<List> ASRRequest(String path) async {
  final file = await rootBundle.load(path);
  final bytes = file.buffer.asUint8List();
  final q = base64.encode(bytes);

  const langType = 'zh-CHS';

  final currTime =
      (DateTime.now().millisecondsSinceEpoch / 1000).truncate().toString();

  final salt = const Uuid().v1();
  String signStr = APP_KEY + truncate(q) + salt + currTime + APP_SECRET;
  String sign = encodeSHA256(signStr);

  final data = <String, String>{
    'appKey': APP_KEY,
    'q': q,
    'salt': salt,
    'curtime': currTime,
    'sign': sign,
    'signType': 'v2',
    'langType': langType,
    'rate': '16000',
    'format': 'wav',
    'channel': '1',
    'type': '1',
  };

  final response = await doRequest(data);
  final Result = response.data['result'] as List<dynamic>;
  return Result;
}
