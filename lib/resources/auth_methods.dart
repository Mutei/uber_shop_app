import 'dart:convert'; // Import for utf8 encoding
import 'dart:typed_data';
import 'package:crypto/crypto.dart'; // Import for hashing

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_shop_app/models/user.dart' as model;
import 'package:uber_shop_app/resources/storage_methods.dart';
import 'package:uber_shop_app/widgets/snackBar.dart';

import '../constants/colors.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert the password to bytes
    var digest = sha256.convert(bytes); // Perform SHA-256 hash
    return digest.toString(); // Convert hash to string
  }

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required Uint8List profilePicture,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && userName.isNotEmpty) {
        // Hash the password before storing
        String hashedPassword = _hashPassword(password);

        // Register user with Firebase Auth
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String userId = cred.user!.uid;
        print("User ID in (auth.methods dart file) ...> $userId");
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', profilePicture, false);

        // Add user to our database
        model.User user = model.User(
          email: email,
          uid: userId,
          username: userName,
          password: hashedPassword,
          profilePicture: photoUrl,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = 'success';
        showSnackbar("Sign Up Successful", "You have successfully signed up",
            kPrimaryColor!, Colors.white);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showSnackbar("Invalid Email", "Please enter a valid email",
            kPrimaryColor!, Colors.white);
      } else if (e.code == 'weak-password') {
        showSnackbar(
            "Weak Password",
            "Password should be at least 6 characters!",
            kPrimaryColor!,
            Colors.white);
      } else if (e.code == 'email-already-in-use') {
        showSnackbar(
            "Email Already in Use",
            "This email is already registered. Please use a different email.",
            kPrimaryColor!,
            Colors.white);
      }
    } catch (e) {
      res = e.toString();
      showSnackbar("Error", "An error occurred during sign up", kPrimaryColor!,
          Colors.white);
    }
    return 'The result in (auth_methods.dart) is $res';
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred!';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
        showSnackbar("Login Successful", "You are now logged in successfully",
            kPrimaryColor!, Colors.white);
      } else if (email.isEmpty) {
        showSnackbar("Email is Empty", "Please enter your email",
            kPrimaryColor!, Colors.white);
      } else if (password.isEmpty) {
        showSnackbar("Password is Empty", "Please enter your password",
            kPrimaryColor!, Colors.white);
      } else {
        showSnackbar("Empty Fields", "Please enter your email and password",
            kPrimaryColor!, Colors.white);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        showSnackbar("Wrong Password", "You have entered a wrong password",
            kPrimaryColor!, Colors.white);
      } else if (e.code == 'user-not-found') {
        showSnackbar("User Not Found", "User is not found", kPrimaryColor!,
            Colors.white);
      } else {
        showSnackbar("Error", "An error occurred during login", kPrimaryColor!,
            Colors.white);
      }
    } catch (e) {
      res = e.toString();
      showSnackbar("Error", "An error occurred during login", kPrimaryColor!,
          Colors.white);
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    showSnackbar("Sign Out", "You have been signed out successfully",
        kPrimaryColor!, Colors.white);
  }
}
