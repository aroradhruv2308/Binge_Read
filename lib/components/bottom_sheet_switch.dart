import 'package:flutter/material.dart';

import '../Utils/constants.dart';
import '../Utils/global_variables.dart';

class BottomSheetSwitch extends StatefulWidget {
  final bool switchValue;
  final ValueChanged valueChanged;
  final currentMultiplierIndex;

  Function fontSizeMultiplierChange;

  BottomSheetSwitch(
      {super.key,
      required this.switchValue,
      required this.valueChanged,
      required this.currentMultiplierIndex,
      required this.fontSizeMultiplierChange});

  @override
  State<BottomSheetSwitch> createState() => _BottomSheetSwitchState();
}

class _BottomSheetSwitchState extends State<BottomSheetSwitch> {
  late bool _switchValue;

  // All the values in the array will be fontSize/12.
  final List<double> values = [0.71, 0.86, 1, 1.14, 1.28];
  late int selectedIndex;

  @override
  void initState() {
    _switchValue = widget.switchValue;
    selectedIndex = widget.currentMultiplierIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _switchValue ? AppColors.whiteColor : AppColors.backgroundColor,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Font Size',
              style: TextStyle(
                color: _switchValue ? AppColors.darkGreyColor : AppColors.greyColor,
                fontFamily: 'Lexend',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Aa',
                    style: TextStyle(
                      fontSize: SizeConstants.twelvePixel,
                      fontFamily: 'Lexend',
                      color: !_switchValue ? AppColors.whiteColor : AppColors.backgroundColor,
                      fontWeight: FontWeight.bold, // Your desired font weight
                    ),
                  ),
                  Slider(
                    activeColor: _switchValue ? AppColors.backgroundColor : AppColors.whiteColor,
                    value: selectedIndex.toDouble(),
                    min: 0,
                    max: values.length - 1,
                    divisions: values.length - 1,
                    onChanged: (double value) {
                      setState(() {
                        selectedIndex = value.toInt();

                        // Call parent fontSize change function to
                        // change the fontSize in parent screen.
                        widget.fontSizeMultiplierChange(value.toInt(), values[value.toInt()]);
                      });
                    },
                  ),
                  Text(
                    'Aa',
                    style: TextStyle(
                      fontSize: SizeConstants.eighteenPixel,
                      fontFamily: 'Lexend',
                      color: !_switchValue ? AppColors.whiteColor : AppColors.backgroundColor,
                      fontWeight: FontWeight.bold, // Your desired font weight
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Theme',
              style: TextStyle(
                color: _switchValue ? AppColors.darkGreyColor : AppColors.greyColor,
                fontFamily: 'Lexend',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Light Mode",
                  style: TextStyle(
                    fontSize: SizeConstants.fourteenPixel,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold,
                    color: _switchValue ? AppColors.backgroundColor : AppColors.whiteColor,
                  ),
                ),
                Switch(
                  value: _switchValue,
                  activeColor: _switchValue ? AppColors.backgroundColor : AppColors.whiteColor,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue = value;
                      widget.valueChanged(value);
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
