%{
    #include "zoomjoystrong.h"
    #include <stdio.h>
    int yylex();
%}

%error-verbose
%start zoomjoystrong

%union { int i; char* str; float f;}

%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token INT
%token FLOAT

%type<str> END
%type<str> END_STATEMENT
%type<str> POINT
%type<str> LINE
%type<str> CIRCLE
%type<str> RECTANGLE
%type<str> SET_COLOR
%type<i> INT
%type<f> FLOAT

%%


zoomjoystrong:	statementList end
;

statementList: statement 
	| statement statementList 
;

statement:  point  
	|	line  
	|	circle	
	|	rectangle 
	|	set_color
;

line:	LINE INT INT INT INT END_STATEMENT
	{  printf( "%s %d %d %d %d;\n", $1, $2, $3, $4, $5); callLine($2, $3, $4, $5); }
;


point:	POINT INT INT END_STATEMENT
	{ printf( "%s %d %d;\n" , $1, $2, $3); callPoint($2,$3); }  
;


rectangle:  RECTANGLE INT INT INT INT END_STATEMENT
	{ printf( "%s %d %d %d %d;\n", $1, $2, $3, $4, $5); callRectangle($2, $3, $4, $5); }
;

set_color:  SET_COLOR INT INT INT END_STATEMENT
	{ printf( "%s %d %d %d;\n", $1, $2, $3, $4); callSetColor($2, $3, $4); }
; 

end: END END_STATEMENT
	{ printf( "%s;\n", $1); finish(); return 0; }
;

%%