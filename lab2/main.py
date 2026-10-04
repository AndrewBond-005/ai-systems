import os
from swiplserver import PrologMQI, create_posix_path

from parser import parse_input
from recommend import recommend
from queries import (
    get_all_civilizations,
    get_all_eras,
    get_all_resources,
)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
KB_PATH = os.path.join(BASE_DIR, "knowledge_base.pl")

def print_help(prolog):
    civs = get_all_civilizations(prolog)
    eras = get_all_eras(prolog)
    resources = get_all_resources(prolog)

    print("Шаблон: Я играю за <civ>[, сейчас эра <era>][, ресурсы <r1>, <r2>][, стиль melee|ranged]")
    print("Цивилизации:", ", ".join(civs))
    print("Эпохи:", ", ".join(eras))
    print("Ресурсы:", ", ".join(resources))



def main():
    with PrologMQI() as mqi:
        with mqi.create_thread() as prolog:
            path = create_posix_path(KB_PATH)
            prolog.query(f'consult("{path}")')
            prolog.query("set_prolog_flag(encoding, utf8)")

            print_help(prolog)

            while True:
                line = input("> ").strip()
                if line.lower() == "exit":
                    break
                if not line:
                    continue

                profile, error = parse_input(line)
                if error:
                    print("Ошибка:", error)
                    continue

                print("Рекомендации:")
                tips = recommend(prolog, profile)
                for t in tips:
                    print("  -", t)
                print()


if __name__ == "__main__":
    main()