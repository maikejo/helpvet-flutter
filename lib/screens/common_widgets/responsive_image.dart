import 'package:flutter/material.dart';
import 'package:flutter_finey/styles/common_variables.dart';

import '../../styles/common_variables.dart';

class ResponsiveImage extends StatelessWidget {
  ResponsiveImage(
      {@required this.image, @required this.width, @required this.height});

  final double width;
  final double height;
  final ExactAssetImage image;

  double _getWidth(context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    if (deviceWidth >= CommonVariables.largeDeviceWidth) {
      return this.width * 1.3;
    }

    return this.width * (deviceWidth / CommonVariables.defaultWidth);
  }

  double _getHeight(context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    if (deviceWidth >= CommonVariables.largeDeviceWidth) {
      return this.height * 1.3;
    }

    return this.height * (deviceWidth / CommonVariables.defaultWidth);
  }

  @override
  Widget build(BuildContext context) {
    return Image(
        fit: BoxFit.cover,
        image: this.image,
        width: _getWidth(context),
        height: _getHeight(context));
  }
}
