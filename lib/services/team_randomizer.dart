import 'dart:math';

import '../models/player.dart';
import '../models/pokemon.dart';

class TeamRandomizer {
  final Random _random = Random();

  List<Player>? generateTeams({
    required List<String> playerNames,
    required List<Pokemon> pokemonPool,
  }) {
    if (playerNames.isEmpty) {
      return [];
    }

    final usedPokemonIds = <int>{};
    final players = <Player>[];

    for (final playerName in playerNames) {
      final team = _generateSingleTeam(
        pokemonPool: pokemonPool,
        globallyUsedPokemonIds: usedPokemonIds,
      );

      if (team == null) {
        return null;
      }

      usedPokemonIds.addAll(
        team.map((pokemon) => pokemon.id),
      );

      players.add(
        Player(
          name: playerName,
          team: team,
        ),
      );
    }

    return players;
  }

  List<Pokemon>? _generateSingleTeam({
    required List<Pokemon> pokemonPool,
    required Set<int> globallyUsedPokemonIds,
  }) {
    final starters = pokemonPool
        .where((pokemon) => pokemon.isStarter)
        .where(
          (pokemon) => !globallyUsedPokemonIds.contains(pokemon.id),
        )
        .toList();

    starters.shuffle(_random);

    for (final starter in starters) {
      final team = <Pokemon>[starter];
      final usedTypes = <String>{...starter.types};

      final availablePokemon = pokemonPool
          .where((pokemon) => !pokemon.isStarter)
          .where(
            (pokemon) => !globallyUsedPokemonIds.contains(pokemon.id),
          )
          .where((pokemon) => pokemon.id != starter.id)
          .toList();

      availablePokemon.shuffle(_random);

      final result = _buildTeam(
        team: team,
        usedTypes: usedTypes,
        availablePokemon: availablePokemon,
      );

      if (result != null) {
        return result;
      }
    }

    return null;
  }

  List<Pokemon>? _buildTeam({
    required List<Pokemon> team,
    required Set<String> usedTypes,
    required List<Pokemon> availablePokemon,
  }) {
    if (team.length == 6) {
      return List<Pokemon>.from(team);
    }

    final candidates = availablePokemon.where((pokemon) {
      return pokemon.types.every(
        (type) => !usedTypes.contains(type),
      );
    }).toList();

    candidates.shuffle(_random);

    for (final candidate in candidates) {
      team.add(candidate);
      usedTypes.addAll(candidate.types);

      final remainingPokemon = availablePokemon
          .where((pokemon) => pokemon.id != candidate.id)
          .toList();

      final result = _buildTeam(
        team: team,
        usedTypes: usedTypes,
        availablePokemon: remainingPokemon,
      );

      if (result != null) {
        return result;
      }

      team.removeLast();

      for (final type in candidate.types) {
        usedTypes.remove(type);
      }
    }

    return null;
  }
}