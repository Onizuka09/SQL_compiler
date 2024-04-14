%{
#define YYDEBUG 0 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef YYDEBUG
  yydebug = 1;
#endif
int yylex(void);
int yyerror(char *s);

extern void yyaccept();
extern void yyabort();
%}
%union{
int op; 
}
%token CREATETK
%token SELECTTK
%token DELETETK
%token TABLETK
%token FROMTK
%token WHERETK
%token UPDATETK
%token SETTK
%token REFTK
%token FOREIGNTK
%token PRIMARYTK
%token TYPEWITHOUTTK
%token TYPEWITHTK
%token IDTK
%token <op> OPTK
%token <num> NBTK
%token PARENTOUV
%token PARENTFERM
%token VIRGULE
%token POINTVIR
%token STRINGTK

%start query

%%



query: diff_query  END 
	 | diff_query END query;
;
diff_query: update_query | create_query 
;
create_query: CREATETK TABLETK IDTK PARENTOUV column_list PARENTFERM ; 
column_list: column_def VIRGULE column_list
		   | column_def
		   ;
column_def: IDTK TYPEWITHOUTTK
		  | IDTK TYPEWITHTK PARENTOUV NBTK PARENTFERM
          |  IDTK TYPEWITHTK PARENTOUV NBTK PARENTFERM PRIMARYTK 
          | IDTK TYPEWITHOUTTK PRIMARYTK
		  | PRIMARYTK PARENTOUV idtk PARENTFERM 
		  | FOREIGNTK PARENTOUV IDTK PARENTFERM REFTK IDTK  PARENTOUV IDTK PARENTFERM 
          ;


update_query: UPDATETK IDTK SETTK list_set_statement ;



list_set_statement: list_set_statement VIRGULE set_statement|set_statement
;
set_statement: IDTK OPTK values{

        if (yylval.op== 1) {
        printf("Operator is equal\n");
    } else {
        printf("Operator is not equal\n");
        }
   
   
}
;
values: STRINGTK|NBTK 
;
END: POINTVIR { yyaccept("correct \n"); printf("> ");} ;
%%

#include "lex.yy.c"

int yyerror(char *s){

//Execution a la main
//  // diff_query  POINTVIR
//update_query  POINTVIR
// UPDATETK IDTK  SETTK list_set_statement  POINTVIR
// UPDATETK IDTK  SETTK set_statement  POINTVIR
// UPDATETK IDTK  SETTK  IDTK OPTK values   POINTVIR
// UPDATETK IDTK  SETTK  IDTK OPTK STRINGTK   POINTVIR

    printf("%s\n",s);
    yyabort();
    return 1;
}


int main(int argc, char *argv[]){
// UPDATE Client SET Email = 3 ;
printf("> ");
//to add later
//diff_query: create_query | update_query | delete_query | select_query
//update_query: UPDATETK IDTK  SETTK list_set_statement | UPDATETK IDTK SETTK list_set_statement where_statement
    yyparse();
    //getchar();
    return 0;
}
