// ignore_for_file: unnecessary_import

import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserLoginService {
  late Box<User> _userDetails;

  Future<void> init() async {
    _userDetails = await Hive.openBox<User>('userDetails');
    if (kDebugMode) {
      print(_userDetails);
    }
  }

  Future<User?> getUserDetails() async {
    if (_userDetails.isNotEmpty) {
      // Retrieve the first user details in the box
      final user = _userDetails.values.first;
      return user;
    }
    return null;
  }

  // TODO: Check later.
  Future<List<dynamic>> getBookmarkItems() async {
    return [];
  }

  Future<void> addUserDetails(String key, User user) async {
    await _userDetails.put(key, user);
  }

  Future<void> deleteUserDetails(String key) async {
    await _userDetails.delete(key);
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
