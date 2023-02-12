import 'package:flutter/material.dart';
import 'package:shop/utils/validatrors.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

void _onSubmit() {}

class _AuthFormState extends State<AuthForm> {
  final AuthMode _authMode = AuthMode.signup;
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

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
        height: _authMode == AuthMode.signup ? 290 : 220,
        width: deviceSize.width * 0.85,
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
              if (_authMode == AuthMode.signup)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar Senha'),
                  keyboardType: TextInputType.text,
                  validator: (value) => Validators.confirmPasswordValidator(
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
                  _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
