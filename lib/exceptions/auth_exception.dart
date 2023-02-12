class AuthException implements Exception {
  final String key;
  static const Map<String, String> _errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Muitas tentativas. Tente mais tarde',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado',
    'INVALID_PASSWORD': 'Senha inválida',
    'USER_DISABLED': 'Usuário desabilitado',
  };

  AuthException({required this.key});

  @override
  String toString() {
    return _errors[key] ?? 'Erro desconhecido!';
  }
}
