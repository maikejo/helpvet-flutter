import 'package:cloud_firestore/cloud_firestore.dart';

class Documentacao {
  final String urlDocIdentificacao;
  final String urlDocSelf;
  final String urlDocResidencia;

  Documentacao(
      {this.urlDocIdentificacao, this.urlDocSelf, this.urlDocResidencia});

  Map<String, Object> toJson() {
    return {
      'urlDocIdentificacao': urlDocIdentificacao,
      'urlDocSelf': urlDocSelf,
      'urlDocResidencia': urlDocResidencia
    };
  }

  factory Documentacao.fromJson(Map<String, Object> doc) {
    Documentacao documentacao = new Documentacao(
        urlDocIdentificacao: doc['urlDocIdentificacao'],
        urlDocSelf: doc['urlDocSelf'],
        urlDocResidencia: doc['urlDocResidencia']);
    return documentacao;
  }

  factory Documentacao.fromDocument(DocumentSnapshot doc) {
    return Documentacao.fromJson(doc.data);
  }
}
