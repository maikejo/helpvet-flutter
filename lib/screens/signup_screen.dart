import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/helper/size_config.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/util/custom_alert_dialog.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'package:image_picker/image_picker.dart';
import './common_widgets/responsive_padding.dart';
import './signup_widgets/sign_up_form.dart';
import './signup_widgets/sign_up_button.dart';
import './signup_widgets/sign_up_bottom.dart';
import '../styles/common_variables.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key key, this.tipoConta,}) : super(key: key);

  final String tipoConta;

  @override
  _SignupScreenState createState() => new _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _crmvController = TextEditingController();

  File _fileController;
  String _urlAvatarController;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight:  200 , maxWidth: 200);
    setState(() {
      _fileController = image;
    });
  }

  Future uploadDocIdent(BuildContext context, String email) async {
    String fileName = "avatar";
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(email + "/avatar/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
    _urlAvatarController =
    await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Sucesso"),
          content: new Text("Cadastro realizado com sucesso!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Application.router.navigateTo(
                    context, RouteConstants.ROUTE_LOGIN,
                    clearStack: true,
                    replace: true,
                    transition: TransitionType.fadeIn);
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
          content: content,
          title: title,
          onPressed: onPressed,
        );
      },
    );
  }

  void _cadastrar() async {
    try {

      if(_fileController != null){
        Dialogs.showLoadingDialog(context, _keyLoader);

        String fileName = "avatar";
        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(_emailController.text + "/avatar/" + fileName);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
        _urlAvatarController = await (await uploadTask.onComplete).ref.getDownloadURL();

        await Auth.signUp(_emailController.text, _senhaController.text).then((email) {
          Auth.addUser(new User(
              nome: _nomeController.text,
              email: _emailController.text,
              senha: _senhaController.text,
              tipo: widget.tipoConta,
              imagemUrl: _urlAvatarController,
              diasPlano: 7,
              dtCriacao: Timestamp.now(),
              ativado: true,
              cpf: _cpfController.text,
              telefone: _telefoneController.text,
              crmv: _crmvController.text
          ));

          Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          _showDialog();
        });
      }else{
        _showDialogFoto();
      }

    } catch (e) {
      print("Error in sign up: $e");
      String exception = Auth.getExceptionText(e);
      _showErrorAlert(
          title: "Já existe um cadastro com esse email.", content: exception);
    }
  }

  void _showDialogFoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Erro"),
          content: new Text("Informe uma foto para seu perfil!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context,rootNavigator: true).pop();
                ;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildWithConstraints(BuildContext context, BoxConstraints constraints) {

    var column = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

           Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    ResponsivePadding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: GestureDetector(
                        onTap: () => getImageFromGallery(),
                        child: new Center(
                          child: _fileController == null
                              ? new Stack(
                            children: <Widget>[
                              Container(
                                height: 100.0,
                                width: 100.0,
                                child: new CircleAvatar(
                                  radius: 80.0,
                                  backgroundImage: AssetImage("images/icons/ic_camera.png"),
                                ),
                              ),
                            ],
                          )
                              : ClipOval(
                            child: Container(
                                height: 100,
                                width: 100,
                                child: _fileController == null
                                    ? Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                  size: 50,
                                )
                                    : Image.file(
                                  _fileController,
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                child: SignUpForm(
                                    _nomeController,
                                    _emailController,
                                    _senhaController,
                                    _senhaController,
                                    _cpfController,
                                    _telefoneController,
                                    _crmvController,
                                    widget.tipoConta)
                            ),

                            SizedBox(height: 5.0),
                            SignUpButton(_cadastrar),
                            SizedBox(height: 40.0),
                            SignUpBottom()
                          ]),
                    ),

                  ]))
        ]);

    var constrainedBox = ConstrainedBox(
        constraints: constraints.copyWith(maxHeight: MediaQuery.of(context).size.height),
        child: Container(
            color: Colors.white,
            child: column)
    );

    var scrollView = SingleChildScrollView(child: constrainedBox);

    return scrollView;
  }

  @override
  Widget build(BuildContext context) {
    var layoutBuilder = new LayoutBuilder(builder: _buildWithConstraints);

    var scaffold = new Scaffold(
      body: layoutBuilder,
    );

    return scaffold;
  }
}
