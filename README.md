# 🎲 Cobblemon Team Randomizer

Um randomizador de equipes desenvolvido em **Flutter Web** para gerar times de Pokémon para partidas de **Cobblemon**.

O projeto cria equipes aleatórias para vários jogadores seguindo regras que tornam o sorteio mais equilibrado e interessante.

## ✨ Funcionalidades

- 👥 Suporte a múltiplos jogadores
- 🎲 Sorteio automático das equipes
- 🐉 6 Pokémon por jogador
- ⭐ 1 Pokémon inicial por equipe
- 🚫 Nenhum Pokémon repetido entre os jogadores
- 🔥 Tipagens únicas dentro de cada equipe
- 🎬 Sistema animado de revelação dos times
- ⏱️ Contagem regressiva antes da revelação
- 🏆 Tela de conclusão do sorteio
- 📱 Interface responsiva
- 🌐 Execução diretamente no navegador

## 🎯 Regras do sorteio

Cada jogador recebe exatamente **6 Pokémon**.

### Starter

Cada equipe possui exatamente **1 Pokémon designado como Starter**.

### Pokémon únicos

Um Pokémon sorteado para um jogador não pode aparecer novamente no time de outro jogador durante o mesmo sorteio.

### Formas evolutivas finais

O sorteio utiliza apenas Pokémon que estejam no **estágio final de sua linha evolutiva** ou espécies que **não possuem evolução**.

Isso evita que formas básicas ou intermediárias sejam sorteadas junto com Pokémon completamente evoluídos.

Exemplos:

- Charmander ❌
- Charmeleon ❌
- Charizard ✅

- Bulbasaur ❌
- Ivysaur ❌
- Venusaur ✅

- Caterpie ❌
- Metapod ❌
- Butterfree ✅

Pokémon que não possuem evolução também permanecem disponíveis no sorteio.

A base atual possui **568 Pokémon elegíveis**, incluindo os **27 starters finais** das nove gerações.

### 🔧 Usando todos os Pokémon

Por padrão, o randomizador utiliza apenas Pokémon no estágio final de sua linha evolutiva ou espécies que não possuem evolução.

O dataset original completo foi preservado no projeto:

```text
assets/data/old_pokemon.json

### Tipagens únicas

Dentro de uma equipe, nenhuma tipagem pode se repetir.

Por exemplo, se um Pokémon possuir:

```text
Fire / Flying
```

nenhum outro Pokémon daquela equipe poderá possuir `Fire` ou `Flying`.

O algoritmo utiliza **backtracking** para encontrar combinações válidas de Pokémon respeitando essas regras.

## 🎬 Team Reveal

Os times não são apresentados imediatamente após o sorteio.

O projeto possui uma experiência de revelação onde:

1. O treinador é apresentado
2. Uma contagem regressiva `3... 2... 1...` é iniciada
3. O Starter é revelado
4. Os outros cinco Pokémon aparecem progressivamente
5. O usuário decide quando avançar para o próximo treinador
6. Ao final, todos os times podem ser visualizados juntos

## 🛠️ Tecnologias

- **Flutter**
- **Dart**
- **Flutter Web**
- **PokéAPI**
- **Python** — geração do dataset utilizado pelo projeto

## 📁 Estrutura

```text
lib/
├── data/
│   └── pokemon_repository.dart
├── models/
│   ├── player.dart
│   └── pokemon.dart
├── pages/
│   ├── home_page.dart
│   └── team_reveal_page.dart
├── services/
│   └── team_randomizer.dart
└── widgets/
    ├── app_header.dart
    ├── player_panel.dart
    ├── pokemon_sprite.dart
    ├── pokemon_team_slot.dart
    ├── randomize_button.dart
    ├── results_header.dart
    ├── team_card.dart
    └── type_badge.dart
```

## 🚀 Executando o projeto

Clone o repositório:

```bash
git clone https://github.com/OeGiaretta/Cobblemon-Team-Randomizer
```

Entre na pasta:

```bash
cd Cobblemon-Team-Randomizer
```

Instale as dependências:

```bash
flutter pub get
```

Execute no Chrome:

```bash
flutter run -d chrome
```

Ou apenas acesse o link: https://pokerandom-one.vercel.app/

## 🧪 Verificação

Para analisar o projeto:

```bash
flutter analyze
```

A versão atual passa pelo Flutter Analyzer sem issues.

## 🗺️ Próximos passos

Algumas funcionalidades que podem ser adicionadas futuramente:

- Filtros por geração
- Banlist de Pokémon
- Controle de lendários
- Balanceamento por BST
- Reroll individual
- Compartilhamento dos times
- Salas para sorteios
- Sprites locais para funcionamento offline
- Filtro específico para Pokémon disponíveis no Cobblemon

## 📌 Status

**V1 — Funcional**

O núcleo do randomizador, a interface, o sistema de revelação e a visualização final dos times estão implementados.

---

Desenvolvido com Flutter para tornar os sorteios de equipes no Cobblemon mais divertidos.
