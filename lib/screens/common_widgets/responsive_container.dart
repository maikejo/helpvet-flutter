import 'package:flutter/material.dart';

import '../../styles/common_variables.dart';

class ResponsiveContainer extends StatelessWidget {
  ResponsiveContainer(
      {this.width, this.height, @required this.child, this.decoration});

  final Widget child;
  final double width;
  final double height;
  final BoxDecoration decoration;

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
    if (this.height == null && this.width == null) {
      return Container(decoration: this.decoration, child: this.child);
    }

    if (this.width == null) {
      return Container(
          height: _getHeight(context),
          decoration: this.decoration,
          child: this.child);
    }

    if (this.height == null) {
      return Container(
          width: _getWidth(context),
          decoration: this.decoration,
          child: this.child);
    }

    return Container(
        width: _getWidth(context),
        height: _getHeight(context),
        decoration: this.decoration,
        child: this.child);
  }
}
