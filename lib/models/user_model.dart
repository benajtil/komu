import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String photoUrl;
  final String status;
  final String role;
  final bool isOnline;
  final DateTime lastActive;
  final DateTime createdAt;
  final List<String> friends;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'status': status,
      'isOnline': isOnline,
      'role': role,
      'lastActive': Timestamp.fromDate(lastActive),
      'createdAt': Timestamp.fromDate(createdAt),
      'friends': friends,
    };
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? " ",
      displayName: map['displayName'] ?? " ",
      email: map['email'] ?? " ",
      photoUrl: map['photoUrl'] ?? "",
      status: map['status'] ?? " ",
      role: map['role'] ?? " ",
      isOnline: map['isOnline'] ?? false,
      lastActive: _parseDate(map['lastActive']),
      createdAt: _parseDate(map['createdAt']),
      friends: List<String>.from(map['friends'] ?? []),
    );
  }

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.status,
    required this.isOnline,
    required this.lastActive,
    required this.createdAt,
    required this.friends,
    required this.role,
  });

  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? photoUrl,
    String? status,
    String? role,
    bool? isOnline,
    DateTime? lastActive,
    DateTime? createdAt,
    List<String>? friends,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      role: role ?? this.role,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      createdAt: createdAt ?? this.createdAt,
      friends: friends ?? this.friends,
    );
  }
}
