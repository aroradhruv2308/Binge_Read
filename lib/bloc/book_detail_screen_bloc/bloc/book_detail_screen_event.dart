part of 'book_detail_screen_bloc.dart';

abstract class BookDetailScreenEvent {
  const BookDetailScreenEvent();
}

// Event which is triggered to display all the episodes data.
class ShowSeasonEpisodesEvent extends BookDetailScreenEvent {
  int? seasonNumber;

  ShowSeasonEpisodesEvent({required this.seasonNumber});
}

// EVent to reset already set state.
class ResetEvent extends BookDetailScreenEvent {
  ResetEvent();
}
