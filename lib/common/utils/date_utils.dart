import 'package:intl/intl.dart';

String formatDate(String dateString, {String? format}) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat(format ?? 'yyyy-MM-dd').format(dateTime);
}

String formatDateObj(DateTime date, {String? format}) {
  return DateFormat(format ?? 'yyyy-MM-dd').format(date);
}

DateTime getCurrentDateTime() => DateTime.now();

DateTime addDays(int days, DateTime date) {
  return date.add(Duration(days: days));
}
