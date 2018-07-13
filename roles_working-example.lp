init(character(alice)).
init(character(bob)).
init(character(carol)).

init(role(protagonist)).
init(role(antagonist)).
init(role(support)).

#program initial.

q(0).

% import from instance
character(X) :- init(character(X)).

%1{role(protagonist,Y): character(Y) }1:- init(role(protagonist)).
:- character(Y), role(X,Y), role(Z,Y), Z!=X.
%role(X) :- init(role(X)), X != protagonist.
1{role(X,Y): character(Y) }1:- init(role(X)).

#program always.
character(X) :- _character(X).
role(X,Y) :- _role(X,Y).
:- role(X,Y), role(Z,Y), X!=Z.

%verbs
:- occurs(character(X), verb(_, character(Y)), _), X = Y.

verb(help,character(X)) :- character(X).
verb(harm,character(X)) :- character(X).
verb(worry,none).
verb(kill,none) :- character(X).
choice(verb(X,Y)) :- verb(X,Y), X != kill.

%moods
emotion(happy).
emotion(anxious).
emotion(hurt).
emotion(dead).

%effects
mood(X,anxious):- occurs(character(X), verb(worry, none), _).
mood(X,happy):- occurs(_, verb(help, character(X)), _).
mood(X,hurt):- occurs(_, verb(harm, character(X)), _), not mood(X,happy).
mood(X,dead):- occurs(_, verb(kill, character(X)), _), not mood(X,happy).

#program dynamic.
q(X+1) :- 'q(X).
occurs(X, Y, act(1)) :- choice(X, Y).
occurs(X, Y) :- occurs(X, Y, act(1)).
mood(X,dead) :- 'mood(X,dead).

%behavior protagonist --> player
1 { choice(character(X), verb(Y, Z)) : choice(verb(Y, Z)) } 1 :- role(protagonist,X).
role(support,Y):- occurs(character(X),verb(help,character(Y)),act(1)),role(protagonist,X).

%behavior support
choice(character(X), verb(help,character(Y))):- role(support,X), role(protagonist,Y), not 'mood(X,_).

%behavior antagonist
choice(character(X), verb(harm,character(Y))):- role(antagonist,X), role(protagonist,Y), not 'mood(X,_).
choice(character(X), verb(kill,character(Y))):- role(antagonist,X), role(support,Y), 'mood(X,hurt).

#program final.
:- not q(2).

#show role/2.
#show mood/2.
#show occurs/2.
%#show q/1.