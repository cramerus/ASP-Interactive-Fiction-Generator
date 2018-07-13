% telingo instances/02-lost-child.lp encoding/encoding.lp encoding/objects.lp encoding/verbs.lp encoding/characters.lp encoding/adjs.lp 0 --imin=18

init(character(child)).
init(character(father)).
init(character(stepmother)).

init(player(character(child))).

init(setting(home)).
% unassigned chars -> place is at setting

init(place(school)).
init(is(character(father), place(office))).
init(has(character(stepmother), object(key))).
init(is(character(child), adj(trapped))).

init(goal(has(character(child), object(key)), act(rising))).
init(goal(verb(escape, none), act(rising))).
init(goal(verb(go, trans(place(office))), act(climax))).
init(goal(verb(find, trans(character(father))), act(climax))).
init(goal(verb(hug, trans(character(stepmother))), act(falling))).
init(goal(verb(hug, trans(character(father))), act(falling))).
