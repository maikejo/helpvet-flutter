import 'package:flutter/material.dart';
import 'package:flutter_finey/helper/ui_helper.dart';

class RecentSearchWidget extends StatelessWidget {
  final double currentSearchPercent;

  const RecentSearchWidget({Key key, this.currentSearchPercent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentSearchPercent != 0
        ? Positioned(
            top: realH(
                -(75.0 + 494.0) + (75 + 75.0 + 494.0) * currentSearchPercent),
            left: realW((standardWidth - 320) / 2),
            width: realW(320),
            height: realH(494),
            child: Opacity(
              opacity: currentSearchPercent,
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "images/localizacao/recent.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
        : const Padding(
            padding: const EdgeInsets.all(0),
          );
  }
}
