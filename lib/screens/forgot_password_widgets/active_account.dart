import 'package:flutter/material.dart';

import '../common_widgets/shadow_card.dart';
import '../common_widgets/responsive_padding.dart';
import '../common_widgets/responsive_image.dart';
import '../common_widgets/responsive_container.dart';
import '../../styles/common_styles.dart';
import '../../styles/common_colors.dart';

class ActiveAccount extends StatelessWidget {
  ActiveAccount(
      {this.labelText,
      this.value,
      this.icon,
      this.iconWidth,
      this.iconHeight,
      this.onPressItem});

  final String labelText;
  final String value;
  final String icon;
  final double iconHeight;
  final double iconWidth;
  final Function onPressItem;

  @override
  Widget build(BuildContext context) {
    return ShadowCardWidget(
        paddingVertical: 18.0,
        child: Row(children: <Widget>[
          new ResponsiveContainer(
              width: 68.0,
              child: Center(
                  child: new ResponsiveImage(
                      image: new ExactAssetImage(icon),
                      width: iconWidth,
                      height: iconHeight))),
          new Container(
              width: 1.0,
              height: 48.0,
              color: CommonColors.lightGray,
              margin: const EdgeInsets.only(right: 24.0)),
          new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ResponsivePadding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(labelText,
                        style: CommonStyles(context: context)
                            .getBlackNormalText())),
                new Text(value,
                    style: CommonStyles(context: context).getGrayNormalText())
              ])
        ]),
        onPressItem: onPressItem);
  }
}
