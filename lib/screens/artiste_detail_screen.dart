import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/provider.dart';
import '/models/Album.dart'; // Assurez-vous que le chemin est correct
import 'package:http/http.dart' as http;
import 'dart:convert';

// -- detail d'un artiste
class ArtisteDetailScreen extends StatefulWidget {
  final String id;

  const ArtisteDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ArtisteDetailScreen> createState() => _ArtisteDetailScreenState();
}

class _ArtisteDetailScreenState extends State<ArtisteDetailScreen> {
  late Future<Artist> _artistFuture;

  final ApiService apiService = ApiService("https://api.spotify.com/v1");

  @override
  void initState() {
    super.initState();
    _artistFuture = apiService.fetchArtistDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Artist Detail')),
      body: FutureBuilder<Artist>(
        future: _artistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            Artist artist = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text(
                  artist.name,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Image.network(artist.imageUrl),
                SizedBox(height: 16.0),
                Text(
                  'Genres:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: artist.genres
                      .map((genre) => Chip(label: Text(genre)))
                      .toList(),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Popularity: ${artist.popularity}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
