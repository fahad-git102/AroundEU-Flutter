import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
  userNotFound,
  networdError
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "network-request-failed":
        status = AuthStatus.networdError;
        break;
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }
  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.networdError:
        errorMessage = "No internet connection was found. Please connect your internet or try again.".tr();
        break;
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.".tr();
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.".tr();
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your email or password is wrong.".tr();
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
        "The email address is already in use by another account.".tr();
        break;
      case AuthStatus.userNotFound:
        errorMessage =
        "This email address is not registered.".tr();
        break;
      default:
        errorMessage = "An error occured. Please try again later.".tr();
    }
    return errorMessage;
  }
}