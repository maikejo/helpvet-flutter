import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/helper/size_config.dart';
import 'package:flutter_finey/model/cadastroPetVision.dart';
import 'package:flutter_finey/screens/signup_screen.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/model/translate_cloud.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'common_widgets/responsive_container.dart';
import 'common_widgets/responsive_image.dart';
import 'common_widgets/responsive_padding.dart';
import 'package:flutter_finey/screens/info_descobrir_pet_screen.dart';

class EscolherSignupScreen extends StatefulWidget {

  @override
  _EscolherSignupScreenState createState() => _EscolherSignupScreenState();
}

class _EscolherSignupScreenState extends State<EscolherSignupScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  void _redirectConta(String tpConta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SignupScreen(tipoConta: tpConta),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeConfig = SizeConfig(mediaQueryData: MediaQuery.of(context));

    return Container(
      width: MediaQuery.of(context).size.width,
      height: sizeConfig.dynamicScaleSize(size: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          ResponsivePadding(
            padding: EdgeInsets.only(top: 40.0),
            child: Text('Tipo de Conta ' ,
                style: TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.pink,
                    fontSize: 24
                )),
          ),

          ResponsivePadding(
            padding: EdgeInsets.only(top: 40.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

            GestureDetector(
               child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Container(
                          height: 70.0,
                          width: 70.0,
                          //padding: EdgeInsets.only(top: 30.0),
                          child: new CircleAvatar(
                            backgroundColor: Colors.grey[50],
                            radius: 65.0,
                            backgroundImage: AssetImage(
                                "images/icons/ic_conta_pet.png"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Dono Pet",style: TextStyle(color: Colors.indigo),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              onTap: () {
                _redirectConta("CLI");
              },
            ),

            GestureDetector(
               child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 70.0,
                          width: 70.0,
                          //padding: EdgeInsets.only(top: 30.0),
                          child: new CircleAvatar(
                            radius: 65.0,
                            backgroundImage: AssetImage(
                                "images/icons/ic_conta_vet.png"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Veterinário",style: TextStyle(color: Colors.indigo),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              onTap: () {
                _redirectConta("VET");
              },
            ),

                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 70.0,
                          width: 70.0,
                          //padding: EdgeInsets.only(top: 30.0),
                          child: new CircleAvatar(
                            backgroundColor: Colors.pinkAccent[100],
                            radius: 65.0,
                            backgroundImage: AssetImage(
                                "images/icons/ic_conta_clinica.png"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Clínica",style: TextStyle(color: Colors.indigo),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),

          ResponsivePadding(
              padding: const EdgeInsets.only(top: 40.0),
              child:    Container(
                width: 300.0,
                padding: EdgeInsets.only(top: 20.0),
                child: Text('Selecione o tipo de conta de acordo com seu perfil.' ,
                    style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                        fontSize: 18
                    )),
              ),
          ),
        ],
      ),
    );
  }
}