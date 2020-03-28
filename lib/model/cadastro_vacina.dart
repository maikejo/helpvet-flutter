import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroVacina {
  final DateTime data;
  final String imagemUrl;

  CadastroVacina({this.data, this.imagemUrl});

  Map<String, Object> toJson() {
    return {
      'data': data,
      'imagemUrl': imagemUrl,
    };
  }

  factory CadastroVacina.fromJson(Map<String, Object> doc) {
    CadastroVacina documentacao = new CadastroVacina(
        data: doc['data'],
        imagemUrl: doc['imagemUrl']);
    return documentacao;
  }

  factory CadastroVacina.fromDocument(DocumentSnapshot doc) {
    return CadastroVacina.fromJson(doc.data);
  }
}
