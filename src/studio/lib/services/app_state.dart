import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'data_service.dart';

class AppState extends ChangeNotifier {
  final DataService _dataService;

  AppState({DataService? dataService}) : _dataService = dataService ?? DataService();

  List<Session> _sessions = [];
  bool _isLoading = false;
  String? _error;

  List<Session> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Session> get upcomingSessions =>
      _sessions.where((s) => s.status == SessionStatus.upcoming).toList();

  List<Session> get inProgressSessions =>
      _sessions.where((s) => s.status == SessionStatus.inProgress).toList();

  List<Session> get completedSessions =>
      _sessions.where((s) => s.status == SessionStatus.completed).toList();

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sessions = await _dataService.loadSessions();
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
