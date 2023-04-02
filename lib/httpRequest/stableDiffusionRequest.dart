import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Image> sendPostRequest(String prompt) async {
  print(prompt);
  final url = Uri.parse('https://webui-debug.site.youdao.com/sdapi/v1/txt2img');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body:
        '{"enable_hr":false,"denoising_strength":0,"firstphase_width":0,"firstphase_height":0,"hr_scale":2,"hr_upscaler":"string","hr_second_pass_steps":0,"hr_resize_x":0,"hr_resize_y":0,"prompt":"$prompt","styles":[""],"seed":-1,"subseed":-1,"subseed_strength":0,"seed_resize_from_h":-1,"seed_resize_from_w":-1,"batch_size":1,"n_iter":1,"steps":50,"cfg_scale":7,"width":512,"height":512,"restore_faces":false,"tiling":false,"eta":0,"s_churn":0,"s_tmax":0,"s_tmin":0,"s_noise":1,"override_settings":{},"override_settings_restore_afterwards":true,"script_args":[],"sampler_index":"Euler"}',
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);

    // 使用Dart的点表示法访问JSON对象中的字段。
    final images = jsonResponse['images'] as List<dynamic>;

    Uint8List bytes = base64Decode(images.first);
    return Image.memory(bytes);
  } else {
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}
