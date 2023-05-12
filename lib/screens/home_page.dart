import 'package:binge_read/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeScreenBloc homeScreenBloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeScreenBloc = HomeScreenBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Test'),
      ),
      body: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        bloc: homeScreenBloc,
        builder: (context, state) {
          if (state is HomeScreenInitial) {
            return Container(
              color: Colors.blueAccent,
              child: Center(child: Text("Splash Screen")),
            );
          }
          return Container(
            color: Colors.redAccent,
            child: Center(child: Text("Home Screen")),
          );
        },
      ),
    );
  }
}
