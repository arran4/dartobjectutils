// ignore_for_file: constant_identifier_names

import 'errors.dart';

/// A function that constructs an object of type [Y] from a Map.
typedef ConstructorFunc<Y> = Y Function(Map<String, dynamic> params);

/// A function that constructs an object of type [Y] from a Map or null.
typedef ConstructorFuncAllowNull<Y> = Y Function(Map<String, dynamic>? params);

// --- String ---

/// Retrieves a string property from a map, or returns a default value if not found or type mismatch.
R getStringPropOrDefault<R extends String?>(
  Map<String, dynamic>? props,
  String prop,
  R defaultValue,
) {
  if (props != null) {
    final v = props[prop];
    if (v is String) {
      return v as R;
    }
    if (v is num) {
      return v.toString() as R;
    }
  }
  return defaultValue;
}

/// Retrieves a string property from a map, or returns the result of a default function if not found or type mismatch.
R getStringPropOrDefaultFunction<R extends String?>(
  Map<String, dynamic>? props,
  String prop,
  R Function() defaultFunction,
) {
  if (props != null) {
    final v = props[prop];
    if (v is String) {
      return v as R;
    }
    if (v is num) {
      return v.toString() as R;
    }
  }
  return defaultFunction();
}

/// Retrieves a string property from a map, or throws an error if not found or type mismatch.
R getStringPropOrThrow<R extends String?>(
  Map<String, dynamic>? props,
  String prop, {
  String? message,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is String) {
        return v as R;
      }
      if (v is num) {
        return v.toString() as R;
      }
    }
  }
  throw MissingOrInvalidPropertyException(
    message ?? '$prop not found as string in ${props.runtimeType}',
  );
}

// --- String Regexp ---

/// Retrieves a string property from a map, checks if it matches the [regexp], or returns a default value if not found or mismatch.
R getStringRegexpPropOrDefault<R extends String?>(
  Map<String, dynamic>? props,
  String prop,
  RegExp regexp,
  R defaultValue,
) {
  try {
    return getStringRegexpPropOrThrow<R>(props, prop, regexp);
  } catch (_) {
    return defaultValue;
  }
}

/// Retrieves a string property from a map, checks if it matches the [regexp], or returns the result of a default function if not found or mismatch.
R getStringRegexpPropOrDefaultFunction<R extends String?>(
  Map<String, dynamic>? props,
  String prop,
  RegExp regexp,
  R Function() defaultFunction,
) {
  try {
    return getStringRegexpPropOrThrow<R>(props, prop, regexp);
  } catch (_) {
    return defaultFunction();
  }
}

/// Retrieves a string property from a map, checks if it matches the [regexp], or throws an error if not found or mismatch.
R getStringRegexpPropOrThrow<R extends String?>(
  Map<String, dynamic>? props,
  String prop,
  RegExp regexp, {
  String? message,
}) {
  final val = getStringPropOrThrow<R>(props, prop, message: message);
  if (val != null && !regexp.hasMatch(val)) {
    throw MissingOrInvalidPropertyException(
      message ??
          '$prop value "$val" does not match pattern ${regexp.pattern} in ${props.runtimeType}',
    );
  }
  return val;
}

// --- Number (int/double) ---

/// Retrieves a number (num) property from a map.
/// Note: In Dart, num is the superclass of int and double.
R getNumberPropOrDefault<R extends num?>(
  Map<String, dynamic>? props,
  String prop,
  R defaultValue,
) {
  try {
    return getNumberPropOrThrow<R>(props, prop);
  } catch (_) {
    return defaultValue;
  }
}

R getNumberPropOrDefaultFunction<R extends num?>(
  Map<String, dynamic>? props,
  String prop,
  R Function() defaultFunction,
) {
  try {
    return getNumberPropOrThrow<R>(props, prop);
  } catch (_) {
    return defaultFunction();
  }
}

R getNumberPropOrThrow<R extends num?>(
  Map<String, dynamic>? props,
  String prop, {
  String? message,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is num) {
        // Handle conversion between int and double if strict generic R is provided?
        // Usually num covers both. If R is strictly int, and v is double, this might fail cast.
        // Let's try to be smart.
        try {
          return v as R;
        } catch (_) {}
        if (R == int && v is double) return v.toInt() as R;
        if (R == double && v is int) return v.toDouble() as R;
        // if R is num, it should pass.
        // If R is nullable, it should also pass.
      }
      if (v is String) {
        final n = num.tryParse(v);
        if (n != null) {
          try {
            return n as R;
          } catch (_) {}
          if (R == int && n is double) return n.toInt() as R;
          if (R == double && n is int) return n.toDouble() as R;
        }
      }
    }
  }
  throw MissingOrInvalidPropertyException(
    message ?? '$prop not found as number in ${props.runtimeType}',
  );
}

