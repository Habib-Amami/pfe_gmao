enum Status {
  // ignore: constant_identifier_names
  Active,
  // ignore: constant_identifier_names
  Standby,
  // ignore: constant_identifier_names
  Shutdown
}

// Extension to convert enum values to strings
extension StatusToString on Status {
  String statusToShortString() {
    return toString().split('.').last;
  }
}
