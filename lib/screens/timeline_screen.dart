import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/helper/date_converter.dart';
import 'package:timeline_flow/timeline_flow.dart';
//import 'timeline.dart';

class TimelineScreen extends StatefulWidget {
  TimelineScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TimelineScreenState createState() => new _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {

  @override
  void initState() {
    super.initState();
    listaConsultas();
    listaExames();
  }

  List<DocumentSnapshot> listaConsulta;
  List<DocumentSnapshot> listaExame;
  TimelineTile tile;
  List<TimelineTile> timeline = [];

  void listaConsultas(){
    StreamSubscription<QuerySnapshot> _subscription = Firestore.instance.collection("consultas").document('maikejo@gmail.com').collection("lista").document('4YvUJ7ZItH3ENHTWKXgm').collection("lista").snapshots().listen((datasnapshot) {
      setState(() {
        listaConsulta = datasnapshot.documents;

        for(var consulta in listaConsulta){
          var imagem = consulta.data['imagemUrl'];

          Timestamp converteDataTimestamp = consulta.data['data'];
          var data  = DateConverter().converteTimestamp(converteDataTimestamp.millisecondsSinceEpoch);

          TimelineTile tile = new TimelineTile(
            title: Text('Consulta'),
            subTitle: CircleAvatar(
              backgroundImage: (imagem != null)
                  ? CachedNetworkImageProvider(
                  imagem)
                  : AssetImage(
                  "assets/images/default.png"),
            ),
            icon: Icon( (Icons.history),color: (Colors.blue)),
            gap: 0.0,
            trailing: Text(data.toString()),
          );

          timeline.add(tile);
        }
      });
    });
  }
  void listaExames(){
    StreamSubscription<QuerySnapshot> _subscription = Firestore.instance.collection("exames").document('maikejo@gmail.com').collection("lista").document('4YvUJ7ZItH3ENHTWKXgm').collection("lista").snapshots().listen((datasnapshot) {
      setState(() {
        listaExame = datasnapshot.documents;

        for(var consulta in listaExame){
          var imagem = consulta.data['imagemUrl'];

          Timestamp converteDataTimestamp = consulta.data['data'];
          var data  = DateConverter().converteTimestamp(converteDataTimestamp.millisecondsSinceEpoch);

          TimelineTile tile = new TimelineTile(
            title: Text('Exame'),
            subTitle: CircleAvatar(
              backgroundImage: (imagem != null)
                  ? CachedNetworkImageProvider(imagem)
                  : AssetImage("assets/images/default.png"),
            ),
            icon: Icon(Icons.history,color: Colors.blue),
            gap: 0.0,
            trailing: Text(data.toString()),
          );

          timeline.add(tile);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Pet Timeline'),
        backgroundColor:Colors.pinkAccent,
      ),
      body: Column(
        children: <Widget>[

              TimelineProfile(
               margin: EdgeInsets.only(top: 5.0),
               image: AssetImage("images/icons/ic_timeline.png"),
               title: Text('Pet Timeline',style: TextStyle(color: Colors.white)),
               subTitle: Text('Hitórico',style: TextStyle(color: Colors.white)),
               color: Color(0xFF162A49),
              ),


               Expanded(
                child:Stack(
                children: <Widget>[
                TimelineView.builder( bottom: 40.0, left: 30.0, leftLine: 45.0, bottomLine:40.0,  itemCount: this.timeline.length, itemBuilder: (index){

                  return TimelineTile(
                    title: this.timeline[index].title,
                    icon: Icon(Icons.timelapse,color:Colors.pinkAccent),
                    gap: 0.0,
                    height: 80.0,
                    subTitle: this.timeline[index].subTitle,
                    trailing: this.timeline[index].trailing,
                  );

                }),
                ],
                )),


        ],
      ),
    );
  }
}