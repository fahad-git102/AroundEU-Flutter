import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/main.dart';
import 'package:groupchat/views/auth/login_screen.dart';

import '../component_library/text_widgets/extra_medium_text.dart';
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

  Future<void> deleteAccount(BuildContext context) async{
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.delete();
        Utilities().showCustomToast(message: 'Your account has been deleted successfully', isError: false);
        Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, LoginScreen.route, (route)=> false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Utilities().showReauthenticateDialog(context);
      } else {
        Utilities().showCustomToast(message: 'Failed to delete account: ${e.message}', isError: true);
      }
    }
  }

  Future<void> reauthenticateUser(String email, String password, BuildContext context) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
      Utilities().showCustomToast(message: 'Reauthentication successful! You can now delete your account.'.tr(), isError: false);
      await deleteAccount(context);
    } catch (e) {
      Utilities().showCustomToast(message: 'Reauthentication failed: ${e.toString()}', isError: true);
    }
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