import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String searchQuery = ''; // Variable pour stocker la requête de recherche

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                searchQuery =
                    value; // Mettre à jour la requête de recherche lors de la saisie
              },
              decoration: InputDecoration(
                labelText: 'Search Albums', // Libellé du champ de texte
                border:
                    OutlineInputBorder(), // Style de la bordure du champ de texte
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Naviguer vers l'écran des détails de la recherche en passant la requête de recherche
              context.go('/b/searchdetails?query=$searchQuery');
            },
            child: Text('Search'), // Texte du bouton de recherche
          ),
        ],
      ),
    );
  }
}
