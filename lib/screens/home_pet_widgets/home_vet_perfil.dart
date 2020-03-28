import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/helper/size_config.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_image.dart';
import 'package:flutter_finey/screens/vet_pet_screen.dart';
import 'package:flutter_finey/service/auth.dart';
import '../agenda_screen.dart';
import '../consulta_screen.dart';


class HomeVetPerfil extends StatelessWidget {

  HomeVetPerfil({this.idPet});

  final String idPet;

  @override
  Widget build(BuildContext context) {

   final sizeConfig = SizeConfig(mediaQueryData: MediaQuery.of(context));

   return Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FutureBuilder(
                      future: Auth.getDadosUser(Auth.user.email),
                      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                        if (snapshot.data != null) {

                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                               FadeIn(1, Container(
                                  padding: EdgeInsets.only(top: 16),
                                 width: MediaQuery.of(context).size.width,
                                 height: sizeConfig.dynamicScaleSize(size: 230),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.green[600],
                                        Colors.green[200],
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(42),
                                        bottomLeft: Radius.circular(42)),
                                  ),
                                  child: Column(
                                    children: <Widget>[

                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16),
                                          ),Padding(
                                            padding: const EdgeInsets.only(
                                                left: 1),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  'Registro',
                                                  style: TextStyle(
                                                      color: Colors.white,fontSize: 18),
                                                ),
                                                Text(
                                                  "Total",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: CachedNetworkImageProvider(
                                                        snapshot.data.imagemUrl))),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 70),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  'Conta',
                                                  style: TextStyle(
                                                      color: Colors.white,fontSize: 18),
                                                ),
                                                Text(
                                                  "Vet",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 16, bottom: 32),
                                        child: Text(
                                          snapshot.data.nome,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                 FadeIn(1, Container(
                   height: sizeConfig.dynamicScaleSize(size: 260),
                   width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Column(
                              children: <Widget>[

                                IconButton(
                                  icon: ResponsiveImage(
                                      image: new ExactAssetImage("images/icons/ic_agendamento.png"),
                                      width: 32.0,
                                      height: 32.0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AgendaScreen(),
                                      ),
                                    );
                                  },
                                ),

                                Text(
                                  'Agenda',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[

                                IconButton(
                                  icon: ResponsiveImage(
                                      image: new ExactAssetImage("images/icons/ic_pets.png"),
                                      width: 32.0,
                                      height: 32.0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VetPetScreen(idVet: Auth.user.email,),
                                      ),
                                    );
                                  },
                                ),

                                Text(
                                  'Clientes',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[

                                IconButton(
                                  icon:  ResponsiveImage(
                                      image: new ExactAssetImage("images/icons/ic_laudo.png"),
                                      width: 32.0,
                                      height: 32.0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ConsultaScreen(),
                                      ),
                                    );
                                  },
                                ),

                                Text(
                                  'Diagnosticos',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ]));
  }
}
