import 'package:binge_read/db/appDto.dart';
import 'package:binge_read/firebase_options.dart';
import 'package:binge_read/screens/episode_reader_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:binge_read/services/user_login_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/build_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and provide a path to store the box
  await Hive.initFlutter();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await Firebase.initializeApp(
    name: 'binge_read',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeApp();
  runApp(MyApp());
}

Future<void> initializeApp() async {
  UserLoginService userLoginService = UserLoginService();
  await userLoginService.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Once the future has completed successfully
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: MainScreen(index: 0),
      home: MyHtmlScreen(),
    );
  }
}
