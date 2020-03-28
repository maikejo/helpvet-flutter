import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class PagamentoService {

 static atualizaVacina(documentId) {
   Firestore.instance
       .collection('vacinas')
       .document(Auth.user.email).collection("lista").document(documentId)
       .updateData(documentId)
       .catchError((e) {
     print(e);
   });
 }
}
