import 'package:compute_xchange/utils/error_page.dart';
import 'package:compute_xchange/utils/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/text_to_image_bloc.dart';

class textToImagePage extends StatefulWidget {
  @override
  _TextToImagePage createState() => _TextToImagePage();
}

class _TextToImagePage extends State<textToImagePage> {
  TextEditingController _descriptionController = TextEditingController();
  late final TextToImageBloc _textToImageBloc;

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
      body: Column(
        children: [
          TextField(
            autofocus: true,
            controller: _descriptionController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _textToImageBloc.add(TextToImageLoadEvent(
                    _descriptionController.text,
                  ));
                },
              ),
            ),
          ),
          textToImageBody(textToImageBloc: _textToImageBloc)
        ],
      ),
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
    return BlocProvider(
        create: (context) => widget.textToImageBloc,
        child: BlocBuilder<TextToImageBloc, TextToImageState>(
          builder: (context, state) {
            if (state is TextToImageLoading) {
              return LoadingWidget();
            } else if (state is TextToImageSuccess) {
              return Container(
                width: 300,
                height: 300,
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
        ));
  }
}
