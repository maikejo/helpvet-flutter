import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finey/model/cadastro_consulta.dart';
import 'auth.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class CadastroConsultaService {

  static Stream<QuerySnapshot> getConsultasPet(String email,String documentId) {
    Firestore.instance.collection("consultas").document(email).collection("lista").document(documentId).collection("lista").snapshots().listen((datasnapshot) {
      return datasnapshot.documents;
    });
  }

 static void cadastrarConsulta(CadastroConsulta cadastroConsulta,String idDono, String idPet) async {
    var map = Map<String, dynamic>();
    map = cadastroConsulta.toJson();

    CollectionReference _collectionReference = Firestore.instance.collection("consultas").document(idDono).collection("lista").document(idPet).collection("lista");
    _collectionReference.add(map).whenComplete(() {

    });

  }

 static atualizaConsulta(documentId) {
   Firestore.instance
       .collection('consultas')
       .document(Auth.user.email).collection("lista").document(documentId)
       .updateData(documentId)
       .catchError((e) {
     print(e);
   });
 }

 static deletaConsulta(documentId) {
   Firestore.instance
       .collection('consultas')
       .document(documentId).collection("lista").document(documentId)
       .delete()
       .catchError((e) {
     print(e);
   });
 }

}
