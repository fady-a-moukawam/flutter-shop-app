import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import 'package:shop_app/widgets/product_grid_view.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;

  void goToCart(ctx) {
    Navigator.of(ctx).pushNamed(CartScreen.routeName);
  }

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
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () => goToCart(context),
              icon: const Icon(Icons.shopping_cart),
              // color: Theme.of(context).colorScheme.primary,
            ),
            builder: (_, value, ch) => Badge(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              label: Text('${value.getItemCount}'),
              child: ch,
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductGridView(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
