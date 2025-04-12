import 'package:flutter/material.dart';

import 'gallery_page.dart';
import 'activity_log_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 32),

              // Logo at the top
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/cats.jpg',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Title text
              Text(
                'PAWS Mobile App',
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 32),

              // Gallery button
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  leading: Icon(Icons.photo_library, color: colorScheme.primary),
                  title: Text(
                    'Gallery',
                    style: textTheme.titleMedium,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GalleryPage()),
                    );
                  },
                ),
              ),

              SizedBox(height: 16),

              // Activity Log button
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  leading: Icon(Icons.history, color: colorScheme.primary),
                  title: Text(
                    'Activity Log',
                    style: textTheme.titleMedium,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ActivityLogPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
