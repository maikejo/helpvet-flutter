import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as response;
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_finey/blockchain/blockchain.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/helper/size_config.dart';
import 'package:flutter_finey/model/ether_scan_transaction.dart';
import 'package:flutter_finey/model/localizacao_pet.dart';
import 'package:flutter_finey/model/wallet.dart' as wallet;
import 'package:flutter_finey/screens/common_widgets/finey_drawer.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_container.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:intl/intl.dart';
import 'package:web3dart/credentials.dart';

class WalletHomeScreen extends StatefulWidget {
  WalletHomeScreen({@required this.privateKey});
  final Future<String> privateKey;

  @override
  _WalletHomeScreenState createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> {
  var simbolo = null;
  var total_token = null;
  final bool _running = true;
  static wallet.Wallet dadosWallet;
  static LocalizacaoPet dadosLocalizacaoPet;
  static BlockchainUtils blockchainUtils = BlockchainUtils();
  final Dio _dio = Dio();
  var _baseUrl = 'https://api-rinkeby.etherscan.io/api';
  static List<EtherScanResultTransaction> transactions = null;
  final currencyFormatter = NumberFormat('#,##0.000');

  @override
  void initState() {
    super.initState();
    blockchainUtils.initialSetup();
    getDadosWallet(Auth.user.email);
    getDadosRecompensa(Auth.user.email);

  }

  static Future<List<EtherScanResultTransaction>> getTransactionEtherScan(String adress, String apiKey) async {
    Dio _dio = Dio();
    EtherScanTransaction transaction;

    try {
      response.Response userData = await _dio.get('https://api-rinkeby.etherscan.io/api?module=account&action=txlist&address=$adress&startblock=0&endblock=99999999&page=1&offset=10&sort=asc&apikey=$apiKey');
      print('User Info: ${userData.data}');
      transaction = EtherScanTransaction.fromJson(userData.data);
      transactions = transaction.result;
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
    }
    return transactions;
  }

  static Future<wallet.Wallet> getDadosWallet(String email) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('wallet').document(email).get();

    if (snapshot.data != null) {
      var nome = snapshot['nome'];
      var privateKey = snapshot['privateKey'];
      var address = snapshot['address'];
      var contratoAprovado = snapshot['contratoAprovado'];

      wallet.Wallet recuperaWallet = new wallet.Wallet(
          nome: nome
          , privateKey: privateKey
          , address: address
          , contratoAprovado: contratoAprovado);

      dadosWallet = recuperaWallet;

      getTransactionEtherScan(dadosWallet.address, dotenv.env["FIRST_COIN_CONTRACT_ADDRESS"]);
      approve(dadosWallet.address);

      return dadosWallet;
    } else {
      return null;
    }
  }

  static Future<LocalizacaoPet> getDadosRecompensa(String email) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('localizacao_pet')
        .document(email)
        .get();

