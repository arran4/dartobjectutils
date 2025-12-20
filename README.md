# dartobjectutils

dartobjectutils provides helper functions to safely extract values from untyped objects (`Map<String, dynamic>`) and marshal them into Dart classes. These utilities help avoid runtime errors when parsing JSON or other data sources by validating and converting properties on the fly.

## Why it exists

When working with Dart, especially when interfacing with JSON APIs, you often deal with `Map<String, dynamic>`. Accessing fields directly can be unsafe if the data doesn't match your expectations (e.g., missing keys, wrong types, null values).

This library helps validate and convert.

## How it helps

* **Type safety**: The helper functions ensure that the values you extract have the correct type.
* **Null safety**: The helper functions handle null and undefined values gracefully, preventing runtime errors.
* **Code clarity**: The helper functions make your code more readable and easier to understand.
* **Reduced boilerplate**: The helper functions reduce the amount of boilerplate code you need to write.

## Installation

```bash
dart pub add dartobjectutils
```

## Usage

Below is a simplified User model showing the intended pattern, adapted from the TypeScript version.

```dart
import 'package:dartobjectutils/dartobjectutils.dart';

// Helper class for User settings
class UserSettings {
  final String theme;

  UserSettings({
    Map<String, dynamic>? props,
  }) : theme = getStringPropOrDefault(props, 'Theme', 'light');
}

// User class using the helper functions
class User {
  final String userUID;
  final String email;
  final String name;
  final UserSettings settings;
  final List<String> tags;
  final DateTime? created;
  final bool active;

  User({
    Map<String, dynamic>? props,
  })  : userUID = getStringPropOrDefault(props, 'UserUID', ''),
        email = getStringPropOrDefault(props, 'Email', ''),
        name = getStringPropOrDefault(props, 'Name', ''),
        settings = getObjectFunctionPropOrThrow(
            props, 'Settings', (p) => UserSettings(props: p)),
        tags = getStringArrayPropOrDefault(props, 'Tags', <String>[]),
        created = getDatePropOrDefault(props, 'Created', null),
        active = getBooleanPropOrDefault(props, 'Active', false);
}
```

Common helpers can also be used independently:

```dart
final lastLogin = getDatePropOrDefault(rawUser, 'LastLogin', DateTime.now());
final settings = getObjectFunctionPropOrThrow(rawUser, 'Settings', (p) => UserSettings(props: p));
final roles = getStringArrayPropOrDefault(rawUser, 'Roles', <String>[]);
final isAdmin = getBooleanPropOrDefault(rawUser, 'IsAdmin', false);
```

## API Summary

### String
* `getStringPropOrDefault`, `getStringPropOrDefaultFunction`, `getStringPropOrThrow`

### Number (int/double/num)
* `getNumberPropOrDefault`, `getNumberPropOrDefaultFunction`, `getNumberPropOrThrow`

### BigInt
* `getBigIntPropOrDefault`, `getBigIntPropOrDefaultFunction`, `getBigIntPropOrThrow`

### Boolean
* `getBooleanPropOrDefault`, `getBooleanPropOrDefaultFunction`, `getBooleanPropOrThrow`
* `getBooleanFunctionPropOrDefault`, `getBooleanFunctionPropOrDefaultFunction`

### Date
* `getDatePropOrDefault`, `getDatePropOrDefaultFunction`, `getDatePropOrThrow`

### Arrays
* `getStringArrayPropOrDefault`, `getStringArrayPropOrDefaultFunction`, `getStringArrayPropOrThrow`
* `getDateArrayPropOrDefault`, `getDateArrayPropOrDefaultFunction`, `getDateArrayPropOrThrow`
* `getNumberArrayPropOrDefault`, `getNumberArrayPropOrDefaultFunction`, `getNumberArrayPropOrThrow`
* `getBigIntArrayPropOrDefault`, `getBigIntArrayPropOrDefaultFunction`, `getBigIntArrayPropOrThrow`
* `getBooleanArrayPropOrDefault`, `getBooleanArrayPropOrDefaultFunction`, `getBooleanArrayPropOrThrow`
* `getObjectArrayPropOrDefault`, `getObjectArrayPropOrDefaultFunction`, `getObjectArrayPropOrThrow`
* `getObjectArrayFunctionPropOrDefault`, `getObjectArrayFunctionPropOrThrow`

