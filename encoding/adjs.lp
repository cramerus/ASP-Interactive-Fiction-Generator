#program initial.

setting(X) :- init(setting(X)).
place(X) :- setting(X).
place(X) :- init(place(X)).
place(X) :- init(goal(verb(go, trans(place(X))), _)).
place(X) :- init(goal(is(_, place(X)))).

is(X, Y) :- init(is(X, Y)).
is(C, place(X)) :- player(C), setting(X).
is(character(C), place(X)) :- character(C), setting(X), not init(is(character(C), place(_))), not player(character(C)).

#program always.

adj(hurt).
adj(tired).
adj(angry).
adj(happy).
adj(sick).
adj(hurt).
adj(dead).
adj(trapped).

place(X) :- _place(X).

% unidirectional semantic linking
link(verb(fight, trans(C)), is(C, adj(hurt))) :- verb(fight, trans(C)). 
link(is(C, adj(hurt)), verb(help, trans(C))) :- verb(help, trans(C)).

link(verb(go, trans(place(X))), is(character(C), place(X))) :- character(C), verb(go, trans(place(X))).
link(is(character(C), place(X)), verb(go, trans(Y))) :- place(X), verb(go, trans(Y)), character(C).

#program dynamic.

% PLACES
is(C, place(X)) :- not occurs(C, verb(go, _), _), 'is(C, place(X)).
is(C, place(X)) :- occurs(C, verb(go, trans(place(X))), act(Q)).
setting(X) :- is(C, place(X)), player(C).

% continuation: unless cured
is(C, adj(X)) :- 'is(C, adj(X)), not cure(C, adj(X)).

% what triggers a state
is(C, adj(hurt)) :- occurs(_, verb(fight, trans(C)), _).
is(C, adj(sick)) :- occurs(_, verb(infect, trans(C)), _).
is(C, adj(happy)) :- occurs(_, verb(V, trans(C)), _), helpful(verb(V, trans(C))).
is(C, adj(dead)) :- occurs(_, verb(kill, trans(C)), _), not is(C, adj(happy)).

% cure: this action 'cures' a character of a state
cure(C, adj(hurt)) :- occurs(_, verb(help, trans(C)), Q).
cure(character(C), adj(hurt)) :- story(Q), character(C).
cure(C, adj(trapped)) :- has(C, object(key)), occurs(C, verb(escape, none), _).

% VERBS that adj affect
occurs(C, verb(defeat, trans(CC)), Q) :- occurs(C, verb(fight, trans(CC)), Q), 'is(CC, adj(hurt)), not player(CC).

% CONSTRAINS on motion
:- occurs(C, verb(go, trans(X)), Q), 'is(C, X).
:- occurs(C, verb(go, _), _), is(C, adj(trapped)).
:- occurs(C, verb(X, trans(character(CC))), _), is(C, place(P)), is(character(CC), place(PP)), P != PP, X != search.
:- occurs(C, verb(X, ditrans(CC, _)), _), is(C, place(P)), is(character(CC), place(PP)), P != PP, X != search.
:- occurs(C, verb(X, ditrans(_, CC)), _), is(C, place(P)), is(character(CC), place(PP)), P != PP, X != search.

% FAIL conditions due to effects
fails(C, verb(run, none), Q) :- 'is(C, adj(hurt)), act(Q), decision(verb(run, none)).
fails(C, verb(find, trans(X)), Q) :- occurs(C, verb(search, trans(X)), Q), is(X, place(Y)), is(C, place(Z)), Y != Z.

