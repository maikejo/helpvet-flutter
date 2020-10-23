import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_animation.dart';
import 'package:flutter_finey/helper/size_config.dart';
import 'package:flutter_finey/model/cadastro_pet.dart';
import 'package:flutter_finey/screens/home_screen_pet.dart';
import 'package:flutter_finey/service/auth.dart';
import './common_widgets/finey_drawer.dart';
import './home_widgets/home_header.dart';
import '../config/application.dart';
import '../config/routes.dart';
import 'home_widgets/slide_item.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.idAcessoVetDono, this.idVetAcesso}) : super(key: key);

  final String idAcessoVetDono;
  final String idVetAcesso;

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseUser firebaseUser;
  CadastroPet dadosCadastroPet;
  final db = Firestore.instance;

  void _recuperaUser() async {
    FirebaseUser _firebaseUser = await Auth.getCurrentFirebaseUser();

    setState(() {
      firebaseUser = _firebaseUser;
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperaUser();
  }

  void _redirectAddPetScreen() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_CADASTRO_PET,
        transition: TransitionType.inFromRight);
  }

  Widget _buildWithConstraints(BuildContext context, BoxConstraints constraints) {
    final sizeConfig = SizeConfig(mediaQueryData: MediaQuery.of(context));

    var column = new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          HomeHeader(),
          widget.idAcessoVetDono != null ?

          //VISUALIZA PERFIL DO CLIENTE
          FadeAnimation(1, Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                        stream: db.collection('cadastro_pet').document(widget.idAcessoVetDono).collection("lista").snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data.documents.map((doc) {
                                return GestureDetector(
                                    //padding: EdgeInsets.only(right: 10.0),
                                    child: SlideItem(
                                      img: doc.data['urlAvatar'],
                                      nome: doc.data['nome'],
                                      tipoPet: doc.data['tipoPet'],
                                      rating: doc.data['especie'],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HomePetScreen(
                                            idPet: doc.documentID,
                                            idAcessoVetDono:
                                                widget.idAcessoVetDono,
                                          ),
                                        ),
                                      );
                                    });
                              }).toList(),
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                  ],
                ),
              ),
            )
          : FadeAnimation(1, Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: <Widget>[

                    StreamBuilder<QuerySnapshot>(
                        stream: db.collection('cadastro_pet').document(firebaseUser.email).collection("lista").snapshots(),
                        builder: (context, snapshot) {

                          if (snapshot.data != null) {
                            return Column(
                              children: snapshot.data.documents.map((doc) {
                                return GestureDetector(
                                  //padding: EdgeInsets.only(right: 10.0),
                                    child: SlideItem(
                                      img: doc.data['urlAvatar'],
                                      nome: doc.data['nome'],
                                      tipoPet: doc.data['tipoPet'],
                                      rating: doc.data['especie'],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HomePetScreen(idPet: doc.documentID),
                                        ),
                                      );
                                    },
                                    onLongPress: (() async{
                                        await db
                                            .collection('cadastro_pet').document(Auth.user.email).collection('lista').document(doc.documentID)
                                            .delete();
                                        })
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
            ),

        ]);

    var scrollView = new SingleChildScrollView(
        child: new Container(
          color: Colors.white,
          child: column)
    );

    return scrollView;
  }

  @override
  Widget build(BuildContext context) {
    var layoutBuilder = new LayoutBuilder(builder: _buildWithConstraints);
    var scaffold;

    if (widget.idAcessoVetDono != null) {
      scaffold = new Scaffold(
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 6.0,
            /*child: Container(
              height: 80.0,
              color: Colors.pinkAccent,
            ),*/
          ),
          body: layoutBuilder,
          drawer: FineyDrawer(
              rootContext: context,
              currentPath: RouteConstants.ROUTE_HOME,
              firebaseUser: firebaseUser));
    } else {
      scaffold = Scaffold(
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 6.0,
            child: Container(
              height: 50.0,
              color: Colors.pinkAccent,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton.extended(
              heroTag: "btAddPet",
              label: Text("Adicionar Pet"),
              backgroundColor: Color(0xFF162A49),
              icon: const Icon(Icons.pets),
              onPressed: (_redirectAddPetScreen)),
          body: layoutBuilder,
          drawer: FineyDrawer(
              rootContext: context,
              currentPath: RouteConstants.ROUTE_HOME,
              firebaseUser: firebaseUser,
              idAcessoVetDono: widget.idAcessoVetDono));
    }
    return scaffold;
  }
}
