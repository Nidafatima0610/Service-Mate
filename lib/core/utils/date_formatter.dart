import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _displayDateFormat = DateFormat('EEE, MMM d, yyyy');
  static final DateFormat _shortDateFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _dayOfWeekFormat = DateFormat('EEE');
  static final DateFormat _dayNumFormat = DateFormat('d');
  static final DateFormat _monthFormat = DateFormat('MMM');
  static final DateFormat _isoFormat = DateFormat('yyyy-MM-dd');

  static String formatFullDate(DateTime date) => _displayDateFormat.format(date);
  static String formatShortDate(DateTime date) => _shortDateFormat.format(date);
  static String formatDayOfWeek(DateTime date) => _dayOfWeekFormat.format(date);
  static String formatDayNumber(DateTime date) => _dayNumFormat.format(date);
  static String formatMonth(DateTime date) => _monthFormat.format(date);
  static String toIsoDateString(DateTime date) => _isoFormat.format(date);

  static DateTime? parseIsoDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return _isoFormat.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  /// Check if date is in the past (before today 00:00:00)
  static bool isPastDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.isBefore(today);
  }

  /// Generate next N selectable business/booking dates starting today
  static List<DateTime> getUpcomingDates([int count = 14]) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(count, (index) => today.add(Duration(days: index)));
  }
}

