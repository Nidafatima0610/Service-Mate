enum SlotPeriod {
  morning,
  afternoon,
  evening,
}

class TimeSlot {
  final String id;
  final String label; // e.g. "09:00 AM"
  final SlotPeriod period;
  final bool isAvailable;

  const TimeSlot({
    required this.id,
    required this.label,
    required this.period,
    this.isAvailable = true,
  });

  String get periodLabel {
    switch (period) {
      case SlotPeriod.morning:
        return 'Morning';
      case SlotPeriod.afternoon:
        return 'Afternoon';
      case SlotPeriod.evening:
        return 'Evening';
    }
  }

  static List<TimeSlot> get standardSlots => const [
        TimeSlot(id: '09_00', label: '09:00 AM', period: SlotPeriod.morning),
        TimeSlot(id: '10_30', label: '10:30 AM', period: SlotPeriod.morning),
        TimeSlot(id: '12_00', label: '12:00 PM', period: SlotPeriod.afternoon),
        TimeSlot(id: '01_30', label: '01:30 PM', period: SlotPeriod.afternoon),
        TimeSlot(id: '03_00', label: '03:00 PM', period: SlotPeriod.afternoon),
        TimeSlot(id: '04_30', label: '04:30 PM', period: SlotPeriod.evening),
        TimeSlot(id: '06_00', label: '06:00 PM', period: SlotPeriod.evening),
      ];
}

