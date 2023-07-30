import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';

import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  const OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;

  Orders(this.authToken,
      this._orders); // here we are passing the token through the constructor

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutter-shop-app-1f18f-default-rtdb.firebaseio.com/orders.json?auth=$authToken');

    try {
      final res = await http.get(url);
      final List<OrderItem> orderList = [];
      final Map<String, dynamic>? savedOrders = json.decode(res.body);

      if (savedOrders == null) {
        return;
      }

      savedOrders.forEach(
        (key, value) {
          orderList.add(OrderItem(
            id: key,
            amount: value['amount'],
            dateTime: DateTime.parse(value['dateTime']),
            products: (value['products'] as List<dynamic>).map((prod) {
              return CartItem(
                  id: prod['id'],
                  title: prod['title'],
                  price: prod['price'],
                  quantity: prod['quantity']);
            }).toList(),
          ));
        },
      );
      _orders = orderList.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-shop-app-1f18f-default-rtdb.firebaseio.com/orders.json?auth=$authToken');

    try {
      final timeStamp = DateTime.now();

      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((elem) => {
                      'id': elem.id,
                      'title': elem.title,
                      'quantity': elem.quantity,
                      'price': elem.price,
                    })
                .toList(),
          }));

      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartProducts,
              dateTime: timeStamp));

      notifyListeners();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
