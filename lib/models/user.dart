class User {
  final String id;
  final String name;
  final String email;
  final String username;
  final int role;
  final String imageUrl;
  final String password;
  final String resetToken;
  final String phoneNumber;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.username,
      required this.role,
      required this.imageUrl,
      required this.password,
      required this.resetToken,
      required this.phoneNumber});
}
