import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  final String nome;
  final String privateKey;
  final String address;
  final bool contrato_aprovado;

  Wallet(
      {this.nome, this.privateKey, this.address , this.contrato_aprovado});

  Map<String, Object> toJson() {
    return {
      'nome': nome,
      'privateKey': privateKey,
      'address': address,
      'contrato_aprovado': contrato_aprovado
    };
  }

  factory Wallet.fromJson(Map<String, Object> doc) {
    Wallet wallet = new Wallet(
        nome: doc['nome'],
        privateKey: doc['privateKey'],
        address: doc['address'],
        contrato_aprovado: doc['contrato_aprovado']
    );
    return wallet;
  }

  factory Wallet.fromDocument(DocumentSnapshot doc) {
    return Wallet.fromJson(doc.data);
  }
}