% telingo instances/01-heist.lp encoding/encoding.lp encoding/objects.lp encoding/verbs.lp encoding/characters.lp encoding/adjs.lp 0 --imin=18
% imin = the maximum length of the story; will produce all models of length equal or less this number

#program initial.

act(start).
story(start).
q(0).

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
q(X+1) :- 'q(X).

% options are limited to verbs that are semantically linked to goals of that act
option(verb(A, B)) :- choice(verb(A, B)), _goal(verb(C, D), act(Q)), act(Q), link(verb(A, B), verb(C, D)), not &final, not story(_).

1 { decision(character(X), verb(Y, Z)) : option(verb(Y, Z)) } 1 :- player(character(X)), not &final, not story(_).
occurs(X, Y, act(Z)) :- decision(X, Y), act(Z).

% occurs limitations - not same thing more than twice in a row
:- occurs(X, Y, Z), 'occurs(X, Y, Z), ''occurs(X, Y, Z).

% for show purposes in python output
decision(V, O) :- decision(_, verb(V, O)).
occurs(X, verb(Y)) :- occurs(character(X), verb(Y, none), _).
occurs(X, verb(Y, A)) :- occurs(character(X), verb(Y, trans(A)), _).
occurs(X, verb(Y, A, B)) :- occurs(character(X), verb(Y, ditrans(A, B)), _).
%fails(X, verb(Y)) :- fails(character(X), verb(Y, none), _).
%fails(X, verb(Y, A)) :- fails(character(X), verb(Y, trans(A)), _).
%fails(X, verb(Y, A, B)) :- fails(character(X), verb(Y, ditrans(A, B)), _).
is(X, Y) :- is(X, Y, _).

% at change of act, import goals
story(X) :- act(X), 'act(XX), X != XX.
goal(V, act(Q)) :- story(Q), _goal(V, act(Q)).
goal(V, act(Q)) :- 'goal(V, act(Q)), not occurs(character(X), V, act(Q)), player(character(X)).

% define success
success(act(X)) :- act(X), not goal(_, act(X)).

% describe change of story acts
act(rising) :- 'act(start).
act(climax) :- 'success(act(rising)).
act(falling) :- 'success(act(climax)).
act(end) :- 'success(act(falling)).
act(X) :- 'act(X), not 'success(act(X)), X != start, X != end.

%act(end) :- fail.
:- act(end), not &final.

#program final.

:- not act(end).
story(end).

#show setting/1.
#show is/2.
#show has/2.
#show decision/2.
#show occurs/2.
#show story/1.
%#show fails/2.

% for testing/debugging
%#show goal/2.
%#show choice/1.
%#show option/1.
%#show link/2.
%#show check/1.
