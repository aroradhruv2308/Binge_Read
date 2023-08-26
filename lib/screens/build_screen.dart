// ignore_for_file: must_be_immutable

import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/components/custom_navbar.dart';
import 'package:binge_read/screens/bookmark_screen.dart';
import 'package:binge_read/screens/explore_screen.dart';
import 'package:binge_read/screens/home_page.dart';
import 'package:binge_read/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  int index = 0;
  MainScreen({super.key, this.index = 0});

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
        screen = const ExplorePage();
        break;
      case 2:
        screen = BookmarkPage(
          bookmarkItems: [],
        );
        break;
      default:
        screen = const ProfileScreen();
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
