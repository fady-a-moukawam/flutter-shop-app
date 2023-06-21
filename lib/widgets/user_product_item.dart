import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.id});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);

    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        title: Text(title),
        trailing: SizedBox(
          width: 100,
          child: Row(children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  productsData.deleteProduct(id);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ]),
        ),
      ),
    );
  }
}
