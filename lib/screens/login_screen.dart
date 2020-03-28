import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/helper/size_config.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/screens/faq_screen.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/service/finger_print/local_authentication_service.dart';
import 'package:flutter_finey/service/finger_print/service_locator.dart';
import 'package:flutter_finey/util/custom_alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './common_widgets/responsive_image.dart';
import './common_widgets/responsive_padding.dart';
import './common_widgets/title.dart';
import './login_widgets/login_bottom.dart';
import './login_widgets/login_button.dart';
import './login_widgets/login_form.dart';
import '../config/application.dart';
import '../config/routes.dart';
import '../styles/common_variables.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  AnimationController _opacityController;
  bool checkValue = false;

  SharedPreferences sharedPreferences;
  StreamSubscription<Event> subscription;

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  String animation = "go";


  @override
  void initState() {
    //setupLocator();
    super.initState();

    _opacityController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    )
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);

    _opacityController.forward();

    getRemenberCredential();
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_FORGOT_PASSWORD,
        transition: TransitionType.fadeIn);
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void _showDialogAtivacao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Ativar Plano"),
          content: new Text("Seu tempo de uso expirou. Adquira agora seu plano!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
             FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Application.router.navigateTo(context, RouteConstants.ROUTE_LOGIN,
                clearStack: true,
                replace: true,
                transition: TransitionType.inFromBottom);
              },
            ),

             FlatButton(
              child: new Text("Ativar Plano"),
              onPressed: () {
                Application.router.navigateTo(context, RouteConstants.ROUTE_PLANOS,
                    clearStack: true,
                    replace: true,
                    transition: TransitionType.inFromBottom);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogOnline() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Sem Internet"),
          content: new Text("Verifique se esta conectado na rede"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {

              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorAlert({String title, String content, VoidCallback onPressed}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
            content: content, title: title, onPressed: _dismissDialog);
      },
    );
  }

  void _handleLogin() async {

    User user = await Auth.getDadosUser(_emailController.text);

    final dtCriacao = user.dtCriacao;
    final dtHoje = Timestamp.now();
    final diasCorridos = dtHoje.toDate().difference(dtCriacao.toDate()).inDays;

    if(diasCorridos > user.diasPlano || user.ativado == false){
      _showDialogAtivacao();
    }else{

      StreamSubscription<QuerySnapshot> _subscription;
      List<DocumentSnapshot> listaCadastroPet;

      _subscription = Firestore.instance.collection("cadastro_pet").document(_emailController.text).collection("lista").snapshots().listen((datasnapshot) {
        listaCadastroPet = datasnapshot.documents;

        if(user.tipo == "CLI"){
          if (listaCadastroPet.length > 0) {
            Application.router.navigateTo(context, RouteConstants.ROUTE_HOME,
                clearStack: true,
                replace: true,
                transition: TransitionType.inFromBottom);
          } else {
            Application.router.navigateTo(context, RouteConstants.ROUTE_CADASTRO_PET,
                clearStack: true,
                replace: true,
                transition: TransitionType.inFromBottom);
          }

        }else{
          Application.router.navigateTo(context, RouteConstants.ROUTE_HOME_PET,
              clearStack: true,
              replace: true,
              transition: TransitionType.fadeIn);
        }

      });
    }

  }

  void getRemenberCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = sharedPreferences.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          _emailController.text = sharedPreferences.getString("email");
          _senhaController.text = sharedPreferences.getString("senha");
        } else {
          _emailController.clear();
          _senhaController.clear();
          sharedPreferences.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }

  void _login() async {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await Auth.signIn(_emailController.text, _senhaController.text).then((email){
        //final LocalAuthenticationService _localAuth = locator<LocalAuthenticationService>();

        //_localAuth.authenticate();

         _handleLogin();
      } );
    } catch (e) {
      _showErrorAlert(
          title: "Falha ao autenticar.", content: "Usuário ou Senha incorreto");
    }
  }

  void _handleSignUp() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_SIGN_UP,
        transition: TransitionType.fadeIn);
  }

  _onChangedRemenber(bool value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = value;
      animation = "go";
      sharedPreferences.setBool("check", checkValue);
      sharedPreferences.setString("email", _emailController.text);
      sharedPreferences.setString("senha", _senhaController.text);
      sharedPreferences.commit();
      getRemenberCredential();
    });
  }

  Widget _buildWithConstraints(BuildContext context, BoxConstraints constraints) {
    final sizeConfig = SizeConfig(mediaQueryData: MediaQuery.of(context));
    var column = new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[

      Container(
        width: MediaQuery.of(context).size.width,
        height: sizeConfig.dynamicScaleSize(size: 268),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF58524),
                Color(0XFFF92B7F),
              ],
            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(120))),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),

            Align(
              alignment: Alignment.center,
              child: ResponsiveImage(
                  image: new ExactAssetImage('images/helpvet_logo_round.png'),
                  width: 150.0,
                  height: 150.0),
            ),

           /* Container(
                height: 200,
                padding: const EdgeInsets.only(left: 30.0, right:30.0),
                child: FlareActor(
                  "assets/rato.flr",
                  shouldClip: false,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.contain,
                  animation: animation,
                )),*/

            TitleWidget(
                text: 'Help Vet',
                paddingTop: 10.0,
                paddingLeft: 145.0,
                paddingRight: 120.0,
                paddingBottom: 1.0),
            Spacer(),
          ],
        ),
      ),

      Container(
        padding: const EdgeInsets.only(top: 30.0),
        child: LoginForm(_emailController, _senhaController,animation = "erro"),
      ),

        Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                ResponsivePadding(
                  padding: EdgeInsets.only(left: 210.0,right: 20.0),
                  child: CheckboxListTile(
                  activeColor: Colors.pinkAccent,
                  value: checkValue,
                  onChanged: _onChangedRemenber,
                  title: Text("Lembrar"),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                ),

                ResponsivePadding(
                    padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20.0),
                    child: LoginButton(
                      handleForgotPassword: _handleForgotPassword,
                      handleLogin: _login,
                    )),
                ResponsivePadding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: LoginBottom(
                      handleSignUp: _handleSignUp,
                    )),

                Center(
                    child: ResponsivePadding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: FloatingActionButton.extended(
                          heroTag: "btFaq",
                          label: Text("FAQ"),
                          backgroundColor: Color(0xFF162A49),
                          icon: const Icon(Icons.chat_bubble),
                          onPressed: () {

                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                context: context,
                                builder: (BuildContext context) {

                                  return FaqScreen();
                                }
                            );
                          }),
                    )
                ),

              ],
            ),

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
    var layoutBuilder = new LayoutBuilder(builder: _buildWithConstraints);

    var scaffold = new Scaffold(body: layoutBuilder);

    return scaffold;
  }
}
