import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Users_Repositories
{
  var refUser = FirebaseAuth.instance;
  final refFirestore = FirebaseFirestore.instance;
  final refStorage = FirebaseStorage.instance;


  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }

  Future<void> usersSignUp(String _email, _password, _username, _name, _phone, _photo) async {
    var userResult = await refUser.createUserWithEmailAndPassword(email: _email, password: _password);
    try
    {
      var userId = userResult.user!.uid;
      await refFirestore.collection("users").doc(userId).set({
        "email" : _email,
        "name" : _name,
        "username" : _username,
        "phone" : _phone,
        "photo" : _photo
      });
    }
    catch (e)
    {
      print("Catch" + e.toString());
    }
  }

  Future<void> resetPassword(String _email) async {
    refUser.sendPasswordResetEmail(email: _email);
  }

  Future<Map<String, String>> getDataFromDatabase() async {
    final user = FirebaseAuth.instance.currentUser!;
    Map<String, String> userData = {};

    await FirebaseFirestore.instance.collection("users").doc(user.uid).get().then((snapshot) async {
      try {
        if (snapshot.exists) {
          userData["email"] = snapshot.data()!["email"];
          userData["name"] = snapshot.data()!["name"];
          userData["username"] = snapshot.data()!["username"];
          userData["phone"] = snapshot.data()!["phone"];
          userData["photo"] = snapshot.data()!["photo"];
        }
      } catch (e) {
        print(e.toString());
      }
    });

    return userData;
  }

}