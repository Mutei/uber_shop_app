import 'dart:convert'; // Import for utf8 encoding
import 'package:crypto/crypto.dart'; // Import for hashing

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uber_shop_app/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert the password to bytes
    var digest = sha256.convert(bytes); // Perform SHA-256 hash
    return digest.toString(); // Convert hash to string
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty || userName.isNotEmpty) {
        // Hash the password before storing
        String hashedPassword = _hashPassword(password);

        // Register user with Firebase Auth
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String userId = cred.user!.uid;
        print("User ID in (auth.methods dart file) ...> $userId");

        // Add user to our database
        model.User user = model.User(
          email: email,
          uid: userId,
          username: userName,
          password: hashedPassword,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = 'The email is badly formatted.';
      } else if (e.code == 'weak-password') {
        res = 'Password should be at least 6 characters.';
      }
    } catch (e) {
      res = e.toString();
    }
    return 'The result in (auth_methods.dart) is $res';
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred!';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        res = 'You entered a wrong password';
      } else if (e.code == 'user-not-found') {
        res = 'User is not found';
      } else {
        res = 'Log-in Successful';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
