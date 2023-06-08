import 'package:flutter/material.dart';

import 'package:shop_app/widgets/product_grid_view.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('the body shop'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              if (selectedValue == FilterOptions.favorites) {
                setState(() {
                  _showOnlyFavorites = true;
                });
              }
              if (selectedValue == FilterOptions.all) {
                setState(() {
                  _showOnlyFavorites = false;
                });
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: ProductGridView(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
