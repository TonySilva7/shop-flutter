import 'package:flutter/material.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductsOverviewPages extends StatelessWidget {
  final List<Product> loadedProducts = dummyProducts;

  ProductsOverviewPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 elementos por linha
          childAspectRatio: 3 / 2, // relação entre altura e largura
          crossAxisSpacing: 10, // espaçamento entre os elementos no eixo horizontal
          mainAxisSpacing: 10, // espaçamento entre os elementos no eixo vertical
        ),
        itemBuilder: (ctx, i) => ProductItem(product: loadedProducts[i]),
        itemCount: loadedProducts.length,
      ),
    );
  }
}
