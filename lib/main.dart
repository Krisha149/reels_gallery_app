// Flutter + Riverpod + Hive imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/video_model.dart';
import 'models/user_model.dart';
import 'app.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized before async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();

  // Register Hive adapters for custom models
  Hive.registerAdapter(VideoModelAdapter());
  Hive.registerAdapter(UserModelAdapter());

  // Open Hive boxes for storing data
  await Hive.openBox<VideoModel>('videos'); // Stores VideoModel objects
  await Hive.openBox<UserModel>('users');   // Stores UserModel objects
  await Hive.openBox('meta');               // Stores meta info (like current user)

  // Run the app with Riverpod's ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}
