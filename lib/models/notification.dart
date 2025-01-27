import 'dart:convert';

class Notification {
  final String user;
  final String title;
  final String message;
  final bool isRead;
  final String? link;
  final DateTime createdAt;

  Notification(
      {required this.user,
      required this.title,
      required this.message,
      this.isRead = false,
      this.link,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'user': user, 
      'title': title,
      'message': message,
      'isRead': isRead,
      'link': link,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      user: map['user'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      isRead: map['isRead'] ?? false,
      link: map['link'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());
  factory Notification.fromJson(String source) => Notification.fromMap(json.decode(source));
}
