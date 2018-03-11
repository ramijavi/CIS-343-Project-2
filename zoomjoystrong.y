/* C declarations */

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

/* Bison declarations */

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

/* Grammar rules*/
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

/* Additional C code */

/* Main method, entry poin for the program */
int main(int argc, char** argv){
  	
	setup();
  	yyparse();
  	printf("\n Programe Existing \n");
  	return 0;

}

/* Error reporting function. Will print an error message whenever it reads a token that doesn't
 * satify any syntax rule 
 */
void yyerror(const char* msg){

  	fprintf(stderr, "ERROR! %s\n", msg);

}

/* Custom function that calls the line function in the source file */
void callLine(int x, int y, int a, int b){

	/* Checks for input error: checks that the coordinates are within the window dimensions*/
	if(x < HEIGHT && x > 0 && x < WIDTH && y < HEIGHT && y > 0 && y < WIDTH && a < HEIGHT && a > 0 && a < WIDTH && b < HEIGHT && b > 0 && b < WIDTH){
        	line(x, y, a, b);
  	}
	/* Notify the user if incorrect input was entered */
  	else{
        	printf("\nFailed to draw line: Invalid arguments\n");
  	}
}

/* Custom function that calls the point function in the source file */
void callPoint(int x, int y){

	/* Checks for input eror: checks that the coordinates are within the window dimensions */
  	if(x < HEIGHT && x > 0 && x < WIDTH && y < HEIGHT && y > 0 && y < WIDTH){
		point(x , y);
	}
	/* Notify the user if incorrect input was entered */
  	else{
    		printf("\nFailed to draw point: Invalid arguments\n");
  	}
}

/* Custom function that calls the circle function in the source file */
void callCircle(int x, int y, int radius){
	
	/* Checks for input error: checks that the circle will be within the window dimensions
	 * Adds the radius and the center coordinates to make sure of this
	 */
	if (radius > 0 && HEIGHT-y >= radius && y>=radius && x>=radius && WIDTH-x >= radius){ 
    		circle( x, y, radius);
  	}
	/* Notify the user if incorrect input was entered */
  	else{
  		printf("\nFailed to draw circle: Invalid arguments\n");
	}
}

/* Custom function that calls the rectangle function in the source file */
void callRectangle(int x, int y, int w, int h){

	/* Checks for input error: checks that the rectangle will be within the window dimensions
	 * Adds the width and the height of the rectangle to the coordinates to ensure that they
	 * are not greater than the window size
	 */
  	if( x + w <= WIDTH && x + w >= 0 && y + h <= HEIGHT && y + h >= 0){ 
    		rectangle( x, y, w, h);
  	}
	/* Notify the user if incorrect input was entered */
  	else{
    		printf("\nFailed to draw rectangle: Invalid arguments\n");
  	}
}

/* Custom function that calls the set_color function in the source file */
void callSetColor(int red, int blue, int green){

	/* Check  for input error: checks that the number entered for the three primary colors are valid
	 * These values must be between 0 and 255, both included
	 */
  	if(red =< 255 && red >= 0 && blue =< 255 && blue >= 0 && green =< 255 && green >= 0){
    		set_color( red, blue, green);
  	}
	/* Notify the client if incorrect input was entered*/
  	else{
  	 	printf("\nFailed to set color: Invalid arguments\n");
  	}
}
