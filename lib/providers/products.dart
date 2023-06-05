import 'package:flutter/material.dart';

import 'package:shop_app/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    //! Note:
    //! we returned a copy of _items and not _items directly because at the end this is an object and if we pass it directly
    //! the pointer will be pointing to the object
    //! in memory and every change will immediately affect the original object
    return [..._items];
  }

  void addProduct() {
    // _items.add...
    notifyListeners();
  }
}
