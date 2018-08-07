all:game

game: *.lisp *.asd
	clisp -q -ansi -norc  generate.lisp