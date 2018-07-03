% telingo instances/02-lost-child.lp encoding/encoding.lp encoding/objects.lp encoding/verbs.lp encoding/characters.lp encoding/adjs.lp 0 --imin=18

init(character(child)).
init(character(father)).
init(character(stepmother)).

init(player(character(child))).

init(setting(home)).

init(is(character(father), place(city))).
init(has(character(stepmother), object(key))).

init(goal(has(character(child), object(key)), act(rising))).
init(goal(verb(escape, none), act(rising))).
%init(goal(verb(go, trans(place(city))), act(climax))).
%init(goal(verb(find, trans(character(father))), act(climax))).
%init(goal(verb(go, trans(place(home))), act(falling))).
%init(goal(verb(hug, trans(character(stepmother))), act(falling))).
