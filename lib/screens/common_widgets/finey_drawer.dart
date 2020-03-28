import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/screens/home_widgets/perfil_screen.dart';
import 'package:flutter_finey/service/auth.dart';

import '../../config/application.dart';
import '../../config/routes.dart';
import '../common_widgets/responsive_container.dart';
import '../common_widgets/responsive_padding.dart';
import '../common_widgets/responsive_image.dart';
import '../common_widgets/circle_image.dart';
import '../../styles/common_styles.dart';
import '../../styles/common_variables.dart';
import '../../styles/common_colors.dart';
import '../home_screen_pet.dart';

class FineyDrawer extends StatelessWidget {
  FineyDrawer({this.rootContext, this.currentPath, this.firebaseUser,this.idAcessoVetDono});

  final FirebaseUser firebaseUser;
  final BuildContext rootContext;
  final currentPath;
  final idAcessoVetDono;
  String tipoConta;

  Widget _userInfo(context) {
    return ResponsivePadding(
        padding: const EdgeInsets.symmetric(horizontal: 42.0),
        child: InkWell(
            child: Row(children: <Widget>[
              Expanded(
                child: ResponsivePadding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          StreamBuilder(
                              stream: Auth.getUser(firebaseUser.email),
                              builder: (BuildContext context,
                                  AsyncSnapshot<User> snapshot) {
                                if (snapshot.data != null) {

                                  tipoConta = snapshot.data.tipo;

                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[

                                        GestureDetector(
                                          child:  Container(
                                            height: 70.0,
                                            width: 70.0,
                                            child: CircleAvatar(
                                              backgroundImage: (snapshot.data.imagemUrl != '')
                                                  ? CachedNetworkImageProvider(
                                                  snapshot.data.imagemUrl)
                                                  : AssetImage(
                                                  "assets/images/default.png"),
                                            ),
                                          ),

                                          onTap: ((){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PerfilScreen(idCliente: firebaseUser.email),
                                              ),
                                            );
                                          }),
                                        ),


                                        Text("${snapshot.data.nome}",
                                            style:
                                                CommonStyles(context: context)
                                                    .getHeaderText()),
                                        Text("${snapshot.data.email}"),
                                      ],
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                      child: new CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation(
                                                  Colors.blue),
                                          strokeWidth: 5.0),
                                      height: 50.0,
                                      width: 50.0);
                                }
                              }),
                        ])),
              ),
              ResponsiveImage(
                  image: new ExactAssetImage("images/icons/ic_arrow_right.png"),
                  width: 8.0,
                  height: 12.0)
            ]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerfilScreen(idCliente: firebaseUser.email),
                ),
              );
            }));
  }

  Widget _menuItem(context, String itemText, String routeText, String icon,
      double iconWidth, double iconHeight) {
    if (routeText == currentPath) {
      return _activeItem(
          context, itemText, routeText, icon, iconWidth, iconHeight);
    } else {
      return _normalItem(
          context, itemText, routeText, icon, iconWidth, iconHeight);
    }
  }

  Widget _activeItem(context, String itemText, String route, String icon,
      double iconWidth, double iconHeight) {
    return InkWell(
        child: ResponsivePadding(
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
            child: Row(
              children: <Widget>[
                ResponsiveContainer(
                    width: 35.0,
                    child: Row(children: <Widget>[
                      ResponsiveImage(
                          image: new ExactAssetImage(icon),
                          width: iconWidth,
                          height: iconHeight)
                    ])),
                Text(itemText,
                    style: CommonStyles(context: context).getBlueNormalText())
              ],
            )),
        onTap: () {
          // _redirectToProfileScreen(context);
          Application.router.pop(context);
        });
  }

  Widget _normalItem(context, String itemText, String route, String icon,
      double iconWidth, double iconHeight) {
    return InkWell(
        child: ResponsivePadding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
          child: Row(
            children: <Widget>[
              ResponsiveContainer(
                  width: 35.0,
                  child: Row(children: <Widget>[
                    ResponsiveImage(
                        image: new ExactAssetImage(icon),
                        width: iconWidth,
                        height: iconHeight)
                  ])),
              Text(itemText,
                  style: CommonStyles(context: context).getGrayNormalText())
            ],
          ),
        ),
        onTap: () {
          Application.router
              .navigateTo(context, route, clearStack: true, replace: true);
        });
  }

  Widget _backButton(context) {
    return ResponsivePadding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: ResponsiveContainer(
            width: 48.0,
            height: 48.0,
            decoration: const BoxDecoration(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(100.0))),
            child: new FloatingActionButton(
                heroTag: "btSair",
                backgroundColor: Colors.pinkAccent,
                child: Center(
                    child: Icon(Icons.arrow_back, color: CommonColors.white)),
                onPressed: () {})));
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = CommonVariables(context: context).getAppBarHeight();

    return Drawer(
        child: ResponsivePadding(
            padding: EdgeInsets.only(top: paddingTop),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _userInfo(context),
                  ResponsivePadding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(children: <Widget>[
                        /*  _menuItem(
                      context,
                      "Ativar Conta",
                      RouteConstants.ROUTE_PROFILE_LESS,
                      "images/icons/ic_done.png",
                      16.0,
                      16.0
                  ),*/
                        _menuItem(
                            context,
                            "Home Pet",
                            RouteConstants.ROUTE_HOME,
                            "images/icons/ic_home.jpg",
                            16.0,
                            16.0),
                        _menuItem(
                            context,
                            "Planos",
                            RouteConstants.ROUTE_PLANOS,
                            "images/icons/ic_report.png",
                            14.0,
                            16.0),

                       Container(
                         height: 30,
                         child: GestureDetector(
                         ),
                       )

                      ]),
                  ),

                  ResponsivePadding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                    height: 1.0,
                                    color: CommonColors.lightGray)),
                          ])),


                  /* ResponsivePadding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: <Widget>[
                  _menuItem(
                    context,
                    "Theme",
                    RouteConstants.ROUTE_LOGIN,
                    "images/icons/ic_theme.png",
                    16.0,
                    14.0
                  ),
                  _menuItem(
                    context,
                    "Help & Support",
                    RouteConstants.ROUTE_LOGIN,
                    "images/icons/ic_help.png",
                    16.0,
                    16.0
                  ),
                  _menuItem(
                    context,
                    "Team & Policy",
                    RouteConstants.ROUTE_LOGIN,
                    "images/icons/ic_policy.png",
                    16.0,
                    16.0
                  ),
                ]
              )
            ),*/
                  ResponsivePadding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                    height: 1.0,
                                    color: CommonColors.lightGray)),
                          ])),

                  ResponsivePadding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(children: <Widget>[
                        _menuItem(
                            context,
                            "Contato",
                            null,
                            //RouteConstants.ROUTE_LOGIN,
                            "images/icons/ic_message.png",
                            16.0,
                            16.0),
                        _menuItem(context, "Sair", RouteConstants.ROUTE_LOGIN,
                            "images/icons/ic_logout.png", 14.1, 16.0)
                      ])
                  ),

                tipoConta == 'VET' ? ResponsivePadding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: ResponsiveContainer(
                          width: 200.0,
                          height: 48.0,

                          child: new FloatingActionButton.extended(
                              heroTag: "btVoltarPerfilVet",
                              label: Text("Voltar Perfil"),
                              backgroundColor: Colors.green,
                              icon: const Icon(Icons.assignment_ind),
                              onPressed: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePetScreen(idAcessoVetDono: idAcessoVetDono),
                                    ),
                                  );

                              }
                          ))) : SizedBox(),

                  SizedBox(height: 10.0),

                  ResponsivePadding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: ResponsiveContainer(
                          width: 200.0,
                          height: 48.0,

                          child: new FloatingActionButton.extended(
                              heroTag: "btAlterarPerfil",
                              label: Text("Alterar Perfil"),
                              backgroundColor: Colors.blueAccent,
                              icon: const Icon(Icons.assignment_ind),
                              onPressed: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PerfilScreen(idCliente: firebaseUser.email),
                                  ),
                                );

                              })))


                ])));
  }
}
