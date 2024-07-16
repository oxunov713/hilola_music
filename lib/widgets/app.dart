import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/music_provider.dart';
import 'splash/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProviderMusic(),
      child: Consumer<ProviderMusic>(
        builder: (context, provider, _) {
          return MaterialApp(
            theme: ThemeData(
              fontFamily: "Sans",
              appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
            ),
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
