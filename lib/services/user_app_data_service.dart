import 'package:binge_read/models/user.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class UserAppDataService {
  late Box<AppData> _userAppData;

  Future<void> init() async {
    _userAppData = await Hive.openBox<AppData>('userAppData');
  }

  Future<void> dispose() async {
    await _userAppData.close();
  }
}
