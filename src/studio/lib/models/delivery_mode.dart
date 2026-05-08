enum DeliveryModeCategory {
  schoolEnterpriseCoop,
  trainingBase,
  internalTeaching,
  oneOnOne;

  String get label {
    switch (this) {
      case DeliveryModeCategory.schoolEnterpriseCoop:
        return '校企合作';
      case DeliveryModeCategory.trainingBase:
        return '实训基地';
      case DeliveryModeCategory.internalTeaching:
        return '内部教学';
      case DeliveryModeCategory.oneOnOne:
        return '一对一';
    }
  }

  String get description {
    switch (this) {
      case DeliveryModeCategory.schoolEnterpriseCoop:
        return '与高校合作开展的课程项目';
      case DeliveryModeCategory.trainingBase:
        return '在实训基地开展的实践培训';
      case DeliveryModeCategory.internalTeaching:
        return '组织内部的培训教学';
      case DeliveryModeCategory.oneOnOne:
        return '一对一个性化辅导';
    }
  }

  static DeliveryModeCategory fromString(String value) {
    switch (value) {
      case 'school_enterprise_coop':
        return DeliveryModeCategory.schoolEnterpriseCoop;
      case 'training_base':
        return DeliveryModeCategory.trainingBase;
      case 'internal_teaching':
        return DeliveryModeCategory.internalTeaching;
      case 'one_on_one':
        return DeliveryModeCategory.oneOnOne;
      default:
        throw ArgumentError('Unknown delivery mode: $value');
    }
  }
}

class DeliveryMode {
  final String id;
  final DeliveryModeCategory category;
  final bool requiresPartner;
  final int maxStudents;
  final String billingMethod;

  const DeliveryMode({
    required this.id,
    required this.category,
    required this.requiresPartner,
    required this.maxStudents,
    required this.billingMethod,
  });

  factory DeliveryMode.fromJson(Map<String, dynamic> json) {
    return DeliveryMode(
      id: json['id'] as String,
      category: DeliveryModeCategory.fromString(json['category'] as String),
      requiresPartner: json['requires_partner'] as bool,
      maxStudents: json['max_students'] as int,
      billingMethod: json['billing_method'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'requires_partner': requiresPartner,
      'max_students': maxStudents,
      'billing_method': billingMethod,
    };
  }
}
