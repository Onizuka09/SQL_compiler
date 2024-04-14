build: 
	bison -d sql.y --debug 
	lex sql.l
	gcc sql.tab.c -g -o test
