import 'package:flutter/material.dart';

import '../../config/application.dart';
import '../../config/routes.dart';
import '../common_widgets/link_button.dart';
import '../../styles/common_styles.dart';

class ForgotPasswordBottom extends StatelessWidget {
  ForgotPasswordBottom();

  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      new Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: new Text("Não possuiu uma conta?",
              style: CommonStyles(context: context).getBlackNormalText())),
      LinkButtonWidget(
          text: "Cadastrar",
          onTap: () {
            Application.router
                .navigateTo(context, RouteConstants.ROUTE_SIGN_UP);
          })
    ]);
  }
}
