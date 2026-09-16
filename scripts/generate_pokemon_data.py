import json
import urllib.request
from pathlib import Path
import time

OUTPUT_PATH = Path("assets/data/pokemon.json")

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


def load_pokemon():
    pokemon_list = []

    print("Baixando dados dos Pokémon...")

    for pokemon_id in range(1, MAX_POKEMON_ID + 1):
        url = f"https://pokeapi.co/api/v2/pokemon/{pokemon_id}"

        try:
            data = fetch_json(url)

            types = [
                item["type"]["name"]
                for item in sorted(
                    data["types"],
                    key=lambda item: item["slot"],
                )
            ]

            pokemon = {
                "id": pokemon_id,
                "name": data["name"].replace("-", " ").title(),
                "types": types,
                "isStarter": pokemon_id in STARTER_IDS,
            }

            pokemon_list.append(pokemon)

            print(
                f"[{pokemon_id}/{MAX_POKEMON_ID}] "
                f"{pokemon['name']}"
            )

        except Exception as error:
            print(
                f"Erro ao carregar Pokémon "
                f"{pokemon_id}: {error}"
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