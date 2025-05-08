./pbp/t2t.bash . ./pbp  abcir.ohm abc2py.rwr empty.js test.abcir >test.mpy
node indenter.mjs <test.mpy

def test (self):
    b = 2
    c = 3
    a = b + c
    print (b)
    print (c)
    print (a)

test()


