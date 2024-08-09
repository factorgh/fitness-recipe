class User {
  final String id;
  final String fullName;
  final String email;
  final String username;
  final int role;
  final String imageUrl;
  final String password;
  final String token;
  final String phoneNumber;

  User(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.username,
      required this.role,
      required this.imageUrl,
      required this.password,
      required this.token,
      required this.phoneNumber});
}
