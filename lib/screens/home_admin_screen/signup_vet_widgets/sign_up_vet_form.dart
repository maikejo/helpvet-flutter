import 'package:flutter/material.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'package:flutter_finey/styles/common_styles.dart';

class SignUpVetForm extends StatelessWidget {
  SignUpVetForm(this._nomeController, this._emailController, this._senhaController,
      this._repetirSenhaController);

  final TextEditingController _nomeController;
  final TextEditingController _emailController;
  final TextEditingController _senhaController;
  final TextEditingController _repetirSenhaController;

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
                    left: 40.0, right: 40.0, bottom: 24.0),
                child: TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_box, color: Colors.blue),
                        fillColor: Colors.blue,
                        labelText: 'Nome & Sobrenome',
                        labelStyle:
                            CommonStyles(context: context).getLabelText()))),
            ResponsivePadding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, bottom: 24.0),
                child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email, color: Colors.blue),
                        fillColor: Colors.blue,
                        labelText: 'E-mail',
                        labelStyle:
                            CommonStyles(context: context).getLabelText()))),

            ResponsivePadding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, bottom: 24.0),
                child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.call_end, color: Colors.blue),
                        fillColor: Colors.blue,
                        labelText: 'Telefone',
                        labelStyle:
                        CommonStyles(context: context).getLabelText()))),

            ResponsivePadding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, bottom: 25.0),
                child: TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock_outline, color: Colors.blue),
                        labelText: 'Senha',
                        labelStyle:
                            CommonStyles(context: context).getLabelText()))),
            ResponsivePadding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: TextFormField(
                    controller: _repetirSenhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Colors.blue),
                        labelText: 'Repetir Senha',
                        labelStyle:
                            CommonStyles(context: context).getLabelText())))
          ])))
    ]));
  }
}
