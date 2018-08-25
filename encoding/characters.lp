#program initial.

character(X) :- init(character(X)).
player(X) :- init(player(X)).

role(X, Y) :- init(role(X, Y)).
specialist(X, Y) :- init(specialist(X, Y)). % X is speciality, Y is character

#program always.

character(X) :- _character(X).
player(X) :- _player(X).

role(X, Y) :- _role(X, Y).
specialist(X, Y) :- _specialist(X, Y).

role(antagonist).
role(support).

specialist(scientist).
specialist(thief).
specialist(magic).

helpful(verb(help, X)) :- verb(help, X).
helpful(verb(equip, X)) :- verb(equip, X).
helpful(verb(inspire, X)) :- verb(inspire, X).

harmful(verb(fight, X)) :- verb(fight, X).
harmful(verb(rob, X)) :- verb(rob, X).
harmful(verb(infect, X)) :- verb(infect, X).
harmful(verb(curse, X)) :- verb(infect, X).

neutral(verb(talk, X)) :- verb(talk, X).
neutral(verb(pickpocket, X)) :- verb(pickpocket, X).
neutral(verb(research, none)).

speciality(verb(help, X), none) :- verb(help, X).
speciality(verb(fight, X), none) :- verb(fight, X).
speciality(verb(talk, X), none) :- verb(talk, X).

speciality(verb(equip, X), specialist(thief)) :- verb(equip, X).
speciality(verb(rob, X), specialist(thief)) :- verb(rob, X).
speciality(verb(pickpocket, X), specialist(thief)) :- verb(pickpocket, X).

speciality(verb(inspire, X), specialist(scientist)) :- verb(inspire, X).
speciality(verb(infect, X), specialist(scientist)) :- verb(infect, X).
speciality(verb(research, none), specialist(scientist)).

%speciality(verb(curse, X), specialist(magic)) :- verb(curse, X).

#program dynamic.

% assign roles if not already given
role(support, Y) :- occurs(X, verb(help, trans(Y)), _), player(X).
role(antagonist, Y) :- occurs(X, verb(fight, trans(Y)), _), player(X).
role(X, Y) :- 'role(X, Y).
:- 2 { role(_, character(X)) }, character(X).

% behavior: protagonist
%1 { choice(character(X), verb(Y, Z)) : choice(verb(Y, Z)), speciality(Y, none) } 1 :- role(protagonist,X), not mood(X,dead), not 'mood(X,sick).

% behavior: support
%:- role(support,X), not choice(character(X),_).
%:- role(support,X), choice(character(X),verb(V1,_)), choice(character(X),verb(V2,_)), V1!=V2.

%choice(character(X),verb(V,character(Y))) :- role(support,X), helpful(V), specialist(SP,X), speciality(V,SP), role(protagonist,Y).
%0{choice(character(X),verb(V,character(Y)))}1 :- role(support,X), helpful(V), speciality(V,none), role(protagonist,Y), not 'mood(X,_).

% behavior: antagonist
%:- role(antagonist,X), not choice(character(X),_).
%:- role(antagonist,X), choice(character(X),verb(V1,_)), choice(character(X),verb(V2,_)), V1!=V2.
%choice(character(X),verb(V,character(Y))) :- role(antagonist,X), harmful(V), specialist(SP,X), speciality(V,SP), role(protagonist,Y), not 'mood(X,_).
%0{choice(character(X),verb(V,character(Y)))}1 :- role(antagonist,X), harmful(V), speciality(V,none), role(protagonist,Y), not 'mood(X,_).
%choice(character(X),verb(kill,character(Y))) :- role(antagonist,X), role(support,Y), 'mood(X,hurt), not mood(Y,dead).

% antagonist fights everyone they find
occurs(CC, verb(fight, trans(C)), Q) :- 'occurs(CC, verb(find, trans(C)), Q),  role(antagonist, CC),
    not occurs(C, verb(trick, trans(CC)), Q),
    not occurs(C, verb(run, none), Q),
    not occurs(C, verb(escape, none), Q),
    not is(C, adj(safe)).

% 'follower' character follows player if support
occurs(C, verb(go, trans(X)), Q) :- is(C, adj(follower)), occurs(CC, verb(go, trans(X)), Q), player(CC), 'is(C, Y), 'is(CC, Y), Y != X, role(support, C).
is(C, adj(visible)) :- occurs(C, verb(go, trans(X)), Q), is(C, adj(follower)).

% constraints
:- occurs(C, verb(hug, trans(X)), _), role(antagonist, X), player(C).
:- occurs(C, verb(help, trans(X)), _), role(antagonist, X), player(C).
:- occurs(C, verb(steal, ditrans(_, X)), _), role(support, X), player(C).
:- occurs(C, verb(fight, trans(X)), _), role(support, X), player(C).
:- occurs(C, verb(request, ditrans(_, X)), _), role(antagonist, X), player(C).
:- occurs(C, verb(lie, trans(X)), _), role(support, X), player(C).
