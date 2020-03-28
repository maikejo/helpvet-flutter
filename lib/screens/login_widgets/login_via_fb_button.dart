import 'package:flutter/material.dart';

import '../common_widgets/rectangle_icon_button.dart';
import '../../styles/common_colors.dart';
import '../../styles/common_variables.dart';

class LoginViaFbButton extends StatelessWidget {
  LoginViaFbButton({this.onPress});

  final Function onPress;

  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      RectangleIconButtonWidget(
          isFullWidth: true,
          isLeftIcon: true,
          bgColor: CommonColors.facebook,
          text: "Sign In with Facebook",
          btnIcon: Icons.arrow_forward,
          btnWidth: CommonVariables.defaultBtnWidth,
          btnHeight: CommonVariables.defaultBtnHeight,
          onPressed: this.onPress)
    ]);
  }
}
