import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/user.dart';

// A StateNotifier to manage the User state
class UserNotifier extends StateNotifier<User?> {
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
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
