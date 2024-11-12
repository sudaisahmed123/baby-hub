class UserModel {
  final String uid;
  final String name;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  final String role;

  UserModel({
    required this.uid,
    required this.role,
    this.name = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
  });

    Map<String, dynamic> toMap() {
    return {
      'userId': uid,
      'username': name,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,

    };
  }
}
