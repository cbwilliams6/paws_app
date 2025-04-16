import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ImageDetailPage extends StatefulWidget {
  final String url;

  ImageDetailPage({required this.url});

  @override
  _ImageDetailPageState createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  final user = FirebaseAuth.instance.currentUser;
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  // Function to hash the image URL to create a valid Firestore document ID
  String _generateDocId(String url) {
    var bytes = utf8.encode(url); // Convert URL to bytes
    var digest = md5.convert(bytes); // Create MD5 hash
    return digest.toString(); // Return hash as document ID
  }

  // Check if the image is already favorited by the current user
  Future<void> _checkIfFavorited() async {
    if (user == null) return;

    final docId = _generateDocId(widget.url); // Generate a valid doc ID

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(docId) // Use the hashed doc ID
        .get();

    setState(() {
      isFavorited = doc.exists;
    });
  }

  // Toggle the favorite status
  Future<void> _toggleFavorite() async {
    if (user == null) return;

    final docId = _generateDocId(widget.url); // Generate a valid doc ID
    final favRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(docId); // Use the hashed doc ID

    if (isFavorited) {
      await favRef.delete(); // Remove from favorites
    } else {
      await favRef.set({
        'url': widget.url,
        'createdAt': DateTime.now(),
      }); // Add to favorites
    }

    setState(() {
      isFavorited = !isFavorited;
    });
  }

  // Delete the image from Firebase Storage and Firestore
  Future<void> _deleteImage() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Image'),
        content: Text('Are you sure you want to delete this image? This cannot be undone.'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Delete from Firebase Storage
        final ref = FirebaseStorage.instance.refFromURL(widget.url);
        await ref.delete();

        // Also remove from favorites, if needed
        if (user != null) {
          final docId = _generateDocId(widget.url); // Generate the valid doc ID
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user!.uid)
              .collection('favorites')
              .doc(docId) // Use the hashed doc ID
              .delete();
        }

        Navigator.pop(context); // Go back to the gallery
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image deleted')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Details")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Image.network(widget.url, fit: BoxFit.contain),
            ),
            // Wrap this part in SafeArea to avoid the Android navigation buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? Colors.red : null,
                      ),
                      onPressed: _toggleFavorite,
                      tooltip: isFavorited ? 'Unfavorite' : 'Favorite',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: _deleteImage,
                      tooltip: 'Delete Image',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
