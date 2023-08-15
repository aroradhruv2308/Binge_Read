import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(DisplayNameChange());
    });
    on<LoadingEvent>((event, emit) {
      emit(LoadingState());
    });
  }

  Future<void> _handleSignInWithGoogle(SignInWithGoogleEvent event, Emitter<GoogleAuthenticationState> emit) async {
    emit(GoogleAuthenticationLoading());

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user unable to login, emit failure event.
      if (googleUser == null) {
        emit(GoogleAuthenticationFaliure());
        return;
      }

      Map<String, dynamic> userData = {
        'name': googleUser.displayName?.substring(0, 15),
        'email': googleUser.email,
      };

      // This will check if user is new i.e. no email have registered before
      // then store user data in db.
      await addUserInDBAndStoreInHive(userData);

      // Set email in global variable to user email. This will be used
      // for getting complete user data from db.
      Globals.userEmail = userData["email"];
      Globals.isLogin = true;

      // Fetch userMetaData for loggedin user.
      // Get user episodes data from DB.
      var userMetaData = await getUserData(Globals.userEmail);
      Globals.userMetaData = userMetaData;

      emit(GoogleAuthenticationSuccess(googleUser));
    } catch (e) {
      emit(GoogleAuthenticationFaliure());
    }
  }

  Future<void> _handleSignOut(SignOutEvent event, Emitter<GoogleAuthenticationState> emit) async {
    await _googleSignIn.signOut();

    // Delete user from hive local storage.
    await Globals.userLoginService?.deleteUserDetails(Globals.userEmail);

    // Reset username, email and isLogin status.
    Globals.userEmail = "";
    Globals.userName = "Reader";
    Globals.isLogin = false;
    Globals.userMetaData = {};

    emit(GoogleAuthenticationInitial());
  }
}
