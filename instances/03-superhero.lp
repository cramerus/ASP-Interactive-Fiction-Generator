% telingo instances/03-superhero.lp encoding/encoding.lp encoding/objects.lp encoding/verbs.lp encoding/characters.lp encoding/adjs.lp 0 --imin=23

init(character(hero)).
init(character(scientist)).
init(character(reporter)).

init(player(character(hero))).

init(role(protagonist, character(hero))).

init(has(character(scientist), object(power))).

init(is(object(bomb), place(lair))).
init(is(character(scientist), place(lab))).

init(setting(city)).

init(goal(verb(help, trans(character(scientist))), act(rising))) | init(goal(verb(help, trans(character(reporter))), act(rising))).
init(goal(verb(fight, trans(character(scientist))), act(rising))) | init(goal(verb(fight, trans(character(reporter))), act(rising))).
init(goal(has(character(hero), object(power)), act(rising))).
init(goal(verb(destroy, trans(object(bomb))), act(climax))).
init(goal(verb(defeat, trans(character(scientist))), act(falling))) | init(goal(verb(defeat, trans(character(reporter))), act(falling))).
