import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:userapp/data/entity/users.dart';

class UsersDaoRepository {
  var collectionUsers = FirebaseFirestore.instance.collection("users");
  var firebaseAuth = FirebaseAuth.instance;

  Future<Users?> getCurrentUser() async {
    var user = firebaseAuth.currentUser;

    if (user != null) {
      var query =
          collectionUsers.where("email", isEqualTo: user.email.toString());

      try {
        var querySnapshot = await query.get();

        if (querySnapshot.docs.isNotEmpty) {
          var document = querySnapshot.docs.first;
          var data = document.data();
          var key = document.id;
          var user = Users.fromJson(data, key);

          return user;
        }
      } catch (e) {
        // print("Error xx a: $e");
      }
    }
    return null;
  }

  Future<void> signIn(String email, String password) async {
    try {
      Users? currentUser = await getCurrentUser();
      if (currentUser != null) {
        signOut();
      }
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        print("Giriş Başarılı: ${userCredential.user}");
      }
    } on FirebaseAuthException catch (e) {
      print("Bir sorun oluştu: $e");
    }
  }

  Future<void> signUp(String email, String password) async {
    final UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      registerUser(email, password);
    }
  }

  Future<void> registerUser(
      String email, String password) async {
    var newUser = HashMap<String, dynamic>();

    newUser["userid"] = "";
    newUser["email"] = email;
    newUser["password"] = password;

    DocumentReference newDocumentRef = await collectionUsers.add(newUser);
    String documentId = newDocumentRef.id;
    var updateUser = HashMap<String, dynamic>();
    updateUser["userid"] = documentId;
    await collectionUsers.doc(documentId).update(updateUser);
  }

  Future<void> updateUser(
      String userid, String username, String useraddress) async {
    var updateUser = HashMap<String, dynamic>();
    updateUser["username"] = username;
    // updateUser["address"] = useraddress;

    collectionUsers.doc(userid).update(updateUser);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
