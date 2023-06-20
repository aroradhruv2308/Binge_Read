import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/bloc/general_bloc/bloc/user_data_bloc.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:binge_read/firebase_options.dart';
import 'package:binge_read/models/user.dart';
import 'package:binge_read/screens/episode_reader_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.initFlutter(appDocumentDir.path);

  await initializeApp();

  runApp(MyApp());
}

Future<void> initializeApp() async {
  await Firebase.initializeApp(
    name: 'binge_read',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Globals.userLoginService = UserLoginService();
  await Globals.userLoginService?.init();
  User? userDetails = await Globals.userLoginService?.getUserDetails();
  if (userDetails != null) {
    Globals.userName = userDetails.userId;
    Globals.userEmail = userDetails.userEmail;
    print("details aggyi benchooo");
  } else {
    print("abhi tak to shi lagrha hai");
  }
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void dispose() {
    Globals.userLoginService?.dispose();
    super.dispose(); // Close the Hive box
  }

  @override
  Widget build(BuildContext context) {
    // Once the future has completed successfully
<<<<<<< HEAD
    return MultiBlocProvider(
      providers: [BlocProvider<UserDataBloc>(create: (context) => UserDataBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(index: 0),
        // home: MyHtmlScreen(),
      ),
=======
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(index: 0),
      // home: MyHtmlScreen(),
>>>>>>> f2303be999d5f5ba56e59e74000e33d2c03ff941
    );
  }
}
