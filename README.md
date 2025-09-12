# Reels Gallery App (Flutter) - 

## What is included
- Riverpod state management
- Hive local persistence (users + videos)
- Login / Register (local, demo)
- Per-user like toggle; views list shown in BottomSheet
- Add video from gallery (FilePicker)
- Remote video fetching via Pexels (optional) with fallback sample URLs

## How to run
1. Download and Extract zip // direct clone.
2. Run `flutter pub get`.
3. (Optional) If you want to regenerate adapters, run:
   `flutter pub run build_runner build --delete-conflicting-outputs`
   But generated adapters are included.
4. Run the app: `flutter run`.

## Pexels API
To fetch real videos, get a Pexels API key and set it in:
`lib/services/video_api_service.dart` -> `_pexelsKey`.

