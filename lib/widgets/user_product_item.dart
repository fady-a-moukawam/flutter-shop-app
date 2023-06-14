import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const UserProductItem(
      {super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        title: Text(title),
        trailing: SizedBox(
          width: 100,
          child: Row(children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {},
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
