import 'dart:io';
import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/external_widgets/exhibition_bottom/vacina_exhibition_bottom_sheet.dart';
import 'package:flutter_finey/external_widgets/exhibition_bottom/vacina_sliding_cards.dart';
import 'package:flutter_finey/external_widgets/exhibition_bottom/tabs.dart';
import 'package:flutter_finey/helper/Consts.dart';
import 'package:flutter_finey/model/cadastro_vacina.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/service/cadastro_vacina_service.dart';
import 'package:flutter_finey/styles/common_styles.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'chat_widgets/full_screen_image.dart';
import 'common_widgets/responsive_container.dart';
import 'common_widgets/responsive_padding.dart';

class VacinaScreen extends StatefulWidget {
  VacinaScreen({@required this.idPet , this.idAcessoVetDono});

  final String idPet;
  final String idAcessoVetDono;

  @override
  _VacinaScreenState createState() => _VacinaScreenState();
}

class _VacinaScreenState extends State<VacinaScreen> {
  final Firestore datbase = Firestore.instance;
  Stream slides;
  File _fileController;
  String _urlFotoVacinaController;
  DateTime dataAtual = new DateTime.now();
  CadastroVacinaService cadastroVacinaService;
  final db = Firestore.instance;

  TextEditingController _vacina = new TextEditingController();
  TextEditingController _dataAplicacaoController = new TextEditingController(text: "");
  TextEditingController _dataReaplicacaoController = new TextEditingController(text: "");
  DateTime dataAplicacao = null;
  DateTime dataReaplicacao = null;
  String _selectedDataAplicacao = "Data Aplicação";
  String _selectedDataReaplicacao = "Data Reaplicação";
  bool edicao = false;


  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  void _queryDatabase() {
    Query query = datbase.collection('vacinas').document(Auth.user.email).collection("lista");
    slides = query.snapshots().map((list) => list.documents.map((doc) => doc.data));
    db.collection('vacinas').document(Auth.user.email).collection("lista").snapshots();
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 80, maxHeight:  700 , maxWidth: 700);
    setState(() {
      _fileController = image;
    });

