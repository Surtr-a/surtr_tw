import 'package:logging/logging.dart';

final Logger _log = Logger('TimeUtil');
class TimeUtil {
  /// calculates the time interval from the current time and converts it to [String]
  static String getTimeIntervalStr(DateTime createAt) {
    String timeIntervalStr;

    var duration = DateTime.now().difference(createAt);
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    if (days == 0) {
      if (hours == 0) {
        timeIntervalStr = '${minutes}m';
      } else {
        timeIntervalStr = '${hours}h';
      }
    } else if (days < 7) {
      timeIntervalStr = '${days}d';
    } else {
      timeIntervalStr = '${createAt.day} ${_month[createAt.month]}';
    }

    return timeIntervalStr;
  }

  static const Map<int, String> _month = {
    01: 'Jan',
    02: 'Feb',
    03: 'Mar',
    04: 'Apr',
    05: 'May',
    06: 'Jun',
    07: 'Jul',
    08: 'Aug',
    09: 'Sept',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };
}
