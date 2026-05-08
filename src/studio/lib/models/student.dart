enum StudentType {
  paid,
  vip,
  free;

  String get label {
    switch (this) {
      case StudentType.paid:
        return '付费学员';
      case StudentType.vip:
        return 'VIP学员';
      case StudentType.free:
        return '免费学员';
    }
  }

  static StudentType fromString(String value) {
    switch (value) {
      case 'paid':
        return StudentType.paid;
      case 'vip':
        return StudentType.vip;
      case 'free':
        return StudentType.free;
      default:
        throw ArgumentError('Unknown student type: $value');
    }
  }
}

class Student {
  final String id;
  final String name;
  final StudentType type;
  final String organizationId;

  const Student({
    required this.id,
    required this.name,
    required this.type,
    required this.organizationId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
      type: StudentType.fromString(json['type'] as String),
      organizationId: json['organization_id'] as String,
    );
  }
}

class Organization {
  final String id;
  final String name;
  final String type;

  const Organization({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }
}

class Customer {
  final String id;
  final String name;
  final String organizationId;

  const Customer({
    required this.id,
    required this.name,
    required this.organizationId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      organizationId: json['organization_id'] as String,
    );
  }
}

class Contract {
  final String id;
  final String organizationId;
  final String classId;
  final String deliveryModeId;
  final double amount;

  const Contract({
    required this.id,
    required this.organizationId,
    required this.classId,
    required this.deliveryModeId,
    required this.amount,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      classId: json['class_id'] as String,
      deliveryModeId: json['delivery_mode_id'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class Enrollment {
  final String id;
  final String studentId;
  final String classId;
  final DateTime enrolledAt;

  const Enrollment({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.enrolledAt,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      classId: json['class_id'] as String,
      enrolledAt: DateTime.parse(json['enrolled_at'] as String),
    );
  }
}
