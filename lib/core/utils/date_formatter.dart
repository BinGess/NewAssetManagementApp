import 'package:intl/intl.dart';

final _dateFormat = DateFormat('yyyy-MM-dd');
final _monthFormat = DateFormat('yyyy年MM月');

/// Formats a date as 'yyyy-MM-dd'
String formatDate(DateTime date) => _dateFormat.format(date);

/// Formats a date as 'yyyy年MM月' (Chinese format)
String formatMonth(DateTime date) => _monthFormat.format(date);
