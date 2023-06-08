import 'package:binge_read/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class BottomNavBar extends StatefulWidget {
  int index;
  Function onItemTapped;
  BottomNavBar({this.index = 0, required this.onItemTapped});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor, // Set your desired dark color here
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      height: 64,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(LineIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.compass),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.user),
            label: 'Profile',
          ),
        ],
        currentIndex: widget.index,
        onTap: (value) {
          widget.onItemTapped(value);
        },
        backgroundColor: AppColors.navBarColor, // Set the same dark color here
        selectedItemColor:
            AppColors.glowGreen, // Set your desired selected item color
        unselectedItemColor:
            Colors.grey, // Set your desired unselected item color
      ),
    );
  }
}
