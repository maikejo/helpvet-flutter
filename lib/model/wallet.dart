import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  final String nome;
  final String privateKey;
  final String address;

  Wallet(
      {this.nome, this.privateKey, this.address});

  Map<String, Object> toJson() {
    return {
      'nome': nome,
      'privateKey': privateKey,
      'address': address
    };
  }

  factory Wallet.fromJson(Map<String, Object> doc) {
    Wallet wallet = new Wallet(
        nome: doc['nome'],
        privateKey: doc['privateKey'],
        address: doc['address']);
    return wallet;
  }

  factory Wallet.fromDocument(DocumentSnapshot doc) {
    return Wallet.fromJson(doc.data);
  }
}