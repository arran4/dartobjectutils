import 'package:dartobjectutils/dartobjectutils.dart';
import 'dart:core';

class MyEnum {
  final String name;
  const MyEnum(this.name);
  @override
  String toString() => "MyEnum.$name";
}

void main() {
  // Setup
  // Make these large enough to show a difference.
  // 1000 enum values
  // 10000 input elements
  final int enumSize = 1000;
  final int inputSize = 10000;

  final values = List.generate(enumSize, (i) => MyEnum('val$i'));
  // Create inputs that are scattered across the enum values
  final inputList = List.generate(inputSize, (i) => 'val${i % enumSize}');

  final map = {'data': inputList};

  print('Running benchmark with enumSize=$enumSize, inputSize=$inputSize');

  // Warmup
  print('Warming up...');
  for (int i = 0; i < 5; i++) {
    getEnumArrayPropOrThrow(map, 'data', values);
  }

  // Measure
  print('Measuring...');
  final stopwatch = Stopwatch()..start();
  final iterations = 20;
  for (int i = 0; i < iterations; i++) {
    getEnumArrayPropOrThrow(map, 'data', values);
  }
  stopwatch.stop();

  print('Total time: ${stopwatch.elapsedMilliseconds} ms');
  print('Average time: ${stopwatch.elapsedMilliseconds / iterations} ms');
}
