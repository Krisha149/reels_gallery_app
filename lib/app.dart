// Flutter + Riverpod imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';

// Main App widget using Riverpod
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch currentUserProvider to get logged-in user
    final current = ref.watch(currentUserProvider);

    return MaterialApp(
      title: 'Reels Clone', // App title
      theme: ThemeData.dark(), // Dark theme for UI
      debugShowCheckedModeBanner: false, // Remove debug banner
      // If user logged in, go to HomeScreen; else show LoginScreen
      home: current != null ? const HomeScreen() : const LoginScreen(),
    );
  }
}
