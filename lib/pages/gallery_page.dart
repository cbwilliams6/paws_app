import 'package:flutter/material.dart';

import '../services/firebase_storage_service.dart';
import 'image_detail_page.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final FirebaseStorageService _storageService = FirebaseStorageService();
  late Future<List<String>> imageUrls;

  @override
  void initState() {
    super.initState();
    imageUrls = _storageService.getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gallery")),
      body: FutureBuilder<List<String>>(
        future: imageUrls,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageDetailPage(url: snapshot.data![index]),
                    ),
                  );
                },
                child: Image.network(snapshot.data![index], fit: BoxFit.cover),
              );
            },
          );
        },
      ),
    );
  }
}
