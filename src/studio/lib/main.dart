import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/course_data.dart';
import 'services/course_service.dart';
import 'services/player_state.dart';
import 'screens/course_list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/player_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 课程目录（列表页数据源；失败时保留空列表）
  await CourseService.load(
    apiUrl: const String.fromEnvironment('QTCLASS_API_BASE_URL'),
  );
  // 播放器单课数据在进入课时时按课程加载；启动阶段只准备内置 fallback。
  await CourseData.load();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PlayerState())],
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
        '/': (_) => const CourseListScreen(),
        '/login': (_) => const LoginScreen(),
        '/player': (_) => const PlayerScreen(),
      },
    );
  }
}
