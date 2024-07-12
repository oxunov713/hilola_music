import 'package:flutter/material.dart';
import 'package:hilola_gayratova/provider/music_provider.dart';
import 'package:provider/provider.dart';

import 'widgets/app.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProviderMusic()),
        ],
        child: const App(),
      ),
    );
