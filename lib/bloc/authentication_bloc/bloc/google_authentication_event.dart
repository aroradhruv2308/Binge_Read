part of 'google_authentication_bloc.dart';

abstract class GoogleAuthenticationEvent {
  const GoogleAuthenticationEvent();
}

class LoadingEvent extends GoogleAuthenticationEvent {
  const LoadingEvent();
}

class SignInWithGoogleEvent extends GoogleAuthenticationEvent {
  const SignInWithGoogleEvent();
}

class SignOutEvent extends GoogleAuthenticationEvent {
  const SignOutEvent();
}

class ChangeDisplayName extends GoogleAuthenticationEvent {
  const ChangeDisplayName();
}
