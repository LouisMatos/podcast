import 'package:flutter/material.dart';

/// Categoria de podcast: rótulo pt-BR + `genreId` da Apple + ícone.
typedef PodcastGenre = ({int id, String label, IconData icon});

/// As principais categorias de podcast brasileiro. `id` é o gênero da Apple
/// (usado nos rankings por categoria). Ordem = ordem de exibição.
const List<PodcastGenre> podcastGenres = [
  (id: 1489, label: 'Notícias', icon: Icons.newspaper),
  (id: 1303, label: 'Comédia', icon: Icons.sentiment_very_satisfied),
  (id: 1324, label: 'Sociedade e Cultura', icon: Icons.groups),
  (id: 1488, label: 'True Crime', icon: Icons.local_police),
  (id: 1321, label: 'Negócios', icon: Icons.trending_up),
  (id: 1304, label: 'Educação', icon: Icons.school),
  (id: 1318, label: 'Tecnologia', icon: Icons.memory),
  (id: 1545, label: 'Esportes', icon: Icons.sports_soccer),
  (id: 1512, label: 'Saúde e Fitness', icon: Icons.favorite),
  (id: 1310, label: 'Música', icon: Icons.music_note),
  (id: 1533, label: 'Ciência', icon: Icons.science),
  (id: 1323, label: 'Ficção', icon: Icons.auto_stories),
  (id: 1305, label: 'Infantil e Família', icon: Icons.child_care),
  (id: 1314, label: 'Religião e Espiritualidade', icon: Icons.self_improvement),
];
