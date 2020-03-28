import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/screens/widgets/generic/animated_text_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/application.dart';
import '../config/routes.dart';
import './common_widgets/title.dart';
import './common_widgets/finey_header.dart';
import './common_widgets/responsive_padding.dart';
import './forgot_password_widgets/forgot_password_bottom.dart';
import './forgot_password_widgets/active_account.dart';
import '../styles/common_variables.dart';
import '../styles/common_styles.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ForgotPasswordScreenState createState() => new _ForgotPasswordScreenState();
}



class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final _emailController = TextEditingController();
  Interval _nameTextFieldLoadingAnimationInterval;
  AnimationController _loadingController;
  var _authData = {'email': '', 'password': ''};

  @override
  void initState() {
    super.initState();
    _nameTextFieldLoadingAnimationInterval = const Interval(0, .85);
  }

  @override
  Future<void> resetarSenha(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    _showDialogAlteracaoSenha();
  }

  void _showDialogAlteracaoSenha() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Recuperar senha"),
          content: new Text("Foi enviado um email para alterar sua senha."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Application.router.navigateTo(context, RouteConstants.ROUTE_LOGIN,
                    clearStack: true,
                    replace: true,
                    transition: TransitionType.inFromBottom);
                ;
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildWithConstraints(BuildContext context, BoxConstraints constraints) {
    double deviceHeight = MediaQuery.of(context).size.height;

    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = min(deviceSize.width * 0.75, 360.0);
    const cardPadding = 16.0;
    final textFieldWidth = cardWidth - cardPadding * 2;


    var column =
        new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TitleWidget(
                          text: 'Esqueceu a Senha',
                          paddingTop: 96.0,
                          paddingLeft: 40.0,
                          paddingRight: 40.0,
                          paddingBottom: 0.0),
                      ResponsivePadding(
                          padding: const EdgeInsets.only(
                              right: 40.0, left: 40.0, top: 16.0, bottom: 66.0),
                          child: Text(
                              "Não se preocupe, informe seu email que foi feito o cadastro para recuperar sua senha.",
                              style: CommonStyles(context: context)
                                  .getGrayNormalText())),

                      /* ResponsivePadding(
                          padding: const EdgeInsets.only(
                              left: 40.0, right: 40.0, bottom: 40.0),
                          child: ActiveAccount(
                              labelText: "Digite o Email",
                              value: "******xyz@gmail.com",
                              icon: "images/icons/ic_mail.png",
                              iconWidth: 34.0,
                              iconHeight: 24.0,
                              onPressItem: () {
                              *//*  Application.router.navigateTo(
                                    context, RouteConstants.ROUTE_VERIFY_CODE);*//*
                              })),*/

                      ResponsivePadding(
                          padding: const EdgeInsets.only(
                              left: 40.0, right: 40.0, bottom: 40.0),
                              child: TextFormField(
                              style: new TextStyle(color: Color(0xFF162A49),fontWeight: FontWeight.bold,fontSize: 16),
                              controller: _emailController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email, color: Color(0xFF162A49)),
                                  filled: true,
                                  fillColor: Colors.indigo[100],
                                  hintStyle: TextStyle(color: Color(0xFF162A49)),
                                  hintText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                /*  focusedBorder:OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),*/


                                  labelStyle:
                                  CommonStyles(context: context).getLabelText()))
                      ),

                     /* ResponsivePadding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: ActiveAccount(
                              labelText: "Enviar para numero",
                              value: "******123",
                              icon: "images/icons/ic_phone.png",
                              iconWidth: 20.0,
                              iconHeight: 32.0,
                              onPressItem: () {
                                Application.router.navigateTo(
                                    context, RouteConstants.ROUTE_VERIFY_CODE);
                              }))*/

                      Center(
                        child:    ResponsivePadding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child: FloatingActionButton.extended(
                              heroTag: "btRecuperarSenha",
                              label: Text("Recuperar senha"),
                              backgroundColor: Colors.pink,
                              icon: const Icon(Icons.autorenew),
                              onPressed: () {
                                resetarSenha(_emailController.text);
                              }),
                        ),
                      ),


                    ]),
                ResponsivePadding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: ForgotPasswordBottom())
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
            child: column));

    var scrollView = new SingleChildScrollView(child: constrainedBox);

    return scrollView;
  }

  @override
  Widget build(BuildContext context) {
    var layoutBuilder = new LayoutBuilder(
      builder: _buildWithConstraints,
    );

    var scaffold = new Scaffold(
      body: layoutBuilder,
    );

    return scaffold;
  }
}
