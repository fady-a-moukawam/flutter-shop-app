import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _rollbackMarkIsFavorite(bool updatedVal) {
    isFavorite = updatedVal;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final url = Uri.parse(
          'https://flutter-shop-app-1f18f-default-rtdb.firebaseio.com/products/$id.json');
      final res =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));

      if (res.statusCode >= 400) {
        _rollbackMarkIsFavorite(oldStatus);
      }
    } catch (error) {
      _rollbackMarkIsFavorite(oldStatus);
    }
  }
}
