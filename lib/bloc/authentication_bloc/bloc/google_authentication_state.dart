part of 'google_authentication_bloc.dart';

abstract class GoogleAuthenticationState extends Equatable {
  const GoogleAuthenticationState();
}

class GoogleAuthenticationInitial extends GoogleAuthenticationState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class GoogleAuthenticationLoading extends GoogleAuthenticationState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class GoogleAuthenticationSuccess extends GoogleAuthenticationState {
  late final GoogleSignInAccount? googleUser;

  GoogleAuthenticationSuccess(this.googleUser);

  @override
  List<Object?> get props => [googleUser];
}

class GoogleAuthenticationFaliure extends GoogleAuthenticationState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
