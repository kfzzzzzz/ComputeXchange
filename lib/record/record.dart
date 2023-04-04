import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

//final record = Record();
//var savePath = '';

Future<void> startRecord(Record record) async {
  //savePath = path;
// 检查并请求权限
  if (await record.hasPermission()) {
    // 开始录制
    await record.start(
      encoder: AudioEncoder.wav,
      bitRate: 128000, // 默认值
      samplingRate: 44100, // 默认值
    );
  }
}

Future<String> stopRecord(Record record) async {
  final path = await record.stop();

  // 将原始PCM数据转换为.wav文件
  final output = await convertM4AToWAV(path ?? "");
  return output;
}

Future<String> convertM4AToWAV(String m4aPath) async {
  final documentsDirectory = await getApplicationDocumentsDirectory();
  String wavPath =
      '${documentsDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.wav';
  final arguments = '-i $m4aPath -acodec pcm_s16le -ac 1 -ar 16000 $wavPath';
  final executeCallback = FFmpegKit.executeAsync(arguments);
  final returnCode =
      await executeCallback.then((session) => session.getReturnCode());
  if (ReturnCode.isSuccess(returnCode) || returnCode == null) {
    //print('M4A file converted to WAV file successfully');
    //print('Output file path: $wavPath');
    return wavPath;
  } else {
    //print('M4A file to WAV file conversion failed');
    throw 'Conversion failed with returnCode=$returnCode';
  }
}
