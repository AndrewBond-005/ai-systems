def _as_list(res):
    if not isinstance(res, list):
        return []
    return res


def get_unique_unit(prolog, civ):
    res = prolog.query(f"unique_unit_of({civ}, U)")
    return [row["U"] for row in _as_list(res)]


def get_units_in_era(prolog, era):
    res = prolog.query(f"military_units_in_era({era}, U)")
    return [row["U"] for row in _as_list(res)]


def get_all_military_units(prolog):
    res = prolog.query("military_unit(U)")
    return [row["U"] for row in _as_list(res)]


def get_required_resources(prolog, unit):
    res = prolog.query(f"requires_resource({unit}, R)")
    return [row["R"] for row in _as_list(res)]


def get_units_available(prolog, era, resources):
    if era is None:
        pool = get_all_military_units(prolog)
    else:
        pool = get_units_in_era(prolog, era)

    available = []
    for unit in pool:
        needed = get_required_resources(prolog, unit)
        ok = True
        for r in needed:
            if r not in resources:
                ok = False
                break
        if ok:
            available.append(unit)
    return available


def get_units_requiring_resource(prolog, resource):
    res = prolog.query(f"units_requiring_resource({resource}, U)")
    return [row["U"] for row in _as_list(res)]


def get_buildings_for_district(prolog, district):
    res = prolog.query(f"buildings_in_district({district}, B)")
    return [row["B"] for row in _as_list(res)]


def get_all_civilizations(prolog):
    res = prolog.query("civilization(X)")
    return [row["X"] for row in _as_list(res)]


def get_all_eras(prolog):
    res = prolog.query("era(X)")
    return [row["X"] for row in _as_list(res)]


def get_all_resources(prolog):
    res = prolog.query("resource(X)")
    return [row["X"] for row in _as_list(res)]


def get_tech_for_unit(prolog, unit):
    res = prolog.query(f"unlocks_unit(T, {unit})")
    lst = _as_list(res)
    if not lst:
        return None
    return lst[0]["T"]


def get_next_era(prolog, era):
    res = prolog.query(f"era_before({era}, E)")
    lst = _as_list(res)
    if not lst:
        return None
    return lst[0]["E"]


def get_units_of_next_era(prolog, era):
    next_era = get_next_era(prolog, era)
    if next_era is None:
        return next_era, []
    res = prolog.query(f"available_in_era(U, {next_era})")
    units = [row["U"] for row in _as_list(res)]
    return next_era, units


def get_unlocked_by_resource(prolog, era, resources, new_resource):
    res_list = "[" + ",".join(resources) + "]"
    query = f"unit_unlocked_by_resource(U, {era}, {res_list}, {new_resource})"
    res = prolog.query(query)
    return [row["U"] for row in _as_list(res)]


def get_best_for_style(prolog, style, era, resources):
    res_list = "[" + ",".join(resources) + "]"
    query = f"best_unit_for_style(U, {style}, {era}, {res_list})"
    res = prolog.query(query)
    return [row["U"] for row in _as_list(res)]