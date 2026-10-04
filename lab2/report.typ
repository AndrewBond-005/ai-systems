#import "@preview/zebraw:0.6.1": *
// ==================== НАСТРОЙКИ ДОКУМЕНТА ====================
#set page(paper: "a4", margin: (left: 2.5cm, right: 2.5cm, top: 3cm, bottom: 2cm), numbering: none)


#show figure: set figure(kind: "image", supplement: none)

#set text(font: "Times New Roman", size: 13pt)

#set heading(numbering: none)
#show heading: it => {
  set text(size: 14pt, weight: "bold")
  it
}

// ==================== ТИТУЛЬНЫЙ ЛИСТ ====================
#set page(paper: "a4", margin: (left: 2.5cm, right: 2.5cm, top: 1.5cm, bottom: 2cm))

#align(center)[
  
  Федеральное государственное автономное образовательное \
  учреждение высшего образования \
  «Национальный исследовательский университет ИТМО»\
  Факультет Программной инженерии и Компьютерной техники\

  
  #v(3cm)
  
  #set text(size: 16pt, weight: "bold")
  Отчёт по Модулю №1 
  
  #set text(size: 16pt)
  по Системам Искусственного Интеллекта

  
  #set text(size: 16pt)
 Базы знаний и онтологии. 
 
 Система поддержки принятия решений
 
  #set text(size: 16pt)
  Вариант 16
  
  #v(0.3cm)

  #v(5cm)
  #text(size:14pt)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.5cm,
    align: left,
    [],
    [],
    [
      *Выполнили:* \
      Бондаренко Андрей   \
      Снагин Станислав 
      *Преподаватель:* \
      Жданов Андрей Дмитриевич
    ]
  )
]
  #v(1cm)

  #v(3cm)
  
  Санкт-Петербург 2026г.
]

#pagebreak()
// ==================== ОСНОВНАЯ ЧАСТЬ ====================
#set page(paper: "a4", margin: (left: 1.7cm, right: 1.5cm, top: 1.5cm, bottom: 1.7cm), numbering: "1")

#outline(indent: 0cm, title: "Содержание")
#pagebreak()



= Аннотация

В рамках модуля выполнены три лабораторные задачи: построена база знаний
(БЗ) на языке Prolog, описывающая игровые сущности Civilization VI, та же
модель переведена в онтологию OWL (Protege), и на её основе разработана
система поддержки принятия решений (DSS), которая по строке фиксированного
формата выдаёт игроку рекомендации. Домен - компьютерная игра Civilization VI
(юниты, эпохи, технологии, ресурсы, цивилизации). DSS использует
логический вывод Prolog: правила композиции, отрицания и кванторов
позволяют отбирать юнитов, доступных игроку в текущей эре с учётом его
ресурсов и стиля игры. Итог -  механизм
рекомендаций, где знания отделены от кода, а добавление нового юнита
требует правки только `.pl`-файла.

// ============================================================
// 3. Введение
// ============================================================

= Введение

== Цели модуля

- освоить логическое моделирование предметной области
- научиться проектировать онтологии в OWL и проверять их ризонером
- понять, как строить системы поддержки принятия решений (DSS),
  опирающиеся на формальные знания, а не на жёстко прописанные правила.

== Почему БЗ и онтологии полезны

- *Повторное использование знаний*: одна и та же модель используется
  и в Prolog, и в OWL, и в DSS.
- *Проверяемый вывод*: каждое решение можно объяснить - «юнит X доступен,
  потому что эра Y и ресурс Z».
- *Прозрачность*: правила видно, их можно читать и обсуждать, в отличие
  от весов нейросети.
- *Расширяемость*: чтобы добавить новую сущность, правим только
  базу знаний, а не код программы.

// ============================================================
// 4. База знаний в Prolog
// ============================================================

= База знаний в Prolog (ЛР1, Часть 1)

== Домен и словарь

Домен - Civilization VI. Сущности: *цивилизация*, *эпоха*, *юнит*,
*технология*, *ресурс*, *район*, *здание*. Отношения:
`requires_resource/2`, `available_in_era/2`, `unlocks_unit/2`,
`civ_unique_unit/2`, `building_in_district/2`, `era_before/2`,
`unit_style/2`.

== Требования к БЗ и как они выполнены

#table(
  columns: 2,
  [*Требование*], [*Выполнено*],
  [≥ 20 фактов с 1 аргументом], [78],
  [10–15 фактов с 2 аргументами], [100+],
  [5–7 правил], [9 правил: `military_unit/1`, `unit_available_in_era/2`,
   `military_units_in_era/2`, `units_requiring_resource/2`,
   `unique_unit_of/2`, `buildings_in_district/2`, `unit_buildable/3`,
   `unit_unlocked_by_resource/4`, `best_unit_for_style/4`],
)

