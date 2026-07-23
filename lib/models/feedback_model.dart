class FeedbackModel {
  final String id;
  final String name;
  final String email;
  final String message;
  final DateTime date;

  FeedbackModel({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    required this.date,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      message: json['message'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'message': message,
      'date': date.toIso8601String(),
    };
  }
}
