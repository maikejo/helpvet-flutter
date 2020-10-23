import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/screens/home_screen.dart';
import 'package:flutter_finey/screens/home_screen_pet.dart';
import 'package:flutter_finey/screens/home_widgets/perfil_screen.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:intl/intl.dart';

class HistoricoPagamentosScreen extends StatefulWidget {
  HistoricoPagamentosScreen({this.idCliente});

  final String idCliente;

  @override
  _HistoricoPagamentosScreenState createState() => _HistoricoPagamentosScreenState();
}

class _HistoricoPagamentosScreenState extends State<HistoricoPagamentosScreen> {

  List<Color> gradientColor = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
            title: Text("Lista de pagamentos"),
            backgroundColor: Colors.pink,
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => HomeScreen()));
              }
            )
        ),

        body: Stack(
          children: <Widget>[

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/5.0,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.pink,
                      Colors.pinkAccent,
                    ],
                  ),
                 /* borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100)
                  )*/
              ),
            ),

            new Center(
              child: new Container(
                margin: EdgeInsets.only(bottom: 70.0),
                width: 400.0,
                height: 600.0,

                child: Container(
                  child: Card(
                    elevation: 6.0,
                    margin: EdgeInsets.only(right: 15.0, left: 15.0),
                    child: new Wrap(
                      children: <Widget>[
                        Container(
                          height: 570.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(100),
                                  bottomRight: Radius.circular(100),
                                  topLeft: Radius.circular(200),
                                  topRight: Radius.circular(200),
                              )
                          ),

                          child: ListView(
                            padding: EdgeInsets.all(12.0),
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance.collection("pagamentos").document(Auth.user.email).collection("lista").snapshots(),
                                  builder: (context, snapshot) {

                                    if (snapshot.hasData) {
                                      return Column(
                                        children: snapshot.data.documents.map((doc) {

                                          return ListTile(
                                            title: FadeIn(1,Card(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                              color: const Color(0xFFFFFFFF),
                                              elevation: 4.0,
                                              child: ListTile(
                                                leading: Container(
                                                  child: CircleAvatar(
                                                    backgroundImage: AssetImage('images/icons/ic_pagamentos.png'),
                                                    radius: 20.0,
                                                  ),
                                                ),

                                                title: new Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text('Data: ' + DateFormat("dd/MM/yy hh:mm").format(DateTime.now()),
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight: FontWeight.bold,
                                                        )),

                                                  ],
                                                ),

                                                subtitle: Text('Valor: ' + doc.data['valor'].toString(),
                                                    style: TextStyle(
                                                      color: Colors.indigo)
                                                ),
                                                  onTap: (() {

                                                  }),

                                                onLongPress: ((){

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
                        ),

                      ],
                    ),
                  ),
                ),

              ),
            ),

          ],

    ));
  }
}