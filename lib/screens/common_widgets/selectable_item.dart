import 'package:flutter/material.dart';

import '../common_widgets/responsive_padding.dart';
import '../common_widgets/responsive_image.dart';
import '../common_widgets/responsive_container.dart';
import '../../styles/common_styles.dart';
import '../../styles/common_colors.dart';

class SelectableItem extends StatelessWidget {
  SelectableItem(
      {this.imageIcon,
      this.imageIconWidth,
      this.imageIconHeight,
      this.text,
      this.onPressItem});

  final String imageIcon;
  final double imageIconWidth;
  final double imageIconHeight;
  final String text;
  final Function onPressItem;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onPressItem,
        child: Container(
            decoration: new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide(
                        width: 1.0, color: CommonColors.lightGray))),
            child: ResponsivePadding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ResponsiveContainer(
                          width: 56.0,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ResponsiveImage(
                                    image: new ExactAssetImage(imageIcon),
                                    width: imageIconWidth,
                                    height: imageIconHeight)
                              ])),
                      Expanded(
                          child: Text(text,
                              style: CommonStyles(context: context)
                                  .getGrayNormalText())),
                      ResponsivePadding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ResponsiveImage(
                              image: new ExactAssetImage(
                                  "images/icons/ic_arrow_right.png"),
                              width: 7.5,
                              height: 12.0))
                    ]))));
  }
}
