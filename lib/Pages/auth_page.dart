import 'package:flutter/material.dart';

import '../components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                Colors.deepPurpleAccent,
                Colors.blue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 60,
                ),
                transform: Matrix4.rotationZ(-8 * 3.1415927 / 180)..translate(-8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Minha Loja',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Anton',
                    color: Colors.white,
                  ),
                ),
              ),
              AuthForm(),
            ],
          ),
        )
      ],
    ));
  }
}
