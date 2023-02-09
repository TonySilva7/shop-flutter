import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order_list.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final List<CartItem> items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6?.color),
                    ),
                    backgroundColor: Colors.purple,
                  ),
                  Spacer(),
                  MyButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) => MyCartItem(cartItem: items[i]),
              itemCount: items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  const MyButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemsCount < 1
                ? null
                : () async {
                    setState(() => _isLoading = true);

                    await Provider.of<OrderList>(context, listen: false).addOrder(widget.cart);
                    widget.cart.clearList();

                    setState(() => _isLoading = false);
                  },
            style: TextButton.styleFrom(
              foregroundColor: Colors.purple,
            ),
            child: Text('COMPRAR'),
            // textColor: Theme.of(context).primaryColor,
          );
  }
}
