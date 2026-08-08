import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/services/player_state.dart';
import 'package:qtclass_studio/widgets/stage/player_controls.dart';

import '../helpers/seed.dart';

/// 播放控制栏测试
void main() {
  group('PlayerControls - 播放控制', () {
    testWidgets('初始显示播放图标', (tester) async {
      await tester.pumpWidget(
        wrapWithProviders(const Material(child: PlayerControls())),
      );
      await tester.pump();

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('播放中显示暂停图标', (tester) async {
      final state = PlayerState();
      state.play();

      await tester.pumpWidget(
        wrapWithProviders(
          const Material(child: PlayerControls()),
          state: state,
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.pause), findsOneWidget);

      state.pause();
    });
  });
}
