import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import 'pokemon_sprite.dart';
import 'type_badge.dart';

class PokemonTeamSlot extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonTeamSlot({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: pokemon.isStarter
            ? const Color(0xFFFFC857).withValues(alpha: 0.07)
            : Colors.white.withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: pokemon.isStarter
              ? const Color(0xFFFFC857).withValues(alpha: 0.28)
              : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          if (pokemon.isStarter)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC857)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 10,
                      color: Color(0xFFFFC857),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'STARTER',
                      style: TextStyle(
                        color: Color(0xFFFFC857),
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            const SizedBox(height: 20),

          Expanded(
            child: Center(
              child: AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 250),
                child: PokemonSprite(
                  pokemonId: pokemon.id,
                  size: 125,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            pokemon.name.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 8),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            runSpacing: 4,
            children: pokemon.types.map((type) {
              return TypeBadge(type: type);
            }).toList(),
          ),
        ],
      ),
    );
  }
}