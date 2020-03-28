import 'package:flutter/material.dart';

import '../external_widgets/verify_input/verify_input.dart';
import './common_widgets/finey_header.dart';
import './common_widgets/responsive_padding.dart';
import './common_widgets/title.dart';
import './common_widgets/link_button.dart';
import '../styles/common_variables.dart';
import '../styles/common_styles.dart';
import '../styles/common_colors.dart';

class VerifyCodeScreen extends StatefulWidget {
  VerifyCodeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _VerifyCodeScreenState createState() => new _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen>
    implements InputProtocol {
  void didFinished(VerifyInput verifyInput, BuildContext ctx, String verCode) {
    print("verCode is $verCode");
  }

  Widget _verifyCode(BuildContext context) {
    Options opt = Options(
        fontSize: 24.0,
        fontColor: CommonColors.black,
        fontWeight: FontWeight.normal,
        emptyUnderLineColor: CommonColors.gray,
        inputedUnderLineColor: CommonColors.blue);
    return VerifyInput(
        codeLength: 6, size: Size(300.0, 48.0), options: opt, delegate: this);
  }

  Widget _buildWithConstraints(
      BuildContext context, BoxConstraints constraints) {
    double deviceHeight = MediaQuery.of(context).size.height;

    var column = new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FineyHeader(
              leftImageIconButton: "images/icons/ic_back.png",
              leftImageIconButtonWidth: 24.0,
              leftImageIconButtonHeight: 17.0,
              onPressLeftButton: () {
                Navigator.of(context).pop();
              }),
          new Container(
              height: deviceHeight -
                  CommonVariables(context: context).getAppBarHeight() -
                  CommonVariables(context: context).getScreenPaddingBottom(),
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TitleWidget(
                        text: 'Verificar Codigo',
                        paddingTop: 96.0,
                        paddingLeft: 40.0,
                        paddingRight: 40.0,
                        paddingBottom: 0.0),
                    ResponsivePadding(
                        padding: const EdgeInsets.only(
                            right: 40.0, left: 40.0, top: 16.0, bottom: 66.0),
                        child: Text(
                            "Não se preocupe, escolha o método que deseja recuperar sua senha",
                            style: CommonStyles(context: context)
                                .getGrayNormalText())),
                    ResponsivePadding(
                      padding: const EdgeInsets.only(
                          right: 40.0, left: 40.0, top: 16.0, bottom: 66.0),
                      // child: _verifyCode(context)
                      child:
                          Container(height: 100.0, child: _verifyCode(context)),
                    ),
                    Center(
                        child: LinkButtonWidget(
                            text: "Enviar novamente",
                            onTap: () {
                              // Application.router.navigateTo(context, RouteConstants.ROUTE_LOGIN);
                            }))
                  ]))
        ]);

    var constrainedBox = new ConstrainedBox(
      constraints:
          constraints.copyWith(maxHeight: MediaQuery.of(context).size.height),
      child: new Container(
          color: Colors.white,
          padding: EdgeInsets.only(
              bottom:
                  CommonVariables(context: context).getScreenPaddingBottom()),
          child: column),
    );

    var scrollView = new SingleChildScrollView(child: constrainedBox);

    return scrollView;
  }

  @override
  Widget build(BuildContext context) {
    var layoutBuilder = new LayoutBuilder(builder: _buildWithConstraints);

    var scaffold = new Scaffold(body: layoutBuilder);

    return scaffold;
  }
}
