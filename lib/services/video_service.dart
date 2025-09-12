// Hive ane UUID import
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/video_model.dart';

// VideoService: Local video storage & actions like add, like, view
class VideoService {
  // Hive box to store VideoModel objects
  final Box<VideoModel> _box = Hive.box<VideoModel>('videos');

  // Load all videos from Hive
  List<VideoModel> loadAll() => _box.values.toList();

  // Add a local video from device path
  Future<VideoModel> addLocal(String path) async {
    final id = const Uuid().v4(); // Generate unique ID
    final v = VideoModel(id: id, url: path); // Create VideoModel
    await _box.put(id, v); // Save in Hive
    return v; // Return added video
  }

  // Add a remote video (from API or server)
  Future<void> addRemote(VideoModel v) async {
    await _box.put(v.id, v); // Save video in Hive using its ID
  }

  // Toggle like/unlike for a video by a specific user
  Future<void> toggleLike(VideoModel video, String userId) async {
    final v = _box.get(video.id); // Fetch video from Hive
    if (v == null) return; // Video not found

    if (v.likedBy.contains(userId)) {
      // If user already liked, remove like
      v.likedBy.remove(userId);
      v.likes = v.likedBy.length;
    } else {
      // Else, add like
      v.likedBy.add(userId);
      v.likes = v.likedBy.length;
    }
    await v.save(); // Save changes in Hive
  }

  // Add view for a video by a specific user
  Future<void> addView(VideoModel video, String userId) async {
    final v = _box.get(video.id); // Fetch video
    if (v == null) return; // Video not found
    if (!v.viewers.contains(userId)) {
      // Only add if user hasn't viewed yet
      v.viewers.add(userId);
      await v.save(); // Save changes
    }
  }
}
