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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyColor),
              shape: BoxShape.circle),
          child: const Icon(
            Icons.menu_rounded,
            color: AppColors.darkGreyColor,
          ),
        ), // Add spacing between elements
        const Text(
          'App Title',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGreyColor),
        ),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyColor),
              shape: BoxShape.circle),
          child: const Icon(
            Icons.notifications_rounded,
            color: AppColors.darkGreyColor,
          ),
        ),
      ],
    );
  }
}
