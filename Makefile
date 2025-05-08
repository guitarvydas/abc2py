wdir=.
t2t = ./pbp/t2t.bash ${wdir} ${wdir}/pbp


all : test.abcir abc2py 

abc2py : abcir.ohm abc2py.rwr test.abcir
	${t2t}  abcir.ohm abc2py.rwr empty.js test.abcir >test.mpy
	node indenter.mjs <test.mpy >test.py
	python3 test.py

test.abcir : abcir.rwr abc.ohm empty.js test.abc
	${t2t}  abc.ohm abcir.rwr empty.js test.abc >test.abcir

install-js-requires:
	npm install yargs prompt-sync ohm-js
