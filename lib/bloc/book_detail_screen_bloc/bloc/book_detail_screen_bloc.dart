import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:binge_read/db/query.dart';

part 'book_detail_screen_event.dart';
part 'book_detail_screen_state.dart';

class BookDetailScreenBloc extends Bloc<BookDetailScreenEvent, BookDetailScreenState> {
  Map<int, List<Episode>> _episodes = {};
  late int _seriesId;

  BookDetailScreenBloc(int seriesId, int seasonId) : super(BookDetailScreenInitial()) {
    // Initialize _episodes using seriesId and currentSeason
    if (!_episodes.containsKey(seasonId)) {
      _fetchAndSetEpisodesData(seasonId, seriesId);
    }

    // This event is triggered when user changes season number on
    // series detail screen, then we need to fetch new episodes based
    // on selected season number.
    on<ShowSeasonEpisodesEvent>((event, emit) {
      int seasonNumber = event.seasonNumber ?? 1;

      // Check if episode data for this season already present in episdoses,
      // then directly set the state.
      if (_episodes.containsKey(seasonNumber)) {
        List<Episode>? episodes = _episodes[seasonNumber];

        ShowSeasonEpisodesState state = ShowSeasonEpisodesState(seasonNumber, episodes);
        emit(state);

        return;
      }

      // Otherwise fetch episodes data from _fetchAndSetEpisodesData, this
      // will fetch episodes data and will also emit this event.
      _fetchAndSetEpisodesData(seasonNumber, seriesId);
    });

    // Adding this reset event, which will reset the bloc after emitting
    // one event (some issue with bloc - I will discuss with Dhruv for exact
    // comment.)
    on<ResetEvent>((event, emit) {
      ResetState state = const ResetState();
      emit(state);
    });
  }

  void _fetchAndSetEpisodesData(int seasonId, int seriesId) async {
    if (!_episodes.containsKey(seasonId) || _seriesId != seriesId) {
      try {
        List<Episode> episodes = await fetchEpisodes(seasonId: seasonId, seriesId: seriesId);

        // Set episodes data based on season_id in map and also update series number.
        _episodes[seasonId] = episodes;
        _seriesId = seriesId;
      } catch (e) {
        // TODO: Add error event here.
        print("Unable to trigger any state because of following error: $e");
        return;
      }
    }

    add(ShowSeasonEpisodesEvent(seasonNumber: seasonId));
  }
}
