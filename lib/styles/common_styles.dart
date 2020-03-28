import 'package:flutter/material.dart';

import './common_colors.dart';
import './common_variables.dart';

class CommonStyles {
  CommonStyles({this.context});

  BuildContext context;

  // Text
  TextStyle getLinkText() {
    return TextStyle(
        color: CommonColors.blue,
        fontSize: CommonVariables(context: context).getSmallFontSize(),
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.normal);
  }

  TextStyle getHeaderText() {
    return TextStyle(
        color: CommonColors.black,
        fontSize: CommonVariables(context: context).getNormalFontSize(),
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.w600);
  }

  TextStyle getHeaderTextButton() {
    return TextStyle(
        color: CommonColors.blue,
        fontSize: CommonVariables(context: context).getNormalFontSize(),
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.normal);
  }

  TextStyle getLabelText() {
    return TextStyle(
        color: CommonColors.gray,
        fontSize: CommonVariables(context: context).getNormalFontSize(),
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.normal);
  }

  TextStyle getBlackNormalText() {
    return TextStyle(
        color: CommonColors.black,
        fontSize: CommonVariables(context: context).getNormalFontSize(),
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.normal);
  }

  TextStyle getDarkGrayNormalText() {
    return TextStyle(
        color: CommonColors.darkGray,
        fontSize: CommonVariables(context: context).getNormalFontSize(),
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.normal);
  }

  TextStyle getDarkGrayNormalSemiBoldText() {
    return TextStyle(
        color: CommonColors.darkGray,
        fontSize: CommonVariables(context: context).getNormalFontSize(),
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.w600);
  }

  TextStyle getGrayNormalText() {
    return TextStyle(
        color: CommonColors.gray,
        fontSize: CommonVariables(context: context).getNormalFontSize(),
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.normal);
  }

  TextStyle getGraySmallText() {
    return TextStyle(
        color: CommonColors.gray,
        fontSize: CommonVariables(context: context).getSmallFontSize(),
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.normal);
  }

  TextStyle getSplashLogoText() {
    return TextStyle(
        color: CommonColors.black,
        fontSize: 48.0,
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.bold);
  }

  TextStyle getBlueNormalText() {
    return TextStyle(
        color: CommonColors.blue,
        fontSize: CommonVariables(context: context).getNormalFontSize(),
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.normal);
  }

  TextStyle getWhiteNormalText() {
    return TextStyle(
        color: CommonColors.white,
        fontSize: CommonVariables(context: context).getNormalFontSize(),
        fontFamily: CommonVariables.defaultFont,
        fontWeight: FontWeight.normal);
  }

  // Box Shadow
  BoxDecoration getBoxShadow() {
    return const BoxDecoration(color: Colors.white, boxShadow: [
      const BoxShadow(
        color: Colors.black12,
        blurRadius: 10.0,
      )
    ]);
  }

  // Box Shadow
  BoxDecoration getFormShadow() {
    return const BoxDecoration(boxShadow: [
      const BoxShadow(
          color: Colors.black12, blurRadius: 4.0, offset: Offset(0.0, 0.0))
    ]);
  }
}
