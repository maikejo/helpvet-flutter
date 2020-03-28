import 'package:flutter/material.dart';

import '../common_widgets/responsive_padding.dart';
import '../../styles/common_variables.dart';
import '../../styles/common_colors.dart';

class TitleWidget extends StatelessWidget {
  TitleWidget({
    this.text,
    this.paddingTop,
    this.paddingLeft,
    this.paddingRight,
    this.paddingBottom,
  });

  final String text;
  final double paddingTop;
  final double paddingBottom;
  final double paddingRight;
  final double paddingLeft;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ResponsivePadding(
          padding: EdgeInsets.only(
              top: paddingTop,
              left: paddingLeft,
              right: paddingRight,
              bottom: paddingBottom),
          child: Text(
            text,
            style: TextStyle(
                fontSize: CommonVariables(context: context).getLargeFontSize(),
                color: CommonColors.white,
                fontFamily: 'SanFransisco'),
          ),
        ),
      ],
    );
  }
}
