import 'package:flutter/material.dart';

import 'views/HomePage.dart';
import 'views/AdminPage.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thank You',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/admin': (context) => AdminPage(),
      }
    );
  }
}

