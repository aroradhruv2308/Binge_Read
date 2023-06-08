import 'package:binge_read/Utils/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("BINGE READ",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: SizeConstants.twentyFourPixel,
          )),
    );
  }
}
