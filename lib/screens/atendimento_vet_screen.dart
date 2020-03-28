import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/model/cadastro_consulta.dart';
import 'package:flutter_finey/screens/agenda_screen.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/service/cadastro_consulta_service.dart';
import 'package:flutter_finey/util/dialog.dart';
import 'dart:math' as math;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AtendimentoPetScreen extends StatefulWidget {
  AtendimentoPetScreen({@required this.idDono, this.idPet,this.eventoAgenda});

  final String idPet;
  final String idDono;
  final Map eventoAgenda;

  @override
  _AtendimentoPetScreenState createState() => new _AtendimentoPetScreenState();
}

class _AtendimentoPetScreenState extends State<AtendimentoPetScreen>
    with TickerProviderStateMixin {

  AnimationController controller;
  File _fileController;
  String _urlFotoVacinaController;
  DateTime dataAtual = new DateTime.now();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(hours: 1),
    );
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 80, maxHeight:  700 , maxWidth: 700);
    setState(() {
      _fileController = image;
    });

    try{
      if(_fileController != null) {
        Dialogs.showLoadingDialog(context, _keyLoader);
        uploadLaudo(context);
      }
    }catch(e){
      print('erro');
    }

  }

  Future uploadLaudo(BuildContext context) async {
    String fileName = "laudo_"+ new DateFormat("dd-MM-yyyy").format(dataAtual);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(widget.idDono + "/documentos/laudo/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_fileController);
    _urlFotoVacinaController = await (await uploadTask.onComplete).ref.getDownloadURL();

    CadastroConsulta cadastroConsulta = new CadastroConsulta(data: dataAtual,imagemUrl: _urlFotoVacinaController,status: "CON",tempoAtendimento: timerString,idPet: widget.idPet);
    CadastroConsultaService.cadastrarConsulta(cadastroConsulta,widget.idDono,widget.idPet);

    //ATUALIZA STATUS AGENDA
    var evento = [ { "agenda" : widget.eventoAgenda['agenda'].toString() , "idAgenda":  widget.eventoAgenda['idAgenda'].toString() , "idDono" :  widget.eventoAgenda['idDono'].toString() , "idPet" : widget.eventoAgenda['idPet'].toString() , "status": 'CON' , "data" : widget.eventoAgenda['data'] } ];
    Firestore.instance.collection('agenda').document(widget.idDono).collection("lista").document(widget.eventoAgenda['idAgenda']).updateData({ "eventos" : [{ "data" : widget.eventoAgenda['data'] , "evento": evento }] });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgendaScreen(idVet: Auth.user.email, idPet: widget.idPet,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Atendimento'),
      ),

      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Container(
                    color: Colors.teal,
                    height:
                    controller.value * MediaQuery.of(context).size.height,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                        animation: controller,
                                        backgroundColor: Colors.white,
                                        color: themeData.indicatorColor,
                                      )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Tempo do atendimento",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        timerString,
                                        style: TextStyle(
                                            fontSize: 112.0,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return FloatingActionButton.extended(
                                onPressed: () {
                                  if (controller.isAnimating) {
                                    controller.stop();
                                    getImageFromCamera();

                                  } else {
                                    controller.reverse(
                                        from: controller.value == 0.0
                                            ? 1.0
                                            : controller.value);
                                  }
                                },
                                icon: Icon(controller.isAnimating
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                label: Text(
                                    controller.isAnimating ? "Terminar" : "Iniciar"));
                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
