#program initial.

object(X) :- init(goal(verb(_, trans(object(X))), _)).

#program always.

object(X) :- _object(X).

#program dynamic.

% same state reactions
has(C, X) :- occurs(C, verb(take, trans(X)), act(_)).
has(C, X) :- 'has(C, X), not story(end).
%has(C, X) :- occurs(C, verb(give,
