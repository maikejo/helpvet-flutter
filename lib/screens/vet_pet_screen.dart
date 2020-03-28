import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'dart:async';
import 'home_screen.dart';

class VetPetScreen extends StatefulWidget {
  VetPetScreen({@required this.idPet , this.idVet});
  final String idPet;
  final String idVet;

  @override
  _VetPetScreenState createState() => _VetPetScreenState();
}

class _VetPetScreenState extends State<VetPetScreen> {
  final Firestore datbase = Firestore.instance;
  Stream slides;
  File _fileController;
  String _urlFotoVacinaController;
  DateTime dataAtual = new DateTime.now();
  final db = Firestore.instance;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Clientes"),
        backgroundColor: Colors.pinkAccent),
      body: new Container(
        child: ListView(
          padding: EdgeInsets.all(12.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("usuarios").where("tipo", isEqualTo: "CLI").snapshots(),
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
                                  Text(doc.data['nome'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),

                              subtitle: Text('Ativo',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),
                              onTap: (() {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => HomeScreen(idAcessoVetDono: doc.data['email'], idVetAcesso: widget.idVet))
                                );
                              }),
                              onLongPress: (() async{
                              /*  await db
                                    .collection('consultas').document(Auth.user.email).collection('lista').document(widget.idPet).collection("lista")
                                    .document(doc.documentID)
                                    .delete();*/
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
    ),

    );
  }

}
