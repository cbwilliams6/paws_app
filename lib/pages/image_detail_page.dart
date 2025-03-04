import 'package:flutter/material.dart';

class ImageDetailPage extends StatelessWidget {
  final String url;

  ImageDetailPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Details")),
      body: Column(
        children: [
          Expanded(child: Image.network(url, fit: BoxFit.contain)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    // Handle favoriting logic
                  },
                ),
                IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () {
                    // Handle saving to device logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
