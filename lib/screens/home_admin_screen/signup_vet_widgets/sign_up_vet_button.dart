import 'package:flutter/material.dart';
import 'package:flutter_finey/screens/common_widgets/rectangle_button.dart';
import 'package:flutter_finey/screens/common_widgets/rectangle_button_vet.dart';
import 'package:flutter_finey/styles/common_variables.dart';

class SignUpVetButton extends StatelessWidget {
  SignUpVetButton(@required this.handleCadastro);

  final Function handleCadastro;

  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      RectangleButtonVetWidget(
          isFullWidth: true,
          text: "CADASTRAR",
          btnWidth: CommonVariables.defaultBtnWidth,
          btnHeight: CommonVariables.defaultBtnHeight,
          onPressed: this.handleCadastro),
    ]);
  }
}
