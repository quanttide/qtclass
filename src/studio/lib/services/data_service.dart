import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

class DataService {
  Future<List<Session>> loadSessions() async {
    final jsonString = await rootBundle.loadString('assets/sessions.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => Session.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
