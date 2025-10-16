class User {
  final String fullName;
  final String email;
  final String username;
  final String password;

  User({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
  });
}

final List<User> users = [
  User(
    fullName: 'John Doe',
    email: 'p5PfA@example.com',
    username: 'johndoe',
    password: 'password123',
  ),
  User(
    fullName: 'Keysha Arindra',
    email: 'keydrf@example.com',
    username: 'key',
    password: '123',
  ),
];