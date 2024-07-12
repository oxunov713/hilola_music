import 'package:flutter/material.dart';
import 'package:hilola_gayratova/provider/music_provider.dart';
import 'package:hilola_gayratova/widgets/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import 'home/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProviderMusic(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Sans",
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
