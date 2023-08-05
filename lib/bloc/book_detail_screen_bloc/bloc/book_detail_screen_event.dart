part of 'book_detail_screen_bloc.dart';

abstract class BookDetailScreenEvent {
  const BookDetailScreenEvent();
}

// Event which is triggered to display all the episodes data.
class ShowSeasonEpisodesEvent extends BookDetailScreenEvent {
  int? seasonNumber;

  ShowSeasonEpisodesEvent({required this.seasonNumber});
}

// Event which is triggered to update percentRead in episodes
// data in bloc.
class UpdatePercentReadEvent extends BookDetailScreenEvent {
  int? seasonNumber;
  int? episodeNumber;
  int? percentRead;

  UpdatePercentReadEvent({
    required this.seasonNumber,
    required this.episodeNumber,
    required this.percentRead,
  });
}

// EVent to reset already set state.
class ResetEvent extends BookDetailScreenEvent {
  ResetEvent();
}
