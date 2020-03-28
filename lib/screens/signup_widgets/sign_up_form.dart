import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../common_widgets/responsive_padding.dart';
import '../../styles/common_styles.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm(this._nomeController, this._emailController, this._senhaController,
      this._repetirSenhaController,this._cpfController,this._telefoneController);

  final TextEditingController _nomeController;
  final TextEditingController _emailController;
  final TextEditingController _senhaController;
  final TextEditingController _repetirSenhaController;
  final TextEditingController _cpfController;
  final TextEditingController _telefoneController;

  var maskTelefoneFormatter = new MaskTextInputFormatter(mask: '(##) ###-###-###', filter: { "#": RegExp(r'[0-9]') });
  var maskCpfFormatter = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[

      Form(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
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
                            CommonStyles(context: context).getLabelText()))),

            ResponsivePadding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, bottom: 15.0),
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _cpfController,
                    inputFormatters: [maskCpfFormatter],
                    decoration: InputDecoration(
                        icon: Icon(Icons.description, color: Colors.pinkAccent),
                        fillColor: Colors.red,
                        labelText: 'CPF',
                        labelStyle:
                        CommonStyles(context: context).getLabelText()))),

            ResponsivePadding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, bottom: 15.0),
                child: TextFormField(
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
                child: TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock_outline, color: Colors.pinkAccent),
                        labelText: 'Senha',
                        labelStyle:
                            CommonStyles(context: context).getLabelText()))),
         /*   ResponsivePadding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: TextFormField(
                    controller: _repetirSenhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Colors.pinkAccent),
                        labelText: 'Repetir Senha',
                        labelStyle:
                            CommonStyles(context: context).getLabelText())))*/
          ])))
    ]));
  }
}
