import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';

import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, index) => OrderItem(order: orders.getOrders[index]),
        itemCount: orders.getOrders.length,
      ),
    );
  }
}
