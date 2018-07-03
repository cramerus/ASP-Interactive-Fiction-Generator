init(character(alice)).
init(character(bob)).
init(character(carol)).

init(role(protagonist,alice)).
init(role(antagonist)).
init(role(support)).

init(specialist(scientist,carol)).
init(specialist(thief,bob)).

#program initial.

q(0).

% import from instance
character(X) :- init(character(X)).

%random roles, fixed protagonist
:- character(Y), role(X,Y), role(Z,Y), Z!=X.
role(X,Y):- init(role(X,Y)).
1{role(X,Y): character(Y) }1:- init(role(X)).

%fixed specialists
specialist(X,Y) :- init(specialist(X,Y)).

#program always.
character(X) :- _character(X).
role(X,Y) :- _role(X,Y).
:- role(X,Y), role(Z,Y), X!=Z.
specialist(X,Y) :- _specialist(X,Y).

%verbs
:- occurs(character(X), verb(_, character(Y)), _), X = Y.
choice(verb(X,Y)) :- verb(X,Y), not reaction(X).

helpful(help).
helpful(equip).
helpful(inspire).

harmful(attack).
harmful(rob).
harmful(infect).

neutral(talk).
neutral(pickpocket).
neutral(research).

reaction(kill).

speciality(help,none).
speciality(attack,none).
speciality(talk,none).

%speciality(equip,thief).
speciality(rob,thief).
speciality(pickpocket,thief).

speciality(inspire,scientist).
speciality(infect,scientist).
speciality(research,scientist).

verb(help,character(X)) :- character(X).
verb(equip,character(X)) :- character(X).
verb(inspire,character(X)) :- character(X).

verb(attack,character(X)) :- character(X).
verb(rob,character(X)) :- character(X).
verb(infect,character(X)) :- character(X).

verb(talk,character(X)) :- character(X).
verb(pickpocket,none).
verb(research,none).

verb(kill,character(X)) :- character(X).

%moods
emotion(happy).
emotion(sick).
emotion(hurt).
emotion(dead).

%effects
mood(X,sick):- occurs(_, verb(infect, character(X)),_).
mood(X,happy):- occurs(_, verb(V, character(X)), _), helpful(V).
mood(X,hurt):- occurs(_, verb(attack, character(X)), _), not mood(X,happy).
mood(X,dead):- occurs(_, verb(kill, character(X)), _), not mood(X,happy).


#program dynamic.
q(X+1) :- 'q(X).
occurs(X, Y, act(1)) :- choice(X, Y).
occurs(X, Y) :- occurs(X, Y, act(1)).

%behavior protagonist --> player
1 { choice(character(X), verb(Y, Z)) : choice(verb(Y, Z)), speciality(Y, none) } 1 :- role(protagonist,X), not mood(X,dead), not 'mood(X,sick).
role(support,Y):- occurs(character(X),verb(help,character(Y)),act(1)),role(protagonist,X).
role(antagonist,Y):- occurs(character(X),verb(attack,character(Y)),act(1)),role(protagonist,X).

%behavior support
:- role(support,X), not choice(character(X),_).
:- role(support,X), choice(character(X),verb(V1,_)), choice(character(X),verb(V2,_)), V1!=V2.

choice(character(X),verb(V,character(Y))) :- role(support,X), helpful(V), specialist(SP,X), speciality(V,SP), role(protagonist,Y).
0{choice(character(X),verb(V,character(Y)))}1 :- role(support,X), helpful(V), speciality(V,none), role(protagonist,Y), not 'mood(X,_).

%behavior antagonist
:- role(antagonist,X), not choice(character(X),_).
:- role(antagonist,X), choice(character(X),verb(V1,_)), choice(character(X),verb(V2,_)), V1!=V2.
choice(character(X),verb(V,character(Y))) :- role(antagonist,X), harmful(V), specialist(SP,X), speciality(V,SP), role(protagonist,Y), not 'mood(X,_).
0{choice(character(X),verb(V,character(Y)))}1 :- role(antagonist,X), harmful(V), speciality(V,none), role(protagonist,Y), not 'mood(X,_).
choice(character(X),verb(kill,character(Y))) :- role(antagonist,X), role(support,Y), 'mood(X,hurt), not mood(Y,dead).


#program final.
:- not q(1).

%#show role/2.
#show mood/2.
#show occurs/2.