import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String userEmail;
  @HiveField(1)
  final String userId;

  User(this.userEmail, this.userId);
}

@HiveType(typeId: 2)
class AppData {
  @HiveField(0)
  final Map<String, int> seriesReadCount;

  AppData(this.seriesReadCount);
}
