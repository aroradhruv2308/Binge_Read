part of 'book_detail_screen_bloc.dart';

abstract class BookDetailScreenState extends Equatable {
  const BookDetailScreenState();

  @override
  List<Object?> get props => [];
}

class BookDetailScreenInitial extends BookDetailScreenState {}

// Initial state when user navigates to book detail screen.
class InitialLoadState extends BookDetailScreenState {
  final List<Episode>? episodes;
  const InitialLoadState(this.episodes);

  @override
  List<Object?> get props => [episodes];
}

// State changes when user change season_id from Season drop down.
class ShowSeasonEpisodesState extends BookDetailScreenState {
  final int seasonNumber;
  final List<Episode>? episodes;

  const ShowSeasonEpisodesState(this.seasonNumber, this.episodes);

  @override
  List<Object?> get props => [seasonNumber, episodes];
}

class UpdatePercentReadState extends BookDetailScreenState {
  const UpdatePercentReadState();
}

class ResetState extends BookDetailScreenState {
  const ResetState();
}
