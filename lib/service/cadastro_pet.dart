import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/model/cadastro_pet.dart';
import 'auth.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class CadastroPetService {
  static void criarCadastroPet(CadastroPet cadastroPet) async {
    //Firestore.instance.document("cadastro_pet/${Auth.user.email}/lista").setData(cadastroPet.toJson());

    CollectionReference _collectionReference;
    var map = Map<String, dynamic>();
    map = cadastroPet.toJson();

    _collectionReference = Firestore.instance.collection("cadastro_pet")
        .document(Auth.user.email)
        .collection("lista");
    _collectionReference.add(map).whenComplete(() {
      print("Inserido com sucesso");
    });
  }

  static Future<CadastroPet> getCadastroPet(String email, String id) async {
    DocumentSnapshot snapshot = await Firestore.instance.collection('cadastro_pet').document(email).collection("lista").document(id).get();

    if (snapshot.data != null) {
      var nome = snapshot['nome'];
      var tipoPet = snapshot['tipoPet'];
      var especie = snapshot['especie'];
      var raca = snapshot['raca'];
      var dataNascimento = snapshot['dataNascimento'];
      var urlAvatar = snapshot['urlAvatar'];
      var idDoenca = snapshot['idDoenca'];
      var idAlergia = snapshot['idAlergia'];
      var idTipoPet = snapshot['idTipoPet'];
      var tipoAlergia = snapshot['tipoAlergia'];

      CadastroPet cadastroPet = new CadastroPet(
          nome: nome,
          tipoPet: tipoPet,
          raca: raca,
          especie: especie,
          dataNascimento: dataNascimento,
          urlAvatar: urlAvatar,
          idDoenca: idDoenca,
          idAlergia: idAlergia,
          idTipoPet: idTipoPet,
          tipoAlergia: tipoAlergia
      );
      return cadastroPet;
    } else {
      return null;
    }
  }

  static Future<List<DocumentSnapshot>> getTodosCadastroPet(String email) async {
    List<DocumentSnapshot> listaCadastroPet;

    StreamSubscription<QuerySnapshot> _subscription = Firestore.instance.collection("cadastro_pet").document(email).collection("lista").snapshots().listen((datasnapshot) {
          listaCadastroPet = datasnapshot.documents;
        });
  }

}
