part of 'text_to_image_bloc.dart';

@immutable
abstract class TextToImageEvent {}

class TextToImageLoadEvent extends TextToImageEvent {
  final String description;

  TextToImageLoadEvent(this.description);
}

class TextToImageLoadingEvent extends TextToImageEvent {}
