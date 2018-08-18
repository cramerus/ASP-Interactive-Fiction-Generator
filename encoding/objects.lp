#program initial.

object(X) :- init(goal(verb(_, trans(object(X))), _)).
object(X) :- init(has(_, object(X))).
has(C, X) :- init(has(C, X)).

#program always.

object(X) :- _object(X).
object(key) :- is(_, adj(trapped)).

% unidirectional semantic linking
link(verb(give, ditrans(X, C)), has(C, X)) :- verb(give, ditrans(X, C)).
link(has(character(C), X), verb(give, ditrans(X, CC))) :- verb(give, ditrans(X, CC)), character(C).
link(has(character(C), X), verb(request, ditrans(X, C))) :- verb(request, ditrans(X, C)), character(C).
link(verb(take, trans(X)), has(C, X)) :- trans(X), player(C).
link(verb(steal, ditrans(X, CC)), has(character(C), X)) :- character(C), verb(steal, ditrans(X, CC)).
link(has(C, X), verb(steal, ditrans(X, C))) :- verb(steal, ditrans(X, C)).
link(has(C, X), verb(use, trans(X))) :- trans(X), player(C).
link(has(C, object(key)), verb(escape, none)) :- player(C).

#program dynamic.

% continuing to have an object: works through acts
has(C, X) :- 'has(C, X), not remove(C, X).

% what triggers having an object
has(C, X) :- occurs(C, verb(take, trans(X)), _).
has(C, X) :- occurs(CC, verb(give, ditrans(X, C)), _).
has(C, X) :- occurs(C, verb(steal, ditrans(X, CC)), _).

% what triggers removal of object from possession
remove(CC, X) :- occurs(CC, verb(give, ditrans(X, C)), _).
remove(CC, X) :- occurs(C, verb(steal, ditrans(X, CC)), _).
remove(CC, X) :- occurs(CC, verb(destroy, trans(X)), _).

% VERBS that has affects
occurs(C, verb(find, trans(X)), Q) :- occurs(C, verb(search, trans(X)), Q), not fails(C, verb(find, trans(X)), Q).
occurs(CC, verb(give, ditrans(X, C)), Q) :- 'has(CC, X), occurs(C, verb(request, ditrans(X, CC)), Q), not not &tel { < <? occurs(C, verb(help, trans(CC)), Q) }.
:- occurs(C, verb(take, trans(X)), _), 'has(C, X).
:- occurs(C, verb(use, trans(X), _), Q), not 'has(C, X).
:- occurs(C, verb(give, ditrans(X, _)), Q), not 'has(C, X).
:- occurs(C, verb(give, ditrans(X, CC)), Q), 'has(CC, X).
:- occurs(C, verb(search, trans(X)), Q), 'has(CC, X).
:- occurs(C, verb(steal, ditrans(X, CC)), Q), not 'has(CC, X).
:- occurs(C, verb(request, ditrans(X, CC)), Q), not 'has(CC, X).
:- occurs(C, verb(request, ditrans(X, CC)), Q), 'has(C, X).

% conditions to escape: run, or have a key, or defeat/trick the villain in the same act
:- occurs(C, verb(escape, none), Q), role(antagonist, V), not has(C, object(key)), not not &tel {
    ~ < <? occurs(C, verb(run, none), Q) & 
    ~ < <? occurs(C, verb(defeat, trans(V)), Q) &
    ~ < <? occurs(C, verb(trick, trans(V)), Q) }.

% FAIL conditions due to effects
fails(CC, verb(give, ditrans(X, C)), Q) :- not occurs(CC, verb(give, ditrans(X, C)), Q), occurs(C, verb(request, ditrans(X, CC)), Q).
fails(C, verb(find, trans(X)), Q) :- occurs(C, verb(search, trans(X)), Q), has(_, X).
fails(C, verb(find, trans(X)), Q) :- occurs(C, verb(search, trans(X)), Q), is(C, place(Y)), is(X, place(Z)), Y != Z.
