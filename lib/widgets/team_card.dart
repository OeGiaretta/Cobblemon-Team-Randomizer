import 'package:flutter/material.dart';

import 'pokemon_team_slot.dart';

import '../models/player.dart';

class TeamCard extends StatelessWidget {
  final Player player;

  const TeamCard({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFFFF6B6B),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '6 Pokémon',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.catching_pokemon_rounded,
                  color: Color(0xFFFF6B6B),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Divider(
              color: Colors.white.withValues(alpha: 0.08),
              height: 1,
            ),

            const SizedBox(height: 12),

            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: player.team.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                    return PokemonTeamSlot(
                    pokemon: player.team[index],
                    );
                },
            ),
          ],
        ),
      ),
    );
  }
}