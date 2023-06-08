part of 'book_detail_screen_bloc.dart';

abstract class BookDetailScreenState extends Equatable {
  const BookDetailScreenState();

  @override
  List<Object> get props => [];
}

class BookDetailScreenInitial extends BookDetailScreenState {}

class ShowSeasonEpisodesState extends BookDetailScreenState {
  int? seasonNumber;
  ShowSeasonEpisodesState(this.seasonNumber);
  bool get hasSeasonNumber => seasonNumber != null;
  @override
  List<Object> get props => [hasSeasonNumber];
}

class ResetState extends BookDetailScreenState {
  const ResetState();
  @override
  List<Object> get props => [];
}