// --- BigInt ---

R getBigIntPropOrDefault<R extends BigInt?>(
  Map<String, dynamic>? props,
  String prop,
  R defaultValue,
) {
  try {
    return getBigIntPropOrThrow(props, prop);
  } catch (_) {}
  return defaultValue;
}

R getBigIntPropOrDefaultFunction<R extends BigInt?>(
  Map<String, dynamic>? props,
  String prop,
  R Function() defaultFunction,
) {
  try {
    return getBigIntPropOrThrow(props, prop);
  } catch (_) {}
  return defaultFunction();
}

R getBigIntPropOrThrow<R extends BigInt?>(
  Map<String, dynamic>? props,
  String prop, {
  String? message,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is BigInt) {
        return v as R;
      }
      if (v is num) {
        return BigInt.from(v) as R;
      }
      if (v is String) {
        final b = BigInt.tryParse(v);
        if (b != null) return b as R;
      }
    }
  }
  throw MissingOrInvalidPropertyException(
    message ?? '$prop not found as BigInt in ${props.runtimeType}',
  );
}

// --- Boolean ---

bool getBooleanPropOrDefault(
  Map<String, dynamic>? props,
  String prop,
  bool defaultValue,
) {
  try {
    return getBooleanPropOrThrow(props, prop);
  } catch (_) {}
  return defaultValue;
}

bool getBooleanPropOrDefaultFunction(
  Map<String, dynamic>? props,
  String prop,
  bool Function() defaultFunction,
) {
  try {
    return getBooleanPropOrThrow(props, prop);
  } catch (_) {}
  return defaultFunction();
}

bool getBooleanPropOrThrow(
  Map<String, dynamic>? props,
  String prop, {
  bool Function(dynamic v)? constructorFunc,
}) {
  if (props != null && props.containsKey(prop)) {
    final v = props[prop];
    if (constructorFunc != null) {
      return constructorFunc(v);
    } else if (v is bool) {
      return v;
    }
  }
  throw MissingOrInvalidPropertyException(
    '$prop not found as boolean in ${props.runtimeType}',
  );
}

bool getBooleanFunctionPropOrDefault(
  Map<String, dynamic>? props,
  String prop,
  bool Function(dynamic v) constructorFunc,
  bool defaultValue,
) {
  try {
    return getBooleanPropOrThrow(props, prop, constructorFunc: constructorFunc);
  } catch (_) {}
  return defaultValue;
}

bool getBooleanFunctionPropOrDefaultFunction(
  Map<String, dynamic>? props,
  String prop,
  bool Function(dynamic v) constructorFunc,
  bool Function() defaultValue,
) {
  try {
    return getBooleanPropOrThrow(props, prop, constructorFunc: constructorFunc);
  } catch (_) {}
  return defaultValue();
}

// --- Date ---

// Dart doesn't have union types like R | Date.
// We can use generic R.

R getDatePropOrDefault<R>(
  Map<String, dynamic>? props,
  String prop,
  R defaultValue,
) {
  try {
    final res = getDatePropOrThrow(props, prop);
    return res as R;
  } catch (_) {}
  return defaultValue;
}

R getDatePropOrDefaultFunction<R>(
  Map<String, dynamic>? props,
  String prop,
  R Function() defaultFunction,
) {
  try {
    // If R is nullable Date, or just Date (and we cast it to R which might be Date)
    // The typescript signature is: R | Date.
    // In Dart we have to return dynamic or generic R where R covers Date.
    // If R is Date? then it works.
    final res = getDatePropOrThrow(props, prop);
    // Unsafe cast if R is not compatible. But usage expects R to be compatible.
    return res as R;
  } catch (_) {}
  return defaultFunction();
}

