import 'package:flutter/material.dart';
import 'screens/ShoppingListScreen.dart';

void main() => runApp(IQueChumbei());

class IQueChumbei extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iQueChumbei',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textSelectionColor: Colors.black54,
      ),
      home: ShoppingListScreen(title: 'iQueChumbei'),
    );
  }
}
