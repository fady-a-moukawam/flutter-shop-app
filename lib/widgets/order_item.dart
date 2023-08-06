import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:shop_app/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({super.key, required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat.MMMEd().format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_isOpen ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isOpen = !_isOpen;
                });
              },
            ),
          ),
          AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
              height: _isOpen
                  ? min(widget.order.products.length * 20.0 + 100, 100)
                  : 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView.builder(
                itemBuilder: (_, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.order.products[index].title),
                      Text(
                          '\$${widget.order.products[index].quantity}x ${widget.order.products[index].price}')
                    ],
                  );
                },
                itemCount: widget.order.products.length,
              ))
        ],
      ),
    );
  }
}
