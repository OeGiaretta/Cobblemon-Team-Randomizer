import 'package:flutter/material.dart';

import '../models/player.dart';
import '../widgets/pokemon_sprite.dart';
import '../widgets/type_badge.dart';

class TeamRevealPage extends StatefulWidget {
  final List<Player> players;

  const TeamRevealPage({
    super.key,
    required this.players,
  });

  @override
  State<TeamRevealPage> createState() => _TeamRevealPageState();
}

class _TeamRevealPageState extends State<TeamRevealPage> {
  bool _starterRevealed = false;
  int _revealedPokemonCount = 0;
  int _currentPlayerIndex = 0;
  int? _countdown;

  Future<void> _revealTeam() async {
    for (int number = 3; number >= 1; number--) {
      if (!mounted) return;

      setState(() {
        _countdown = number;
      });

      await Future.delayed(
        const Duration(milliseconds: 700),
      );
    }

    if (!mounted) return;

    setState(() {
      _countdown = null;
      _starterRevealed = true;
    });

    // Mantém o Starter sozinho na tela por um momento.
    await Future.delayed(
      const Duration(milliseconds: 1400),
    );

    for (int i = 1; i <= 5; i++) {
      if (!mounted) return;

      setState(() {
        _revealedPokemonCount = i;
      });

      await Future.delayed(
        const Duration(milliseconds: 700),
      );
    }
  }

  void _nextPlayer() {
    if (_currentPlayerIndex >= widget.players.length - 1) {
      return;
    }

    setState(() {
      _currentPlayerIndex++;
      _starterRevealed = false;
      _revealedPokemonCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.players[_currentPlayerIndex];

    final starter = player.team.firstWhere(
      (pokemon) => pokemon.isStarter,
    );

    final remainingPokemon = player.team
        .where((pokemon) => !pokemon.isStarter)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF080B10),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white70,
                ),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'PRÓXIMO TREINADOR',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      player.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 40),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: _starterRevealed
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFFC857)
                                    .withValues(alpha: 0.20),
                                blurRadius: 50,
                                spreadRadius: 8,
                              ),
                            ]
                          : [],
                        color: _starterRevealed
                            ? const Color(0xFFFFC857)
                                .withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.03),
                        border: Border.all(
                          color: _starterRevealed
                              ? const Color(0xFFFFC857)
                                  .withValues(alpha: 0.4)
                              : Colors.white.withValues(alpha: 0.08),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 650),
                          transitionBuilder: (child, animation) {
                            final scaleAnimation = Tween<double>(
                              begin: 0.4,
                              end: 1.0,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutBack,
                              ),
                            );

                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: scaleAnimation,
                                child: child,
                              ),
                            );
                          },
                          child: _starterRevealed
                              ? PokemonSprite(
                                  key: ValueKey(starter.id),
                                  pokemonId: starter.id,
                                  size: 180,
                                )
                              : Text(
                                  _countdown?.toString() ?? '?',
                                  key: ValueKey(_countdown ?? 'hidden'),
                                  style: TextStyle(
                                    fontSize: _countdown != null ? 110 : 100,
                                    fontWeight: FontWeight.w900,
                                    color: _countdown != null
                                        ? const Color(0xFFFFC857)
                                        : Colors.white24,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _starterRevealed
                          ? Column(
                              key: const ValueKey('revealed'),
                              children: [
                                const Text(
                                  'SEU STARTER É',
                                  style: TextStyle(
                                    color: Color(0xFFFFC857),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  starter.name.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Wrap(
                                  spacing: 6,
                                  alignment: WrapAlignment.center,
                                  children: starter.types.map((type) {
                                    return TypeBadge(type: type);
                                  }).toList(),
                                ),
                              ],
                            )
                          : const Text(
                              'SEU STARTER SERÁ...',
                              key: ValueKey('waiting'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),

                    const SizedBox(height: 32),

                    // BOTÃO PARA REVELAR O STARTER
                    if (!_starterRevealed)
                      FilledButton.icon(
                      onPressed: _countdown == null
                          ? _revealTeam
                          : null,
                        icon: const Icon(
                          Icons.catching_pokemon_rounded,
                        ),
                        label: const Text('REVELAR'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 18,
                          ),
                        ),
                      ),

                    // DEPOIS DO STARTER, MOSTRA OS OUTROS 5
                    if (_starterRevealed) ...[
                      SizedBox(
                        width: 600,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(
                            remainingPokemon.length,
                            (index) {
                              final pokemon = remainingPokemon[index];
                              final revealed =
                                  index < _revealedPokemonCount;

                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (child, animation) {
                                  final scaleAnimation = Tween<double>(
                                    begin: 0.65,
                                    end: 1.0,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutBack,
                                    ),
                                  );

                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: scaleAnimation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  key: ValueKey(
                                    '$index-$revealed',
                                  ),
                                  width: 100,
                                  height: 125,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: revealed
                                        ? Colors.white.withValues(
                                            alpha: 0.04,
                                          )
                                        : Colors.white.withValues(
                                            alpha: 0.02,
                                          ),
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha:
                                            revealed ? 0.10 : 0.05,
                                      ),
                                    ),
                                    boxShadow: revealed
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFFE53935)
                                                .withValues(alpha: 0.10),
                                            blurRadius: 18,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : [],
                                  ),
                                  child: revealed
                                      ? Column(
                                          children: [
                                            Expanded(
                                              child: PokemonSprite(
                                                pokemonId: pokemon.id,
                                                size: 72,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              pokemon.name,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              textAlign:
                                                  TextAlign.center,
                                              style:
                                                  const TextStyle(
                                                fontSize: 11,
                                                fontWeight:
                                                    FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const Center(
                                          child: Text(
                                            '?',
                                            style: TextStyle(
                                              fontSize: 38,
                                              fontWeight:
                                                  FontWeight.w900,
                                              color: Colors.white12,
                                            ),
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (_revealedPokemonCount == remainingPokemon.length)
                        FilledButton.icon(
                          onPressed: _currentPlayerIndex < widget.players.length - 1
                              ? _nextPlayer
                              : () {
                                  Navigator.pop(context);
                                },
                          icon: Icon(
                            _currentPlayerIndex < widget.players.length - 1
                                ? Icons.arrow_forward_rounded
                                : Icons.check_rounded,
                          ),
                          label: Text(
                            _currentPlayerIndex < widget.players.length - 1
                                ? 'PRÓXIMO TREINADOR'
                                : 'FINALIZAR',
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 16,
                            ),
                          ),
                        ),

                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}