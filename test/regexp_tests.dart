import 'package:dartobjectutils/dartobjectutils.dart';
import 'package:test/test.dart';

void main() {
  group('String Regexp Tests', () {
    final map = {
      'email': 'test@example.com',
      'username': 'user123',
      'invalid': '!!!',
      'num': 123,
    };
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final alphaNumericRegex = RegExp(r'^[a-zA-Z0-9]+$');

    test('getStringRegexpPropOrThrow', () {
      expect(
        getStringRegexpPropOrThrow(map, 'email', emailRegex),
        'test@example.com',
      );
      expect(
        getStringRegexpPropOrThrow(map, 'username', alphaNumericRegex),
        'user123',
      );

      // Mismatch
      expect(
        () => getStringRegexpPropOrThrow(map, 'invalid', alphaNumericRegex),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );

      // Missing
      expect(
        () => getStringRegexpPropOrThrow(map, 'missing', emailRegex),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );

      // Wrong type (though getStringPropOrThrow converts num to string,
      // let's see if regex matches the stringified version.
      // 123 matches ^[a-zA-Z0-9]+$
      expect(getStringRegexpPropOrThrow(map, 'num', alphaNumericRegex), '123');
    });

    test('getStringRegexpPropOrDefault', () {
      expect(
        getStringRegexpPropOrDefault(
          map,
          'email',
          emailRegex,
          'default@example.com',
        ),
        'test@example.com',
      );
      expect(
        getStringRegexpPropOrDefault(
          map,
          'invalid',
          alphaNumericRegex,
          'default',
        ),
        'default',
      );
      expect(
        getStringRegexpPropOrDefault(
          map,
          'missing',
          alphaNumericRegex,
          'default',
        ),
        'default',
      );
    });

    test('getStringRegexpPropOrDefaultFunction', () {
      expect(
        getStringRegexpPropOrDefaultFunction(
          map,
          'email',
          emailRegex,
          () => 'default@example.com',
        ),
        'test@example.com',
      );
      expect(
        getStringRegexpPropOrDefaultFunction(
          map,
          'invalid',
          alphaNumericRegex,
          () => 'default',
        ),
        'default',
      );
    });
  });

  group('String Array Regexp Tests', () {
    final map = {
      'emails': ['a@a.com', 'b@b.com'],
      'mixed': ['a@a.com', 'invalid'],
      'nums': [123, 456],
    };
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final numRegex = RegExp(r'^\d+$');

    test('getStringArrayRegexpPropOrThrow', () {
      expect(getStringArrayRegexpPropOrThrow(map, 'emails', emailRegex), [
        'a@a.com',
        'b@b.com',
      ]);

      // One invalid element should cause throw
      expect(
        () => getStringArrayRegexpPropOrThrow(map, 'mixed', emailRegex),
        throwsA(isA<MissingOrInvalidPropertyException>()),
      );

      // Also ElementConversionException or MissingOrInvalidPropertyException?
      // getStringArrayPropOrThrow returns List<String>.
      // The validation happens after.
      // I should probably implement it such that it throws if ANY element fails.

      // Numbers as strings
      expect(getStringArrayRegexpPropOrThrow(map, 'nums', numRegex), [
        '123',
        '456',
      ]);
    });

    test('getStringArrayRegexpPropOrDefault', () {
      expect(
        getStringArrayRegexpPropOrDefault(map, 'emails', emailRegex, [
          'default',
        ]),
        ['a@a.com', 'b@b.com'],
      );
      expect(
        getStringArrayRegexpPropOrDefault(map, 'mixed', emailRegex, [
          'default',
        ]),
        ['default'],
      );
    });

    test('getStringArrayRegexpPropOrDefaultFunction', () {
      expect(
        getStringArrayRegexpPropOrDefaultFunction(
          map,
          'mixed',
          emailRegex,
          () => ['default'],
        ),
        ['default'],
      );
    });
  });
}
