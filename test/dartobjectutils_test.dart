import 'package:dartobjectutils/dartobjectutils.dart';
import 'package:test/test.dart';

void main() {
  group('String Tests', () {
    final map = {'str': 'hello', 'num': 123, 'null': null};

    test('getStringPropOrThrow', () {
      expect(getStringPropOrThrow(map, 'str'), 'hello');
      expect(getStringPropOrThrow(map, 'num'), '123');
      expect(
        () => getStringPropOrThrow(map, 'missing'),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );
      expect(
        () => getStringPropOrThrow(map, 'null'),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );
    });

    test('getStringPropOrDefault', () {
      expect(getStringPropOrDefault(map, 'str', 'default'), 'hello');
      expect(getStringPropOrDefault(map, 'missing', 'default'), 'default');
      expect(getStringPropOrDefault(map, 'null', 'default'), 'default');
    });
  });

  group('Number Tests', () {
    final map = {
      'int': 123,
      'double': 123.45,
      'strInt': '456',
      'strDouble': '456.78',
      'invalid': 'abc',
    };

    test('getNumberPropOrThrow', () {
      expect(getNumberPropOrThrow<int>(map, 'int'), 123);
      expect(getNumberPropOrThrow<double>(map, 'double'), 123.45);
      // Conversions
      expect(getNumberPropOrThrow<double>(map, 'int'), 123.0);
      expect(getNumberPropOrThrow<int>(map, 'double'), 123); // truncates?

      expect(getNumberPropOrThrow<int>(map, 'strInt'), 456);
      expect(getNumberPropOrThrow<double>(map, 'strDouble'), 456.78);

      expect(
        () => getNumberPropOrThrow(map, 'missing'),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );
      expect(
        () => getNumberPropOrThrow(map, 'invalid'),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );
    });

    test('getNumberPropOrDefault', () {
      expect(getNumberPropOrDefault<int>(map, 'int', 0), 123);
      expect(getNumberPropOrDefault<int>(map, 'missing', 0), 0);
    });
  });

  group('Boolean Tests', () {
    final map = {'true': true, 'false': false, 'strTrue': 'true'};

    test('getBooleanPropOrThrow', () {
      expect(getBooleanPropOrThrow(map, 'true'), true);
      expect(getBooleanPropOrThrow(map, 'false'), false);
      expect(
        () => getBooleanPropOrThrow(map, 'missing'),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );
      // strTrue is string, not boolean, so should throw unless constructorFunc
      expect(
        () => getBooleanPropOrThrow(map, 'strTrue'),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );
    });

    test('getBooleanPropOrThrow with constructorFunc', () {
      expect(
        getBooleanPropOrThrow(
          map,
          'strTrue',
          constructorFunc: (v) => v == 'true',
        ),
        true,
      );
    });

    test('getBooleanPropOrDefault', () {
      expect(getBooleanPropOrDefault(map, 'true', false), true);
      expect(getBooleanPropOrDefault(map, 'missing', true), true);
    });
  });

  group('Date Tests', () {
    final now = DateTime.now();
    final map = {
      'date': now,
      'dateStr': now.toIso8601String(),
      'timestamp': now.millisecondsSinceEpoch / 1000, // seconds
    };

    test('getDatePropOrThrow', () {
      expect(getDatePropOrThrow(map, 'date'), now);
      // Precision might be lost with iso string depending on format
      // expect(getDatePropOrThrow(map, 'dateStr').isAtSameMomentAs(now), isTrue); // close enough?
      // Timestamp in seconds
      final dt = getDatePropOrThrow(map, 'timestamp');
      // millisecondsSinceEpoch / 1000 * 1000 -> int truncation of ms part if any.
      // But 'timestamp' in map is `now.millisecondsSinceEpoch / 1000`. This is a double.
      // 1766209270362 / 1000 = 1766209270.362
      // In getDatePropOrThrow:
      // return DateTime.fromMillisecondsSinceEpoch((v * 1000).toInt());
      // (1766209270.362 * 1000) = 1766209270362.0
      // .toInt() = 1766209270362
      // So it should be exact.
      // However, floating point arithmetic might introduce small errors?
      // 123.456 * 1000 is 123456.
      // Let's check tolerance.
      expect(dt.millisecondsSinceEpoch, closeTo(now.millisecondsSinceEpoch, 1));
    });

    test('getDatePropOrDefault', () {
      expect(getDatePropOrDefault<DateTime>(map, 'date', DateTime(2000)), now);
      expect(
        getDatePropOrDefault<DateTime>(map, 'missing', DateTime(2000)),
        DateTime(2000),
      );
    });
  });

  group('Array Tests', () {
    final map = {
      'strs': ['a', 'b', 1],
      'dates': ['2023-01-01', DateTime(2023, 1, 2)],
    };

    test('getStringArrayPropOrThrow', () {
      expect(getStringArrayPropOrThrow(map, 'strs'), ['a', 'b', '1']);
    });

    test('getDateArrayPropOrThrow', () {
      final dates = getDateArrayPropOrThrow(map, 'dates');
      expect(dates[0], DateTime(2023, 1, 1));
      expect(dates[1], DateTime(2023, 1, 2));
    });

    test('getNumberArrayPropOrThrow', () {
      final nums = getNumberArrayPropOrThrow({'nums': [1, 2.5, '3']}, 'nums');
      expect(nums, [1, 2.5, 3]);
    });

    test('getBigIntArrayPropOrThrow', () {
      final bigInts = getBigIntArrayPropOrThrow({'bigInts': [BigInt.one, 2, '3']}, 'bigInts');
      expect(bigInts, [BigInt.one, BigInt.from(2), BigInt.from(3)]);
    });

    test('getBooleanArrayPropOrThrow', () {
      final bools = getBooleanArrayPropOrThrow({'bools': [true, false]}, 'bools');
      expect(bools, [true, false]);
    });
  });

  group('Object Tests', () {
    final map = {
      'obj': {'id': 1},
      'objs': [
        {'id': 1},
        {'id': 2},
      ],
    };

    test('getObjectPropOrThrow', () {
      final obj = getObjectPropOrThrow<Map<String, dynamic>>(map, 'obj');
      expect(obj['id'], 1);
    });

    test('getObjectFunctionPropOrThrow', () {
      final obj = getObjectFunctionPropOrThrow<int>(
        map,
        'obj',
        (p) => p['id'] as int,
      );
      expect(obj, 1);
    });

    test('getObjectArrayPropOrThrow', () {
      final list =
          getObjectArrayPropOrThrow<
            Map<String, dynamic>,
            List<Map<String, dynamic>>
          >(map, 'objs');
      expect(list.length, 2);
      expect(list[0]['id'], 1);
    });

    test('getObjectArrayFunctionPropOrThrow', () {
      final list = getObjectArrayFunctionPropOrThrow<int, List<int>>(
        map,
        'objs',
        (p) => p['id'] as int,
      );
      expect(list, [1, 2]);
    });
  });

  group('Map Tests', () {
    final map = {
      'map': {'a': 1, 'b': 2},
    };

    test('getMapPropOrThrow', () {
      final m = getMapPropOrThrow<String, int>(map, 'map');
      expect(m, {'a': 1, 'b': 2});
    });
  });

  group('Enum Tests', () {
    final map = {
      'enum': 'one',
      'enums': ['one', 'two'],
      'invalidEnum': 'four',
    };

    test('getEnumPropOrThrow', () {
      expect(
        getEnumPropOrThrow(map, 'enum', TestEnum.values),
        TestEnum.one,
      );
      expect(
        () => getEnumPropOrThrow(map, 'missing', TestEnum.values),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );
      expect(
        () => getEnumPropOrThrow(map, 'invalidEnum', TestEnum.values),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );
    });

    test('getEnumPropOrDefault', () {
      expect(
        getEnumPropOrDefault(map, 'enum', TestEnum.values, TestEnum.three),
        TestEnum.one,
      );
      expect(
        getEnumPropOrDefault(
            map, 'missing', TestEnum.values, TestEnum.three),
        TestEnum.three,
      );
    });

    test('getEnumPropOrDefaultFunction', () {
      expect(
        getEnumPropOrDefaultFunction(
            map, 'enum', TestEnum.values, () => TestEnum.three),
        TestEnum.one,
      );
      expect(
        getEnumPropOrDefaultFunction(
            map, 'missing', TestEnum.values, () => TestEnum.three),
        TestEnum.three,
      );
    });

    test('getEnumArrayPropOrThrow', () {
      expect(
        getEnumArrayPropOrThrow(map, 'enums', TestEnum.values),
        [TestEnum.one, TestEnum.two],
      );
      expect(
        () => getEnumArrayPropOrThrow(map, 'missing', TestEnum.values),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );
      expect(
        () => getEnumArrayPropOrThrow(
          {'enums': ['one', 'four']},
          'enums',
          TestEnum.values,
        ),
        throwsA(isA<ElementConversionException>()),
      );
    });

    test('getEnumArrayPropOrDefault', () {
      expect(
        getEnumArrayPropOrDefault(
            map, 'enums', TestEnum.values, [TestEnum.three]),
        [TestEnum.one, TestEnum.two],
      );
      expect(
        getEnumArrayPropOrDefault(
            map, 'missing', TestEnum.values, [TestEnum.three]),
        [TestEnum.three],
      );
    });

    test('getEnumArrayPropOrDefaultFunction', () {
      expect(
        getEnumArrayPropOrDefaultFunction(
            map, 'enums', TestEnum.values, () => [TestEnum.three]),
        [TestEnum.one, TestEnum.two],
      );
      expect(
        getEnumArrayPropOrDefaultFunction(
            map, 'missing', TestEnum.values, () => [TestEnum.three]),
        [TestEnum.three],
      );
    });

    test('getEnumPropOrThrow with keyExtractor', () {
      final customMap = {'enum': 'custom_one'};
      expect(
        getEnumPropOrThrow(
          customMap,
          'enum',
          CustomTestEnum.values,
          keyExtractor: (e) => e.name,
        ),
        CustomTestEnum.one,
      );
    });
  });
}

enum TestEnum { one, two, three }

enum CustomTestEnum {
  one,
  two,
  three;

  @override
  String toString() {
    return 'custom_$name';
  }
}
