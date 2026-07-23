class ChatMessage {
  final String id;
  final String senderEmail;
  final String senderName;
  final String recipientEmail; // 'admin' or parent's email
  final String text;
  final DateTime date;
  final String barangay;

  ChatMessage({
    required this.id,
    required this.senderEmail,
    required this.senderName,
    required this.recipientEmail,
    required this.text,
    required this.date,
    required this.barangay,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      senderEmail: json['senderEmail'] as String,
      senderName: json['senderName'] as String,
      recipientEmail: json['recipientEmail'] as String,
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
      barangay: json['barangay'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderEmail': senderEmail,
      'senderName': senderName,
      'recipientEmail': recipientEmail,
      'text': text,
      'date': date.toIso8601String(),
      'barangay': barangay,
    };
  }
}
