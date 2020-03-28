import 'dart:async';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/animation/fade_in_animation.dart';
import 'package:flutter_finey/model/cadastro_pet.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/service/cadastro_pet.dart';
import 'package:flutter_finey/styles/common_styles.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'atendimento_vet_screen.dart';
import 'common_widgets/responsive_padding.dart';
import 'home_screen_pet.dart';

class AgendaScreen extends StatefulWidget {
  AgendaScreen({Key key, this.title , this.idPet, this.idVet}) : super(key: key);
  final String idPet;
  final String title;
  final String idVet;

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> with TickerProviderStateMixin {

  Map<DateTime, List> _events;
  List _selectedEvents = new List();
  List _selectedEventsDono = new List();
  AnimationController _animationController;
  CalendarController _calendarController;
  final db = Firestore.instance;
  Stream slides;
  List<DocumentSnapshot> listaAgenda;
  StreamSubscription<QuerySnapshot> _stream;
  DateTime data;

  List<String> _months = ["Maike Silva"].toList();
  String _selectedMonth;

  DateTime dataCriacao;
  TimeOfDay horaCriacao;
  String tituloCriacao;

  FirebaseUser firebaseUser;
  CadastroPet cadastroPet;
  User user;
  String tipoUser;
  String idDono;
  String idPet;

  TextEditingController _dataAgendamentoController = new TextEditingController(text: "");
  TextEditingController _horaAgendamentoController = new TextEditingController(text: "");
  TextEditingController _tituloController = new TextEditingController();
  DateTime dataAgendamento = null;

// Example holidays
  final Map<DateTime, List> _holidays = {
    DateTime(2019, 1, 1): ['New Year\'s Day'],
    DateTime(2019, 1, 6): ['Epiphany'],
    DateTime(2019, 2, 14): ['Valentine\'s Day'],
    DateTime(2019, 4, 21): ['Easter Sunday'],
    DateTime(2019, 4, 22): ['Easter Monday'],
  };

  void _recuperaUser() async {
    FirebaseUser _firebaseUser = await Auth.getCurrentFirebaseUser();
    User _user = await Auth.getDadosUser(_firebaseUser.email);

    setState(() {
      firebaseUser = _firebaseUser;
      user = _user;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedMonth = _months.first;
    _recuperaUser();
    listarAgenda();

    _events = {};
    _selectedEvents = [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  Future<void> _selectDataAgendamento(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2100),
    );
    if (d != null)
      setState(() {
        _dataAgendamentoController.text = new DateFormat("d/MM/y").format(d);
        dataAgendamento = d;
      });
  }

  Future<void> _selectHoraAgendamento(BuildContext context) async {
    final TimeOfDay d = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (d != null)
      setState(() {
        _horaAgendamentoController.text =  d.hour.toString() + ":" + d.minute.toString();
        horaCriacao = d;
      });
  }

  void listarAgenda() {

      List<DocumentSnapshot> listaUser;
      List<DocumentSnapshot> listaAgenda;

      _stream = Firestore.instance.collection("usuarios").where("email", isEqualTo: Auth.user.email).snapshots().listen((datasnapshot) {
        setState(() {

          listaUser = datasnapshot.documents;

          for (var lista in listaUser) {
            tipoUser = lista.data["tipo"];
          }

          if (tipoUser == "CLI") {
            _stream = Firestore.instance.collection("agenda").document(Auth.user.email).collection("lista").where("idPet", isEqualTo: widget.idPet).snapshots().listen((datasnapshot) {

              setState(() {
                listaAgenda = datasnapshot.documents;

                for (var lista in listaAgenda) {
                  var eventos = lista.data["eventos"];

                  for (var listaEvento in eventos) {
                    var evento = listaEvento["evento"];
                    Timestamp data = listaEvento["data"];

                    _events.addAll({data.toDate(): evento});
                    _selectedEvents.addAll(_events[DateTime.now()] ?? []);
                  }
                }
              });
            });
          } else {

            List<DocumentSnapshot> listaUser;
            StreamSubscription<QuerySnapshot> _streamUsuarios;

            _streamUsuarios = Firestore.instance.collection("usuarios").snapshots().listen((datasnapshot) {

              setState(() {
                listaUser = datasnapshot.documents;

                for (var lista in listaUser) {
                  var email = lista.data["email"];

                  Stream<QuerySnapshot> stream = Firestore.instance.collection('agenda').document(email).collection("lista").snapshots();
                  stream.listen((onData){
                    onData.documents.forEach((doc) {

                      listaAgenda = onData.documents;

                      for(var lista in listaAgenda){
                        var pets = lista.data["eventos"];
                        idDono = lista.data["idDono"];
                        idPet = lista.data["idPet"];

                        for(var listaEventos in pets){
                          var evento = listaEventos["evento"];
                          Timestamp data = listaEventos["data"];

                          _events.addAll({data.toDate() : evento });
                          _selectedEvents.addAll(_events[DateTime.now()] ?? []);
                        }
                      }

                    });
                  });

                }
              });
            });

          }
        });
      });

  }


  void gravarAgendamento(DateTime dataCriacao, TimeOfDay horaCriacao,String titulo) async{

    var cliente = 'maikejo@gmail.com';
    var documentId;
    var updData;
    List updEvento;
    var updlistaEvento;

   /* for(var lista in listaAgenda){
      var eventos = lista.data["eventos"];
      documentId = lista.documentID;

      for(var listaEvento in eventos){
        updData = listaEvento["data"];
        updlistaEvento = listaEvento["evento"];
        print(updlistaEvento);
      }
    }*/

    //ATUALIZA DADOS EVENTO PARA O MESMO DIA

    /*if(dataCriacao == updData){

    updlistaEvento.add(descricao);

    var updDocData = {
        "eventos":[{ "data" : dataCriacao , "evento": updlistaEvento }],
      };

      Firestore.instance.collection('agenda').document(Auth.user.email).collection('lista').document(documentId).updateData(updDocData);

    }else{

      //ADICIONA NOVO CASO A DATA SEJA DIFERENTE
      var descMontada = "Maike Silva" + " - " + descricao + " ás " + "12:00";
      var evento = [descMontada];
      var docData = {
        "eventos":[{ "data" : dataCriacao , "evento": evento }],
      };

      Firestore.instance.collection('agenda').document(Auth.user.email).collection('lista').add(docData);

    }*/

    //ADICIONA NOVO CASO A DATA SEJA DIFERENTE
    var hora = horaCriacao.hour.toString();
    var minutos;

    if(horaCriacao.minute == 0){
       minutos = "00";
    }else{
       minutos = horaCriacao.minute.toString();
    }

    var horaAgendamento = hora + ":" + minutos;
    var descMontada = titulo + " ás " + horaAgendamento;
    var evento = [ { "agenda" : descMontada , "idDono" : Auth.user.email , "idPet" : widget.idPet , "status": 'INI' , "data": dataAgendamento } ];

    DocumentReference docRef = await Firestore.instance.collection('agenda').document(Auth.user.email).collection("lista")
        .add({"idPet" : widget.idPet, "idDono": Auth.user.email, "eventos" : [{ "data" : dataAgendamento , "evento": evento }] });

    //INSERE ID NO EVENTO E ATUALIZA INFORMACOES
    var eventoUpdate = [ { "agenda" : descMontada , "idDono" : Auth.user.email , "idPet" : widget.idPet , "status": 'INI', "idAgenda": docRef.documentID , "data": dataAgendamento } ];
    Firestore.instance.collection('agenda').document(Auth.user.email).collection("lista").document(docRef.documentID)
        .updateData({"idPet" : widget.idPet, "idDono": Auth.user.email, "eventos" : [{ "data" : dataAgendamento , "evento": eventoUpdate }] });

    Navigator.pop(context);

    _showDialogAgenda();
 }

  void _showDialogConsultaRealizada() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Atendimento"),
          content: new Text("Consulta já foi realizada!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.pop(context);
                ;
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogAgenda() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Sucesso"),
          content: new Text("Agendado com sucesso!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context,rootNavigator: true).pop();
                ;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {

    void onMonthChange(String item){
      setState(() {
        _selectedMonth = item;
      });
    }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: Text('Agendamentos - Consultas'),
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:(() {
            Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => HomePetScreen(idPet: widget.idPet,idAcessoVetDono: widget.idVet),
            ),
            );
          }),
          ),
        ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          heroTag: "btFotoVacina",
          backgroundColor: Colors.pinkAccent,
          child: const Icon(Icons.add),

        onPressed: () {

            _dataAgendamentoController = new TextEditingController(text: "");
            _horaAgendamentoController = new TextEditingController(text: "");
            tituloCriacao = null;

          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              context: context,
              builder: (context) {

              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                    return Container(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          ResponsivePadding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text('Criar Agendamento' ,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                    fontSize: 24
                                )),
                          ),

                          Container(
                            width: 300.0,
                            child:  ResponsivePadding(padding: const EdgeInsets.only(top:40.0),
                              child: Row(
                                children: <Widget>[

                                  IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    color: Colors.pink,
                                    tooltip: 'Data agendamento',
                                    onPressed: () {
                                      _selectDataAgendamento(context);
                                    },
                                  ),

                                  Flexible(
                                    child: new TextField(
                                        enabled: false,
                                        controller: _dataAgendamentoController,
                                        decoration: InputDecoration(
                                            fillColor: Colors.pinkAccent,
                                            labelText: 'Data agendamento',
                                            labelStyle: CommonStyles(context: context).getLabelText())
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),

                          Container(
                            width: 300.0,
                            child:  ResponsivePadding(padding: const EdgeInsets.only(top:20.0),
                              child: Row(
                                children: <Widget>[

                                  IconButton(
                                    icon: Icon(Icons.access_time),
                                    color: Colors.pink,
                                    tooltip: 'Horário agendamento',
                                    onPressed: () {
                                      _selectHoraAgendamento(context);
                                    },
                                  ),

                                  Flexible(
                                    child: new TextField(
                                        enabled: false,
                                        controller: _horaAgendamentoController,
                                        decoration: InputDecoration(
                                            fillColor: Colors.pinkAccent,
                                            labelText: 'Horário agendamento',
                                            labelStyle: CommonStyles(context: context).getLabelText())
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Container(
                            width: 340.0,
                            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                            child: StreamBuilder(
                                stream: Firestore.instance.collection('tipoConsulta').orderBy("nome").snapshots(),
                                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                  if (snapshot.data != null) {

                                    return ListTile(
                                      leading: const Icon(
                                        Icons.add_to_queue,
                                        color: Colors.pink,
                                      ),
                                      title: DropdownButton(
                                        hint: Text('Qual tipo de consulta ?'),
                                        onChanged: (titulo) {
                                          setState(() {
                                            tituloCriacao = titulo;
                                          });
                                        },
                                        value: tituloCriacao,
                                        isExpanded: true,
                                        items: snapshot.data.documents.map((DocumentSnapshot document) {

                                          return DropdownMenuItem(
                                            value: document.data['nome'].toString(),
                                            child: new Text(document.data['nome'].toString()),
                                          );
                                        }).toList(),
                                      ),
                                    );

                                  }else{
                                    return SizedBox();
                                  }
                                }),
                          ),

                          ResponsivePadding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: FloatingActionButton.extended(
                                heroTag: "btAgendar",
                                label: Text("Agendar"),
                                backgroundColor: Colors.pink,
                                icon: const Icon(Icons.access_alarm),
                                onPressed: () {
                                  gravarAgendamento(dataCriacao,horaCriacao,tituloCriacao);
                                }),
                          ),
                        ],
                      ),
                    );
              });
              }
          );
        },
      ),

        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendar(),
            // _buildTableCalendarWithBuilders(),
            const SizedBox(height: 8.0),
            //_buildButtons(),
            const SizedBox(height: 8.0),
            Expanded(child: _buildEventList()),
          ],
        ),
      );
  }

  Widget _buildTableCalendar() {
    return FadeIn(1,TableCalendar(
      //locale: 'pl_PL',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mês',
        CalendarFormat.week: 'Semana',
      },
      calendarStyle: CalendarStyle(
        selectedColor: Colors.pinkAccent[400],
        todayColor: Colors.pinkAccent[200],
        markersColor: Colors.green,
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),

      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    ));
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {

    return ListView(
      children: _selectedEvents.map((event) => Card(

        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            leading: tipoUser == 'VET' ? Badge(
              position: BadgePosition.topLeft(),
              badgeColor: Colors.green,
              badgeContent: Container(
                width: 15,
               height: 15,

               child: FutureBuilder(
                   future: Auth.getDadosUser(event['idDono'].toString()),
                   builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

                     if (snapshot.data != null) {
                       return CircleAvatar(
                         backgroundImage: snapshot.data.imagemUrl == null
                             ? AssetImage('images/ic_blank_image.png')
                             : CachedNetworkImageProvider(snapshot.data.imagemUrl),
                         radius: 20.0,
                       );
                     }

                   }),
              ),

              child:  Container(
               child: FutureBuilder(
                    future: CadastroPetService.getCadastroPet(event['idDono'].toString(),event['idPet'].toString()),
                    builder: (BuildContext context, AsyncSnapshot<CadastroPet> snapshot) {

                      if (snapshot.data != null) {
                       return CircleAvatar(
                          backgroundImage: snapshot.data.urlAvatar == null
                              ? AssetImage('images/ic_blank_image.png')
                              : CachedNetworkImageProvider(snapshot.data.urlAvatar),
                          radius: 20.0,
                        );
                      }

                    }),
              ),
            ) : Badge(
              position: BadgePosition.topLeft(),
              badgeColor: Colors.green,
              badgeContent: Container(
                width: 15,
                height: 15,

                child: FutureBuilder(
                    future: Auth.getDadosUser(Auth.user.email),
                    builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

                      if (snapshot.data != null) {
                        return CircleAvatar(
                          backgroundImage: snapshot.data.imagemUrl == null
                              ? AssetImage('images/ic_blank_image.png')
                              : CachedNetworkImageProvider(snapshot.data.imagemUrl),
                          radius: 20.0,
                        );
                      }

                    }),
              ),

              child:  Container(
                child: FutureBuilder(
                    future: CadastroPetService.getCadastroPet(Auth.user.email,widget.idPet),
                    builder: (BuildContext context, AsyncSnapshot<CadastroPet> snapshot) {

                      if (snapshot.data != null) {
                        return CircleAvatar(
                          backgroundImage: snapshot.data.urlAvatar == null
                              ? AssetImage('images/ic_blank_image.png')
                              : CachedNetworkImageProvider(snapshot.data.urlAvatar),
                          radius: 20.0,
                        );
                      }

                    }),
              ),
            ),

            title: tipoUser == 'VET' ? new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(event['idDono'].toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),

                event['status'].toString() == 'INI' ? IconButton(padding: const EdgeInsets.only(top: 15.0),iconSize: 40,
                  icon: Icon(
                    Icons.play_circle_filled,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AtendimentoPetScreen(idDono: event['idDono'].toString(), idPet: event['idPet'].toString(), eventoAgenda: event),
                      ),
                    );
                  },
                ) : IconButton(padding: const EdgeInsets.only(top: 15.0),iconSize: 40,
                  icon: Icon(
                    Icons.assignment,
                    color: Colors.green,
                  ),
                ),

              ],
            ): new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Auth.user.email,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),

            subtitle: tipoUser == 'VET' ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(event['agenda'].toString()),
                event['status'] == 'INI' ? Text('Iniciar') : Text('Concluído'),
              ],
            ): Text(event['agenda'].toString()),

            onTap: ((){
              event['status'] == 'CON' && tipoUser == 'VET' ? _showDialogConsultaRealizada() : print('click');
            }),
          ),
        ),
      )).toList(),
    );
  }
}