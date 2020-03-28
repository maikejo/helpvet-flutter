import 'package:flutter/material.dart';

import '../../styles/common_variables.dart';

class CircleImage extends StatelessWidget {
  CircleImage(
      {this.image,
      this.imageNetwork,
      @required this.width,
      @required this.height});

  final double width;
  final double height;
  final ExactAssetImage image;
  final NetworkImage imageNetwork;

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
    return Container(
        width: _getWidth(context),
        height: _getHeight(context),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(200.0)),
            image: new DecorationImage(
                image: image ?? imageNetwork, fit: BoxFit.cover)));
  }
}
