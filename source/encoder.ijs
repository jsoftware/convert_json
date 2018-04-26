NB. json encoder

enc_json=: 3 : 0
select. t=. 3!:0 y
case. 2;131072;262144 do.
  if. y-:'json_true' do. 'true'
  elseif. y-:'json_false' do. 'false'
  elseif. y-:'json_null' do. 'null'
  elseif. do.
    '"', '"',~ jsonesc utf8^:(2~:t) ,y
  end.
case. 1;4;8 do.
  ":!.17 {.,y
case. 32 do.
  if. 2>$$y do.
    if. 0=#y do.
      '[]'       NB. empty array
    else.
      s=. '['
      for_v. y do.
        s=. s , ',',~ enc_json >v
      end.
      ']',~ }:s
    end.
  elseif. 2=$$y do.
    assert. 0 2 e.~ {.$y
    if. 0=#y do.
      '{}'       NB. empty hash
    else.
      s=. '{'
      for_i. i.{:$y do.
        s=. s , ':',~ enc_json (<0,i){::y
        s=. s , ',',~ enc_json (<1,i){::y
      end.
      '}',~ }:s
    end.
  elseif. do. 13!:8[3
  end.
case. do. 13!:8[3
end.
)

NB. escape sequence of json
NB. \n linefeed
NB. \r carriage return
NB. \t horizontal tab
NB. \b backspace
NB. \f formfeed
NB. \\ backslash
NB. \/ slash
NB. \" quote
NB. \uxxxx unicode code
JSONESC0=: LF, CR, TAB, FF, (8{a.), '\/"'
JSONESC1=: 'nrtfb\/"'
JSONASC=: JSONESC0, 32}.127{.a.
jsonesc=: 3 : 0
NB. add backslash
txt=. y
msk=. txt e. JSONESC0
if. 1 e. msk do.
  ndx=. , ((I. msk) + i. +/ msk) +/ 0 1
  new=. , '\',.JSONESC1 {~ JSONESC0 i. msk#txt
  txt=. new ndx } (1 + msk) # txt
end.
NB. convert nonprinting ascii characters to uxxxx
msk=. -. txt e. JSONASC
if. 1 e. msk do.
  new=. 'u',"1 '0123456789abcdef' {~ 16 16 16 16 #: a. i. msk # txt
  ndx=., ((I. msk) + 5 * i. +/ msk) +/ i. 6
  txt=. (, '\',("1) new) ndx } (1 + msk * 5) # txt
end.
txt
)
