import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/model/cartao_credito.dart';
import 'package:flutter_finey/screens/pagamento_widgets/cartao_credito_form.dart';
import 'package:flutter_finey/screens/pagamento_widgets/cartao_credito_widget.dart';
import 'dart:async';

class PagamentoScreen extends StatefulWidget {
  PagamentoScreen({this.plano});

  final String plano;

  @override
  _PagamentoScreenState createState() => _PagamentoScreenState();
}

class _PagamentoScreenState extends State<PagamentoScreen> {
  final Firestore datbase = Firestore.instance;
  Stream slides;
  final db = Firestore.instance;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pagamento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
            title: Text("Pagamento"),
            backgroundColor: Colors.pinkAccent,
            leading: IconButton(icon:Icon(Icons.arrow_back),
        onPressed:() => Application.router.navigateTo(
            context, RouteConstants.ROUTE_PLANOS,
            transition: TransitionType.fadeIn),
      )
    ),
        resizeToAvoidBottomInset: true,

        body: SafeArea(
          child: Column(
            children: <Widget>[
              CartaoCreditoWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: CartaoCreditoForm(
                    onCreditCardModelChange: onCreditCardModelChange,
                    plano: 30,
                    valor: "10,00",
                  ),
                ),
              ),

            ],
          ),

        ),
      ),
    );
  }

  void onCreditCardModelChange(CartaoCredito creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

}
