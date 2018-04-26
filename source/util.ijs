NB. x name
NB. y decoded json hash table
NB. return _1 or box value
gethash_json=: 4 : 0
assert. 2=$$y
assert. 32=3!:0 y
x=. ,&.> boxopen x
assert. 1=$x
if. ({.x) e. {.y do.
  ({:y){~({.y) i. {.x
else.
  _1
end.
)

NB. is empty hash ?
emptyhash_json=: 3 : 0
(2=$$y) *. (0={.$y) *. 32=3!:0 y
)

NB. is empty array ?
emptyarray_json=: 3 : 0
(2>$$y) *. (0=#y) *. 32=3!:0 y
)
