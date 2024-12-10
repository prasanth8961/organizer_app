import 'package:intl/intl.dart';

String formatTimeStamp(String timestamp) {
  final DateTime dateTime = DateTime.parse(timestamp);
  return DateFormat.yMMMMd().format(dateTime);
}
