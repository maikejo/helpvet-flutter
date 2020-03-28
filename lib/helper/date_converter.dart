import 'package:intl/intl.dart';

class DateConverter {

  String converteTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('dd/MM/yyyy');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);

    return format.format(date);
  }
}