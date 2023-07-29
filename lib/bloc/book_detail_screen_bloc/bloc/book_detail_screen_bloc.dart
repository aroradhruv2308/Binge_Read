import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:binge_read/db/query.dart';

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

  // Add this function to fetch episodes data and update the state
  Future<void> fetchEpisodesData({required int seriesId, required int seasonId}) async {
    try {
      // Call the method to fetch episodes data
      List<Episode> fetchedEpisodes = await fetchEpisodes(seriesId: seriesId, seasonId: seasonId);

      // Call emit to update the state with the latest episodes data
      emit(ShowSeasonEpisodesState(seasonId));
    } catch (e) {
      // Handle any error that occurred during fetching episodes
      print('Error fetching episodes: $e');
    }
  }
}
