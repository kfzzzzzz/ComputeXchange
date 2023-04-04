import 'package:compute_xchange/httpRequest/ASRRequest.dart';
import 'package:compute_xchange/record/record.dart';
import 'package:compute_xchange/utils/error_page.dart';
import 'package:compute_xchange/utils/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

import 'bloc/text_to_image_bloc.dart';

class textToImagePage extends StatefulWidget {
  @override
  _TextToImagePage createState() => _TextToImagePage();
}

class _TextToImagePage extends State<textToImagePage> {
  TextEditingController _descriptionController = TextEditingController();
  late final TextToImageBloc _textToImageBloc;
  final record = Record();

  @override
  void initState() {
    super.initState();
    _textToImageBloc = TextToImageBloc();
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
        title: const Text("StableDiffusionDemo"),
      ),
      body: Stack(alignment: Alignment.center, children: [
        Column(
          children: [
            // TextField(
            //   autofocus: true,
            //   controller: _descriptionController,
            //   decoration: InputDecoration(
            //     suffixIcon: IconButton(
            //       icon: Icon(Icons.send),
            //       onPressed: () {
            //         _textToImageBloc.add(TextToImageLoadEvent(
            //           _descriptionController.text,
            //         ));
            //       },
            //     ),
            //   ),
            // ),
            textToImageBody(textToImageBloc: _textToImageBloc),
          ],
        ),
        Positioned(
            bottom: 50,
            child: GestureDetector(
              onTap: () {
                recordTap(record, _textToImageBloc);
              },
              child: const Image(
                image: AssetImage("images/recordIcon.png"),
                width: 80.0,
                height: 80.0,
              ),
            ))
      ]),
    );
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

Future<void> recordTap(Record record, TextToImageBloc textToImageBloc) async {
  textToImageBloc.add(TextToImageLoadingEvent());
  textToImageBloc.add(TextToImageLoadEvent("duck"));

  // bool isRecording = await record.isRecording();
  // if (isRecording) {
  //   textToImageBloc.add(TextToImageLoadingEvent());
  //   final path = await stopRecord(record);
  //   await Future.delayed(const Duration(seconds: 1));
  //   final result = await ASRRequest(path);
  //   final prompt = result.first as String;
  //   textToImageBloc.add(TextToImageLoadEvent(prompt));
  // } else {
  //   startRecord(record);
  // }
}
