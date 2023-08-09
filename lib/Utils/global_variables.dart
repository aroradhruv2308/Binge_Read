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
  static Map<String, dynamic>? userMetaData = {};
  static String userDisplayName = "";
  static String profilePictureUrl = "";
  static String defaultProfilePicAssetPath = "images/default-profile-pic.jpg";
  static bool isLightMode = false;
}

final Logger logger = Logger();
