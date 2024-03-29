import 'package:dr_kirana/screens/splash_page.dart';
import 'package:dr_kirana/store/cart/cart.dart';
import 'package:dr_kirana/store/login_store/login_store.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
        Provider<Cart>(
          create: (_) => Cart(),
        ),
        Provider<LoginStore>(
          create: (_) => LoginStore(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData.light(),
        title: "Dr Kirana",
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
        home: SplashPage(),
      ),
    );
  }
}
