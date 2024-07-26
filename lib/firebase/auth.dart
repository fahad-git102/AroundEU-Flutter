import 'package:firebase_auth/firebase_auth.dart';

import 'auth_exception_handling.dart';

class Auth{
  late AuthStatus _status;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<AuthStatus> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _status = AuthStatus.successful;
    } on  FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  // //Google sign-in
  // Future<AuthStatus> signInWithGoogle() async {
  //   await GoogleSignIn().signOut();
  //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication? gAuth = await gUser?.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //       accessToken: gAuth?.accessToken,
  //       idToken: gAuth?.idToken
  //   );
  //   try{
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     _status = AuthStatus.successful;
  //   } on  FirebaseAuthException catch (e) {
  //     _status = AuthExceptionHandler.handleAuthException(e);
  //   }
  //   return _status;
  // }

  Future<AuthStatus> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseAuth.currentUser!.updateDisplayName(name);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    await _firebaseAuth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError((e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }
}