import 'package:flutter/material.dart';

import '../common_widgets/responsive_padding.dart';
import '../../styles/common_colors.dart';
import '../../styles/common_variables.dart';

class HomeDetailButton extends StatelessWidget {
  HomeDetailButton({this.bgColor, this.label, this.value, this.onPress});

  final Color bgColor;
  final String label;
  final String value;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double horizontalPad =
        CommonVariables(context: context).getHorizontalPad(16);

    return Container(
        width: (deviceWidth - (horizontalPad * 3)) / 2,
        decoration: new BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(6.0)),
            color: bgColor,
            boxShadow: [
              const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0))
            ]),
        child: ResponsivePadding(
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            child: FlatButton(
                onPressed: this.onPress,
                child: Column(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(bottom: 7.0),
                      child: Text(label,
                          style: TextStyle(
                              color: CommonColors.white,
                              fontFamily: CommonVariables.defaultFont,
                              fontSize: CommonVariables(context: context)
                                  .getSmallFontSize(),
                              fontWeight: FontWeight.normal))),
                  Text(value,
                      style: TextStyle(
                          color: CommonColors.white,
                          fontFamily: CommonVariables.defaultFont,
                          fontSize: CommonVariables(context: context)
                              .getLargeFontSize(),
                          fontWeight: FontWeight.normal))
                ]))));
  }
}
