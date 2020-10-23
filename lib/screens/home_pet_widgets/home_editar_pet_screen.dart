import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/helper/date_converter.dart';
import 'package:flutter_finey/helper/size_config.dart';
import 'package:flutter_finey/model/cadastro_pet.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_container.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/service/cadastro_pet.dart';
import 'package:flutter_finey/styles/common_styles.dart';
import 'package:flutter_finey/styles/common_variables.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class HomeEditarPetScreen extends StatefulWidget {
  HomeEditarPetScreen({this.idPet});

  final String idPet;

  @override
  _HomeEditarPetScreenState createState() => new _HomeEditarPetScreenState();
}

class _HomeEditarPetScreenState extends State<HomeEditarPetScreen> with SingleTickerProviderStateMixin{

  final db = Firestore.instance;
  var _nomeController = TextEditingController();
  final _especieController = TextEditingController();
  final _racaController = TextEditingController();
  final _data = TextEditingController();
  final _tipoAlergiaController = TextEditingController();

  DateTime _dataNascimentoController = null;
  String _selectedTipoPet = null;
  File _fileController;
  String _urlAvatarController;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final dateFormat = DateFormat("dd/MM/yyyy");
  bool edicao = false;
  String _selectedDoenca = null;
  String _selectedAlergia = null;
  bool dataNascimentoAlterado = false;

  final List<Tab> tabs = <Tab>[
    new Tab(icon: Icon(Icons.pets),text: 'Dados'),
    new Tab(icon: Icon(Icons.assignment),text: 'Saúde'),
  ];

  TabController _tabController;

