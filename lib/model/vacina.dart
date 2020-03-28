import 'package:cloud_firestore/cloud_firestore.dart';

class Vacina {

  FieldValue data;
  String imagemUrl;

  Vacina({this.data, this.imagemUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['data'] = this.data;
    map['imagemUrl'] = this.imagemUrl;
    return map;
  }

  Vacina fromMap(Map<String, dynamic> map) {
    Vacina _chat = Vacina();
    _chat.data = map['data'];
    _chat.imagemUrl = map['imagemUrl'];
    return _chat;
  }



}