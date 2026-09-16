import 'package:flutter/material.dart';

import 'models/player.dart';
import 'models/pokemon.dart';

import 'services/team_randomizer.dart';

import 'data/pokemon_repository.dart';


void main() {
  runApp(const CobblemonRandomizerApp());
}

class CobblemonRandomizerApp extends StatelessWidget {
  const CobblemonRandomizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cobblemon Team Randomizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE53935),
        ),
      ),
      home: const HomePage(),
    );
  }
}

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

    setState(() {
      if (result == null) {
        _players = [];
        _errorMessage =
            'Não foi possível gerar todos os times com os Pokémon disponíveis.';
      } else {
        _players = result;
        _errorMessage = null;
      }
    });
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
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.catching_pokemon,
                  size: 72,
                  color: Color(0xFFE53935),
                ),

                const SizedBox(height: 16),

                Text(
                  'Cobblemon Team Randomizer',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '6 Pokémon • 1 Starter • No repeated types',
                ),

                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _playerController,
                        onSubmitted: (_) => _addPlayer(),
                        decoration: const InputDecoration(
                          labelText: 'Nome do jogador',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _addPlayer,
                      icon: const Icon(Icons.person_add),
                      label: const Text('Adicionar'),
                    ),
                  ],
                ),

                if (_playerNames.isNotEmpty) ...[
                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: _playerNames.map((name) {
                      return Chip(
                        label: Text(name),
                        onDeleted: () => _removePlayer(name),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 28),

                FilledButton.icon(
                  onPressed: _generateTeams,
                  icon: const Icon(Icons.casino),
                  label: const Text('Sortear Times'),
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

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth =
                          constraints.maxWidth >= 800
                              ? 360.0
                              : constraints.maxWidth;

                      return Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: _players.map((player) {
                          return SizedBox(
                            width: cardWidth,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      player.name,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),

                                    const SizedBox(height: 16),

                                    ...player.team.map((pokemon) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          child: Text(
                                            pokemon.id.toString(),
                                          ),
                                        ),
                                        title: Text(
                                          pokemon.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          pokemon.types
                                              .join(' / ')
                                              .toUpperCase(),
                                        ),
                                        trailing: pokemon.isStarter
                                            ? const Icon(
                                                Icons.star,
                                              )
                                            : null,
                                      );
                                    }),
                                  ],
                                ),
                              ),
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