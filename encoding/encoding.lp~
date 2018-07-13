% telingo instances/01-heist.lp encoding/encoding.lp encoding/objects.lp encoding/verbs.lp encoding/characters.lp encoding/adjs.lp 0 --imin=20
% imin = the maximum length of the story; will produce all models of length equal or less this number

#program initial.

act(start).
story(start).
%q(0).

% import from instance
setting(X) :- init(setting(X)).
goal(X, Y) :- init(goal(X, Y)).
character(X) :- init(character(X)).
villain(X) :- init(villain(X)).
player(X) :- init(player(X)).

#program always.

character(X) :- _character(X).
player(X) :- _player(X).
villain(X) :- _villain(X).

#program dynamic.

% keep track of state number: currently unnecessary
%q(X+1) :- 'q(X).

% options are limited to verbs that are semantically linked to goals of that act
option(verb(A, B)) :- choice(verb(A, B)), _goal(verb(C, D), act(Q)), act(Q), link(verb(A, B), verb(C, D)), not &final, not story(_).

1 { decision(verb(Y, Z)) : option(verb(Y, Z)) } 1 :- not &final, not story(_).
occurs(X, Y, act(Z)) :- player(X), decision(Y), act(Z), not fails(X, Y, act(Z)).

% occurs limitations - not same thing more than twice in a row
:- occurs(X, Y, Z), 'occurs(X, Y, Z), ''occurs(X, Y, Z).
:- decision(Y), 'fails(X, Y, Z), player(X).

% at change of act, import goals
story(X) :- act(X), 'act(XX), X != XX.
goal(V, act(Q)) :- story(Q), _goal(V, act(Q)).
goal(verb(A, B), act(Q)) :- 'goal(verb(A, B), act(Q)), not occurs(character(X), verb(A, B), act(Q)), player(character(X)).
goal(has(C, X), act(Q)) :- act(Q), not has(C, X), 'goal(has(C, X), act(Q)).
goal(is(C, X), act(Q)) :- act(Q), 'goal(is(C, X), act(Q)), not is(C, X).

% describe change of story acts
complete(act(X)) :- act(X), not goal(_, act(X)).
act(rising) :- 'act(start).
act(climax) :- 'complete(act(rising)).
act(falling) :- 'complete(act(climax)).
act(end) :- 'complete(act(falling)).
act(X) :- 'act(X), not 'complete(act(X)), X != start, X != end.

:- act(end), not &final.

#program final.

:- not act(end).
story(end).

#show setting/1.
#show is/2.
#show has/2.
#show decision/1.
#show occurs/3.
#show story/1.
#show fails/3.

% for testing/debugging
%#show violated/1.
%#show goal/2.
%#show choice/1.
%#show option/1.
%#show link/2.
%#show check/1.
