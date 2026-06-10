import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.updatedAt,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(jsonDecode(source));

  static bool isLegacyEncryptedFormat(Map<String, dynamic> data) {
    return data.containsKey('ciphertext') ||
        data.containsKey('payload') ||
        (data.containsKey('nonce') && !data.containsKey('title'));
  }

  factory Todo.fromFirestore(Map<String, dynamic> data) {
    if (isLegacyEncryptedFormat(data)) {
      throw FormatException('Legacy encrypted todo format is no longer supported.');
    }
    return Todo(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdAt: data['createdAt'] is String
          ? DateTime.parse(data['createdAt'])
          : (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] is String
          ? DateTime.parse(data['updatedAt'])
          : (data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'sortIndex': 0, // Will be set by service
    };
  }
}
