% telingo instances/01-heist.lp encoding/encoding.lp encoding/objects.lp encoding/verbs.lp encoding/characters.lp encoding/adjs.lp 0 --imin=20

init(character(thief)).
init(character(guard)).

init(player(character(thief))).

% every character should have a role
init(role(protagonist, character(thief))).
init(role(antagonist, character(guard))).

init(has(character(guard), object(key))).

init(setting(museum)).

% Goals must be OCCURS statements, and are assumed to be done by the player character.
init(goal(verb(defeat, trans(character(guard))), act(rising))).
init(goal(verb(find, trans(object(painting))), act(rising))).
init(goal(verb(take, trans(object(painting))), act(climax))).
init(goal(verb(escape, none), act(climax))).
init(goal(verb(steal, ditrans(object(key), character(guard))), act(falling))).
init(goal(verb(escape, none), act(falling))).