DateTime getDatePropOrThrow(Map<String, dynamic>? props, String prop) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is DateTime) {
        return v;
      } else if (v is String) {
        try {
          return DateTime.parse(v);
        } catch (_) {}
      } else if (v is num) {
        // Assumes seconds if small? TS says: new Date((v as number) * 1000)
        // JS Date constructor with number is milliseconds.
        // If TS multiplies by 1000, it assumes v is seconds.
        return DateTime.fromMillisecondsSinceEpoch((v * 1000).toInt());
      }
    }
  }
  throw MissingOrInvalidPropertyException(
    '$prop not found as date in ${props.runtimeType}',
  );
}

// --- String Array ---

R getStringArrayPropOrDefault<R>(
  Map<String, dynamic>? props,
  String prop,
  R defaultValue,
) {
  try {
    final res = getStringArrayPropOrThrow(props, prop);
    return res as R;
  } catch (_) {}
  return defaultValue;
}

R getStringArrayPropOrDefaultFunction<R>(
  Map<String, dynamic>? props,
  String prop,
  R Function() defaultFunction,
) {
  try {
    final res = getStringArrayPropOrThrow(props, prop);
    return res as R;
  } catch (_) {}
  return defaultFunction();
}

List<String> getStringArrayPropOrThrow(
  Map<String, dynamic>? props,
  String prop, {
  String? message,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
    }
  }
  throw MissingOrInvalidPropertyException(
    message ?? '$prop not found as string[] in ${props.runtimeType}',
  );
}

// --- String Array Regexp ---

R getStringArrayRegexpPropOrDefault<R>(
  Map<String, dynamic>? props,
  String prop,
  RegExp regexp,
  R defaultValue,
) {
  try {
    final res = getStringArrayRegexpPropOrThrow(props, prop, regexp);
    return res as R;
  } catch (_) {}
  return defaultValue;
}

R getStringArrayRegexpPropOrDefaultFunction<R>(
  Map<String, dynamic>? props,
  String prop,
  RegExp regexp,
  R Function() defaultFunction,
) {
  try {
    final res = getStringArrayRegexpPropOrThrow(props, prop, regexp);
    return res as R;
  } catch (_) {}
  return defaultFunction();
}

List<String> getStringArrayRegexpPropOrThrow(
  Map<String, dynamic>? props,
  String prop,
  RegExp regexp, {
  String? message,
}) {
  final list = getStringArrayPropOrThrow(props, prop, message: message);
  for (final val in list) {
    if (!regexp.hasMatch(val)) {
      throw MissingOrInvalidPropertyException(
        message ??
            '$prop element "$val" does not match pattern ${regexp.pattern} in ${props.runtimeType}',
      );
    }
  }
  return list;
}

// --- Date Array ---

R getDateArrayPropOrDefault<R>(
  Map<String, dynamic>? props,
  String prop,
  R defaultValue,
) {
  try {
    final res = getDateArrayPropOrThrow(props, prop);
    return res as R;
  } catch (e) {
    if (e is MissingOrInvalidPropertyException) {
      // Pass, return default
    } else {
      rethrow;
    }
  }
  return defaultValue;
}

R getDateArrayPropOrDefaultFunction<R>(
  Map<String, dynamic>? props,
  String prop,
  R Function() defaultFunction,
) {
  try {
    final res = getDateArrayPropOrThrow(props, prop);
    return res as R;
  } catch (e) {
    if (e is MissingOrInvalidPropertyException) {
      // Pass, return default
    } else {
      rethrow;
    }
  }
  return defaultFunction();
}

List<DateTime> getDateArrayPropOrThrow(
  Map<String, dynamic>? props,
  String prop,
) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is List) {
        return v.map((e) {
          if (e is String) {
            return DateTime.parse(e);
          } else if (e is DateTime) {
            return e;
          } else if (e is num) {
            return DateTime.fromMillisecondsSinceEpoch((e * 1000).toInt());
          }
          throw ElementConversionException(
            'Unknown type for date $e ${e.runtimeType}',
          );
        }).toList();
      }
    }
  }
  throw MissingOrInvalidPropertyException(
    '$prop not found as date[] in ${props.runtimeType}',
  );
}

// --- Object ---

Y getObjectPropOrThrow<Y>(Map<String, dynamic>? props, String prop) {
  // If Y is a Map or something we can just cast?
  // TS: GetObjectFunctionPropOrThrow<Y>(props, prop, (e) => e as Y)
  // It assumes e is the object (unknown) and casts it to Y.
  // Since we are in Dart, `e` comes from `props[prop]`. It is `dynamic`.
  // We can just cast it.
  // But wait, `GetObjectFunctionPropOrThrow` checks `typeof v === 'object' && v !== null`.
  return getObjectFunctionPropOrThrow<Y>(props, prop, (e) => e as Y);
}

