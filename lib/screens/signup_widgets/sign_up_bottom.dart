import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../../config/application.dart';
import '../../config/routes.dart';
import '../common_widgets/link_button.dart';
import '../../styles/common_styles.dart';

class SignUpBottom extends StatelessWidget {
  SignUpBottom();

  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      new Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: new Text("Possui uma conta?",
              style: new TextStyle(
              fontSize: 25.0,
              color: Colors.black,
              ),
          )
      ),
      LinkButtonWidget(
          text: "Entrar",
          onTap: () {
            Application.router.navigateTo(context, RouteConstants.ROUTE_LOGIN, transition: TransitionType.fadeIn);
          })

    ]);
  }
}
