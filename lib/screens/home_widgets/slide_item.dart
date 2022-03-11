import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'package:flutter_finey/screens/localizacao_screen.dart';

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
        height: MediaQuery.of(context).size.height / 3.9,
        width: MediaQuery.of(context).size.width / 1.2,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
          elevation: 3.0,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 40.0),
                    height: MediaQuery.of(context).size.height/5.9,
                    width: MediaQuery.of(context).size.width,

                      child: Container(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundImage: widget.img == null
                              ? AssetImage('images/ic_blank_image.png')
                              : CachedNetworkImageProvider("${widget.img}"),
                          radius: 20.0,

                        ),
                      ),

                    /*  CachedNetworkImageProvider(
                        "${widget.img}",
                        fit: BoxFit.cover,
                      ),*/
                    ),


                  Positioned(
                    top: 6.0,
                    left: 6.0,
                    child:GestureDetector(
                      child:  Image.asset("images/icons/ic_menu_tres_pontos.png",
                          height: 48,
                          width: 48),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LocalizacaoScreen(),
                          ),
                        );
                      },

                    ),
                    ),

                  Positioned(
                    top: 7.0,
                    right: 6.0,
                    child: Icon(
                      Icons.star,
                      color: Colors.yellow[600],
                      size: 25,
                    ),
                  ),

                ],
              ),

              SizedBox(height: 7.0),

              ResponsivePadding(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.nome}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              ResponsivePadding(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.tipoPet}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
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