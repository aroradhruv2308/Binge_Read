part of 'book_detail_screen_bloc.dart';

abstract class BookDetailScreenEvent {
  const BookDetailScreenEvent();
}

class ShowSeasonEpisodesEvent extends BookDetailScreenEvent {
  int? seasonNumber;
  ShowSeasonEpisodesEvent({required this.seasonNumber});
}

class ResetEvent extends BookDetailScreenEvent {
  ResetEvent();
}
