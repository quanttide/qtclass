import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'data_service.dart';

class AppState extends ChangeNotifier {
  final DataService _dataService;

  AppState({DataService? dataService}) : _dataService = dataService ?? DataService();

  List<Session> _sessions = [];
  List<Lecture> _lectures = [];
  bool _isLoading = false;
  String? _error;

  List<Session> get sessions => _sessions;
  List<Lecture> get lectures => _lectures;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Session> get upcomingSessions =>
      _sessions.where((s) => s.status == SessionStatus.upcoming).toList();

  List<Session> get inProgressSessions =>
      _sessions.where((s) => s.status == SessionStatus.inProgress).toList();

  List<Session> get completedSessions =>
      _sessions.where((s) => s.status == SessionStatus.completed).toList();

  Lecture? lectureForSession(String sessionId) {
    try {
      return _lectures.firstWhere((l) => l.sessionId == sessionId);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _dataService.loadSessions(),
        _dataService.loadLectures(),
      ]);
      _sessions = results[0] as List<Session>;
      _lectures = results[1] as List<Lecture>;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void markAttendance(String sessionId, String studentId, AttendanceStatus status) {
    final session = _sessions.firstWhere((s) => s.id == sessionId);
    final student = session.students.firstWhere((s) => s.id == studentId);
    student.attendance = status;
    notifyListeners();
  }

  void markAllAttendance(String sessionId, AttendanceStatus status) {
    final session = _sessions.firstWhere((s) => s.id == sessionId);
    for (final student in session.students) {
      student.attendance = status;
    }
    notifyListeners();
  }
}
