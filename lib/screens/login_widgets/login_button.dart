import 'package:flutter/material.dart';
import '../common_widgets/rectangle_icon_button.dart';
import '../common_widgets/link_button.dart';
import '../../styles/common_variables.dart';

class LoginButton extends StatelessWidget {
  LoginButton({
    @required this.handleForgotPassword,
    @required this.handleLogin,
  });

  final Function handleForgotPassword;
  final Function handleLogin;

  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          LinkButtonWidget(
              text: "Esqueceu a senha?", onTap: this.handleForgotPassword),
          RectangleIconButtonWidget(
              isLeftIcon: false,
              text: "ENTRAR",
              btnIcon: Icons.arrow_forward,
              btnWidth: 170.0,
              btnHeight: CommonVariables.defaultBtnHeight,
              onPressed: (this.handleLogin)),
        ]);
  }
}
