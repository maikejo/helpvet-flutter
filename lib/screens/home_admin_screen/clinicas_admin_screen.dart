import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/helper/Consts.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../common_widgets/responsive_padding.dart';

class ClinicasAdminScreen extends StatefulWidget {
  @override
  _ClinicasAdminScreenState createState() => new _ClinicasAdminScreenState();
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
}

class _ClinicasAdminScreenState extends State<ClinicasAdminScreen> {
  TextEditingController _cnpjController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nomeController = new TextEditingController();
  TextEditingController _enderecoController = new TextEditingController();

  var youtube = new FlutterYoutube();
  final db = Firestore.instance;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String cnpj;
  String email;
  GeoPoint localizacao;
  String nome;
  bool edicao = false;
  File _fileController;
  String _urlAvatarController;
  PickResult selectedPlace;
  double latitude;
  double longitude;
  Geoflutterfire geo = Geoflutterfire();


  @override
  initState() {
    super.initState();
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight:  200 , maxWidth: 200);
    setState(() {
      _fileController = image;
    });

    try{
      if(_fileController != null) {
        Dialogs.showLoadingDialog(context, _keyLoader);
        uploadFoto(context,Auth.user.email);
      }
    }catch(e){
      print('erro');
    }

  }

  Future uploadFoto(BuildContext context, String email) async {
    String fileName = "clinica";
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(email + "/clinica/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
    _urlAvatarController = await (await uploadTask.onComplete).ref.getDownloadURL();
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  }

  void adicionar(String cnpj,String email,String nome,String endereco){
    GeoFirePoint posicao = geo.point(latitude: latitude, longitude: longitude);

    Firestore.instance.collection('clinicas').document(email).setData({"cnpj" : cnpj, "email": email, "nome": nome , "imagemUrl" : _urlAvatarController, "endereco": endereco, "position": posicao.data});
    Navigator.pop(context);
  }

  void atualizar(String id,String cnpj,String email,String nome,String endereco,GeoPoint geoPoint){
    GeoFirePoint posicao = geo.point(latitude: geoPoint.latitude, longitude: geoPoint.longitude);

    Firestore.instance.collection('clinicas').document(id).updateData({"cnpj" : cnpj, "email": email, "nome": nome,"imagemUrl" : _urlAvatarController,"endereco": endereco, "position": posicao.data});
    Navigator.pop(context);
  }

  Widget modal(bool edicao,String id,String cnpj,String email,GeoPoint localizacao,String nome,String endereco,GeoPoint geoPoint){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return  Container(
            padding: EdgeInsets.only(
              top: Consts.avatarRadius + Consts.padding,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[

                ResponsivePadding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    onTap: () => getImageFromGallery(),
                    child: new Center(
                      child: _fileController == null
                          ? new Stack(
                        children: <Widget>[
                          Container(
                            height: 100.0,
                            width: 100.0,
                            child: new CircleAvatar(
                              radius: 80.0,
                              backgroundImage: AssetImage(
                                  "images/icons/ic_camera.png"),
                            ),
                          ),
                        ],
                      )
                          : new Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: new BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: new DecorationImage(
                            image: new AssetImage(
                                _fileController.path),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                              color: Colors.blue,
                              width: 5.0),
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(80.0)),
                        ),
                      ),
                    ),
                  ),
                ),

                new Material(color: Colors.white,
                    child: Column(
                      children: <Widget>[

                        ResponsivePadding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _nomeController,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.assignment),
                              hintText: 'Nome',
                              labelText: 'Nome da Clínica',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _cnpjController,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.assignment),
                              hintText: 'CNPJ',
                              labelText: 'CNPJ',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.email),
                              hintText: 'E-mail',
                              labelText: 'E-mail',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top:25.0),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FloatingActionButton.extended(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlacePicker(
                                            //KEY_SERVER_API
                                            apiKey: 'AIzaSyCNKo4m4YPHk8CaRz3VSbDMYu1V_s0sips',
                                            initialPosition: ClinicasAdminScreen.kInitialPosition,
                                            searchingText: 'Pesquisando',
                                            hintText: 'Pesquisar clínica',
                                            useCurrentLocation: true,
                                            onPlacePicked: (result) {
                                              selectedPlace = result;
                                              Navigator.of(context).pop();
                                              setState(() {});
                                            },
                                            selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                                              return isSearchBarFocused
                                                  ? Container()
                                                  : FloatingCard(
                                                bottomPosition: MediaQuery.of(context).size.height * 0.05,
                                                leftPosition: MediaQuery.of(context).size.width * 0.25,
                                                width: MediaQuery.of(context).size.width * 0.5,
                                                height: MediaQuery.of(context).size.height * 0.05,
                                                borderRadius: BorderRadius.circular(12.0),
                                                child: state == SearchingState.Searching
                                                    ? Center(child: CircularProgressIndicator())
                                                    : FloatingActionButton.extended(
                                                    heroTag: "btSelecionarClinica",
                                                    label: Text("Selecionar clínica"),
                                                    backgroundColor: Colors.blueAccent,
                                                    icon: const Icon(Icons.add_location),
                                                    onPressed: () {
                                                      _enderecoController.text = selectedPlace.adrAddress;
                                                      latitude = selectedPlace.geometry.location.lat;
                                                      longitude = selectedPlace.geometry.location.lng;

                                                      Navigator.of(context).pop();
                                                    }),
                                              );
                                            },
                                            /*  pinBuilder: (context, state) {
                                           if (state == PinState.Idle) {
                                             return Icon(Icons.favorite_border);
                                           } else {
                                             return Icon(Icons.favorite);
                                           }
                                         },*/
                                          ),
                                        ),
                                      );
                                    },

                                    heroTag: "btLocalizacao",
                                    label: Text(""),
                                    backgroundColor: Colors.indigo,
                                    icon: const Icon(Icons.add_location),


                                  ),
                                  selectedPlace == null
                                      ? Container()
                                      : Text(selectedPlace.adrAddress ?? ""),
                                ],
                              ),


                              SizedBox(width: 20.0),

                              Container(
                                width: 275.0,
                                child:   TextField(
                                  controller: _enderecoController,
                                  decoration: const InputDecoration(
                                    hintText: 'Endereço',
                                    labelText: 'Endereço',
                                  ),),

                              ),

                            ],
                          ),
                        ),

                        ResponsivePadding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: <Widget>[

                              ResponsivePadding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[

                                    ResponsivePadding(
                                      padding: const EdgeInsets.only(top: 60.0),
                                      child: FloatingActionButton.extended(
                                          heroTag: "btSalvar",
                                          label: Text("Salvar"),
                                          backgroundColor: Colors.green,
                                          icon: const Icon(Icons.assignment),
                                          onPressed: () {
                                            edicao == false ? adicionar(_cnpjController.text,_emailController.text,_nomeController.text,_enderecoController.text) :
                                            atualizar(id,_cnpjController.text,_emailController.text,_nomeController.text,_enderecoController.text,geoPoint);
                                          }),
                                    ),

                                    SizedBox(width: 20.0),

                                    ResponsivePadding(
                                      padding: const EdgeInsets.only(top: 60.0),
                                      child: FloatingActionButton.extended(
                                          heroTag: "btCancelar",
                                          label: Text("Cancelar"),
                                          backgroundColor: Colors.red,
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context,rootNavigator: true).pop();
                                          }),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],

                    )),
              ],
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Adicionar - Clínicas"),
          backgroundColor: Colors.blue),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "btAddClinica",
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),

        onPressed: () {
          edicao = false;
            _cnpjController = new TextEditingController();
            _emailController = new TextEditingController();
            localizacao = null;
            _nomeController = new TextEditingController();
            _urlAvatarController = null;
            _enderecoController = new TextEditingController();
             GeoPoint geoPoint = null;

            modal(edicao,null,_cnpjController.text,_emailController.text,localizacao,_nomeController.text,_enderecoController.text,geoPoint);

        },
      ),


      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('clinicas').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) {

                      return ListTile(
                        title: FadeIn(1, Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: const Color(0xFFFFFFFF),
                          elevation: 4.0,
                          child: ListTile(

                            leading:  Container(
                              decoration: new BoxDecoration(

                              ),
                              child: CircleAvatar(
                                backgroundImage: doc.data['imagemUrl'] == null
                                    ? AssetImage('images/ic_blank_image.png')
                                    : CachedNetworkImageProvider(doc.data['imagemUrl']),
                                radius: 20.0,
                              ),
                            ),


                            title: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(doc.data['nome'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),

                            subtitle: Text(doc.data['cnpj'],
                                style: TextStyle(
                                  color: Colors.grey,
                                )),

                            onTap: ((){
                              edicao = true;

                              _cnpjController.text = doc.data['cnpj'];
                              _emailController.text = doc.data['email'];
                              _nomeController.text = doc.data['nome'];
                              _enderecoController.text = doc.data['endereco'];
                             GeoPoint geoPoint = doc.data['position']['geopoint'];

                              modal(edicao, doc.documentID,_cnpjController.text,_emailController.text,null,_nomeController.text,_enderecoController.text,geoPoint);

                            }),

                            onLongPress: (() async{
                              await db.collection('clinicas').document(doc.documentID).delete();
                            }),
                          ),
                        ),
                      ));
                    }).toList(),
                  );
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
    );
  }
}