Y getObjectFunctionPropOrThrow<Y>(
  Map<String, dynamic>? props,
  String prop,
  ConstructorFunc<Y> constructorFunc, {
  String? message,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is Map<String, dynamic>) {
        return constructorFunc(v);
      }
      // Handling if it's a Map but not <String, dynamic>?
      // In Dart JSON decoding usually produces Map<String, dynamic>.
      // If it is Map<dynamic, dynamic>, we might need to cast.
      if (v is Map) {
        try {
          return constructorFunc(v.cast<String, dynamic>());
        } catch (_) {}
      }
    }
  }
  throw MissingOrInvalidPropertyException(
    message ?? '$prop not found as object in ${props.runtimeType}',
  );
}

Y getObjectPropOrDefault<Y>(
  Map<String, dynamic>? props,
  String prop,
  Y defaultValue,
) {
  try {
    return getObjectPropOrThrow<Y>(props, prop);
  } catch (_) {}
  return defaultValue;
}

Y getObjectFunctionPropOrDefault<Y>(
  Map<String, dynamic>? props,
  String prop,
  ConstructorFunc<Y> constructorFunc,
  Y defaultValue,
) {
  try {
    return getObjectFunctionPropOrThrow(props, prop, constructorFunc);
  } catch (_) {}
  return defaultValue;
}

Y getObjectPropOrDefaultFunction<Y>(
  Map<String, dynamic>? props,
  String prop,
  ConstructorFunc<Y> constructorFunc,
  Y Function() defaultValue,
) {
  try {
    return getObjectFunctionPropOrThrow(props, prop, constructorFunc);
  } catch (_) {}
  return defaultValue();
}

// --- Object Array ---

X getObjectArrayPropOrThrow<Y, X extends List<Y>?>(
  Map<String, dynamic>? props,
  String prop,
) {
  // X is List<Y> or List<Y>?
  // We need to pass a constructor func that just casts.
  return getObjectArrayFunctionPropOrThrow<Y, X>(props, prop, (e) => e as Y);
}

X getObjectArrayFunctionPropOrThrow<Y, X extends List<Y>?>(
  Map<String, dynamic>? props,
  String prop,
  ConstructorFunc<Y> constructorFunc, {
  String? message,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is List) {
        // v is List<dynamic>. We need to map it.
        final list = v.map((e) {
          if (e is Map<String, dynamic>) {
            return constructorFunc(e);
          }
          if (e is Map) {
            return constructorFunc(e.cast<String, dynamic>());
          }
          throw ElementConversionException("Element in array is not a Map");
        }).toList();
        return list as X;
      }
    }
  }
  throw MissingOrInvalidPropertyException(
    message ?? '$prop not found as object in ${props.runtimeType}',
  );
}

X getObjectArrayPropOrDefault<Y, X extends List<Y>?>(
  Map<String, dynamic>? props,
  String prop,
  X defaultValue,
) {
  try {
    return getObjectArrayPropOrThrow<Y, X>(props, prop);
  } catch (_) {}
  return defaultValue;
}

X getObjectArrayFunctionPropOrDefault<Y, X extends List<Y>?>(
  Map<String, dynamic>? props,
  String prop,
  ConstructorFunc<Y> constructorFunc,
  X defaultValue,
) {
  try {
    return getObjectArrayFunctionPropOrThrow<Y, X>(
      props,
      prop,
      constructorFunc,
    );
  } catch (_) {}
  return defaultValue;
}

X getObjectArrayPropOrDefaultFunction<Y, X extends List<Y>?>(
  Map<String, dynamic>? props,
  String prop,
  ConstructorFunc<Y> constructorFunc,
  X Function() defaultValue,
) {
  try {
    return getObjectArrayFunctionPropOrThrow<Y, X>(
      props,
      prop,
      constructorFunc,
    );
  } catch (_) {}
  return defaultValue();
}

// --- Map ---

Map<K, V> getMapPropOrThrow<K, V>(
  Map<String, dynamic>? props,
  String prop, {
  String? message,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is Map) {
        // cast to K, V
        return v.cast<K, V>();
      }
      // TS: if (typeof v === 'object' && v !== null) { return new Map(Object.entries(v)) as Map<K, V>; }
      // In Dart, if it is not a Map but an object? Dart objects are not Maps.
      // Usually JSON deserializes to Map.
    }
  }
  throw MissingOrInvalidPropertyException(
    message ?? '$prop not found as Map in ${props.runtimeType}',
  );
}

