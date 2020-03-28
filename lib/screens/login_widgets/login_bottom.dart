import 'package:flutter/material.dart';

import '../common_widgets/link_button.dart';
import '../../styles/common_styles.dart';

class LoginBottom extends StatelessWidget {
  LoginBottom({@required this.handleSignUp});

  final Function handleSignUp;

  Widget build(BuildContext context) {
    return Container(
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        new Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: new Text("Não possui uma conta?",
                style: CommonStyles(context: context).getBlackNormalText())),
        LinkButtonWidget(text: "Criar Conta", onTap: this.handleSignUp)
      ]),
    );
  }
}
