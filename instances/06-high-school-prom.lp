% telingo instances/06-high-school-prom.lp encoding/encoding.lp encoding/objects.lp encoding/verbs.lp encoding/characters.lp encoding/adjs.lp 0 --imin=20

init(character(student)).
init(character(friend)).
init(character(crush)).

init(player(character(student))).

init(role(protagonist, character(student))).
init(role(support, character(friend))).
init(role(support, character(crush))).

init(is(object(flowers), place(shop))).
init(is(object(flowers), adj(sale))).
init(has(character(friend), object(money))).
init(has(character(crush), object(chocolate))).

init(is(character(friend), adj(visible))).
init(is(character(crush), adj(visible))).
init(is(place(prom), adj(restricted(act(climax))))).
init(is(place(prom), adj(restricted(act(rising))))).

init(setting(school)).

init(goal(verb(buy, trans(object(flowers))), act(rising))).
init(goal(verb(give, ditrans(object(flowers), character(friend))), act(climax))) | init(goal(verb(give, ditrans(object(flowers), character(crush))), act(climax))).
init(goal(verb(kiss, trans(character(friend))), act(climax))) | init(goal(verb(kiss, trans(character(crush))), act(climax))).
init(goal(verb(go, trans(place(prom))), act(falling))).