R getMapPropOrDefault<K, V, R>(
  Map<String, dynamic>? props,
  String prop,
  R defaultValue,
) {
  try {
    final res = getMapPropOrThrow<K, V>(props, prop);
    return res as R;
  } catch (_) {}
  return defaultValue;
}

R getMapPropOrDefaultFunction<K, V, R>(
  Map<String, dynamic>? props,
  String prop,
  R Function() defaultFunction,
) {
  try {
    final res = getMapPropOrThrow<K, V>(props, prop);
    return res as R;
  } catch (_) {}
  return defaultFunction();
}

// --- Allow Null variants ---

Y getObjectPropOrThrowAllowNull<Y>(Map<String, dynamic>? props, String prop) {
  return getObjectFunctionPropOrThrowAllowNull<Y>(props, prop, (e) => e as Y);
}

Y getObjectFunctionPropOrThrowAllowNull<Y>(
  Map<String, dynamic>? props,
  String prop,
  ConstructorFuncAllowNull<Y> constructorFunc, {
  String? message,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is Map<String, dynamic> || v == null) {
        return constructorFunc(v);
      }
      if (v is Map) {
        return constructorFunc(v.cast<String, dynamic>());
      }
    }
  }
  throw MissingOrInvalidPropertyException(
    message ?? '$prop not found as object in ${props.runtimeType}',
  );
}

Y getObjectPropOrDefaultAllowNull<Y>(
  Map<String, dynamic>? props,
  String prop,
  Y defaultValue,
) {
  try {
    return getObjectPropOrThrowAllowNull<Y>(props, prop);
  } catch (_) {}
  return defaultValue;
}

Y getObjectFunctionPropOrDefaultAllowNull<Y>(
  Map<String, dynamic>? props,
  String prop,
  ConstructorFuncAllowNull<Y> constructorFunc,
  Y defaultValue,
) {
  try {
    return getObjectFunctionPropOrThrowAllowNull(props, prop, constructorFunc);
  } catch (_) {}
  return defaultValue;
}

Y getObjectPropOrDefaultFunctionAllowNull<Y>(
  Map<String, dynamic>? props,
  String prop,
  ConstructorFuncAllowNull<Y> constructorFunc,
  Y Function() defaultValue,
) {
  try {
    return getObjectFunctionPropOrThrowAllowNull(props, prop, constructorFunc);
  } catch (_) {}
  return defaultValue();
}
// --- Number Array ---

R getNumberArrayPropOrDefault<R>(
  Map<String, dynamic>? props,
  String prop,
  R defaultValue,
) {
  try {
    final res = getNumberArrayPropOrThrow(props, prop);
    return res as R;
  } catch (_) {}
  return defaultValue;
}

R getNumberArrayPropOrDefaultFunction<R>(
  Map<String, dynamic>? props,
  String prop,
  R Function() defaultFunction,
) {
  try {
    final res = getNumberArrayPropOrThrow(props, prop);
    return res as R;
  } catch (_) {}
  return defaultFunction();
}

List<num> getNumberArrayPropOrThrow(
  Map<String, dynamic>? props,
  String prop, {
  String? message,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is List) {
        return v.map((e) {
          if (e is num) return e;
          if (e is String) {
            final n = num.tryParse(e);
            if (n != null) return n;
          }
          throw ArgumentError('Element $e is not a number');
        }).toList();
      }
    }
  }
  throw ArgumentError(
    message ?? '$prop not found as number[] in ${props.runtimeType}',
  );
}

// --- BigInt Array ---

R getBigIntArrayPropOrDefault<R>(
  Map<String, dynamic>? props,
  String prop,
  R defaultValue,
) {
  try {
    final res = getBigIntArrayPropOrThrow(props, prop);
    return res as R;
  } catch (_) {}
  return defaultValue;
}

R getBigIntArrayPropOrDefaultFunction<R>(
  Map<String, dynamic>? props,
  String prop,
  R Function() defaultFunction,
) {
  try {
    final res = getBigIntArrayPropOrThrow(props, prop);
    return res as R;
  } catch (_) {}
  return defaultFunction();
}

