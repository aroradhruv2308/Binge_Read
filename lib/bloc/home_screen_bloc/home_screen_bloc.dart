import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<RemoveSplashScreenEvent>((event, emit) {
      final state = RemoveSplashScreenState();
      emit(state);
    });
    on<ShowShimmerEvent>((event, emit) {
      final state = ShowShimmerState();
      emit(state);
    });
    on<InitialEvent>((event, emit) {
      final state = HomeScreenInitial();
      emit(state);
    });
  }
}
