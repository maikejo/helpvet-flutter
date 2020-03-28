import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/helper/size_config.dart';
import 'package:flutter_finey/model/cadastroPetVision.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/model/translate_cloud.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'common_widgets/responsive_container.dart';
import 'common_widgets/responsive_padding.dart';
import 'package:flutter_finey/screens/info_descobrir_pet_screen.dart';

class DescobriPetScreen extends StatefulWidget {

  @override
  _DescobriPetScreenState createState() => _DescobriPetScreenState();
}

class _DescobriPetScreenState extends State<DescobriPetScreen> with SingleTickerProviderStateMixin {
  File _fileController;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String _urlFoto;

  @override
  void initState() {
    super.initState();
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight:  500 , maxWidth: 500);
    setState(() {
      _fileController = image;
    });

    try{
      if(_fileController != null) {
        Dialogs.showLoadingDialog(context, _keyLoader);
        _atualizaAvatar();
      }
    }catch(e){
      print('erro');
    }
  }

  void _atualizaAvatar() async{
    String fileName = "avatar";
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(Auth.user.email + "/descobrirPet/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
    _urlFoto = await (await uploadTask.onComplete).ref.getDownloadURL();

    buscarDadosFotoPet(_urlFoto);
  }

  Future<CadastroPetVision> buscarDadosFotoPet(String urlFoto) async {

    final response =
    await http.post('https://vision.googleapis.com/v1/images:annotate?key=AIzaSyCVFqFS6Wtubn4Q5Y6BUk3MvV_18dkTzCA',
      headers: {
        HttpHeaders.authorizationHeader: "104161238808375259389",
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.contentTypeHeader: "application/json"},
      body: json.encode({
        "requests": [
          {
            "image": {
              "source": {
                "imageUri": urlFoto
              },
            },
            "features": [
              {
                "type": "LABEL_DETECTION"
              }
            ],
            "imageContext": {
              "languageHints": [
                "en", "pt"
              ]
            }
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      List<TranslateCloud> listaDescricao = [];
      final jsonData = json.decode(response.body);
      final resposnses = jsonData['responses'];
      print(resposnses);

        for (var lista in resposnses){
          var labels = lista['labelAnnotations'];

          for(var listaInfo in labels){
            var description = listaInfo['description'];
            var score = listaInfo['score'];
            var descricao = description;

            String descricaoTraduzida = await traduzirDadosFotoPet(descricao);
            TranslateCloud translateCloud = new TranslateCloud(description: descricaoTraduzida,score: score);

            listaDescricao.add(translateCloud);

          }

          Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          Navigator.pop(context);

          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              context: context,
              builder: (BuildContext context) {
                return InfoDescobrirPetScreen(listaInfo: listaDescricao, foto: _urlFoto);
              }
          );

      }

    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to load post');
    }
  }

  Future<String> traduzirDadosFotoPet(String texto) async {

    final response =
    await http.get('https://translation.googleapis.com/language/translate/v2?target=pt&key=AIzaSyAtkQztwa1-tozTi1jZzSGN97ey62a2uuI&q=' + texto,
      headers: {
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.contentTypeHeader: "application/json"},
    );

    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = json.decode(response.body);
      final datas = jsonData['data'];
      final translations = datas['translations'];
      print(translations);

      for (var lista in translations) {
        var translatedText = lista['translatedText'];
        return translatedText;
      }

    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to load post');
    }

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
            padding: EdgeInsets.only(top: 20.0),
            child: Text('Saiba mais do seu pet ' ,
                style: TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.pink,
                    fontSize: 24
                )),
          ),

          Container(
            padding: EdgeInsets.only(top: 30.0),
            child: new CircleAvatar(
              radius: 65.0,
              backgroundImage: AssetImage(
                  "images/icons/ic_descobrir_pet.png"),
            ),
          ),

          Container(
            width: 300.0,
            padding: EdgeInsets.only(top: 20.0),
            child: Text('Tire a foto de um animal e descubra o seu tipo,raça,tamanho aproximado entre outras informações.' ,
                style: TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                    fontSize: 18
                )),
          ),

          ResponsivePadding(
              padding: const EdgeInsets.only(top: 40.0),
              child: ResponsiveContainer(
                  width: 200.0,
                  height: 50.0,

                  child: new FloatingActionButton.extended(
                      heroTag: "btDescobrirPet",
                      label: Text("Tirar Foto"),
                      backgroundColor: Colors.blueAccent,
                      icon: const Icon(Icons.phone_iphone),
                      onPressed: () {
                        getImageFromCamera();
                      })
              )
          ),
        ],
      ),
    );
  }
}