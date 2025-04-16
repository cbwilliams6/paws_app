import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'image_detail_page.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final FirebaseStorageService _storageService = FirebaseStorageService();
  late Future<List<Map<String, dynamic>>> imageData;
  DateTime? selectedDate;

  int _selectedIndex = 0;
  late Future<List<Map<String, dynamic>>> favoriteImages;

  void _refreshImages() {
    setState(() {
      imageData = _storageService.getImages(forDate: selectedDate);
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshImages();
    favoriteImages = _getFavoriteImages();
  }

  Future<List<Map<String, dynamic>>> _getFavoriteImages() async {
    // Fetch the favorite images for the logged-in user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final favoritesSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    return favoritesSnapshot.docs.map((doc) {
      return {
        'url': doc['url'],
        'createdAt': (doc['createdAt'] as Timestamp).toDate(),
      };
    }).toList();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Pull to refresh the gallery
  Future<void> _refreshGallery() async {
    setState(() {
      imageData = _storageService.getImages(forDate: selectedDate);
    });
  }

  // Pull to refresh the favorites
  Future<void> _refreshFavorites() async {
    setState(() {
      favoriteImages = _getFavoriteImages();
    });
  }

  Widget _buildGalleryPage() {
    return RefreshIndicator(
      onRefresh: _refreshGallery, // Trigger a refresh by reloading the images
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: imageData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final data = snapshot.data!;
          if (data.isEmpty) return Center(child: Text("No images found."));

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final url = data[index]['url'];
              final date = data[index]['createdAt'];

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ImageDetailPage(url: url)),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(url, fit: BoxFit.cover),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        color: Colors.black54,
                        child: Text(
                          DateFormat('MM/dd').format(date),
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFavoritesPage() {
    return RefreshIndicator(
      onRefresh: _refreshFavorites, // Trigger a refresh for favorites
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: favoriteImages,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final data = snapshot.data!;
          if (data.isEmpty) return Center(child: Text("No favorites found."));

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final url = data[index]['url'];
              final date = data[index]['createdAt'];

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ImageDetailPage(url: url)),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(url, fit: BoxFit.cover),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        color: Colors.black54,
                        child: Text(
                          DateFormat('MM/dd').format(date),
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                        _refreshImages();
                      });
                    }
                  },
                ),
                if (selectedDate != null)
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        selectedDate = null;
                        _refreshImages();
                      });
                    },
                  ),
              ]
            : null,
      ),
      body: _selectedIndex == 0 ? _buildGalleryPage() : _buildFavoritesPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
