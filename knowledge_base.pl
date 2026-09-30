% ============================================================
% Civilization Game Knowledge Base (конвертировано из RDF/OWL)
% ============================================================

% ---------- Классы (факты "является") ----------

unit_type(warrior).
unit_type(archer).
unit_type(horseman).
unit_type(catapult).
unit_type(karavella).
unit_type(swordsman).
unit_type(crossbowman).
unit_type(knight).
unit_type(trebuchet).
unit_type(caravel).
unit_type(scout).
unit_type(settler).
unit_type(builder).
unit_type(rock_band).
unit_type(legion).
unit_type(maryannu_chariot_archer).
unit_type(hoplite).
unit_type(immortal).
unit_type(highlander).
unit_type(samurai).
unit_type(cossack).
unit_type(chu_ko_nu).
unit_type(keshig).
unit_type(impi).
unit_type(hwacha).

% MilitaryUnit — подкласс UnitType
military_unit(X) :- unit_type(X), \+ non_military_unit(X), \+ civilization_unit(X).

% NonMilitaryUnit — подкласс UnitType
non_military_unit(settler).
non_military_unit(builder).
non_military_unit(rock_band).

% CivilizationUnit — уникальные юниты цивилизаций
civilization_unit(legion).
civilization_unit(maryannu_chariot_archer).
civilization_unit(hoplite).
civilization_unit(immortal).
civilization_unit(highlander).
civilization_unit(samurai).
civilization_unit(cossack).
civilization_unit(chu_ko_nu).
civilization_unit(keshig).
civilization_unit(impi).
civilization_unit(hwacha).

civilization(russia).
civilization(egypt).
civilization(china).
civilization(greece).
civilization(persia).
civilization(mongolia).
civilization(rome).
civilization(scotland).
civilization(japan).
civilization(zulu).
civilization(korea).

era(ancient).
era(classical).
era(medieval).
era(renaissance).
era(industrial).
era(modern).
era(information).

resource(iron).
resource(horses).

technology(bronze_working).
technology(archery).
technology(horseback_riding).
technology(iron_working).
technology(mathematics).
technology(military_tactics).
technology(chivalry).
technology(machinery).
technology(naval_tradition).
technology(cartography).

building(barracks).
building(archery_range).
building(stable).
building(lighthouse).
building(shipyard).
building(arena).

district(encampment).
district(harbor).
district(entertainment_complex).

% ---------- Имена (Data Property: name) ----------

name(warrior, 'Warrior').
name(archer, 'Archer').
name(horseman, 'Horseman').
name(catapult, 'Catapult').
name(karavella, 'Karavella').
name(swordsman, 'Swordsman').
name(crossbowman, 'Crossbowman').
name(knight, 'Knight').
name(trebuchet, 'Trebuchet').
name(caravel, 'Caravel').
name(scout, 'Scout').
name(settler, 'Settler').
name(builder, 'Builder').
name(rock_band, 'Rock Band').
name(legion, 'Legion').
name(maryannu_chariot_archer, 'Maryannu Chariot Archer').
name(hoplite, 'Hoplite').
name(immortal, 'Immortal').
name(highlander, 'Highlander').
name(samurai, 'Samurai').
name(cossack, 'Cossack').
name(chu_ko_nu, 'Chu Ko Nu').
name(keshig, 'Keshig').
name(impi, 'Impi').
name(hwacha, 'Hwacha').

name(ancient, 'Ancient').
name(classical, 'Classical').
name(medieval, 'Medieval').
name(renaissance, 'Renaissance').
name(industrial, 'Industrial').
name(modern, 'Modern').
name(information, 'Information').

name(russia, 'Russia').
name(egypt, 'Egypt').
name(china, 'China').
name(greece, 'Greece').
name(persia, 'Persia').
name(mongolia, 'Mongolia').
name(rome, 'Rome').
name(scotland, 'Scotland').
name(japan, 'Japan').
name(zulu, 'Zulu').
name(korea, 'Korea').

name(iron, 'Iron').
name(horses, 'Horses').

name(bronze_working, 'Bronze Working').
name(archery, 'Archery').
name(horseback_riding, 'Horseback Riding').
name(iron_working, 'Iron Working').
name(mathematics, 'Mathematics').
name(military_tactics, 'Military Tactics').
name(chivalry, 'Chivalry').
name(machinery, 'Machinery').
name(naval_tradition, 'Naval Tradition').
name(cartography, 'Cartography').

name(barracks, 'Barracks').
name(archery_range, 'Archery Range').
name(stable, 'Stable').
name(lighthouse, 'Lighthouse').
name(shipyard, 'Shipyard').
name(arena, 'Arena').

name(encampment, 'Encampment').
name(harbor, 'Harbor').
name(entertainment_complex, 'Entertainment Complex').


% ---------- Object Properties ----------

% requiresResource(UnitType, Resource)
requires_resource(swordsman, iron).
requires_resource(crossbowman, iron).
requires_resource(knight, horses).
requires_resource(knight, iron).

