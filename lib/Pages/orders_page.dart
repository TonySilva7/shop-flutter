import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return const Center(
              child: Text('Ocorreu um erro!'),
            );
          } else {
            return Consumer<OrderList>(
              builder: (ctx, OrderList orders, child) => RefreshIndicator(
                onRefresh: () async => await orders.loadOrders(),
                child: ListView.builder(
                  itemBuilder: (ctx, i) => OrderWidget(order: orders.items[i]),
                  itemCount: orders.itemsCount,
                ),
              ),
            );
          }
        },
      ),
      // body: isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : RefreshIndicator(
      //         onRefresh: () async => await orders.loadOrders(),
      //         child: ListView.builder(
      //           itemBuilder: (ctx, i) => OrderWidget(order: orders.items[i]),
      //           itemCount: orders.itemsCount,
      //         ),
      //       ),
    );
  }
}
