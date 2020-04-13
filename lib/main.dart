import 'package:dr_kirana/services/authservice.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData.light(),
      title: "Dr Kirana",
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics)
      ],
      home: AuthService().handleAuth(),
    );
  }
}
