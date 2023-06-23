import 'package:binge_read/services/user_login_service.dart';
import 'package:logger/logger.dart';

class Globals {
  static bool isLogin = false;
  static String userName = "Reader";
  static String userEmail = "not present";
  static UserLoginService? userLoginService;
}

final Logger logger = Logger();
