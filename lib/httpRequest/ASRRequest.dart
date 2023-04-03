import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

const demo = '';
const demodemo = '';
const demodemodemo = '';

String truncate(String q) {
  if (q == null) {
    return "";
  }
  final size = q.length;
  return size <= 20
      ? q
      : '${q.substring(0, 10)}$size${q.substring(size - 10, size)}';
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
  const audioFilePath = '音频的路径';
  const langType = 'zh-CHS';
  final file = File(audioFilePath);
  final fileExtension = path.extension(audioFilePath);
  if (fileExtension != '.wav') {
    print('不支持的音频类型');
    return;
  }

  final bytes = await file.readAsBytes();
  final q = base64.encode(bytes);

  final curTime = DateTime.now().millisecondsSinceEpoch.toString();
  final salt = const Uuid().v1();
  final signStr = '$demodemo${truncate(q)}$salt$curTime$demodemodemo';
  final sign = encrypt(signStr);

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
  print(response.body);
}
