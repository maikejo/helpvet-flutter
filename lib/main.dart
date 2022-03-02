import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_finey/screens/chat_widgets/call_screens/provider/user_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import './config/routes.dart';
import './config/application.dart';
import './styles/common_colors.dart';
import 'package:flutter/material.dart' hide Router;

class MainApp extends StatefulWidget {
  MainApp({Key key, @required this.currentUserId}) : super(key: key);
  final String currentUserId;

  @override
  State createState() => MainAppState();
}

class MainAppState extends State<MainApp> {

  MainAppState({Key key}) {
    var router = new FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  //final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  //final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],

      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animal - Home Care',
      theme: new ThemeData(
        //fontFamily: 'Quicksand',
        primarySwatch: Colors.blue,
        hintColor: CommonColors.gray,
        dividerColor: Colors.white,
      ),
      onGenerateRoute: Application.router.generator,
      ),
    );
  }
}


Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MainApp());
}
