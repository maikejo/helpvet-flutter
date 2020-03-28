import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:image_picker/image_picker.dart';

class DoencaPetAdminScreen extends StatefulWidget {
  @override
  _DoencaPetAdminScreenState createState() => new _DoencaPetAdminScreenState();
}

class _DoencaPetAdminScreenState extends State<DoencaPetAdminScreen> {
  TextEditingController textEditingControllerUrl = new TextEditingController();
  TextEditingController textEditingControllerId = new TextEditingController();

  var youtube = new FlutterYoutube();
  final db = Firestore.instance;
  String doenca;
  String urlTutorial;
  TextEditingController _doencaController = new TextEditingController();


  @override
  initState() {
    super.initState();
  }
  
  void adicionar(String nome){
    Firestore.instance.collection('doencas').add({"nome" : nome});
    Navigator.pop(context);
  }

  void atualizar(String id,String pet){
    Firestore.instance.collection('tipoPet').document(id).updateData({"pet" : pet });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Adicionar - Doenças"),
          backgroundColor: Colors.blue),


      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "btAddDoenca",
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),

        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.add_box),
                              hintText: 'Nome doença',
                              labelText: 'Doença',
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (doenca) {
                              doenca = doenca;
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
                                      adicionar(doenca);
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
              stream: db.collection('doencas').orderBy('nome').snapshots(),
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
                                backgroundImage:AssetImage('images/icons/ic_doenca.png'),
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

                            onTap: ((){
                              _doencaController.text = doc.data['nome'];

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Form(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[

                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  controller: _doencaController,
                                                  decoration: const InputDecoration(
                                                    icon: const Icon(Icons.add_box),
                                                    hintText: 'Nome doença',
                                                    labelText: 'Doença',
                                                  ),
                                                  keyboardType: TextInputType.text,
                                                  onChanged: (doenca) {
                                                    doenca = doenca;
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
                                                            atualizar(doc.documentID,_doencaController.text);
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
                              await db.collection('doencas').document(doc.documentID).delete();
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