import 'package:flutter/material.dart';

import '../common_widgets/responsive_image.dart';
import '../common_widgets/responsive_padding.dart';
import '../common_widgets/responsive_container.dart';
import '../../styles/common_variables.dart';
import '../../styles/common_styles.dart';

class FineyHeader extends StatelessWidget {
  FineyHeader(
      {this.title,
      this.rightImageIconButton,
      this.leftImageIconButton,
      this.rightImageIconButtonWidth,
      this.rightImageIconButtonHeight,
      this.leftImageIconButtonHeight,
      this.leftImageIconButtonWidth,
      this.rightIconButton,
      this.leftIconButton,
      this.rightTextButton,
      this.leftTextButton,
      this.onPressRightButton,
      this.onPressLeftButton,
      this.noShadow});

  final String title;
  final String rightImageIconButton;
  final String leftImageIconButton;
  final double rightImageIconButtonWidth;
  final double rightImageIconButtonHeight;
  final double leftImageIconButtonWidth;
  final double leftImageIconButtonHeight;
  final IconData rightIconButton;
  final IconData leftIconButton;
  final String rightTextButton;
  final String leftTextButton;
  final Function onPressRightButton;
  final Function onPressLeftButton;
  final bool noShadow;

  Widget _renderLeftButton(context) {
    return ResponsiveContainer(
      width: 120.0,
      child: ResponsivePadding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              leftImageIconButton != null
                  ? new InkWell(
                      onTap: this.onPressLeftButton,
                      child: new ResponsivePadding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: new ResponsiveImage(
                              image: new ExactAssetImage(leftImageIconButton),
                              width: leftImageIconButtonWidth,
                              height: leftImageIconButtonHeight)))
                  : Container(),
              leftIconButton != null
                  ? new InkWell(
                      child: new ResponsivePadding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(leftIconButton)),
                      onTap: this.onPressLeftButton)
                  : Container(),
              leftTextButton != null
                  ? new InkWell(
                      onTap: this.onPressLeftButton,
                      child: new ResponsivePadding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(leftTextButton,
                              style: CommonStyles(context: context)
                                  .getHeaderTextButton())))
                  : Container(),
            ],
          )),
    );
  }

  Widget _renderRightButton(context) {
    return ResponsiveContainer(
        width: 120.0,
        child: ResponsivePadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <
                Widget>[
              rightImageIconButton != null
                  ? new InkWell(
                      onTap: this.onPressRightButton,
                      child: new ResponsivePadding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: new ResponsiveImage(
                            image: new ExactAssetImage(rightImageIconButton),
                            width: rightImageIconButtonWidth,
                            height: rightImageIconButtonHeight),
                      ))
                  : Container(),
              rightIconButton != null
                  ? new InkWell(
                      child: new ResponsivePadding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(rightIconButton)),
                      onTap: this.onPressRightButton)
                  : Container(),
              rightTextButton != null
                  ? new InkWell(
                      onTap: this.onPressRightButton,
                      child: new ResponsivePadding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: Text(rightTextButton,
                            style: CommonStyles(context: context)
                                .getHeaderTextButton()),
                      ),
                    )
                  : Container()
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: CommonVariables(context: context).getAppBarHeight(),
        padding: EdgeInsets.only(
            top: CommonVariables(context: context).getAppBarPaddingTop()),
        decoration: (noShadow == null || noShadow == false)
            ? new BoxDecoration(color: Colors.white, boxShadow: [
                const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12.0,
                    offset: Offset(0.0, 5.0)),
              ])
            : const BoxDecoration(),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _renderLeftButton(context),
              title != null
                  ? new Text(title,
                      style: CommonStyles(context: context).getHeaderText())
                  : Container(),
              _renderRightButton(context)
            ]));
  }
}
