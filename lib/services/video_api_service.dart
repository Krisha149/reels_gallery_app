// Import necessary packages
import 'dart:convert'; // JSON decode
import 'package:http/http.dart' as http; // HTTP requests
import 'package:uuid/uuid.dart'; // Unique ID generation
import '../models/video_model.dart'; // Video model

// VideoApiService: Fetch videos from Pexels API or fallback samples
class VideoApiService {
  // Replace with your Pexels API key
  static const _pexelsKey = 'NOMuJY8DuH0LFSDpNy6SdeqvuHykqrx01i3GZDSridgiD98yOPtFJ3Ey';

  // Fetch popular videos, default 8 per page
  Future<List<VideoModel>> fetchVideos({int perPage = 8}) async {
    if (_pexelsKey.isEmpty) {
      // If API key not provided, return fallback sample videos
      final sample = [
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_5mb.mp4',
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4',
      ];
      // Convert sample URLs to VideoModel with unique ID
      return sample.map((s) => VideoModel(id: const Uuid().v4(), url: s)).toList();
    }

    // Pexels API endpoint
    final url = Uri.parse('https://api.pexels.com/videos/popular?per_page=$perPage');

    // Send GET request with Authorization header
    final resp = await http.get(url, headers: {'Authorization': _pexelsKey});

    if (resp.statusCode != 200) {
      // If API error, print status code and return empty list
      print('Pexels API error: ${resp.statusCode}');
      return [];
    }

    // Decode JSON response
    final data = json.decode(resp.body);
    final List results = data['videos'] ?? [];

    final List<VideoModel> list = [];
    for (final item in results) {
      final files = item['video_files'] as List<dynamic>;
      if (files.isEmpty) continue;

      // Select medium quality video link to avoid large size
      final fileUrl = files.first['link'] as String;

      final id = const Uuid().v4(); // Generate unique ID
      list.add(VideoModel(id: id, url: fileUrl)); // Add to list
    }

    return list; // Return list of VideoModel
  }
}
