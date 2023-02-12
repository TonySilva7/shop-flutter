class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  static final RegExp _passwordRegExp = RegExp(
    // r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
  );

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório';
    } else if (!_emailRegExp.hasMatch(value)) {
      return 'Por favor, informe um email válido';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    } else if (!_passwordRegExp.hasMatch(value)) {
      return 'Insira ao menos 8 caracteres. Ex. Abc123@*';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    } else if (value != password) {
      return 'Senhas não conferem';
    }
    return null;
  }
}
