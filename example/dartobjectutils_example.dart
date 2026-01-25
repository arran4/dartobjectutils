import 'dart:convert';
import 'package:dartobjectutils/dartobjectutils.dart';

// 1. Define your data models
class Address {
  final String street;
  final String city;
  final String zip;

  Address(Map<String, dynamic> json)
    : street = getStringPropOrThrow(json, 'street'),
      city = getStringPropOrThrow(json, 'city'),
      // Use default value for optional fields
      zip = getStringPropOrDefault(json, 'zip', '00000');

  @override
  String toString() => '$street, $city $zip';
}

class User {
  final String name;
  final int age;
  final bool isActive;
  final Address address;
  final List<String> tags;
  final List<Address> prevAddresses;
  final Map<String, int> scores;

  User(Map<String, dynamic> json)
    : name = getStringPropOrThrow(json, 'name'),
      // Automatically converts compatible types (e.g. String "30" -> int 30)
      age = getNumberPropOrDefault(json, 'age', 0).toInt(),
      isActive = getBooleanPropOrDefault(json, 'isActive', false),
      // Parse nested object
      address = getObjectFunctionPropOrThrow(
        json,
        'address',
        (j) => Address(j),
      ),
      // Parse array of primitives
      tags = getStringArrayPropOrDefault(json, 'tags', <String>[]),
      // Parse array of objects
      prevAddresses = getObjectArrayFunctionPropOrDefault(
        json,
        'prevAddresses',
        (j) => Address(j),
        <Address>[],
      )!, // ! is safe because we provide a non-null default value
      // Explicitly specify generics for type safety when extracting Maps
      scores = getMapPropOrDefault<String, int, Map<String, int>>(
        json,
        'scores',
        <String, int>{},
      );

  @override
  String toString() {
    return 'User(name: $name, age: $age, isActive: $isActive, '
        'address: [$address], tags: $tags, '
        'prevAddresses: $prevAddresses, scores: $scores)';
  }
}

void main() {
  print('--- dartobjectutils Example ---');

  // Case 1: Valid full object
  final validJson = {
    'name': 'Alice',
    'age': 30,
    'isActive': true,
    'address': {'street': '123 Main St', 'city': 'Wonderland', 'zip': '12345'},
    'tags': ['admin', 'editor'],
    'prevAddresses': [
      {'street': '456 Old St', 'city': 'OldTown', 'zip': '67890'},
      {'street': '789 Unknown St', 'city': 'Nowhere'},
    ],
    'scores': {'math': 95, 'science': 88},
  };

  print('\n1. Parsing Valid User:');
  try {
    final user = User(validJson);
    print(user);
  } catch (e) {
    print('Error: $e');
  }

  // Case 2: Missing optional fields (using defaults)
  final minimalJson = {
    'name': 'Bob',
    'address': {'street': '1st Ave', 'city': 'Metropolis'},
    // 'age' missing -> defaults to 0
    // 'isActive' missing -> defaults to false
    // 'tags' missing -> defaults to []
    // 'prevAddresses' missing -> defaults to []
  };

  print('\n2. Parsing Minimal User (defaults):');
  try {
    final user = User(minimalJson);
    print(user);
  } catch (e) {
    print('Error: $e');
  }

  // Case 3: Invalid data (throwing error)
  final invalidJson = {
    'name': 'Charlie',
    'age':
        'not a number', // getNumberPropOrDefault handles conversion failure -> defaults to 0
    'address': 'Not a map', // getObjectFunctionPropOrThrow throws exception
  };

  print('\n3. Parsing Invalid User (expecting error):');
  try {
    final user = User(invalidJson);
    print(user);
  } catch (e) {
    print('Caught expected error: $e');
  }

  // Case 4: JSON String from API
  print('\n4. Parsing JSON String (simulating API response):');
  const jsonString = '''
  {
    "name": "David",
    "age": "45",
    "isActive": 1,
    "address": {
      "street": "101 Binary Blvd",
      "city": "Cyberspace",
      "zip": 10101
    },
    "tags": ["bot", "ai"],
    "scores": {"coding": 100}
  }
  ''';

  try {
    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    // Demonstration of manual extraction before creating the object
    print('Decoded name: ${getStringPropOrThrow(decoded, "name")}');
    print(
      'Decoded age: ${getNumberPropOrThrow(decoded, "age")}',
    ); // Auto converts string "45" to num

    // Custom handling for boolean if API returns 0/1 instead of true/false
    final isActive = getBooleanFunctionPropOrDefault(
      decoded,
      'isActive',
      (v) => v == 1 || v == true,
      false,
    );
    print('Decoded isActive (custom logic): $isActive');

    // Create User object
    // Note: User class uses strict boolean parsing by default, so "isActive": 1 might result in false
    // unless the User class logic is updated to handle numbers.
    final user = User(decoded);
    print('User object: $user');
  } catch (e) {
    print('Error parsing JSON string: $e');
  }
}
