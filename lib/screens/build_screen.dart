import 'package:binge_read/components/custom_navbar.dart';
import 'package:binge_read/screens/explore_screen.dart';
import 'package:binge_read/screens/home_page.dart';
import 'package:binge_read/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  int index = 0;
  MainScreen({this.index = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (widget.index) {
      case 0:
        screen = const HomePage();
        break;
      case 1:
        screen = ExplorePage();
        break;
      case 2:
        screen = Container();
        break;
      default:
        screen = ProfileScreen();
        break;
    }

    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        index: widget.index,
        onItemTapped: (int selectedIndex) {
          setState(() {
            widget.index = selectedIndex;
          });
        },
      ),
      body: screen,
    );
  }
}
