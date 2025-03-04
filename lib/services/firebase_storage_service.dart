import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> getImages() async {
    try {
      ListResult result = await _storage.ref('uploads/').listAll();
      print("Found ${result.items.length} images");
      List<String> urls = [];

      for (var ref in result.items) {
        String url = await ref.getDownloadURL();
        print("Fetched URL: $url");
        urls.add(url);
      }

      return urls;
    } catch (e) {
      print("Error getting images: $e");
      return [];
    }
  }
}
