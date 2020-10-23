import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_animation.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/screens/common_widgets/bottomBar.dart';
import '../common_widgets/responsive_image.dart';

class HomeBar extends StatelessWidget {
  HomeBar(
      {@required this.handleClickChatButton,
      @required this.handleClickAddPetButton,
      @required this.handleClickMainButton,
      @required this.handleClickLocalizacaoButton,
      this.handleClickBoneButton});

  final Function handleClickChatButton;
  final Function handleClickAddPetButton;
  final Function handleClickMainButton;
  final Function handleClickLocalizacaoButton;
  final Function handleClickBoneButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FadeAnimation(3,FloatingActionButton(
            heroTag: "bt1",
            backgroundColor: Colors.pinkAccent,
            child: const Icon(Icons.pets),
            onPressed: this.handleClickAddPetButton)),
        bottomNavigationBar: BottomBar(handleClickChatButton: this.handleClickChatButton,
          handleClickAddPetButton: this.handleClickAddPetButton,
          handleClickMainButton: this.handleClickMainButton,
          handleClickLocalizacaoButton: this.handleClickLocalizacaoButton,
          handleClickBoneButton: this.handleClickBoneButton),
      );

  }
}
