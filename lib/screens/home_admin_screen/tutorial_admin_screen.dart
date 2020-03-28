import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TutorialAdminScreen extends StatefulWidget {
  @override
  _TutorialAdminScreenState createState() => new _TutorialAdminScreenState();
}

class _TutorialAdminScreenState extends State<TutorialAdminScreen> {
  TextEditingController _tituloController = new TextEditingController();
  TextEditingController _urlController = new TextEditingController();

  var youtube = new FlutterYoutube();
  final db = Firestore.instance;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String tituloTutorial;
  String urlTutorial;
  File _fileController;
  String _urlAvatarController;
  bool edicao = false;


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
    String fileName = "tutoriais";
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(email + "/tutoriais/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
    _urlAvatarController = await (await uploadTask.onComplete).ref.getDownloadURL();
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  }

  void adicionar(String titulo,String url){
    Firestore.instance.collection('tutoriais').add({"data" : Timestamp.now(), "imagemUrl": _urlAvatarController, "titulo" : titulo , "youyubeUrl" : url });
    Navigator.pop(context);
  }

  void atualizar(String id,String titulo,String youtubeUrl,String imagemUrl){
    Firestore.instance.collection('tutoriais').document(id).updateData({"data" : Timestamp.now(), "imagemUrl": imagemUrl, "titulo" : titulo , "youtubeUrl" : youtubeUrl });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Adicionar - Videos Tutoriais"),
          backgroundColor: Colors.blue),


      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "btAddTutorial",
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),

        onPressed: () {

          edicao = false;

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        ResponsivePadding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: GestureDetector(
                            onTap: () => getImageFromGallery(),
                            child: new Center(
                              child: _fileController == null
                                  ? new Stack(
                                children: <Widget>[
                                  Container(
                                    height: 70.0,
                                    width: 70.0,
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

                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.assignment),
                              hintText: 'Titulo Tutorial',
                              labelText: 'Titulo',
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (titulo) {
                              tituloTutorial = titulo;
                            },
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.video_library),
                              hintText: 'Url(Vídeo)',
                              labelText: 'Url',
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (url) {
                              urlTutorial = url;
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
                                    child: Text("Adicionar"),
                                    onPressed: (){
                                      adicionar(tituloTutorial,urlTutorial);
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
                    ),
                  ),
                );
              });
        },
      ),


      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('tutoriais').snapshots(),
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
                                Text(doc.data['titulo'],
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

                              edicao = true;

                              _tituloController.text = doc.data['titulo'];
                              _urlController.text = doc.data['youtubeUrl'];

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Form(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[

                                              ResponsivePadding(
                                                padding: const EdgeInsets.only(top: 10.0),
                                                child: GestureDetector(
                                                  onTap: () => getImageFromGallery(),
                                                  child: new Center(
                                                    child: doc.data['imagemUrl'] == null
                                                        ? new Stack(
                                                      children: <Widget>[
                                                        Container(
                                                          height: 70.0,
                                                          width: 70.0,
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
                                                          image: new CachedNetworkImageProvider(doc.data['imagemUrl']),
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

                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  controller: _tituloController,
                                                  decoration: const InputDecoration(
                                                    icon: const Icon(Icons.assignment),
                                                    hintText: 'Titulo Tutorial',
                                                    labelText: 'Titulo',
                                                  ),
                                                  keyboardType: TextInputType.text,
                                                  onChanged: (titulo) {
                                                    _tituloController.text = titulo;
                                                  },
                                                ),
                                              ),

                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  controller: _urlController,
                                                  decoration: const InputDecoration(
                                                    icon: const Icon(Icons.video_library),
                                                    hintText: 'Url(Vídeo)',
                                                    labelText: 'Url',
                                                  ),
                                                  keyboardType: TextInputType.text,
                                                  onChanged: (url) {
                                                   _urlController.text = url;
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
                                                          child: Text("Atualizar"),
                                                          onPressed: (){
                                                            atualizar(doc.documentID,_tituloController.text,_urlController.text,_urlAvatarController);
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
                                          ),
                                        ),
                                      );
                                    });

                            }),

                            onLongPress: (() async{
                              await db.collection('tutoriais').document(doc.documentID).delete();
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