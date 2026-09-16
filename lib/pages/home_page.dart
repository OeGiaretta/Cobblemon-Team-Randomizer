import 'package:flutter/material.dart';

import '../models/player.dart';
import '../models/pokemon.dart';

import '../widgets/app_header.dart';
import '../widgets/player_panel.dart';
import '../widgets/randomize_button.dart';
import '../widgets/team_card.dart';
import '../widgets/results_header.dart';

import '../data/pokemon_repository.dart';

import '../services/team_randomizer.dart';

import 'team_reveal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TeamRandomizer _randomizer = TeamRandomizer();
  final PokemonRepository _pokemonRepository = PokemonRepository();
  final TextEditingController _playerController = TextEditingController();

  final List<String> _playerNames = [];

  List<Pokemon> _pokemonPool = [];
  List<Player> _players = [];

  bool _isLoadingPokemon = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPokemon();
  }

  Future<void> _loadPokemon() async {
    try {
      final pokemon = await _pokemonRepository.loadPokemon();

      if (!mounted) return;

      setState(() {
        _pokemonPool = pokemon;
        _isLoadingPokemon = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoadingPokemon = false;
        _errorMessage = 'Erro ao carregar os Pokémon.';
      });
    }
  }

  void _addPlayer() {
    final name = _playerController.text.trim();

    if (name.isEmpty) {
      return;
    }

    final alreadyExists = _playerNames.any(
      (player) => player.toLowerCase() == name.toLowerCase(),
    );

    if (alreadyExists) {
      setState(() {
        _errorMessage = 'Esse jogador já foi adicionado.';
      });
      return;
    }

    setState(() {
      _playerNames.add(name);
      _playerController.clear();
      _players = [];
      _errorMessage = null;
    });
  }

  void _removePlayer(String name) {
    setState(() {
      _playerNames.remove(name);
      _players = [];
      _errorMessage = null;
    });
  }

  void _generateTeams() {
    if (_isLoadingPokemon) {
      setState(() {
        _errorMessage = 'Os Pokémon ainda estão sendo carregados.';
      });
      return;
    }

    if (_pokemonPool.isEmpty) {
      setState(() {
        _errorMessage = 'Nenhum Pokémon foi carregado.';
      });
      return;
    }

    if (_playerNames.isEmpty) {
      setState(() {
        _errorMessage = 'Adicione pelo menos um jogador.';
      });
      return;
    }

    final result = _randomizer.generateTeams(
      playerNames: _playerNames,
      pokemonPool: _pokemonPool,
    );

    if (result == null) {
      setState(() {
        _players = [];
        _errorMessage =
            'Não foi possível gerar todos os times com os Pokémon disponíveis.';
      });

      return;
    }

    setState(() {
      _players = result;
      _errorMessage = null;
    });

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TeamRevealPage(players: result)),
    );
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cobblemon Team Randomizer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const AppHeader(),

                const SizedBox(height: 32),

                PlayerPanel(
                  controller: _playerController,
                  playerNames: _playerNames,
                  onAddPlayer: _addPlayer,
                  onRemovePlayer: _removePlayer,
                ),

                const SizedBox(height: 24),

                RandomizeButton(
                  onPressed: _generateTeams,
                  enabled: !_isLoadingPokemon && _playerNames.isNotEmpty,
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],

                if (_players.isNotEmpty) ...[
                const SizedBox(height: 40),

                ResultsHeader(
                    playerCount: _players.length,
                    pokemonCount: _players.fold<int>(
                    0,
                    (total, player) => total + player.team.length,
                    ),
                ),

                const SizedBox(height: 24),

                LayoutBuilder(
                    builder: (context, constraints) {
                    final cardWidth = constraints.maxWidth >= 1100
                        ? 520.0
                        : constraints.maxWidth >= 700
                            ? 480.0
                            : constraints.maxWidth;

                    return Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children: _players.map((player) {
                        return SizedBox(
                            width: cardWidth,
                            child: TeamCard(
                            player: player,
                            ),
                        );
                        }).toList(),
                    );
                    },
                ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
