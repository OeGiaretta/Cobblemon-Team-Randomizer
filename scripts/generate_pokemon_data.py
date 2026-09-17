import json
import urllib.request
from pathlib import Path
import time

OUTPUT_PATH = Path("assets/data/pokemon.json")
INPUT_PATH = Path("assets/data/old_pokemon.json")

MAX_POKEMON_ID = 1025


STARTER_IDS = {
    # Gen 1
    3, 6, 9,

    # Gen 2
    154, 157, 160,

    # Gen 3
    254, 257, 260,

    # Gen 4
    389, 392, 395,

    # Gen 5
    497, 500, 503,

    # Gen 6
    652, 655, 658,

    # Gen 7
    724, 727, 730,

    # Gen 8
    812, 815, 818,

    # Gen 9
    908, 911, 914,
}


def fetch_json(url, max_attempts=5):
    for attempt in range(1, max_attempts + 1):
        try:
            request = urllib.request.Request(
                url,
                headers={
                    "User-Agent": "Cobblemon-Team-Randomizer"
                },
            )

            with urllib.request.urlopen(
                request,
                timeout=15,
            ) as response:
                return json.loads(
                    response.read().decode()
                )

        except Exception as error:
            print(
                f"Tentativa {attempt}/{max_attempts} "
                f"falhou: {error}"
            )

            if attempt < max_attempts:
                time.sleep(2)

    raise Exception(
        f"Falha após {max_attempts} tentativas."
    )

def is_final_evolution(pokemon_id):
    species_url = (
        f"https://pokeapi.co/api/v2/pokemon-species/{pokemon_id}/"
    )

    species_data = fetch_json(species_url)

    evolution_chain_url = species_data["evolution_chain"]["url"]
    evolution_data = fetch_json(evolution_chain_url)

    pokemon_name = species_data["name"]

    def find_species(chain):
        if chain["species"]["name"] == pokemon_name:
            return chain

        for evolution in chain["evolves_to"]:
            result = find_species(evolution)

            if result is not None:
                return result

        return None

    species_node = find_species(
        evolution_data["chain"]
    )

    if species_node is None:
        return False

    return len(species_node["evolves_to"]) == 0

def load_pokemon():
    print("Filtrando apenas formas finais...")

    with open(INPUT_PATH, "r", encoding="utf-8") as file:
        original_pokemon = json.load(file)

    pokemon_list = []

    total = len(original_pokemon)

    for index, pokemon in enumerate(original_pokemon, start=1):
        try:
            if is_final_evolution(pokemon["id"]):
                pokemon_list.append(pokemon)
                status = "✓"
            else:
                status = "✗"

            print(
                f"[{index}/{total}] {status} {pokemon['name']}"
            )

        except Exception as error:
            print(
                f"Erro ao verificar {pokemon['name']}: {error}"
            )

    return pokemon_list


def save_json(pokemon_list):
    OUTPUT_PATH.parent.mkdir(
        parents=True,
        exist_ok=True,
    )

    with open(
        OUTPUT_PATH,
        "w",
        encoding="utf-8",
    ) as file:
        json.dump(
            pokemon_list,
            file,
            ensure_ascii=False,
            indent=2,
        )


def main():
    pokemon_list = load_pokemon()

    save_json(pokemon_list)

    print()
    print("------------------------------")
    print("Base gerada com sucesso!")
    print(f"Pokémon: {len(pokemon_list)}")
    print(f"Arquivo: {OUTPUT_PATH}")
    print("------------------------------")


if __name__ == "__main__":
    main()