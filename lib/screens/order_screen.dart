import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';

import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _orderFuture;

  Future _obtainOrderFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    //!by using this approach we make sure that the api call will not be called whenever we call build method again for any other state that might change
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //!when using FutureBuilder
    //!don't use Provider with FutureBuilder or we will fall in an infinite loop

    return Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _orderFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.hasError) {
              return Text('Error: ${dataSnapshot.error}');
            } else {
              return Consumer<Orders>(
                  builder: (_, orderData, child) => ListView.builder(
                        itemBuilder: (ctx, index) =>
                            OrderItem(order: orderData.getOrders[index]),
                        itemCount: orderData.getOrders.length,
                      ));
            }
          },
        ));
  }
}
