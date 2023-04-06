part of 'record_lottie_bloc.dart';

@immutable
abstract class RecordLottieState {}

class RecordLottieInitial extends RecordLottieState {}

class RecordLottiePlaying extends RecordLottieState {}

class RecordLottieStop extends RecordLottieState {}
