import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product_list.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewPages extends StatefulWidget {
  const ProductsOverviewPages({super.key});

  @override
  State<ProductsOverviewPages> createState() => _ProductsOverviewPagesState();
}

class _ProductsOverviewPagesState extends State<ProductsOverviewPages> {
  bool _showFavoriteOnly = false;
  bool isLoading = true;

  Future<void> handleRefresh() async {
    await Provider.of<ProductList>(context, listen: false).loadProducts();
  }

  @override
  void initState() {
    super.initState();
    handleRefresh().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Somente Favoritos'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Todos'),
              ),
            ],
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.favorites) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/cart'),
              icon: Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => Badge(
              label: Text(cart.itemsCount.toString()),
              child: child!,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async => await handleRefresh(),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ProductGrid(showFavoriteOnly: _showFavoriteOnly)),
      drawer: AppDrawer(),
    );
  }
}
