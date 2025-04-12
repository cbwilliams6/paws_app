import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> getImages({DateTime? forDate}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final userRef = _storage.ref('Users/${user.uid}/pi_images/');
    ListResult result = await userRef.listAll();

    final List<Map<String, dynamic>> images = [];

    for (var ref in result.items) {
      final metadata = await ref.getMetadata();
      final createdAt = metadata.timeCreated;

      if (forDate != null && createdAt != null) {
        final isSameDate = createdAt.year == forDate.year &&
            createdAt.month == forDate.month &&
            createdAt.day == forDate.day;

        if (!isSameDate) continue;
      }

      final url = await ref.getDownloadURL();
      images.add({
        'url': url,
        'createdAt': createdAt,
      });
    }

    images.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
    return images;
  }
}