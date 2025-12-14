import 'package:flutter/material.dart';
import 'package:googlemapproject/bottomnavigation.dart';
import 'package:googlemapproject/provider/current_location_provider.dart';
import 'package:googlemapproject/provider/delivery_provider.dart';
import 'package:provider/provider.dart';


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
        ChangeNotifierProvider(create: (_) => CurrentLocationProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: NavigationMenu(),
      ),
    );
  }
}


