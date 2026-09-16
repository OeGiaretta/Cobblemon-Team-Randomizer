import 'package:flutter/material.dart';

class PokemonSprite extends StatelessWidget {
  final int pokemonId;
  final double size;

  const PokemonSprite({
    super.key,
    required this.pokemonId,
    this.size = 56,
  });

  String get _spriteUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/'
        'sprites/pokemon/other/home/$pokemonId.png';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.network(
        _spriteUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.catching_pokemon_rounded,
            size: size * 0.55,
            color: Colors.white.withValues(alpha: 0.25),
          );
        },
      ),
    );
  }
}