wdir=.
t2t = ./pbp/t2t.bash ${wdir} ${wdir}/pbp


all : abc2py abcir2py

abc2py : abc.ohm abc2py.rwr test.abc
	${t2t}  abc.ohm abc2py.rwr empty.js test.abc >test.meta-py
	node indenter.mjs <test.meta-py >test.py
	python3 test.py

abcir2py : abcir.ohm abc2py.rwr test.abcir
	${t2t}  abcir.ohm abcir2py.rwr empty.js test.abcir >testir.meta-py
	node indenter.mjs <testir.meta-py >testir.py
	python3 testir.py

test.abcir : abcir.rwr abc.ohm empty.js test.abc
	${t2t}  abc.ohm abcir.rwr empty.js test.abc >test.abcir

install-js-requires:
	npm install yargs prompt-sync ohm-js
