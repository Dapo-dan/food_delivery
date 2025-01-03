import 'package:flutter/material.dart';
import 'package:food_delivery/core/app_set_up.dart';
import 'package:food_delivery/providers/favorite_provider.dart';
import 'package:food_delivery/providers/quantity_provider.dart';
import 'package:provider/provider.dart';
import 'Views/app_main_screen.dart';

void main() async {
 await appSetUp();
  runApp(const MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // for favorite provider
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        // for quantity provider
        ChangeNotifierProvider(create: (_) => QuantityProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppMainScreen(),
      ),
    );
  }
}
