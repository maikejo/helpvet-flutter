import 'package:flutter/material.dart';
import '../common_widgets/responsive_padding.dart';
import '../common_widgets/responsive_container.dart';
import '../common_widgets/responsive_image.dart';
import '../../styles/common_variables.dart';

class HomeHeader extends StatelessWidget {
  HomeHeader();

  Widget _buildHeaderLeft(context) {
    return ResponsiveContainer(
        width: 100.0,
        child: ResponsivePadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(children: <Widget>[
              InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: new ResponsivePadding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: new ResponsiveImage(
                          image:
                              new ExactAssetImage("images/icons/ic_menu.png"),
                          width: 18.0,
                          height: 14.5)))
            ])));
  }

  // Build right header
  Widget _buildHeaderRight(context) {
    return ResponsiveContainer(
        width: 100.0,
        child: ResponsivePadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[])));
  }

  // Build center header
  Widget _buildHeaderCenter(context) {
    return Column(children: <Widget>[
      new Container(
        margin: const EdgeInsets.only(top: 15.0),
        child: Text('HelpVet',
            style: TextStyle(
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 25)),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double appBarPaddingTop =
        CommonVariables(context: context).getAppBarPaddingTop();
    double appBarHeight = CommonVariables(context: context).getAppBarHeight();
    double headerRowHeight = appBarHeight - appBarPaddingTop;

    return Container(
        padding: EdgeInsets.only(top: appBarPaddingTop),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          const BoxShadow(
              color: Colors.black12, blurRadius: 12.0, offset: Offset(0.0, 5.0))
        ]),
        child: Column(children: <Widget>[
          new Container(
              height: 50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildHeaderLeft(context),
                    _buildHeaderCenter(context),
                    _buildHeaderRight(context)
                  ])),
          //_buildTimeFilterBar(context)
        ]));
  }
}
