import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';

const URL = 'https://aigc-api-trial.hz.netease.com/openai/api/v2/text/chat';
const APP_ID = '';
const API_Key = '';

Map<String, String> signedHeaders(String appId, String appKey) {
  String nonce = generateNonce(10);
  String timestamp =
      (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString();
  String str2Sign =
      "appId=$appId&nonce=$nonce&timestamp=$timestamp&appkey=$appKey";
  String sign = md5.convert(utf8.encode(str2Sign)).toString().toUpperCase();

  Map<String, String> headers = <String, String>{};
  headers.putIfAbsent("appId", () => appId);
  headers.putIfAbsent("nonce", () => nonce);
  headers.putIfAbsent("timestamp", () => timestamp);
  headers.putIfAbsent("sign", () => sign);
  headers.putIfAbsent("version", () => "v2");
  return headers;
}

String generateNonce(int length) {
  final random = Random.secure();
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(
        random.nextInt(chars.length),
      ),
    ),
  );
}

Future<String> GPTRequest(String input) async {
  final Map<String, dynamic> requestBody = {
    'messages': [
      {'role': 'user', 'content': '你好呀'},
      {'role': 'assistant', 'content': '\n\n你好，有什么可以帮助你的吗？'},
      {'role': 'user', 'content': '接下来请生成Stable Diffusion 的Prompt'},
      {'role': 'assistant', 'content': '\n\n好的'},
      {
        'role': 'user',
        'content':
            '要求：1.输出结果为英文。2.输出结果仅包含Prompt不要讲多余的话。3.输出关键词，且不同词用逗号隔开。4.只输出Keywords就可以。'
      },
      {'role': 'assistant', 'content': '\n\n好的'},
      {'role': 'user', 'content': input},
    ],
    'model': 'gpt-3.5-turbo',
    'maxTokens': 200,
    'temperature': 0.3,
    'topP': 1,
    'stop': null,
    'presencePenalty': 0,
    'frequencyPenalty': 0
  };

  final dio = Dio();
  final response = await dio.post(
    URL,
    data: json.encode(requestBody),
    options: Options(
      headers: signedHeaders(APP_ID, API_Key),
    ),
  );

  if (response.statusCode == 200) {
    // 请求成功
    final choices = response.data['detail']['choices'] as List;
    final content = choices.first['message']['content'];
    final words = content.split("Keywords: ");
    final result = words[1];
    return result;
  } else {
    // 请求失败
    print('请求失败，状态码：${response.statusCode}');
    return "";
  }
}
