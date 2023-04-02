part of 'text_to_image_bloc.dart';

@immutable
abstract class TextToImageState {}

class TextToImageInitial extends TextToImageState {}

class TextToImageLoading extends TextToImageState {}

class TextToImageSuccess extends TextToImageState {
  final Image resultImage;

  TextToImageSuccess(this.resultImage);
}

class TextToImageFaild extends TextToImageState {}
