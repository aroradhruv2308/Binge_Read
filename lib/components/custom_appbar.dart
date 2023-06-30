import 'package:binge_read/Utils/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  String leadingElement;
  String middleElement;
  String trailingElement;
  CustomAppBar({
    Key? key,
    this.trailingElement = "",
    this.middleElement = "",
    this.leadingElement = "",
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    String userName = widget.middleElement;
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              width: 60, // Adjust the width and height according to your preference
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.cyan,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('images/anime_avatar2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            )),
        // Add spacing between elements
        Expanded(
          flex: 6,
          child: Text(
            'Hello $userName',
            style: const TextStyle(
                fontSize: SizeConstants.eighteenPixel,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(border: Border.all(color: AppColors.glowGreen), shape: BoxShape.circle),
            child: const Icon(
              Icons.notifications_rounded,
              color: AppColors.glowGreen,
            ),
          ),
        ),
      ],
    );
  }
}
