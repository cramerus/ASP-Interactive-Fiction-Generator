init(character(child)).
init(character(mom)).
init(character(dad)).
init(character(



init(character(thief)).
init(character(guard)).
%init(character(sidekick)).

init(player(character(thief))).
init(villain(character(guard))).

init(setting(museum)).

% Goals must be OCCURS statements, and are assumed to be done by the player character.
init(goal(verb(defeat, trans(character(guard))), act(rising))).
init(goal(verb(find, trans(object(painting))), act(rising))).
init(goal(verb(take, trans(object(painting))), act(climax))).
init(goal(verb(escape, none), act(climax))).
init(goal(verb(take, trans(object(key))), act(falling))).
init(goal(verb(escape, none), act(falling))).

