import 'package:flutter/material.dart';

import './indicator.dart';

class PageIndicators extends StatelessWidget {
  final PageController pageController;

  const PageIndicators({Key key, this.pageController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.center,
            child: Indicator(
              controller: pageController,
              pageCount: 3,
              color: Colors.blueGrey,
            )),
      ],
    );
  }
}
