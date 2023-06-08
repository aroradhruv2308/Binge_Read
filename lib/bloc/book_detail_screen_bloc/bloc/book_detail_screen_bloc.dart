import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'book_detail_screen_event.dart';
part 'book_detail_screen_state.dart';

class BookDetailScreenBloc extends Bloc<BookDetailScreenEvent, BookDetailScreenState> {
  BookDetailScreenBloc() : super(BookDetailScreenInitial()) {
    on<BookDetailScreenEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ShowSeasonEpisodesEvent>((event, emit) {
      int? seasonNumber = event.seasonNumber;
      ShowSeasonEpisodesState state = ShowSeasonEpisodesState(seasonNumber);
      emit(state);
    });
    on<ResetEvent>((event, emit) {
      ResetState state = ResetState();
      emit(state);
    });
  }
}
