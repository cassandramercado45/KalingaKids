class ChildModel {
  final String id;
  final String name;
  final DateTime birthDate;
  final String gender; // 'Lalaki' or 'Babae'
  final String bloodType;
  final List<GrowthRecord> growthHistory;

  ChildModel({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.bloodType,
    required this.growthHistory,
  });

  // Calculate age in years and months
  Map<String, int> get age {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    if (now.day < birthDate.day) {
      months--;
    }
    if (months < 0) {
      years--;
      months += 12;
    }
    return {'years': years, 'months': months};
  }

  String get ageString {
    final ageMap = age;
    return 'Edad: ${ageMap['years']} taon at ${ageMap['months']} buwan';
  }

  Map<String, int> getAgeAt(DateTime date) {
    int years = date.year - birthDate.year;
    int months = date.month - birthDate.month;
    if (date.day < birthDate.day) {
      months--;
    }
    if (months < 0) {
      years--;
      months += 12;
    }
    return {'years': years, 'months': months};
  }

  String getAgeStringAt(DateTime date) {
    final ageMap = getAgeAt(date);
    if (ageMap['years'] == 0) {
      return '${ageMap['months']} buwan';
    }
    return '${ageMap['years']} taon at ${ageMap['months']} buwan';
  }

  // Get latest growth record
  GrowthRecord? get latestRecord {
    if (growthHistory.isEmpty) return null;
    final sorted = List<GrowthRecord>.from(growthHistory)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.first;
  }

  // Factory to convert JSON/Map to ChildModel
  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] as String,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      gender: json['gender'] as String,
      bloodType: json['bloodType'] as String,
      growthHistory: (json['growthHistory'] as List<dynamic>?)
              ?.map((e) => GrowthRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Convert ChildModel to JSON/Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'bloodType': bloodType,
      'growthHistory': growthHistory.map((e) => e.toJson()).toList(),
    };
  }

  ChildModel copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    String? gender,
    String? bloodType,
    List<GrowthRecord>? growthHistory,
  }) {
    return ChildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      growthHistory: growthHistory ?? this.growthHistory,
    );
  }
}

class GrowthRecord {
  final String id;
  final DateTime date;
  final double height; // in cm
  final double weight; // in kg

  GrowthRecord({
    required this.id,
    required this.date,
    required this.height,
    required this.weight,
  });

  double get bmi {
    if (height <= 0) return 0.0;
    return weight / ((height / 100) * (height / 100));
  }

  String getBmiInterpretation(double ageInYears) {
    final value = bmi;
    if (ageInYears < 2) {
      if (value < 14.0) return 'Underweight';
      if (value < 18.0) return 'Normal';
      if (value < 20.0) return 'Overweight';
      return 'Obese';
    }
    if (ageInYears < 5) {
      if (value < 13.5) return 'Underweight';
      if (value < 17.5) return 'Normal';
      if (value < 19.5) return 'Overweight';
      return 'Obese';
    }
    if (ageInYears < 10) {
      if (value < 13.0) return 'Underweight';
      if (value < 18.5) return 'Normal';
      if (value < 21.0) return 'Overweight';
      return 'Obese';
    }
    if (ageInYears <= 19) {
      if (value < 14.5) return 'Underweight';
      if (value < 23.0) return 'Normal';
      if (value < 26.5) return 'Overweight';
      return 'Obese';
    }
    if (value < 18.5) return 'Underweight';
    if (value < 25.0) return 'Normal';
    if (value < 30.0) return 'Overweight';
    return 'Obese';
  }

  String get bmiInterpretation {
    return getBmiInterpretation(19.0);
  }

  factory GrowthRecord.fromJson(Map<String, dynamic> json) {
    return GrowthRecord(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'height': height,
      'weight': weight,
    };
  }
}
