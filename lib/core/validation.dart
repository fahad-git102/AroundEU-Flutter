class Validation{
  validateEmptyField(val, {message}){
    bool isValid = val.toString().isNotEmpty;
    if(isValid){
      return null;
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