% availableInEra(UnitType, Era)
available_in_era(warrior, ancient).
available_in_era(archer, ancient).
available_in_era(scout, ancient).
available_in_era(horseman, classical).
available_in_era(swordsman, classical).
available_in_era(catapult, classical).
available_in_era(crossbowman, medieval).
available_in_era(knight, medieval).
available_in_era(trebuchet, medieval).
available_in_era(caravel, renaissance).

% unlocksUnit(Technology, UnitType)
unlocks_unit(bronze_working, warrior).
unlocks_unit(archery, archer).
unlocks_unit(horseback_riding, horseman).
unlocks_unit(iron_working, swordsman).
unlocks_unit(mathematics, catapult).
unlocks_unit(military_tactics, crossbowman).
unlocks_unit(chivalry, knight).
unlocks_unit(machinery, trebuchet).
unlocks_unit(cartography, caravel).

% civHasUniqueUnit(Civilization, UnitType)
civ_unique_unit(russia, cossack).
civ_unique_unit(egypt, maryannu_chariot_archer).
civ_unique_unit(china, chu_ko_nu).
civ_unique_unit(greece, hoplite).
civ_unique_unit(persia, immortal).
civ_unique_unit(mongolia, keshig).
civ_unique_unit(rome, legion).
civ_unique_unit(scotland, highlander).
civ_unique_unit(japan, samurai).
civ_unique_unit(zulu, impi).
civ_unique_unit(korea, hwacha).


% Ближний бой (melee)
unit_style(warrior, melee).
unit_style(horseman, melee).
unit_style(swordsman, melee).
unit_style(knight, melee).
unit_style(scout, melee).
unit_style(legion, melee).
unit_style(hoplite, melee).
unit_style(immortal, melee).
unit_style(highlander, melee).
unit_style(samurai, melee).
unit_style(cossack, melee).
unit_style(keshig, melee).
unit_style(impi, melee).

% Дальний бой (ranged)
unit_style(archer, ranged).
unit_style(catapult, ranged).
unit_style(crossbowman, ranged).
unit_style(trebuchet, ranged).
unit_style(chu_ko_nu, ranged).
unit_style(hwacha, ranged).
unit_style(maryannu_chariot_archer, ranged).

% buildingInDistrict(Building, District)
building_in_district(barracks, encampment).
building_in_district(archery_range, encampment).
building_in_district(stable, encampment).
building_in_district(lighthouse, harbor).
building_in_district(shipyard, harbor).
building_in_district(arena, entertainment_complex).

% eraBefore(Era, Era)
era_before(ancient, classical).
era_before(ancient, medieval).
era_before(ancient, renaissance).
era_before(ancient, industrial).
era_before(ancient, modern).
era_before(ancient, information).

era_before(classical, medieval).
era_before(classical, renaissance).
era_before(classical, industrial).
era_before(classical, modern).
era_before(classical, information).

era_before(medieval, renaissance).
era_before(medieval, industrial).
era_before(medieval, modern).
era_before(medieval, information).

era_before(renaissance, industrial).
era_before(renaissance, modern).
era_before(renaissance, information).

era_before(industrial, modern).
era_before(industrial, information).

era_before(modern, information).

% ---------- Полезные правила для запросов ----------

% Юнит доступен в эре E, если он явно в ней или в любой более ранней эре,
% а также если его открывает технология, доступная к этой эре.
unit_available_in_era(Unit, Era) :-
    available_in_era(Unit, Era).

unit_available_in_era(Unit, Era) :-
    available_in_era(Unit, EarlierEra),
    era_before(EarlierEra, Era).

% Какие юниты военного типа доступны в эре
military_units_in_era(Era, Unit) :-
    military_unit(Unit),
    unit_available_in_era(Unit, Era).

% Юниты, требующие конкретный ресурс
units_requiring_resource(Resource, Unit) :-
    requires_resource(Unit, Resource).

% Уникальный юнит цивилизации
unique_unit_of(Civ, Unit) :-
    civ_unique_unit(Civ, Unit).

% Какие здания можно построить в районе
buildings_in_district(District, Building) :-
    building_in_district(Building, District).


% Юнит доступен в эру Era, если он открывается в эту или более раннюю эру
% и все требуемые ресурсы у игрока есть.
unit_buildable(Unit, Era, Resources) :-
    military_unit(Unit),
    unit_available_in_era(Unit, Era),
    forall(requires_resource(Unit, R), member(R, Resources)).

% Юнит станет доступен, если добавить ресурс NewRes к Resources,
% но только если сейчас он ещё не доступен.
unit_unlocked_by_resource(Unit, Era, Resources, NewRes) :-
    \+ member(NewRes, Resources),
    military_unit(Unit),
    unit_available_in_era(Unit, Era),
    requires_resource(Unit, NewRes),
    unit_buildable(Unit, Era, [NewRes|Resources]).

best_unit_for_style(Unit, Style, Era, Resources) :-
    unit_style(Unit, Style),
    unit_buildable(Unit, Era, Resources).