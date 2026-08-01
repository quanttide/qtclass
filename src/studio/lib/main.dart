import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/player_state.dart';
import 'screens/home_screen.dart';
import 'screens/player_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerState()),
      ],
      child: const QtClassApp(),
    ),
  );
}

class QtClassApp extends StatelessWidget {
  const QtClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '量潮课堂',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F6B4F),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/player': (_) => const PlayerScreen(),
      },
    );
  }
}
