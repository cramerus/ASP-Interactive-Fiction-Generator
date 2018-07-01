#program initial.

object(X) :- init(goal(verb(_, trans(object(X))), _)).

#program always.

object(X) :- _object(X).

#program dynamic.

% continuing to have an object
has(C, X) :- 'has(C, X), not story(end), 
    not 'occurs(C, verb(give, ditrans(X, character(CC))), act(Q)), character(CC), act(Q).

% same state reactions
has(C, X) :- occurs(C, verb(take, trans(X)), _).
has(CC, X) :- occurs(_, verb(give, ditrans(X, CC)), _).
