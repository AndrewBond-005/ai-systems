import re

CIVILIZATIONS = [
    "russia", "egypt", "china", "greece", "persia", "mongolia",
    "rome", "scotland", "japan", "zulu", "korea",
]

ERAS = [
    "ancient", "classical", "medieval", "renaissance",
    "industrial", "modern", "information",
]

RESOURCES = ["iron", "horses"]

STYLES = ["melee", "ranged"]

PATTERN = re.compile(
    r"^\s*Я играю за\s+(\w+)"
    r"(?:\s*,\s*(?:сейчас\s+)?эра\s+(\w+))?"
    r"(?:\s*,\s*ресурсы:?\s*([\w\s,]+?))?"
    r"(?:\s*,\s*стиль:?\s*(\w+))?"
    r"\s*$",
    re.IGNORECASE,
)


def parse_input(line):
    m = PATTERN.match(line)
    if m is None:
        return None, "Строка не по шаблону"

    civ = m.group(1).lower()
    if civ not in CIVILIZATIONS:
        return None, f"Неизвестная цивилизация: {civ}"

    era = m.group(2)
    if era is not None:
        era = era.lower()
        if era not in ERAS:
            return None, f"Неизвестная эра: {era}"

    style = m.group(4)
    if style is not None:
        style = style.lower()
        if style not in STYLES:
            return None, f"Неизвестный стиль: {style}"

    resources = []
    if m.group(3):
        for r in m.group(3).split(","):
            r = r.strip().lower()
            if not r:
                continue
            if r not in RESOURCES:
                return None, f"Неизвестный ресурс: {r}"
            resources.append(r)

    profile = {
        "civ": civ,
        "era": era,
        "resources": resources,
        "playstyle": style,
    }
    return profile, None