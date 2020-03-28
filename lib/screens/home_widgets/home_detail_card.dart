import 'package:flutter/material.dart';

import '../common_widgets/shadow_card.dart';
import '../common_widgets/responsive_padding.dart';
import '../common_widgets/circle_image.dart';
import '../common_widgets/responsive_container.dart';
import '../../styles/common_styles.dart';
import '../../styles/common_colors.dart';
import '../../styles/common_variables.dart';

class HomeDetailCard extends StatelessWidget {
  HomeDetailCard(
      {@required this.date,
      @required this.day,
      @required this.categoryName,
      @required this.categoryIcon,
      @required this.category,
      @required this.money,
      @required this.moneyTextStyle});

  final String date;
  final String day;
  final String categoryName;
  final String category;
  final String money;
  final ExactAssetImage categoryIcon;
  final TextStyle moneyTextStyle;

  Widget _buildDate(BuildContext context) {
    return ResponsiveContainer(
        width: 68.0,
        decoration: new BoxDecoration(
            border: Border(
                right: BorderSide(width: 1.0, color: CommonColors.lightGray))),
        child: Column(children: <Widget>[
          ResponsivePadding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(date,
                  style: TextStyle(
                      color: CommonColors.black,
                      fontSize:
                          CommonVariables(context: context).getLargeFontSize(),
                      fontFamily: CommonVariables.defaultFont,
                      fontWeight: FontWeight.normal))),
          new Text(day,
              style: CommonStyles(context: context).getGraySmallText())
        ]));
  }

  Widget _buildInfo(BuildContext context) {
    return Expanded(
        child: ResponsivePadding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new CircleImage(
                            image: categoryIcon, width: 24.0, height: 24.0),
                        ResponsivePadding(
                            padding: const EdgeInsets.only(left: 9.0),
                            child: Text(categoryName,
                                style: CommonStyles(context: context)
                                    .getDarkGrayNormalText()))
                      ]),
                  ResponsivePadding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: new Text(category,
                          style: CommonStyles(context: context)
                              .getGraySmallText()))
                ])));
  }

  Widget _buildMoney() {
    return ResponsivePadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(money, style: moneyTextStyle));
  }

  @override
  Widget build(BuildContext context) {
    return ShadowCardWidget(
        outerPadHorizontal: 16.0,
        outerPadVertical: 8.0,
        paddingVertical: 24.0,
        child: Row(children: <Widget>[
          _buildDate(context),
          _buildInfo(context),
          _buildMoney()
        ]),
        onPressItem: () {});
  }
}
