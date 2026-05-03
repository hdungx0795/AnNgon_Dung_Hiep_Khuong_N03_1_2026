import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String phone;
  
  @HiveField(3)
  final String email;
  
  @HiveField(4)
  final String dob;
  
  @HiveField(5)
  final String passwordHash;
  
  @HiveField(6)
  final String? avatarPath;
  
  @HiveField(7)
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.dob,
    required this.passwordHash,
    this.avatarPath,
    required this.createdAt,
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? dob,
    String? passwordHash,
    String? avatarPath,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      passwordHash: passwordHash ?? this.passwordHash,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
