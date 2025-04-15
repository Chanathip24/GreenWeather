import 'package:intl/intl.dart';

class TimeService {
  static String getCurrentTime(String time) {
    final utcTime = DateTime.parse(time);

    final thaiTime = utcTime.toUtc().add(const Duration(hours: 7));
    final thaiTimeFormatted = DateFormat('E, d/M').format(thaiTime);
    return thaiTimeFormatted;
  }
}
