import 'package:easy_localization/easy_localization.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';

class Validation{
  validateEmptyField(val, {message}){
    bool isValid = val.toString().isNotEmpty;
    if(isValid){
      return null;
    }else{
      return message ?? "Filed required";
    }
  }

  validatePinField(val, {message}){
    bool isValid = val.toString().isNotEmpty;
    bool isFiveDigits = val.toString().length == 5;
    if(isValid && isFiveDigits){
      return null;
    }else if(isValid && !isFiveDigits){
      return 'Pin must be of five digits'.tr();
    }else{
      return message ?? "Filed required";
    }
  }

  validateEmail(val) {
    var mobile = val;
    bool isValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(mobile);
    if (isValid) {
      return null;
    } else {
      return 'Enter a valid email';
    }
  }
}