== Структура файла

Файл `knowledge_base.pl` разбит на разделы:

- факты-классы (`unit_type/1`, `civilization/1`, `era/1`, …)
- факты-свойства (`requires_resource/2`, `available_in_era/2`, …)
- правила вывода (`unit_available_in_era/2`, `unit_buildable/3`, …)
- комментарии-примеры тест-запросов.

== Примеры запросов

#table(
  columns: 2,
  [#image("выполнение1.png", width: 90%)],[#image("выполнение2.png", width: 90%)]

)

// ============================================================
// 5. Онтология в Protégé
// ============================================================
= Онтология в Protégé (ЛР1, Часть 2)

== Перевод Prolog → OWL

Онтология собрана в Protégé 5.6 на основе базы знаний из ЛР1.
Соответствие между конструкциями Prolog и OWL:

#table(
  columns: 3,
  [*Prolog*], [*OWL*], [*Комментарий*],
  [`unit_type(warrior).`], [`civ:Warrior rdf:type civ:MilitaryUnit`], [индивид класса],
  [`military_unit(X) :- ...`], [`civ:MilitaryUnit` ⊑ `civ:UnitType`], [подкласс + disjoint],
  [`requires_resource(U, R)`], [`civ:requiresResource` (ObjectProperty)], [domain: UnitType, range: Resource],
  [`available_in_era(U, E)`], [`civ:availableInEra` (ObjectProperty)], [domain: UnitType, range: Era],
  [`unlocks_unit(T, U)`], [`civ:unlocksUnit` (ObjectProperty)], [domain: Technology, range: UnitType],
  [`civ_unique_unit(C, U)`], [`civ:civUniqueUnit` (ObjectProperty)], [domain: Civilization, range: UnitType],
  [`building_in_district(B, D)`], [`civ:buildingInDistrict` (ObjectProperty)], [domain: Building, range: District],
  [`unit_style(U, melee)`], [`civ:unitStyle` (ObjectProperty)], [domain: UnitType, range: Style],
  [`era_before(A, B)`], [`civ:eraBefore` (ObjectProperty, Transitive)], [domain: Era, range: Era],
  [`name(X, 'Warrior')`], [`civ:name` (DataProperty, xsd:string)], [строковое имя],
)

== Минимальный состав онтологии

=== Иерархия классов

 ```
owl:Thing
├── UnitType
│   ├── MilitaryUnit
│   │   └── CivilizationUnit
│   └── NonMilitaryUnit
├── Civilization
├── Era
├── Technology
├── Resource
├── Building
├── District
└── Style
```



=== Object Properties

#table(
  columns: 3,
  [*Свойство*], [*Domain*], [*Range*],
  [`requiresResource`], [UnitType], [Resource],
  [`availableInEra`], [UnitType], [Era],
  [`unlocksUnit`], [Technology], [UnitType],
  [`civUniqueUnit`], [Civilization], [UnitType],
  [`buildingInDistrict`], [Building], [District],
  [`unitStyle`], [UnitType], [Style],
  [`eraBefore`], [Era], [Era],
)

Свойство `eraBefore` объявлено транзитивным
(`owl:TransitiveProperty`), что позволяет ризонеру выводить
непрямые связи между эрами.


=== Кардинальности и ограничения

На ключевых отношениях заданы кардинальные ограничения:

- `availableInEra exactly 1 Era` — каждый юнит появляется ровно в одну эру;
- `requiresResource max 2 Resource` — юнит требует не более двух ресурсов.

Ограничение совместимости — `owl:AllDisjointClasses` между
`MilitaryUnit` и `NonMilitaryUnit`: ризонер поймает противоречие,
если один индивид попадёт в оба класса. Транзитивность `eraBefore`
исключает циклы в порядке эр — при попытке замкнуть цепочку
ризонер выведет `eraBefore(X, X)` и пометит онтологию как
неконсистентную.

== Трассируемость Prolog ↔ OWL

