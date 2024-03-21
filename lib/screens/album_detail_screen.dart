import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import '/models/Album.dart'; // Assurez-vous que le chemin est correct
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:projet_spotify_gorouter/DatabaseService.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String id;

  const AlbumDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  late Future<Album> _albumFuture;
  late AudioPlayer player;
  late ConcatenatingAudioSource playlist;
  final databaseService = DatabaseService();

  final ApiService apiService = ApiService("https://api.spotify.com/v1");

  @override
  void initState() {
    super.initState();
    _albumFuture = apiService.fetchAlbumDetails(widget.id);
    player = AudioPlayer();
    playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: [], // Les chansons seront ajoutées une fois l'album chargé
    );
    initDBe();
  }

  void initDBe() async {
    databaseFactory = databaseFactoryFfiWeb;
    await databaseService.initDb();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _initializeAndPlay(List<String>? tracksURL) async {
    // Réinitialisation de la playlist pour chaque nouvel album
    await playlist.clear();
    if (tracksURL != null) {
      for (var trackURL in tracksURL) {
        playlist.add(AudioSource.uri(Uri.parse(trackURL)));
      }
    }
    await player.setAudioSource(playlist,
        initialIndex: 0, initialPosition: Duration.zero);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Album Detail')),
      body: FutureBuilder<Album>(
        future: _albumFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            Album album = snapshot.data!;
            _initializeAndPlay(album.tracksURL); // Initialiser et jouer l'album
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text(album.title,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 16.0),
                Image.network(album.imageUrl),
                ..._buildAlbumDetails(album),
                if (album.tracksURL != null)
                  ..._buildTracks(player, album.tracks!, album.tracksURL!),
              ],
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }

  List<Widget> _buildAlbumDetails(Album album) {
    List<Widget> details = [
      SizedBox(height: 20),
      Text('Artists:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      // Liste des artistes
      if (album.artists != null)
        Column(
          children: album.artists!
              .map((artist) => Text(artist, style: TextStyle(fontSize: 16)))
              .toList(),
        ),
      SizedBox(height: 10),
      // Bouton pour accéder au détail de l'artiste, s'il y a des identifiants d'artistes
      if (album.artistsId != null && album.artistsId!.isNotEmpty)
        ElevatedButton(
          onPressed: () {
            String artistId = album.artistsId![0];
            // Naviguer vers le détail de l'artiste
            context.go('/a/artistedetails/$artistId');
          },
          child: Text('Go to Artist Detail'),
        ),
      SizedBox(height: 20),
      Text('Artists IDs:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      // Liste des identifiants des artistes
    ];

    return details;
  }

  List<Widget> _buildTracks(
      AudioPlayer player, List<String> tracks, List<String> tracksURL) {
    List<Widget> trackWidgets = [];
    for (int i = 0; i < tracks.length; i++) {
      trackWidgets.add(
        ListTile(
          title: Text(tracks[i]),
          leading: Icon(Icons.music_note),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // IconButton(
              //   icon: Icon(Icons.playlist_add),
              //   onPressed: () async {
              //     // Exemple d'ajout d'une chanson à une playlist nommée 'Ma Playlist'
              //     // Vous devrez adapter cette logique pour permettre à l'utilisateur de sélectionner ou créer une playlist

              //     final newTrack =
              //         tracks[i]; // Utilisez l'ID réel de la chanson ici
              //     final playlist =
              //         Playlist(name: 'Ma Playlist', trackIds: [newTrack]);
              //     await databaseService.insertPlaylist(playlist);
              //     // Afficher un message de confirmation ou mettre à jour l'UI ici
              //   },
              // ),
              // Bouton de lecture
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () async {
                  if (!player.playing) {
                    await player.seek(Duration.zero, index: i);
                    await player.play();
                  } else {
                    if (player.currentIndex != i) {
                      await player.seek(Duration.zero, index: i);
                      await player.play();
                    }
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: () => player.pause(),
              ),
            ],
          ),
        ),
      );
    }
    return trackWidgets;
  }
}
