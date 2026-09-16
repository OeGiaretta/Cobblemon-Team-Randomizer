import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/pokemon.dart';

class PokemonRepository {
  Future<List<Pokemon>> loadPokemon() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/pokemon.json',
    );

    final List<dynamic> jsonData = jsonDecode(jsonString);

    return jsonData
        .map(
          (item) => Pokemon.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}