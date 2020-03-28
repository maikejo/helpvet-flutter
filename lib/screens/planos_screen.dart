import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/service/auth.dart';
import 'dart:async';

class PlanosScreen extends StatefulWidget {
  @override
  _PlanosScreenState createState() => _PlanosScreenState();
}

class _PlanosScreenState extends State<PlanosScreen> {
  final Firestore datbase = Firestore.instance;
  Stream slides;
  final db = Firestore.instance;
  User usuario;

  @override
  void initState() {
    super.initState();
    _buscaDadosAtivacao();
  }

  void _redirectPagamentoScreen() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_PAGAMENTO,
        transition: TransitionType.inFromBottom);
  }

  void _buscaDadosAtivacao() async{
    User user = await Auth.getDadosUser(Auth.user.email);
    setState(() {
      usuario = user;
    });
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
            title: Text("Planos"),
            backgroundColor: Colors.blueAccent,
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Application.router.navigateTo(
                  context, RouteConstants.ROUTE_HOME,
                  transition: TransitionType.fadeIn),
            )
        ),
        body: new Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 253, 72, 72),
                  const Color.fromARGB(255, 87, 97, 249),
                ],
                stops: [0.0, 1.0],
              )
          ),

          child: ListView(
            padding: EdgeInsets.all(12.0),
            children: <Widget>[
              SizedBox(height: 20.0),
              StreamBuilder<QuerySnapshot>(
                  stream: db.collection('planos').snapshots(),
                  builder: (context, snapshot) {

                    if (snapshot.data != null) {

                      if(usuario != null){
                        return Column(
                          children: snapshot.data.documents.map((doc) {

                            return ListTile(
                              title: Container(
                                height: 124.0,
                                child: FadeIn(1, Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  color: const Color(0xFFFFFFFF),
                                  elevation: 4.0,
                                  child: ListTile(
                                    /*leading:  Container(
                                decoration: new BoxDecoration(

                                ),
                                child: CircleAvatar(
                                  backgroundImage: doc.data['imagemUrl'] == null
                                      ? AssetImage('images/ic_blank_image.png')
                                      : CachedNetworkImageProvider(doc.data['imagemUrl']),
                                  radius: 20.0,
                                ),
                              ),*/

                                    title: new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(doc.data['nomePlano'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,

                                            )),

                                        Text(doc.data['vlPlano'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    ),

                                    subtitle: Container(
                                      margin: const EdgeInsets.only(top: 25),
                                      child:   Text(doc.data['dsPlano'],
                                          style: TextStyle(
                                            color: Colors.grey,
                                          )),
                                    ),

                                    leading: doc.data['diasPlano'] == usuario.diasPlano ? Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      child: Text('Ativo',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ): null ,


                                    onTap: _redirectPagamentoScreen,
                                  ),
                                )),
                              ),
                            );
                          }).toList(),
                        );
                      }else{
                        return SizedBox();
                      }

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
