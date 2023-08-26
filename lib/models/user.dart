import 'package:binge_read/models/models.dart';
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String userEmail;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String imageUrl;

  User(this.userEmail, this.userId, this.imageUrl);
}

@HiveType(typeId: 2)
class AppData {
  @HiveField(0)
  final Map<String, int> seriesReadCount;
  @HiveField(1)
  final List<Pair<String, dynamic>> bookmarkItems;

  AppData(this.seriesReadCount, this.bookmarkItems);
}
