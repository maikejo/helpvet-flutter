import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroConsulta {
  final DateTime data;
  final String imagemUrl;
  final String status;
  final String tempoAtendimento;
  final String idPet;

  CadastroConsulta({this.data, this.imagemUrl,this.status,this.tempoAtendimento,this.idPet});

  Map<String, Object> toJson() {
    return {
      'data': data,
      'imagemUrl': imagemUrl,
      'status': status,
      'tempoAtendimento': tempoAtendimento,
      'idPet': idPet
    };
  }

  factory CadastroConsulta.fromJson(Map<String, Object> doc) {
    CadastroConsulta documentacao = new CadastroConsulta(
        data: doc['data'],
        imagemUrl: doc['imagemUrl'],
        status: doc['status'],
        tempoAtendimento: doc['tempoAtendimento'],
        idPet: doc['idPet']
    );
    return documentacao;
  }

  factory CadastroConsulta.fromDocument(DocumentSnapshot doc) {
    return CadastroConsulta.fromJson(doc.data);
  }
}
