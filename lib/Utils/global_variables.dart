import 'package:binge_read/services/user_app_data_service.dart';
import 'package:binge_read/services/user_login_service.dart';
import 'package:logger/logger.dart';

class Globals {
  static bool isLogin = false;
  static String userName = "Reader";
  static String userEmail = "";
  static UserLoginService? userLoginService;
  static UserAppDataService? userAppDataService;
  static Map<String, int> seriesReadCount = {};
  static String userDisplayName = "";
  static String profilePictureUrl = "";
}

final Logger logger = Logger();
