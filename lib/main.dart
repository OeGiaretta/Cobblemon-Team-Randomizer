import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const CobblemonRandomizerApp());
}

class CobblemonRandomizerApp extends StatelessWidget {
  const CobblemonRandomizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cobblemon Team Randomizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE53935),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1117),
      ),
      home: const HomePage(),
    );
  }
}