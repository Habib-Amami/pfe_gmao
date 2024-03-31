// Define an enumeration for equipment priorities
enum Priority {
  // ignore: constant_identifier_names
  High,
  // ignore: constant_identifier_names
  Medium,
  // ignore: constant_identifier_names
  Low,
}

// Extension to convert enum values to strings
extension PriorityToString on Priority {
  String priorityToShortString() {
    return toString().split('.').last;
  }
}
