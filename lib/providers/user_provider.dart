import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a StateProvider for managing the username
final userProvider = StateProvider<String?>((ref) {
  // Initial value is null, indicating no user is logged in
  return null;
});
