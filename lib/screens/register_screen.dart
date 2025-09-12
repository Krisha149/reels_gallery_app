// Flutter material library ane Riverpod import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth provider ane screens import
import '../providers/auth_provider.dart';
import 'home_screen.dart';

// RegisterScreen: ConsumerStatefulWidget because we need Riverpod ref + state
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final nameCtl = TextEditingController();  // Name input controller
  final emailCtl = TextEditingController(); // Email input controller
  final passCtl = TextEditingController();  // Password input controller
  bool loading = false;                     // Loading state for register button
  String? err;                              // Error message to display

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Gradient background
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10, // Shadow effect
              color: Colors.white.withOpacity(0.9), // Slightly transparent
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Create Account ✨",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Register to get started",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 24),

                    // Name TextField
                    TextField(
                      controller: nameCtl,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Email TextField
                    TextField(
                      controller: emailCtl,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Password TextField
                    TextField(
                      controller: passCtl,
                      obscureText: true, // Hide text
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Show error if any
                    if (err != null)
                      Text(err!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),

                    // Register button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: loading
                          ? null // Disable button while loading
                          : () async {
                        setState(() {
                          loading = true;
                          err = null;
                        });
                        try {
                          final serv = ref.read(authServiceProvider);
                          await serv.register(
                              nameCtl.text.trim(),
                              emailCtl.text.trim(),
                              passCtl.text.trim());

                          // Set current user in state
                          ref.read(currentUserProvider.notifier).state =
                              serv.currentUser;

                          // Navigate to HomeScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                          );
                        } catch (e) {
                          setState(() {
                            err = e.toString(); // Show error
                          });
                        } finally {
                          setState(() {
                            loading = false; // Stop loading spinner
                          });
                        }
                      },
                      child: loading
                          ? const CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : const Text(
                        'Register',
                        style:
                        TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
