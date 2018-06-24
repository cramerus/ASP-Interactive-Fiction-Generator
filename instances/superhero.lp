init(character(hero)).
init(character(scientist)).
init(character(reporter)).

role(villain).
role(sidekick).

init(player(character(hero))).
init(villain(character(scientist))).
%init(sidekick(character(scientist))).

%init(villain(character(reporter))).
init(sidekick(character(reporter))).

init(setting(city)).

init(goal(occurs(character(hero), verb(gain, power), act(rising)))).
init(goal(occurs(character(hero), verb(figure_out, power), act(rising)))).
init(goal(occurs(character(hero), verb(save, role(sidekick)), act(climax)))).
init(goal(occurs(character(hero), verb(take, object(evil_macguffin)), act(climax)))).
init(goal(occurs(character(hero), verb(defeat, role(villain)), act(falling)))).
init(goal(occurs(character(hero), verb(escape, none), act(falling)))).


Encoding
% telingo heist.lp encoding.lp objects.lp verbs.lp 0

#program initial.

act(start).
story(start).
q(0).

% import from instance
setting(X) :- init(setting(X)).
goal(X) :- init(goal(X)).
character(X) :- init(character(X)).
player(X) :- init(player(X)).
villain(X) :- init(villain(X)).
sidekick(X) :- init(sidekick(X)).

#program always.

character(X) :- _character(X).
player(X) :- _player(X).
villain(X) :- _villain(X).
sidekick(X) :- _sidekick(X).

#program dynamic.

q(X+1) :- 'q(X).

1 { choice(character(X), verb(Y, Z)) : choice(verb(Y, Z)) } 1 :- player(character(X)), not &final, not story(_).
occurs(X, Y, act(Z)) :- choice(X, Y), act(Z).

%player(character(X)),

% occurs limitations - not same thing more than twice in a row
:- occurs(X, Y, Z), 'occurs(X, Y, Z), ''occurs(X, Y, Z).

% just to make it look nicer and not repeat the act 10000 times
occurs(X, Y) :- occurs(X, Y, _), not choice(X, Y).
state(X, Y) :- state(X, Y, _).

% at change of act, import goals
story(X) :- act(X), 'act(XX), X != XX.
goal(occurs(X, Y, act(Q))) :- story(Q), _goal(occurs(X, Y, act(Q))).
goal(occurs(X, Y, act(Q))) :- 'goal(occurs(X, Y, act(Q))), not occurs(X, Y, act(Q)).

% define success, and limit length of story
% currently: 5 rising, 5 climax, 5 falling
success(act(X)) :- act(X), not goal(occurs(_, _, act(X))).
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

#show setting/1.
#show state/2.
#show choice/2.
#show occurs/2.
#show story/1.

Objects
#program initial.

object(X) :- init(goal(occurs(_, verb(_, object(X))), _)).

#program always.

object(X) :- _object(X).

#program dynamic.
Verbs
#program initial.

#program always.

% eliminates reflexive verbs - which can be defined separately using object 'self'
:- occurs(character(X), verb(_, character(Y)), _), X = Y.

verb(help, character(X)) :- character(X).
verb(gain, power).
verb(talk, character(X)) :- character(X).


verb(search, character(X)) :- character(X).
verb(search, object(X)) :- object(X).
choice(verb(search, X)) :- verb(search, X).

verb(fight, character(X)) :- character(X).
choice(verb(fight, X)) :- verb(fight, X).

verb(take, object(X)) :- object(X).
choice(verb(take, X)) :- verb(take, X).

verb(run, none).
choice(verb(run, X)) :- verb(run, X).

verb(escape, none).
choice(verb(escape, X)) :- verb(escape, X).

verb(defeat, character(X)) :- character(X).

verb(find, object(X)) :- object(X).
verb(find, character(X)) :- character(X).

#program dynamic.

% same state involuntary reactions
% search for X: immediately find X
occurs(C, verb(find, X), Q) :- occurs(C, verb(search, X), Q).
% X fights Y: Y is hurt, unless they run away from the fight
state(C, adj(hurt), Q) :- occurs(CC, verb(fight, C), Q), not occurs(C, verb(run, none), Q).
% Y defeats X if they fight while X is already hurt
occurs(C, verb(defeat, CC), Q) :- occurs(C, verb(fight, CC), Q), not not &tel { < <? state(CC, adj(hurt), Q) }.

% next state involuntary reactions
% X finds Y villain: Y fights X
occurs(CC, verb(fight, C), Q) :- 'occurs(C, verb(find, CC), Q), villain(CC).

% conditions: X must happen at some point before Y
% can't take object unless have found that object, previous act works too
:- occurs(C, verb(take, X), _), act(Q), &tel { ~ < <? occurs(C, verb(find, X), act(Q)) }.
% conditions to escape: run, or have a key, or defeat the villain in the same act
:- occurs(C, verb(escape, none), Q), villain(V), character(A), &tel {
    ~ < <? occurs(C, verb(run, none), Q) & 
    ~ < <? occurs(C, verb(take, object(key)), Q) &
    ~ < <? occurs(character(A), verb(defeat, V), Q)
    }.
% must find someone before you fight them
%:- occurs(C, verb(fight, CC), Q), &tel { ~ < <? occurs(C, verb(find, CC), Q) }.

% inhibit: X happening prevents Y happening in the same act in the future
% don't fight a character if they're already defeated
:- occurs(C, verb(defeat, CC), Q), &tel { > >? occurs(C, verb(fight, CC), Q) }.
% don't find something if you've already found it (in any act)
:- occurs(C, verb(find, X), _), act(Q), &tel { > >? occurs(C, verb(find, X), act(Q)) }.
% don't take something if you've already taken it (in any act)
:- occurs(C, verb(take, X), _), act(Q), &tel { > >? occurs(C, verb(take, X), act(Q)) }.
% defeated character can't do anything after being defeated
:- occurs(_, verb(defeat, C), act(Q)), &tel { > >? occurs(C, verb(A, B), act(Q)) }, act(Q), verb(A, B).
% can't run if hurt
:- state(C, adj(hurt), Q), &tel { > >? occurs(C, verb(run, none), Q) }.



