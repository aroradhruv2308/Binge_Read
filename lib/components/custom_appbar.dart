import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/Utils/util_functions.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final String leadingElement;
  final String middleElement;
  final String trailingElement;
  const CustomAppBar({
    super.key,
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
    String userName = capitalizeWords(widget.middleElement);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.cyan,
              shape: BoxShape.circle,
              image: Globals.isLogin
                  ? DecorationImage(
                      image: NetworkImage(Globals.profilePictureUrl),
                      fit: BoxFit.contain,
                    )
                  : DecorationImage(
                      image: AssetImage(Globals.defaultProfilePicAssetPath),
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        ),
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
      ],
    );
  }
}
