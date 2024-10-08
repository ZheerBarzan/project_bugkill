import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in

  Future<UserCredential> signInWithEmailAndPassword(
      String input, password) async {
    String? email;

    if (input.contains('@')) {
      email = input;
    } else {
      QuerySnapshot querySnapshot = await _firestore
          .collection("Users")
          .where("username", isEqualTo: input)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        email = querySnapshot.docs[0]['email'];
      } else {
        throw Exception("User not found");
      }
    }
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email!, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  // sign up

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info
      _firestore.collection("Users").doc(userCredential.user!.email).set({
        "username": email.split('@')[0],
        "bio": "Empty Bio",
        "email": email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sigh out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //OAuth

  // google
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // errors
}
