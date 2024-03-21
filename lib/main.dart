import 'package:flutter/material.dart';
import 'package:projet_spotify_gorouter/router/router_config.dart';

/// Exemple d'application avec double navigation
///  - une avec une bottom navigation bar (3 branches)
///  - une navigation entre les pages de chaque branche

void main() => runApp(const MyApp());

/// The main app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // -- le point d'entrée du main est le router
  //    (pas de scafflod à ce niveau)
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      )
    );
  }
}


