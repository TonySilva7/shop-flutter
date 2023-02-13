import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';

class OrderList with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    DateTime dateNow = DateTime.now();

    final Response response = await post(
      Uri.parse('${dotenv.env['ORDER_BASE_URL']}.json'),
      body: jsonEncode({
        'total': cart.totalAmount,
        'date': dateNow.toIso8601String(),
        'products': cart.items.values
            .map((CartItem cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'name': cartItem.name,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );

    final id = jsonDecode(response.body)['name'];

    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        date: dateNow,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }

  Future<void> loadOrders() async {
    _items.clear();

    final response = await get(Uri.parse('${dotenv.env['ORDER_BASE_URL']}.json'));
    Map<String, dynamic> data = jsonDecode(response.body);

    if (data.isNotEmpty) {
      data.forEach((orderId, orderData) {
        _items.add(
          Order(
            id: orderId,
            date: DateTime.parse(orderData['date']),
            total: orderData['total'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    productId: item['productId'],
                    name: item['name'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList(),
          ),
        );
      });
      notifyListeners();
    }
  }
}
