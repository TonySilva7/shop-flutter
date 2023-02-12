import 'package:flutter/material.dart';
import 'package:shop/utils/validators.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.login;
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _onSubmit() {}

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;

  void _switchAuthMode() {
    setState(() {
      _authMode = _isLogin() ? AuthMode.signup : AuthMode.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: deviceSize.width * 0.85,
        // height: _isSignup() ? 290 : 270,
        child: Form(
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _authData['email'] = value?.trim() ?? '',
                  validator: (value) => Validators.emailValidator(value)),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.text,
                onSaved: (value) => _authData['password'] = value?.trim() ?? '',
                controller: _passwordController,
                obscureText: true,
                validator: (value) => Validators.passwordValidator(value),
              ),
              if (_isSignup())
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar Senha'),
                  keyboardType: TextInputType.text,
                  validator: _isLogin()
                      ? null
                      : (value) => Validators.confirmPasswordValidator(
                            value,
                            _passwordController.text,
                          ),
                  obscureText: true,
                ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _isLogin() ? 'ENTRAR' : 'REGISTRAR',
                ),
              ),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin() ? 'Criar uma nova conta' : 'Já tenho uma conta',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
