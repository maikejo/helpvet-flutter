import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/helper/Consts.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PlanosAdminScreen extends StatefulWidget {
  @override
  _PlanosAdminScreenState createState() => new _PlanosAdminScreenState();
}

class _PlanosAdminScreenState extends State<PlanosAdminScreen> {
  TextEditingController _descontoController = new TextEditingController();
  TextEditingController _diasPlanoController = new TextEditingController();
  TextEditingController _dsPlanoController = new TextEditingController();
  TextEditingController _nomePlanoController = new TextEditingController();
  TextEditingController _vlPlanoController = new TextEditingController();

  var youtube = new FlutterYoutube();
  final db = Firestore.instance;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String nomePlano;
  String dsPlano;
  String vlPlano;
  int diasPlano;
  String desconto;
  bool edicao = false;

  File _fileController;
  String _urlAvatarController;


  @override
  initState() {
    super.initState();
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight:  200 , maxWidth: 200);
    setState(() {
      _fileController = image;
    });

    try{
      if(_fileController != null) {
        Dialogs.showLoadingDialog(context, _keyLoader);
        uploadFoto(context,Auth.user.email);
      }
    }catch(e){
      print('erro');
    }

  }

  Future uploadFoto(BuildContext context, String email) async {
    String fileName = "planos";
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(email + "/planos/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
    _urlAvatarController = await (await uploadTask.onComplete).ref.getDownloadURL();
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  }

  void adicionar(String desconto,int diasPlano,String dsPlano,String nomePlano,String vlPlano){
    Firestore.instance.collection('planos').add({"desconto" : desconto, "diasPlano": diasPlano, "dsPlano": dsPlano, "imagemUrl": _urlAvatarController , "nomePlano": nomePlano, "vlPlano": vlPlano});
    Navigator.pop(context);
  }

  void atualizar(String id,String desconto,int diasPlano,String dsPlano,String nomePlano,String vlPlano){
    Firestore.instance.collection('planos').document(id).updateData({"desconto" : desconto, "diasPlano": diasPlano, "dsPlano": dsPlano, "imagemUrl": _urlAvatarController , "nomePlano": nomePlano, "vlPlano": vlPlano});
    Navigator.pop(context);
  }

  Widget modal(bool edicao,String id,String desconto,int diasPlano,String dsPlano,String nomePlano,String vlPlano){
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

               edicao == true ? ResponsivePadding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    onTap: () => getImageFromGallery(),
                    child: new Center(
                      child: _urlAvatarController == null
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
                ) : ResponsivePadding(
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
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _nomePlanoController,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.assignment),
                              hintText: 'Nome',
                              labelText: 'Nome do Plano',
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (nome) {
                              _nomePlanoController.text = nome;
                            },
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _dsPlanoController,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.assignment),
                              hintText: 'Descrição',
                              labelText: 'Descrição do Plano',
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (ds) {
                              _dsPlanoController.text = ds;
                            },
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _vlPlanoController,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.monetization_on),
                              hintText: 'Valor',
                              labelText: 'Valor',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (vl) {
                              _vlPlanoController.text = vl;
                            },
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _descontoController,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.shopping_cart),
                              hintText: 'Desconto',
                              labelText: 'Desconto',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (des) {
                              _descontoController.text = des;
                            },
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _diasPlanoController,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.add),
                              hintText: 'Dias',
                              labelText: 'Dias do Plano',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (dias) {
                              _diasPlanoController.text = dias;
                            },
                          ),
                        ),

                        ResponsivePadding(
                          padding: const EdgeInsets.only(top: 20.0),
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
                                      edicao == false ? adicionar(desconto,diasPlano,dsPlano,_nomePlanoController.text,vlPlano) :
                                      atualizar(id,_descontoController.text,int.parse(_diasPlanoController.text),_dsPlanoController.text,_nomePlanoController.text,_vlPlanoController.text);
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
          title: Text("Adicionar - Planos"),
          backgroundColor: Colors.blue),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "btAddPlanos",
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),

        onPressed: () {

          _descontoController = new TextEditingController();
          _diasPlanoController = new TextEditingController();
          _dsPlanoController = new TextEditingController();
         _nomePlanoController = new TextEditingController();
         _vlPlanoController = new TextEditingController();
         _urlAvatarController = null;
         _fileController = null;


          modal(edicao,null,_descontoController.text,null,_dsPlanoController.text,_nomePlanoController.text,_vlPlanoController.text);
        },
      ),


      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('planos').snapshots(),
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
                                Text(doc.data['nomePlano'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),

                            subtitle: Text(doc.data['dsPlano'],
                                style: TextStyle(
                                  color: Colors.grey,
                                )),

                            onTap: ((){
                              edicao = true;

                              _descontoController.text = doc.data['desconto'];
                              _diasPlanoController.text = doc.data['diasPlano'].toString();
                              _dsPlanoController.text = doc.data['dsPlano'];
                              _nomePlanoController.text = doc.data['nomePlano'];
                              _vlPlanoController.text = doc.data['vlPlano'];

                              modal(edicao, doc.documentID,_descontoController.text,int.parse(_diasPlanoController.text),_dsPlanoController.text,_nomePlanoController.text,_vlPlanoController.text);

                            }),

                            onLongPress: (() async{
                              await db.collection('planos').document(doc.documentID).delete();
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
}