class Validator {
  static String? validateEmail(String? value){
    if(value==null||value.isEmpty){
      return "Email is required";
    }
    final emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
    );
    if(!emailRegex.hasMatch(value)){
      return "Enter a valid email";
    }
    return null;
  }
}