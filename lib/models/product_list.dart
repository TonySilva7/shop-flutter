import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;
  // bool _showFavoriteOnly = false;

  // List<Product> get items {
  //   if (_showFavoriteOnly) {
  //     return _items.where((product) => product.isFavorite).toList();
  //   }
  //   return [..._items];
  // }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items.where((product) => product.isFavorite).toList();

  int get itemsCount => _items.length;

  void saveProduct(Map<String, Object> formData) {
    bool hasId = formData['id'] != null;

    final newProduct = Product(
      id: hasId ? formData['id'] as String : Random().nextDouble().toString(),
      name: formData['name'].toString(),
      price: formData['price'] as double,
      description: formData['description'].toString(),
      imageUrl: formData['imageUrl'].toString(),
    );

    if (hasId) {
      updateProduct(newProduct);
    } else {
      addProduct(newProduct);
    }
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    final index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      _items.removeWhere((item) => item.id == product.id);
      notifyListeners();
    }
  }
}
