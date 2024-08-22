// lib/models/notification.dart
import 'dart:convert';

class AppNotification {
  final String id;
  final String userId;
  final String createdBy;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.createdBy,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'createdBy': createdBy,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] as String,
      userId: map['userId'] as String,
      createdBy: map['createdBy'] as String,
      message: map['message'] as String,
      type: map['type'] as String,
      isRead: map['isRead'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppNotification.fromJson(String source) =>
      AppNotification.fromMap(json.decode(source) as Map<String, dynamic>);

  AppNotification copyWith({
    String? id,
    String? userId,
    String? createdBy,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdBy: createdBy ?? this.createdBy,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'AppNotification(id: $id, userId: $userId, createdBy: $createdBy, message: $message, type: $type, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant AppNotification other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.createdBy == createdBy &&
        other.message == message &&
        other.type == type &&
        other.isRead == isRead &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        createdBy.hashCode ^
        message.hashCode ^
        type.hashCode ^
        isRead.hashCode ^
        createdAt.hashCode;
  }
}
