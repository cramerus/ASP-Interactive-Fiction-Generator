% telingo instances/05-murder-mystery.lp encoding/encoding.lp encoding/objects.lp encoding/verbs.lp encoding/characters.lp encoding/adjs.lp 0 --imin=19

init(character(detective)).
init(character(assistant)).
init(character(murderer)).

init(player(character(detective))).

init(role(protagonist, character(detective))).
init(role(antagonist, character(murderer))).
init(role(support, character(assistant))).

init(is(object(clues), place(city))).
init(is(object(body), place(work))).
init(is(object(body), adj(visible))).
init(is(character(assistant), place(work))).
init(is(character(murderer), place(hideout))).
init(is(place(hideout), adj(hidden))).

init(is(character(murderer), adj(violent))).
init(is(character(assistant), adj(follower))).

init(setting(home)).

init(goal(verb(go, trans(place(work))), act(rising))).
init(goal(verb(talk, trans(character(assistant))), act(rising))).
init(goal(verb(find, trans(object(clues))), act(climax))).
init(goal(verb(go, trans(place(hideout))), act(climax))).
init(goal(verb(save, trans(character(assistant))), act(falling))).
init(goal(verb(defeat, trans(character(murderer))), act(falling))).
