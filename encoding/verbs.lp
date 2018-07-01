#program initial.

#program always.

% define transitivity and ditransitivity
trans(object(X)) :- object(X).
trans(character(X)) :- character(X).
ditrans(X, Y) :- trans(X), trans(Y).

% eliminates reflexive verbs - which can be defined separately using object 'self'
:- occurs(character(X), verb(_, character(Y)), _), X = Y.

verb(search, trans(X)) :- trans(X).
choice(verb(search, X)) :- verb(search, X).

verb(fight, trans(character(X))) :- character(X).
choice(verb(fight, X)) :- verb(fight, X).

verb(take, trans(object(X))) :- object(X).
choice(verb(take, X)) :- verb(take, X).

verb(run, none).
choice(verb(run, none)).

verb(escape, none).
choice(verb(escape, none)).

verb(defeat, trans(character(X))) :- character(X).

verb(find, trans(X)) :- trans(X).

verb(help, trans(character(X))) :- character(X).
choice(verb(help, X)) :- verb(help, X).

verb(talk, trans(character(X))) :- character(X).
choice(verb(talk, X)) :- verb(talk, X).

verb(get, trans(object(X))) :- object(X).

verb(use, trans(object(X))) :- object(X).
choice(verb(use, X)) :- verb(use, X).

verb(save, trans(character(X))) :- character(X).
choice(verb(save, X)) :- verb(save, X).

verb(understand, trans(X)) :- trans(X).

verb(give, ditrans(object(X), character(Y))) :- object(X), character(Y).
choice(verb(give, ditrans(X, Y))) :- verb(give, ditrans(X, Y)).

verb(trick, trans(character(X))) :- character(X).

verb(lie, trans(character(X))) :- character(X).
choice(verb(lie, trans(X))) :- verb(lie, trans(X)).

% semantic linking
link(verb(X, Y), verb(X, Y)) :- verb(X, Y).
link(A, C) :- link(A, B), link(B, C).

link(verb(search, X), verb(find, X)) :- verb(search, X), verb(find, X).
link(verb(find, X), verb(fight, X)) :- verb(find, X), verb(fight, X). 
link(verb(find, X), verb(take, X)) :- verb(find, X), verb(take, X). 
link(verb(find, X), verb(talk, X)) :- verb(find, X), verb(talk, X). 
link(verb(find, X), verb(lie, X)) :- verb(find, X), verb(lie, X). 
link(verb(find, X), verb(help, X)) :- verb(find, X), verb(help, X).

link(verb(take, X), verb(use, X)) :- verb(take, X), verb(use, X). 
link(verb(run, none), verb(escape, none)).
link(verb(take, trans(object(key))), verb(escape, none)).
link(verb(fight, X), verb(defeat, X)) :- verb(fight, X), verb(defeat, X).
link(verb(defeat, trans(X)), verb(escape, none)) :- verb(defeat, trans(X)), villain(X).
link(verb(trick, trans(X)), verb(escape, none)) :- verb(trick, trans(X)), villain(X).
link(verb(lie, trans(X)), verb(trick, trans(X))) :- verb(lie, trans(X)), verb(trick, trans(X)).

#program dynamic.

% same state involuntary reaction
% search for X: immediately find X
occurs(C, verb(find, X), Q) :- occurs(C, verb(search, X), Q).
% Y defeats X if they fight while X is already hurt
occurs(C, verb(defeat, trans(CC)), Q) :- occurs(C, verb(fight, trans(CC)), Q), not not &tel { < <? is(CC, adj(hurt), Q) }.
% if X finds Y, Y also finds X
occurs(C, verb(find, trans(CC)), Q) :- occurs(CC, verb(find, trans(C)), Q).
% lie --> trick
occurs(C, verb(trick, trans(CC)), Q) :- occurs(C, verb(lie, trans(CC)), Q).

% next state involuntary reactions
% X finds Y villain: Y fights X - unless tricked, or they run!
occurs(CC, verb(fight, trans(C)), Q) :- 'occurs(C, verb(find, trans(CC)), Q), villain(CC),
    not occurs(C, verb(trick, trans(CC)), Q), 
    not occurs(C, verb(run, none), Q),
    not occurs(C, verb(escape, none), Q).

% conditions: X must happen at some point before Y
% can't take object unless have found that object, previous act works too
:- occurs(C, verb(take, X), _), act(Q), &tel { ~ < <? occurs(C, verb(find, X), act(Q)) }.
% can't use object unless has that object
:- occurs(C, verb(use, trans(X), _), act(Q)), not has(C, X).
% conditions to escape: run, or have a key, or defeat/trick the villain in the same act
:- occurs(C, verb(escape, none), Q), villain(V), not has(C, object(key)), &tel {
    ~ < <? occurs(C, verb(run, none), Q) & 
    ~ < <? occurs(C, verb(defeat, trans(V)), Q) &
    ~ < <? occurs(C, verb(trick, trans(V)), Q) }.
% must find someone before you fight them, etc
:- occurs(C, verb(fight, trans(CC)), Q), &tel { ~ < <? occurs(C, verb(find, trans(CC)), Q) }.
:- occurs(C, verb(talk, trans(CC)), Q), &tel { ~ < <? occurs(C, verb(find, trans(CC)), Q) }.
:- occurs(C, verb(lie, trans(CC)), Q), &tel { ~ < <? occurs(C, verb(find, trans(CC)), Q) }.
:- occurs(C, verb(help, trans(CC)), Q), &tel { ~ < <? occurs(C, verb(find, trans(CC)), Q) }.

% inhibit: X happening prevents Y happening in the same act in the future
% don't fight a character if they're already defeated
:- occurs(C, verb(defeat, trans(CC)), Q), &tel { > >? occurs(C, verb(fight, trans(CC)), Q) }.
% don't take something if you have it already.
:- occurs(C, verb(take, trans(X)), _), 'has(C, X).
% don't search for something if you already found it
:- occurs(C, verb(search, X), Q), &tel { > >? occurs(C, verb(find, X), Q) }.
% defeated character can't do anything after being defeated
:- occurs(_, verb(defeat, trans(C)), act(Q)), &tel { > >? occurs(C, verb(A, B), act(Q)) }, act(Q), verb(A, B).
% two characters can't defeat each other in the same turn
:- occurs(C, verb(defeat, trans(CC)), act(Q)), occurs(CC, verb(defeat, trans(C)), act(Q)).
% can't run if hurt
:- is(C, adj(hurt), Q), &tel { > >? occurs(C, verb(run, none), Q) }.
% escape can only be the last action in an act
:- occurs(_, verb(escape, none), act(Q)), not story'(_).

% fail conditions
%fail :- occurs(_, verb(defeat, trans(C)), _), player(C).
