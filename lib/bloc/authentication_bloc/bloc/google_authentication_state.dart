part of 'google_authentication_bloc.dart';

abstract class GoogleAuthenticationState extends Equatable {
  const GoogleAuthenticationState();
}

class GoogleAuthenticationInitial extends GoogleAuthenticationState {
  @override
  List<Object?> get props => [];
}

class DisplayNameChange extends GoogleAuthenticationState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends GoogleAuthenticationState {
  @override
  List<Object?> get props => [];
}

class GoogleAuthenticationLoading extends GoogleAuthenticationState {
  @override
  List<Object?> get props => [];
}

class GoogleAuthenticationSuccess extends GoogleAuthenticationState {
  final GoogleSignInAccount? googleUser;

  const GoogleAuthenticationSuccess(this.googleUser);

  @override
  List<Object?> get props => [googleUser];
}

class GoogleAuthenticationFaliure extends GoogleAuthenticationState {
  @override
  List<Object?> get props => [];
}
