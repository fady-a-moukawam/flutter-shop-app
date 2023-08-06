import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  const ProductItem({
    super.key,
    // required this.id,
    // required this.title,
    // required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // if we use the Provider this will cause a full widget re-render on each update
    // final product = Provider.of<Product>(context);

//!for enhancement:
//we can  set listen as false and wrap only the part of the widget that will be important tp update with a Consumer
    final product = Provider.of<Product>(context, listen: false);
    final cartData = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          leading: Consumer<Product>(
            builder: (_, value, child) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () => product.toggleFavorite(
                    authData.getToken as String, authData.userId)),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () => {
              cartData.addProductToCart(
                  product.id, product.title, product.price),
              ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'Product successfully added to cart!',
                  style: TextStyle(color: Colors.white),
                ),
                action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () => cartData.removeSingleItem(product.id)),
                duration: const Duration(seconds: 4),
                backgroundColor: Colors.green,
              ))
            },
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: {'productId': product.id}),
          child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    const AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              )),
        ),
      ),
    );
  }
}
