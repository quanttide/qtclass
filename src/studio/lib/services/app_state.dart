import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'data_service.dart';

class AppState extends ChangeNotifier {
  final DataService _dataService = DataService();

  List<DeliveryMode> _deliveryModes = [];
  List<Course> _courses = [];
  List<Student> _students = [];
  List<Organization> _organizations = [];
  List<Contract> _contracts = [];
  List<Enrollment> _enrollments = [];
  bool _isLoading = false;
  String? _error;

  List<DeliveryMode> get deliveryModes => _deliveryModes;
  List<Course> get courses => _courses;
  List<Student> get students => _students;
  List<Organization> get organizations => _organizations;
  List<Contract> get contracts => _contracts;
  List<Enrollment> get enrollments => _enrollments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _dataService.loadDeliveryModes(),
        _dataService.loadCourses(),
        _dataService.loadStudents(),
        _dataService.loadOrganizations(),
        _dataService.loadContracts(),
        _dataService.loadEnrollments(),
      ]);

      _deliveryModes = results[0] as List<DeliveryMode>;
      _courses = results[1] as List<Course>;
      _students = results[2] as List<Student>;
      _organizations = results[3] as List<Organization>;
      _contracts = results[4] as List<Contract>;
      _enrollments = results[5] as List<Enrollment>;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  DeliveryMode? deliveryModeById(String id) {
    try {
      return _deliveryModes.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  Organization? organizationById(String id) {
    try {
      return _organizations.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Student? studentById(String id) {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Class> classesByCourseId(String courseId) {
    final course = _courses.firstWhere((c) => c.id == courseId);
    return course.classes;
  }

  List<Enrollment> enrollmentsByClassId(String classId) {
    return _enrollments.where((e) => e.classId == classId).toList();
  }
}
