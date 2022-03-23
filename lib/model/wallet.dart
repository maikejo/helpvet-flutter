import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  final String nome;
  final String privateKey;
  final String address;
  final bool contratoAprovado;

  Wallet(
      {this.nome, this.privateKey, this.address , this.contratoAprovado});

  Map<String, Object> toJson() {
    return {
      'nome': nome,
      'privateKey': privateKey,
      'address': address,
      'contratoAprovado': contratoAprovado
    };
  }

  factory Wallet.fromJson(Map<String, Object> doc) {
    Wallet wallet = new Wallet(
        nome: doc['nome'],
        privateKey: doc['privateKey'],
        address: doc['address'],
        contratoAprovado: doc['contratoAprovado']
    );
    return wallet;
  }

  factory Wallet.fromDocument(DocumentSnapshot doc) {
    return Wallet.fromJson(doc.data);
  }
}