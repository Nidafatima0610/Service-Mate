class ServiceModel {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String description;
  final double price;
  final int durationMinutes;
  final String providerName;
  final double providerRating;
  final int reviewCount;
  final bool isFeatured;
  final bool isPopular;
  final List<String> includes;
  final String? badge;
  final String iconType;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.providerName,
    this.providerRating = 4.8,
    this.reviewCount = 50,
    this.isFeatured = false,
    this.isPopular = false,
    this.includes = const [],
    this.badge,
    this.iconType = 'cleaning',
  });

  String get durationString {
    if (durationMinutes < 60) {
      return '$durationMinutes mins';
    }
    final hours = durationMinutes ~/ 60;
    final mins = durationMinutes % 60;
    if (mins == 0) {
      return hours == 1 ? '1 hour' : '$hours hours';
    }
    return '$hours hr $mins min';
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      providerName: json['providerName'] as String,
      providerRating: (json['providerRating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 50,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isPopular: json['isPopular'] as bool? ?? false,
      includes: (json['includes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      badge: json['badge'] as String?,
      iconType: json['iconType'] as String? ?? 'cleaning',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'description': description,
      'price': price,
      'durationMinutes': durationMinutes,
      'providerName': providerName,
      'providerRating': providerRating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'isPopular': isPopular,
      'includes': includes,
      'badge': badge,
      'iconType': iconType,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

