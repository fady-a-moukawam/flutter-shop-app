import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';

import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
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
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (_) => Products('', [], ''),
              update: (_, authObject, previousProducts) => Products(
                    authObject.getToken ?? '',
                    previousProducts == null ? [] : previousProducts.items,
                    authObject.userId,
                  )),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (_) => Orders('', '', []),
              update: (_, authObject, previousOrders) => Orders(
                  authObject.getToken ?? '',
                  authObject.userId,
                  previousOrders == null ? [] : previousOrders.getOrders)),
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            title: 'My shop app',
            theme: ThemeData(
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.iOS: CustomPageTransitionsBuilder(),
                  TargetPlatform.android: CustomPageTransitionsBuilder(),
                }),
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
            home: authData.isAuthenticated
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, authSnapshots) =>
                        authSnapshots.connectionState == ConnectionState.waiting
                            ? const Center(child: CircularProgressIndicator())
                            : AuthScreen()),
            routes: {
              ProductsOverviewScreen.routeName: (context) =>
                  const ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (context) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrderScreen.routeName: (context) => const OrderScreen(),
              UserProducts.routName: (context) => const UserProducts(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
              AuthScreen.routeName: (context) => AuthScreen()
            },
          ),
        ));
  }
}
