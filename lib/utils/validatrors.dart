class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!_emailRegExp.hasMatch(value)) {
      return 'Por favor, informe um email válido';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (!_passwordRegExp.hasMatch(value)) {
      return 'Senha deve conter pelo menos 8 caracteres, uma letra e um número';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value != password) {
      return 'Senhas não conferem';
    }
    return null;
  }
}
