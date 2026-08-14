import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/course.dart';
import 'package:qtclass_studio/services/course_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Course.fromJson 解析完整字段', () {
    final course = Course.fromJson({
      'id': 'prod',
      'name': '生产实习',
      'icon': '🏭',
      'badge': '生产实习 · 微型创业',
      'badgeClass': 'capstone',
      'desc': '综合运用前四门课的全部能力。',
      'meta': {'modules': 5, 'duration': '2 周', 'students': 38},
      'stages': [
        {
          'id': 'm1',
          'name': '一、量潮是谁',
          'lessons': [
            {'id': 'm1-1', 'title': '1.1 量潮的创立故事', 'duration': '阅读 10 min', 'type': '阅读'},
          ],
        },
      ],
    });

    expect(course.id, 'prod');
    expect(course.isProd, isTrue);
    expect(course.name, '生产实习');
    expect(course.badgeClass, 'capstone');
    expect(course.meta.modules, 5);
    expect(course.meta.duration, '2 周');
    expect(course.meta.students, 38);
    expect(course.stages, hasLength(1));
    expect(course.stages.first.lessons.first.title, '1.1 量潮的创立故事');
    expect(course.stages.first.lessons.first.type, '阅读');
  });

  test('Course.fromJson 缺省字段容错', () {
    final course = Course.fromJson({
      'id': 'x',
      'name': 'X',
      'meta': {},
      'stages': [],
    });
    expect(course.icon, '');
    expect(course.badge, '');
    expect(course.badgeClass, 'beginner');
    expect(course.isProd, isFalse);
    expect(course.meta.modules, 0);
    expect(course.stages, isEmpty);
  });

  test('CourseService 加载 assets 课程列表', () async {
    await CourseService.load();
    expect(CourseService.loaded, isTrue);
    expect(CourseService.all, hasLength(5));
    expect(CourseService.byId('prod')?.isProd, isTrue);
    expect(CourseService.byId('prod')?.stages, hasLength(5));
  });
}