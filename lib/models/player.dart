import 'pokemon.dart';

class Player {
  final String name;
  final List<Pokemon> team;

  const Player({
    required this.name,
    this.team = const [],
  });

  Player copyWith({
    String? name,
    List<Pokemon>? team,
  }) {
    return Player(
      name: name ?? this.name,
      team: team ?? this.team,
    );
  }
}