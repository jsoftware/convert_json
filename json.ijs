require 'regex'

coclass 'json'
classes=. 3<. '"\[],{}:' (#@[ |&>: i.) a.
classes=. 0 (I.a.e.' ',CRLF,TAB)} (]+4*0=])classes

words=: (0;(0 10#:10*".;._2]0 :0);classes)&;:
  0.0  1.1  2.1  3.1  4.1
  1.0  5.0  6.0  1.0  1.0
  4.0  4.0  4.0  4.0  4.0
  0.3  1.2  2.2  3.2  4.2
  0.3  1.2  2.0  3.2  4.0
  0.3  1.2  2.2  3.2  4.2
  1.0  1.0  1.0  1.0  1.0
)

tokens=. ;:'[ ] , { } :'
actions=: lBra`rBracket`comma`lBra`rBracket`colon`value
fromJson=: 0 {:: (,a:) ,&.> [: actions @.(tokens&i.@[)/ [:|.a:,words

lBra=: a: ,~ ]
rBracket=: _2&}.@], [:< _2&{::@], _1&{@]
comma=: ]
rBrace=: _2&}.@], [:< _2&{::@], [:|: (2,~ [: -:@$ _1&{@]) $ _1&{@]
colon=: ]
value=: _1&}.@], [:< _1&{::@], jsonValue&.>@[
jsonValue=: 3 : 0
if. '"'={. y do. evalbs }.}:y
elseif. 'true'-:y do. 1
elseif. 'false'-:y do. 0
elseif. do. {. 0". 'Ee-_' charsub y
end.
)
subst2=: (_2<\'\"\\\/\b\f\n\r\t')&(i.{(34 92 47 8 12 10 13 9{&.><a.),])"0
hexchars=. 'ABCDEF0123456789abcdef'
dfh=: 16 #. 16 | _6 + hexchars i. ]
subst6=: (8 u:[:u:@dfh 2}.]) ::]^:(6&=@#*.('\'={.)*.'uU'e.~{.@}.)&.>

splitbs=: (0;(0 10#:10*".;._2]0 :0);(a.e.hexchars)+(2*a.='\')+3*a.e.'Uu')&;:
 1.1  1.1  2.1 1.1
 1.0  1.0  2.2 1.0
 3.0  3.0  3.0 4.0
 1.2  1.2  2.2 1.2
 1.2  5.0  2.2 1.2
 1.2  6.0  2.2 1.2
 1.2  7.0  2.2 1.2
 1.2  3.0  2.2 1.2
)
evalbs=: [:; [:subst2 [:subst6 splitbs^:(*@#)
fromJson_z_=: fromJson_json_
toJson_z_=: toJson_json_
