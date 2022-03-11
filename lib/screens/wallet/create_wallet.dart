
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';

class CreateWalletScreen extends StatefulWidget {
  CreateWalletScreen({@required this.isWalletCreated});
  final String isWalletCreated;

  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final Firestore datbase = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Application.router.navigateTo(
                context, RouteConstants.ROUTE_HOME,
                transition: TransitionType.fadeIn),
          ),
        backgroundColor: Color.fromRGBO(38, 81, 158, 1),
        title: Text('Criar Carteira'),
      ),

      body: Stack(
        children: <Widget>[
          //Container for top data
          Container(
            margin: EdgeInsets.symmetric(horizontal: 45, vertical: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Container(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text("Carteira", style: TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.w700),),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 25),
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text("Crie ou importe sua carteira para começar a realizar transações das suas moedas digitais.", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),),
                ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 25),
                    child: Card(
                        elevation: 20,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: 600,
                          height: 160,
                          child: Center(child: Text('Criar Carteira', style: TextStyle(fontSize: 25))),
                        )),
                  ),

                Container(
                  child: Card(
                      elevation: 20,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                        width: 600,
                        height: 160,
                        child: Center(child: Text('Importar Carteira', style: TextStyle(fontSize: 25))),
                      )),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
