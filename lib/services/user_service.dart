import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  // Static instance for global access
  static final UserService instance = UserService._internal();

  // Private constructor for singleton pattern
  UserService._internal();

  // Private variable to store current user
  User? _currentUser;

  // Public getter to access the current user
  User? get currentUser => _currentUser;

  // Method to initialize and fetch the current user
  void fetchCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;
  }
}
