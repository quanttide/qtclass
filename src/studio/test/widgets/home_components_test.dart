import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/services/course_data.dart';
import 'package:qtclass_studio/widgets/home/course_subtitle.dart';
import 'package:qtclass_studio/widgets/home/course_tag.dart';
import 'package:qtclass_studio/widgets/home/course_title.dart';
import 'package:qtclass_studio/widgets/home/home_content.dart';
import 'package:qtclass_studio/widgets/home/home_nav_bar.dart';
import 'package:qtclass_studio/widgets/home/meta_row.dart';
import 'package:qtclass_studio/widgets/home/method_label.dart';
import 'package:qtclass_studio/widgets/home/objectives_list.dart';
import 'package:qtclass_studio/widgets/home/start_button.dart';

/// 首页组件测试（镜像 `lib/widgets/home/` 结构）
void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('HomeNavBar - 顶栏导航', () {
    testWidgets('显示品牌与当前页标识', (tester) async {
      await tester.pumpWidget(wrap(const HomeNavBar()));
      await tester.pump();
      expect(find.text('量潮课堂'), findsOneWidget);
      expect(find.text('课程首页'), findsOneWidget);
    });
  });

  group('CourseTag / CourseTitle / CourseSubtitle / MethodLabel - 展示组件', () {
    testWidgets('渲染传入文案', (tester) async {
      await tester.pumpWidget(
        wrap(
          Column(
            children: const [
              CourseTag(label: '氛围编程 · Vibe Coding'),
              CourseTitle(text: '课程标题'),
              CourseSubtitle(text: '课程简介'),
              MethodLabel(text: '互动节点 · 状态反馈'),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(find.text('氛围编程 · Vibe Coding'), findsOneWidget);
      expect(find.text('课程标题'), findsOneWidget);
      expect(find.text('课程简介'), findsOneWidget);
      expect(find.text('互动节点 · 状态反馈'), findsOneWidget);
    });
  });

  group('MetaRow - 元信息行', () {
    testWidgets('四项元信息来自课程数据', (tester) async {
      await tester.pumpWidget(wrap(const MetaRow()));
      await tester.pump();
      expect(find.text('适合人群'), findsOneWidget);
      expect(find.text('开发者'), findsOneWidget);
      expect(find.text('预计时间'), findsOneWidget);
      expect(find.text('选择节点'), findsOneWidget);
      expect(
        find.textContaining('${CourseData.interactionNodes.length} 个'),
        findsOneWidget,
      );
      expect(find.text('难度'), findsOneWidget);
    });
  });

  group('ObjectivesList - 学习目标', () {
    testWidgets('目标列表来自课程数据', (tester) async {
      await tester.pumpWidget(wrap(const ObjectivesList()));
      await tester.pump();
      expect(find.text('本节你将掌握'), findsOneWidget);
      expect(find.textContaining('Zed 编辑器'), findsWidgets);
    });
  });

  group('StartButton - 开始学习', () {
    testWidgets('点击触发回调', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(StartButton(onPressed: () => tapped = true)),
      );
      await tester.pump();
      await tester.tap(find.text('开始学习'));
      expect(tapped, isTrue);
    });
  });

  group('HomeContent - 内容容器', () {
    testWidgets('组合全部首页区块', (tester) async {
      await tester.pumpWidget(wrap(HomeContent(onStart: () {})));
      await tester.pump();
      expect(find.textContaining('开发环境搭建'), findsWidgets);
      expect(find.text('开始学习'), findsOneWidget);
      expect(find.text('本节你将掌握'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
