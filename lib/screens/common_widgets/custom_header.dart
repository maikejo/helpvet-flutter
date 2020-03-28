import 'package:flutter/material.dart';

import '../../styles/common_styles.dart';

class CustomHeader extends StatelessWidget {
  CustomHeader({this.title, this.leftButton, this.rightButton});

  final String title;

  final Widget leftButton;

  final Widget rightButton;

  @override
  Widget build(BuildContext context) {
    var emptyButton = Container(width: 30.0, height: 30.0, color: Colors.red);

    return Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          const BoxShadow(color: Colors.black38, blurRadius: 20.0)
        ]),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 24.0, bottom: 4.0),
                  child: leftButton != null ? leftButton : emptyButton),
              Padding(
                  padding: EdgeInsets.only(top: 24.0, bottom: 4.0),
                  child: new Text(title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: CommonStyles(context: context).getHeaderText())),
              Padding(
                  padding: EdgeInsets.only(top: 24.0, bottom: 4.0),
                  child: rightButton != null ? rightButton : emptyButton)
            ]));
  }
}
