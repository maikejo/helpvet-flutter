import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/helper/Consts.dart';
import 'package:flutter_finey/model/userVet.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/styles/common_styles.dart';
import 'package:flutter_finey/util/custom_alert_dialog.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class VeterinarioAdminScreen extends StatefulWidget {
  VeterinarioAdminScreen();

  @override
  _VeterinarioAdminScreenState createState() => new _VeterinarioAdminScreenState();
}

class _VeterinarioAdminScreenState extends State<VeterinarioAdminScreen> {
  final db = Firestore.instance;

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _cpfCnpjController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _registroMedicoController = TextEditingController();

  String _selectedClinica = null;
  File _fileController;
  String _urlAvatarController;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final dateFormat = DateFormat("dd/MM/yyyy");
  bool edicao = false;

  @override
  initState() {
    super.initState();
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight:  500 , maxWidth: 500);
    setState(() {
      _fileController = image;
    });

    try{
      if(_fileController != null) {
        Dialogs.showLoadingDialog(context, _keyLoader);
        _atualizaAvatar();
      }
    }catch(e){
      print('erro');
    }

  }

  void _showDialogFotoPet() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Erro"),
          content: new Text("Informe uma foto!"),
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

  void _atualizaAvatar() async{
    String fileName = "avatar";
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(Auth.user.email + "/avatar/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
    _urlAvatarController = await (await uploadTask.onComplete).ref.getDownloadURL();
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  }

  void _cadastrar() async {

    try {

      if(_fileController != null){

        _atualizaAvatar();

        await Auth.signUp(_emailController.text, _senhaController.text).then((email) {
          Auth.addUserVet(new UserVet(
              nome: _nomeController.text,
              email: _emailController.text,
              senha: _senhaController.text,
              tipo: "VET",
              imagemUrl: _urlAvatarController,
              diasPlano: 7,
              dtCriacao: Timestamp.now(),
              ativado: true,
              cpfCnpj : _cpfCnpjController.text,
              registroMedico: _registroMedicoController.text,
              cnpjClinica: _selectedClinica

          ));

        });

      }else{
        _showDialogFotoPet();
      }

    } catch (e) {
      print("Error in sign up: $e");
      String exception = Auth.getExceptionText(e);
      _showErrorAlert(
          title: "Já existe um cadastro com esse email.", content: "");
    }
  }

  void atualizar(String id,String nome,String cnpjClinica,String cpfCnpj,String registroVeterinario,String email,String senha){

    Firestore.instance.collection('usuarios').document(id).updateData({"nome" : nome, "cnpjClinica": cnpjClinica, "cpfCnpj": cpfCnpj,
                                                                       "imagemUrl": _urlAvatarController , "registroVeterinario": registroVeterinario,
                                                                       "email": email, "senha": senha});
    Navigator.pop(context);
  }

  Widget modal(bool edicao,String id,String nome,String clinica,String cpfCnpj,String registroMedico,String email,String senha){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return  Container(
            padding: EdgeInsets.only(
              top: Consts.avatarRadius + Consts.padding,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[

                ResponsivePadding(
                  padding: const EdgeInsets.only(bottom: 20.0),
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
                              backgroundImage: AssetImage(
                                  "images/icons/ic_camera.png"),
                            ),
                          ),
                        ],
                      )
                          : new Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: new BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: new DecorationImage(
                            image: new AssetImage(
                                _fileController.path),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                              color: Colors.blue,
                              width: 5.0),
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(80.0)),
                        ),
                      ),
                    ),
                  ),
                ),

                new Material(color: Colors.white,
                    child: Column(
                      children: <Widget>[

                        ResponsivePadding(
                            padding: const EdgeInsets.only(
                                left: 40.0, right: 40.0, bottom: 10.0, top: 10.0),
                            child: TextFormField(
                                controller: _nomeController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.account_circle, color: Colors.blue),
                                    fillColor: Colors.blue,
                                    labelText: 'Nome & Sobrenome',
                                    labelStyle: CommonStyles(context: context).getLabelText()))),

                        ResponsivePadding(padding: const EdgeInsets.only(right: 80.0, bottom: 10.0),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance.collection('clinicas').snapshots(),
                              builder: (context,snapshot) {
                                if (snapshot.data != null){

                                  return Container(padding: EdgeInsets.only(top: 20.0,left: 38.0),
                                    child: DropdownButton<String>(
                                      value: clinica,
                                      isDense: true,
                                      hint: Text('Selecionar Clínica'),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedClinica = newValue;
                                        });
                                      },
                                      items: snapshot.data.documents.map((DocumentSnapshot document) {
                                        return new DropdownMenuItem<String>(
                                            value: document.data['cnpj'].toString(),
                                            child: new Container(
                                              height: 100.0,
                                              child: new Text(
                                                document.data['nome'].toString(),
                                              ),
                                            ));
                                      }).toList()
                                    ),
                                  );
                                }

                              }),
                        ),

                        ResponsivePadding(
                            padding: const EdgeInsets.only(
                                left: 40.0, right: 40.0, bottom: 10.0),
                            child: TextFormField(
                                controller: _cpfCnpjController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.assignment, color: Colors.blue),
                                    fillColor: Colors.blue,
                                    labelText: 'CPF/CNPJ',
                                    labelStyle:
                                    CommonStyles(context: context).getLabelText()))),

                        ResponsivePadding(
                            padding: const EdgeInsets.only(
                                left: 40.0, right: 40.0, bottom: 10.0),
                            child: TextFormField(
                                controller: _registroMedicoController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.assignment_ind, color: Colors.blue),
                                    fillColor: Colors.blue,
                                    labelText: 'Registro',
                                    labelStyle:
                                    CommonStyles(context: context).getLabelText()))),

                        ResponsivePadding(
                            padding: const EdgeInsets.only(
                                left: 40.0, right: 40.0, bottom: 10.0),
                            child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.email, color: Colors.blue),
                                    fillColor: Colors.blue,
                                    labelText: 'E-mail',
                                    labelStyle:
                                    CommonStyles(context: context).getLabelText()))),

                        ResponsivePadding(
                            padding: const EdgeInsets.only(
                                left: 40.0, right: 40.0, bottom: 60.0),
                            child: TextFormField(
                                controller: _senhaController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.lock, color: Colors.blue),
                                    fillColor: Colors.blue,
                                    labelText: 'Senha',
                                    labelStyle:
                                    CommonStyles(context: context).getLabelText()))),

                        ResponsivePadding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: <Widget>[

                              Padding(
                                padding: const EdgeInsets.only(top:10,left: 20.0),
                                child: RaisedButton(
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    child: Text("Salvar"),
                                    onPressed: (){

                                        edicao == false ? _cadastrar() :
                                        atualizar(id,_nomeController.text,_selectedClinica,_cpfCnpjController.text,_registroMedicoController.text,_emailController.text,_senhaController.text);

                                    }
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top:10.0, left: 20.0),
                                child: RaisedButton(
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    child: Text("Cancelar"),
                                    onPressed: (){
                                      Navigator.of(context,rootNavigator: true).pop();
                                    }
                                ),
                              ),

                            ],
                          ),
                        ),

                      ],

                    )),

              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Adicionar - Veterinário"),
          backgroundColor: Colors.blue),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "btAddVeterinario",
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),

        onPressed: () {

          _nomeController = new TextEditingController();
          _selectedClinica = null;
          _cpfCnpjController = new TextEditingController();
          _registroMedicoController = new TextEditingController();
          _emailController = new TextEditingController();
          _senhaController = new TextEditingController();
          _urlAvatarController = null;
          _fileController = null;

          modal(null,null,_nomeController.text,_selectedClinica,_cpfCnpjController.text,_registroMedicoController.text,_emailController.text,_senhaController.text);
        },

      ),


      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('usuarios').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  return Column(
                    children: snapshot.data.documents.map((doc) {

                      return doc.data['tipo'] == 'VET' ? ListTile(
                          title: FadeIn(1,Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: const Color(0xFFFFFFFF),
                            elevation: 4.0,
                            child: ListTile(

                              leading:  Container(
                                decoration: new BoxDecoration(

                                ),
                                child: CircleAvatar(
                                  backgroundImage: doc.data['imagemUrl'] == null
                                      ? AssetImage('images/ic_blank_image.png')
                                      : CachedNetworkImageProvider(doc.data['imagemUrl']),
                                  radius: 20.0,
                                ),
                              ),

                              title: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(doc.data['nome'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),

                              subtitle: Text(doc.data['email'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),

                              onTap: (() {
                                edicao = true;

                                _nomeController.text = doc.data['nome'];
                                _selectedClinica = doc.data['cnpjClinica'].toString();
                                _cpfCnpjController.text = doc.data['cpfCnpj'];
                                _registroMedicoController.text = doc.data['registroVeterinario'];
                                _emailController.text = doc.data['email'];
                                _senhaController.text = doc.data['senha'];

                                modal(edicao, doc.documentID,_nomeController.text,_selectedClinica,_cpfCnpjController.text,_registroMedicoController.text,_emailController.text, _senhaController.text);

                              }),

                              onLongPress: (() async{
                                await db.collection('usuarios').document(doc.documentID).delete();
                              }),
                            ),
                          ),
                        )) : SizedBox();

                    }).toList(),
                  );
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
    );
  }
}