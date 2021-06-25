import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/model/cadastroPetVision.dart';
import 'package:flutter_finey/model/cadastro_pet.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/service/cadastro_pet.dart';
import 'package:flutter_finey/styles/common_styles.dart';
import 'package:flutter_finey/util/custom_alert_dialog.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './common_widgets/responsive_padding.dart';
import '../styles/common_variables.dart';
import 'cadastro_pet_widgets/cadastro_pet_button.dart';
import 'home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

enum Sexo { MACHO, FEMEA }

class CadastroPetScreen extends StatefulWidget {
  CadastroPetScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CadastroPetScreenState createState() => new _CadastroPetScreenState();
}

class _CadastroPetScreenState extends State<CadastroPetScreen> with SingleTickerProviderStateMixin {
  final _nomeController = TextEditingController();
  final _especieController = TextEditingController();
  final _racaController = TextEditingController();
  TextEditingController _dataNascimentoController = new TextEditingController(text: "");
  final _tipoAlergiaController = TextEditingController();
  File _fileController;
  String _urlAvatarController;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final dateFormat = DateFormat("dd/MM/yyyy");

  String _selectedDoenca;
  String _selectedTipoPet;
  String _selectedAlergia;
  Sexo _sexo = Sexo.MACHO;
  DateTime dataNascimento = null;