    if (snapshot.data != null) {
      var recompensa = snapshot['recompensa'];

      LocalizacaoPet localizacaoPet =
          new LocalizacaoPet(recompensa: recompensa);

      dadosLocalizacaoPet = localizacaoPet;
      return dadosLocalizacaoPet;
    } else {
      return null;
    }
  }

  void transferToken(double amount) async {
    blockchainUtils.transfer(EthereumAddress.fromHex(dadosWallet.address),
        amount, dadosWallet.privateKey);
  }

  void transferFromToken(EthereumAddress addressFrom, EthereumAddress addressSend, double amount) async {
    EthereumAddress addressFrom = EthereumAddress.fromHex(dadosWallet.address);
    EthereumAddress addressSend = EthereumAddress.fromHex("0x9Fb2838fC9570D57baE43e41dFE716B294905F04");
    blockchainUtils.transferFrom(addressFrom, addressSend, amount, dadosWallet.privateKey);
  }

  static void approve(String address) async {
    if(!dadosWallet.contratoAprovado && address != null){
     String response = await blockchainUtils.approve(EthereumAddress.fromHex(address), 100009000000000000000, dadosWallet.privateKey);

     if(response != null){
       Firestore.instance.collection('wallet').document(Auth.user.email).updateData({'contratoAprovado': true});
     }

    }
  }

  Stream<String> getBalanceOfWallet() async* {
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 3));
      total_token = await blockchainUtils.getBalanceOf(EthereumAddress.fromHex(dadosWallet.address));
      //final currencyFormatter = NumberFormat('#,##0.000');
      //total_token = currencyFormatter.format(total_token);
      yield "${total_token}";
    }
  }

  @override
  Widget build(BuildContext context) {
    var layoutBuilder = LayoutBuilder(builder: _buildWithConstraints);

    return Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Application.router.navigateTo(
              context, RouteConstants.ROUTE_HOME,
              transition: TransitionType.fadeIn),
        ),
        backgroundColor: Color.fromRGBO(38, 81, 158, 1),
        title: Text('Minha Carteira'),
      ),
      backgroundColor: Color.fromRGBO(38, 81, 158, 1),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text("Inicio")),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), title: Text("Card")),
        ],
        /* onTap: (index){
          setState(() {
            selectedTab = index;
          });
        },*/
        showUnselectedLabels: true,
        iconSize: 30,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: layoutBuilder,
    );
  }

  Widget _buildWithConstraints(
      BuildContext context, BoxConstraints constraints) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          //Container for top data

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              children: <Widget>[
                /*     Icon(
                  Icons.notifications, color: Colors.lightBlue[100],),*/
                SizedBox(
                  width: 16,
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset("images/ic_pet.png",
                        fit: BoxFit.contain, width: 40),
                  ),
                )
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //Icon(Icons.backspace_rounded, color: Colors.lightBlue[100],),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 70),
                      child: StreamBuilder(
                        stream: getBalanceOfWallet(),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.data == null) {
                            return const CircularProgressIndicator();
                          }
                          return Text(
                              'HVT' +
                                  ' - ${currencyFormatter.format(double.parse(snapshot.data) / 1000000000000000000)}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700));
                        },
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 72),
                  child: Text(
                    "Valor total",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.blue[100]),
                  ),
                ),
                SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (() {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return _dialogTransferToken();
                            });
                      }),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(243, 245, 248, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              child: Icon(
                                Icons.send,
                                color: Colors.blue[900],
                                size: 30,
                              ),
                              padding: EdgeInsets.all(12),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Enviar",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.blue[100]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (() {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return _dialogClaimToken();
                            });
                      }),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(243, 245, 248, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              child: Icon(
                                Icons.attach_money,
                                color: Colors.blue[900],
                                size: 30,
                              ),
                              padding: EdgeInsets.all(12),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Ganhos",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.blue[100]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(243, 245, 248, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18))),
                            child: Icon(
                              Icons.public,
                              color: Colors.blue[900],
                              size: 30,
                            ),
                            padding: EdgeInsets.all(12),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Transações",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.blue[100]),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (() {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return _dialogConfigToken();
                            });
                      }),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(243, 245, 248, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              child: Icon(
                                Icons.build_circle,
                                color: Colors.blue[900],
                                size: 30,
                              ),
                              padding: EdgeInsets.all(12),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Configurações",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.blue[100]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          //draggable sheet
          DraggableScrollableSheet(
            builder: (context, scrollController) {
              return FutureBuilder(
                future: getTransactionEtherScan("0x4324a8c8131931f599870d9A55572bfa63a302ec", dotenv.env["ETHERSCAN_API_KEY"]),
                  builder:  (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                     return Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(243, 245, 248, 1),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 24,
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Transações Recentes",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 24,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "Ver todos",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.grey[800]),
                                    )
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 32),
                              ),
                              SizedBox(
                                height: 24,
                              ),

                              //Container for buttons
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 32),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Todos",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: Colors.grey[900]),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[200],
                                                blurRadius: 10.0,
                                                spreadRadius: 4.5)
                                          ]),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.green,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "Completa",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Colors.grey[900]),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[200],
                                                blurRadius: 10.0,
                                                spreadRadius: 4.5)
                                          ]),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.orange,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "Retiradas",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Colors.grey[900]),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[200],
                                                blurRadius: 10.0,
                                                spreadRadius: 4.5)
                                          ]),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 16,
                              ),
                              //Container Listview for expenses and incomes
                              Container(
                                child: Text(
                                  "TODAY",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[500]),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 32),
                              ),

                              SizedBox(
                                height: 16,
                              ),

                              ListView.builder(
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 32),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(18))
                                          ),
                                          child: Icon(Icons.date_range,
                                            color: Colors.lightBlue[900],),
                                          padding: EdgeInsets.all(12),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Text("Transações", style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[900]),),
                                              Text("${transactions[index].hash}",
                                                style: TextStyle(fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey[500]),),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text("+\$${transactions[index].value}", style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.lightGreen),),
                                            Text("26 Jan", style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey[500]),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                shrinkWrap: true,
                                itemCount: transactions.length,
                                padding: EdgeInsets.all(0),
                                controller: ScrollController(keepScrollOffset: false),
                              ),
                            ],
                          ),
                          controller: scrollController,
                        ),
                      );
                    }else{
                      return CircularProgressIndicator();
                    }
                  }
              );
            },
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 1,
          )
        ],
      ),
    );
  }

  Widget _dialogTransferToken() {
    TextEditingController adressController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    String addressToText = '';
    String amount = '';
    final sizeConfig = SizeConfig(mediaQueryData: MediaQuery.of(context));

    return Container(
      height: 720,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ResponsivePadding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text('Realizar transferencia',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                    fontSize: 24)),
          ),
          Container(
            padding: EdgeInsets.only(top: 30.0),
            child: new CircleAvatar(
              radius: 65.0,
              backgroundImage: AssetImage("images/icons/ic_pagamentos.png"),
            ),
          ),
          SizedBox(height: 20),
          Container(
              width: 350,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Carteira de envio...',
                  prefixIcon: Icon(Icons.account_balance_wallet),
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                autofocus: false,
                onChanged: (text) {
                  setState(() {
                    addressToText = text;
                  });
                },
              )),
          SizedBox(height: 20),
          Container(
              width: 350,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Valor de envio...',
                  prefixIcon: Icon(Icons.monetization_on),
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                autofocus: false,
                onChanged: (text) {
                  setState(() {
                    amount = text;
                  });
                },
              )),
          ResponsivePadding(
              padding: const EdgeInsets.only(top: 40.0),
              child: ResponsiveContainer(
                  width: 200.0,
                  height: 50.0,
                  child: new FloatingActionButton.extended(
                      heroTag: "btTransferencia",
                      label: Text("Transferir"),
                      backgroundColor: Colors.blueAccent,
                      icon: const Icon(Icons.phone_iphone),
                      onPressed: () {
                        transferFromToken(
                            null,
                            EthereumAddress.fromHex(
                                "0x9Fb2838fC9570D57baE43e41dFE716B294905F04"),
                            null);
                      }))),
        ],
      ),
    );
  }

  Widget _dialogClaimToken() {
    String amountClaim = '';

    return Container(
      height: 720,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ResponsivePadding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text('Ganhos Recebidos',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                    fontSize: 24)),
          ),
          Container(
            padding: EdgeInsets.only(top: 30.0),
            child: new CircleAvatar(
              radius: 65.0,
              backgroundImage: AssetImage("images/icons/ic_Gaming.png"),
            ),
          ),
          ResponsivePadding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text('Total de ganhos: ${dadosLocalizacaoPet.recompensa}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                  fontSize: 24,
                )),
          ),
          SizedBox(height: 20),
          Container(
              width: 350,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Valor de retirada...',
                  prefixIcon: Icon(Icons.attach_money),
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                autofocus: false,
                onChanged: (text) {
                  setState(() {
                    amountClaim = text;
                  });
                },
              )),
          SizedBox(height: 20),
          ResponsivePadding(
              padding: const EdgeInsets.only(top: 40.0),
              child: ResponsiveContainer(
                  width: 200.0,
                  height: 50.0,
                  child: new FloatingActionButton.extended(
                      heroTag: "btClaim",
                      label: Text("Claim"),
                      backgroundColor: Colors.blueAccent,
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        transferToken(double.parse(amountClaim));
                      }))),
        ],
      ),
    );
  }

  Widget _dialogConfigToken() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ResponsivePadding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text('Dados Wallet',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                    fontSize: 24)),
          ),
          Container(
            padding: EdgeInsets.only(top: 30.0),
            child: new CircleAvatar(
              radius: 65.0,
              backgroundImage: AssetImage("images/icons/ic_bank.png"),
            ),
          ),
          ResponsivePadding(
            padding: EdgeInsets.only(top: 50.0, left: 20),
            child: Text('Seu endereço: ${dadosWallet.address}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontSize: 24,
                )),
          ),
          ResponsivePadding(
            padding: EdgeInsets.only(top: 50.0, left: 20),
            child: Text('Chave Privada: ${dadosWallet.privateKey}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontSize: 24,
                )),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
