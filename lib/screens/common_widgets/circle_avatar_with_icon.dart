import 'package:flutter/material.dart';
import './circle_image.dart';

import './responsive_container.dart';

class CircleAvatarWithIcon extends StatelessWidget {
  CircleAvatarWithIcon(
      {@required this.image,
      @required this.icon,
      @required this.iconBgColor,
      this.top,
      this.bottom,
      this.left,
      this.right});

  final ExactAssetImage image;
  final Icon icon;
  final Color iconBgColor;
  final double top;
  final double bottom;
  final double left;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ResponsiveContainer(
          width: 88.0,
          child: Row(children: <Widget>[
            CircleImage(width: 72.0, height: 72.0, image: image)
          ])),
      Positioned(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          child: new ResponsiveContainer(
              width: 32.0,
              height: 32.0,
              decoration: new BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(100.0)),
                  color: iconBgColor),
              child: icon))
    ]);
  }
}
