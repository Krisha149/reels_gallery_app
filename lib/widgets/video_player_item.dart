// Flutter, Riverpod, Hive, and video_player imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reels_gallery_app/models/user_model.dart';
import 'package:video_player/video_player.dart';
import '../models/video_model.dart';
import '../providers/video_provider.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import 'package:hive/hive.dart';

// VideoPlayerItem: Single video widget with play/pause, likes, and viewers
class VideoPlayerItem extends ConsumerStatefulWidget {
  final VideoModel video; // Video to display
  final bool play;        // Whether video should play
  const VideoPlayerItem({super.key, required this.video, required this.play});

  @override
  ConsumerState<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends ConsumerState<VideoPlayerItem> {
  VideoPlayerController? _controller; // Controller for video playback
  bool initialized = false;            // Track if controller initialized

  @override
  void didUpdateWidget(covariant VideoPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If new video, dispose old controller and init new one
    if (oldWidget.video.id != widget.video.id) {
      _disposeController();
      _initController();
    }
    // If play state changed, play or pause
    else if (widget.play != oldWidget.play) {
      if (widget.play) _controller?.play();
      else _controller?.pause();
    }
  }

  @override
  void initState() {
    super.initState();
    _initController(); // Initialize video controller

    // Add view for current user if playing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user != null && widget.play) {
        ref.read(videoListProvider.notifier).addView(widget.video, user.id);
      }
    });
  }

  // Initialize video controller
  void _initController() {
    final url = widget.video.url;
    if (url.startsWith('http')) {
      _controller = VideoPlayerController.network(url); // Remote video
    } else {
      _controller = VideoPlayerController.asset(url);   // Local video
    }
    _controller!.setLooping(true); // Loop video
    _controller!.initialize().then((_) {
      setState(() { initialized = true; });
      if (widget.play) _controller!.play(); // Auto-play if play=true
    }).catchError((e) {});
  }

  // Dispose video controller
  void _disposeController() {
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    initialized = false;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider); // Get current user
    final isLiked = user != null && widget.video.likedBy.contains(user.id); // Check if liked

    return Stack(
      children: [
        // Video display
        Center(
          child: initialized && _controller != null
              ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          )
              : const CircularProgressIndicator(),
        ),

        // Overlay for likes and views
        Positioned(
          right: 12,
          bottom: 180,
          child: Column(
            children: [
              // Like button
              GestureDetector(
                onTap: user == null
                    ? null
                    : () {
                  ref
                      .read(videoListProvider.notifier)
                      .toggleLike(widget.video, user.id);
                },
                child: AnimatedScale(
                  scale: isLiked ? 1.3 : 1.0, // Animate when liked
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Display likes count
              Text(
                '${widget.video.likes}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),
              // Viewers button
              IconButton(
                icon: const Icon(Icons.remove_red_eye, color: Colors.white, size: 32),
                onPressed: () {
                  final viewers = widget.video.viewers;
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.black.withOpacity(0.9),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) {
                      final usersBox = Hive.box<UserModel>('users');
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Drag handle
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            width: 60,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const Text(
                            '👀 Viewers',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Divider(color: Colors.white24),
                          // List of viewers
                          Expanded(
                            child: ListView.builder(
                              itemCount: viewers.length,
                              itemBuilder: (context, index) {
                                final id = viewers[index];
                                final u = usersBox.get(id); // Get user from Hive
                                final name = u != null ? u.name : id;
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.purple,
                                    child: Text(
                                      name[0].toUpperCase(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(name,
                                      style: const TextStyle(color: Colors.white)),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 4),
              // Display viewers count
              Text(
                '${widget.video.viewers.length}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
