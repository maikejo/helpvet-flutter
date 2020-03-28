import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:intl/intl.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => new _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  TextEditingController textEditingControllerUrl = new TextEditingController();
  TextEditingController textEditingControllerId = new TextEditingController();

  var youtube = new FlutterYoutube();
  final db = Firestore.instance;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Videos Tutoriais"),
          backgroundColor: Colors.pinkAccent),

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
                              FlutterYoutube.playYoutubeVideoByUrl(
                                  apiKey: "AIzaSyCmccaWLcem0lGv-cE0Ccj5Sg3D1tetDyE",
                                  videoUrl: doc.data['youtubeUrl'],
                                  autoPlay: true
                              );
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