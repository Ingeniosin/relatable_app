import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  bool isLoaded = false;
  User? user;

  bool get isSignIn => user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      isLoaded = true;
      this.user = user;
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUpWithEmailAndPassword(String email, String password, String name) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _auth.currentUser!.updateDisplayName(name);
  }

  Future<bool> checkEmail(String email) async {
    bool emailExists = false;
    try {
      await _auth.fetchSignInMethodsForEmail(email);
      emailExists = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emailExists = false;
      }
    }
    return emailExists;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
