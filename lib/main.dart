import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/music_provider.dart';

import 'widgets/app.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderMusic()),
      ],
      child: const App(),
    ),
  );
}
//todo ShP ga provider yasash yoki bloc ga o'tkazish
//todo iloji bo'lsa notigficatiom bn lockgaplayer qo'shish
