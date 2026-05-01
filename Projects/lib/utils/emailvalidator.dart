class Validator {
  static int validateEmail(String? value){
    // 0 for null email
    // -1 for invalid email
    //1 for valid email
    if(value==null||value.isEmpty){
      return 0;
    }
    final emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
    );
    if(!emailRegex.hasMatch(value)){
      return -1;
    }
    return 1;
  }
}