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
        color: Colors.transparent,
        elevation: 9.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
            height: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)
                ),
                color: Colors.white
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width /2 - 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          InkWell(
                              child: Container(
                                child: ResponsiveImage(
                                    image: new ExactAssetImage("images/icons/ic_home.jpg"),
                                    width: 30.0,
                                    height: 30.0),
                              ),
                              onTap: this.handleClickMainButton),

                          InkWell(
                              child: Container(
                                child: ResponsiveImage(
                                    image: new ExactAssetImage("images/icons/ic_message.png"),
                                    width: 30.0,
                                    height: 30.0),
                              ),
                              onTap: this.handleClickChatButton),

                          //Icon(Icons.home, color: Color(0xFFEF7532)),
                          //Icon(Icons.person_outline, color: Color(0xFF676E79))
                        ],
                      )
                  ),
                  Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width /2 - 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          InkWell(
                              child: Container(
                                child: ResponsiveImage(
                                    image: new ExactAssetImage("images/icons/ic_location_2.png"),
                                    width: 32.0,
                                    height: 32.0),
                              ),
                              onTap: this.handleClickLocalizacaoButton),

                          InkWell(
                              child: Container(
                                //margin: const EdgeInsets.only(right: 25),
                                child: ResponsiveImage(
                                    image: new ExactAssetImage("images/icons/ic_descobrir_pet.png"),
                                    width: 30.0,
                                    height: 30.0),
                              ),
                              onTap:this.handleClickBoneButton)

                          //Icon(Icons.search, color: Color(0xFF676E79)),
                          //Icon(Icons.shopping_basket, color: Color(0xFF676E79))
                        ],
                      )
                  ),
                ]
            )
        )
    );
  }
}
