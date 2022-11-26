import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';

class MyCartItem extends StatelessWidget {
  final CartItem cartItem;

  const MyCartItem({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Text(cartItem.name);
  }
}
