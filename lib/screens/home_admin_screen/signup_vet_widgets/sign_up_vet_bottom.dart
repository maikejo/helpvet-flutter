import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/screens/common_widgets/link_button.dart';
import 'package:flutter_finey/styles/common_styles.dart';

class SignUpVetBottom extends StatelessWidget {
  SignUpVetBottom();

  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      new Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: new Text("Possui uma conta?",
              style: CommonStyles(context: context).getBlackNormalText())),
      LinkButtonWidget(
          text: "Entrar",
          onTap: () {
            Application.router.navigateTo(context, RouteConstants.ROUTE_LOGIN,
                transition: TransitionType.fadeIn);
          })
    ]);
  }
}