#table(
  columns: 3,
  [*Prolog*], [*OWL*], [*Комментарий*],
  [`unit_type(X)`], [`civ:UnitType` (класс)], [все юниты — индивиды],
  [`military_unit(X) :- ...`], [`civ:MilitaryUnit` + disjoint], [правило заменено явной типизацией],
  [`requires_resource(U, R)`], [`civ:requiresResource`], [ObjectProperty],
  [`available_in_era(U, E)`], [`civ:availableInEra`], [ObjectProperty],
  [`unlocks_unit(T, U)`], [`civ:unlocksUnit`], [ObjectProperty],
  [`civ_unique_unit(C, U)`], [`civ:civUniqueUnit`], [ObjectProperty],
  [`building_in_district(B, D)`], [`civ:buildingInDistrict`], [ObjectProperty],
  [`unit_style(U, melee)`], [`civ:unitStyle`], [Style — класс с индивидами melee/ranged],
  [`era_before(A, B)`], [`civ:eraBefore` (Transitive)], [встроенная транзитивность],
  [`name(X, 'Warrior')`], [`civ:name`], [DataProperty, xsd:string],
  [`unit_buildable/3`, `unit_unlocked_by_resource/4`, `best_unit_for_style/4`],
    [—],
    [правила с `forall` и отрицанием не выражаются в OWL без SWRL; остаются в Prolog],
)

= DSS на основе БЗ (ЛР2)

== Формат входной строки
Я играю за \<civ>[, сейчас эра \<era>][, ресурсы \<r1>[, \<r2>]][, стиль melee|ranged]


Пример:
Я играю за rome, сейчас эра classical, ресурсы iron, стиль melee
#image("скрин работы программы.png", width: 100%)

== Конвейер обработки
 ```
строка
  │
  ├─► parse_input()
  │     ↓ profile = {civ, era, resources, playstyle}
  │
  ├─► recommend(prolog, profile)
  │     ├─ unique_unit_of(civ, U)
  │     ├─ military_units_in_era(era, U)
  │     ├─ best_unit_for_style(U, style, era, resources)
  │     ├─ unlocks_unit(T, BestUnit)
  │     ├─ available_in_era(U, NextEra)
  │     └─ unit_unlocked_by_resource(U, era, resources, missing)
  │
  └─► вывод: список рекомендаций с обоснованием
```

== Диалог

Диалог с пользователем сводится к одной строке фиксированного формата.
При неполных данных (например, не указана эра) DSS выдаёт общие
рекомендации по всем военным юнитам с учётом ресурсов.

== Сценарии

#table(
  columns: 2,
  [*Вход*], [*Выход*],
  [`Я играю за rome`],
    [Уникальный юнит: legion. Все доступные юниты при отсутствии ресурсов],
  [`Я играю за rome, сейчас эра classical, ресурсы iron`],
    [Swordsman - лучший melee, чтобы строить, нужна iron_working],
  [`Я играю за japan, сейчас эра medieval, ресурсы iron, стиль ranged`],
    [Crossbowman - лучший ranged, технология military_tactics],
  [`Я играю за france`], [Ошибка: неизвестная цивилизация],
  [`asdkjhasd`], [Ошибка: строка не по шаблону],
)

// ============================================================
// 7. Тестирование
// ============================================================

= Тестирование и отладка

== Тест-кейсы Prolog

#table(
  columns: 2,
  [*Запрос*], [*Ожидание*],
  [`military_units_in_era(classical, U)`], [6 юнитов],
  [`unique_unit_of(japan, U)`], [`samurai`], 
  [`best_unit_for_style(U, melee, classical, [iron])`], [`swordsman`], 
  [`unit_unlocked_by_resource(U, classical, [iron], horses)`],
    [`horseman`], 
)

== Тест-кейсы DSS

- Happy path: полная строка → 4–6 рекомендаций.
- Негативные: неизвестная цивилизация, неизвестная эра, неизвестный ресурс,
  строка без «Я играю за».

// ============================================================
// 8. Оценка
// ============================================================

= Оценка и интерпретация

== Prolog vs OWL

#table(
  columns: 2,
  [*Prolog*], [*OWL/Protégé*],
  [Правила выводятся естественно (`:-`, `\+`, `forall`)],
    [Правила требуют SWRL или ограничений, менее гибко],
  [Быстро расширяется одним фактом], [Расширение = правки в GUI, дольше],
  [Хорош для DSS], [Хорош для документации и валидации модели],
)

== Идеи развития

- добавить больше юнитов, зданий, технологий
- учитывать стоимость и силу юнитов 
- интерактивный диалог с несколькими строками, а не одна команда
- подключить SPARQL-эндпоинт к OWL-версии.

// ============================================================
// 9. Заключение
// ============================================================

= Заключение

В ходе модуля построена база знаний Prolog, переведена в онтологию OWL,
и на её основе реализована DSS-программа, которая по строке фиксированного
формата выдаёт рекомендации. Механизм полностью основан на логическом
выводе: добавление нового юнита требует только правки `.pl`-файла.
Ограничения: нет стоимости и силы юнитов, диалог одношаговый, OWL-версия
не подключена к DSS.