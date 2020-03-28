import 'package:cloud_firestore/cloud_firestore.dart';

class Evento {

  String titulo;

  Evento({this.titulo});

  Map<String, Object> toJson() {
    return {
      'titulo': titulo,
    };
  }

  factory Evento.fromJson(Map<String, Object> doc) {
    Evento evento = new Evento(
        titulo: doc['titulo']
    );
    return evento;
  }

  factory Evento.fromDocument(DocumentSnapshot doc) {
    return Evento.fromJson(doc.data);
  }
}
