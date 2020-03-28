import 'package:flutter/material.dart';
import 'package:flutter_finey/external_widgets/exhibition_bottom/tabs.dart';
import 'package:flutter_finey/external_widgets/exhibition_bottom/vacina_sliding_cards.dart';
import 'package:flutter_finey/external_widgets/exhibition_clinicas/clinica_sliding_cards.dart';
import 'package:flutter_finey/helper/ui_helper.dart';

class ExploreContentWidget extends StatelessWidget {
  final double currentExplorePercent;
  final placeName = const [
    "Authentic\nrestaurant",
    "Famous\nmonuments",
    "Weekend\ngetaways"
  ];
  const ExploreContentWidget({Key key, this.currentExplorePercent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentExplorePercent != 0) {
      return Positioned(
        top: realH(standardHeight + (100 - standardHeight) * currentExplorePercent),
        width: screenWidth,
        child: Container(
          height: 550.0,
          child:  ClinicaSlidingCardsView(),
        ),
      );
    } else {
      return const Padding(
        padding: const EdgeInsets.all(0),
      );
    }
  }

  buildListItem(int index, String name) {
    return Transform.translate(
      offset: Offset(0, index * realH(127) * (1 - currentExplorePercent)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /*Image.asset(
            "images/localizacao/banner_${index % 3 + 1}.png",
            width: realH(127),
            height: realH(127),
          ),*/
          Text(
            placeName[index % 3],
            style: TextStyle(color: Colors.white, fontSize: realH(16)),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
