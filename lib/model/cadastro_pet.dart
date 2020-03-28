import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPet {
  final String nome;
  final String tipoPet;
  final String raca;
  final String especie;
  final Timestamp dataNascimento;
  final String urlAvatar;
  final String sexo;
  final String idDoenca;
  final String idAlergia;
  final String idTipoPet;
  final String tipoAlergia;

  CadastroPet({this.nome, this.tipoPet, this.raca,this.especie, this.dataNascimento, this.urlAvatar, this.sexo,
               this.idDoenca,this.idAlergia,this.idTipoPet, this.tipoAlergia});

  Map<String, Object> toJson() {
    return {
      'nome': nome,
      'tipoPet': tipoPet,
      'raca': raca,
      'especie': especie,
      'dataNascimento': dataNascimento,
      'urlAvatar': urlAvatar,
      'sexo': sexo,
      'idDoenca': idDoenca,
      'idAlergia': idAlergia,
      'idTipoPet': idTipoPet,
      'tipoAlergia': tipoAlergia
    };
  }

  factory CadastroPet.fromJson(Map<String, Object> doc) {
    CadastroPet documentacao = new CadastroPet(
        nome: doc['nome'],
        tipoPet: doc['tipoPet'],
        raca: doc['raca'],
        especie: doc['especie'],
        dataNascimento: doc['dataNascimento'],
        urlAvatar: doc['urlAvatar'],
        sexo: doc['sexo'],
        idDoenca: doc['idDoenca'],
        idAlergia: doc['idAlergia'],
        idTipoPet: doc['idTipoPet'],
        tipoAlergia: doc['tipoAlergia']
    );

    return documentacao;
  }

  factory CadastroPet.fromDocument(DocumentSnapshot doc) {
    return CadastroPet.fromJson(doc.data);
  }
}
