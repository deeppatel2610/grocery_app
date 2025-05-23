import 'package:flutter/material.dart';
import 'package:grocery_app/home_page.dart';
import 'package:grocery_app/home_provider.dart';
import 'package:grocery_app/temp.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grocery App',
        home: HomePage(),
      ),
    );
  }
}
