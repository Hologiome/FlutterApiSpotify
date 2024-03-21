import 'package:flutter/material.dart';
import 'package:projet_spotify_gorouter/provider.dart'; // Importation de ApiService
import '/models/Album.dart'; // Importation de Album depuis le dossier models
import 'package:go_router/go_router.dart';

class SearchDetailsScreen extends StatelessWidget {
  final String searchQuery;

  const SearchDetailsScreen({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService("https://api.spotify.com/v1");

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: FutureBuilder<List<Album>>(
        future: apiService.searchAlbums(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Album album = snapshot.data![index];
                return ListTile(
                  leading: Image.network(album.imageUrl, width: 56, height: 56,
                      errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error);
                  }),
                  title: Text(album.title),
                  onTap: () {
                    context.go('/a/albumdetails/${album.id}');
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No albums found'));
          }
        },
      ),
    );
  }
}
