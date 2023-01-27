import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;
  final _baseUrl = 'https://shop-flutter-4802f-default-rtdb.firebaseio.com';

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
    http.post(Uri.parse('$_baseUrl/products.json'),
        body: jsonEncode({
          'name': product.name,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }));

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
