import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_animation.dart';
import '../common_widgets/responsive_image.dart';

class HomeAdmBar extends StatelessWidget {
  HomeAdmBar(
      {@required this.handleClickChatButton,
      @required this.handleClickAddPetButton,
      @required this.handleClickMainButton,
      @required this.handleClickLocalizacaoButton});

  final Function handleClickChatButton;
  final Function handleClickAddPetButton;
  final Function handleClickMainButton;
  final Function handleClickLocalizacaoButton;

  Widget _buildHomeButton(context) {
    return new InkWell(
        child: Container(
          margin: const EdgeInsets.only(left: 25),
          child: ResponsiveImage(
              image: new ExactAssetImage("images/icons/ic_home.jpg"),
              width: 32.0,
              height: 32.0),
        ),
        onTap: this.handleClickMainButton);
  }

  Widget _buildChatButton(context) {
    return new InkWell(
        child: Container(
          margin: const EdgeInsets.only(right: 50),
          child: ResponsiveImage(
              image: new ExactAssetImage("images/icons/ic_message.png"),
              width: 30.0,
              height: 30.0),
        ),
        onTap: this.handleClickChatButton);
  }

  Widget _buildLocalizacaotButton(context) {
    return new InkWell(
        child: Container(
          margin: const EdgeInsets.only(right: 0),
          child: ResponsiveImage(
              image: new ExactAssetImage("images/icons/ic_location_2.png"),
              width: 40.0,
              height: 40.0),
        ),
        onTap: this.handleClickLocalizacaoButton);
  }

  Widget _buildBonetButton(context) {
    return new InkWell(
        child: Container(
          margin: const EdgeInsets.only(right: 25),
          child: ResponsiveImage(
              image: new ExactAssetImage("images/icons/ic_bone.png"),
              width: 35.0,
              height: 35.0),
        ),
        onTap:null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: 450.0,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FadeAnimation(3,FloatingActionButton(
            heroTag: "btHomeAdm",
            backgroundColor: Colors.blue,
            child: const Icon(Icons.supervised_user_circle),
            onPressed: this.handleClickAddPetButton)),
        bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 6.0,
            child: new Container(
              //height: 200,
              //margin: const EdgeInsets.only(top: 5.0,left: 50),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildHomeButton(context),
                  _buildChatButton(context),
                  _buildLocalizacaotButton(context),
                  _buildBonetButton(context),
                ],
              ),
            )),
      ),
    );
  }
}
