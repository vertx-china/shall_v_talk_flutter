import 'package:date_format/date_format.dart';

void main() {
  var now = DateTime.now();
  var date = formatDate(now,
      ['yyyy', '-', 'mm', '-', 'dd', ' ', 'hh', ':', 'nn', ':', 'ss', ' ', 'z']);
  print('date=$date');
}
