part of 'home_screen_bloc.dart';

@immutable
abstract class HomeScreenEvent {}

class RemoveSplashScreenEvent extends HomeScreenEvent {}

class ShowShimmerEvent extends HomeScreenEvent {}

class InitialEvent extends HomeScreenEvent {}
