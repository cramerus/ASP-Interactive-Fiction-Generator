#program initial.

object(X) :- init(goal(verb(_, object(X)), _)).

#program always.

object(X) :- _object(X).

#program dynamic.
