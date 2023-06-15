import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'google_authentication_event.dart';
part 'google_authentication_state.dart';

class GoogleAuthenticationBloc extends Bloc<GoogleAuthenticationEvent, GoogleAuthenticationState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleAuthenticationBloc() : super(GoogleAuthenticationInitial()) {
    on<GoogleAuthenticationEvent>((event, emit) {});
    on<SignInWithGoogleEvent>(_handleSignInWithGoogle);
    on<SignOutEvent>(_handleSignOut);
  }
  Future<void> _handleSignInWithGoogle(SignInWithGoogleEvent event, Emitter<GoogleAuthenticationState> emit) async {
    emit(GoogleAuthenticationLoading());

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(GoogleAuthenticationFaliure());
        return;
      }
      emit(GoogleAuthenticationSuccess(googleUser));
    } catch (e) {
      print("###### $e");
      emit(GoogleAuthenticationFaliure());
    }
  }

  Future<void> _handleSignOut(SignOutEvent event, Emitter<GoogleAuthenticationState> emit) async {
    await _googleSignIn.signOut();
    emit(GoogleAuthenticationInitial());
  }
}
