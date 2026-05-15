import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/session.dart';

void main() {
  test('SessionStatus has 3 values', () {
    expect(SessionStatus.values.length, 3);
  });

  test('AttendanceStatus has 4 values', () {
    expect(AttendanceStatus.values.length, 4);
  });
}
