class ChildModel {
  final String id;
  final String name;
  final DateTime birthDate;
  final String gender; // 'Lalaki' or 'Babae'
  final String bloodType;
  final List<GrowthRecord> growthHistory;
  final String barangay;
  final String parentEmail;

  ChildModel({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.bloodType,
    required this.growthHistory,
    required this.barangay,
    required this.parentEmail,
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
              ?.map((e) => GrowthRecord.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
      barangay: (json['barangay'] as String?) ?? 'Sabang',
      parentEmail: (json['parentEmail'] as String?) ?? 'magulang.demo@gmail.com',
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
      'barangay': barangay,
      'parentEmail': parentEmail,
    };
  }

  ChildModel copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    String? gender,
    String? bloodType,
    List<GrowthRecord>? growthHistory,
    String? barangay,
    String? parentEmail,
  }) {
    return ChildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      growthHistory: growthHistory ?? this.growthHistory,
      barangay: barangay ?? this.barangay,
      parentEmail: parentEmail ?? this.parentEmail,
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
    final months = (ageInYears * 12).round();
    final value = bmi;

    if (months < 72) {
      // 0-71 months -> Weight-for-Age, Length/Height-for-Age, Weight-for-Length
      
      // 1. Weight-for-Age
      final expectedWeight = 3.2 + (months * 0.26);
      String wfa;
      if (weight < expectedWeight * 0.8) {
        wfa = 'Kulang sa Timbang (Underweight)';
      } else if (weight > expectedWeight * 1.25) {
        wfa = 'Sobra sa Timbang (Overweight)';
      } else {
        wfa = 'Normal';
      }

      // 2. Length/Height-for-Age
      double expectedHeight = 50.0;
      if (months <= 24) {
        expectedHeight = 50.0 + (months * 1.25);
      } else {
        expectedHeight = 80.0 + ((months - 24) * 0.6);
      }
      String hfa;
      if (height < expectedHeight * 0.9) {
        hfa = 'Bansot (Stunted)';
      } else if (height > expectedHeight * 1.1) {
        hfa = 'Matangkad (Tall)';
      } else {
        hfa = 'Normal';
      }

      // 3. Weight-for-Length/Height
      String wfl;
      if (value < 13.5) {
        wfl = 'Kulang sa Timbang (Wasted)';
      } else if (value < 17.5) {
        wfl = 'Normal';
      } else if (value < 19.5) {
        wfl = 'Sobra sa Timbang (Overweight)';
      } else {
        wfl = 'Obese / Labis ang Timbang';
      }

      return 'Weight-for-Age: $wfa | Length/Height-for-Age: $hfa | Weight-for-Length: $wfl';
    } else {
      // 6-19 years -> BMI-for-Age
      if (ageInYears < 10) {
        if (value < 13.0) return 'BMI-for-Age: Kulang sa Timbang (Wasted)';
        if (value < 18.5) return 'BMI-for-Age: Normal';
        if (value < 21.0) return 'BMI-for-Age: Sobra sa Timbang (Overweight)';
        return 'BMI-for-Age: Obese / Labis ang Timbang';
      } else if (ageInYears <= 19) {
        if (value < 14.5) return 'BMI-for-Age: Kulang sa Timbang (Wasted)';
        if (value < 23.0) return 'BMI-for-Age: Normal';
        if (value < 26.5) return 'BMI-for-Age: Sobra sa Timbang (Overweight)';
        return 'BMI-for-Age: Obese / Labis ang Timbang';
      } else {
        if (value < 18.5) return 'BMI-for-Age: Kulang sa Timbang (Underweight)';
        if (value < 25.0) return 'BMI-for-Age: Normal';
        if (value < 30.0) return 'BMI-for-Age: Sobra sa Timbang (Overweight)';
        return 'BMI-for-Age: Obese / Labis ang Timbang';
      }
    }
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
