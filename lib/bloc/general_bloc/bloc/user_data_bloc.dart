import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  UserDataBloc() : super(UserDataInitial()) {
    on<UserDetailsEvent>((event, emit) {
      UserDetailsState state =
          UserDetailsState(userName: event.userName, userEmail: event.userEmail, imageUrl: event.imageUrl);
      emit(state);
    });
  }
}
