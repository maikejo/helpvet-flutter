import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_animation.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/helper/size_config.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_image.dart';
import 'package:flutter_finey/screens/home_admin_screen/clinicas_admin_screen.dart';
import 'package:flutter_finey/screens/home_admin_screen/doenca_admin_screen.dart';
import 'package:flutter_finey/screens/home_admin_screen/planos_admin_screen.dart';
import 'package:flutter_finey/screens/home_admin_screen/tipoPet_admin_screen.dart';
import 'package:flutter_finey/screens/home_admin_screen/tutorial_admin_screen.dart';
import 'package:flutter_finey/screens/home_admin_screen/vet_admin_screen.dart';
import 'package:flutter_finey/service/auth.dart';

class HomeAdmPerfil extends StatelessWidget {
  HomeAdmPerfil({this.idAdm});

  final String idAdm;

  @override
  Widget build(BuildContext context) {

  final sizeConfig = SizeConfig(mediaQueryData: MediaQuery.of(context));

   return Expanded(
        child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  FutureBuilder(
                      future: Auth.getDadosUser(this.idAdm == null ? Auth.user.email : this.idAdm),
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
                                  height: sizeConfig.dynamicScaleSize(size: 262),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.blue[600],
                                        Colors.blue[200],
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
                                                  "023402",
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
                                                  "Adm",
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
                    height: sizeConfig.dynamicScaleSize(size: 330),
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
                                      image: new ExactAssetImage("images/icons/ic_tutorial.png"),
                                      width: 32.0,
                                      height: 32.0),
                                  onPressed: () {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TutorialAdminScreen(),
                                      ),
                                    );

                                  },
                                ),

                                Text(
                                  'Tutoriais',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  icon: ResponsiveImage(
                                      image: new ExactAssetImage("images/icons/ic_videos.png"),
                                      width: 32.0,
                                      height: 32.0),
                                  onPressed: () {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TipoPetAdminScreen(),
                                      ),
                                    );

                                  },
                                ),

                                Text(
                                  'Videos',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[

                                IconButton(
                                  icon: ResponsiveImage(
                                      image: new ExactAssetImage("images/icons/ic_pet_adm.png"),
                                      width: 32.0,
                                      height: 32.0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TipoPetAdminScreen(),
                                      ),
                                    );
                                  },
                                ),

                                Text(
                                  'Tipo Pet',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[

                                IconButton(
                                  icon: ResponsiveImage(
                                      image: new ExactAssetImage("images/icons/ic_planos.png"),
                                      width: 32.0,
                                      height: 32.0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlanosAdminScreen(),
                                      ),
                                    );
                                  },
                                ),

                                Text(
                                  'Planos',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[

                                IconButton(
                                  icon: ResponsiveImage(
                                      image: new ExactAssetImage("images/icons/ic_vet_adm.png"),
                                      width: 32.0,
                                      height: 32.0),
                                  onPressed: () {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VeterinarioAdminScreen(),
                                      ),
                                    );

                                  },
                                ),

                                Text(
                                  'Veterinários',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )

                              ],
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  icon: ResponsiveImage(
                                      image: new ExactAssetImage("images/icons/ic_clinica_vet.png"),
                                      width: 32.0,
                                      height: 32.0),
                                  onPressed: () {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ClinicasAdminScreen(),
                                      ),
                                    );

                                  },
                                ),

                                Text(
                                  'Clínicas',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )

                              ],
                            ),
                          ],
                        ),

                        //SizedBox(height: 30.0),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[

                                IconButton(
                                  icon: ResponsiveImage(
                                      image: new ExactAssetImage("images/icons/ic_doenca.png"),
                                      width: 32.0,
                                      height: 32.0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DoencaPetAdminScreen(),
                                      ),
                                    );
                                  },
                                ),

                                Text(
                                  'Doenças',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ]));
  }
}
