import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total'),
                  const Spacer(),
                  Chip(
                    label: Text('\$ ${cartData.totalAmount}'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(onPressed: () {}, child: const Text('Order Now!'))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cartData.getItemCount,
            itemBuilder: (ctx, index) {
              return CartItem(
                  id: cartData.getItems.values.toList()[index].id,
                  productId: cartData.getItems.keys.toList()[index],
                  title: cartData.getItems.values.toList()[index].title,
                  price: cartData.getItems.values.toList()[index].price,
                  quantity: cartData.getItems.values.toList()[index].quantity);
            },
          ))
        ],
      ),
    );
  }
}
