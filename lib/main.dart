import 'package:flutter/material.dart';
import 'package:sqflite_image_practice/pages/my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Database storing images practice',
      home: MyHomePage(),
    );
  }
}