% telingo instances/07-ancient-city.lp encoding/encoding.lp encoding/objects.lp encoding/verbs.lp encoding/characters.lp encoding/adjs.lp 0 --imin=18

init(character(explorer)).
init(player(character(explorer))).

init(role(protagonist, character(explorer))).

init(character(deity)).
init(is(character(deity), place(temple))).
%init(is(character(deity), adj(trapped))).

init(setting(camp)).
init(place(temple)).
init(place(city)).

init(is(object(artifact), place(city))).

init(goal(verb(find, trans(character(deity))), act(rising))).
init(goal(verb(take, trans(object(artifact))), act(climax))).
init(goal(verb(give, ditrans(object(artifact),character(deity))), act(climax))).
init(goal(verb(defeat, trans(character(deity))), act(falling))).
init(goal(verb(go, trans(place(camp))), act(falling))).
