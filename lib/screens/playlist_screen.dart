import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// The home screen
class PlaylistScreen extends StatelessWidget {
  /// Constructs a [PlaylistScreen]
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlist Screen')),
      body: const Center(
        child: Text("Playlist")
        /*ElevatedButton(
          onPressed: () => context.go('/albumdetails'),
          child: const Text('Go to the Details screen'),
        ),*/

      ),
    );
  }
}