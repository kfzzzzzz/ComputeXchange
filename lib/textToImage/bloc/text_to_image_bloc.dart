import 'package:bloc/bloc.dart';
import 'package:compute_xchange/httpRequest/stableDiffusionRequest.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'text_to_image_event.dart';
part 'text_to_image_state.dart';

class TextToImageBloc extends Bloc<TextToImageEvent, TextToImageState> {
  TextToImageBloc() : super(TextToImageInitial()) {
    on<TextToImageLoadEvent>((event, emit) async {
      Future<Image> resultList = sendPostRequest(event.description);
      emit(TextToImageLoading());
      await resultList.then((Image result) {
        emit(TextToImageSuccess(result));
      }).onError((error, stackTrace) {
        emit(TextToImageFaild());
      });
    });
  }
}
