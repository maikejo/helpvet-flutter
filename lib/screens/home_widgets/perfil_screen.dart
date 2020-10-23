import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_container.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'package:flutter_finey/screens/historico_pagamentos.dart';
import 'package:flutter_finey/screens/planos_screen.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/styles/common_styles.dart';
import 'package:flutter_finey/util/custom_alert_dialog.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PerfilScreen extends StatefulWidget {
  PerfilScreen({this.idCliente});

  final String idCliente;

  @override
  _PerfilScreenState createState() => new _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> with SingleTickerProviderStateMixin {
  final db = Firestore.instance;

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _ativoController = TextEditingController();
  TextEditingController _tipoContaController = TextEditingController();
  TextEditingController _dataCriacaoController = TextEditingController();
  TextEditingController _diasController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();

  final MaskedTextController _cardNumberController = MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController = MaskedTextController(mask: '00/0000');
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _cvvCodeController = MaskedTextController(mask: '0000');

  var maskTelefoneFormatter = new MaskTextInputFormatter(mask: '(##) ###-###-###', filter: { "#": RegExp(r'[0-9]') });
  var maskCpfFormatter = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });

  TabController _tabController;
  final List<Tab> tabs = <Tab>[
    new Tab(icon: Icon(Icons.account_circle),text: 'Dados'),
    new Tab(icon: Icon(Icons.assignment),text: 'Plano'),
  ];

  String _selectedClinica = null;
  File _fileController;
  String _urlAvatarController;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final dateFormat = DateFormat("dd/MM/yyyy");
  bool edicao = false;

  @override
  initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
    getDadosUser();
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

  Future<User> getDadosUser() async{
   User user = await Auth.getDadosUser(widget.idCliente);

   _nomeController.text = user.nome;
   _emailController.text = user.email;

   if(user.ativado == true){
     _ativoController.text = "ATIVO";
   }

   _tipoContaController.text = user.tipo;
   _diasController.text = user.diasPlano.toString();
   _urlAvatarController = user.imagemUrl;
   _cpfController.text = user.cpf;
   _telefoneController.text = user.telefone;

  }

  void _atualizaAvatar() async{
    String fileName = "avatar";
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(Auth.user.email + "/avatar/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
    _urlAvatarController = await (await uploadTask.onComplete).ref.getDownloadURL();
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  }

  void atualizar(String id,String nome,String cpf,String telefone){
    Firestore.instance.collection('usuarios').document(id).updateData({"nome" : nome, "imagemUrl": _urlAvatarController, "cpf": cpf, "telefone": telefone});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Perfil"),
          backgroundColor: Colors.blue,
          bottom: new TabBar(
            controller: _tabController,
            tabs: tabs,
          ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[

        Container(
          child:StreamBuilder(
                  stream: Auth.getUser(widget.idCliente),
                  builder: (BuildContext context,
                      AsyncSnapshot<User> snapshot) {

                    if (snapshot.data != null) {

                      return Container(
                          child: SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            left: 40.0, right: 40.0, bottom: 15.0),
                                        child: TextFormField(
                                            controller: _nomeController,
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.account_box, color: Colors.pinkAccent),
                                                fillColor: Colors.red,
                                                labelText: 'Nome & Sobrenome',
                                                labelStyle:
                                                CommonStyles(context: context).getLabelText()
                                            )
                                        )),

                                    ResponsivePadding(
                                        padding: const EdgeInsets.only(
                                            left: 40.0, right: 40.0, bottom: 15.0),
                                        child: TextFormField(
                                            enabled: false,
                                            keyboardType: TextInputType.number,
                                            controller: _cpfController,
                                            inputFormatters: [maskCpfFormatter],
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.description, color: Colors.pinkAccent),
                                                fillColor: Colors.red,
                                                labelText: 'CPF',
                                                labelStyle:
                                                CommonStyles(context: context).getLabelText()
                                            )
                                        )),

                                    ResponsivePadding(
                                        padding: const EdgeInsets.only(
                                            left: 40.0, right: 40.0, bottom: 15.0),
                                        child: TextFormField(
                                            enabled: false,
                                            controller: _emailController,
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.email, color: Colors.pinkAccent),
                                                fillColor: Colors.red,
                                                labelText: 'E-mail',
                                                labelStyle:
                                                CommonStyles(context: context).getLabelText()))),

                                    ResponsivePadding(
                                        padding: const EdgeInsets.only(
                                            left: 40.0, right: 40.0, bottom: 15.0),
                                        child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: _telefoneController,
                                            inputFormatters: [maskTelefoneFormatter],
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.phone, color: Colors.pinkAccent),
                                                fillColor: Colors.red,
                                                labelText: 'Telefone',
                                                labelStyle:
                                                CommonStyles(context: context).getLabelText()))),

                                    ResponsivePadding(
                                        padding: const EdgeInsets.only(
                                            left: 40.0, right: 40.0, bottom: 15.0),
                                        child: TextFormField(enabled: false,
                                            controller: _ativoController,
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.assignment_ind, color: Colors.pinkAccent),
                                                fillColor: Colors.red,
                                                labelText: 'Ativo',
                                                labelStyle:
                                                CommonStyles(context: context).getLabelText()))),

                                    ResponsivePadding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                    ),

                                    ResponsivePadding(
                                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                        child: ResponsiveContainer(
                                            width: 200.0,
                                            height: 50.0,

                                            child: new FloatingActionButton.extended(
                                                heroTag: "btSalvarPerfil",
                                                label: Text("Salvar Perfil"),
                                                backgroundColor: Colors.blueAccent,
                                                icon: const Icon(Icons.assignment_ind),
                                                onPressed: () {
                                                  atualizar(widget.idCliente, _nomeController.text,_cpfController.text,_telefoneController.text);
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

        Container(
          padding: const EdgeInsets.only(top: 30.0),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      Container(
                        width: 350.0,
                        child: Card(
                          elevation: 10,
                          child: Column(
                            children: <Widget>[

                              Container(
                                color: Colors.indigo,
                                width: 350.0,
                                height: 50.0,
                                child: ResponsivePadding(
                                  padding: const EdgeInsets.only(left: 60.0, top: 15.0),
                                  child: Text('Dados do Cartão de Crédito' ,
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16)),
                                ),
                              ),

                              ResponsivePadding(
                                  padding: const EdgeInsets.only(
                                      left: 40.0, right: 40.0, bottom: 24.0),
                                  child: TextFormField(
                                      controller: _cardNumberController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.credit_card, color: Colors.pinkAccent),
                                          fillColor: Colors.red,
                                          labelText: 'Número do cartão',
                                          hintText: 'xxxx xxxx xxxx xxxx'))),

                              ResponsivePadding(
                                  padding: const EdgeInsets.only(
                                      left: 40.0, right: 40.0, bottom: 24.0),
                                  child: TextFormField(
                                      controller: _expiryDateController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.event, color: Colors.pinkAccent),
                                          fillColor: Colors.red,
                                          labelText: 'Data Expiração',
                                          hintText: 'MM/YYYY'))),

                              ResponsivePadding(
                                  padding: const EdgeInsets.only(
                                      left: 40.0, right: 40.0, bottom: 24.0),
                                  child: TextFormField(
                                      controller: _cvvCodeController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.assignment, color: Colors.pinkAccent),
                                          fillColor: Colors.red,
                                          labelText: 'CVV',
                                          hintText: 'XXXX'))
                              ),

                            ],
                          ),
                        ),
                      ),


                        ResponsivePadding(
                          padding: const EdgeInsets.only(
                              left: 40.0, right: 40.0, top: 30.0),
                          child: TextFormField(
                              enabled: false,
                              controller: _diasController,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.event, color: Colors.pinkAccent),
                                  fillColor: Colors.red,
                                  labelText: 'Dias do plano',
                                  labelStyle:
                                  CommonStyles(context: context).getLabelText()))),

                      ResponsivePadding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: <Widget>[


                            ResponsivePadding(
                              padding: const EdgeInsets.only(top: 60.0),
                              child: FloatingActionButton.extended(
                                  heroTag: "btAlterarPlano",
                                  label: Text("Alterar plano"),
                                  backgroundColor: Colors.amber,
                                  icon: const Icon(Icons.assignment),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlanosScreen(),
                                      ),
                                    );
                                  }),
                            ),

                            SizedBox(width: 10.0),

                            ResponsivePadding(
                              padding: const EdgeInsets.only(top: 60.0),
                              child: FloatingActionButton.extended(
                                  heroTag: "btPagamento",
                                  label: Text("Pagamentos"),
                                  backgroundColor: Colors.deepPurple,
                                  icon: const Icon(Icons.shopping_cart),
                                  onPressed: () {
                                      Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                      builder: (context) => HistoricoPagamentosScreen(idCliente: widget.idCliente)));

                                  }),
                            ),


                          ],
                        ),
                      ),

                    ])
            )
          ),

        ],

      ),

    );
  }
}