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
    Globals.isLogin = true;
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
    return MultiBlocProvider(
      providers: [BlocProvider<UserDataBloc>(create: (context) => UserDataBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(index: 0),
        // home: MyHtmlScreen(),
      ),
    );
  }
}
