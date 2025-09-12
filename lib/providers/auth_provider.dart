import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

/// Provides a singleton instance of [AuthService].
/// Any widget can use `ref.read(authServiceProvider)` to access authentication methods.
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Holds the current logged-in user (or null if not logged in).
/// This is a reactive state provider → widgets can `watch(currentUserProvider)`
/// and rebuild automatically when the user logs in or logs out.
final currentUserProvider = StateProvider<UserModel?>((ref) {
  final service = ref.read(authServiceProvider);
  return service.currentUser; // get the currently logged-in user from AuthService
});
