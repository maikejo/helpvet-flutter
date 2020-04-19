
import 'package:flutter_finey/model/user.dart';

import 'firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getUserDetails() => _firebaseMethods.getUserDetails();

}
