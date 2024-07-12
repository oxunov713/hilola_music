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
//TODO sqflite or sharedpref bn musiqlarani durationini,qaysi musiqani eshitayotganini va qayerga kelganini eslab qolishi kerak
//TODO reklama banneri qoyish kerak yani zametka
//TODO imagelar shuffle xolatda keladi
//TODO musiqani shuffle qilgan xolda eshitishi kerak
//TODO kodni optimallashtirish,soddalashtirish,
