import 'package:flutter/material.dart';

import '../common_widgets/responsive_padding.dart';
import '../common_widgets/circle_image.dart';
import '../../styles/common_styles.dart';
import '../../styles/common_colors.dart';

class CategoryItem extends StatelessWidget {
  CategoryItem(
      {@required this.categoryIcon,
      @required this.categoryName,
      @required this.money,
      @required this.moneyTextStyle,
      this.onPressItem});

  final ExactAssetImage categoryIcon;
  final String categoryName;
  final String money;
  final TextStyle moneyTextStyle;
  final Function onPressItem;

  Widget _buildInfo(BuildContext context) {
    return Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
      new Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        new CircleImage(image: categoryIcon, width: 24.0, height: 24.0),
        ResponsivePadding(
            padding: const EdgeInsets.only(left: 9.0),
            child: Text(categoryName,
                style: CommonStyles(context: context).getDarkGrayNormalText()))
      ])
    ]));
  }

  Widget _buildMoney() {
    return Text(money, style: moneyTextStyle);
  }

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
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child:
                  Row(children: <Widget>[_buildInfo(context), _buildMoney()]),
            )));
  }
}
