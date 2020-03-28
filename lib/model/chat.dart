import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {

  String senderUid;
  String receiverUid;
  String tipo;
  String mensagem;
  FieldValue data;
  String photoUrl;

  Chat({this.senderUid, this.receiverUid, this.tipo, this.mensagem, this.data});
  Chat.withoutMessage({this.senderUid, this.receiverUid, this.tipo, this.data, this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderUid'] = this.senderUid;
    map['receiverUid'] = this.receiverUid;
    map['tipo'] = this.tipo;
    map['mensagem'] = this.mensagem;
    map['data'] = this.data;
    return map;
  }

  Chat fromMap(Map<String, dynamic> map) {
    Chat _chat = Chat();
    _chat.senderUid = map['senderUid'];
    _chat.receiverUid = map['receiverUid'];
    _chat.tipo = map['tipo'];
    _chat.mensagem = map['mensagem'];
    _chat.data = map['data'];
    return _chat;
  }

  

}