enum BookingStatus {
  confirmed,
  inProgress,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class BookingModel {
  final String id;
  final String referenceCode;
  final String serviceId;
  final String serviceName;
  final String serviceCategory;
  final String providerName;
  final DateTime date;
  final String timeSlot;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerAddress;
  final String? specialInstructions;
  final double basePrice;
  final double serviceFee;
  final double tax;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;
  final String? cancellationReason;
  final DateTime? cancelledAt;

  const BookingModel({
    required this.id,
    required this.referenceCode,
    required this.serviceId,
    required this.serviceName,
    required this.serviceCategory,
    required this.providerName,
    required this.date,
    required this.timeSlot,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerAddress,
    this.specialInstructions,
    required this.basePrice,
    required this.serviceFee,
    required this.tax,
    required this.totalPrice,
    this.status = BookingStatus.confirmed,
    required this.createdAt,
    this.cancellationReason,
    this.cancelledAt,
  });

  bool get isUpcoming =>
      status == BookingStatus.confirmed || status == BookingStatus.inProgress;

  bool get isCompleted => status == BookingStatus.completed;

  bool get isCancelled => status == BookingStatus.cancelled;

  BookingModel copyWith({
    String? id,
    String? referenceCode,
    String? serviceId,
    String? serviceName,
    String? serviceCategory,
    String? providerName,
    DateTime? date,
    String? timeSlot,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? customerAddress,
    String? specialInstructions,
    double? basePrice,
    double? serviceFee,
    double? tax,
    double? totalPrice,
    BookingStatus? status,
    DateTime? createdAt,
    String? cancellationReason,
    DateTime? cancelledAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      referenceCode: referenceCode ?? this.referenceCode,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      providerName: providerName ?? this.providerName,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      basePrice: basePrice ?? this.basePrice,
      serviceFee: serviceFee ?? this.serviceFee,
      tax: tax ?? this.tax,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      referenceCode: json['referenceCode'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      serviceCategory: json['serviceCategory'] as String,
      providerName: json['providerName'] as String,
      date: DateTime.parse(json['date'] as String),
      timeSlot: json['timeSlot'] as String,
      customerName: json['customerName'] as String,
      customerEmail: json['customerEmail'] as String,
      customerPhone: json['customerPhone'] as String,
      customerAddress: json['customerAddress'] as String,
      specialInstructions: json['specialInstructions'] as String?,
      basePrice: (json['basePrice'] as num).toDouble(),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.confirmed,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      cancellationReason: json['cancellationReason'] as String?,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referenceCode': referenceCode,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceCategory': serviceCategory,
      'providerName': providerName,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'specialInstructions': specialInstructions,
      'basePrice': basePrice,
      'serviceFee': serviceFee,
      'tax': tax,
      'totalPrice': totalPrice,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'cancellationReason': cancellationReason,
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

