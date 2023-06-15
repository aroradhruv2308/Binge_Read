import 'package:binge_read/models/user.dart';
import 'package:hive/hive.dart';

class UserLoginService {
  late Box<User> _userDetails;

  Future<void> init() async {
    Hive.registerAdapter(UserAdapter());
    _userDetails = await Hive.openBox<User>('userDetails');
  }

  Future<User?> getUserDetails(String key) async {
    if (_userDetails.containsKey(key)) {
      return _userDetails.get(key);
    }

    return null;
  }

  Future<void> addUserDetails(String key, User user) async {
    await _userDetails.put(key, user);
  }

  Future<void> updateUserDetails(String key, User updatedUser) async {
    if (_userDetails.containsKey(key)) {
      await _userDetails.put(key, updatedUser);
    }
  }
}
