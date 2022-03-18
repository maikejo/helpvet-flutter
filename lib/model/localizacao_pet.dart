import 'package:cloud_firestore/cloud_firestore.dart';

class LocalizacaoPet {
  final double distancia_percorrida;
  final String recompensa;
  final GeoPoint localizacao_inicial;
  final GeoPoint localizacao_final;

  LocalizacaoPet(
      {this.distancia_percorrida, this.recompensa , this.localizacao_inicial, this.localizacao_final});

  Map<String, Object> toJson() {
    return {
      'distancia_percorrida': distancia_percorrida,
      'recompensa': recompensa,
      'localizacao_inicial': localizacao_inicial,
      'localizacao_final': localizacao_final
    };
  }

  factory LocalizacaoPet.fromJson(Map<String, Object> doc) {
    LocalizacaoPet localizacaoPet = new LocalizacaoPet(
        distancia_percorrida: doc['distancia_percorrida'],
        recompensa: doc['recompensa'],
        localizacao_inicial: doc['localizacao_inicial'],
        localizacao_final: doc['localizacao_final']
    );
    return localizacaoPet;
  }

  factory LocalizacaoPet.fromDocument(DocumentSnapshot doc) {
    return LocalizacaoPet.fromJson(doc.data);
  }
}