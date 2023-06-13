import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Products()),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (context) => Orders(),
          )
        ],
        child: MaterialApp(
          title: 'My shop app',
          theme: ThemeData(
              fontFamily: 'Lato',
              primarySwatch: Colors.blue,
              colorScheme: const ColorScheme(
                brightness: Brightness.dark,
                primary: Colors.orange,
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
          home: const ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrderScreen.routeName: (context) => const OrderScreen()
          },
        ));
  }
}
