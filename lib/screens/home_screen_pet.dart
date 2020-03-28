import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_finey/animation/fade_animation.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/helper/size_config.dart';
import 'package:flutter_finey/model/cadastro_pet.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/screens/agenda_screen.dart';
import 'package:flutter_finey/screens/consulta_screen.dart';
import 'package:flutter_finey/screens/exame_screen.dart';
import 'package:flutter_finey/screens/home_pet_widgets/home_adm_perfil.dart';
import 'package:flutter_finey/screens/social_widgets/ui/insta_home_screen.dart';
import 'package:flutter_finey/screens/vacina_screen.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/service/cadastro_pet.dart';
import 'package:flutter_finey/styles/common_variables.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import '../config/application.dart';
import '../config/routes.dart';
import './common_widgets/finey_drawer.dart';
import './home_widgets/home_header.dart';
import './home_widgets/home_bar.dart';
import 'chat_users_screen.dart';
import 'common_widgets/responsive_image.dart';
import 'descobrir_pet_screen.dart';
import 'home_pet_widgets/home_editar_pet_screen.dart';
import 'home_pet_widgets/home_vet_perfil.dart';
import 'home_widgets/home_adm_bar.dart';
import 'home_widgets/home_vet_bar.dart';
import 'package:social_share_plugin/social_share_plugin.dart';


class HomePetScreen extends StatefulWidget {
  HomePetScreen({@required this.idPet, this.idAcessoVetDono});

  final String idPet;
  final String idAcessoVetDono;

  @override
  _HomePetScreenState createState() => new _HomePetScreenState();
}

