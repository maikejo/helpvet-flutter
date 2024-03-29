import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/model/cadastro_exame.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/service/cadastro_exame_service.dart';
import 'package:flutter_finey/service/cadastro_vacina_service.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'chat_widgets/full_screen_image.dart';

class ExameScreen extends StatefulWidget {
  ExameScreen({@required this.idPet,this.idAcessoVetDono});
  final String idPet;
  final String idAcessoVetDono;

  @override
  _ExameScreenState createState() => _ExameScreenState();
}

class _ExameScreenState extends State<ExameScreen> {
  final Firestore datbase = Firestore.instance;
  Stream slides;
  File _fileController;
  String _urlFotoVacinaController;
  DateTime dataAtual = new DateTime.now();
  CadastroVacinaService cadastroVacinaService;
  final db = Firestore.instance;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 80, maxHeight:  700 , maxWidth: 700);
    setState(() {
      _fileController = image;
    });

    try{

      if(_fileController != null) {
        Dialogs.showLoadingDialog(context, _keyLoader);
        uploadDocVacina(context);
      }
    }catch(e){
      print('erro');
    }

  }

  Future uploadDocVacina(BuildContext context) async {
      String fileName = "exame_"+ new DateFormat("dd-MM-yyyy").format(dataAtual);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(Auth.user.email + "/documentos/exames/" + fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
      _urlFotoVacinaController = await (await uploadTask.onComplete).ref.getDownloadURL();

      CadastroExame cadastroExame = new CadastroExame(data: dataAtual,imagemUrl: _urlFotoVacinaController);
      CadastroExameService.cadastrarExame(cadastroExame,widget.idPet);

      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  }

  Widget mostarVetAcessoExame(){
    return Scaffold(
      appBar: AppBar(
          title: Text("Lista de Exames"),
          backgroundColor: Colors.pinkAccent),

      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("exames").document(widget.idAcessoVetDono).collection("lista").document(widget.idPet).collection("lista").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) {

                      return ListTile(
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
                                Text("Exame",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),

                            subtitle: Text(DateFormat("dd/MM/yy hh:mm").format(DateTime.now()),
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => FullScreenImage(photoUrl: doc.data['imagemUrl'],)));
                            }),
                          ),
                        ),
                      ));
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


  @override
  Widget build(BuildContext context) {

    if(widget.idAcessoVetDono != null){
      return mostarVetAcessoExame();
    }else{
      return Scaffold(
        appBar: AppBar(
            title: Text("Lista de Exames"),
            backgroundColor: Colors.pinkAccent),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            heroTag: "btFotoExame",
            backgroundColor: Colors.pinkAccent,
            child: const Icon(Icons.party_mode),
            onPressed: (getImageFromCamera)
        ),

        body: ListView(
          padding: EdgeInsets.all(12.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("exames").document(Auth.user.email).collection("lista").document(widget.idPet).collection("lista").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.documents.map((doc) {

                        return ListTile(
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
                                  Text("Exame",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),

                              subtitle: Text(DateFormat("dd/MM/yy hh:mm").format(DateTime.now()),
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),
                              onTap: (() {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => FullScreenImage(photoUrl: doc.data['imagemUrl'],)));
                              }),
                              onLongPress: (() async{
                                await db
                                    .collection('exames').document(Auth.user.email).collection('lista').document(widget.idPet).collection("lista")
                                    .document(doc.documentID)
                                    .delete();
                              }),
                            ),
                          )),
                        );
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

}
