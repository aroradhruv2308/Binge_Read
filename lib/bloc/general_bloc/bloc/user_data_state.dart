part of 'user_data_bloc.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();
}

class UserDataInitial extends UserDataState {
  @override
  List<Object> get props => [];
}

class UserDetailsState extends UserDataState {
  String userName = "";
  String userEmail = "";
  String imageUrl = "";
  UserDetailsState({required this.userName, required this.userEmail, required this.imageUrl});
  @override
  List<Object> get props => [this.userName, this.userEmail, this.imageUrl];
}

class BookMarkDetailsState extends UserDataState {
  @override
  List<Object> get props => [];
}
