import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/providers/product.dart';
import 'package:shop_app/models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    //! Note:
    //! we returned a copy of _items and not _items directly because at the end this is an object and if we pass it directly
    //! the pointer will be pointing to the object
    //! in memory and every change will immediately affect the original object
    return [..._items];
  }

  List<Product> get favoritesItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-shop-app-1f18f-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);
      final apiProducts = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> productList = [];

      apiProducts.forEach((key, value) {
        productList.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: value['isFavorite'],
        ));
      });

      _items = productList;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shop-app-1f18f-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      // _items.add(newProduct); add element at the end
      _items.insert(0, newProduct); //add element at the top
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product editedProduct) async {
    final prodIndex =
        _items.indexWhere((element) => element.id == editedProduct.id);

    if (prodIndex > -1) {
      try {
        final url = Uri.parse(
            'https://flutter-shop-app-1f18f-default-rtdb.firebaseio.com/products/${editedProduct.id}.json');
        await http.patch(url,
            body: json.encode({
              'title': editedProduct.title,
              'description': editedProduct.description,
              'price': editedProduct.price,
              'imageUrl': editedProduct.imageUrl,
            }));

        _items[prodIndex] = editedProduct;
        notifyListeners();
      } catch (error) {
        print(error);
      }
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
        'https://flutter-shop-app-1f18f-default-rtdb.firebaseio.com/products/$productId.json');

    final productIndex =
        _items.indexWhere((element) => element.id == productId);
    Product? originalElementToBeDeleted = _items[productIndex];

    _items.removeAt(productIndex);
    notifyListeners();
    // delete method does not throw an error -> it will return the status code as 400 or greater
    final res = await http.delete(url);

    //in case of error
    if (res.statusCode >= 400) {
      _items.insert(productIndex, originalElementToBeDeleted);
      notifyListeners();
      throw HttpException('Could not delete product!');
    }

    originalElementToBeDeleted = null;
  }
}
