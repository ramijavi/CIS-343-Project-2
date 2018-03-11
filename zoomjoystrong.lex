%{

	#include "contact.tab.h"
	#include <stdlib.h>

%}

%option noyywrap

%%

(end)	  		{ yylval.str = strdup(yytext); return END; }
;	  		{ return END_STATEMENT; }
(POINT|point)		{ yylval.str = strdup(yytext); return POINT; }
(LINE|line)		{ yylval.str = strdup(yytext); return LINE; }
(CIRCLE|circle)  	{ yylval.str = strdup(yytext); return CIRCLE; }
(RECTANGLE|rectangle) 	{ yylval.str = strdup(yytext); return RECTANGLE; }
(SET_COLOR|set_color) 	{ yylval.str = strdup(yytext); return SET_COLOR; }
[0-9]+	  		{ yylval.i = atoi(yytext); return INT; }
-?[0-9]+\.[0-9]+ 	{yylval.f = atof(yytext); return FLOAT; }
[ \t\n]	  		;
.+  			; 



%%
