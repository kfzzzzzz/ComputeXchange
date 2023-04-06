import 'package:compute_xchange/httpRequest/ASRRequest.dart';
import 'package:compute_xchange/httpRequest/GPTRequest.dart';
import 'package:compute_xchange/record/record.dart';
import 'package:compute_xchange/textToImage/bloc/record_lottie_bloc/bloc/record_lottie_bloc.dart';
import 'package:compute_xchange/utils/error_page.dart';
import 'package:compute_xchange/utils/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:lottie/lottie.dart';

import 'bloc/text_to_image_bloc.dart';

class textToImagePage extends StatefulWidget {
  @override
  _TextToImagePage createState() => _TextToImagePage();
}

class _TextToImagePage extends State<textToImagePage> {
  TextEditingController _descriptionController = TextEditingController();
  late final TextToImageBloc _textToImageBloc;
  late final RecordLottieBloc _recordLottieBloc;
  final record = Record();
  bool isRecording = false;
  String animationAssetPath = 'images/asr_recording.json';

  @override
  void initState() {
    super.initState();
    _textToImageBloc = TextToImageBloc();
    _recordLottieBloc = RecordLottieBloc();
  }

  @override
  void dispose() {
    _textToImageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("小小漫画家"),
        backgroundColor: Colors.pink, // 设置背景颜色为透明
        elevation: 0, // 移除AppBar的阴影效果
      ),
      body: Stack(alignment: Alignment.center, children: [
        // 背景图
        Positioned.fill(
          child: Image.asset(
            "images/background.png",
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            textToImageBody(textToImageBloc: _textToImageBloc),
          ],
        ),
        Positioned(
            bottom: 50,
            child: GestureDetector(
                onTap: () {
                  recordTap(record, _textToImageBloc, _recordLottieBloc);
                },
                child: BlocProvider(
                    create: (context) => _recordLottieBloc,
                    child: BlocBuilder<RecordLottieBloc, RecordLottieState>(
                        builder: (context, state) {
                      if (state is RecordLottiePlaying) {
                        return Lottie.asset(
                          animationAssetPath,
                          width: 250.0,
                          height: 80.0,
                          repeat: true,
                          animate: true,
                        );
                      } else {
                        return const Image(
                          image: AssetImage("images/recordIcon.png"),
                          width: 80.0,
                          height: 80.0,
                        );
                      }
                    }))))
      ]),
    );
  }

  Future<void> recordTap(Record record, TextToImageBloc textToImageBloc,
      RecordLottieBloc recordLottieBloc) async {
    bool isRecording = await record.isRecording();
    if (isRecording) {
      recordLottieBloc.add(RecordLottieStopEvent());
      textToImageBloc.add(TextToImageLoadingEvent());
      final path = await stopRecord(record);
      await Future.delayed(const Duration(seconds: 1));
      final result = await ASRRequest(path);
      final prompt = result.first as String;
      final inputprompt = await GPTRequest(prompt);
      textToImageBloc.add(TextToImageLoadEvent(inputprompt));
    } else {
      isRecording = true;
      recordLottieBloc.add(RecordLottiePlayEvent());
      startRecord(record);
    }
  }
}

class textToImageBody extends StatefulWidget {
  final TextToImageBloc textToImageBloc;

  const textToImageBody({super.key, required this.textToImageBloc});

  @override
  _TextToImageBody createState() => _TextToImageBody();
}

class _TextToImageBody extends State<textToImageBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocProvider(
          create: (context) => widget.textToImageBloc,
          child: BlocBuilder<TextToImageBloc, TextToImageState>(
            builder: (context, state) {
              if (state is TextToImageLoading) {
                return LoadingWidget();
              } else if (state is TextToImageSuccess) {
                return Container(
                  width: 640,
                  height: 512,
                  child: Center(
                    child: state.resultImage,
                  ),
                );
              } else if (state is TextToImageFaild) {
                return ErrorLoadingWidget(message: "加载失败");
              } else {
                return Container();
              }
            },
          )),
    );
  }
}
