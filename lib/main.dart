import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Pages/product_detail_page.dart';
import 'package:shop/Pages/products_overview_page.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProductList(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(secondary: Colors.deepOrange),
        ),
        home: const ProductsOverviewPages(),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.productDetail: (context) => const ProductDetailPage(),
        },
      ),
    );
  }
}
