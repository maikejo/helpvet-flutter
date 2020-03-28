import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_finey/helper/date_converter.dart';
import 'package:flutter_finey/screens/chat_widgets/full_screen_image.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'dart:math' as math;

import 'package:flutter_finey/service/auth.dart';

class ClinicaSlidingCardsView extends StatefulWidget {
  ClinicaSlidingCardsView({this.idPet});

  final String idPet;

  @override
  _ClinicaSlidingCardsViewState createState() => _ClinicaSlidingCardsViewState();
}

class _ClinicaSlidingCardsViewState extends State<ClinicaSlidingCardsView> {
  PageController pageController;
  PageController pageController2;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.85);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });

    pageController2 = PageController(viewportFraction: 0.85);
    pageController2.addListener(() {
      setState(() => pageOffset = pageController2.page);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: PageView(
        controller: pageController,
        children: <Widget>[

          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("clinicas").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {

                  return PageView(
                      controller: pageController2,
                      children: snapshot.data.documents.map((doc) {

                        //var dataAplicacao  = DateConverter().converteTimestamp(doc.data['dataAplicacao'].millisecondsSinceEpoch);
                        //var dataReaplicacao  = DateConverter().converteTimestamp(doc.data['dataReaplicacao'].millisecondsSinceEpoch);

                        return GestureDetector(
                          child: SlidingCard(
                            nome: doc.data['nome'],
                            email: doc.data['email'],
                            endereco: 'Endereço: ' + doc.data['endereco'],
                            imagem: doc.data['imagemUrl'],
                            offset: pageOffset,
                          ),

                          onLongPress: (() async{
                            await Firestore.instance
                                .collection('clinicas')
                                .document(doc.documentID)
                                .delete();
                          }),
                        );

                      }).toList(),
                    );

                } else {
                  return SizedBox();
                }
              }),

        ],
      ),
    );
  }
}

class SlidingCard extends StatelessWidget {
  final String nome;
  final String email;
  final String endereco;
  final String imagem;
  final double offset;

  const SlidingCard({
    Key key,
    @required this.nome,
    @required this.email,
    @required this.endereco,
    @required this.imagem,
    @required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child:  ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                child: Image.network(
                  '$imagem',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment(-offset.abs(), 0),
                  fit: BoxFit.none,
                ),
              ),
              onTap: ((){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => FullScreenImage(photoUrl: '$imagem')));
                }),
            ),

            SizedBox(height: 8),
            Expanded(
              child: CardContent(
                nome: nome,
                email: email,
                endereco: endereco,
                offset: gauss,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String nome;
  final String email;
  final String endereco;
  final double offset;

  const CardContent(
      {Key key,
        @required this.nome,
        @required this.email,
        @required this.endereco,
        @required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(nome, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              email,
              style: TextStyle(color: Colors.green),
            ),
          ),
          SizedBox(height: 15.0),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              endereco,
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),

          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * offset, 0),
                child: ResponsivePadding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: FloatingActionButton.extended(
                      heroTag: "btLigar",
                      label: Text("Ligar"),
                      backgroundColor: Colors.green,
                      icon: const Icon(Icons.call),
                      onPressed: () {

                      }),
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}