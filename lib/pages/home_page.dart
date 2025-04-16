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
        child: SingleChildScrollView( // <- this fixes the overflow
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),

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

              const SizedBox(height: 24),

              // Title text
              Text(
                'PAWS Mobile App',
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Gallery button
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  leading: Icon(Icons.photo_library, color: colorScheme.primary),
                  title: Text(
                    'Gallery',
                    style: textTheme.titleMedium,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GalleryPage()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Activity Log button
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  leading: Icon(Icons.history, color: colorScheme.primary),
                  title: Text(
                    'Activity Log',
                    style: textTheme.titleMedium,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ActivityLogPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32), // breathing room at bottom
            ],
          ),
        ),
      ),
    );
  }
}
