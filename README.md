# dartobjectutils

dartobjectutils provides helper functions to safely extract values from untyped objects (`Map<String, dynamic>`) and marshal them into Dart classes. These utilities help avoid runtime errors when parsing JSON or other data sources by validating and converting properties on the fly.

## Why it exists

When working with Dart, especially when interfacing with JSON APIs, you often deal with `Map<String, dynamic>`. Accessing fields directly can be unsafe if the data doesn't match your expectations (e.g., missing keys, wrong types, null values).

This library provides a set of helper functions that allow you to safely extract and convert values from these maps. This makes it easy to construct a class from loose JSON without writing repetitive null checks and type casts throughout your code.

## How it helps

By using the helper functions provided by this library, you gain the following benefits:
* **Type safety**: The helper functions ensure that the values you extract have the correct type.
* **Null safety**: The helper functions handle null and undefined values gracefully, preventing runtime errors.
* **Code clarity**: The helper functions make your code more readable and easier to understand.
* **Reduced boilerplate**: The helper functions reduce the amount of boilerplate code you need to write for JSON deserialization.

## Installation

```bash
dart pub add dartobjectutils
```

## Usage

Below is a simplified User model showing the intended pattern.

```dart
import 'package:dartobjectutils/dartobjectutils.dart';

class UserSettings {
  final String theme;

  UserSettings({
    Map<String, dynamic>? props,
  }) : theme = getStringPropOrDefault(props, 'Theme', 'light');
}

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

By relying on these helpers you gain:
* a single constructor argument for easy copying of an object
* safer unmarshalling of deserialized JSON objects

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

## Links

* [repository](https://github.com/arran4/dartobjectutils)

## License

BSD-3-Clause
