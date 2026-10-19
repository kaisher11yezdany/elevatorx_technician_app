class Technician {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String employeeId;
  final String? profilePhoto;
  final String department;
  final List<String> skills;
  final String role;
  final String territory;
  final String status;
  final DateTime createdAt;

  Technician({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.employeeId,
    this.profilePhoto,
    required this.department,
    required this.skills,
    required this.role,
    required this.territory,
    required this.status,
    required this.createdAt,
  });

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      employeeId: json['employeeId'] ?? '',
      profilePhoto: json['profilePhoto'],
      department: json['department'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      role: json['role'] ?? 'Technician',
      territory: json['territory'] ?? '',
      status: json['status'] ?? 'Active',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'employeeId': employeeId,
    'profilePhoto': profilePhoto,
    'department': department,
    'skills': skills,
    'role': role,
    'territory': territory,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };
}

class AuthResponse {
  final String token;
  final Technician technician;

  AuthResponse({required this.token, required this.technician});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      technician: Technician.fromJson(json['technician'] ?? {}),
    );
  }
}
