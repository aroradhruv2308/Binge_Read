import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/bloc/general_bloc/bloc/user_data_bloc.dart';
import 'package:binge_read/firebase_options.dart';
import 'package:binge_read/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:binge_read/services/user_login_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'db/query.dart';
import 'screens/build_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const MyApp());
}

Future<void> initializeApp() async {
  await Firebase.initializeApp(
    name: 'binge_read',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create userLogin service.
  Globals.userLoginService = UserLoginService();
  await Globals.userLoginService?.init();
  User? userDetails = await Globals.userLoginService?.getUserDetails();

  if (userDetails != null) {
    Globals.userName = userDetails.userId;
    Globals.userEmail = userDetails.userEmail;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of the application.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose(); // Close the Hive box
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Update the read counts if app is being paused, this
      // can happen when users opens another app and put the
      // app in recents.
      updateViewCountsInFirestore();
    }
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
