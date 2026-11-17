import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final int serviceCount;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.serviceCount = 0,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: _getIconData(json['icon'] as String?),
      description: json['description'] as String? ?? '',
      serviceCount: (json['serviceCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint.toString(),
      'description': description,
      'serviceCount': serviceCount,
    };
  }

  static IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'cleaning':
      case 'home_cleaning':
        return Icons.cleaning_services_rounded;
      case 'beauty':
      case 'beauty_salon':
        return Icons.spa_rounded;
      case 'repair':
      case 'home_repair':
        return Icons.home_repair_service_rounded;
      case 'fitness':
      case 'personal_training':
        return Icons.fitness_center_rounded;
      case 'photography':
        return Icons.camera_alt_rounded;
      case 'tutoring':
        return Icons.school_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceCategory && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

