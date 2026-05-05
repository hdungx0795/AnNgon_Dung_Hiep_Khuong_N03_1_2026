class NguoiDung {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String passwordHash;
  final String avatarPath;

  const NguoiDung({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.passwordHash,
    required this.avatarPath,
  });

  String getDisplayName() {
    return name.trim().isEmpty ? 'Nguoi dung' : name;
  }

  String getMaskedPhone() {
    if (phone.length <= 4) return phone;
    final visibleTail = phone.substring(phone.length - 4);
    return '${'*' * (phone.length - 4)}$visibleTail';
  }

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      passwordHash: json['passwordHash'] as String? ?? '',
      avatarPath: json['avatarPath'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'passwordHash': passwordHash,
      'avatarPath': avatarPath,
    };
  }

  NguoiDung copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? passwordHash,
    String? avatarPath,
  }) {
    return NguoiDung(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  @override
  String toString() {
    return 'NguoiDung(id: $id, name: $name, phone: $phone, email: $email, avatarPath: $avatarPath)';
  }
}
