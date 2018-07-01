#program initial.

#program always.

adj(hurt).

#program dynamic.

% same state involuntary reaction
% X fights Y: Y is hurt, unless they run away from the fight
is(C, adj(hurt), Q) :- occurs(CC, verb(fight, trans(C)), Q).
