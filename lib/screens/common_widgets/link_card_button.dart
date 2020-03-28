import 'package:flutter/material.dart';

import '../common_widgets/responsive_image.dart';
import '../../styles/common_styles.dart';
import '../../styles/common_colors.dart';
import '../../styles/common_variables.dart';

class LinkCardButtonWidget extends StatelessWidget {
  LinkCardButtonWidget({this.text, this.onPress});

  final String text;
  final Function onPress;

  double _getWidth(context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var btnWidth = CommonVariables.defaultBtnWidth;

    btnWidth = btnWidth * (deviceWidth / CommonVariables.defaultWidth);
    return btnWidth;
  }

  double _getHeight(context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var btnHeight = CommonVariables.defaultBtnHeight;

    if (deviceWidth >= CommonVariables.largeDeviceWidth) {
      btnHeight = btnHeight * 1.3;
    }

    return btnHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _getWidth(context),
        height: _getHeight(context),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(const Radius.circular(6.0)),
            border: new Border.all(
                color: CommonColors.gray,
                width: 1.0,
                style: BorderStyle.solid)),
        child: FlatButton(
            onPressed: this.onPress,
            child: Stack(children: <Widget>[
              Positioned.fill(
                child: Center(
                    child: Text(text,
                        style: CommonStyles(context: context)
                            .getGrayNormalText())),
              ),
              Positioned(
                  left: 0.0,
                  child: SizedBox(
                      height: _getHeight(context),
                      child: ResponsiveImage(
                        image: ExactAssetImage("images/icons/ic_add.png"),
                        width: 32.0,
                        height: 32.0,
                      )))
            ])));
  }
}
