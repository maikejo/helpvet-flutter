import 'package:flutter/material.dart';

import '../common_widgets/responsive_padding.dart';

class ShadowCardWidget extends StatelessWidget {
  ShadowCardWidget(
      {this.outerPadHorizontal,
      this.outerPadVertical,
      this.paddingHorizontal,
      this.paddingVertical,
      @required this.child,
      @required this.onPressItem});

  final double outerPadHorizontal;
  final double outerPadVertical;
  final double paddingHorizontal;
  final double paddingVertical;
  final Widget child;
  final Function onPressItem;

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
        padding: EdgeInsets.symmetric(
            horizontal: outerPadHorizontal ?? 0.0,
            vertical: outerPadVertical ?? 0.0),
        child: Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(const Radius.circular(6.0)),
              boxShadow: [
                const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 4.0)),
              ],
            ),
            child: FlatButton(
                padding: const EdgeInsets.all(0.0),
                child: ResponsivePadding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontal ?? 0.0,
                        vertical: paddingVertical ?? 0.0),
                    child: child),
                onPressed: onPressItem)));
  }
}
