import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> getImages() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user logged in.");
        return [];
      }

      final userRef = _storage.ref('Users/${user.uid}/pi_images/');
      ListResult result = await userRef.listAll();

      print("Found ${result.items.length} images for user ${user.uid}");
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
