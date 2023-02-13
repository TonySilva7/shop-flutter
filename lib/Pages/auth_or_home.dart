import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop/Pages/auth_page.dart';
import 'package:shop/Pages/products_overview_page.dart';
import 'package:shop/models/auth.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    return auth.isAuth ? ProductsOverviewPages() : AuthPage();
  }
}
