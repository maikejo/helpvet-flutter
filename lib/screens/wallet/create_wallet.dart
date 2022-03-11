
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finey/blockchain/wallet_address.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/model/wallet.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_image.dart';
import 'package:flutter_finey/screens/common_widgets/responsive_padding.dart';
import 'package:flutter_finey/screens/wallet/wallet_home_screen.dart';
import 'package:flutter_finey/service/auth.dart';

class CreateWalletScreen extends StatefulWidget {
  CreateWalletScreen({@required this.isWalletCreated});
  final String isWalletCreated;

  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  WalletAddress walletAddressService = WalletAddress();
  var mnemonic = null;
  var privateKey = null;
  var publicKey = null;
  Future<String> privateKeyRecuperada = null;


  _createWallet() async{
    mnemonic = walletAddressService.generateMnemonic();
    privateKey = await walletAddressService.getPrivateKey(mnemonic);
    publicKey = await walletAddressService.getPublicKey(privateKey);
    addWallet(privateKey, publicKey);
  }

  static void addWallet(var privateKey, var publicKey) async {
    Wallet wallet = new Wallet(nome: 'Minha Carteira', privateKey: privateKey.toString(), address: publicKey.toString());
    Firestore.instance.document("wallet/${Auth.user.email}").setData(wallet.toJson());
    Firestore.instance.collection('usuarios').document(Auth.user.email).updateData({'isWallet': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Application.router.navigateTo(
                context, RouteConstants.ROUTE_HOME,
                transition: TransitionType.fadeIn),
          ),
        backgroundColor: Color.fromRGBO(38, 81, 158, 1),
        title: Text('Criar Carteira'),
      ),

      body: Stack(
        children: <Widget>[
          //Container for top data
          Container(
            margin: EdgeInsets.symmetric(horizontal: 45, vertical: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Container(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text("Carteira", style: TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.w700),),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 25),
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text("Crie ou importe sua carteira para começar a realizar transações das suas moedas digitais.", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 25),
                  child: GestureDetector(
                    onTap: ((){
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return _dialogCreateWallet();
                          }
                      );
                    }),
                    child: Card(
                        elevation: 20,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: 600,
                          height: 160,
                          child: Center(child: Text('Criar Carteira', style: TextStyle(fontSize: 25))),
                        )),
                  ),
                ),

                Container(
                 child: GestureDetector(
                   onTap: ((){
                     showModalBottomSheet(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(35.0),
                         ),
                         context: context,
                         builder: (BuildContext context) {
                           return _dialogImportWallet();
                         }
                     );
                   }),
                   child: Card(
                          elevation: 20,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SizedBox(
                            width: 600,
                            height: 160,
                            child: Center(child: Text('Importar Carteira', style: TextStyle(fontSize: 25))),
                          )

                      ),
                  ),
                    ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogCreateWallet() {

    _createWallet();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Container(
            alignment: AlignmentDirectional.bottomStart,
            child: Text("Informações de sua Carteira", style: TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.w700),),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 25),
            alignment: AlignmentDirectional.bottomStart,
            child: Text("Palavra chave: ${mnemonic}", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            alignment: AlignmentDirectional.bottomStart,
            child: Text("Sua Carteira: ${publicKey}", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            alignment: AlignmentDirectional.bottomStart,
            child: Text("Chave Privada: ${privateKey}", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),),
          ),

          ResponsivePadding(
            padding: const EdgeInsets.only(top: 40.0),
            child: FloatingActionButton.extended(
                heroTag: "btAcessarCarteira",
                label: Text("Acessar Carteira"),
                backgroundColor: Colors.blue,
                icon: const Icon(Icons.import_export),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WalletHomeScreen(
                              privateKey: privateKeyRecuperada
                          ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _dialogImportWallet() {
    TextEditingController nameController = TextEditingController();
    String privateKeyRecuperadaText = '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 45, vertical: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Container(
            margin: EdgeInsets.symmetric(vertical: 25),
            alignment: AlignmentDirectional.bottomStart,
            child: Text("Informe sua frase", style: TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.w700),),
          ),

          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Inserir palavra chave',
            ),
            onChanged: (text) {
              setState(() {
                privateKeyRecuperadaText = text;
                privateKeyRecuperada = walletAddressService.getPrivateKey(privateKeyRecuperadaText);
              });
            },
          ),

          ResponsivePadding(
            padding: const EdgeInsets.only(top: 60.0),
            child: FloatingActionButton.extended(
                heroTag: "btImportar",
                label: Text("Importar Carteira"),
                backgroundColor: Colors.blue,
                icon: const Icon(Icons.import_export),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WalletHomeScreen(
                              privateKey: privateKeyRecuperada
                             ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }



}
