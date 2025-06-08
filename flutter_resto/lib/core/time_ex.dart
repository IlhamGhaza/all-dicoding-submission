import 'package:intl/intl.dart';

String convertToCustomFormat(String iso8601String) {
  // Parse ISO 8601 string to DateTime
  DateTime dateTime = DateTime.parse(iso8601String);

  // Create DateFormat object for desired output format
  DateFormat formatter = DateFormat('dd/MM/yyyy');

  // Format the date
  String formattedDate = formatter.format(dateTime);

  return formattedDate;
}
