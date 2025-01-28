import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Gets the color scheme from the apps theme
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(  // Makes sure content is not overlapped by system UI
        child: Column(
          children: [
            // First block - Live Camera
            Expanded(
              flex: 1,  // This block takes 1/3 of the screen height
              child: Container(
                color: colorScheme.primary,  // Using primary color from the theme
                child: Center(
                  child: Text(
                    'Live Camera',
                    style: TextStyle(
                      fontSize: 24, 
                      color: colorScheme.onPrimary, // Ensure text is readable on primary color
                    ),
                  ),
                ),
              ),
            ),

            // Second block - Saved Pictures
            Expanded(
              flex: 1,  // This block takes 1/3 of the screen height
              child: Container(
                color: colorScheme.secondary,  // Using secondary color from the theme
                child: Center(
                  child: Text(
                    'Saved Pictures',
                    style: TextStyle(
                      fontSize: 24, 
                      color: colorScheme.onSecondary, // Ensure text is readable on secondary color
                    ),
                  ),
                ),
              ),
            ),

            // Third block - Activity Log
            Expanded(
              flex: 1,  // This block takes 1/3 of the screen height
              child: Container(
                color: colorScheme.tertiary,  // Using tertiary color from the theme
                child: Center(
                  child: Text(
                    'Activity Log',
                    style: TextStyle(
                      fontSize: 24, 
                      color: colorScheme.onTertiary, // Ensure text is readable on tertiary color
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
