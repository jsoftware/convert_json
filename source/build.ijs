NB. build.ijs

mkdir_j_ jpath '~Addons/convert/json'
mkdir_j_ jpath '~addons/convert/json'

writesourcex_jp_ '~Addons/convert/json/source';'~Addons/convert/json/json.ijs'

(jpath '~addons/convert/json/json.ijs') (fcopynew ::0:) jpath '~Addons/convert/json/json.ijs'

f=. 3 : 0
(jpath '~Addons/convert/json/',y) fcopynew jpath '~Addons/convert/json/source/',y
(jpath '~addons/convert/json/',y) (fcopynew ::0:) jpath '~Addons/convert/json/source/',y
)

f 'history.txt'
f 'manifest.ijs'
