import 'package:flutter/material.dart';
import '../../styles/common_variables.dart';
import '../../styles/common_colors.dart';

class RectangleButtonVetWidget extends StatelessWidget {
  RectangleButtonVetWidget({
    this.isFullWidth,
    this.bgColor,
    this.textColor,
    @required this.text,
    @required this.btnWidth,
    @required this.btnHeight,
    @required this.onPressed,
  });

  final bool isFullWidth;
  final Color bgColor;
  final Color textColor;
  final String text;
  final double btnWidth;
  final double btnHeight;
  final Function onPressed;

  double _getWidth(context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var btnWidth = this.btnWidth;

    if (deviceWidth >= CommonVariables.largeDeviceWidth) {
      if (this.isFullWidth == true) {
        btnWidth = btnWidth * (deviceWidth / CommonVariables.defaultWidth);
      } else {
        btnWidth = btnWidth * 1.3;
      }
    } else {
      btnWidth = btnWidth * (deviceWidth / CommonVariables.defaultWidth);
    }

    return btnWidth;
  }

  double _getHeight(context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var btnHeight = this.btnHeight;
    if (deviceWidth >= CommonVariables.largeDeviceWidth) {
      btnHeight = btnHeight * 1.3;
    }

    return btnHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _getWidth(context),
        height: _getHeight(context),
        decoration: new BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Color(0XFFF92B7F),
              ],
            ),
            borderRadius: const BorderRadius.all(const Radius.circular(6.0)),
            color: bgColor ?? CommonColors.blue),
        child: FlatButton(
            onPressed: onPressed,
            child: Center(
                child: Text(text,
                    style: TextStyle(
                        fontSize: CommonVariables(context: context)
                            .getNormalFontSize(),
                        fontFamily: CommonVariables.defaultFont,
                        color: textColor ?? Colors.white,
                        fontWeight: FontWeight.normal)))));
  }
}
