part of 'record_lottie_bloc.dart';

@immutable
abstract class RecordLottieEvent {}

class RecordLottiePlayEvent extends RecordLottieEvent {}

class RecordLottieStopEvent extends RecordLottieEvent {}
