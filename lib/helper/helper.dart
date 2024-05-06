class Helper{
  final RegExp nameRegExp = RegExp('[a-zA-Z]');
  final String emailRegString =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp namAndnumRegExp = RegExp('[0-9a-zA-Z]');

  final RegExp numberRegExp = RegExp(r'\d');

  String? emailValidation(value) {
    RegExp regExp = RegExp(emailRegString);
    if (value!.isEmpty) {
      return ('Please Enter Email');
    } else if (!regExp.hasMatch(value)) {
      return ('Please, Enter Valid Email');
    } else {
      return null;
    }

  }

  String? passwordValidation(value) {
    String pswrd = r'[!@#$%^&*(),.?":{}|<>]';
    RegExp regExp = RegExp(pswrd);
    if (value!.isEmpty || value.length < 8 || !regExp.hasMatch(value)) {
      // return ('Password must be more 6 letter'.tr());
      return ('Please Enter a valid password');
    } else {
      return null;
    }
  }
}