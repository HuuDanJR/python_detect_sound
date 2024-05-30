import 'package:intl/intl.dart' show DateFormat;

class StringFormat {
  String formatDate(value) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(value);
    return formattedDate;
  }
  String formatDateReverse(value) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(value);
    return formattedDate;
  }
  String formatTimeHHMM(value) {
    String formattedDate = DateFormat('HH:mm').format(value);
    return formattedDate;
  }
  String formatDateMonthYear(value) {
    String formattedDate = DateFormat('MM/yyyy').format(value);
    return formattedDate;
  }

  String formatDateOnlyDay(value) {
    String formattedDate = DateFormat('dd').format(value);
    return formattedDate;
  }
  String formatDateOnlyDayText2(value) {
    String formattedDate = DateFormat('EE').format(value);
    return formattedDate;
  }

  String formatDateWithTime(value) {
    String formattedDate = DateFormat('Hms').format(value);
    return formattedDate;
  }

  DateTime formatDateWithTimeReverse(value) {
    DateTime tempDate =
         DateFormat("yyyy-MM-dd HH:mm:ss").parse(value);
    return tempDate;
  }

  String formatDateAndTime(value) {
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
    return formattedDate;
  }
  String formatTimeAndDate(value) {
    String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(value);
    return formattedDate;
  }

  String formatDateAndTime2(value) {
    String formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(value);
    return formattedDate;
  }

  String FormatTime(value) {
    String formattedDate = DateFormat('HH:mm').format(value);
    return formattedDate;
  }

  String FormatTimeFull(value) {
    String formattedDate = DateFormat('HH:mm:ss').format(value);
    return formattedDate;
  }

  String formatDateWithSplash(value) {
    String formattedDate = DateFormat('EEE dd/MM').format(value);
    return formattedDate;
  }
  String formatMonthYear(value) {
    String formattedDate = DateFormat('MMMM yyyy').format(value);
    return formattedDate;
  }
  String formatMonthNum(value) {
    String formattedDate = DateFormat('MM').format(value);
    return formattedDate;
  }
  String formatYearNum(value) {
    String formattedDate = DateFormat('yyyy').format(value);
    return formattedDate;
  }

  String formatDateWithDay(value) {
    String formattedDate = DateFormat('EEE dd').format(value);
    return formattedDate;
  }

  String formatDateOnlyDayText(value) {
    String formattedDate = DateFormat('EEE').format(value);
    return formattedDate;
  }

  String formatDateOnlyDayDD(value) {
    String formattedDate = DateFormat('EEE').format(value);
    return formattedDate;
  }

  String formatDateOnlyDayDDDate(value) {
    String formattedDate = DateFormat('EEE dd MM' ).format(value);
    return formattedDate;
  }
  String formatDateOnlyDayDDDateFull(value) {
    String formattedDate = DateFormat('EEE dd/MM/yyyy' ).format(value);
    return formattedDate;
  }
  String formatDateOnlyDayDDDateFullB(value) {
    String formattedDate = DateFormat('dd/MM/yyyy EEE' ).format(value);
    return formattedDate;
  }

  String formatDayDateTime(value) {
    String formattedDate =
        DateFormat('yyyy-MM-dd (EEE)  HH:mm:ss').format(value);
    return formattedDate;
  }
  String formatDayDateTimeDisplay(value) {
    String formattedDate =
        DateFormat('dd MMM yyyy, ').add_jm().format(value);
    return formattedDate;
  }
  String formatDayDateTimeFull(value) {
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss a').format(value);
    return formattedDate;
  }

		stringToDate(value) {
  DateTime tempDate = DateFormat("yyyy-MM-dd").parse(value);
  return tempDate;
}
}
