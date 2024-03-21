class Album {
  final String id;
  final String title;
  final String imageUrl;
  final List<String>? artists;
  final List<String>? artistsId; // Changez le type en List<String>
  final List<String>? tracks;
  final List<String>? tracksURL;

  Album({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.artists,
    this.artistsId,
    this.tracks,
    this.tracksURL,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    List<String>? artists = json['artists'] != null
        ? (json['artists'] as List)
            .map((artist) => artist['name'] as String)
            .toList()
        : null;
    List<String>? artistsId = json['artists'] != null
        ? (json['artists'] as List)
            .map((artistId) =>
                artistId['id'] as String) // Changez le type en String
            .toList()
        : null;
    List<String>? tracks =
        json.containsKey('tracks') && json['tracks']['items'] != null
            ? (json['tracks']['items'] as List)
                .map((track) => track['name'] as String)
                .toList()
            : null;

    List<String>? tracksURL =
        json.containsKey('tracks') && json['tracks']['items'] != null
            ? (json['tracks']['items'] as List)
                .map((trackURL) => trackURL['preview_url'] as String)
                .toList()
            : null;

    return Album(
      id: json['id'],
      title: json['name'],
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url']
          : 'https://via.placeholder.com/150', // Image par défaut si aucune n'est fournie
      artists: artists,
      artistsId: artistsId,
      tracks: tracks,
      tracksURL: tracksURL,
    );
  }
}

class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> genres;
  final int popularity;

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genres,
    required this.popularity,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    List<String> genres = (json['genres'] as List<dynamic>)
        .map((genre) => genre as String)
        .toList();

    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url'] as String
          : 'https://via.placeholder.com/150', // Image par défaut si aucune n'est fournie
      genres: genres,
      popularity: json['popularity'] as int,
    );
  }
}

class Playlist {
  final int? id; // SQLite attribue des IDs automatiquement
  final String name;
  final List<String> trackIds; // Liste des IDs des chansons

  Playlist({this.id, required this.name, required this.trackIds});

  // Conversion d'un objet Playlist en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'trackIds': trackIds.join(
          ','), // Stocker les IDs des chansons comme une chaîne séparée par des virgules
    };
  }

  // Créer un objet Playlist à partir d'un Map
  static Playlist fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'],
      name: map['name'],
      trackIds:
          map['trackIds'].split(','), // Convertir la chaîne en une liste d'IDs
    );
  }
}
