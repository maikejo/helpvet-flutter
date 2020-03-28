import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './config/routes.dart';
import './config/application.dart';
import './styles/common_colors.dart';

class MainApp extends StatefulWidget {
  MainApp({Key key, @required this.currentUserId}) : super(key: key);
  final String currentUserId;

  @override
  State createState() => MainAppState();
}

class MainAppState extends State<MainApp> {

  MainAppState({Key key}) {
    var router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final app = new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animal - Home Care',
      theme: new ThemeData(
        //fontFamily: 'Quicksand',
        primarySwatch: Colors.blue,
        hintColor: CommonColors.gray,
        dividerColor: Colors.white,
      ),
      onGenerateRoute: Application.router.generator,
    );
    // print("initial route = ${app.initialRoute}");
    return app;
  }
}

void main() => runApp(new MainApp());
