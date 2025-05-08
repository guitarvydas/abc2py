#!/bin/bash
sbcl --noinform --non-interactive \
     --eval '(setf *print-pretty* t)' \
     --eval '(setf (readtable-case *readtable*) :preserve)' \
     --eval '(let ((form (read *standard-input* nil nil)))  (pprint form) (terpri) (exit))'
