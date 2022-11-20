import 'package:flutter/material.dart';
import 'package:shop/Pages/product_detail_page.dart';
import 'package:shop/Pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(secondary: Colors.deepOrange),
      ),
      home: ProductsOverviewPages(),
      debugShowCheckedModeBanner: true,
      routes: {
        AppRoutes.productDetail: (context) => const ProductDetailPage(),
      },
    );
  }
}
