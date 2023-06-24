import 'package:binge_read/services/user_login_service.dart';
import 'package:logger/logger.dart';

class Globals {
  static bool isLogin = false;
  static String userName = "Reader";
  static String userEmail = "not present";
  static UserLoginService? userLoginService;
  static Map<String, int> seriesReadCount = {};
}

final Logger logger = Logger();
