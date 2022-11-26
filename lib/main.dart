import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Pages/cart_page.dart';
import 'package:shop/Pages/product_detail_page.dart';
import 'package:shop/Pages/products_overview_page.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ).copyWith(
            secondary: Colors.deepOrange,
          ),
          canvasColor: Color.fromARGB(255, 253, 236, 255),
        ),
        home: const ProductsOverviewPages(),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.productDetail: (context) => const ProductDetailPage(),
          AppRoutes.cart: (context) => const CartPage(),
        },
      ),
    );
  }
}
