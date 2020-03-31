import 'package:dr_kirana/services/authservice.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData.light(),
      title: "Dr Kirana",
      home: AuthService().handleAuth(),
    );
  }
}
