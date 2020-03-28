import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatefulWidget {
  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    final message = 'https://animalhomecare.com.br';
    return Scaffold(
        appBar: AppBar(
            title: Text("QR Code"),
            backgroundColor: Colors.pinkAccent),
      body: Material(
        color: Colors.white,
        child: SafeArea(
          top: true,
          bottom: true,
          child: FadeIn(1,Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Container(
                      width: 280,
                      child: QrImage(
                        data: message,
                        foregroundColor: Color(0xff03291c),
                        embeddedImage: AssetImage('images/helpvet_logo_round.png'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40)
                      .copyWith(bottom: 40),
                  child: Text('Tenha todos os dados de seu pet utilizando apenas o QR-Code , mostre para seu vetenirario favorito!'),
                ),
              ],
            ),
          )),
        ),
      )

    );
  }
}