    try{
      if(_fileController != null) {
        Dialogs.showLoadingDialog(context, _keyLoader);
        uploadDocVacina(context);
      }
    }catch(e){
      print('erro');
    }

  }

  Future uploadDocVacina(BuildContext context) async {
      String fileName = "vacina_"+ new DateFormat("dd-MM-yyyy").format(dataAtual);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(Auth.user.email + "/documentos/vacinas/" + fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
      _urlFotoVacinaController = await (await uploadTask.onComplete).ref.getDownloadURL();

      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  }

  Future<void> _selectDataAplicacao(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2100),
    );
    if (d != null)
      setState(() {
        _dataAplicacaoController.text = new DateFormat("d/MM/y").format(d);
        dataAplicacao = d;
      });
  }

  Future<void> _selectDataReaplicacao(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2100),
    );
    if (d != null)
      setState(() {
        _dataReaplicacaoController.text = new DateFormat("d/MM/y").format(d);
        dataReaplicacao = d;
      });
  }

  void adicionar(String vacina,DateTime dataAplicacao,DateTime dataReaplicacao){
    Firestore.instance.collection('vacinas').document(Auth.user.email).collection("lista").document(widget.idPet).collection("lista")
        .add({"vacina" : vacina, "data": Timestamp.now(), "dataAplicacao": Timestamp.now(),"dataReaplicacao": Timestamp.now(),"imagemUrl" : _urlFotoVacinaController});
    Navigator.pop(context);
  }

  void atualizar(String id,String vacina,DateTime dataAplicacao,DateTime dataReaplicacao){
    Firestore.instance.collection('vacinas').document(Auth.user.email).collection("lista").document(widget.idPet).collection("lista").document(id)
        .updateData({"vacina" : vacina, "data": Timestamp.now(), "dataAplicacao": Timestamp.now(),"dataReaplicacao": Timestamp.now(),"imagemUrl" : _urlFotoVacinaController});
    Navigator.pop(context);
  }

  Widget mostarVetAcessoVacina(){
    return Scaffold(
      appBar: AppBar(
          title: Text("Lista de Vacinas"),
          backgroundColor: Colors.pinkAccent),

      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),

          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("vacinas").document(widget.idAcessoVetDono).collection("lista").document(widget.idPet).collection("lista").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) {

                      return ListTile(
                        title: FadeIn(1,Card(
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
                                Text("Cartão de Vacina",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),

                            subtitle:

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text('Vacina: ' + doc.data['vacina'],
                                    style: TextStyle(
                                      color: Colors.blue,
                                    )),

                                Text('Aplicação: ' + DateFormat("dd/MM/yy hh:mm").format(DateTime.now()),
                                    style: TextStyle(
                                      color: Colors.blue,
                                    )),

                                Text('Reaplicação: ' + DateFormat("dd/MM/yy hh:mm").format(DateTime.now()),
                                    style: TextStyle(
                                      color: Colors.grey,
                                    )),
                              ],
                            ),

                            onTap: (() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => FullScreenImage(photoUrl: doc.data['imagemUrl'],)));
                            }),
                          ),
                        ),
                        ));
                    }).toList(),
                  );
                } else {
                  return SizedBox();
                }
              })
        ],
      ),
    );
  }

  Widget modal(bool edicao,String id,String vacina,String dataAplicacao,String dataReaplicacao){

    showDialog(
        context: context,
        builder: (BuildContext context) => Container(
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
                    onTap: () => getImageFromCamera(),
                    child: new Center(
                      child: _urlFotoVacinaController == null
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
                                _urlFotoVacinaController),
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
                            controller: _vacina,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.add_comment),
                              hintText: 'Vacina',
                              labelText: 'Nome da vacina',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),

                        ResponsivePadding(padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[

                              IconButton(
                                icon: Icon(Icons.calendar_today),
                                color: Colors.pink,
                                tooltip: 'Data Aplicação',
                                onPressed: () {
                                  _selectDataAplicacao(context);
                                },
                              ),

                              Flexible(
                                child: new TextField(
                                    controller: _dataAplicacaoController,
                                    decoration: InputDecoration(
                                        fillColor: Colors.pinkAccent,
                                        labelText: 'Data aplicação',
                                        labelStyle: CommonStyles(context: context).getLabelText())
                                ),
                              ),

                            ],
                          ),
                        ),

                        ResponsivePadding(padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[

                              IconButton(
                                icon: Icon(Icons.calendar_today),
                                color: Colors.pink,
                                tooltip: 'Data reaplicação',
                                onPressed: () {
                                  _selectDataReaplicacao(context);
                                },
                              ),

                              Flexible(
                                child: new TextField(
                                    controller: _dataReaplicacaoController,
                                    decoration: InputDecoration(
                                        fillColor: Colors.pinkAccent,
                                        labelText: 'Data reaplicação',
                                        labelStyle: CommonStyles(context: context).getLabelText())
                                ),
                              ),

                            ],
                          ),
                        ),

                        ResponsivePadding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: <Widget>[

                              ResponsivePadding(
                                  padding: const EdgeInsets.only(top:10,left: 20.0),
                                  child: ResponsiveContainer(
                                    width: 130.0,
                                    height: 40.0,

                                    child: new FloatingActionButton.extended(
                                        heroTag: "btSalvarVacina",
                                        label: Text("Salvar"),
                                        backgroundColor: Colors.blueAccent,
                                        icon: const Icon(Icons.assignment_ind),
                                        onPressed: (){
                                          adicionar(_vacina.text,this.dataAplicacao,this.dataReaplicacao);
                                        }),
                                  )
                              ),

                              ResponsivePadding(
                                  padding: const EdgeInsets.only(top:10.0, left: 20.0),
                                  child: ResponsiveContainer(
                                    width: 130.0,
                                    height: 40.0,

                                    child: new FloatingActionButton.extended(
                                        heroTag: "btCancelarVacina",
                                        label: Text("Cancelar"),
                                        backgroundColor: Colors.red,
                                        icon: const Icon(Icons.cancel),
                                        onPressed: (){
                                          Navigator.of(context,rootNavigator: true).pop();
                                        }),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),

        )
    );

  /*  showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        context: context,
        builder: (context) {

          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState */

  /*) {
                return Container(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      ResponsivePadding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text('Adicionar Vácina' ,
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.pink,
                                fontSize: 24
                            )),
                      ),

                      ResponsivePadding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: GestureDetector(
                          onTap: () => getImageFromCamera(),
                          child: new Center(
                            child: _urlFotoVacinaController == null
                                ? new Stack(
                              children: <Widget>[
                                Container(
                                  height: 70.0,
                                  width: 70.0,
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
                                      _urlFotoVacinaController),
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

                      Container(
                        padding: EdgeInsets.only(bottom: 1.0),
                        width: 360.0,
                        child:  Column(
                          children: <Widget>[

                            ResponsivePadding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _vacina,
                                decoration: const InputDecoration(
                                  icon: const Icon(Icons.add_comment),
                                  hintText: 'Vacina',
                                  labelText: 'Nome da vacina',
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),

                            ResponsivePadding(padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[

                                  IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    color: Colors.pink,
                                    tooltip: 'Data Aplicação',
                                    onPressed: () {
                                      _selectDataAplicacao(context);
                                    },
                                  ),

                                  Flexible(
                                    child: new TextField(
                                        controller: _dataAplicacaoController,
                                        decoration: InputDecoration(
                                            fillColor: Colors.pinkAccent,
                                            labelText: 'Data aplicação',
                                            labelStyle: CommonStyles(context: context).getLabelText())
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            ResponsivePadding(padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[

                                  IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    color: Colors.pink,
                                    tooltip: 'Data reaplicação',
                                    onPressed: () {
                                      _selectDataReaplicacao(context);
                                    },
                                  ),

                                  Flexible(
                                    child: new TextField(
                                        controller: _dataReaplicacaoController,
                                        decoration: InputDecoration(
                                            fillColor: Colors.pinkAccent,
                                            labelText: 'Data reaplicação',
                                            labelStyle: CommonStyles(context: context).getLabelText())
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            ResponsivePadding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: <Widget>[

                                  ResponsivePadding(
                                      padding: const EdgeInsets.only(top:10,left: 20.0),
                                      child: ResponsiveContainer(
                                        width: 130.0,
                                        height: 40.0,

                                        child: new FloatingActionButton.extended(
                                            heroTag: "btSalvarVacina",
                                            label: Text("Salvar"),
                                            backgroundColor: Colors.blueAccent,
                                            icon: const Icon(Icons.assignment_ind),
                                            onPressed: (){
                                              adicionar(_vacina.text,this.dataAplicacao,this.dataReaplicacao);
                                            }),
                                      )
                                  ),

                                  ResponsivePadding(
                                      padding: const EdgeInsets.only(top:10.0, left: 20.0),
                                      child: ResponsiveContainer(
                                        width: 130.0,
                                        height: 40.0,

                                        child: new FloatingActionButton.extended(
                                            heroTag: "btCancelarVacina",
                                            label: Text("Cancelar"),
                                            backgroundColor: Colors.red,
                                            icon: const Icon(Icons.cancel),
                                            onPressed: (){
                                              Navigator.of(context,rootNavigator: true).pop();
                                            }),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                );
              });
        }
    );*/

  }

  @override
  Widget build(BuildContext context) {

    if(widget.idAcessoVetDono != null){
     return mostarVetAcessoVacina();
    }else{
      return Scaffold(
        appBar: AppBar(
            title: Text("Lista de Vacinas"),
            backgroundColor: Colors.pinkAccent),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            heroTag: "btFotoVacina",
            backgroundColor: Colors.pinkAccent,
            child: const Icon(Icons.party_mode),

          onPressed: () {
            _vacina = new TextEditingController();
            _fileController = null;
            _dataAplicacaoController = new TextEditingController();
            _dataReaplicacaoController = new TextEditingController();
            _urlFotoVacinaController = null;

            modal(edicao,null,_vacina.text,_selectedDataAplicacao,_selectedDataReaplicacao);
          },
        ),

        body: Stack(
          children: <Widget>[
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Tabs(),
                  SizedBox(height: 50),
                  VacinaSlidingCardsView(idPet: widget.idPet),
                ],
              ),
            ),
            //VacinaExhibitionBottomSheet(),
          ],
        ),
      );

        /*ListView(
          padding: EdgeInsets.all(12.0),
          children: <Widget>[
            SizedBox(height: 20.0),

            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("vacinas").document(Auth.user.email).collection("lista").document(widget.idPet).collection("lista").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.documents.map((doc) {

                        return ListTile(
                          title: FadeIn(1,Card(
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
                                  Text("Cartão de Vacina",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),

                              subtitle:

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      Text('Vacina: ' + doc.data['vacina'],
                                          style: TextStyle(
                                            color: Colors.blue,
                                          )),

                                      Text('Aplicação: ' + DateFormat("dd/MM/yy hh:mm").format(DateTime.now()),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          )),

                                      Text('Reaplicação: ' + DateFormat("dd/MM/yy hh:mm").format(DateTime.now()),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          )),
                                    ],
                                  ),


                              onTap: (() {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => FullScreenImage(photoUrl: doc.data['imagemUrl'],)));
                              }),

                              onLongPress: (() async{
                                await db
                                    .collection('vacinas').document(Auth.user.email).collection('lista').document(widget.idPet).collection("lista")
                                    .document(doc.documentID)
                                    .delete();
                              }),
                            ),
                          )),
                        );
                      }).toList(),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
          ],
        ),*/

    }
  }

}
