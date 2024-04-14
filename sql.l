%{
#include<stdio.h>
#include<stdlib.h>
#include "sql.tab.h"


enum op_code {
  EQ = 1,
  NE = 2,
  LT = 3,
  GT = 4,
  LE = 5,
  GE = 6
};

void yyaccept() {
    printf("Query accepted!\n");
  
}

void yyabort() {
    printf("Query not accepted!\n");
   
}
%}
%option caseless
id [A-Za-z_][A-Za-z0-9_]* 
typeWithParent number|varchar|char|int|float
typeWithoutParent date|bool
op <>|<|>|<=|>=|=
nb [0-9]+
string '[^']+'
createKW create
deleteKW delete
selectKW select
tableKW table
fromKW from
whereKW where
updateKW update
setKW set
referencesKW references
foreignKW foreign
primaryKW primary
keyKW key
specialChar [\$\%\&\#\@\!\^\*\[\]\{\}\|\:\;\"\<\>\?\`\~\+\-\_\.\?\/\\]

%%
{createKW} { printf("CREATE : %s \n",yytext); return CREATETK; }
{selectKW} { printf("SELECT : %s \n",yytext); return SELECTTK; }
{deleteKW} { printf("DELETE : %s \n",yytext); return DELETETK;}
{tableKW} { printf("TABLE : %s \n",yytext); return TABLETK;}
{fromKW} { printf("FROM : %s \n",yytext); return FROMTK;}
{whereKW} { printf("WHERE : %s \n",yytext); return WHERETK; }
{updateKW} { printf("UPDATE : %s \n",yytext); return UPDATETK; }
{setKW} { printf("SET : %s \n",yytext); return SETTK;}
{referencesKW} { printf("%s \n",yytext);  return REFTK; }
{foreignKW}[ ]{keyKW} { printf("%s \n",yytext); return FOREIGNTK; }
{primaryKW}[ ]{keyKW} { printf("%s \n",yytext); return PRIMARYTK; }
{typeWithoutParent} { printf("TYPE WITHOUT PARENT : %s \n",yytext); return TYPEWITHOUTTK; }
{typeWithParent} { printf("TYPE WITH PARENT : %s \n",yytext); return TYPEWITHTK; }
{id} { printf("id : %s \n",yytext); return IDTK; }
{op} {
  printf("operator: %s \n", yytext);
  if (strcmp(yytext, "=") == 0) {
    yylval.op = EQ;
  } else if (strcmp(yytext, "<>") == 0) {
    yylval.op = NE;
  } else if (strcmp(yytext, "<") == 0) {
    yylval.op = LT;
  } else if (strcmp(yytext, ">") == 0) {
    yylval.op = GT;
  } else if (strcmp(yytext, "<=") == 0) {
    yylval.op = LE;
  } else if (strcmp(yytext, ">=") == 0) {
    yylval.op = GE;
  } else {
   yylval.op = 0 ;
  }
  return OPTK;
}
{nb} { printf("number %s \n",yytext);  return NBTK;}
"(" { printf(" %s \n",yytext); return PARENTOUV;}  
")" { printf("%s \n",yytext); return PARENTFERM; }  
"," {printf("%s \n",yytext); return VIRGULE;}
";" { printf(" pv: %s \n",yytext); return POINTVIR;}
{string} { printf("string : %s \n",yytext); return STRINGTK; }
[ \t\n\r] {}
{id}{specialChar}|{id}{specialChar}{id}|{specialChar}{id} { printf("%s Error : Special character detected in ID\n", yytext); }
. { printf("%s Erreur \n", yytext); }

%%

int yywrap() {
    return 0; 
}
