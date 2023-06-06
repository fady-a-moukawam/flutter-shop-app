import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';

import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final productId = args['productId'];

    final Product productObject =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(productObject.title),
      ),
    );
  }
}
