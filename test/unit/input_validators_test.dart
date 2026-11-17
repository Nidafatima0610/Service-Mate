import 'package:flutter_test/flutter_test.dart';
import 'package:service_mate/core/utils/date_formatter.dart';
import 'package:service_mate/core/utils/input_validators.dart';

void main() {
  group('InputValidators - Name Validation', () {
    test('returns error when name is empty or whitespace', () {
      expect(InputValidators.validateName(''), isNotNull);
      expect(InputValidators.validateName('   '), isNotNull);
      expect(InputValidators.validateName(null), isNotNull);
    });

    test('returns error when name is shorter than 2 characters', () {
      expect(InputValidators.validateName('A'), contains('at least 2 characters'));
    });

    test('accepts valid names', () {
      expect(InputValidators.validateName('Alex Vance'), isNull);
      expect(InputValidators.validateName('Jane Mary-Ann'), isNull);
      expect(InputValidators.validateName("O'Connor"), isNull);
    });
  });

  group('InputValidators - Email Validation', () {
    test('rejects invalid email formats', () {
      expect(InputValidators.validateEmail(''), isNotNull);
      expect(InputValidators.validateEmail('invalid'), isNotNull);
      expect(InputValidators.validateEmail('user@'), isNotNull);
      expect(InputValidators.validateEmail('@domain.com'), isNotNull);
      expect(InputValidators.validateEmail('user@domain'), isNotNull);
    });

    test('accepts valid email addresses', () {
      expect(InputValidators.validateEmail('alex@example.com'), isNull);
      expect(InputValidators.validateEmail('internship.arrowstack@gmail.com'), isNull);
    });
  });

  group('InputValidators - Phone Number Validation', () {
    test('rejects empty, short, or invalid phone numbers', () {
      expect(InputValidators.validatePhone(''), isNotNull);
      expect(InputValidators.validatePhone('12345'), contains('at least 10 digits'));
      expect(InputValidators.validatePhone('not-a-number'), isNotNull);
    });

    test('accepts valid formatted phone numbers', () {
      expect(InputValidators.validatePhone('+1 (555) 234-5678'), isNull);
      expect(InputValidators.validatePhone('+15552345678'), isNull);
      expect(InputValidators.validatePhone('5552345678'), isNull);
    });
  });

  group('DateFormatter & Past-Date Rejection', () {
    test('correctly identifies past date vs today vs future', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = now.add(const Duration(days: 1));

      expect(DateFormatter.isPastDate(yesterday), isTrue);
      expect(DateFormatter.isPastDate(today), isFalse);
      expect(DateFormatter.isPastDate(tomorrow), isFalse);
    });

    test('generates selectable future dates', () {
      final dates = DateFormatter.getUpcomingDates(14);
      expect(dates.length, 14);
      for (final d in dates) {
        expect(DateFormatter.isPastDate(d), isFalse);
      }
    });
  });
}

