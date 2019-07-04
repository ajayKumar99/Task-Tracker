import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class Authentication {
  Future<FirebaseUser> signInUser();
  Future<void> signOutUser();
  Future<FirebaseUser> getCurrentUserCredentials();
}

class Auth implements Authentication {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> signInUser() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOutUser() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  Future<FirebaseUser> getCurrentUserCredentials() async {
    return _firebaseAuth.currentUser();
  }
}