import 'package:flutter/material.dart';

import '../common_widgets/rectangle_button.dart';
import '../../styles/common_variables.dart';

class CartaoCreditoButton extends StatelessWidget {
  CartaoCreditoButton(@required this.handleCadastro);

  final Function handleCadastro;

  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      RectangleButtonWidget(
          isFullWidth: true,
          text: "REALIZAR PAGAMENTO",
          btnWidth: CommonVariables.defaultBtnWidth,
          btnHeight: CommonVariables.defaultBtnHeight,
          onPressed: this.handleCadastro),
    ]);
  }
}
