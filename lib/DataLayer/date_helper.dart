library date_helper;

import 'package:intl/intl.dart';

DateFormat dateFormat = DateFormat("MMMM yyyy");

String convertDateToString(DateTime currentMonth) {
  return dateFormat.format(currentMonth);
}

DateTime convertStringToDate(String currentMonth) {
  return dateFormat.parse(currentMonth);
}

DateTime convertToStartOfMonth(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month);
}

String convertToStartOfLastMonth(String date){
  DateTime current = convertStringToDate(date);
  DateTime previousMonth = DateTime(current.year, current.month-1);
  return convertDateToString(previousMonth);
}

String convertToStartOfNextMonth(String date){
  DateTime current = convertStringToDate(date);
  DateTime previousMonth = DateTime(current.year, current.month+1);
  return convertDateToString(previousMonth);
}


