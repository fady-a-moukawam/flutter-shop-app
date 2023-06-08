import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductGridView extends StatelessWidget {
  final bool showOnlyFavorites;

  const ProductGridView({super.key, required this.showOnlyFavorites});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showOnlyFavorites ? productsData.favoritesItems : productsData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: ((context, index) {
          // ChangeNotifierProvider(
          //   create: (c) => products[index],
          return ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(
              key: ValueKey(products[index].id),
              // id: products[index].id,
              // title: products[index].title,
              // imageUrl: products[index].imageUrl
            ),
          );
        }));
  }
}
