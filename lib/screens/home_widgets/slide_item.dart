import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';

class SlideItem extends StatefulWidget {

  final String img;
  final String nome;
  final String tipoPet;
  final String rating;

  SlideItem({
    Key key,
    @required this.img,
    @required this.nome,
    @required this.tipoPet,
    @required this.rating,
  })
      : super(key: key);

  @override
  _SlideItemState createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.6,
        width: MediaQuery.of(context).size.width / 1.2,
        child: Card(
          color: Color(0xFF162A49),
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
          elevation: 3.0,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height/3.9,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider("${widget.img}"),
                        placeholder: AssetImage('images/ic_blank_image.png'),
                      ),

                    /*  CachedNetworkImageProvider(
                        "${widget.img}",
                        fit: BoxFit.cover,
                      ),*/
                    ),
                  ),

                  Positioned(
                    top: 6.0,
                    right: 6.0,
                    child: Card(
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(4.0)),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.yellow[600],
                              size: 10,
                            ),

                            Text(
                              " ${widget.rating} ",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

             /*    Positioned(
                    top: 6.0,
                    left: 6.0,
                    child: Card(
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(3.0)),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child:Text(
                          " ABRIR ",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),

              SizedBox(height: 7.0),

              ResponsivePadding(
                padding: EdgeInsets.only(left: 130.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.nome}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),

              ResponsivePadding(
                padding: EdgeInsets.only(left: 125.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.tipoPet}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.0),

            ],
          ),
        ),
      ),
    );
  }
}