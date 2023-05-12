part of 'home_screen_bloc.dart';

@immutable
abstract class HomeScreenState extends Equatable {}

class HomeScreenInitial extends HomeScreenState {
  @override
  List<Object?> get props => [];
}

class RemoveSplashScreenState extends HomeScreenState {
  @override
  List<Object?> get props => [];
}
