import 'package:flutter/material.dart';

import 'package:shop_app/widgets/product_grid_view.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('the body shop'),
      ),
      body: const ProductGridView(),
    );
  }
}
