import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cielo/flutter_cielo.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/model/cartao_credito.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/util/custom_alert_dialog.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'cartao_credito_button.dart';

class CartaoCreditoForm extends StatefulWidget {
  const CartaoCreditoForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    @required this.onCreditCardModelChange,
    @required this.plano,
    @required this.valor,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CartaoCredito) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;
  final int plano;
  final String valor;

  @override
  _CartaoCreditoFormState createState() => _CartaoCreditoFormState();
}

class _CartaoCreditoFormState extends State<CartaoCreditoForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  Color themeColor;
  int plano;

  void Function(CartaoCredito) onCreditCardModelChange;
  CartaoCredito creditCardModel;

  final MaskedTextController _cardNumberController =
  MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
  MaskedTextController(mask: '00/0000');
  final TextEditingController _cardHolderNameController =
  TextEditingController();
  final TextEditingController _cvvCodeController =
  MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  void adicionarCompra(String valor,int plano,String idPagamento){
    Firestore.instance.collection('pagamentos').document(Auth.user.email).collection("lista")
        .add({"data": Timestamp.now(),"valor":valor ,"plano": plano, "idPagamento": idPagamento});

    Navigator.pop(context);
  }

  void _showDialogSucesso() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Sucesso"),
          content: new Text("Pagamento realizado com sucesso!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Application.router.navigateTo(
                    context, RouteConstants.ROUTE_PLANOS,
                    clearStack: true,
                    replace: true,
                    transition: TransitionType.fadeIn);
                ;
              },
            ),
          ],
        );
      },
    );
  }

  //inicia objeto da api
  final CieloEcommerce cielo = CieloEcommerce(
      environment: Environment.SANDBOX, // ambiente de desenvolvimento
      merchant: Merchant(
        merchantId: "3f075fcb-411b-4b9e-b7fc-677d04f8c303",
        merchantKey: "DXCINPEBTOVDEMQBFFADXXILLAXCFGZFHMNMYMUF",
      ));


  _dismissDialog() {
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  }

  void _showErrorAlert({String title, String content, VoidCallback onPressed}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
            content: content, title: title, onPressed: _dismissDialog);
      },
    );
  }

  void realizarCompra() async{
    //Objeto de venda
    Sale sale = Sale(
        merchantOrderId: "123", // id único de sua venda
        customer: Customer( //objeto de dados do usuário
            name: "Comprador crédito simples"
        ),
        payment: Payment(    // objeto para de pagamento
            type: TypePayment.creditCard, //tipo de pagamento
            amount: 1, // valor da compra em centavos
            installments: 1, // número de parcelas
            softDescriptor: "HelpVet", //descrição que aparecerá no extrato do usuário. Apenas 15 caracteres
            creditCard: CreditCard( //objeto de Cartão de crédito
              cardNumber: _cardNumberController.text, //número do cartão
              holder: _cardHolderNameController.text, //nome do usuário impresso no cartão
              expirationDate: _expiryDateController.text, // data de expiração
              securityCode: _cvvCodeController.text, // código de segurança
              brand: "Visa", // bandeira
            )
        )
    );

    try{

      //DIALOGO LOADING
      Dialogs.showLoadingDialog(context, _keyLoader);
        var response = await cielo.createSale(sale);

        Auth.atualizaPlano(30, DateTime.now());

        print(response.payment.paymentId);
        adicionarCompra(widget.valor,widget.plano,response.payment.paymentId);

        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();

      _showDialogSucesso();

    }on CieloException catch(e){

      print(e.message);
      print(e.errors[0].message);
      print(e.errors[0].code);

      _showErrorAlert(
          title: "Falha no Pagamento.", content: e.errors[0].message);
    }
  }


  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CartaoCredito(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: TextFormField(
                controller: _cardNumberController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Número do cartão',
                  hintText: 'xxxx xxxx xxxx xxxx',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _expiryDateController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Data Expiração',
                    hintText: 'MM/YYYY'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextField(
                focusNode: cvvFocusNode,
                controller: _cvvCodeController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  hintText: 'XXXX',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (String text) {
                  setState(() {
                    cvvCode = text;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 50, right: 16),
              child:  CartaoCreditoButton(realizarCompra),
            ),
          ],
        ),
      ),
    );
  }
}
