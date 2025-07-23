class User {
  final String username;
  final String token;
  final String expires;
  final int userId;
  final String fullName;
  final String status;
  final String lastLogin;

  User({
    required this.username,
    required this.token,
    required this.expires,
    required this.userId,
    required this.fullName,
    required this.status,
    required this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      token: json['token'],
      expires: json['expires'],
      userId: json['user_id'],
      fullName: json['full_name'],
      status: json['status'],
      lastLogin: json['last_login'],
    );
  }
}
