import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/blockchain/blockchain.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/screens/common_widgets/finey_drawer.dart';

class WalletHomeScreen extends StatefulWidget {
  WalletHomeScreen({@required this.privateKey});
  final Future<String> privateKey;

  @override
  _WalletHomeScreenState createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> {

  var simbolo = null;
  final bool _running = true;

  Stream<String> getSimboloToken() async* {
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));

      BlockchainUtils blockchainUtils = BlockchainUtils();
      blockchainUtils.initialSetup();
      simbolo = await blockchainUtils.getSymbol();
      yield "${simbolo}";
    }
  }

  @override
  Widget build(BuildContext context) {
    var layoutBuilder = LayoutBuilder(builder: _buildWithConstraints);

    return Scaffold(
      appBar: new AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Application.router.navigateTo(
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
              icon: Icon(Icons.home),
              title: Text("Inicio")
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              title: Text("Card")
          ),
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

  Widget _buildWithConstraints(BuildContext context, BoxConstraints constraints) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
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
                SizedBox(width: 16,),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                        "images/ic_pet.png", fit: BoxFit.contain,
                        width: 40),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    //Icon(Icons.backspace_rounded, color: Colors.lightBlue[100],),
                    StreamBuilder(
                      stream: getSimboloToken(),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return Text(
                          snapshot.data + " - \$1000.00", style: TextStyle(color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700)
                        );

                      },
                    ),
                  ],
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 72),
                  child: Text("Valor total", style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.blue[100]),),
                ),
                SizedBox(height: 36),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(243, 245, 248, 1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(18))
                            ),
                            child: Icon(Icons.date_range,
                              color: Colors.blue[900], size: 30,),
                            padding: EdgeInsets.all(12),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text("Enviar", style: TextStyle(fontWeight: FontWeight
                              .w700, fontSize: 14, color: Colors.blue[100]),),
                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(243, 245, 248, 1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(18))
                            ),
                            child: Icon(Icons.public, color: Colors.blue[900],
                              size: 30,),
                            padding: EdgeInsets.all(12),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text("Transações", style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.blue[100]),),
                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(243, 245, 248, 1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(18))
                            ),
                            child: Icon(Icons.attach_money,
                              color: Colors.blue[900], size: 30,),
                            padding: EdgeInsets.all(12),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text("Ganhos", style: TextStyle(fontWeight: FontWeight
                              .w700, fontSize: 14, color: Colors.blue[100]),),
                        ],
                      ),
                    ),

                    /*  Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(243, 245, 248, 1),
                                borderRadius: BorderRadius.all(Radius.circular(18))
                            ),
                            child: Icon(Icons.trending_down, color: Colors.blue[900], size: 30,),
                            padding: EdgeInsets.all(12),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text("Topup", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.blue[100]),),
                        ],
                      ),
                    )*/
                  ],
                )

              ],
            ),
          ),


          //draggable sheet
          DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(243, 245, 248, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 24,),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Transações Recentes", style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 24,
                                color: Colors.black),),
                            Text("Ver todos", style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.grey[800]),)
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32),
                      ),
                      SizedBox(height: 24,),

                      //Container for buttons
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text("Todos", style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.grey[900]),),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey[200],
                                        blurRadius: 10.0,
                                        spreadRadius: 4.5)
                                  ]
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            SizedBox(width: 16,),
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
                                  Text("Completa", style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.grey[900]),),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey[200],
                                        blurRadius: 10.0,
                                        spreadRadius: 4.5)
                                  ]
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),

                            SizedBox(width: 16,),
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
                                  Text("Retiradas", style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.grey[900]),),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey[200],
                                        blurRadius: 10.0,
                                        spreadRadius: 4.5)
                                  ]
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 16,),
                      //Container Listview for expenses and incomes
                      Container(
                        child: Text("TODAY", style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[500]),),
                        padding: EdgeInsets.symmetric(horizontal: 32),
                      ),

                      SizedBox(height: 16,),

                      ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 32),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20))
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

                                SizedBox(width: 16,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text("Payment", style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[900]),),
                                      Text("Payment from Saad",
                                        style: TextStyle(fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[500]),),
                                    ],
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text("+\$500.5", style: TextStyle(
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
                        itemCount: 2,
                        padding: EdgeInsets.all(0),
                        controller: ScrollController(keepScrollOffset: false),
                      ),

                      //now expense
                      SizedBox(height: 16,),

                      Container(
                        child: Text("YESTERDAY", style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[500]),),
                        padding: EdgeInsets.symmetric(horizontal: 32),
                      ),

                      SizedBox(height: 16,),

                      ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 32),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20))
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18))
                                  ),
                                  child: Icon(Icons.directions_car,
                                    color: Colors.lightBlue[900],),
                                  padding: EdgeInsets.all(12),
                                ),

                                SizedBox(width: 16,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text("Petrol", style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[900]),),
                                      Text("Payment from Saad",
                                        style: TextStyle(fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[500]),),
                                    ],
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text("-\$500.5", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.orange),),
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
                        itemCount: 2,
                        padding: EdgeInsets.all(0),
                        controller: ScrollController(keepScrollOffset: false),
                      ),

                      //now expense


                    ],
                  ),
                  controller: scrollController,
                ),
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

}
