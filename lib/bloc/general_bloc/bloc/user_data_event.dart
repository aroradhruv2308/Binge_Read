// ignore_for_file: must_be_immutable

part of 'user_data_bloc.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();
}

// Event to update username. This event is called if user edits
// username from profile section.
class UserNameUpdateEvent extends UserDataEvent {
  // By default username will be Reader. (This is shown if
  // user is using app without logging in.)
  String userName = "Reader";

  UserNameUpdateEvent({required this.userName});

  @override
  List<Object?> get props => [userName];
}

// Event to update app data when user login the app.
class UserDataUpdateEvent extends UserDataEvent {
  String userName = "Reader";
  String userEmail = "";
  String avatarURL = Globals.defaultProfilePicAssetPath;
  bool isLogin = false;

  UserDataUpdateEvent(
      {required this.userName, required this.userEmail, required this.avatarURL, required this.isLogin});

  @override
  List<Object?> get props => [userName, userEmail, avatarURL, isLogin];
}

// Event to update user app related meta data. For instance episodes read
// percentage, bookmarks etc.
// class UserMetaDataUpdateEvent extends UserDataEvent {
//   Map<String, dynamic>? userMetaData = {};
// }
