import 'package:flutter/material.dart';

class ResultsHeader extends StatelessWidget {
  final int playerCount;
  final int pokemonCount;

  const ResultsHeader({
    super.key,
    required this.playerCount,
    required this.pokemonCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 26,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE53935)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: Color(0xFFFF6B6B),
              size: 25,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'TIMES SORTEADOS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Confira as equipes de cada treinador',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.48),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoBadge(
                icon: Icons.person_rounded,
                text: playerCount == 1
                    ? '1 TREINADOR'
                    : '$playerCount TREINADORES',
              ),
              _InfoBadge(
                icon: Icons.catching_pokemon_rounded,
                text: '$pokemonCount POKÉMON',
              ),
              const _InfoBadge(
                icon: Icons.check_circle_outline_rounded,
                text: '0 REPETIDOS',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoBadge({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFFFF6B6B),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}