from queries import (
    get_unique_unit,
    get_units_available,
    get_units_requiring_resource,
    get_buildings_for_district,
    get_tech_for_unit,
    get_units_of_next_era,
    get_unlocked_by_resource,
    get_best_for_style,
)


def recommend(prolog, profile):
    tips = []
    civ = profile["civ"]
    era = profile["era"]
    resources = profile["resources"]
    playstyle = profile["playstyle"]

    # 1. Уникальный юнит
    unique = get_unique_unit(prolog, civ)
    if unique:
        tips.append(f"Твой уникальный юнит: {unique[0]}")

    # 2. Доступные юниты
    if era is not None:
        available = get_units_available(prolog, era, resources)
        if available:
            tips.append(f"В эту эру доступны юниты: {', '.join(available)}")
        else:
            tips.append("В эту эру нет доступных юнитов при данных ресурсах")
    else:
        available = get_units_available(prolog, None, resources)
        tips.append(f"Все доступные юниты: {', '.join(available)}")

    # 3. Лучший юнит под стиль (из БЗ)
    if playstyle is not None and era is not None:
        best = get_best_for_style(prolog, playstyle, era, resources)
        if best:
            tips.append(f"Лучший юнит для твоего стиля игры: {best[0]}")
        else:
            tips.append(f"В эру {era} нет юнитов под стиль {playstyle}")

    # 4. Технология для лучшего юнита
    if playstyle is not None and era is not None:
        best = get_best_for_style(prolog, playstyle, era, resources)
        if best:
            tech = get_tech_for_unit(prolog, best[0])
            if tech:
                tips.append(f"Чтобы строить {best[0]}, нужна технология: {tech}")

    # 5. Что откроется в следующей эре
    if era is not None:
        next_era, next_units = get_units_of_next_era(prolog, era)
        if next_era is not None and next_units:
            tips.append(
                f"В следующей эре ({next_era}) откроются: {', '.join(next_units)}"
            )

    # 6. Что станет доступно при добыче ресурса
    if era is not None:
        for res in ("iron", "horses"):
            if res not in resources:
                unlocked = get_unlocked_by_resource(prolog, era, resources, res)
                if unlocked:
                    tips.append(
                        f"Если добудешь {res}, сможешь строить: {', '.join(unlocked)}"
                    )
    else:
        for res in ("iron", "horses"):
            if res not in resources:
                blocked = get_units_requiring_resource(prolog, res)
                if blocked:
                    tips.append(
                        f"Если добудешь {res}, сможешь строить: {', '.join(blocked)}"
                    )

    return tips