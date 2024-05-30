 import 'package:bingo_game/public/datetimes.format.dart';

final format = StringFormat();
getTomorrow(DateTime today) {
    final tmr = DateTime(today.year, today.month, today.day + 1);
    return tmr;
}

 getDateMonth(DateTime today) {
    final firstDayOfMonth = DateTime(today.year, today.month, 1);
    final lastDayOfMonth = DateTime(today.year, today.month + 1, 0);
    return [
      format.formatDate(firstDayOfMonth),
      format.formatDate(lastDayOfMonth)
    ];
 }

 getDateWeek(DateTime today) {
    final weekDay = today.weekday;
    final firstDayOfWeek = today.subtract(Duration(days: weekDay - 1));
    final lastDayOfWeek = today.subtract(Duration(days: weekDay - 7));
    return [
      format.formatDate(firstDayOfWeek),
      format.formatDate(lastDayOfWeek)
    ];
 }