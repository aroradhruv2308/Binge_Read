import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/models/user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../db/query.dart';

part 'google_authentication_event.dart';
part 'google_authentication_state.dart';

class GoogleAuthenticationBloc extends Bloc<GoogleAuthenticationEvent, GoogleAuthenticationState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleAuthenticationBloc() : super(GoogleAuthenticationInitial()) {
    on<GoogleAuthenticationEvent>((event, emit) {});
    on<SignInWithGoogleEvent>(_handleSignInWithGoogle);
    on<SignOutEvent>(_handleSignOut);
    on<ChangeDisplayName>((event, emit) {
      DisplayNameChange state = DisplayNameChange();
      emit(state);
    });
  }
  Future<void> _handleSignInWithGoogle(SignInWithGoogleEvent event, Emitter<GoogleAuthenticationState> emit) async {
    emit(GoogleAuthenticationLoading());

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(GoogleAuthenticationFaliure());
        return;
      }
      Map<String, dynamic> userData = {
        'name': googleUser.displayName,
        'email': googleUser.email,
        'photo-url': googleUser.photoUrl,
        // Add more fields as needed
      };

      await addNewUser(userData);
      Globals.userName = userData['name'];
      String? name = userData['name'];
      String? email = userData['email'];
      Globals.userEmail = userData['email'];

      User userDetails = User(email!, name!);
      await Globals.userLoginService!.addUserDetails(email, userDetails);
      Globals.isLogin = true;
      emit(GoogleAuthenticationSuccess(googleUser));
    } catch (e) {
      emit(GoogleAuthenticationFaliure());
    }
  }

  Future<void> _handleSignOut(SignOutEvent event, Emitter<GoogleAuthenticationState> emit) async {
    await _googleSignIn.signOut();
    await Globals.userLoginService?.updateUserDetails(Globals.userEmail, User("", ""));
    Globals.userEmail = "";
    Globals.userName = "Reader";
    Globals.isLogin = false;
    emit(GoogleAuthenticationInitial());
  }
}
