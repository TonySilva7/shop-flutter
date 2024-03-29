import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Pages/auth_page.dart';
import 'package:shop/Pages/products_overview_page.dart';
import 'package:shop/models/auth.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    // return auth.isAuth ? ProductsOverviewPages() : AuthPage();
    return FutureBuilder(
        future: auth.tryAutoLogin(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.error != null) {
            return const Scaffold(
              body: Center(
                child: Text('Ocorreu um erro!'),
              ),
            );
          } else {
            return auth.isAuth ? ProductsOverviewPages() : AuthPage();
          }
        });
  }
}
