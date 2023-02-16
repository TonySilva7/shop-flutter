import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/utils/validators.dart';

import '../models/auth.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.login;
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  AnimationController? _controller;
  Animation<Size>? _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _heightAnimation = Tween<Size>(
      begin: const Size(double.infinity, 310),
      end: const Size(double.infinity, 400),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );

    // _heightAnimation?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro!'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);
    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        await auth.signIn(_authData['email']!, _authData['password']!);
      } else {
        await auth.signup(_authData['email']!, _authData['password']!);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.login;
        _controller?.reverse();
      }
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
      child: AnimatedBuilder(
        animation: _heightAnimation!,
        builder: (ctx, childForm) => Container(
          padding: const EdgeInsets.all(16),
          width: deviceSize.width * 0.85,
          // height: _isSignup() ? 290 : 270,
          height: _heightAnimation?.value.height, //?? (_isSignup() ? 310 : 400),
          child: childForm,
        ),
        child: Form(
          key: _formKey,
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
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
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
