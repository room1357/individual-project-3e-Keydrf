// create models of user
// with full name, email, password
class User {
  String fullName;
  String email;
  String username;
  String password;

  User({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
  });
}

//create dummy users
List<User> dummyUsers = [
  User(
    fullName: "John Doe", 
    email: "johndoe@gmail.com",
    username: "johndoe",
    password: "password123",
  ),
];