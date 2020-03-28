import 'dart:async';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/screens/home_screen_pet.dart';
import 'package:flutter_finey/service/auth.dart';
import 'chat_widgets/chat_screen.dart';

class ChatUsersScreen extends StatefulWidget {
  ChatUsersScreen({@required this.idPet, this.idAcessoVetDono});

  final String idPet;
  final String idAcessoVetDono;

  _ChatUsersScreenState createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends State<ChatUsersScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot> _subscription;
  List<DocumentSnapshot> listaUsuarios;
  DocumentSnapshot usersList;
  String _tipo;

  DatabaseReference connectedlistRef;
  DatabaseReference myidRef = FirebaseDatabase.instance.reference().child('usuarios/maikejo@gmail.com');
  bool localIOnlineIndicator = false;
  StreamSubscription<Event> subscription;

  void getTipoUsuarioChat() async {
    String tipo = await Auth.geTipo(Auth.user.email);
    setState(() {
      _tipo = tipo;

      if(_tipo == "VET"){
        _subscription = Firestore.instance.collection("usuarios").where("tipo", isEqualTo: "CLI").snapshots().listen((datasnapshot) {
          setState(() {
            listaUsuarios = datasnapshot.documents;
            print("Lista usuarios ${listaUsuarios.length}");
          });
        });
      }else{
        _subscription = Firestore.instance.collection("usuarios").where("tipo", isEqualTo: "VET").snapshots().listen((datasnapshot) {
          setState(() {
            listaUsuarios = datasnapshot.documents;
            print("Lista usuarios ${listaUsuarios.length}");
          });
        });
      }
    });
  }

  static void offlineUser() async {

  }

  @override
  void initState() {
    connectedlistRef = FirebaseDatabase.instance.reference().child('.info/connected');
    subscription = connectedlistRef.onValue.listen(handlerFunctionOnline);
    super.initState();
    getTipoUsuarioChat();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    subscription?.cancel();
  }

  void handlerFunctionOnline(Event event) {
    DataSnapshot dataSnapshot = event.snapshot;
    bool myStatus = dataSnapshot.value;
    print(myStatus);// (.info/connected) returns true if you are connected to Firebase otherwise it will be false
    if (myStatus == false) {
      setState(() {
        localIOnlineIndicator = false;
      });
    } else {

      DatabaseReference myidRef = FirebaseDatabase.instance.reference().child('online');



       myidRef.onDisconnect().set({
         'user': Auth.user.email,
        'online': false
       /* 'dtOnline': ServerValue.timestamp,*/
      }).then((a) {
        myidRef.update({
          'user': Auth.user.email,
          'online': true
         /* 'dtOnline': ServerValue.timestamp*/
        });
      });

      setState(() {
        localIOnlineIndicator = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
          backgroundColor: Colors.pinkAccent,
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:(() {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => HomePetScreen(idPet: widget.idPet,idAcessoVetDono: widget.idAcessoVetDono),
                ),
                );
              }
            )
        )),

        body: listaUsuarios != null
            ? Container(
                width: 400,
                height: MediaQuery.of(context).size.height,
                padding: new EdgeInsets.only(top: 15.0, left: 10.0),

               child: ListView.builder(
                  itemCount: listaUsuarios.length,
                  itemBuilder: ((context, index) {

                    return new Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),

                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          color: const Color(0xFFFFFFFF),
                          elevation: 4.0,
                          child: ListTile(

                            leading:  Badge(
                              badgeColor: localIOnlineIndicator ? Colors.green : Colors.grey,
                              badgeContent: Container(
                                width: 12,
                                height: 12,
                              ),
                              child:  Container(
                                width: 50,
                                height: 50,
                                child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(listaUsuarios[index].data['imagemUrl']),
                                  radius: 20.0,
                                ),
                              ),
                            ),

                            title: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(listaUsuarios[index].data['nome'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),

                               /* IconButton(
                                  icon: Icon(
                                    Icons.brightness_1,
                                    color: localIOnlineIndicator ? Colors.green : Colors.grey,//green shows that you are Online
                                  ),
                                  onPressed: () async {
                                    localIOnlineIndicator
                                        ? await FirebaseDatabase.instance.goOffline()//Manually sets Offline by disconnecting ourselfs from Firebase
                                        : FirebaseDatabase.instance.goOnline();//Manually set Online by Re connecting to Firebase database
                                  },
                                ),*/



                                /*new Icon(
                                    Icons.add_alert,
                                    color: Colors.pinkAccent),*/
                              ],
                            ),

                            subtitle: Text(listaUsuarios[index].data['email'],
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          name: listaUsuarios[index].data['nome'],
                                          photoUrl: listaUsuarios[index].data['imagemUrl'],
                                          receiverUid: listaUsuarios[index].data['email'])));
                            }),
                          ),
                        ),
                    );
                  }),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
