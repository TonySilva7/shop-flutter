import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/exceptions/my_http_exceptions.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items.where((product) => product.isFavorite).toList();

  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    final response = await get(Uri.parse('${Constants.PRODUCT_BASE_URL}/products.json'));
    Map<String, dynamic> data = jsonDecode(response.body);
    _items.clear();

    if (data.isNotEmpty) {
      data.forEach((productId, productData) {
        _items.add(
          Product(
            id: productId,
            name: productData['name'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ),
        );
      });
      notifyListeners();
    }
  }

  Future<void> saveProduct(Map<String, Object> formData) {
    bool hasId = formData['id'] != null;

    final newProduct = Product(
      id: hasId ? formData['id'] as String : Random().nextDouble().toString(),
      name: formData['name'].toString(),
      price: formData['price'] as double,
      description: formData['description'].toString(),
      imageUrl: formData['imageUrl'].toString(),
    );

    if (hasId) {
      return updateProduct(newProduct);
    } else {
      return addProduct(newProduct);
    }
  }

  Future<void> addProduct(Product product) async {
    final Response response = await post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}/products.json'),
      body: jsonEncode(
        {
          'name': product.name,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];

    _items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      ),
    );

    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((element) => element.id == product.id);

    if (index >= 0) {
      await patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/products/${product.id}.json'),
        body: jsonEncode(
          {
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    final index = _items.indexWhere((element) => element.id == product.id);

    if (index >= 0) {
      final Product product = _items[index];
      _items.remove(product);

      _items.removeWhere((item) => item.id == product.id);
      notifyListeners();

      final Response response = await delete(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/products/${product.id}.json'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();

        throw MyHttpException(
          message: 'Ocorreu um erro ao excluir o produto',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
