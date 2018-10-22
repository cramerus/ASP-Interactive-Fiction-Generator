% telingo instances/04-ghost-story.lp encoding/encoding.lp encoding/objects.lp encoding/verbs.lp encoding/characters.lp encoding/adjs.lp 0 --imin=18

init(character(tenant)).
init(character(ghost)).

init(player(character(tenant))).
init(role(protagonist, tenant)).

init(setting(parlor)).
init(place(shrine)).

init(is(object(painting), place(shrine))).
init(is(object(regret), place(parlor))).

% unassigned chars -> place is at setting


init(goal(verb(find, trans(character(ghost))), act(rising))).
init(goal(verb(find, trans(object(regret))), act(rising))).
init(goal(verb(take, trans(object(regret))), act(climax))).
init(goal(verb(take, trans(object(painting))), act(climax))).
init(goal(verb(destroy, trans(object(regret))), act(climax))).
init(goal(verb(give, ditrans(object(painting), character(ghost))), act(falling))).
init(goal(verb(hug, trans(character(ghost))), act(falling))).