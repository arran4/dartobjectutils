import 'package:dartobjectutils/dartobjectutils.dart';

void main() {
  var map = {'key': 'value'};
  var val = getStringPropOrDefault(map, 'key', 'default');
  print('value: $val');
}