  @override
  initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
    getDadosPet();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight:  500 , maxWidth: 500);
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

  Future<CadastroPet> getDadosPet() async{
    CadastroPet pet = await CadastroPetService.getCadastroPet(Auth.user.email,widget.idPet);

    _nomeController.value = TextEditingValue(text: pet.nome);
    _especieController.text = pet.especie;
    _racaController.text = pet.raca;
    _urlAvatarController = pet.urlAvatar;
    _selectedTipoPet = pet.tipoPet;
    _urlAvatarController = pet.urlAvatar;
    _selectedDoenca = pet.idDoenca;
    _selectedAlergia = pet.idAlergia;
    _tipoAlergiaController.value = TextEditingValue(text: pet.tipoAlergia);

    if(dataNascimentoAlterado == false){
      _dataNascimentoController = pet.dataNascimento.toDate();
      var d  = DateConverter().converteTimestamp(_dataNascimentoController.millisecondsSinceEpoch);
      _selectedDataNascimento = d.toString();
    }

  }

  void _atualizaAvatar() async{
    String fileName = "avatar";
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(Auth.user.email + "/avatar/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
    _urlAvatarController = await (await uploadTask.onComplete).ref.getDownloadURL();
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  }

  void atualizar(String nome, DateTime dataNascimento,String especie,String raca,String tipoPet,String idDoenca, String idAlergia,String idTipoPet,String tipoAlergia){
    Firestore.instance.collection('cadastro_pet').document(Auth.user.email).collection("lista").document(widget.idPet)
        .updateData({"nome" : nome,"dataNascimento": dataNascimento, "especie": especie, "raca": raca,
                     "tipoPet": tipoPet, "urlAvatar": _urlAvatarController,"idDoenca": _selectedDoenca,
                     "idAlergia": _selectedAlergia, "idTipoPet":_selectedTipoPet, "tipoAlergia":tipoAlergia});

    Navigator.pop(context);
  }

  String _selectedDataNascimento = 'Data de Nascimento';

  Future<void> _selectDataNascimento(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2100),
    );
    if (d != null)
      setState(() {
        _selectedDataNascimento = new DateFormat("d/MM/y").format(d);
        _dataNascimentoController = d;
        dataNascimentoAlterado = true;
      });
  }


  @override
  Widget build(BuildContext context) {

    double deviceHeight = MediaQuery.of(context).size.height;
    final sizeConfig = SizeConfig(mediaQueryData: MediaQuery.of(context));

    return Scaffold(
      appBar: AppBar(
        title: Text("Alterar Pet"),
        backgroundColor: Colors.pinkAccent,
        bottom: new TabBar(
        controller: _tabController,
        tabs: tabs,
      ),
      ),


      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[

          new Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

            child:FutureBuilder(
                future: CadastroPetService.getCadastroPet(Auth.user.email,widget.idPet),
                builder: (BuildContext context, AsyncSnapshot<CadastroPet> snapshot) {

                  if (snapshot.data != null) {

                    return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child:SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[

                                  ResponsivePadding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          getImageFromGallery();
                                        },
                                      child: new Center(
                                        child: _urlAvatarController == null
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
                                          height: 130.0,
                                          width: 130.0,
                                          child: new CircleAvatar(
                                            backgroundImage: _urlAvatarController == null
                                                ? AssetImage('images/ic_blank_image.png')
                                                : CachedNetworkImageProvider(_urlAvatarController),
                                            radius: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  ResponsivePadding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0, bottom: 10.0),
                                      child: TextFormField(
                                          //onSaved: (value) => _nomeController.text = value,
                                          controller: _nomeController,
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.pets, color: Colors.pinkAccent),
                                              fillColor: Colors.pinkAccent,
                                              labelText: 'Nome do Pet',
                                              labelStyle: CommonStyles(context: context).getLabelText()))),

                                  StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                
                                     return ResponsivePadding(padding: const EdgeInsets.only(right: 100.0, bottom: 10.0),
                                        child: StreamBuilder(
                                            stream: Firestore.instance.collection('tipoPet').orderBy('pet').snapshots(),
                                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                              if (snapshot.data != null){
                                                Center(
                                                  child: const CupertinoActivityIndicator(),
                                                );
                                
                                                return Container(padding: EdgeInsets.only(top: 10.0,left: 28.0),
                                                    child: new ListTile(
                                                      leading: const Icon(
                                                        Icons.all_inclusive,
                                                        color: Colors.pink,
                                                      ),
                                                      title: new DropdownButton<String>(
                                                        hint: Text('Selecionar Tipo Pet'),
                                                        isExpanded: true,
                                                        items: snapshot.data.documents.map((DocumentSnapshot document) {
                                
                                                          return new DropdownMenuItem<String>(
                                                            value: document.data['pet'].toString(),
                                                            child: new Text(document.data['pet'].toString()),
                                                          );
                                                        }).toList(),
                                                        value: _selectedTipoPet,
                                                        onChanged: (String value) {
                                                          setState(() {
                                                            _selectedTipoPet = value;
                                                          });
                                                        },
                                
                                                      ),
                                                    ));
                                
                                              }else{
                                                return SizedBox();
                                              }
                                            }),
                                      );
                                
                                    }
                                    ),

                                  ResponsivePadding(padding: const EdgeInsets.only(left: 30.0),
                                    child: Row(
                                      children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        color: Colors.pink,
                                        tooltip: 'Selecionar Data',
                                        onPressed: () {
                                          _selectDataNascimento(context);
                                        },
                                      ),

                                      InkWell(
                                        child: Text(
                                            _selectedDataNascimento,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Color(0xFF000000))
                                        ),
                                        onTap: (){
                                          _selectDataNascimento(context);
                                        },
                                      ),

                                    ],
                                    ),
                                  ),

                                  SizedBox(height: 20.0),

                                  ResponsivePadding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0, bottom: 10.0),
                                      child: TextFormField(
                                          controller: _especieController,
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.adjust, color: Colors.pinkAccent),
                                              fillColor: Colors.red,
                                              labelText: 'Espécie',
                                              labelStyle:
                                              CommonStyles(context: context).getLabelText()))),

                                  ResponsivePadding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0, bottom: 50.0),
                                      child: TextFormField(
                                          controller: _racaController,
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.adjust, color: Colors.pinkAccent),
                                              fillColor: Colors.red,
                                              labelText: 'Raça',
                                              labelStyle:
                                              CommonStyles(context: context).getLabelText()))),

                                  ResponsivePadding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                      child: ResponsiveContainer(
                                          width: 200.0,
                                          height: 50.0,

                                          child: new FloatingActionButton.extended(
                                              heroTag: "btSalvarPet",
                                              label: Text("Salvar"),
                                              backgroundColor: Colors.blueAccent,
                                              icon: const Icon(Icons.pets),
                                              onPressed: () {
                                                atualizar(_nomeController.text, _dataNascimentoController, _especieController.text, _racaController.text, _selectedTipoPet,_selectedDoenca,_selectedAlergia,_selectedTipoPet,_tipoAlergiaController.text);
                                              })
                                      )
                                  ),
                                ])
                        )

                    );
                  } else {
                    return SizedBox();
                  }
                }),
          ),

          new FutureBuilder(
          future: CadastroPetService.getCadastroPet(Auth.user.email,widget.idPet),
          builder: (BuildContext context, AsyncSnapshot<CadastroPet> snapshot) {

            if (snapshot.data != null) {

              return Container(
                color: Colors.white,
                child: new Container(
                        padding: const EdgeInsets.only(top: 30.0),
                        height: deviceHeight -
                            CommonVariables(context: context).getAppBarHeight() -
                            CommonVariables(context: context).getScreenPaddingBottom(),
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    ResponsivePadding(padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 30.0),
                                      child: StreamBuilder(
                                          stream: Firestore.instance.collection('doencas').snapshots(),
                                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                            if (snapshot.data != null) {
                                              Center(
                                                child: const CupertinoActivityIndicator(),
                                              );

                                             return new ListTile(
                                                leading: const Icon(
                                                  Icons.add_to_queue,
                                                  color: Colors.pink,
                                                ),
                                                title: new DropdownButton<String>(
                                                  hint: Text('Qual doença já teve?'),
                                                  isExpanded: true,
                                                  items: snapshot.data.documents.map((DocumentSnapshot document) {

                                                  return new DropdownMenuItem<String>(
                                                      value: document.data['nome'].toString(),
                                                      child: new Text(document.data['nome'].toString()),
                                                    );
                                                  }).toList(),
                                                  value: _selectedDoenca,
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      _selectedDoenca = value;
                                                    });
                                                  },

                                                ),
                                              );

                                            }else{
                                              return SizedBox();
                                            }
                                          }),
                                    ),

                                    ResponsivePadding(padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0),
                                      child: StreamBuilder(
                                          stream: Firestore.instance.collection('alergias').snapshots(),
                                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                            if (snapshot.data != null) {
                                              Center(
                                                child: const CupertinoActivityIndicator(),
                                              );

                                              return new ListTile(
                                                leading: const Icon(
                                                  Icons.assignment,
                                                  color: Colors.pink,
                                                ),
                                                title: new DropdownButton<String>(
                                                  hint: Text('Tem alguma alergia ?'),
                                                  isExpanded: true,
                                                  items: snapshot.data.documents.map((DocumentSnapshot document) {

                                                    return new DropdownMenuItem<String>(
                                                      value: document.data['nome'].toString(),
                                                      child: new Text(document.data['nome'].toString()),
                                                    );
                                                  }).toList(),
                                                  value: _selectedAlergia,
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      _selectedAlergia = value;
                                                    });
                                                  },

                                                ),
                                              );

                                            }else{
                                              return SizedBox();
                                            }
                                          }),
                                    ),


                                    Visibility(
                                      child: Container(
                                        width: 350.0,
                                          padding: const EdgeInsets.only(
                                              left: 60.0, bottom: 10.0),
                                          child: TextFormField(
                                              controller: _tipoAlergiaController,
                                              decoration: InputDecoration(
                                                  icon: Icon(Icons.adjust, color: Colors.pinkAccent),
                                                  fillColor: Colors.red,
                                                  labelText: 'Descreva a alergia',
                                                  labelStyle:
                                                  CommonStyles(context: context).getLabelText()))),
                                      visible: _selectedAlergia == 'Sim',
                                    ),

                                  ]),
                            ]))

              );

            }else {
              return SizedBox();
            }
          }
        ),
        ],

      ),

    );
  }
}