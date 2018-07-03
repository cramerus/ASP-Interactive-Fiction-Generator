#program initial.

#program always.

% define transitivity and ditransitivity
trans(object(X)) :- object(X).
trans(character(X)) :- character(X).
ditrans(X, Y) :- trans(X), trans(Y).

% eliminates reflexive verbs - which can be defined separately using object 'self'
:- occurs(character(X), verb(_, trans(character(Y))), _), X = Y.
:- occurs(character(X), verb(_, ditrans(character(Y), _)), _), X = Y.
:- occurs(character(X), verb(_, ditrans(_, character(Y))), _), X = Y.

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
verb(help, trans(character(X))) :- character(X), not villain(character(X)).
    choice(verb(help, X)) :- verb(help, X).
verb(give, ditrans(object(X), character(Y))) :- object(X), character(Y).
    choice(verb(give, ditrans(X, Y))) :- verb(give, ditrans(X, Y)).
verb(trick, trans(character(X))) :- character(X).
verb(lie, trans(character(X))) :- character(X).
    choice(verb(lie, trans(X))) :- verb(lie, trans(X)).
verb(request, ditrans(object(X), character(Y))) :- object(X), character(Y), not villain(character(Y)).
    choice(verb(request, ditrans(X, Y))) :- verb(request, ditrans(X, Y)).

verb(steal, ditrans(object(X), character(Y))) :- object(X), character(Y).
    choice(verb(steal, ditrans(X, Y))) :- verb(steal, ditrans(X, Y)).

verb(go, trans(place(X))) :- place(X).
    choice(verb(go, trans(X))) :- verb(go, trans(X)).
verb(talk, trans(character(X))) :- character(X).
    choice(verb(talk, X)) :- verb(talk, X).
verb(get, trans(object(X))) :- object(X).
verb(use, trans(object(X))) :- object(X).
    choice(verb(use, X)) :- verb(use, X).
verb(save, trans(character(X))) :- character(X).
    choice(verb(save, X)) :- verb(save, X).
verb(understand, trans(X)) :- trans(X).

% semantic linking: matches rules in dynamic
link(verb(X, Y), verb(X, Y)) :- verb(X, Y).
link(A, C) :- link(A, B), link(B, C).

link(verb(search, X), verb(find, X)) :- verb(search, X), verb(find, X).
link(verb(find, X), verb(fight, X)) :- verb(find, X), verb(fight, X). 
link(verb(find, X), verb(take, X)) :- verb(find, X), verb(take, X). 
link(verb(find, X), verb(talk, X)) :- verb(find, X), verb(talk, X). 
link(verb(find, X), verb(lie, X)) :- verb(find, X), verb(lie, X). 
link(verb(find, X), verb(help, X)) :- verb(find, X), verb(help, X).
link(verb(find, C), verb(request, ditrans(X, C))) :- verb(find, C), verb(request, ditrans(X, C)).
%link(verb(find, C), verb(steal, ditrans(X, C))) :- verb(find, C), verb(request, ditrans(X, C)).

link(verb(take, X), verb(use, X)) :- verb(take, X), verb(use, X). 
link(verb(run, none), verb(escape, none)).
link(verb(defeat, trans(X)), verb(escape, none)) :- verb(defeat, trans(X)), villain(X).
link(verb(trick, trans(X)), verb(escape, none)) :- verb(trick, trans(X)), villain(X).
link(verb(lie, trans(X)), verb(trick, trans(X))) :- verb(lie, trans(X)), verb(trick, trans(X)).
link(verb(fight, X), verb(defeat, X)) :- verb(fight, X), verb(defeat, X).
link(verb(trick, X), verb(defeat, X)) :- verb(trick, X), verb(defeat, X).
link(verb(request, ditrans(X, C)), verb(give, ditrans(X, CC))) :- verb(request, ditrans(X, C)), verb(give, ditrans(X, CC)).
link(verb(help, trans(C)), verb(give, ditrans(X, C))) :- verb(help, trans(C)), verb(give, ditrans(X, C)).

#program dynamic.

% same state involuntary reaction
occurs(character(C), verb(find, trans(character(CC))), Q) :- occurs(character(CC), verb(find, trans(character(C))), Q), character(C), character(CC).
occurs(C, verb(trick, trans(CC)), Q) :- occurs(C, verb(lie, trans(CC)), Q).
occurs(C, verb(defeat, trans(CC)), Q) :- occurs(C, verb(fight, trans(CC)), Q), 'occurs(C, verb(trick, trans(CC)), Q).

% next state involuntary reactions
occurs(CC, verb(fight, trans(C)), Q) :- 'occurs(CC, verb(find, trans(C)), Q), villain(CC),
    not occurs(C, verb(trick, trans(CC)), Q), 
    not occurs(C, verb(run, none), Q),
    not occurs(C, verb(escape, none), Q).

% conditions: X must happen at some point before Y
:- occurs(C, verb(take, X), _), act(Q), not not &tel { ~ < <? occurs(C, verb(find, X), act(Q)) }.
:- occurs(C, verb(fight, trans(CC)), Q), &tel { ~ < <? occurs(C, verb(find, trans(CC)), Q) }.
:- occurs(C, verb(talk, trans(CC)), Q), not not &tel { ~ < <? occurs(C, verb(find, trans(CC)), Q) }.
:- occurs(C, verb(lie, trans(CC)), Q), not not &tel { ~ < <? occurs(C, verb(find, trans(CC)), Q) }.
:- occurs(C, verb(help, trans(CC)), Q), not not &tel { ~ < <? occurs(C, verb(find, trans(CC)), Q) }.
:- occurs(C, verb(request, ditrans(object(X), CC)), Q), object(X), not not &tel { ~ < <? occurs(C, verb(find, trans(CC)), Q) }.
:- occurs(C, verb(give, ditrans(object(X), CC)), Q), object(X), not not &tel { ~ < <? occurs(C, verb(find, trans(CC)), Q) }.

% inhibit: X happening prevents Y happening in the same act in the future
:- occurs(C, verb(defeat, trans(CC)), Q), not not &tel { > >? occurs(C, verb(fight, trans(CC)), Q) }.
:- occurs(C, verb(search, X), Q), not not &tel { > >? occurs(C, verb(find, X), Q) }.
:- occurs(C, verb(search, X), Q), not not &tel { > >? occurs(C, verb(search, X), Q) }.
:- occurs(C, verb(defeat, trans(CC)), act(Q)), occurs(CC, verb(defeat, trans(C)), act(Q)).
:- occurs(C, verb(fight, trans(CC)), Q), not villain(CC), player(C).

:- occurs(_, verb(escape, none), act(Q)), not story'(_).
:- occurs(_, verb(defeat, trans(C)), act(Q)), not not &tel { > >? occurs(C, verb(A, B), act(Q)) }, act(Q), verb(A, B).

% fails conditions
