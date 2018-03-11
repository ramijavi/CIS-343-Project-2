%{

	#include "contact.tab.h"
	#include <stdlib.h>

%}

%option noyywrap

%%

(end)	  { yylval.str = strdup(yytext); return END; }
;	  { return END_STATEMENT; }




%%
