import 'package:flutter/material.dart';

import '../../styles/common_variables.dart';

class ResponsivePadding extends StatelessWidget {
  ResponsivePadding({this.padding, this.child});

  final EdgeInsets padding;
  final Widget child;

  double _getRightPadding(context) {
    if (this.padding == null) {
      return 0.0;
    }
    var deviceWidth = MediaQuery.of(context).size.width;
    return this.padding.right * (deviceWidth / CommonVariables.defaultWidth);
  }

  double _getTopPadding(context) {
    if (this.padding == null) {
      return 0.0;
    }
    var deviceHeight = MediaQuery.of(context).size.height;
    return this.padding.top * (deviceHeight / CommonVariables.defaultHeight);
  }

  double _getLeftPadding(context) {
    if (this.padding == null) {
      return 0.0;
    }
    var deviceWidth = MediaQuery.of(context).size.width;
    return this.padding.left * (deviceWidth / CommonVariables.defaultWidth);
  }

  double _getBottomPadding(context) {
    if (this.padding == null) {
      return 0.0;
    }
    var deviceHeight = MediaQuery.of(context).size.height;
    return this.padding.bottom * (deviceHeight / CommonVariables.defaultHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        child: this.child,
        padding: EdgeInsets.only(
            right: _getRightPadding(context),
            top: _getTopPadding(context),
            left: _getLeftPadding(context),
            bottom: _getBottomPadding(context)));
  }
}
