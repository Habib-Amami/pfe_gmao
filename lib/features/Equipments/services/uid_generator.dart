import 'package:uuid/uuid.dart';

class UniqueIdGenerator {
  static String generateUniqueId() {
    var uuid = Uuid();
    return uuid.v4();
  }
}
