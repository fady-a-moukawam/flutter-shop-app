import 'package:flutter/material.dart';

import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My shop app',
      theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: Colors.blue,
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.blue,
            onPrimary: Colors.white,
            secondary: Colors.deepOrange,
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            background: Colors.black87,
            onBackground: Colors.white,
            surface: Colors.transparent,
            onSurface: Colors.white,
          )),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (context) => const ProductDetailScreen()
      },
    );
  }
}
