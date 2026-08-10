import 'package:flutter/material.dart';
import '../widgets/home/home_content.dart';
import '../widgets/home/home_nav_bar.dart';
import 'player_screen.dart';

/// 课程首页
///
/// 组合 `HomeNavBar`（顶栏）与 `HomeContent`（课程信息内容）。
/// 映射自 `doc/screens/home.md`。
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _startLearning() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlayerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 顶栏导航
            const HomeNavBar(),
            // 内容
            Expanded(child: HomeContent(onStart: _startLearning)),
          ],
        ),
      ),
    );
  }
}
