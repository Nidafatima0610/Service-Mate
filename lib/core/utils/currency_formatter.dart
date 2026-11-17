import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  static String format(double amount) {
    if (amount == amount.roundToDouble()) {
      return _compactCurrencyFormat.format(amount);
    }
    return _currencyFormat.format(amount);
  }

  static String formatWithDecimals(double amount) {
    return _currencyFormat.format(amount);
  }
}

