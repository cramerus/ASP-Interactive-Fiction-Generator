#program initial.

place(X) :- setting(X).
is(C, place(X)) :- player(C), setting(X).
is(X, Y) :- init(is(X, Y)).

#program always.

place(X) :- setting(X).

adj(hurt).
adj(tired).
adj(angry).

% unidirectional semantic linking
link(verb(fight, trans(C)), is(C, adj(hurt))) :- verb(fight, trans(C)). 
link(is(C, adj(hurt)), verb(help, trans(C))) :- verb(help, trans(C)).

#program dynamic.

% continuation: resets at end of act, unless cured
is(C, X) :- 'is(C, X), not cure(C, X), act(Q).

% what triggers a state
is(C, adj(hurt)) :- occurs(CC, verb(fight, trans(C)), Q).

% cure: this action 'cures' a character of a state
cure(C, adj(hurt)) :- occurs(_, verb(help, trans(C)), Q).
cure(character(C), adj(hurt)) :- story(Q), character(C).

% VERBS that adj affect
occurs(C, verb(defeat, trans(CC)), Q) :- occurs(C, verb(fight, trans(CC)), Q), 'is(CC, adj(hurt)), not player(CC).

% FAIL conditions due to effects
fails(C, verb(run, none), Q) :- 'is(C, adj(hurt)), act(Q), decision(verb(run, none)).
fails(C, verb(find, trans(X)), Q) :- occurs(C, verb(search, trans(X)), Q), is(X, place(Y)), is(C, place(Z)), Y != Z.

