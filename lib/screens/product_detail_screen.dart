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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned:
                true, //even if we scroll it will always be shown else it will dissapear and appear on scroll
            flexibleSpace: FlexibleSpaceBar(
              title: Text(productObject.title),
              background: Hero(
                tag: productId,
                child: Image.network(
                  productObject.imageUrl,
                  fit: BoxFit.cover,
                ),
              ), //this part will only be shown if it s expanded
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${productObject.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                productObject.description,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 900,
            ) // added for testing purpose to be able to scroll and check appbar behaviour
          ]))
        ],
      ),
    );
  }
}
