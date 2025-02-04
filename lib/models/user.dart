import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final String password;
  final String profilePicture;

  const User({
    required this.email,
    required this.uid,
    required this.username,
    required this.password,
    required this.profilePicture,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'password': password,
        'profilePicture': profilePicture,
      };
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      password: snapshot['password'],
      profilePicture: snapshot['profilePicture'],
    );
  }
}
