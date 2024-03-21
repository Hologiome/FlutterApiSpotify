import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/Album.dart'; // Assurez-vous que ce chemin est correct

class ApiService {
  final String _baseUrl;
  String? _accessToken;

  ApiService(this._baseUrl) {
    _fetchToken();
  }

  Future<void> _fetchToken() async {
    _accessToken =
        "BQAHzWFRXKV7bAFR2ghGdqNwdWBmNQ0oUahKFeBBOsD87tScrizT1mm3yRuzHE0zlrp9cMkFy9OoWQsbhbZhHGlweZoo6DXMmbIBrz7JCdYQzvvDmv8"; // Remplacez 'Votre_Token' par votre token d'authentification Spotify
  }

  Future<List<Album>> fetchNewReleases() async {
    final response = await fetchData('browse/new-releases');
    final parsedJson = jsonDecode(response);
    final albumsJson = parsedJson['albums']['items'] as List;

    return albumsJson
        .map((json) => Album.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<Album>> searchAlbums(String query) async {
    final url = Uri.parse(
        'https://api.spotify.com/v1/search?type=album&market=FR&q=$query');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> albumsJson = jsonData['albums']['items'];

      List<Album> albums =
          albumsJson.map((json) => Album.fromJson(json)).toList();
      return albums;
    } else {
      throw Exception('Failed to load albums');
    }
  }

  Future<Album> fetchAlbumDetails(String id) async {
    final response = await fetchData('albums/$id');
    final parsedJson = jsonDecode(response);
    final album = Album.fromJson(parsedJson);
    return album;
  }

  Future<Artist> fetchArtistDetails(String id) async {
    final response = await fetchData('artists/$id');
    final parsedJson = jsonDecode(response);
    final artiste = Artist.fromJson(parsedJson);
    return artiste;
  }

  Future<String> fetchData(String endpoint) async {
    if (_accessToken == null) {
      await _fetchToken();
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data from API: ${response.statusCode}');
    }
  }
}
