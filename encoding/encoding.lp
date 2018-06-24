% telingo instances/01-heist.lp encoding.lp objects.lp verbs.lp characters.lp adjs.lp 0

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

q(X+1) :- 'q(X).

% establish scores for each verb that is a choice
score(V, N) :- N = #sum{X,V,VV : goal(VV, act(Q)), _final_dist(V, VV, X)}, choice(V), act(Q).
%score(V, X) :- N = goal(VV, act(Q)), _dist(V, VV, X), choice(V), act(Q).

option(X) :- score(X, S), { score(verb(A, B), SS) : verb(A, B), SS < S } 4.
% another rule so that if there are more than 4 with the same score, offer all of them?

1 { choice(character(X), verb(Y, Z)) : choice(verb(Y, Z)) } 1 :- player(character(X)), not &final, not story(_).
occurs(X, Y, act(Z)) :- choice(X, Y), act(Z).

% occurs limitations - not same thing more than twice in a row
:- occurs(X, Y, Z), 'occurs(X, Y, Z), ''occurs(X, Y, Z).

% just to make it look nicer and not repeat the act 10000 times
occurs(X, Y) :- occurs(X, Y, _), not choice(X, Y).
state(X, Y) :- state(X, Y, _).

% at change of act, import goals
story(X) :- act(X), 'act(XX), X != XX.
goal(V, act(Q)) :- story(Q), _goal(V, act(Q)).
goal(V, act(Q)) :- 'goal(V, act(Q)), not occurs(character(X), V, act(Q)), player(character(X)).

% define success, and limit length of story
% currently: 5 rising, 5 climax, 5 falling
success(act(X)) :- act(X), not goal(_, act(X)).
:- success(act(rising)), q(X), X != 6.
%:- success(act(climax)), q(X), X != 12.
%:- success(act(falling)), q(X), X != 18.

% describe change of story acts
act(rising) :- 'act(start).
act(climax) :- 'success(act(rising)).
act(falling) :- 'success(act(climax)).
act(end) :- 'success(act(falling)).
act(X) :- 'act(X), not 'success(act(X)), X != start, X != end.

:- act(end), not &final.

#program final.

:- not act(end).
story(end).

%#show setting/1.
%#show state/2.
%#show choice/2.
%#show occurs/2.
%#show story/1.

#show score/2.
#show option/1.
