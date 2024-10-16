import 'package:fit_cibus/models/user.dart';
import 'package:fit_cibus/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  // Set the current user
  void setUser(User user) {
    state = user;
  }

  // Update the user details
  void updateUser({
    required String fullName,
    required String username,
    required String email,
  }) {
    if (state != null) {
      state = state!.copyWith(
        fullName: fullName,
        username: username,
        email: email,
      );
    }
  }

  void updateImageUrl({
    required String imageUrl,
  }) {
    if (state != null) {
      state = state!.copyWith(imageUrl: imageUrl);
    }
  }

  // Clear user data (e.g., on logout)
  void clearUser() {
    state = null;
  }
}

// The user provider
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
