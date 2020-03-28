import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_finey/model/translate_cloud.dart';
import 'common_widgets/responsive_padding.dart';

class InfoDescobrirPetScreen extends StatefulWidget {
  InfoDescobrirPetScreen({this.listaInfo,this.foto});

  final List<TranslateCloud> listaInfo;
  final String foto;

  @override
  _InfoDescobrirPetScreenState createState() => _InfoDescobrirPetScreenState();
}

class MyCurve extends Curve {
  @override
  double transform(double t) => -pow(t, 2) + 1;
}

class _InfoDescobrirPetScreenState extends State<InfoDescobrirPetScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        child: Column(
          children: <Widget>[

            ResponsivePadding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text('Informações do seu pet' ,
                  style: TextStyle(fontWeight: FontWeight.bold,
                      color: Color(0xFF162A49),
                      fontSize: 24
                  )),
            ),

            ResponsivePadding(
            padding: EdgeInsets.only(top: 20.0),
                  child: CircleAvatar(
                      backgroundColor: Color(0xFF162A49),
                      radius: 50.0,
                      child: CircleAvatar(
                        radius: 48.0,
                        backgroundImage: CachedNetworkImageProvider(widget.foto),
                      ),
                    ),
            ),

            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.listaInfo.length,
                itemBuilder: (context, translateCloud) {

                  return Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        width: 10.0,
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(children: <Widget>[

                            Container(
                              child: Text(widget.listaInfo[translateCloud].description,
                              style: TextStyle(
                                color: Colors.indigo[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                height: 1.6,
                              ),
                             ),
                            ),

                            SizedBox(width: 10.0),

                            widget.listaInfo[translateCloud].score >= 0.9 ? Container(
                              child: Center(
                                child: Text('90% á 100%',
                                  style: TextStyle(color: Colors.white,fontSize: 12.0),
                                ),
                              ),

                              height: 17,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.green,
                              ),
                            ) : widget.listaInfo[translateCloud].score > 0.8 ||
                                widget.listaInfo[translateCloud].score < 0.7 ||
                                widget.listaInfo[translateCloud].score > 0.6 ||
                                widget.listaInfo[translateCloud].score <= 0.5 ? Container(
                              child: Center(
                                child: Text('50% á 80%',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),

                              height: 17,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.amber,
                              ),
                            ) : widget.listaInfo[translateCloud].score > 0.0 ||
                                widget.listaInfo[translateCloud].score < 0.1 ||
                                widget.listaInfo[translateCloud].score > 0.2 ||
                                widget.listaInfo[translateCloud].score < 0.3 ||
                                widget.listaInfo[translateCloud].score <= 0.4 ? Container(
                              child: Center(
                                child: Text('0% á 40%',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),

                              height: 17,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.red,
                              ),
                            ) : SizedBox(),
                          ]
                          ),
                        ),
                      )
                  );
                },
              ),
            ),
          ],
        ),
    );

  }
}