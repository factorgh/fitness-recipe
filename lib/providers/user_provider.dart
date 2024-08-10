import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models%202/user.dart';
// Import your User model

// A StateNotifier to manage the User state
class UserNotifier extends StateNotifier {
  UserNotifier() : super(null);

  // Method to set user
  void setUser(User user) {
    state = user;
  }

  // Method to clear user (e.g., logout)
  void clearUser() {
    state = null;
  }
}

// A provider to access UserNotifier
final userProvider = StateNotifierProvider((ref) {
  return UserNotifier();
});
