import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../Utils/global_variables.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  String userName = "Reader";
  String userEmail = "";
  String avatarURL = Globals.defaultProfilePicAssetPath;

  UserDataBloc() : super(UserDataInitial());
}
