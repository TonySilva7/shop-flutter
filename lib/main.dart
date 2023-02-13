import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shop/Pages/auth_or_home.dart';
import 'package:shop/Pages/cart_page.dart';
import 'package:shop/Pages/orders_page.dart';
import 'package:shop/Pages/product_detail_page.dart';
import 'package:shop/Pages/product_form_page.dart';
import 'package:shop/Pages/products_page.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/routes/app_routes.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (ctx) => ProductList('', []),
          update: (ctx, auth, previous) => ProductList(auth.token ?? '', previous?.items ?? []),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => OrderList()),
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
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.authOrHome: (context) => const AuthOrHomePage(),
          AppRoutes.productDetail: (context) => const ProductDetailPage(),
          AppRoutes.cart: (context) => const CartPage(),
          AppRoutes.orders: (context) => const OrdersPage(),
          AppRoutes.products: (context) => const ProductsPage(),
          AppRoutes.productForm: (context) => const ProductFormPage(),
        },
      ),
    );
  }
}
