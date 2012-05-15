/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
    private int curr_comment_count = 0;
    int get_curr_comment_count() {
    return curr_comment_count;
    }
    private boolean in_dash_comment = false;
    private boolean null_string = false;
    private String temp = "";
    private int curr_string_line = 0;
    int get_curr_string_line() {
    return curr_string_line;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
	/* nothing special to do in the initial state */
	break;
	/* If necessary, add code for other states here, e.g: */
	case STRING:
	yybegin( YYINITIAL );
	return new Symbol(TokenConstants.ERROR, "EOF in string constant");
	/* break; */
	case COMMENT:
	yybegin( YYINITIAL );
	if(!in_dash_comment){
	in_dash_comment = false;
	return new Symbol(TokenConstants.ERROR, "EOF in comment");
	}
	/* break; */
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup
%state COMMENT
%state STRING

NEWLINE_CHAR = [\n\012]
WHITESPACE = [ \t\f\b\022\013\033\015]
DIGIT = [0-9]
ALPHA = [a-zA-Z]
ALPHANUM = [a-zA-Z0-9_]
GOOD = [-/=<~,;:@\(\)\.\*\{\}\+]
BAD = [`#%&^_!'>\?\[\]\|\$]
BADDER = \\
NULL = [\0]
INVIS = [\001\002\003\004]

%%

<YYINITIAL> [cC][lL][aA][sS][sS]				{ return new Symbol(TokenConstants.CLASS); }
<YYINITIAL> [eE][lL][sS][eE]					{ return new Symbol(TokenConstants.ELSE); }
<YYINITIAL> [fF][iI]							{ return new Symbol(TokenConstants.FI); }
<YYINITIAL> [iI][fF]							{ return new Symbol(TokenConstants.IF); }
<YYINITIAL> [iI][nN]							{ return new Symbol(TokenConstants.IN); }
<YYINITIAL> [iI][nN][hH][eE][rR][iI][tT][sS]	{ return new Symbol(TokenConstants.INHERITS); }
<YYINITIAL> [iI][sS][vV][oO][iI][dD] 			{ return new Symbol(TokenConstants.ISVOID); }
<YYINITIAL> [lL][eE][tT]						{ return new Symbol(TokenConstants.LET); }
<YYINITIAL> [lL][oO][oO][pP]					{ return new Symbol(TokenConstants.LOOP); }
<YYINITIAL> [pP][oO][oO][lL]					{ return new Symbol(TokenConstants.POOL); }
<YYINITIAL> [tT][hH][eE][nN] 					{ return new Symbol(TokenConstants.THEN); }
<YYINITIAL> [wW][hH][iI][lL][eE]				{ return new Symbol(TokenConstants.WHILE); }
<YYINITIAL> [cC][aA][sS][eE]					{ return new Symbol(TokenConstants.CASE); }
<YYINITIAL> [eE][sS][aA][cC]					{ return new Symbol(TokenConstants.ESAC); }
<YYINITIAL> [nN][eE][wW]						{ return new Symbol(TokenConstants.NEW); }
<YYINITIAL> [oO][fF]							{ return new Symbol(TokenConstants.OF); }
<YYINITIAL> [nN][oO][tT]						{ return new Symbol(TokenConstants.NOT); }
<YYINITIAL> f[aA][lL][sS][eE]					{ return new Symbol(TokenConstants.BOOL_CONST, "false"); }
<YYINITIAL> t[rR][uU][eE]						{ return new Symbol(TokenConstants.BOOL_CONST, "true"); }


<YYINITIAL> "(*"		{ 
							yybegin( COMMENT ); 
							curr_comment_count++;
						}

<YYINITIAL> "+"			{ return new Symbol(TokenConstants.PLUS); }
<YYINITIAL> "/"			{ return new Symbol(TokenConstants.DIV); }
<YYINITIAL> "-"			{ return new Symbol(TokenConstants.MINUS); }
<YYINITIAL> "*"			{ return new Symbol(TokenConstants.MULT); }
<YYINITIAL> "="			{ return new Symbol(TokenConstants.EQ); }
<YYINITIAL> "<"			{ return new Symbol(TokenConstants.LT); }
<YYINITIAL> "."			{ return new Symbol(TokenConstants.DOT); }
<YYINITIAL> "+"			{ return new Symbol(TokenConstants.PLUS); }
<YYINITIAL> "~"			{ return new Symbol(TokenConstants.NEG); }
<YYINITIAL> ","			{ return new Symbol(TokenConstants.COMMA); }
<YYINITIAL> ";"			{ return new Symbol(TokenConstants.SEMI); }
<YYINITIAL> ":"			{ return new Symbol(TokenConstants.COLON); }
<YYINITIAL> "("			{ return new Symbol(TokenConstants.LPAREN); }
<YYINITIAL> ")"			{ return new Symbol(TokenConstants.RPAREN); }
<YYINITIAL> "@"			{ return new Symbol(TokenConstants.AT); }
<YYINITIAL> "{"			{ return new Symbol(TokenConstants.LBRACE); }
<YYINITIAL> "}"			{ return new Symbol(TokenConstants.RBRACE); }
<YYINITIAL> "=>"		{ return new Symbol(TokenConstants.DARROW); }
<YYINITIAL> "<="		{ return new Symbol(TokenConstants.LE); }
<YYINITIAL> "<-"		{ return new Symbol(TokenConstants.ASSIGN); }
<YYINITIAL> "*)"		{ return new Symbol(TokenConstants.ERROR, "Unmatched *)"); }

<YYINITIAL> [A-Z]{ALPHANUM}* { return new Symbol(TokenConstants.TYPEID, AbstractTable.idtable.addString(yytext())); }
<YYINITIAL> {ALPHA}+{ALPHANUM}* { return new Symbol(TokenConstants.OBJECTID, AbstractTable.idtable.addString(yytext())); }

<YYINITIAL> "\""		{ 
							yybegin( STRING );
							temp = "";
							curr_string_line = 0;
						}
<YYINITIAL> "--"		{
							yybegin( COMMENT );
							in_dash_comment = true;
						}

<YYINITIAL> {DIGIT}+	{ return new Symbol(TokenConstants.INT_CONST, 
											AbstractTable.inttable.addString(yytext())); }

<STRING> "\""			{
							yybegin( YYINITIAL );
							if(temp.length() > MAX_STR_CONST - 1){
								return new Symbol(TokenConstants.ERROR,
													"String constant too long");
							}
							if(!null_string){
								null_string = false;
								return new Symbol(TokenConstants.STR_CONST,
												AbstractTable.stringtable.addString(temp));
							}
						}
						
<STRING> \\[btnf\"\\]		{
							
							char c = yytext().charAt(1);
							switch(c){
							case 'b':
								temp = temp.concat(Character.toString('\b'));
								break;
							case 't':
								temp = temp.concat(Character.toString('\t'));
								break;
							case 'n':
								temp = temp.concat(Character.toString('\n'));
								break;
							case 'f':
								temp = temp.concat(Character.toString('\f'));
								break;
							case '"':
								temp = temp.concat("\"");
								break;
							case '\\':
								temp = temp.concat("\\");
								break;
							default:
								System.out.println("How did you screw up?");
								break;
							}
							}
						
<STRING> {NULL}				{
								null_string = true;
								return new Symbol(TokenConstants.ERROR, "String contains null character");
							}

<STRING> {ALPHANUM}|{WHITESPACE}|{GOOD}|{BAD}	{ 
								temp = temp.concat(yytext());
							}

<STRING> \\{NEWLINE_CHAR}	{	
								curr_lineno++;
								char c = yytext().charAt(1);
								switch(c){
								case '\015':
									temp = temp.concat(Character.toString('\015'));
									break;
								case '\n':
									temp = temp.concat(Character.toString('\n'));
									break;
								default:
									System.out.println("How did you screw up?");
									break;
								}
							}

<STRING> \\					{ /* Do nothing */ }

<STRING> {NEWLINE_CHAR}		{
								yybegin( YYINITIAL );
								temp = "";
								curr_lineno++;
								if(!null_string){
									return new Symbol(TokenConstants.ERROR, "Unterminated string constant");
								}
							}
						
<COMMENT> "(*"				{
								if(!in_dash_comment){
									curr_comment_count++;
								}
							}
<COMMENT> "*)"				{
								if(!in_dash_comment){
									curr_comment_count--;
									if(get_curr_comment_count() == 0){
										yybegin( YYINITIAL );
									}
								}
							}
<COMMENT> {NEWLINE_CHAR}	{
								curr_lineno++;
								if(in_dash_comment){
									in_dash_comment = false;
									yybegin( YYINITIAL );
								}
							}
<YYINITIAL,COMMENT, STRING> {NEWLINE_CHAR}	{ curr_lineno++; }
<YYINITIAL,COMMENT> {WHITESPACE}+ { /* Do nothing */ }
<YYINITIAL> {BAD}|{BADDER}|{INVIS}			{ return new Symbol(TokenConstants.ERROR, "" + yytext() + ""); }
<STRING> . { /* Do nothing. */ }
<COMMENT> . { /* Do nothing. */ }
<YYINITIAL> .  { /* This rule should be the very last
                                     in your lexical specification and
                                     will match match everything not
                                     matched by other lexical rules. */
                                  System.err.println("LEXER BUG - UNMATCHED: " + yytext()); }
