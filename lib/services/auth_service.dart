// Hive ane UUID import
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

// AuthService: Register, Login, Logout, CurrentUser handle kare
class AuthService {
  // Hive box to store users
  final Box<UserModel> _users = Hive.box<UserModel>('users');

  // Hive box to store meta information like currentUserId
  final Box _meta = Hive.box('meta');

  // Register method: Navo user create kare
  Future<UserModel> register(String name, String email, String password) async {
    // Check if email already exists
    final exists = _users.values.any((u) => u.email == email);
    if (exists) throw Exception('Email already registered');

    // Generate unique id using UUID
    final id = const Uuid().v4();

    // Create UserModel object
    final user = UserModel(id: id, name: name, email: email, password: password);

    // Save user in Hive box
    await _users.put(id, user);

    // Save current logged in user id in meta
    await _meta.put('currentUserId', id);

    return user; // Return newly created user
  }

  // Login method: User credentials verify kare ane login kare
  Future<UserModel> login(String email, String password) async {
    // Find user matching email and password
    final user = _users.values.firstWhere(
          (u) => u.email == email && u.password == password,
      orElse: () => throw Exception('Invalid credentials'), // Throw error if not found
    );

    // Save logged in user id in meta
    await _meta.put('currentUserId', user.id);

    return user; // Return logged in user
  }

  // Current logged-in user
  UserModel? get currentUser {
    final id = _meta.get('currentUserId') as String?; // Get current user id
    if (id == null) return null; // No user logged in
    return _users.get(id); // Fetch user from Hive
  }

  // Logout method: Remove currentUserId from meta
  Future<void> logout() async {
    await _meta.delete('currentUserId'); // Clear logged in user
  }
}
