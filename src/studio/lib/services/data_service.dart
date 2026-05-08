import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

class DataService {
  Future<List<DeliveryMode>> loadDeliveryModes() async {
    final jsonString = await rootBundle.loadString('assets/delivery_modes.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => DeliveryMode.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Course>> loadCourses() async {
    final jsonString = await rootBundle.loadString('assets/courses.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> loadStudentsData() async {
    final jsonString = await rootBundle.loadString('assets/students.json');
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<List<Student>> loadStudents() async {
    final data = await loadStudentsData();
    final List<dynamic> jsonList = data['students'] as List<dynamic>;
    return jsonList
        .map((e) => Student.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Organization>> loadOrganizations() async {
    final data = await loadStudentsData();
    final List<dynamic> jsonList = data['organizations'] as List<dynamic>;
    return jsonList
        .map((e) => Organization.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Contract>> loadContracts() async {
    final data = await loadStudentsData();
    final List<dynamic> jsonList = data['contracts'] as List<dynamic>;
    return jsonList
        .map((e) => Contract.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Enrollment>> loadEnrollments() async {
    final data = await loadStudentsData();
    final List<dynamic> jsonList = data['enrollments'] as List<dynamic>;
    return jsonList
        .map((e) => Enrollment.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
