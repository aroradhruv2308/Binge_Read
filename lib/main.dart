import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/bloc/general_bloc/bloc/user_data_bloc.dart';
import 'package:binge_read/firebase_options.dart';
import 'package:binge_read/models/user.dart';
import 'package:binge_read/services/user_app_data_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:binge_read/services/user_login_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

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

  // Initializing Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Register Hive Adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(AppDataAdapter());

  // Create user services.
  Globals.userLoginService = UserLoginService();
  Globals.userAppDataService = UserAppDataService();
  await Globals.userLoginService?.init();
  await Globals.userAppDataService?.init();
  User? userDetails = await Globals.userLoginService?.getUserDetails();

  if (userDetails != null) {
    Globals.userName = userDetails.userId;
    Globals.userEmail = userDetails.userEmail;
    Globals.isLogin = true;
  }

  // Update total view count of series data from last
  // session. This can happen if user visited some episodes
  // for less than threshold time (20 secs) and closed the app.
  // Then we update the counts in next session when user
  // opens the app again, till then the counts are stored in
  // local storage.
  await Globals.userAppDataService?.batchUpdateReadCounts();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    // Once the future has completed successfully
    return MultiBlocProvider(
      providers: [BlocProvider<UserDataBloc>(create: (context) => UserDataBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(index: 0),
      ),
    );
  }
}