class _HomePetScreenState extends State<HomePetScreen> {
  FirebaseUser firebaseUser;
  User dono;
  CadastroPet dadosCadastroPet;
  final Color green = Color(0xFF1E8161);
  final db = Firestore.instance;
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  Uint8List byteDataImage;

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
    _recuperaUser();
    _networkImageToByte();
  }

  Future<Uint8List> _networkImageToByte() async {
    Uint8List byteImage = await networkImageToByte('https://firebasestorage.googleapis.com/v0/b/animal-home-care.appspot.com/o/maikejo%40gmail.com%2Favatar_pet%2Favatar_pet?alt=media&token=8932220f-3d61-4a63-84ea-521822f46861');

    setState(() {
      byteDataImage = byteImage;
    });

    return byteImage;
  }

  void _compartilharFoto() async{
    await Share.file('Meu pet usa - HelpVet App', 'pet.png', byteDataImage, 'image/png', text: 'Meu pet usa - HelpVet App');
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('usuarios')
          .document(Auth.user.email)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'br.com.pet.pethomecare'
          : 'br.com.pet.pethomecareIos',
      'HelpVet',
      'Chat',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
      //icon: 'ic_launcher',
      largeIcon: 'ic_launcher',
      largeIconBitmapSource: BitmapSource.Drawable,
      vibrationPattern: vibrationPattern,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
            EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: Colors.pinkAccent,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.pinkAccent,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.pinkAccent,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }

  void _recuperaUser() async {
    FirebaseUser _firebaseUser = await Auth.getCurrentFirebaseUser();
    User user;

    if(widget.idAcessoVetDono != null){
       user = await Auth.getDadosUser(widget.idAcessoVetDono);
    }else{
       user = await Auth.getDadosUser(_firebaseUser.email);
    }

    setState(() {
      firebaseUser = _firebaseUser;
      dono = user;
    });
  }

  void _redirectAddPetScreen(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeEditarPetScreen(idPet: widget.idPet),
      ),
    );
  }

  void _redirectChatScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatUsersScreen(
                idPet: widget.idPet, idAcessoVetDono: widget.idAcessoVetDono),
      ),
    );
  }

  void _redirectHomeScreen() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_HOME,
        transition: TransitionType.fadeIn);
  }

  void _redirectLocalizacaoPetScreen() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_LOCALIZACAO_PET,
        transition: TransitionType.fadeIn);
  }

  void _redirectDescobrirPetScreen() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return DescobriPetScreen();
        }
    );
  }

  void _redirectQrCodeScreen() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_QR_CODE,
        transition: TransitionType.fadeIn);
  }

  void _redirectTimeLineScreen() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_TIMELINE,
        transition: TransitionType.fadeIn);
  }

  void _redirectTutorialScreen() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_TUTORIAL,
        transition: TransitionType.fadeIn);
  }

  void _redirectSocialScreen() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_TUTORIAL,
        transition: TransitionType.fadeIn);
  }

  calcularIdade(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Widget _buildWithConstraints(BuildContext context, BoxConstraints constraints) {
    final sizeConfig = SizeConfig(mediaQueryData: MediaQuery.of(context));

    var column = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[

        HomeHeader(),

        widget.idAcessoVetDono != null ?
        //VISUALIZA DADOS ACESSANDO - PERFIL VETERINARIO
        FutureBuilder(
            future: Auth.getDadosUser(widget.idAcessoVetDono),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

            if (snapshot.data != null) {
              if(snapshot.data.tipo == 'CLI'){
                return Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              FutureBuilder(
                                  future: CadastroPetService.getCadastroPet(widget.idAcessoVetDono,widget.idPet),
                                  builder: (BuildContext context, AsyncSnapshot<CadastroPet> snapshot) {
                                    if (snapshot.data != null) {

                                      int idade = calcularIdade(snapshot.data.dataNascimento.toDate());

                                      return Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                           FadeIn(1,Container(
                                              padding: EdgeInsets.only(top: 16),
                                              width: MediaQuery.of(context).size.width,
                                              height: sizeConfig.dynamicScaleSize(size: 260),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color(0xFFF58524),
                                                    Color(0XFFF92B7F),
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
                                                        padding: const EdgeInsets.only(
                                                            left: 16),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Text(
                                                              'Raça',
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                            Text(
                                                              snapshot.data.raca,
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Badge(
                                                        position: BadgePosition.bottomLeft(),
                                                        badgeColor: Colors.green,
                                                        badgeContent: Container(
                                                          width: 40,
                                                          height: 40,
                                                          child: CircleAvatar(
                                                            backgroundImage: dono.imagemUrl == null
                                                                ? AssetImage('images/ic_blank_image.png')
                                                                : CachedNetworkImageProvider(dono.imagemUrl),
                                                            radius: 20.0,
                                                          ),
                                                        ),
                                                        child:  Container(
                                                          width: 120,
                                                          height: 120,
                                                          child: CircleAvatar(
                                                            backgroundImage: snapshot.data.urlAvatar == null
                                                                ? AssetImage('images/ic_blank_image.png')
                                                                : CachedNetworkImageProvider(snapshot.data.urlAvatar),
                                                            radius: 20.0,
                                                          ),
                                                        ),
                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            right: 16),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Text(
                                                              'Idade',
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                            Text(
                                                              idade.toString(),
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 16, bottom: 30),
                                                    child: Text(
                                                      snapshot.data.nome,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),

                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF162A49),
                                                      borderRadius: BorderRadius.only(
                                                          bottomRight: Radius.circular(18),
                                                          bottomLeft: Radius.circular(18)
                                                      ),
                                                    ),
                                                    height: 50.0,
                                                    padding: const EdgeInsets.all(1.0),

                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[

                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 16, right: 16),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[

                                                              Column(
                                                                children: <Widget>[
                                                                  IconButton(
                                                                    icon: Icon(
                                                                      Icons.add_to_home_screen,
                                                                      color: Colors.white,
                                                                    ),
                                                                    onPressed: _redirectTutorialScreen,
                                                                  ),
                                                                ],
                                                              ),

                                                              Column(
                                                                children: <Widget>[
                                                                  IconButton(
                                                                    icon: Icon(
                                                                      Icons.video_library,
                                                                      color: Colors.white,
                                                                    ),
                                                                    onPressed: null,
                                                                  ),
                                                                ],
                                                              ),

                                                              Column(
                                                                children: <Widget>[

                                                                  IconButton(
                                                                    icon: Icon(
                                                                      Icons.favorite,
                                                                      color: Colors.white,
                                                                    ),
                                                                    onPressed: (){

                                                                    },
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
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

                              FadeIn(1,Container(
                                height: sizeConfig.dynamicScaleSize(size: 280),
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
                                                  image: new ExactAssetImage("images/icons/ic_vacina.png"),
                                                  width: 32.0,
                                                  height: 32.0),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => VacinaScreen(idPet: widget.idPet,idAcessoVetDono : widget.idAcessoVetDono),
                                                  ),
                                                );

                                              },
                                            ),

                                            Text(
                                              'Vacinas',
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
                                                  image: new ExactAssetImage("images/icons/ic_exames.png"),
                                                  width: 32.0,
                                                  height: 32.0),
                                              onPressed: () {

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ExameScreen(idPet: widget.idPet,idAcessoVetDono : widget.idAcessoVetDono),
                                                  ),
                                                );

                                              },
                                            ),

                                            Text(
                                              'Exames',
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
                                                  image: new ExactAssetImage("images/icons/ic_laudo.png"),
                                                  width: 32.0,
                                                  height: 32.0),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ConsultaScreen(idPet: widget.idPet,idAcessoVetDono : widget.idAcessoVetDono),
                                                  ),
                                                );
                                              },
                                            ),

                                            Text(
                                              'Consultas',
                                              style: TextStyle(
                                                  color: Colors.grey,
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

                                        widget.idAcessoVetDono == null ? Column(
                                          children: <Widget>[

                                            IconButton(
                                              icon: Icon(
                                                Icons.date_range,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => AgendaScreen(idPet: widget.idPet),
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
                                        ) : Column(),

                                        widget.idAcessoVetDono == null ? Column(
                                          children: <Widget>[

                                            IconButton(
                                              icon: Icon(
                                                Icons.access_alarm,
                                                color: Colors.grey,
                                              ),
                                              onPressed: _redirectTimeLineScreen,
                                            ),

                                            Text(
                                              'Timeline',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                            )

                                          ],
                                        ) : Column(),

                                        widget.idAcessoVetDono == null ? Column(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(
                                                Icons.visibility,
                                                color: Colors.grey,
                                              ),
                                              onPressed: _redirectQrCodeScreen,
                                            ),

                                            Text(
                                              'QR Code',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                            )

                                          ],
                                        ) : Column(),
                                      ],
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ]));
              }
              else{
                return HomeVetPerfil();
              }
            }else{
              return SizedBox(height: 500);
            }
            }) :

        //VISUALIZACAO USUARIO
        FutureBuilder(
            future: Auth.getDadosUser(Auth.user.email),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

              if (snapshot.data != null) {
                if(snapshot.data.tipo == 'CLI'){
                  return Expanded(
                    child: Column(
                      children: <Widget>[
                        FutureBuilder(
                            future: CadastroPetService.getCadastroPet(Auth.user.email,widget.idPet),
                            builder: (BuildContext context, AsyncSnapshot<CadastroPet> snapshot) {
                              if (snapshot.data != null) {

                                int idade = calcularIdade(snapshot.data.dataNascimento.toDate());

                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FadeIn(1,Container(
                                        padding: EdgeInsets.only(top: 16),
                                        width: MediaQuery.of(context).size.width,
                                        height: sizeConfig.dynamicScaleSize(size: 255),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFFF58524),
                                              Color(0XFFF92B7F),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(45),
                                              bottomLeft: Radius.circular(45)),
                                        ),
                                        child: Column(
                                          children: <Widget>[

                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 16),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        'Raça',
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                      Text(
                                                        snapshot.data.raca,
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                               FadeIn(1, Badge(
                                                  position: BadgePosition.bottomLeft(),
                                                  badgeColor: Colors.green,
                                                  badgeContent: Container(
                                                    width: 40,
                                                    height: 40,
                                                    child: CircleAvatar(
                                                      backgroundImage: dono.imagemUrl == null
                                                          ? AssetImage('images/ic_blank_image.png')
                                                          : CachedNetworkImageProvider(dono.imagemUrl),
                                                      radius: 20.0,
                                                    ),
                                                  ),
                                                  child:  Container(
                                                    width: 120,
                                                    height: 120,
                                                    child: CircleAvatar(
                                                      backgroundImage: snapshot.data.urlAvatar == null
                                                          ? AssetImage('images/ic_blank_image.png')
                                                          : CachedNetworkImageProvider(snapshot.data.urlAvatar),
                                                      radius: 20.0,
                                                    ),
                                                  ),
                                                )),

                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 16),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        'Idade',
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                      Text(
                                                        idade.toString(),
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 21, bottom: 25),
                                              child: Text(
                                                snapshot.data.nome,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),

                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFF162A49),
                                                borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(18),
                                                  bottomLeft: Radius.circular(18)
                                                ),
                                              ),
                                              height: 50.0,
                                              padding: const EdgeInsets.all(1.0),

                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[

                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 16, right: 16),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[

                                                        Column(
                                                          children: <Widget>[
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.add_to_home_screen,
                                                                color: Colors.white,
                                                              ),
                                                              onPressed: _redirectTutorialScreen,
                                                            ),
                                                          ],
                                                        ),

                                                        Column(
                                                          children: <Widget>[
                                                            IconButton(
                                                                icon: ResponsiveImage(
                                                                    image: new ExactAssetImage("images/icons/ic_chatpet.png"),
                                                                    width: 50.0,
                                                                    height: 50.0),
                                                                onPressed: () {
                                                                  Navigator.push(context,
                                                                    MaterialPageRoute(builder: (context) => InstaHomeScreen(),
                                                                    ),
                                                                  );
                                                                }
                                                            ),
                                                          ],
                                                        ),

                                                        Column(
                                                          children: <Widget>[

                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.share,
                                                                color: Colors.white,
                                                              ),
                                                              onPressed: (){
                                                                //Share.text('HelpVet', 'Meu pet usa o HelpVet', 'text/plain');
                                                                _compartilharFoto();
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
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
                            height: sizeConfig.dynamicScaleSize(size: 270),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(35),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[

                                    Column(
                                      children: <Widget>[

                                        Container(
                                          child:  Card(
                                            elevation: 10,
                                            color: Colors.indigo,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              side: BorderSide(color: Colors.white),
                                            ),

                                            child: InkWell(
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                        icon: ResponsiveImage(
                                                            image: new ExactAssetImage("images/icons/ic_vacina.png"),
                                                            width: 42.0,
                                                            height: 42.0),
                                                        onPressed: () {
                                                          Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) => VacinaScreen(idPet: widget.idPet),
                                                            ),
                                                          );
                                                        }
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Vacina",style: TextStyle(color: Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          width: 90.0,
                                        ),

                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          width: 90.0,
                                          child: Card(
                                            elevation: 10,
                                            color: Colors.teal,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              side: BorderSide(color: Colors.white),
                                            ),

                                            child: InkWell(
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                        icon: ResponsiveImage(
                                                            image: new ExactAssetImage("images/icons/ic_exames.png"),
                                                            width: 42.0,
                                                            height: 42.0),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => ExameScreen(idPet: widget.idPet),
                                                            ),
                                                          );
                                                        }
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Exames",style: TextStyle(color: Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          width: 90.0,
                                          child: Card(
                                            elevation: 10,
                                            color: Colors.orange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              side: BorderSide(color: Colors.white),
                                            ),

                                            child: InkWell(
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                        icon: ResponsiveImage(
                                                            image: new ExactAssetImage("images/icons/ic_laudo.png"),
                                                            width: 42.0,
                                                            height: 42.0),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => ConsultaScreen(idPet: widget.idPet),
                                                            ),
                                                          );
                                                        }
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Consultas",style: TextStyle(color: Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20.0),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[

                                        Container(
                                          width: 90.0,
                                          child: Card(
                                            elevation: 10,
                                            color: Colors.pinkAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              side: BorderSide(color: Colors.white),
                                            ),

                                            child: InkWell(
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                        icon: ResponsiveImage(
                                                            image: new ExactAssetImage("images/icons/ic_agendamento.png"),
                                                            width: 42.0,
                                                            height: 42.0),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => AgendaScreen(idPet: widget.idPet),
                                                            ),
                                                          );
                                                        }
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Agenda",style: TextStyle(color: Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[

                                        Container(
                                          width: 90.0,
                                          child: Card(
                                            elevation: 10,
                                            color: Colors.deepOrange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              side: BorderSide(color: Colors.white),
                                            ),

                                            child: InkWell(
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                        icon: ResponsiveImage(
                                                            image: new ExactAssetImage("images/icons/ic_timeline.png"),
                                                            width: 42.0,
                                                            height: 42.0),
                                                      onPressed: _redirectTimeLineScreen,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Timeline",style: TextStyle(color: Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[

                                        Container(
                                          width: 90.0,
                                          child: Card(
                                            elevation: 10,
                                            color: Colors.indigoAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              side: BorderSide(color: Colors.white),
                                            ),

                                            child: InkWell(
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: ResponsiveImage(
                                                          image: new ExactAssetImage("images/icons/ic_qrcode.png"),
                                                          width: 42.0,
                                                          height: 42.0),
                                                      onPressed: _redirectQrCodeScreen,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("QR Code",style: TextStyle(color: Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))
                      ],
                    ),
                  );
                }
                else if(snapshot.data.tipo == 'VET'){
                  return HomeVetPerfil();
                }else{
                  return HomeAdmPerfil();
                }
              }else{
                return SizedBox();
              }
            }
        ),

        //MENU RODAPE
        Container(
          height: 80.0,
          child: FutureBuilder(
              future: Auth.getDadosUser(Auth.user.email),
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

                if(snapshot.data != null){

                  if(snapshot.data.tipo == 'CLI'){
                    return widget.idAcessoVetDono == null ? FadeAnimation(2, HomeBar(
                      handleClickChatButton: _redirectChatScreen,
                      handleClickAddPetButton: _redirectAddPetScreen,
                      handleClickMainButton: _redirectHomeScreen,
                      handleClickLocalizacaoButton: _redirectLocalizacaoPetScreen,
                      handleClickBoneButton: _redirectDescobrirPetScreen,
                    )) : Container();

                  }else if(snapshot.data.tipo == 'VET'){
                    return widget.idAcessoVetDono == null ? FadeAnimation(2, HomeVetBar(
                      handleClickChatButton: _redirectChatScreen,
                      handleClickAddPetButton: null,
                      handleClickMainButton: null,
                      handleClickLocalizacaoButton: _redirectLocalizacaoPetScreen,
                    )) : Container();

                  }else if(snapshot.data.tipo == 'ADM'){
                    return widget.idAcessoVetDono == null ? FadeAnimation(2, HomeAdmBar(
                      handleClickChatButton: _redirectChatScreen,
                      handleClickAddPetButton: null,
                      handleClickMainButton: null,
                      handleClickLocalizacaoButton: _redirectLocalizacaoPetScreen,
                    )) : Container();
                  }

                }else{
                  return SizedBox();
                }

              }
          ),
        ),

      ]
    );


    var constrainedBox = ConstrainedBox(
        constraints: constraints.copyWith(maxHeight: MediaQuery.of(context).size.height),
        child: Container(
            color: Colors.white,
            //padding: EdgeInsets.only(bottom: CommonVariables(context: context).getScreenPaddingBottom()),
            child: column)
    );

    var scrollView = SingleChildScrollView(child: constrainedBox);

    return scrollView;
  }

  @override
  Widget build(BuildContext context) {
    var layoutBuilder = LayoutBuilder(builder: _buildWithConstraints);
    var scaffold = Scaffold(
        body: layoutBuilder,
        drawer: FineyDrawer(
            rootContext: context,
            currentPath: RouteConstants.ROUTE_HOME,
            firebaseUser: firebaseUser));
    return scaffold;
  }
}
