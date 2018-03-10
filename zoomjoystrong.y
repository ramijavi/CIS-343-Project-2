%{
    #include "zoomjoystrong.h"
    #include <stdio.h>
    int yylex();
    void yyerror(const char* msg);
    void callLine(int x, int y, int a, int b);
    void callPoint(int x, int y);
    void callCircle(int x, int y, int radius);
    void callSetColor(int red, int blue, int green);
    void callRectangle(int x, int y, int w, int h);
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


int main(int argc, char** argv){
  setup();
  yyparse();
  printf("\n Programe Existing \n");
  return 0;
}

void yyerror(const char* msg){
  fprintf(stderr, "ERROR! %s\n", msg);
}

void callLine(int x, int y, int a, int b){
  if(x < HEIGHT && x > 0 && x < WIDTH && y < HEIGHT && y > 0 && y < WIDTH && a < HEIGHT && a > 0 && a < WIDTH && b < HEIGHT && b > 0 && b < WIDTH){
        line(x,y,a,b);
  }
  else{
        printf("\nFailed to draw line: Invalid arguments\n");
  }
}

void callPoint(int x, int y){
  if(x < HEIGHT && x > 0 && x < WIDTH && y < HEIGHT && y > 0 && y < WIDTH){
   	point(x , y);
  }
  else{
    	printf("\nFailed to draw point: Invalid arguments\n");
  }
}

void callCircle(int x, int y, int radius){
  if (radius > 0 && HEIGHT-y >= radius && y>=radius && x>=radius && WIDTH-x >= radius){ 
    circle( x, y, radius);
  }
  else{
    printf("\nFailed to draw circle: Invalid arguments\n");
  }
}

void callRectangle(int x, int y, int w, int h){
  if( x + w <= WIDTH && x + w >= 0 && y + h <= HEIGHT && y + h >= 0){ 
    rectangle( x, y, w, h);
  }
  else{
    printf("\nFailed to draw rectangle: Invalid arguments\n");
  }
}

void callSetColor(int red, int blue, int green){
  if(red < 256 && red >= 0 && blue < 256 && blue >= 0 && green < 256 && green >= 0){
    set_color( red, blue, green);
  }
  else{
    printf("\nFailed to set color: Invalid arguments\n");
  }
}