List<BigInt> getBigIntArrayPropOrThrow(
  Map<String, dynamic>? props,
  String prop, {
  String? message,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is List) {
        return v.map((e) {
          if (e is BigInt) return e;
          if (e is num) return BigInt.from(e);
          if (e is String) {
            final b = BigInt.tryParse(e);
            if (b != null) return b;
          }
          throw ArgumentError('Element $e is not a BigInt');
        }).toList();
      }
    }
  }
  throw ArgumentError(
    message ?? '$prop not found as BigInt[] in ${props.runtimeType}',
  );
}

// --- Boolean Array ---

R getBooleanArrayPropOrDefault<R>(
  Map<String, dynamic>? props,
  String prop,
  R defaultValue,
) {
  try {
    final res = getBooleanArrayPropOrThrow(props, prop);
    return res as R;
  } catch (_) {}
  return defaultValue;
}

R getBooleanArrayPropOrDefaultFunction<R>(
  Map<String, dynamic>? props,
  String prop,
  R Function() defaultFunction,
) {
  try {
    final res = getBooleanArrayPropOrThrow(props, prop);
    return res as R;
  } catch (_) {}
  return defaultFunction();
}

List<bool> getBooleanArrayPropOrThrow(
  Map<String, dynamic>? props,
  String prop, {
  String? message,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is List) {
        return v.map((e) {
          if (e is bool) return e;
          throw ArgumentError('Element $e is not a boolean');
        }).toList();
      }
    }
  }
  throw ArgumentError(
    message ?? '$prop not found as boolean[] in ${props.runtimeType}',
  );
}

// --- Enum ---

T getEnumPropOrThrow<T extends Object>(
  Map<String, dynamic>? props,
  String prop,
  List<T> values, {
  String? message,
  String Function(T)? keyExtractor,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      try {
        final extractor = keyExtractor ?? (e) => e.toString().split('.').last;
        return values.firstWhere((e) => extractor(e) == v);
      } catch (_) {
        // Fall through to throw
      }
    }
  }
  throw MissingOrInvalidPropertyException(
    message ?? '$prop not found as enum in ${props.runtimeType}',
  );
}

T? getEnumPropOrDefault<T extends Object>(
  Map<String, dynamic>? props,
  String prop,
  List<T> values,
  T? defaultValue, {
  String Function(T)? keyExtractor,
}) {
  try {
    return getEnumPropOrThrow(props, prop, values, keyExtractor: keyExtractor);
  } catch (_) {}
  return defaultValue;
}

T? getEnumPropOrDefaultFunction<T extends Object>(
  Map<String, dynamic>? props,
  String prop,
  List<T> values,
  T? Function() defaultFunction, {
  String Function(T)? keyExtractor,
}) {
  try {
    return getEnumPropOrThrow(props, prop, values, keyExtractor: keyExtractor);
  } catch (_) {}
  return defaultFunction();
}

// --- Enum Array ---

List<T> getEnumArrayPropOrThrow<T extends Object>(
  Map<String, dynamic>? props,
  String prop,
  List<T> values, {
  String? message,
  String Function(T)? keyExtractor,
}) {
  if (props != null) {
    if (props.containsKey(prop)) {
      final v = props[prop];
      if (v is List) {
        final extractor =
            keyExtractor ?? (val) => val.toString().split('.').last;
        return v.map((e) {
          try {
            return values.firstWhere((val) => extractor(val) == e);
          } catch (_) {
            throw ElementConversionException(
              'Unknown type for enum $e ${e.runtimeType}',
            );
          }
        }).toList();
      }
    }
  }
  throw MissingOrInvalidPropertyException(
    message ?? '$prop not found as enum[] in ${props.runtimeType}',
  );
}

List<T> getEnumArrayPropOrDefault<T extends Object>(
  Map<String, dynamic>? props,
  String prop,
  List<T> values,
  List<T> defaultValue, {
  String Function(T)? keyExtractor,
}) {
  try {
    return getEnumArrayPropOrThrow(
      props,
      prop,
      values,
      keyExtractor: keyExtractor,
    );
  } catch (_) {}
  return defaultValue;
}

List<T> getEnumArrayPropOrDefaultFunction<T extends Object>(
  Map<String, dynamic>? props,
  String prop,
  List<T> values,
  List<T> Function() defaultFunction, {
  String Function(T)? keyExtractor,
}) {
  try {
    return getEnumArrayPropOrThrow(
      props,
      prop,
      values,
      keyExtractor: keyExtractor,
    );
  } catch (_) {}
  return defaultFunction();
}
