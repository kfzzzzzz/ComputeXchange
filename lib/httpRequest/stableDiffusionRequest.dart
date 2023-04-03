import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

Future<Image> sendPostRequest(String prompt) async {
  var inputPrompt =
      "(best quality), ((masterpiece)), (highres), original, picture book style, $prompt,<lora:Q版建模风:0.6><lora:水彩画v4:0.3><lora:矢量插画v1:0.3>";
  print(inputPrompt);
  const url = 'https://webui-debug.site.youdao.com/sdapi/v1/txt2img';
  final dio = Dio();
  final response = await dio.post(
    url,
    options: Options(
      headers: {'Content-Type': 'application/json'},
    ),
    data: {
      "enable_hr": false,
      "denoising_strength": 0,
      "firstphase_width": 0,
      "firstphase_height": 0,
      "hr_scale": 2,
      "hr_upscaler": "string",
      "hr_second_pass_steps": 0,
      "hr_resize_x": 0,
      "hr_resize_y": 0,
      "prompt": inputPrompt,
      "styles": [""],
      "seed": -1,
      "subseed": -1,
      "subseed_strength": 0,
      "seed_resize_from_h": -1,
      "seed_resize_from_w": -1,
      "batch_size": 1,
      "n_iter": 1,
      "steps": 20,
      "cfg_scale": 7,
      "width": 640,
      "height": 512,
      "restore_faces": false,
      "tiling": false,
      "negative_prompt":
          "NSFW,lowres, bad anatomy, bad hands, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry, toy, extra legs",
      "eta": 0,
      "s_churn": 0,
      "s_tmax": 0,
      "s_tmin": 0,
      "s_noise": 1,
      "override_settings": {},
      "override_settings_restore_afterwards": true,
      "script_args": [],
      "sampler_index": "DPM++ SDE"
    },
  );

  print(response.statusCode);

  if (response.statusCode == 200) {
    // 使用Dart的点表示法访问JSON对象中的字段。
    final images = response.data['images'] as List<dynamic>;

    Uint8List bytes = base64Decode(images.first);
    return Image.memory(bytes);
  } else {
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}
