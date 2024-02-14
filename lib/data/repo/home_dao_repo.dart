
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeDaoRepository {
  var collectionUsers = FirebaseFirestore.instance.collection("users");
  var firebaseAuth = FirebaseAuth.instance;

  Future<void> updateUser(
      String userid, List hobbies ) async {
    var updateUser = HashMap<String, dynamic>();
    updateUser["hobbies"] = hobbies;

    collectionUsers.doc(userid).update(updateUser);
  }

  
}
