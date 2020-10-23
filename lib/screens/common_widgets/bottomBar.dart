import 'package:flutter/material.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_image.dart';

class BottomBar extends StatelessWidget {
  BottomBar(
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
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.white,
        elevation: 25.0,
        clipBehavior: Clip.antiAlias,

            child: Row(
                children: [
                  Container(
                      height:  MediaQuery.of(context).size.height,
                      width:  MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          InkWell(
                              child: Container(
                                child: ResponsiveImage(
                                    image: new ExactAssetImage("images/icons/ic_home.jpg"),
                                    width: 35.0,
                                    height: 35.0),
                              ),
                              onTap: this.handleClickMainButton),

                          InkWell(
                              child: Container(
                                child: ResponsiveImage(
                                    image: new ExactAssetImage("images/icons/ic_message.png"),
                                    width: 32.0,
                                    height: 32.0),
                              ),
                              onTap: this.handleClickChatButton),

                          InkWell(
                              child: Container(
                                child: ResponsiveImage(
                                    image: new ExactAssetImage("images/icons/ic_location_2.png"),
                                    width: 35.0,
                                    height: 35.0),
                              ),
                              onTap: this.handleClickLocalizacaoButton),

                          InkWell(
                              child: Container(
                                //margin: const EdgeInsets.only(right: 25),
                                child: ResponsiveImage(
                                    image: new ExactAssetImage("images/icons/ic_descobrir_pet.png"),
                                    width: 35.0,
                                    height: 35.0),
                              ),
                              onTap:this.handleClickBoneButton)

                          //Icon(Icons.home, color: Color(0xFFEF7532)),
                          //Icon(Icons.person_outline, color: Color(0xFF676E79))
                        ],
                      )
                  ),

                ]
            )

    );
  }
}
