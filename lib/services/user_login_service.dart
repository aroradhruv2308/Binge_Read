import 'package:binge_read/models/user.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class UserLoginService {
  late Box<User> _userDetails;

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    Hive.registerAdapter(UserAdapter());

    _userDetails = await Hive.openBox<User>('userDetails');
    print(_userDetails);
  }

  Future<User?> getUserDetails() async {
    if (_userDetails.isNotEmpty) {
      // Retrieve the first user details in the box
      final user = _userDetails.values.first;
      return user;
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

  Future<void> dispose() async {
    await _userDetails.close();
  }
}