### Object / Map
* `getObjectPropOrDefault`, `getObjectPropOrDefaultFunction`, `getObjectPropOrThrow`
* `getObjectFunctionPropOrDefault`, `getObjectFunctionPropOrThrow`
* `getObjectPropOrDefaultAllowNull`, `getObjectPropOrDefaultFunctionAllowNull`, `getObjectPropOrThrowAllowNull`
* `getObjectFunctionPropOrDefaultAllowNull`, `getObjectFunctionPropOrThrowAllowNull`
* `getMapPropOrDefault`, `getMapPropOrDefaultFunction`, `getMapPropOrThrow`

## Running tests

```bash
dart test
```

## Links

* [repository](https://github.com/arran4/dartobjectutils)
* [TS version](https://github.com/arran4/tsobjectutils)

## Definitions

```dart
/// A function that constructs an object of type [Y] from a Map.
typedef ConstructorFunc<Y> = Y Function(Map<String, dynamic> params);

/// A function that constructs an object of type [Y] from a Map or null.
typedef ConstructorFuncAllowNull<Y> = Y Function(Map<String, dynamic>? params);

R getStringPropOrDefault<R extends String?>(Map<String, dynamic>? props, String prop, R defaultValue)
R getStringPropOrDefaultFunction<R extends String?>(Map<String, dynamic>? props, String prop, R Function() defaultFunction)
R getStringPropOrThrow<R extends String?>(Map<String, dynamic>? props, String prop, {String? message})

R getNumberPropOrDefault<R extends num?>(Map<String, dynamic>? props, String prop, R defaultValue)
R getNumberPropOrDefaultFunction<R extends num?>(Map<String, dynamic>? props, String prop, R Function() defaultFunction)
R getNumberPropOrThrow<R extends num?>(Map<String, dynamic>? props, String prop, {String? message})

R getBigIntPropOrDefault<R extends BigInt?>(Map<String, dynamic>? props, String prop, R defaultValue)
R getBigIntPropOrDefaultFunction<R extends BigInt?>(Map<String, dynamic>? props, String prop, R Function() defaultFunction)
R getBigIntPropOrThrow<R extends BigInt?>(Map<String, dynamic>? props, String prop, {String? message})

bool getBooleanPropOrDefault(Map<String, dynamic>? props, String prop, bool defaultValue)
bool getBooleanPropOrDefaultFunction(Map<String, dynamic>? props, String prop, bool Function() defaultFunction)
bool getBooleanPropOrThrow(Map<String, dynamic>? props, String prop, {bool Function(dynamic v)? constructorFunc})
bool getBooleanFunctionPropOrDefault(Map<String, dynamic>? props, String prop, bool Function(dynamic v) constructorFunc, bool defaultValue)
bool getBooleanFunctionPropOrDefaultFunction(Map<String, dynamic>? props, String prop, bool Function(dynamic v) constructorFunc, bool Function() defaultValue)

R getDatePropOrDefault<R>(Map<String, dynamic>? props, String prop, R defaultValue)
R getDatePropOrDefaultFunction<R>(Map<String, dynamic>? props, String prop, R Function() defaultFunction)
DateTime getDatePropOrThrow(Map<String, dynamic>? props, String prop)

R getStringArrayPropOrDefault<R>(Map<String, dynamic>? props, String prop, R defaultValue)
R getStringArrayPropOrDefaultFunction<R>(Map<String, dynamic>? props, String prop, R Function() defaultFunction)
List<String> getStringArrayPropOrThrow(Map<String, dynamic>? props, String prop, {String? message})

R getDateArrayPropOrDefault<R>(Map<String, dynamic>? props, String prop, R defaultValue)
R getDateArrayPropOrDefaultFunction<R>(Map<String, dynamic>? props, String prop, R Function() defaultFunction)
List<DateTime> getDateArrayPropOrThrow(Map<String, dynamic>? props, String prop)

Y getObjectPropOrThrow<Y>(Map<String, dynamic>? props, String prop)
Y getObjectFunctionPropOrThrow<Y>(Map<String, dynamic>? props, String prop, ConstructorFunc<Y> constructorFunc, {String? message})
Y getObjectPropOrDefault<Y>(Map<String, dynamic>? props, String prop, Y defaultValue)
Y getObjectFunctionPropOrDefault<Y>(Map<String, dynamic>? props, String prop, ConstructorFunc<Y> constructorFunc, Y defaultValue)
Y getObjectPropOrDefaultFunction<Y>(Map<String, dynamic>? props, String prop, ConstructorFunc<Y> constructorFunc, Y Function() defaultValue)

X getObjectArrayPropOrThrow<Y, X extends List<Y>?>(Map<String, dynamic>? props, String prop)
X getObjectArrayFunctionPropOrThrow<Y, X extends List<Y>?>(Map<String, dynamic>? props, String prop, ConstructorFunc<Y> constructorFunc, {String? message})
X getObjectArrayPropOrDefault<Y, X extends List<Y>?>(Map<String, dynamic>? props, String prop, X defaultValue)
X getObjectArrayFunctionPropOrDefault<Y, X extends List<Y>?>(Map<String, dynamic>? props, String prop, ConstructorFunc<Y> constructorFunc, X defaultValue)
X getObjectArrayPropOrDefaultFunction<Y, X extends List<Y>?>(Map<String, dynamic>? props, String prop, ConstructorFunc<Y> constructorFunc, X Function() defaultValue)

Map<K, V> getMapPropOrThrow<K, V>(Map<String, dynamic>? props, String prop, {String? message})
R getMapPropOrDefault<K, V, R>(Map<String, dynamic>? props, String prop, R defaultValue)
R getMapPropOrDefaultFunction<K, V, R>(Map<String, dynamic>? props, String prop, R Function() defaultFunction)

Y getObjectPropOrThrowAllowNull<Y>(Map<String, dynamic>? props, String prop)
Y getObjectFunctionPropOrThrowAllowNull<Y>(Map<String, dynamic>? props, String prop, ConstructorFuncAllowNull<Y> constructorFunc, {String? message})
Y getObjectPropOrDefaultAllowNull<Y>(Map<String, dynamic>? props, String prop, Y defaultValue)
Y getObjectFunctionPropOrDefaultAllowNull<Y>(Map<String, dynamic>? props, String prop, ConstructorFuncAllowNull<Y> constructorFunc, Y defaultValue)
Y getObjectPropOrDefaultFunctionAllowNull<Y>(Map<String, dynamic>? props, String prop, ConstructorFuncAllowNull<Y> constructorFunc, Y Function() defaultValue)

R getNumberArrayPropOrDefault<R>(Map<String, dynamic>? props, String prop, R defaultValue)
R getNumberArrayPropOrDefaultFunction<R>(Map<String, dynamic>? props, String prop, R Function() defaultFunction)
List<num> getNumberArrayPropOrThrow(Map<String, dynamic>? props, String prop, {String? message})

R getBigIntArrayPropOrDefault<R>(Map<String, dynamic>? props, String prop, R defaultValue)
R getBigIntArrayPropOrDefaultFunction<R>(Map<String, dynamic>? props, String prop, R Function() defaultFunction)
List<BigInt> getBigIntArrayPropOrThrow(Map<String, dynamic>? props, String prop, {String? message})

R getBooleanArrayPropOrDefault<R>(Map<String, dynamic>? props, String prop, R defaultValue)
R getBooleanArrayPropOrDefaultFunction<R>(Map<String, dynamic>? props, String prop, R Function() defaultFunction)
List<bool> getBooleanArrayPropOrThrow(Map<String, dynamic>? props, String prop, {String? message})
```

## License

BSD-3-Clause
