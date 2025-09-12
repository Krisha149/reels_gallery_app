// Import statements: Flutter Riverpod state management library ane tamara models/service files
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/video_service.dart';
import '../models/video_model.dart';

// Provider for VideoService: Tamara app ma kahi pan VideoService ne access karva mate
final videoServiceProvider = Provider((ref) => VideoService());

// StateNotifierProvider: VideoListNotifier ne expose kare, ane state (list of VideoModel) manage kare
final videoListProvider = StateNotifierProvider<VideoListNotifier, List<VideoModel>>(
      (ref) => VideoListNotifier(ref),
);

// VideoListNotifier: StateNotifier ne extend kare, jethi video list ne manage kari sako
class VideoListNotifier extends StateNotifier<List<VideoModel>> {
  final Ref ref; // Ref object: anya providers access karva mate
  late final VideoService _service; // VideoService instance, late kyake initialize thase

  // Constructor: Ref ne assign kare ane load() method call kare
  VideoListNotifier(this.ref) : super([]) {
    _service = ref.read(videoServiceProvider); // VideoService instance fetch karo
    load(); // App start thaya pachi video list load karo
  }

  // Load method: service thi badha videos fetch kare ane state update kare
  void load() {
    state = _service.loadAll(); // _service.loadAll() returns List<VideoModel>
  }

  // Add a local video (from device path)
  Future<void> addLocal(String path) async {
    await _service.addLocal(path); // Service method call karo
    load(); // Add pachi list reload karo
  }

  // Add a list of remote videos (from server or API)
  Future<void> addRemoteList(List<VideoModel> list) async {
    for (final v in list) {
      await _service.addRemote(v); // Ek-ek video add karo
    }
    load(); // Add pachi list reload karo
  }

  // Toggle like/unlike for a video by a user
  Future<void> toggleLike(VideoModel v, String userId) async {
    await _service.toggleLike(v, userId); // Service method call karo
    load(); // State update karo
  }

  // Add a view to a video by a user
  Future<void> addView(VideoModel v, String userId) async {
    await _service.addView(v, userId); // Service method call karo
    load(); // State update karo
  }
}
