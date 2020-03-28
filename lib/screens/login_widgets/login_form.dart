import 'package:flutter/material.dart';
import 'package:flutter_finey/util/validator.dart';

import '../../styles/common_styles.dart';
import '../common_widgets/responsive_padding.dart';
import 'package:flutter_finey/model/user.dart';

class LoginForm extends StatelessWidget {
  LoginForm(this._usuarioController, this._senhaController, this.animation);

  User user = new User();
  final TextEditingController _usuarioController;
  final TextEditingController _senhaController;
  String animation;

  bool _isToggled = true;
  var _toggleIcon = Icon(Icons.remove_red_eye, color: Colors.grey);

  _togglePassword() {
    if (_isToggled == false) {
      _toggleIcon = Icon(Icons.remove_red_eye, color: Colors.grey);
      _isToggled = true;
    } else {
      _toggleIcon = Icon(Icons.remove_red_eye, color: Colors.blue);
      _isToggled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //return Expanded(
    return Container(
        child: Column(children: <Widget>[

          Form(
          // key: key,
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
            ResponsivePadding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 24.0),
                child: TextFormField(
                  onTap: (){
                    this.animation = "go";
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: _usuarioController,
                  decoration: InputDecoration(
                      fillColor: Colors.red,
                      icon: new Icon(
                        Icons.mail,
                        color: Colors.black54,
                      ),
                      labelText: 'Email',
                      labelStyle: CommonStyles(context: context).getLabelText(),
                    suffixIcon: _usuarioController.text.isNotEmpty ?

                    InkWell(
                      child: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.grey,),
                        onPressed: () {
                          _usuarioController.clear();
                        },
                      ),
                    ) : null,
                  ),
                ),

            ),
            ResponsivePadding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: TextFormField(
                    onTap: (){
                      this.animation = "erro";
                    },
                    controller: _senhaController,
                    obscureText: _isToggled,
                    decoration: InputDecoration(
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.black54,
                        ),
                        labelText: 'Senha',
                        labelStyle:
                            CommonStyles(context: context).getLabelText(),
                        /*suffix: InkWell(
                          onTap: () {
                            _togglePassword();
                          },
                          child: _toggleIcon,
                        )*/))),

          ])))
    ]));
  }
}
