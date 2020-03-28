import 'package:flutter/material.dart';

import '../common_widgets/rectangle_icon_button.dart';
import '../../styles/common_variables.dart';
import '../../styles/common_colors.dart';

class SignUpViaFbButton extends StatelessWidget {
  SignUpViaFbButton({this.onPress});

  final Function onPress;

  Widget build(BuildContext context) {
    return Center(
        child: RectangleIconButtonWidget(
            isFullWidth: true,
            isLeftIcon: true,
            bgColor: CommonColors.facebook,
            text: "Sign Up with Facebook",
            btnIcon: Icons.arrow_forward,
            btnWidth: CommonVariables.defaultBtnWidth,
            btnHeight: CommonVariables.defaultBtnHeight,
            onPressed: this.onPress));
  }
}
