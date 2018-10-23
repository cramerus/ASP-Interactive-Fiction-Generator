#program initial.

setting(X) :- init(setting(X)).
place(X) :- setting(X).
place(X) :- init(place(X)).
place(X) :- init(goal(verb(go, trans(place(X))), _)).
place(X) :- init(goal(is(_, place(X)))).
place(X) :- init(is(_, place(X))).

is(X, Y) :- init(is(X, Y)).
is(C, place(X)) :- player(C), setting(X).
is(object(O), place(X)) :- object(O), setting(X), not has(_, object(O)), not init(is(object(O), place(_))).
is(character(C), place(X)) :- character(C), setting(X), not init(is(character(C), place(_))), not player(character(C)).

#program always.

% temporary
adj(hurt).
adj(tired).
adj(angry).
adj(happy).
adj(sick).
adj(hurt).
adj(dead).
adj(trapped).
adj(cursed).
adj(visible).
adj(safe).

% characteristics (mostly for npc)
adj(violent).
adj(follower).
adj(enamored).
adj(smart).

% place restrictions for acts
adj(restricted(act(falling))).
adj(restricted(act(climax))).
adj(restricted(act(rising))).

place(X) :- _place(X).

#program dynamic.

% unidirectional semantic linking
link(verb(fight, trans(C)), is(C, adj(hurt))) :- verb(fight, trans(C)).
link(is(C, adj(hurt)), verb(help, trans(C))) :- verb(help, trans(C)).

link(verb(fight, trans(C)), is(C, adj(cursed))) :- verb(fight, trans(C)).
%link(verb(V, trans(C)), is(CC, adj(cursed))) :- verb(V, trans(C)), is(C, adj(cursed)), is(CC, adj(cursed)).

link(verb(go, trans(place(X))), is(character(C), place(X))) :- character(C), verb(go, trans(place(X))).
link(is(character(C), adj(happy)), is(character(C), adj(enamored))) :- character(C).
link(verb(understand, none), verb(go, trans(place(Y)))) :- verb(understand, none), place(Y).

% I don't remember what the use of these rules is
link(is(character(C), place(X)), verb(go, trans(Y))) :- place(X), verb(go, trans(Y)), character(C).
link(is(character(C), place(X)), verb(find, trans(A))) :- character(C), verb(find, trans(A)), place(X).

% PLACES
is(character(C), place(X)) :- not occurs(character(C), verb(go, _), _), 'is(character(C), place(X)).
is(character(C), place(X)) :- occurs(character(C), verb(go, trans(place(X))), act(Q)).
is(object(O), place(X)) :- not occurs(_, verb(take, trans(object(O))), _), 'is(object(O), place(X)).
is(object(O), place(X)) :- occurs(character(C), verb(put, trans(object(O))), act(Q)), is(character(C), place(X)).
setting(X) :- is(C, place(X)), player(C).
:- occurs(C, verb(go, trans(P)), Q), is(P, adj(restricted(Q))).

% object gone
is(object(O), place(X)) :- 'is(object(O), place(X)), not 'occurs(_, verb(destroy, trans(object(O))), _).

% continuation: unless cured
is(C, adj(X)) :- 'is(C, adj(X)), not cure(C, adj(X)).

% what triggers a state
is(C, adj(hurt)) :- occurs(_, verb(fight, trans(C)), _).
is(CC, adj(cursed)) :- occurs(CC, verb(fight, trans(C)), _), is(C, adj(cursed)).
is(CC, adj(cursed)) :- occurs(CC, verb(_, trans(C)), _), is(C, adj(cursed)).
is(C, adj(sick)) :- occurs(_, verb(infect, trans(C)), _).
is(C, adj(happy)) :- occurs(_, verb(V, trans(C)), _), helpful(verb(V, trans(C))).
is(C, adj(happy)) :- occurs(_, verb(give, ditrans(X, C)), _), is(X, adj(giftable)).
is(C, adj(dead)) :- occurs(_, verb(kill, trans(C)), _), not is(C, adj(happy)).
is(C, adj(safe)) :- occurs(_, verb(save, trans(C)), _).
is(C, adj(enamored)) :- is(C, adj(happy)), occurs(_, verb(give, ditrans(X, C)), _), is(X, adj(giftable)).

% cure: this action 'cures' a character/object of a state or place
cure(C, adj(hurt)) :- occurs(_, verb(help, trans(C)), Q).
cure(character(C), adj(hurt)) :- story(Q), character(C).
cure(C, adj(trapped)) :- has(C, object(key)), occurs(C, verb(escape, none), _).
cure(X, adj(visible)) :- 'occurs(C, verb(find, trans(X)), _), player(C).
cure(C, adj(trapped)) :- occurs(_, verb(save, trans(C)), Q).
cure(P, adj(hidden)) :- occurs(C, verb(understand, none), _), player(C), 'is(P, adj(hidden)).
cure(X, adj(sale)) :- 'occurs(C, verb(buy, trans(X)), _).

% VERBS that adj affect
occurs(C, verb(defeat, trans(CC)), Q) :- occurs(C, verb(fight, trans(CC)), Q), 'is(CC, adj(hurt)), not player(CC).
occurs(C, verb(find, trans(X)), act(Q)) :- act(Q), is(X, adj(visible)), is(X, place(Y)), is(C, place(Y)), player(C).
occurs(C, verb(understand, none), act(Q)) :- occurs(C, verb(talk, trans(CC)), act(Q)), is(CC, adj(smart)).
:- occurs(C, verb(buy, trans(X)), act(Q)), not is(X, adj(sale)).
:- occurs(C, verb(buy, trans(X)), _), is(C, place(A)), is(X, place(B)), A != B.
:- occurs(C, verb(search, trans(X)), _), is(X, adj(hidden)).
:- occurs(C, verb(take, trans(X)), _), is(X, adj(sale)).
:- occurs(P, verb(kiss, trans(C)), _), not is(C, adj(enamored)).

% CONSTRAINTS on motion
:- occurs(C, verb(go, trans(X)), Q), 'is(C, X).
:- occurs(C, verb(go, _), _), is(C, adj(trapped)).
:- occurs(C, verb(go, trans(P)), _), player(C), is(P, adj(hidden)).
:- occurs(C, verb(X, trans(character(CC))), _), is(C, place(P)), is(character(CC), place(PP)), P != PP, X != search.
:- occurs(C, verb(X, ditrans(character(CC), _)), _), is(C, place(P)), is(character(CC), place(PP)), P != PP, X != search.
:- occurs(C, verb(X, ditrans(_, character(CC))), _), is(C, place(P)), is(character(CC), place(PP)), P != PP, X != search.
