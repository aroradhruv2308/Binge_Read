import 'package:flutter/material.dart';

import '../Utils/constants.dart';

class BottomSheetSwitch extends StatefulWidget {
  final bool switchValue;
  final ValueChanged valueChanged;

  const BottomSheetSwitch({super.key, required this.switchValue, required this.valueChanged});

  @override
  State<BottomSheetSwitch> createState() => _BottomSheetSwitchState();
}

class _BottomSheetSwitchState extends State<BottomSheetSwitch> {
  late bool _switchValue;

  @override
  void initState() {
    _switchValue = widget.switchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _switchValue ? AppColors.whiteColor : AppColors.backgroundColor,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 32.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Theme',
              style: TextStyle(
                color: _switchValue ? AppColors.darkGreyColor : AppColors.greyColor,
                fontFamily: 'Lexend',
              ),
            ),
            const SizedBox(
              height: 4,
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
