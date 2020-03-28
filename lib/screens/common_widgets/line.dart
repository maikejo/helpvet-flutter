import 'package:flutter/material.dart';

import '../common_widgets/responsive_padding.dart';
import '../../styles/common_colors.dart';
import '../../styles/common_variables.dart';

class LineWidget extends StatelessWidget {
  LineWidget();

  Widget build(BuildContext context) {
    return ResponsivePadding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
              child: Container(
                  height: 1.0,
                  margin: const EdgeInsets.only(right: 21.0),
                  color: CommonColors.lightGray)),
          Text(
            "or",
            style: TextStyle(
                color: CommonColors.gray,
                fontSize: CommonVariables(context: context).getSmallFontSize(),
                fontFamily: CommonVariables.defaultFont),
          ),
          Expanded(
              child: Container(
                  height: 1.0,
                  margin: const EdgeInsets.only(left: 21.0),
                  color: CommonColors.lightGray)),
        ]));
  }
}
