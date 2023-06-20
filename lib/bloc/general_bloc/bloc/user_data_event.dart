part of 'user_data_bloc.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();
}

class UserDetailsEvent extends UserDataEvent {
  String userName = "";
  String userEmail = "";
  String imageUrl = "";
  UserDetailsEvent({required this.userName, required this.userEmail, required this.imageUrl});
  @override
  List<Object> get props => [this.userName, this.userEmail, this.imageUrl];
}
