% telingo instances/04-ghost-story.lp encoding/encoding.lp encoding/objects.lp encoding/verbs.lp encoding/characters.lp encoding/adjs.lp 0 --imin=18

init(character(child)).
init(character(ghost)).

init(player(character(child))).

%init(specialist(magic, ghost)).
init(role(protagonist, child)).

init(setting(home)).
% unassigned chars -> place is at setting
init(is(character(ghost), adj(cursed))).
init(is(character(ghost), adj(trapped))).


init(goal(verb(find, trans(character(ghost))), act(rising))).
init(goal(is(character(child), adj(cursed)), act(rising))).
init(goal(verb(destroy, trans(object(source))), act(climax))).
%init(goal(verb(take, trans(object(source))), act(climax))).
init(goal(verb(defeat, trans(character(ghost))), act(falling))).