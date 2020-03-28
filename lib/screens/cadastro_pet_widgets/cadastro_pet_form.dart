import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../common_widgets/responsive_padding.dart';
import '../../styles/common_styles.dart';

class CadastroPetForm extends StatelessWidget {
  CadastroPetForm(this._nomeController, this._generoController,
      this._racaController, this._dataNascimentoController, this._urlAvatarController);

  final TextEditingController _nomeController;
  final TextEditingController _generoController;
  final TextEditingController _racaController;
  DateTime _dataNascimentoController;
  File _urlAvatarController;
  int _radioValue1 = -1;

  List<String> tipoPet = ["Cachorro","Gato"].toList();
  String _selectedTipoPet;

  final dateFormat = DateFormat("dd/MM/yyyy");

  Future getImageFromGallery() async {
    _urlAvatarController =
        await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void onTipoPetChange(String item){
      _selectedTipoPet = item;
  }

  void _handleRadioValueChange1(int value) {

      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          break;
        case 1:
          break;
      }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Form(
          // key: key,
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

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

            ResponsivePadding(
              padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, bottom: 10.0),
              child: RaisedButton(
                child: Text('Pick a date'),
                onPressed: () {
                  showDatePicker(
                      context: context,
                      initialDate: _dataNascimentoController == null ? DateTime.now() : _dataNascimentoController,
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2021)
                  ).then((date) {
                      _dataNascimentoController = date;
                  });
                },
              )
            ),

            ResponsivePadding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, bottom: 10.0),
                child: TextFormField(
                    controller: _generoController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.adjust, color: Colors.pinkAccent),
                        labelText: 'Tipo do Pet',
                        labelStyle:
                            CommonStyles(context: context).getLabelText()))),

            ResponsivePadding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, bottom: 10.0),
                child: TextFormField(
                    controller: _racaController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.adjust, color: Colors.pinkAccent),
                        fillColor: Colors.red,
                        labelText: 'Espécie',
                        labelStyle:
                            CommonStyles(context: context).getLabelText()))),

           /* ResponsivePadding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, bottom: 10.0),
                child: TextFormField(
                    controller: _racaController,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.pinkAccent),
                        ),
                        fillColor: Colors.red,
                        labelText: 'Raça',
                        labelStyle:
                        CommonStyles(context: context).getLabelText()))),*/

           /* ResponsivePadding(
              padding: EdgeInsets.all(8.0),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    new Text(
                      'Sexo :',
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(
                          value: 0,
                          groupValue: _radioValue1,
                          onChanged: _handleRadioValueChange1,
                        ),
                        new Text(
                          'Macho',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(
                          value: 1,
                          groupValue: _radioValue1,
                          onChanged: _handleRadioValueChange1,
                        ),
                        new Text(
                          'Fêmea',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
            ],),),*/


            /* Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 46.0),
                        //child: Icon(Icons.date_range, color: Colors.red),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Data Nascimento",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextFormField(

                            decoration: InputDecoration(labelText: "Arrival"),
                          ),
                        ),
                      ),
                    ],
                  ),*/
          ])))
    ]));
  }
}