  final List<Tab> tabs = <Tab>[
    new Tab(icon: Icon(Icons.pets),text: 'Dados'),
    new Tab(icon: Icon(Icons.assignment),text: 'Saúde'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
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
  }

  void checkCadastroPetFeitoSeen() async {
    final prefs = await SharedPreferences.getInstance();
    int launchCount = prefs.getInt('counter') ?? 0;
    prefs.setInt('counter', launchCount + 1);

    if (launchCount == 0) {
      print("Primeira Vez");
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new CadastroPetScreen()));
    } else {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeScreen()));
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Sucesso"),
          content: new Text("Cadastro realizado com sucesso!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Application.router.navigateTo(
                    context, RouteConstants.ROUTE_HOME,
                    clearStack: true,
                    replace: true,
                    transition: TransitionType.fadeIn);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogFotoPet() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Erro"),
          content: new Text("Informe uma foto de seu Pet!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context,rootNavigator: true).pop();
                ;
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorAlert({String title, String content, VoidCallback onPressed}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          content: content,
          title: title,
          onPressed: onPressed,
        );
      },
    );
  }

  Future<void> _selectDataNascimento(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2100),
    );
    if (d != null)
      setState(() {
        _dataNascimentoController.text = new DateFormat("d/MM/y").format(d);
        dataNascimento = d;
      });
  }

  void _cadastrar() async {

    try {

      if(_fileController != null){

        Dialogs.showLoadingDialog(context, _keyLoader);

        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(Auth.user.email + "/avatar_pet/" + path.basename(_fileController.path));
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
        _urlAvatarController =
        await (await uploadTask.onComplete).ref.getDownloadURL();


        Firestore.instance.collection('cadastro_pet').document(Auth.user.email).collection("lista")
            .add({"nome" : _nomeController.text, "dataNascimento": dataNascimento, "especie": _especieController.text,
                  "raca": _racaController.text,"tipoPet": _selectedTipoPet,
                  "urlAvatar": _urlAvatarController,"idDoenca": _selectedDoenca, "idAlergia": _selectedAlergia,
                  "idTipoPet":_selectedTipoPet,"tipoAlergia": _tipoAlergiaController.text});

        Navigator.of(context,rootNavigator: true).pop();

      /*  Center(
          child: Container(
              height: 300,
              width: 300,
              child: FlareActor(
                "assets/Android.flr",
                animation: "head-spin",
              )
          ),
        );*/

        _showDialog();

      }else{
        _showDialogFotoPet();
      }

    } catch (e) {
      print("Error in sign up: $e");
      String exception = Auth.getExceptionText(e);
      _showErrorAlert(
          title: "Já existe um cadastro com esse email.", content: exception);
    }
  }

  Widget _buildWithConstraints(BuildContext context, BoxConstraints constraints) {
    double deviceHeight = MediaQuery.of(context).size.height;

    var column = new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
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
                          ResponsivePadding(
                            padding: const EdgeInsets.only(top: 10.0),
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
                                    : ClipOval(
                                        child: Container(
                                            height: 100,
                                            width: 100,
                                            child: _fileController == null
                                                ? Icon(
                                              Icons.camera,
                                              color: Colors.white,
                                              size: 50,
                                            )
                                                : Image.file(
                                                    _fileController,
                                                    fit: BoxFit.fill,
                                      )),
                                ),
                              ),
                            ),
                          ),

                          ResponsivePadding(
                              padding: const EdgeInsets.only(
                                  left: 40.0, right: 40.0, bottom: 10.0),
                              child: TextFormField(
                                  controller: _nomeController,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.pets, color: Colors.pinkAccent),
                                      fillColor: Colors.pinkAccent,
                                      labelText: 'Nome do Pet',
                                      labelStyle: CommonStyles(context: context).getLabelText()))),


                          Container(
                            width: 300.0,
                            child:  ResponsivePadding(padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0),
                              child: Row(
                                children: <Widget>[

                                  IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    color: Colors.pink,
                                    tooltip: 'Data agendamento',
                                    onPressed: () {
                                      _selectDataNascimento(context);
                                    },
                                  ),

                                  Flexible(
                                    child: new TextField(
                                        enabled: false,
                                        controller: _dataNascimentoController,
                                        decoration: InputDecoration(
                                            fillColor: Colors.pinkAccent,
                                            labelText: 'Data agendamento',
                                            labelStyle: CommonStyles(context: context).getLabelText())
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),

                          ResponsivePadding(padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0),
                            child: StreamBuilder(
                              stream: Firestore.instance.collection('tipoPet').orderBy('pet').snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.data != null){
                                  return Container(padding: EdgeInsets.only(top: 20.0,left: 38.0),
                                    child:DropdownButton<String>(
                                        value: _selectedTipoPet,
                                        isDense: true,
                                        hint: Text('Selecionar Tipo Pet'),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedTipoPet = newValue;
                                          });
                                        },
                                        items: snapshot.data.documents.map((DocumentSnapshot document) {
                                          return new DropdownMenuItem<String>(
                                              value: document.data['pet'].toString(),
                                              child: new Container(
                                                child: new Text(
                                                  document.data['pet'].toString(),
                                                ),
                                              ));
                                        }).toList()

                                    ),
                                  );
                                }else{
                                 return CircularProgressIndicator();
                                }
                              }),
                          ),

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
                                  left: 40.0, right: 40.0, bottom: 20.0),
                              child: TextFormField(
                                  controller: _racaController,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.adjust, color: Colors.pinkAccent),
                                      fillColor: Colors.red,
                                      labelText: 'Raça',
                                      labelStyle:
                                      CommonStyles(context: context).getLabelText()))),

                          ResponsivePadding(
                            padding: const EdgeInsets.only(right: 100.0),
                            child : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: <Widget>[

                                FlatButton.icon(
                                  label: const Text('Macho'),
                                  icon: Radio(
                                    value: Sexo.MACHO,
                                    groupValue: _sexo,
                                    onChanged: (Sexo value) {
                                      setState(() {
                                        _sexo = value;
                                      });
                                      },
                                  ),
                                ),

                                FlatButton.icon(
                                  label: const Text('Fêmea'),
                                  icon: Radio(
                                    value: Sexo.FEMEA,
                                    groupValue: _sexo,
                                    onChanged: (Sexo value) {
                                      setState(() {
                                        _sexo = value;
                                      });
                                      },
                                  ),
                                ),

                          ],
                          ),
                          ),

                          ResponsivePadding(
                              padding: const EdgeInsets.only(
                                  right: 40.0, left: 28.0, top: 20.0),
                              child: CadastroPetButton(_cadastrar)),
                        ]),
                  ]))
        ]);

    var constrainedBox = new ConstrainedBox(
        constraints:
            constraints.copyWith(maxHeight: MediaQuery.of(context).size.height),
        child: new Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                bottom:
                    CommonVariables(context: context).getScreenPaddingBottom()),
            child: column));

    var scrollView = new SingleChildScrollView(child: constrainedBox);

    return scrollView;
  }

  Widget _buildWithConstraintsSaude(BuildContext context, BoxConstraints constraints) {
    double deviceHeight = MediaQuery.of(context).size.height;

    var column = new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
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
                                stream: Firestore.instance.collection('doencas').orderBy('nome').snapshots(),
                                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.data != null){
                                    return new ListTile(
                                      leading: const Icon(
                                        Icons.add_to_queue,
                                        color: Colors.pink,
                                      ),
                                      title: DropdownButton<String>(
                                        isExpanded: true,
                                        value: _selectedDoenca,
                                        isDense: true,
                                        hint: Text('Qual doença já teve?'),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedDoenca = newValue;
                                          });
                                        },
                                        items: snapshot.data != null ? snapshot.data.documents.map((DocumentSnapshot document) {
                                          return new DropdownMenuItem<String>(
                                              value: document.data['nome'].toString(),
                                              child: new Container(
                                                height: 50.0,
                                                //color: primaryColor,
                                                child: new Text(
                                                  document.data['nome'].toString(),
                                                ),
                                              ));
                                        }).toList()
                                            : DropdownMenuItem(
                                          value: 'null',
                                          child: new Container(
                                            height: 50.0,
                                            child: new Text('null'),
                                          ),
                                        ),
                                      ),
                                    );
                                  }else{
                                   return CircularProgressIndicator();
                                  }
                                }),
                          ),

                          ResponsivePadding(padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 30.0),
                            child: StreamBuilder(
                                stream: Firestore.instance.collection('alergias').snapshots(),
                                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.data != null) {
                                    return new ListTile(
                                      leading: const Icon(
                                        Icons.assignment,
                                        color: Colors.pink,
                                      ),
                                      title: DropdownButton<String>(
                                        isExpanded: true,
                                        value: _selectedAlergia,
                                        isDense: true,
                                        hint: Text('Tem alguma alergia ?'),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedAlergia = newValue;
                                          });
                                        },
                                        items: snapshot.data != null ? snapshot.data.documents.map((DocumentSnapshot document) {
                                          return new DropdownMenuItem<String>(
                                              value: document.data['nome'].toString(),
                                              child: new Container(
                                                height: 50.0,
                                                //color: primaryColor,
                                                child: new Text(
                                                  document.data['nome'].toString(),
                                                ),
                                              ));
                                        }).toList()
                                            : DropdownMenuItem(
                                          value: 'null',
                                          child: new Container(
                                            height: 50.0,
                                            child: new Text('null'),
                                          ),
                                        ),
                                      ),
                                    );
                                  }else{
                                   return CircularProgressIndicator();
                                  }


                                }),
                          ),

                          Visibility(
                            child: Container(
                                width: 350.0,
                                padding: const EdgeInsets.only(
                                    left: 60.0,bottom: 30.0),
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
        ]);

    var constrainedBox = new ConstrainedBox(
        constraints:
        constraints.copyWith(maxHeight: MediaQuery.of(context).size.height),
        child: new Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                bottom:
                CommonVariables(context: context).getScreenPaddingBottom()),
            child: column));

    var scrollView = new SingleChildScrollView(child: constrainedBox);

    return scrollView;
  }

  @override
  Widget build(BuildContext context) {
    var layoutBuilder = new LayoutBuilder(builder: _buildWithConstraints);
    var layoutBuilderSaude = new LayoutBuilder(builder: _buildWithConstraintsSaude);

    var scaffold = new Scaffold(
      appBar: AppBar(
        title: Text("Cadastro Pet"),
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
          color: Colors.deepOrangeAccent,
          child: new Center(
          child: layoutBuilder
          ),
        ),

        new Container(
          color: Colors.white,
          child: new Center(
          child: layoutBuilderSaude
          ),
        ),

    ],

    ),
    );

    return scaffold;
  }
}
