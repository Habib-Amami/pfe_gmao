// Define an enumeration for equipment priorities
enum Priority {
  // ignore: constant_identifier_names
  Low,
  // ignore: constant_identifier_names
  Medium,
  // ignore: constant_identifier_names
  High,
}

extension PriorityToString on Priority {
  String priorityToShortString() {
    return toString().split('.').last;
  }
}
