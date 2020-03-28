import 'package:flutter/material.dart';

class CommonVariables {
  static double defaultHeight = 812.0;
  static double defaultWidth = 375.0;
  static double largeDeviceWidth = 768.0;
  static double defaultBtnHeight = 48.0;
  static double defaultBtnWidth = 295.0;
  static String defaultFont = "SanFransisco";

  double deviceWidth;
  double deviceHeight;

  CommonVariables({this.context}) {
    this.deviceWidth = MediaQuery.of(context).size.width;
    this.deviceHeight = MediaQuery.of(context).size.height;
  }

  final BuildContext context;

  double getSmallFontSize() {
    double fontSize = 14.0;
    if (deviceWidth >= largeDeviceWidth) {
      fontSize = fontSize * 1.3;
    }

    return fontSize;
  }

  double getNormalFontSize() {
    double fontSize = 16.0;
    if (deviceWidth >= largeDeviceWidth) {
      fontSize = fontSize * 1.3;
    }

    return fontSize;
  }

  double getMediumFontSize() {
    double fontSize = 18.0;
    if (deviceWidth >= largeDeviceWidth) {
      fontSize = fontSize * 1.3;
    }

    return fontSize;
  }

  double getLargeFontSize() {
    double fontSize = 24.0;
    if (deviceWidth >= largeDeviceWidth) {
      fontSize = fontSize * 1.3;
    }

    return fontSize;
  }

  double getAppBarHeight() {
    double barHeight = 64.0;

    // if device is iphone X
    if (deviceHeight >= defaultHeight && deviceWidth < largeDeviceWidth) {
      barHeight = 88.0;
    }

    // if device is large device
    if (deviceWidth >= largeDeviceWidth) {
      barHeight = barHeight * 1.3;
    }

    return barHeight;
  }

  double getAppBarPaddingTop() {
    double barPaddingTop = 20.0;
    // if device is iphone X
    if (deviceHeight >= defaultHeight && deviceWidth < largeDeviceWidth) {
      barPaddingTop = 44.0;
    }

    return barPaddingTop;
  }

  double getScreenPaddingBottom() {
    double paddingBottom = 0.0;
    // if device is iphone X
    if (deviceHeight >= defaultHeight && deviceWidth < largeDeviceWidth) {
      paddingBottom = 21.0;
    }

    return paddingBottom;
  }

  double getHorizontalPad(horizontalPad) {
    return horizontalPad * (deviceWidth / defaultWidth);
  }
}
