import 'package:flutter/material.dart';

class PlayerPanel extends StatelessWidget {
  final TextEditingController controller;
  final List<String> playerNames;
  final VoidCallback onAddPlayer;
  final void Function(String name) onRemovePlayer;

  const PlayerPanel({
    super.key,
    required this.controller,
    required this.playerNames,
    required this.onAddPlayer,
    required this.onRemovePlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.groups_rounded,
                size: 22,
                color: Color(0xFFFF6B6B),
              ),
              SizedBox(width: 10),
              Text(
                'Jogadores',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Adicione quem vai participar do sorteio.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => onAddPlayer(),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Nome do jogador',
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF0D1117),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              FilledButton.icon(
                onPressed: onAddPlayer,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Adicionar'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),

          if (playerNames.isNotEmpty) ...[
            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: playerNames.map((name) {
                return Chip(
                  avatar: const CircleAvatar(
                    child: Icon(
                      Icons.person_rounded,
                      size: 16,
                    ),
                  ),
                  label: Text(name),
                  deleteIcon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                  ),
                  onDeleted: () => onRemovePlayer(name),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}