import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroExame {
  final DateTime data;
  final String imagemUrl;

  CadastroExame({this.data, this.imagemUrl});

  Map<String, Object> toJson() {
    return {
      'data': data,
      'imagemUrl': imagemUrl,
    };
  }

  factory CadastroExame.fromJson(Map<String, Object> doc) {
    CadastroExame documentacao = new CadastroExame(
        data: doc['data'],
        imagemUrl: doc['imagemUrl']);
    return documentacao;
  }

  factory CadastroExame.fromDocument(DocumentSnapshot doc) {
    return CadastroExame.fromJson(doc.data);
  }
}
