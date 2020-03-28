import 'package:cloud_firestore/cloud_firestore.dart';

import 'evento.dart';

class Eventos {
   DateTime data;
   String cliente;
   List<Evento> evento;

  Eventos({this.data, this.cliente , this.evento});

  Map<String, Object> toJson() {
    return {
      'data': data,
      'cliente': cliente,
      'evento': evento,
    };
  }

  factory Eventos.fromJson(Map<String, Object> doc) {
    Eventos eventos = new Eventos(
        data: doc['data'],
        cliente: doc['cliente'],
        evento: doc['evento']
    );
    return eventos;
  }

   Eventos.fromMap(Map<String, dynamic> data, String id)
       : this(
     data: data['data'],
     cliente: data['cliente'],
     evento: new List<Evento>.from(data['titulo']),
   );

  factory Eventos.fromDocument(DocumentSnapshot doc) {
    return Eventos.fromJson(doc.data);
  }
}
