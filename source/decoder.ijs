NB. json - simple recursive descent parser

NB. contributed by Raul Miller in J Forum circa 2007

NB. =========================================================
NB.               character classes:
NB. 0: whitespace
NB. 1: "
NB. 2: \
NB. 3: [ ] , { } :
NB. 4: ordinary
classes=. 3<. '"\[],{}:' (#@[ |&>: i.) a.
classes=. 0 (I.a.e.' ',CRLF,TAB)} (]+4*0=])classes

words=: (0;(0 10#:10*".;._2]0 :0);classes)&;: NB. states:
  0.0  1.1  2.1  3.1  4.1  NB. 0 whitespace
  1.0  5.0  6.0  1.0  1.0  NB. 1 "
  4.0  4.0  4.0  4.0  4.0  NB. 2 \
  0.3  1.2  2.2  3.2  4.2  NB. 3 { : , } [ ]
  0.3  1.2  2.0  3.2  4.0  NB. 4 ordinary
  0.3  1.2  2.2  3.2  4.2  NB. 5 ""
  1.0  1.0  1.0  1.0  1.0  NB. 6 "\
)

NB. hypothetically, jsonValue should strip double quotes
NB. interpret back slashes
NB. and recognize numbers
jsonValue=: 3 : 0
if. 0=#y do. <y
elseif. 'true'-:y do. 'json_true'
elseif. 'false'-:y do. 'json_false'
elseif. 'null'-:y do. 'json_null'
elseif. '"'={. y do. evalbs }.}:y
elseif. '0123456789.+-' -.@e.~ {. y do. evalbs y
elseif. do. {. 0". 'Ee-_' charsub y
end.
)

NB. backslash evaluator

subst2=: (_2<\'\"\\\/\b\f\n\r\t')&(i.{(34 92 47 8 12 10 13 9{&.><a.),])"0
hexchars=. 'ABCDEF0123456789abcdef'
dfh=: 16 #. 16 | _6 + hexchars i. ]
subst6=: (8 u:[:u:@dfh 2}.]) ::]^:(6&=@#*.('\'={.)*.'uU'e.~{.@}.)&.>

splitbs=: (0;(0 10#:10*".;._2]0 :0);(a.e.hexchars)+(2*a.='\')+3*a.e.'Uu')&;:
 1.1  1.1  2.1 1.1 NB. state 0 -- start
 1.0  1.0  2.2 1.0 NB. state 1 -- ordinary characters
 3.0  3.0  3.0 4.0 NB. state 2 -- \
 1.2  1.2  2.2 1.2 NB. state 3 -- \n or \u0000
 1.2  5.0  2.2 1.2 NB. state 4 -- \u
 1.2  6.0  2.2 1.2 NB. state 5 -- \u0
 1.2  7.0  2.2 1.2 NB. state 6 -- \u00
 1.2  3.0  2.2 1.2 NB. state 7 -- \u000
)
evalbs=: [:; [:subst2 [:subst6 splitbs^:(*@#)

NB. test suite for backslash evaluator
NB. testbs=: (7 u: evalbs@[) assert at -: 4 u: ]
NB. ordinary text should remain unchanged
NB. 'abcd' testbs 97+i.4
NB. unicode escapes should work
NB. '\u005c\U00a5\U20a9' testbs 92 165 8361
NB. backslash escapes should work
NB. '\"\\\/\b\f\n\r\t' testbs 34 92 47 8 12 10 13 9
NB. empty strings should work
NB. '' testbs ''
NB. backslash processing should not get confused about state
NB. '\a\\\b000' testbs 92 97 92 8 48 48 48

NB. contributed by 04/05/07 Oleg Kobchenko

NB. =========================================================

NB.
NB. Val  ::= '[' List
NB.        | '{' Hash
NB.        | token
NB. List ::= ']'
NB.        | Val (',' Val)* ']'
NB. Hash ::= '}'
NB.        | Pair (',' Pair)* '}'
NB. Pair ::= Val ':' Val
NB.

'T_LBR T_RBR T_LCB T_RCB T_COM T_COL'=: ;:' [ ] { } , :'

token=: 3 : 0
(_1+I=: I+1){::T
)

dec_json=: 3 : 0
T=: words (LF,' ') charsub y-.CR
I=: 0
>getVal token''
)

NB. Val  ::= '[' List
NB.        | '{' Hash
NB.        | token
getVal=: 3 : 0
select. y
case. T_LBR do. getList token''
case. T_LCB do. getHash token''
case. do. <jsonValue y
end.
)

NB. List ::= ']'
NB.        | Val (',' Val)* ']'
getList=: 3 : 0
if. T_RBR -: y do. <0#<'' return. end.
r=. ,getVal y
while. -. T_RBR -: y=. token'' do.
  assert T_COM -: y
  r=. r,getVal token''
end.
<r
)

NB. Hash ::= '}'
NB.        | Pair (',' Pair)* '}'
getHash=: 3 : 0
if. T_RCB -: y do. <0#0 0$<'' return. end.
r=. getPair y
while. -. T_RCB -: y=. token'' do.
  assert T_COM -: y
  r=. r,.getPair token''
end.
<r
)

NB. Pair ::= Val ':' Val
getPair=: 3 : 0
h=. getVal y
assert T_COL -: token''
h,: getVal token''
)
