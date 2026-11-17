class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final bool isDemoUser;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.isDemoUser = true,
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty || parts[0].isEmpty) return 'SM';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    bool? isDemoUser,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      isDemoUser: isDemoUser ?? this.isDemoUser,
    );
  }

  factory UserProfile.defaultProfile() {
    return const UserProfile(
      id: 'demo_user_01',
      fullName: 'Alex Vance',
      email: 'alex.vance@example.com',
      phoneNumber: '+1 (555) 234-5678',
      address: '742 Evergreen Terrace, San Francisco, CA',
      isDemoUser: true,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'user_default',
      fullName: json['fullName'] as String? ?? 'Alex Vance',
      email: json['email'] as String? ?? 'alex.vance@example.com',
      phoneNumber: json['phoneNumber'] as String? ?? '+1 (555) 234-5678',
      address: json['address'] as String? ?? 'San Francisco, CA',
      isDemoUser: json['isDemoUser'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'isDemoUser': isDemoUser,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

