// Flutter material library ane Riverpod import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tamara providers ane widgets import
import '../providers/video_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/video_player_item.dart';
import 'package:file_picker/file_picker.dart';
import '../services/video_api_service.dart';

// HomeScreen: ConsumerStatefulWidget because we need Riverpod ref + state
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pc = PageController(); // Video swipe control (vertical)
  final VideoApiService _api = VideoApiService(); // API service instance
  int currentIndex = 0; // Currently visible video index

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Fetch videos from API after first frame renders
      final list = await _api.fetchVideos(perPage: 8);

      // If videos exist, add them to the VideoListNotifier
      if (list.isNotEmpty) {
        await ref.read(videoListProvider.notifier).addRemoteList(list);
      }

      // Reload state to update UI
      ref.read(videoListProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final videos = ref.watch(videoListProvider); // Watch video list state
    final user = ref.watch(currentUserProvider); // Watch current user

    return Scaffold(
      // If no videos, show message
      body: videos.isEmpty
          ? const Center(child: Text('No videos yet'))
          : PageView.builder(
        controller: _pc, // Page controller for swipe
        scrollDirection: Axis.vertical, // Vertical scroll
        itemCount: videos.length,
        onPageChanged: (i) {
          // Update current index on page change
          setState(() { currentIndex = i; });

          // Add view if user is logged in
          if (user != null) {
            ref.read(videoListProvider.notifier).addView(videos[i], user.id);
          }
        },
        itemBuilder: (context, index) {
          final v = videos[index];
          final isPlaying = index == currentIndex; // Only current video plays
          return VideoPlayerItem(video: v, play: isPlaying); // Custom video player widget
        },
      ),

      // Floating action buttons (add video and logout)
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add local video button
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () async {
              final res = await FilePicker.platform.pickFiles(type: FileType.video);
              if (res != null && res.files.single.path != null) {
                await ref.read(videoListProvider.notifier).addLocal(res.files.single.path!);
              }
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),

          // Logout button
          FloatingActionButton(
            heroTag: 'logout',
            onPressed: () {
              ref.read(authServiceProvider).logout(); // Call logout
              ref.read(currentUserProvider.notifier).state = null; // Clear user state
              Navigator.pushReplacementNamed(context, '/'); // Go to login/home screen
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
