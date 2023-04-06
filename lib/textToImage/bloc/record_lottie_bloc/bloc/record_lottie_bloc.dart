import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'record_lottie_event.dart';
part 'record_lottie_state.dart';

class RecordLottieBloc extends Bloc<RecordLottieEvent, RecordLottieState> {
  RecordLottieBloc() : super(RecordLottieInitial()) {
    on<RecordLottiePlayEvent>((event, emit) {
      emit(RecordLottiePlaying());
    });
    on<RecordLottieStopEvent>((event, emit) {
      emit(RecordLottieStop());
    });
  }
}
