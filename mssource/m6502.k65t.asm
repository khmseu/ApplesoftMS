        .title  BASIC M6502 8K VER 1.1 BY MICRO-SOFT
        .include "M6502.lib.asm"
;Sall
;Radix 10			;throughout all but math-pak.

$Z:
                                     ;Starting point for m6502 simulator
        .org    0                    ;Start off at location zero.
        .subttl SWITCHES,MACROS.

REALIO  =       4                    ;5=Stm
                                     ;4=Apple.
                                     ;3=Commodore.
                                     ;2=Osi
                                     ;1=Mos tech,kim
                                     ;0=Pdp-10 simulating 6502
INTPRC  =       1                    ;Integer arrays.
ADDPRC  =       1                    ;For additional precision.
LNGERR  =       0                    ;Long error messages.
TIME    =       0                    ;Capability to set and read a clk.
EXTIO   =       0                    ;External i/o.
DISKO   =       0                    ;Save and load commands
NULCMD  =       1                    ;For the "null" command
GETCMD  =       1
RORSW   =       1
ROMSW   =       1                    ;Tells if this is on rom.
CLMWID  =       14
LONGI   =       1                    ;Long initialization switch.
STKEND  =       511
BUFPAG  =       0
LINLEN  =       72                   ;Terminal line length.
BUFLEN  =       72                   ;Input buffer size.
ROMLOC  =       0o20000              ;Address of start of pure segment.
KIMROM  =       1
        .if     ROMSW == 0
KIMROM  =       0
        .endif
        .if     REALIO != 1
KIMROM  =       0
        .endif
        .if     ROMSW != 0
RAMLOC  =       0o40000              ;Used only if romsw=1
        .if     REALIO == 0
ROMLOC  =       0o20000              ;Start at 8k.
RAMLOC  =       0o1400
        .endif
        .endif
        .if     REALIO == 3
DISKO   =       1
RAMLOC  =       0o2000
ROMLOC  =       0o140000
NULCMD  =       0
GETCMD  =       1
LINLEN  =       40
BUFLEN  =       81
CQOPEN  =       0o177700
CQCLOS  =       0o177703
CQOIN   =       0o177706             ;Open channel for input
CQOOUT  =       0o177711             ;Fill for commo.
CQCCHN  =       0o177714
CQINCH  =       0o177717             ;Inchr's call to get a character
OUTCH   =       0o177722
CQLOAD  =       0o177725
CQSAVE  =       0o177730
CQVERF  =       0o177733
CQSYS   =       0o177736
ISCNTC  =       0o177741
CZGETL  =       0o177744             ;Call point for "get"
CQCALL  =       0o177747             ;Close all channels
CQTIMR  =       0o215
BUFPAG  =       2
BUF     =       256 * BUFPAG
STKEND  =       507
CQSTAT  =       0o226
CQHTIM  =       0o164104
EXTIO   =       1
TIME    =       1
GETCMD  =       1
CLMWID  =       10
PI      =       255                  ;Value of pi character for commodore.
ROMSW   =       1
RORSW   =       1
TRMPOS  =       0o306
        .endif
        .if     REALIO == 1
GETCMD  =       1
DISKO   =       1
OUTCH   =       0o17240              ;1Ea0
ROMLOC  =       0o20000
RORSW   =       0
CZGETL  =       0o17132
        .endif
        .if     REALIO == 2
RORSW   =       0
RAMLOC  =       0o1000
        .if     ROMSW != 0
RORSW   =       0
RAMLOC  =       0o100000
        .endif
OUTCH   =       0o177013
        .endif
        .if     REALIO == 4
LNGERR  =       1
DISKO   =       1
RORSW   =       1
NULCMD  =       0
GETCMD  =       1
CQINLN  =       0o176547             ;fd67	GETLNZ
CQPRMP  =       0o63                 ;33		Prompt
CQINCH  =       0o176414             ;fd0c	RDKEY
CQCOUT  =       0o177315             ;fecd	WRITE
CQCSIN  =       0o177375             ;fefd	READ
BUFPAG  =       2
BUF     =       BUFPAG * 256
ROMLOC  =       0o150000             ;d000
RAMLOC  =       0o4000               ;0800
OUTCH   =       0o176755             ;fded	COUT
CZGETL  =       0o176414             ;fd0c	RDKEY
LINLEN  =       40
BUFLEN  =       240
RORSW   =       1
STKEND  =       507
        .endif
        .if     RORSW == 0
        .macro  ROR, WD
        LDA     #0
        BCC     * + 4
        LDA     #0o200
        LSR     \WD
        ORA     \WD
        STA     \WD
        .endmacro
        .endif

        .macro  ACRLF
        .byte   13
        .byte   10
        .endmacro
        .macro  SYNCHK, Q
        LDA     #\Q
        JSR     SYNCHR
        .endmacro
        .macro  DT, Q
IRPC	\Q,(IFDIF (\Q)("),(EXP "\Q"))
        .endmacro
        .macro  LDWD, WD
        LDA     \WD
        LDY     \WD + 1
        .endmacro
        .macro  LDWDI, WD
        LDA     #\WD & 0o377
        LDY     #\WD / 0o400
        .endmacro
        .macro  LDWX, WD
        LDA     \WD
        LDX     \WD + 1
        .endmacro
        .macro  LDWXI, WD
        LDA     #\WD & 0o377
        LDX     #\WD / 0o400
        .endmacro
        .macro  LDXY, WD
        LDX     \WD
        LDY     \WD + 1
        .endmacro
        .macro  LDXYI, WD
        LDX     #\WD & 0o377
        LDY     #\WD / 0o400
        .endmacro
        .macro  STWD, WD
        STA     \WD
        STY     \WD + 1
        .endmacro
        .macro  STWX, WD
        STA     \WD
        STX     \WD + 1
        .endmacro
        .macro  STXY, WD
        STX     \WD
        STY     \WD + 1
        .endmacro
        .macro  CLR, WD
        LDA     #0
        STA     \WD
        .endmacro
        .macro  COM, WD
        LDA     \WD
        EOR     #0o377
        STA     \WD
        .endmacro
        .macro  PULWD, WD
        PLA
        STA     \WD
        PLA
        STA     \WD + 1
        .endmacro
        .macro  PSHWD, WD
        LDA     \WD + 1
        PHA
        LDA     \WD
        PHA
        .endmacro
        .macro  JEQ, WD
        BNE     * + 5
        JMP     \WD
        .endmacro
        .macro  JNE, WD
        BEQ     * + 5
        JMP     \WD
        .endmacro
        .macro  BCCA, Q
        BCC     \Q
        .endmacro
                                     ;Branches that always branch
        .macro  BCSA, Q
        BCS     \Q
        .endmacro
                                     ;These are used on the 6502 because
        .macro  BEQA, Q
        BEQ     \Q
        .endmacro
                                     ;There is no unconditional branch
        .macro  BNEA, Q
        BNE     \Q
        .endmacro
        .macro  BMIA, Q
        BMI     \Q
        .endmacro
        .macro  BPLA, Q
        BPL     \Q
        .endmacro
        .macro  BVCA, Q
        BVC     \Q
        .endmacro
        .macro  BVSA, Q
        BVS     \Q
        .endmacro
        .macro  INCW, R
        INC     \R
        BNE     @Q
        INC     \R + 1
@Q:
        .endmacro
        .macro  SKIP1
        .byte   0o044
        .endmacro
                                     ;Bit zero page trick.
        .macro  SKIP2
        .byte   0o054
        .endmacro
                                     ;Bit abs trick.
        .if     1
        .if     REALIO == 0
        .print  SIMULATE
        .endif
        .if     REALIO == 1
        .print  KIM
        .endif
        .if     REALIO == 2
        .print  OSI
        .endif
        .if     REALIO == 3
        .print  COMMODORE
        .endif
        .if     REALIO == 4
        .print  APPLE
        .endif
        .if     REALIO == 5
        .print  STM
        .endif
        .if     ADDPRC != 0
        .print  ADDITIONAL PRECISION
        .endif
        .if     INTPRC != 0
        .print  INTEGER ARRAYS
        .endif
        .if     LNGERR != 0
        .print  LONG ERRORS
        .endif
        .if     DISKO != 0
        .print  SAVE AND LOAD
        .endif
        .if     ROMSW == 0
        .print  RAM
        .endif
        .if     ROMSW != 0
        .print  ROM
        .endif
        .if     RORSW == 0
        .print  NO ROR
        .endif
        .if     RORSW != 0
        .print  ROR ASSUMED
        .endif
        .endif
        .page
        .subttl INTRODUCTION AND COMPILATION PARAMETERS.

; --------- ---- -- ---------
; Copyright 1976 by microsoft
; --------- ---- -- ---------
; 7/27/78 Fixed bug where for variable at byte ff matched return searching
; 	For gosub entry on stack in fndfor call by changing sta forpnt
; 	To sta forpnt+1. this is a serious bug in all versions.
; 7/27/78 Fixed bug at newstt under ifn bufpag when check of curlin
; 	Was done before curlin set up so input retries of first statement
; 	Was giving syntax error instead of redo from start (code was 12/1/77 fix)
; 7/1/78	Saved a few bytes in init for commodore (14)
; 7/1/78 Fixed bug where replacing a line overflowing memory left links
; 	In a bad state. (code at nodel and fini) bug#4
; 7/1/78 Fixed bug where garbage collection never(!) collects temps
; 	(Sty grbpnt  at fndvar, lda grbpnt ora grbpnt+1 at grbpas)
; 	This was commodore bug #2
; 7/1/78 Fixed bug where delete/insert of line could cause a garbage collection with bad vartab if out of memory
; 	 (Ldwd memsiz stwd fretop=jsr runc clc also at nodel)
; 3/9/78 Edit to fix commo trmpos and change left$ and right$ to allow a second argument of 0 and return a null string
; 2/25/78 Fixed bug that inpflg was set wrong when bufpag.ne.0
; 	Increased numlev from 19 to 23
; 2/11/78 Disallowed spaces in reserved words. put in special check for "go to"
; 2/11/78 Fixed bug where rounding of the fac before pushing could cause a string pointer
; 	In the fac to be incremented
; 1/24/78 fixed problem where user defined function undefined check fix was smashing error number in [x]
; 12/1/77 Fixed problem where peek was smashing (poker) causing poke of peek to fail
; 12/1/77 Fixed problem where problem with vartxt=linnum=buf-2 causing buf-1 comma to disappear
; 12/1/77 Fixed bufpag.ne.0 problem at newstt and stop : code was still
; 	Assuming txtptr+1.eq.0 iff statement was direct

NUMLEV  =       23                   ;Number of stack levels reserved
                                     ;By an explicit call to "getstk"*
STRSIZ  =       3                    ;# Of locs per string descriptor.
NUMTMP  =       3                    ;Number of string temporaries.
CONTW   =       15                   ;Character to suppress output.

        .page
        .subttl SOME EXPLANATION.

; M6502 basic configures basic as follows

; Low locations
; 	Page	zero

; 		Startup:
; 		Initially a jmp to initialization code but
; 		Changed to a jmp to "ready".
; 		Restarting the machine at loc 0 during program
; 		Execution can leave things messed up.

; 		Loc of fac to integer and integer to fac
; 		Routines.

; 		"Direct" memory:
; 		These are the most commonly used locations.
; 		They hold bookkeeping info and all other
; 		Frequently used information.
; 		All temporaries, flags, pointers, the buffer area,
; 		The floating accumulator, and anything else that
; 		Is used to store a changing value should be located
; 		In this area. care must be made in moving locations
; 		In this area since the juxtaposition of two locations
; 		Is often depended upon.

; 		Still in ram we have the beginning of the "chrget"
; 		Subroutine. it is here so [txtptr] can be the
; 		Extended address of a load instruction.
; 		This saves having to bother any registers.

; 	Page	one
; 		The stack.

; 	Storage page two and on
; 		In ram versions these data structures come at the
; 		End of basic. in rom version they are at ramloc which
; 		Can either be above or below romloc, which is where
; 		Basic itself resides.

; 				A zero.
; 		[Txttab]	pointer to next line's pointer.
; 				Line # of this line (2 bytes).
; 				Characters on this line.
; 				Zero.
; 				Pointer at next line's pointer
; 					(Pointed to by the above pointer).
; 				... Repeats ...
; 		Last line:	pointer at zero pointer.
; 				Line # of this line.
; 				Characters on this line.
; 				Zero.
; 				Double zero (pointed to by the above pointer).
; 		[Vartab]	simple variables. 6 bytes per value.
; 				2 Bytes give the name, 4 bytes the value.
; 				... Repeats ...
; 		[Arytab]	array variables. 2 bytes name, 2 byte
; 				Length, number of dimensions , extent of
; 				Each dimension (2bytes/), values
; 				... Repeats ...
; 		[Strend]	free space.
; 				... Repeats ...
; 		[Fretop]	string space in use.
; 				... Repeats ...
; 		[Memsiz]	highest machine location.
; 				Unused except by the val function.

; 		Rom -- constants and code.

; 	Function dispatch addresses (at romloc)
; 		"Fundsp" contains the addresses of the
; 		Function routines in the order of the
; 		Function names in the crunch list.
; 		The functions that take more than one argument
; 		Are at the end. see the explanation at "isfun".

; 	The operator list
; 		The "optab" list contains an operator's precedence
; 		Followed by the address of the routine to perform
; 		The operation. the index into the
; 		Operator list is made by subtracting off the crunch value
; 		Of the lowest numbered operator. the order
; 		Of operators in the crunch list and in "optab" is identical.
; 		The precedences are arbitrary except for their
; 		Comparative sizes. note that the precedence for
; 		Unary operators such as "not" and negation are
; 		Setup specially without using the list.

; 	The reserved word or crunch list
; 		When a command or program line is typed in
; 		It is stored in "buf". as soon as the whole line
; 		Has been typed in ("inlin" returns) "crunch" is
; 		Called to convert all reserved words to their
; 		Crunched values. this reduces the size of the
; 		Program and speeds up execution by allowing
; 		List dispatches to perform functions, statements,
; 		And operations. this is because all the statement
; 		Names are stored consecutively in the crunch list.
; 		When a match is found between a string
; 		Of characters and a word in the crunch list
; 		The entire text of the matched word is taken out of
; 		The input line and a reserved word token is put
; 		In its place. a reserved word token is always equal
; 		To octal 200 plus the position of the matched word
; 		In the crunch list.

; 	Statement dispatch addresses
; 		When a statement is to be executed, the first
; 		Character of the statement is examined
; 		To see if it is less than the reserved
; 		Word token for the lowest numbered statement name.
; 		If so, the "let" code is called to
; 		Treat the statement as an assignment statement.
; 		Otherwise a check is made to make sure the
; 		Reserved word number is not too large to be a
; 		Statement type number. if not the address
; 		To dispatch to is fetched from "stmdsp" (the statement
; 		Dispatch list) using the reserved word
; 		Number for the statement to calculate an index into
; 		The list.

; 	Error messages
; 		When an error condition is detected,
; 		[Accx] must be set up to indicate which error
; 		Message is appropriate and a branch must be made
; 		To "error". the stack will be reset and all
; 		Program context will be lost. variables
; 		Values and the actual program remain intact.
; 		Only the value of [accx] is important when
; 		The branch is made to error. [accx] is used as an
; 		Index into "errtab" which gives the two
; 		Character error message that will be printed on the
; 		User's terminal.

; 	Textual messages
; 		Constant messages are stored here. unless
; 		The code to check if a string must be copied
; 		Is changed these strings must be stored above
; 		Page zero, or else they will be copied before
; 		They are printed.

; 	Fndfor
; 		Most small routines are fairly simple
; 		And are documented in place. "fndfor" is
; 		Used for finding "for" entries on
; 		The stack. whenever a "for" is executed, a
; 		16-Byte entry is pushed onto the stack.
; 		Before this is done, however, a check
; 		Must be made to see if there
; 		Are any "for" entries already on the stack
; 		For the same loop variable. if so, that "for" entry
; 		And all other "for" entries that were made after it
; 		Are eliminated from the stack. this is so a
; 		Program that jumps out of the middle
; 		Of a "for" loop and then restarts the loop again
; 		And again won't use up 18 bytes of stack
; 		Space every time. the "next" code also
; 		Calls "fndfor" to search for a "for" entry with
; 		The loop variable in
; 		The "next". at whatever point a match is found
; 		The stack is reset. if no match is found a
; 		"Next without for"  error occurs. gosub execution
; 		Also puts a 5-byte entry on stack.
; 		When a return is executed "fndfor" is
; 		Called with a variable pointer that can't
; 		Be matched. when "fndfor" has run
; 		Through all the "for" entries on the stack
; 		It returns and the return code makes
; 		Sure the entry that was stopped
; 		On is a gosub entry. this assures that
; 		If you gosub to a section of code
; 		In which a for loop is entered but never
; 		Exited the return will still be
; 		Able to find the most recent
; 		Gosub entry. the "return" code eliminates the
; 		"Gosub" entry and all "for" entries made after
; 		The gosub entry.

; 	Non-runtime stuff
; 		The code to input a line, crunch it, give errors,
; 		Find a specific line in the program,
; 		Perform a "new", "clear", and "list" are
; 		All in this area. given the explanation of
; 		Program storage set forth above, these are
; 		All straightforward.

; 	Newstt
; 		Whenever a statement finishes execution it
; 		Does a "rts" which takes
; 		Execution back to "newstt". statements that
; 		Create or look at semi-permanent stack entries
; 		Must get rid of the return address of "newstt" and
; 		Jmp to "newstt" when done. "newstt" always
; 		Chrgets the first character after the statement
; 		Name before dispatching. when returning
; 		Back to "newstt" the only thing that
; 		Must be set up is the text pointer in
; 		"Txtptr". "newstt" will check to make sure
; 		"Txtptr" is pointing to a statement terminator.
; 		If a statement shouldn't be performed unless
; 		It is properly formatted (i.e. "new") it can
; 		Simply do a return after reading all of
; 		Its arguments. since the zero flag
; 		Being off indicates there is not
; 		A statement terminator "newstt" will
; 		Do the jmp to the "syntax error"
; 		Routine. if a statement should be started
; 		Over it can do ldwd oldtxt, stwd txtptr rts since the text pntr
; 		At "newstt" is always stored in "oldtxt".
; 		The ^c code stores [curlin] (the
; 		Current line number) in "oldlin" since the ^c check
; 		Is made before the statement pointed to is
; 		Executed. "stop" and "end" store the text pointer
; 		From "txtptr", which points at their terminating
; 		Character, in "oldtxt".

; 	Statement code
; 		The individual statement code comes
; 		Next. the approach used in executing each
; 		Statement is documented in the statement code
; 		Itself.

; 	Frmevl, the formula evaluator
; 		Given a text pointer pointing to the starting
; 		Character of a formula, "frmevl"
; 		Evaluates the formula and leaves
; 		The value in the floating accumulator (fac).
; 		"Txtptr" is returned pointing to the first character
; 		That could not be interpreted as part of the
; 		Formula. the algorithm uses the stack
; 		To store temporary results:

; 			0. Put a dummy precedence of zero on
; 				The stack.
; 			1. Read lexeme (constant,function,
; 				Variable,formula in parens)
; 				And take the last precedence value
; 				Off the stack.
; 			2. See if the next character is an operator.
; 				If not, check previous one. this may cause
; 				Operator application or an actual
; 				Return from "frmevl".
; 			3. If it is, see what precedence it has
; 				And compare it to the precedence
; 				Of the last operator on the stack.
; 			4. If = or less remember the operator
; 				Pointer of this operator
; 				And branch to "qchnum" to cause
; 				Application of the last operator.
; 				Eventually return to step 2
; 				By returning to just after "doprec".
; 			5. If greater put the last precedence
; 				Back on, save the operator address,
; 				Current temporary result,
; 				And precedence and return to step 1.

; 		Relational operators are all handled through
; 		A common routine. special
; 		Care is taken to detect type mismatches such as 3+"f".

; 	Eval -- the routine to read a lexeme
; 		"Eval" checks for the different types of
; 		Entities it is supposed to detect.
; 		Leading pluses are ignored,
; 		Digits and "." cause "fin" (floating input)
; 		To be called. function names cause the
; 		Formula inside the parentheses to be evaluated
; 		And the function routine to be called. variable
; 		Names cause "ptrget" to be called to get a pointer
; 		To the value, and then the value is put into
; 		The fac. an open parenthesis causes "frmevl"
; 		To be called (recursively), and the ")" to
; 		Be checked for. unary operators (not and
; 		Negation)  put their precedence on the stack
; 		And enter formula evaluation at step 1, so
; 		That everything up to an operator greater than
; 		Their precedence or the end of the formula
; 		Will be evaluated.

; 	Dimension and variable searching
; 		Space is allocated for variables as they are
; 		Encountered. thus "dim" statements must be
; 		Executed to have effect. 6 bytes are allocated
; 		For each simple variable, whether it is a string,
; 		Number or user defined function. the first two
; 		Bytes give the name of the variable and the last four
; 		Give its value. [vartab] gives the first location
; 		Where a simple variable name is found and [arytab]
; 		Gives the location to stop searching for simple
; 		Variables. a "for" entry has a text pointer
; 		And a pointer to a variable value so neither
; 		The program or the simple variables can be
; 		Moved while there are active "for" entries on the stack.
; 		User defined function values also contain
; 		Pointers into simple variable space so no user-defined
; 		Function values can be retained if simple variables
; 		Are moved. adding a simple variable is just
; 		Adding six to [arytab] and [strend], block transfering
; 		The array variables up by six and making sure the
; 		New [strend] is not too close to the strings.
; 		This movement of array variables means
; 		That no pointer to an array will stay valid when
; 		New simple variables can be encountered. this is
; 		Why array variables are not allowed for "for"
; 		Loop variables. setting up a new array variable
; 		Merely involves building the descriptor,
; 		Updating [strend], and making sure there is
; 		Still enough room between [strend] and string space.
; 		"Ptrget", the routine which returns a pointer
; 		To a variable value, has two important flags. one is
; 		"Dimflg" which indicates whether "dim" called "ptrget"
; 		Or not. if so, no prior entry for the variable in
; 		Question should be found, and the index indicates
; 		How much space to set aside. simple variables can
; 		Be "dimensioned", but the only effect will be to
; 		Set aside space for the variable if it hasn't been
; 		Encountered yet. the other important flag is "subflg"
; 		Which indicates whether a subscripted variable should be
; 		Allowed in the current context. if [subflg] is non-zero
; 		The open parenthesis for a subscripted variable
; 		Will not be scanned by "ptrget", and "ptrget" will return
; 		With a text pointer pointing to the "(", if
; 		There was one.
; 	Strings
; 		In the variable tables strings are stored just like
; 		Numeric variables. simple strings have three value
; 		Bytes which are initialized to all zeros (which
; 		Represents the null string). the only difference
; 		In handling is that when "ptrget" sees a "$" after the
; 		Name of a variable, "ptrget" sets [valtyp]
; 		To negative one and turns
; 		On the msb (most-signifigant-bit) of the value of
; 		The first character of the variable name.
; 		Having this bit on in the name of the variable ensures
; 		That the search routine will not match
; 		'A' with 'a$' or 'a$' with 'a'. the meaning of
; 		The three value bytes are:
; 			Low
; 				Length of the string
; 				Low 8 bits
; 				High 8 bits  of the address
; 					Of the characters in the
; 					String if length.ne.0.
; 					Meaningless otherwise.
; 			High
; 		The value of a string variable (these 3 bytes)
; 		Is called the string descriptor to distinguish
; 		It from the actual string data. whenever a
; 		String constant is encountered in a formula or as
; 		Part of an input string, or as part of data, "strlit"
; 		Is called, causing a descriptor to be built for
; 		The string. when assignment is made to a string pointing into
; 		"Buf" the value is copied into string space since [buf]
; 		Is always changing.

; 		String functions and the one string operator "+"
; 		Always return their values in string space.
; 		Assigning a string a constant value in a program
; 		Through a "read" or assignment statement
; 		Will not use any string space since
; 		The string descriptor  will point into the
; 		Program itself. in general, copying is done
; 		When a string value is in "buf", or it is in string
; 		Space and there is an active pointer to it.
; 		Thus f$=g$ will cause copying if g$ has its
; 		String data in string space. f$=chr$(7)
; 		Will use one byte of string space to store the
; 		New one character string created by "chr$", but
; 		The assignment itself will cause no copying since
; 		The only pointer at the new string is a
; 		Temporary descriptor created by "frmevl" which will
; 		Go away as soon as the assignment is done.
; 		It is the nature of garbage collection that
; 		Disallows having two string descriptors point to the same
; 		Area in string space. string functions and operators
; 		Must proceed as follows:
; 			1) Figure out the length of their result.

; 			2) Call "getspa" to find space for their
; 			Result. the arguments to the function
; 			Or operator may change since garbage collection
; 			May be invoked. the only thing that can
; 			Be saved during the call to "getspa" is a pointer
; 			To the descriptors of the arguments.
; 			3) Construct the result descriptor in "dsctmp".
; 			"Getspa" returns the location of the available
; 			Space.
; 			4) Create the new value by copying parts
; 			Of the arguments or whatever.
; 			5) Free up the arguments by calling "fretmp".
; 			6) Jump to "putnew" to get the descriptor in
; 			"Dsctmp" transferred into a new string temporary.

; 		The reason for string temporaries is that garbage
; 		Collection has to know about all active string descriptors
; 		So it knows what is and isn't in use. string temporaries are
; 		Used to store the descriptors of string expressions.

; 		Instead of having an actual value stored in the
; 		Fac, and having the value of a temporary result
; 		Being saved on the stack, as happens with numeric
; 		Variables, strings have the pointer to a string descriptor
; 		Stored in the fac, and it is this pointer
; 		That gets saved on the stack by formula evaluation.
; 		String functions cannot free their arguments up right
; 		Away since "getspa" may force
; 		Garbage collection and the argument strings
; 		May be over-written since garbage collection
; 		Will not be able to find an active pointer to
; 		Them. function and operator results are built in
; 		"Dsctmp" since string temporaries are allocated
; 		(Putnew) and deallocated (fretmp) in a fifo ordering
; 		(I.e. a stack) so the new temporary cannot
; 		Be set up until the old one(s) are freed. trying
; 		To build a result in a temporary after
; 		Freeing up the argument temporaries could result
; 		In one of the argument temporaries being overwritten
; 		Too soon by the new result.

; 		String space is allocated at the very top
; 		Of memory. "memsiz" points beyond the last location of
; 		String space. strings are stored in high locations
; 		First. whenever string space is allocated (getspa).
; 		[Fretop], which is initialized to [memsiz], is updated
; 		To give the highest location in string space
; 		That is not in use. the result is that
; 		[Fretop] gets smaller and smaller, until some
; 		Allocation would make [fretop] less than or equal to
; 		[Strend]. this means string space has run into the
; 		The arrays and that garbage collection must be called.

; 		Garbage collection:
; 			0. [Minptr]=[strend] [fretop]=[memsiz]
; 			1. [Remmin]=0
; 			2. For each string descriptor
; 			(Temporaries, simple strings, string arrays)
; 			If the string is not null and its pointer is
; 			.Gt.minptr and .lt.fretop,
; 			[Minptr]=this string descriptor's pointer,
; 			[Remmin]=pointer at this string descriptor.
; 			End.
; 			3. If remmin.ne.0 (we found an uncollected string),
; 			Block transfer the string data pointed
; 			To in the string descriptor pointed to by "remmin"
; 			So that the last byte of string data is at
; 			[Fretop]. update [fretop] so that it
; 			Points to the location just below the one
; 			The string data was moved into. update
; 			The pointer in the descriptor so it points
; 			To the new location of the string data.
; 			Go to step 1.

; 		After calling garbage collection "getspa" again checks
; 		To see if [acca] characters are available between
; 		[Strend] and [fretop]; if not, an "out of string"
; 		Error is invoked.

; 	Math package
; 		The math package contains floating input (fin),
; 		Floating output (fout), floating compare (fcomp)
; 		... And all the numeric operators and functions.
; 		The formats, conventions and entry points are all
; 		Described in the math package itself.

; 	Init -- the initialization routine
; 		The amount of memory,
; 		Terminal width, and which functions to be retained
; 		Are ascertained from the user. a zero is put down
; 		At the first location not used by the math-package
; 		And [txttab] is set up to point at the next location.
; 		This determines where program storage will start.
; 		Special checks are made to make sure
; 		All questions in "init" are answered reasonably, since
; 		Once "init" finishes, the locations it uses are
; 		Used for program storage. the last thing "init" does is
; 		Change location zero to be a jump to "ready" instead
; 		Of "init". once this is done there is no way to restart
; 		"Init".
; High locations

        .page
        .subttl PAGE ZERO.
        .if     REALIO != 3
START:
        JMP     INIT                 ;Initialize - setup certain locations
                                     ;And delete functions if not needed
                                     ;And change this to "jmp ready"
                                     ;In case user restarts at loc zero.
RDYJSR:
        JMP     INIT                 ;Changed to "jmp strout" by "init"
                                     ;To handle errors.
ADRAYI:
        .word   AYINT                ;Store here the addr of the
                                     ;Routine to turn the fac into a
                                     ;Two byte signed integer in [y,a]
ADRGAY:
        .word   GIVAYF
        .endif
                                     ;Store here the addr of the
                                     ;Routine to convert [y,a] to a floating
                                     ;Point number in the fac.
        .if     ROMSW != 0
USRPOK:
        JMP     FCERR
        .endif
                                     ;Set up orig by init.

; This is the "volatile" storage area and none of it
; Can be kept in rom. any constants in this area cannot
; Be kept in a rom, but must be loaded in by the
; Program instructions in rom.

; --- General ram ---:
CHARAC:
        .fill   1                    ;A delimiting character.
INTEGR  =       CHARAC               ;A one-byte integer from "qint"*
ENDCHR:
        .fill   1                    ;The other delimiting character.
COUNT:
        .fill   1                    ;A general counter.

; --- Flags ---:
DIMFLG:
        .fill   1                    ;In getting a pointer to a variable
                                     ;It is important to remember whether it
                                     ;Is being done for "dim" or not.
                                     ;Dimflg and valtyp must be
                                     ;Consecutive locations.
KIMY    =       DIMFLG               ;Place to preserve y during out.
VALTYP:
        .fill   1                    ;The type indicator.
                                     ;0=Numeric 1=string.
        .if     INTPRC != 0
INTFLG:
        .fill   1
        .endif
                                     ;Tells if integer.
DORES:
        .fill   1                    ;Whether can or can't crunch res'd words.
                                     ;Turned on when "data"
                                     ;Being scanned by crunch so unquoted
                                     ;Strings won't be crunched.
GARBFL  =       DORES                ;Whether to do garbage collection.
SUBFLG:
        .fill   1                    ;Flag whether sub'd variable allowed.
                                     ;"For" and user-defined function
                                     ;Pointer fetching turn
                                     ;This on before calling "ptrget"
                                     ;So arrays won't be detected.
                                     ;"Stkini" and "ptrget" clear it.
                                     ;Also disallows integers there.
INPFLG:
        .fill   1                    ;Flags whether we are doing "input"
                                     ;Or "read"*
TANSGN:
        .fill   1                    ;Used in determining sign of tangent.
        .if     REALIO != 0
CNTWFL:
        .fill   1
        .endif
                                     ;Suppress output flag.
                                     ;Non-zero means suppress.
                                     ;Reset by "input", ready and errors.
                                     ;Complemented by input of ^o.

        .if     REALIO == 4
        .org    80
        .endif
                                     ;Room for apple page 0 stuff.
; --- Ram dealing with terminal handling ---:
        .if     EXTIO != 0
CHANNL:
        .fill   1
        .endif
                                     ;Holds channel number.
        .if     NULCMD != 0
NULCNT:
        .byte   0
        .endif
                                     ;Number of nulls to print.
        .if     REALIO != 3
TRMPOS:
        .fill   1
        .endif
                                     ;Position of terminal carriage.
LINWID:
        .byte   LINLEN               ;Length of line (width)*
NCMWID:
        .byte   NCMPOS               ;Position beyond which there are
                                     ;No more fields.
LINNUM:
        .byte   0                    ;Location to store line number before buf
                                     ;So that "bltuc" can store it all away at once.
        .byte   44                   ;A comma (preload or from rom)
                                     ;Used by input statement since the
                                     ;Data pointer always starts on a
                                     ;Comma or terminator.
        .if     BUFPAG == 0
BUF:
        .fill   BUFLEN
        .endif
                                     ;Type in stored here.
                                     ;Direct statements execute out of
                                     ;Here. remember "input" smashes buf.
                                     ;Must be on page zero
                                     ;Or assignment of string
                                     ;Values in direct statements won't copy
                                     ;Into string space -- which it must.
                                     ;N.b. two nonzero bytes must precede "buflnm"*

; --- Storage for temporary things ---:
TEMPPT:
        .fill   1                    ;Pointer at first free temp descriptor.
                                     ;Initialized to point to tempst.
LASTPT:
        .fill   2                    ;Pointer to last-used string temporary.
TEMPST:
        .fill   STRSIZ * NUMTMP      ;Storage for numtmp temp descriptors.
INDEX1:
        .fill   2                    ;Indexes.
INDEX   =       INDEX1
INDEX2:
        .fill   2
RESHO:
        .fill   1                    ;Result of multiplier and divider.
        .if     ADDPRC != 0
RESMOH:
        .fill   1
        .endif
                                     ;One more byte.
RESMO:
        .fill   1
RESLO:
        .fill   1
ADDEND  =       RESMO                ;Temporary used by "umult"*
        .byte   0                    ;Overflow for res.

; --- Pointers into dynamic data structures ---;
TXTTAB:
        .fill   2                    ;Pointer to beginning of text.
                                     ;Doesn't change after being
                                     ;Setup by "init"*
VARTAB:
        .fill   2                    ;Pointer to start of simple
                                     ;Variable space.
                                     ;Updated whenever the size of the
                                     ;Program changes, set to [txttab]
                                     ;By "scratch" ("new")*
ARYTAB:
        .fill   2                    ;Pointer to beginning of array
                                     ;Table.
                                     ;Incremented by 6 whenever
                                     ;A new simple variable is found, and
                                     ;Set to [vartab] by "clearc"*
STREND:
        .fill   2                    ;End of storage in use.
                                     ;Increased whenever a new array
                                     ;Or simple variable is encountered.
                                     ;Set to [vartab] by "clearc"*
FRETOP:
        .fill   2                    ;Top of string free space.
FRESPC:
        .fill   2                    ;Pointer to new string.
MEMSIZ:
        .fill   2                    ;Highest location in memory.

; --- Line numbers and textual pointers ---:
CURLIN:
        .fill   2                    ;Current line #*
                                     ;Set to 0,255 for direct statements.
OLDLIN:
        .fill   2                    ;Old line number (setup by ^c,"stop"
                                     ;Or "end" in a program)*
POKER   =       LINNUM               ;Set up location used by poke.
                                     ;Temporary for input and read code
OLDTXT:
        .fill   2                    ;Old text pointer.
                                     ;Points at statement to be exec'd next.
DATLIN:
        .fill   2                    ;Data line # -- remember for errors.
DATPTR:
        .fill   2                    ;Pointer to data. initialized to point
                                     ;At the zero in front of [txttab]
                                     ;By "restore" which is called by "clearc"*
                                     ;Updated by execution of a "read"*
INPPTR:
        .fill   2                    ;This remembers where input is coming from.

; --- Stuff used in evaluations ---:
VARNAM:
        .fill   2                    ;Variable's name is stored here.
VARPNT:
        .fill   2                    ;Pointer to variable in memory.
FDECPT  =       VARPNT               ;Pointer into power of tens of "fout"*
FORPNT:
        .fill   2                    ;A variable's pointer for "for" loops
                                     ;And "let" statements.
LSTPNT  =       FORPNT               ;Pntr to list string.
ANDMSK  =       FORPNT               ;The mask used by wait for anding.
EORMSK  =       FORPNT + 1           ;The mask for eoring in wait.
OPPTR:
        .fill   2                    ;Pointer to current op's entry in "optab"*
VARTXT  =       OPPTR                ;Pointer into list of variables.
OPMASK:
        .fill   1                    ;Mask created by current operator.
DOMASK  =       TANSGN               ;Mask in use by relation operations.
DEFPNT:
        .fill   2                    ;Pointer used in function definition.
GRBPNT  =       DEFPNT               ;Another used in garbage collection.
DSCPNT:
        .fill   2                    ;Pointer to a string descriptor.
        .if     ADDPRC != 0
        .fill   1
        .endif
                                     ;For tempf3.
FOUR6:
        .word   STRSIZ               ;Variable constant used by garb collect.

; --- Et cetera ---:
JMPER:
        JMP     60000
SIZE    =       JMPER + 1
OLDOV   =       JMPER + 2            ;The old overflow.
TEMPF3  =       DEFPNT               ;A third fac temporary (4 bytes)*
TEMPF1:
        .if     ADDPRC != 0
        .byte   0
        .endif
                                     ;For tempf1s extra byte.
HIGHDS:
        .fill   2                    ;Desination of highest element in blt.
HIGHTR:
        .fill   2                    ;Source of highest element to move.
TEMPF2:
        .if     ADDPRC != 0
        .byte   0
        .endif
                                     ;For tempf2s extra byte.
LOWDS:
        .fill   2                    ;Location of last byte transferred into.
LOWTR:
        .fill   2                    ;Last thing to move in blt.
ARYPNT  =       HIGHDS               ;A pointer used in array building.
GRBTOP  =       LOWTR                ;A pointer used in garbage collection.
DECCNT  =       LOWDS                ;Number of places before decimal point.
TENEXP  =       LOWDS + 1            ;Has a dpt been input?
DPTFLG  =       LOWTR                ;Base ten exponent.
EXPSGN  =       LOWTR + 1            ;Sign of base ten exponent.

; --- The floating accumulator ---:
FAC:
FACEXP:
        .byte   0
FACHO:
        .byte   0                    ;Most significant byte of mantissa.
        .if     ADDPRC != 0
FACMOH:
        .byte   0
        .endif
                                     ;One more.
FACMO:
        .byte   0                    ;Middle order of mantissa.
FACLO:
        .byte   0                    ;Least sig byte of mantissa.
FACSGN:
        .byte   0                    ;Sign of fac (0 or -1) when unpacked.
SGNFLG:
        .byte   0                    ;Sign of fac is preserved bere by "fin"*
DEGREE  =       SGNFLG               ;A count used by polynomials.
DSCTMP  =       FAC                  ;This is where temp descs are built.
INDICE  =       FACMO                ;Indice is set up here by "qint"*
BITS:
        .byte   0                    ;Something for "shiftr" to use.

; --- The floating argument (unpacked) ---:
ARGEXP:
        .byte   0
ARGHO:
        .byte   0
        .if     ADDPRC != 0
ARGMOH:
        .byte   0
        .endif
ARGMO:
        .byte   0
ARGLO:
        .byte   0
ARGSGN:
        .byte   0

ARISGN:
        .byte   0                    ;A sign reflecting the result.
FACOV:
        .byte   0                    ;Overflow byte of the fac.
STRNG1  =       ARISGN               ;Pointer to a string or descriptor.

FBUFPT:
        .fill   2                    ;Pointer into fbuffr used by fout.
BUFPTR  =       FBUFPT               ;Pointer to buf used by "crunch"*
STRNG2  =       FBUFPT               ;Pointer to string or desc.
POLYPT  =       FBUFPT               ;Pointer into polynomial coefficients.
CURTOL  =       FBUFPT               ;Absolute linear index is formed here.
        .page
        .subttl RAM CODE.
; This code gets changed throughout execution.
; It is made to be fast this way.
; Also, [x] and [y] are not disturbed

; "Chrget" using [txtptr] as the current text pntr
; Fetches a new character into acca after incrementing [txtptr]
; And sets condition codes according to what's in acca.
;	Not c=	numeric	  ("0" thru "9")
;	Z=	":" or end-of-line (a null)

; [Acca] = new char.
; [Txtptr]=[txtptr]+1

; The following exists in rom if rom exists and is loaded
; Down here by init. otherwise it is just loaded into this
; Ram like all the rest of ram is loaded.

CHRGET:
        INC     CHRGET + 7           ;Increment the whole txtptr.
        BNE     CHRGOT
        INC     CHRGET + 8
CHRGOT:
        LDA     60000                ;A load with an ext addr.
TXTPTR  =       CHRGOT + 1
        CMP     #" "                 ;Skip spaces.
        BEQ     CHRGET
QNUM:
        CMP     #":"                 ;Is it a ":"?
        BCS     CHRRTS               ;It is .ge. ":"
        SEC
        SBC     #"0"                 ;All chars .gt. "9" have ret'd so
        SEC
        SBC     #256 - "0"           ;See if numeric.
                                     ;Turn carry on if numeric.
                                     ;Also, setz if null.
CHRRTS:
        RTS                          ;Return to caller.

RNDX:
        .byte   128                  ;Loaded or from rom.
        .byte   79                   ;The initial random number.
        .byte   199
        .byte   82
        .if     ADDPRC != 0
        .byte   89
        .endif
                                     ;One more byte.

        .org    255                  ;Page 1 stuff coming up.
LOFBUF:
        .fill   1                    ;The low fac buffer. copyable.
;---  Page zero/one boundary ---*
                                     ;Must have 13 contiguous bytes.
FBUFFR:
        .fill   3 * ADDPRC + 13      ;Buffer for "fout"*
                                     ;On page 1 so that string is not copied.

;Stack is located here. ie from the end of fbuffr to stkend.
        .page
        .subttl DISPATCH TABLES, RESERVED WORDS, AND ERROR TEXTS.

        .org    ROMLOC

STMDSP:
        .word   END - 1
        .word   FOR - 1
        .word   NEXT - 1
        .word   DATA - 1
        .if     EXTIO != 0
        .word   INPUTN - 1
        .endif
        .word   INPUT - 1
        .word   DIM - 1
        .word   READ - 1
        .word   LET - 1
        .word   GOTO - 1
        .word   RUN - 1
        .word   IF - 1
        .word   RESTOR - 1
        .word   GOSUB - 1
        .word   RETURN - 1
        .word   REM - 1
        .word   STOP - 1
        .word   ONGOTO - 1
        .if     NULCMD != 0
        .word   NULL - 1
        .endif
        .word   FNWAIT - 1
        .if     DISKO != 0
        .if     REALIO == 3
        .word   CQLOAD - 1
        .word   CQSAVE - 1
        .word   CQVERF - 1
        .endif
        .if     REALIO != 0
        .if     REALIO != 2
        .if     REALIO != 3
        .if     REALIO != 5
        .word   LOAD - 1
        .word   SAVE - 1
        .endif
        .endif
        .endif
        .endif
        .if     REALIO != 1
        .if     REALIO != 3
        .if     REALIO != 4
        .word   511                  ;Address of load
        .word   511
        .endif
        .endif
        .endif
        .endif
                                     ;Address of save
        .word   DEF - 1
        .word   POKE - 1
        .if     EXTIO != 0
        .word   PRINTN - 1
        .endif
        .word   PRINT - 1
        .word   CONT - 1
        .if     REALIO == 0
        .word   DDT - 1
        .endif
        .word   LIST - 1
        .word   CLEAR - 1
        .if     EXTIO != 0
        .word   CMD - 1
        .word   CQSYS - 1
        .word   CQOPEN - 1
        .word   CQCLOS - 1
        .endif
        .if     GETCMD != 0
        .word   GET - 1
        .endif
                                     ;Fill w/ get addr.
        .word   SCRATH - 1

FUNDSP:
        .word   SGN
        .word   INT
        .word   ABS
        .if     ROMSW == 0
USRLOC:
        .word   FCERR
        .endif
                                     ;Initially no user routine.
        .if     ROMSW != 0
USRLOC:
        .word   USRPOK
        .endif
        .word   FRE
        .word   POS
        .word   SQR
        .word   RND
        .word   LOG
        .word   EXP
        .if     KIMROM != 0
        .repeat 4
        .word   FCERR
        .endrepeat
        .endif
        .if     KIMROM == 0
COSFIX:
        .word   COS
SINFIX:
        .word   SIN
TANFIX:
        .word   TAN
ATNFIX:
        .word   ATN
        .endif
        .word   PEEK
        .word   LEN
        .word   STR
        .word   VAL
        .word   ASC
        .word   CHR
        .word   LEFT
        .word   RIGHT
        .word   MID
OPTAB:
        .byte   121
        .word   FADDT - 1
        .byte   121
        .word   FSUBT - 1
        .byte   123
        .word   FMULTT - 1
        .byte   123
        .word   FDIVT - 1
        .byte   127
        .word   FPWRT - 1
        .byte   80
        .word   ANDOP - 1
        .byte   70
        .word   OROP - 1
NEGTAB:
        .byte   125
        .word   NEGOP - 1
NOTTAB:
        .byte   90
        .word   NOTOP - 1
PTDORL:
        .byte   100                  ;Precedence.
        .word   DOREL - 1            ;Operator address.

; Tokens for reserved words always have the most
; Significant bit on.
; The list of reserved words:

Q       =       128 - 1
        .macro  DCI, A1
Q       =       Q + 1
        .textc  \A1
        .endmacro
RESLST:
        DCI     "END"
ENDTK   =       Q
        DCI     "FOR"
FORTK   =       Q
        DCI     "NEXT"
        DCI     "DATA"
DATATK  =       Q
        .if     EXTIO != 0
        DCI     "INPUT#"
        .endif
        DCI     "INPUT"
        DCI     "DIM"
        DCI     "READ"
        DCI     "LET"
        DCI     "GOTO"
GOTOTK  =       Q
        DCI     "RUN"
        DCI     "IF"
        DCI     "RESTORE"
        DCI     "GOSUB"
GOSUTK  =       Q
        DCI     "RETURN"
        DCI     "REM"
REMTK   =       Q
        DCI     "STOP"
        DCI     "ON"
        .if     NULCMD != 0
        DCI     "NULL"
        .endif
        DCI     "WAIT"
        .if     DISKO != 0
        DCI     "LOAD"
        DCI     "SAVE"
        .if     REALIO == 3
        DCI     "VERIFY"
        .endif
        .endif
        DCI     "DEF"
        DCI     "POKE"
        .if     EXTIO != 0
        DCI     "PRINT#"
        .endif
        DCI     "PRINT"
PRINTK  =       Q
        DCI     "CONT"
        .if     REALIO == 0
        DCI     "DDT"
        .endif
        DCI     "LIST"
        .if     REALIO != 3
        DCI     "CLEAR"
        .endif
        .if     REALIO == 3
        DCI     "CLR"
        .endif
        .if     EXTIO != 0
        DCI     "CMD"
        DCI     "SYS"
        DCI     "OPEN"
        DCI     "CLOSE"
        .endif
        .if     GETCMD != 0
        DCI     "GET"
        .endif
        DCI     "NEW"
SCRATK  =       Q
; End of command list.
        .byte   84
        .byte   65
        .byte   66
        .byte   "(" + 128
Q       =       Q + 1
TABTK   =       Q
        DCI     "TO"
TOTK    =       Q
        DCI     "FN"
FNTK    =       Q
        .byte   83
        .byte   80
        .byte   67
        .byte   "(" + 128            ;Macro doesnt like ('s in arguments.
Q       =       Q + 1
SPCTK   =       Q
        DCI     "THEN"
THENTK  =       Q
        DCI     "NOT"
NOTTK   =       Q
        DCI     "STEP"
STEPTK  =       Q
        DCI     "+"
PLUSTK  =       Q
        DCI     "-"
MINUTK  =       Q
        DCI     "*"
        DCI     "/"
        DCI     "^"
        DCI     "AND"
        DCI     "OR"
        .byte   190                  ;A greater than sign
Q       =       Q + 1
GREATK  =       Q
        DCI     "="
EQULTK  =       Q
        .byte   188
Q       =       Q + 1                ;A less than sign
LESSTK  =       Q

; Note danger of one reserved word being a part
; Of another:
; Ie * * if 2 greater than f or t=5 then...
; Will not work!!! since "for" will be crunched!!
; In any case make sure the smaller word appears
; Second in the reserved word table ("inp" and "input")
; Another example: if t or q then ... "to" is crunched

        DCI     "SGN"
ONEFUN  =       Q
        DCI     "INT"
        DCI     "ABS"
        DCI     "USR"
        DCI     "FRE"
        DCI     "POS"
        DCI     "SQR"
        DCI     "RND"
        DCI     "LOG"
        DCI     "EXP"
        DCI     "COS"
        DCI     "SIN"
        DCI     "TAN"
        DCI     "ATN"
        DCI     "PEEK"
        DCI     "LEN"
        DCI     "STR$"
        DCI     "VAL"
        DCI     "ASC"
        DCI     "CHR$"
LASNUM  =       Q                    ;Number of last function
                                     ;That takes one arg
        DCI     "LEFT$"
        DCI     "RIGHT$"
        DCI     "MID$"
        DCI     "GO"
GOTK    =       Q
        .byte   0                    ;Marks end of reserved word list

        .if     LNGERR == 0
Q       =       0 - 2
        .macro  DCE, X1
Q       =       Q + 2
        .textc  \X1
        .endmacro
ERRTAB:
        DCE     "NF"
ERRNF   =       Q                    ;Next without for.
        DCE     "SN"
ERRSN   =       Q                    ;Syntax
        DCE     "RG"
ERRRG   =       Q                    ;Return without gosub.
        DCE     "OD"
ERROD   =       Q                    ;Out of data.
        DCE     "FC"
ERRFC   =       Q                    ;Illegal quantity.
        DCE     "OV"
ERROV   =       Q                    ;Overflow.
        DCE     "OM"
ERROM   =       Q                    ;Out of memory.
        DCE     "US"
ERRUS   =       Q                    ;Undefined statement.
        DCE     "BS"
ERRBS   =       Q                    ;Bad subscript.
        DCE     "DD"
ERRDD   =       Q                    ;Redimensioned array.
        DCE     "/0"
ERRDV0  =       Q                    ;Division by zero.
        DCE     "ID"
ERRID   =       Q                    ;Illegal direct.
        DCE     "TM"
ERRTM   =       Q                    ;Type mismatch.
        DCE     "LS"
ERRLS   =       Q                    ;String too long.
        .if     EXTIO != 0
        DCE     "FD"                 ;File data.
ERRBD   =       Q
        .endif
        DCE     "ST"
ERRST   =       Q                    ;String formula too complex.
        DCE     "CN"
ERRCN   =       Q                    ;Can't continue.
        DCE     "UF"
ERRUF   =       Q
        .endif
                                     ;Undefined function.

        .if     LNGERR != 0
Q       =       0
; Note: this error count technique will not work if there are more
; Than 256 characters of error messages
ERRTAB:
        .textc  "NEXT WITHOUT FOR"
ERRNF   =       Q
Q       =       Q + 16
        .textc  "SYNTAX"
ERRSN   =       Q
Q       =       Q + 6
        .textc  "RETURN WITHOUT GOSUB"
ERRRG   =       Q
Q       =       Q + 20
        .textc  "OUT OF DATA"
ERROD   =       Q
Q       =       Q + 11
        .textc  "ILLEGAL QUANTITY"
ERRFC   =       Q
Q       =       Q + 16
        .textc  "OVERFLOW"
ERROV   =       Q
Q       =       Q + 8
        .textc  "OUT OF MEMORY"
ERROM   =       Q
Q       =       Q + 13
        .textc  "UNDEF'D STATEMENT"
ERRUS   =       Q
Q       =       Q + 17
        .textc  "BAD SUBSCRIPT"
ERRBS   =       Q
Q       =       Q + 13
        .textc  "REDIM'D ARRAY"
ERRDD   =       Q
Q       =       Q + 13
        .textc  "DIVISION BY ZERO"
ERRDV0  =       Q
Q       =       Q + 16
        .textc  "ILLEGAL DIRECT"
ERRID   =       Q
Q       =       Q + 14
        .textc  "TYPE MISMATCH"
ERRTM   =       Q
Q       =       Q + 13
        .textc  "STRING TOO LONG"
ERRLS   =       Q
Q       =       Q + 15
        .if     EXTIO != 0
        .textc  "FILE DATA"
ERRBD   =       Q
Q       =       Q + 9
        .endif
        .textc  "FORMULA TOO COMPLEX"
ERRST   =       Q
Q       =       Q + 19
        .textc  "CAN'T CONTINUE"
ERRCN   =       Q
Q       =       Q + 14
        .textc  "UNDEF'D FUNCTION"
ERRUF   =       Q
        .endif

; Needed for messages in all versions.

ERR:
        .text   " ERROR"
        .byte   0
INTXT:
        .text   " IN "
        .byte   0
REDDY:
        ACRLF
        .if     REALIO == 3
        .text   "READY."
        .endif
        .if     REALIO != 3
        .text   "OK"
        .endif
        ACRLF
        .byte   0
BRKTXT:
        ACRLF
        .text   "BREAK"
        .byte   0
        .page
        .subttl GENERAL STORAGE MANAGEMENT ROUTINES.

; Find a "for" entry on the stack via "varpnt"*

FORSIZ  =       2 * ADDPRC + 16
FNDFOR:
        TSX                          ;Load xreg with stk pntr.
        .repeat 4
        INX
        .endrepeat
                                     ;IGNORE .word NEWSTT AND RTS ADDR.
FFLOOP:
        LDA     257,X                ;Get stack entry.
        CMP     #FORTK               ;Is it a "for" token?
        BNE     FFRTS                ;No, no "for" loops with this pntr.
        LDA     FORPNT + 1           ;Get high.
        BNE     CMPFOR
        LDA     258,X                ;Pntr is zero, so assume this one.
        STA     FORPNT
        LDA     259,X
        STA     FORPNT + 1
CMPFOR:
        CMP     259,X
        BNE     ADDFRS               ;Not this one.
        LDA     FORPNT               ;Get down.
        CMP     258,X
        BEQ     FFRTS                ;We got it! we got it!
ADDFRS:
        TXA
        CLC                          ;Add 16 to x.
        ADC     #FORSIZ
        TAX                          ;Result back into x.
        BNE     FFLOOP
FFRTS:
        RTS                          ;Return to caller.

; THIS IS THE .fill TRANSFER ROUTINE.
; It makes space by shoving everything forward.

; On entry:
; [Y,a]=[highds]    (for reason)*
; [Highds]= destination of [high address]*
; [Lowtr]= lowest addr to be transferred.
; [Hightr]= highest addr to be transferred.

; A check is made to ascertain that a reasonable
; Amount of space remains between the bottom
; Of the strings and the highest location transferred into.

; On exit:
; [Lowtr] are unchanged.
; [Hightr]=[lowtr]-200 octal.
; [Highds]=lowest addr transferred into minus 200 octal.

BLTU:
        JSR     REASON               ;Ascertain that string space won't
                                     ;Be overrun.
        STWD    STREND
BLTUC:
        SEC                          ;Prepare to subtract.
        LDA     HIGHTR
        SBC     LOWTR                ;Compute number of things to move.
        STA     INDEX                ;Save for later.
        TAY
        LDA     HIGHTR + 1
        SBC     LOWTR + 1
        TAX                          ;Put it in a counter register.
        INX                          ;So that counter algorithm works.
        TYA                          ;See if low part of count is zero.
        BEQ     DECBLT               ;Yes, go start moving blocks.
        LDA     HIGHTR               ;No, must modify base addr.
        SEC
        SBC     INDEX                ;Borrow is off since [hightr].gt.[lowtr]*
        STA     HIGHTR               ;Save modified base addr.
        BCS     BLT1                 ;If no borrow, go shove it.
        DEC     HIGHTR + 1           ;Borrow implies sub 1 from high order.
        SEC
BLT1:
        LDA     HIGHDS               ;Mod base of dest addr.
        SBC     INDEX
        STA     HIGHDS
        BCS     MOREN1               ;No borrow.
        DEC     HIGHDS + 1           ;Decrement high order byte.
        BCC     MOREN1               ;Always skip.
BLTLP:
        LDA     (HIGHTR),Y           ;Fetch byte to move
        STA     (HIGHDS),Y           ;Move it in, move it out.
MOREN1:
        DEY
        BNE     BLTLP
        LDA     (HIGHTR),Y           ;Move last of the block.
        STA     (HIGHDS),Y
DECBLT:
        DEC     HIGHTR + 1
        DEC     HIGHDS + 1           ;Start on new blocks.
        DEX
        BNE     MOREN1
        RTS                          ;Return to caller.

; This routine is used to ascertain that a given
; Number of locs remain available for the stack.
;    The call is:
;	Lda #number of 2-byte entries needed.
;	Jsr	getstk

; This routine must be called by any routine which puts
; An arbitrary amount of stuff on the stack
; I.e., any recursive routine like "frmevl"*
; It is also called by routines such as "gosub" and "for"
; Which make permanent entries on the stack.

; Routines which merely use and free up the guaranteed
; Numlev locations need not call this.

; On exit:
;    [A] and [x] have been modified.

GETSTK:
        ASL     A                    ;Mult [a] by 2. nb, clears c bit.
        ADC     #2 * NUMLEV + 3 * ADDPRC + 13 ;Make sure 2*numlev+13 locs
                                     ;(13 Because of fbuffr)
        BCS     OMERR                ;Will remain in stack.
        STA     INDEX
        TSX                          ;Get stacked.
        CPX     INDEX                ;Compare.
        BCC     OMERR                ;If stack.le.index1, om.
        RTS

; [Y,a] is a certain address. "reason" makes sure
; It is less than [fretop]*

REASON:
        CPY     FRETOP + 1
        BCC     REARTS
        BNE     TRYMOR               ;Go garb collect.
        CMP     FRETOP
        BCC     REARTS
TRYMOR:
        PHA
        LDX     #8 + ADDPRC          ;If tempf2 has zero in between.
        TYA
REASAV:
        PHA
        LDA     HIGHDS - 1,X         ;Save highds on stack.
        DEX
        BPL     REASAV               ;Put 8 of them on stk.
        JSR     GARBA2               ;Go garb collect.
        LDX     #256 - 8 - ADDPRC
REASTO:
        PLA
        STA     HIGHDS + 8 + ADDPRC,X ;Restore after garb collect.
        INX
        BMI     REASTO
        PLA
        TAY
        PLA                          ;Restore a and y.
        CPY     FRETOP + 1           ;Compare highs
        BCC     REARTS
        BNE     OMERR                ;Higher is bad.
        CMP     FRETOP               ;And the lows.
        BCS     OMERR
REARTS:
        RTS

        .page
        .subttl ERROR HANDLER, READY, TERMINAL INPUT, COMPACTIFY, NEW, REINIT.
OMERR:
        LDX     #ERROM
ERROR:
        .if     REALIO != 0
        LSR     CNTWFL
        .endif
                                     ;Force output.
        .if     EXTIO != 0
        LDA     CHANNL               ;Close non-terminal channel.
        BEQ     ERRCRD
        JSR     CQCCHN               ;Close it.
        LDA     #0
        STA     CHANNL
        .endif
ERRCRD:
        JSR     CRDO                 ;Output crlf.
        JSR     OUTQST               ;Print a question mark
        .if     LNGERR == 0
        LDA     ERRTAB,X             ;Get first chr of err msg.
        JSR     OUTDO                ;Output it.
        LDA     ERRTAB + 1,X         ;Get second chr.
        JSR     OUTDO
        .endif
                                     ;Output it.
        .if     LNGERR != 0
GETERR:
        LDA     ERRTAB,X
        PHA
        AND     #127                 ;Get rid of high bit.
        JSR     OUTDO                ;Output it.
        INX
        PLA                          ;Last char of message?
        BPL     GETERR
        .endif
                                     ;No. go get next and output it.
TYPERR:
        JSR     STKINI               ;Reset the stack and flags.
        LDWDI   ERR                  ;Get pntr to " error"*
ERRFIN:
        JSR     STROUT               ;Output it.
        LDY     CURLIN + 1
        INY                          ;Was number 64000?
        BEQ     READY                ;Yes, don't type line number.
        JSR     INPRT
READY:
        .if     REALIO != 0
        LSR     CNTWFL
        .endif
                                     ;Turn output back on if supressed
        LDWDI   REDDY                ;Say "ok"*
        .if     REALIO != 3
        JSR     RDYJSR
        .endif
                                     ;Or go to init if init error.
        .if     REALIO == 3
        JSR     STROUT
        .endif
                                     ;No init errors possible.
MAIN:
        JSR     INLIN                ;Get a line from terminal.
        STXY    TXTPTR
        JSR     CHRGET
        TAX                          ;Set zero flag based on [a]
                                     ;This distinguishes ":" and 0
        BEQ     MAIN                 ;If blank line, get another.
        LDX     #255                 ;Set direct line number.
        STX     CURLIN + 1
        BCC     MAIN1                ;Is a line number. not direct.
        JSR     CRUNCH               ;Compactify.
        JMP     GONE                 ;Execute it.
MAIN1:
        JSR     LINGET               ;Read line number into "linnum"*
        JSR     CRUNCH
        STY     COUNT                ;Retain character count.
        JSR     FNDLIN
        BCC     NODEL                ;No match, so don't delete.
        LDY     #1
        LDA     (LOWTR),Y
        STA     INDEX1 + 1
        LDA     VARTAB
        STA     INDEX1
        LDA     LOWTR + 1            ;Set transfer to.
        STA     INDEX2 + 1
        LDA     LOWTR
        DEY
        SBC     (LOWTR),Y            ;Compute negative length.
        CLC
        ADC     VARTAB               ;Compute new vartab.
        STA     VARTAB
        STA     INDEX2               ;Set low of trans to.
        LDA     VARTAB + 1
        ADC     #255
        STA     VARTAB + 1           ;Compute high of vartab.
        SBC     LOWTR + 1            ;Compute number of blocks to move.
        TAX
        SEC
        LDA     LOWTR
        SBC     VARTAB               ;Compute offset.
        TAY
        BCS     QDECT1               ;If vartab.le.lowtr
        INX                          ;Decr due to carry, and
        DEC     INDEX2 + 1           ;Decrement store so carry works.
QDECT1:
        CLC
        ADC     INDEX1
        BCC     MLOOP
        DEC     INDEX1 + 1
        CLC                          ;For later adcq
MLOOP:
        LDA     (INDEX1),Y
        STA     (INDEX2),Y
        INY
        BNE     MLOOP                ;.fill DONE?
        INC     INDEX1 + 1
        INC     INDEX2 + 1
        DEX
        BNE     MLOOP                ;Do another block. always.
NODEL:
        JSR     RUNC                 ;Reset all variable info so garbage
                                     ;Collection caused by reason will work
        JSR     LNKPRG               ;Fix up the links
        LDA     BUF                  ;See if anythng there
        BEQ     MAIN
        CLC
        LDA     VARTAB
        STA     HIGHTR               ;Setup hightr.
        ADC     COUNT                ;Add length of line to insert.
        STA     HIGHDS               ;This gives dest addr.
        LDY     VARTAB + 1
        STY     HIGHTR + 1           ;Same for high orders.
        BCC     NODELC
        INY
NODELC:
        STY     HIGHDS + 1
        JSR     BLTU
        .if     BUFPAG != 0
        LDWD    LINNUM               ;Position the binary line number
        STWD    BUF - 2
        .endif
                                     ;In front of buf
        LDWD    STREND
        STWD    VARTAB
        LDY     COUNT
        DEY
STOLOP:
        LDA     BUF - 4,Y
        STA     (LOWTR),Y
        DEY
        BPL     STOLOP
FINI:
        JSR     RUNC                 ;Do clear & set up stack.
                                     ;And set [txtptr] to [txttab]-1.
        JSR     LNKPRG               ;Fix up program links
        JMP     MAIN
LNKPRG:
        LDWD    TXTTAB               ;Set [index] to [txttab]*
        STWD    INDEX
        CLC

; Chead goes through program storage and fixes
; Up all the links. the end of each line is found
; By searching for the zero at the end.
; The double zero link is used to detect the end of the program.

CHEAD:
        LDY     #1
        LDA     (INDEX),Y            ;Arrived at double zeroes?
        BEQ     LNKRTS
        LDY     #4
CZLOOP:
        INY                          ;There is at least one byte.
        LDA     (INDEX),Y
        BNE     CZLOOP               ;No, continue searching.
        INY                          ;Go one beyond.
        TYA
        ADC     INDEX
        TAX
        LDY     #0
        STA     (INDEX),Y
        LDA     INDEX + 1
        ADC     #0
        INY
        STA     (INDEX),Y
        STX     INDEX
        STA     INDEX + 1
        BCCA    CHEAD                ;Always branches.
LNKRTS:
        RTS

; This is the line input routine.
; It reads characters into buf using backarrow (underscore, or
; Shift o) as the delete character and @ as the
; Line delete character. if more than buflen characters
; Are typed, no echoing is done until a backarrow or @ or cr
; Is typed. control-g will be typed for each extra character.
; The routine is entered at inlin.

        .if     REALIO == 4
INLIN:
        LDX     #128                 ;No prompt character
        STX     CQPRMP
        JSR     CQINLN               ;Get a line onto page 2
        CPX     #BUFLEN - 1
        BCS     GDBUFS               ;Not too many characters
        LDX     #BUFLEN - 1
GDBUFS:
        LDA     #0                   ;Put a zero at the end
        STA     BUF,X
        TXA
        BEQ     NOCHR
LOPBHT:
        LDA     BUF - 1,X
        AND     #127
        STA     BUF - 1,X
        DEX
        BNE     LOPBHT
NOCHR:
        LDA     #0
        LDXYI   (BUF - 1)            ;Point at the beginning
        RTS
        .endif
        .if     REALIO != 4
        .if     REALIO != 3
LINLIN:
        .if     REALIO == 2
        JSR     OUTDO
        .endif
                                     ;Echo it.
        DEX                          ;Backarrow so backup pntr and
        BPL     INLINC               ;Get another if count is positive.
INLINN:
        .if     REALIO == 2
        JSR     OUTDO
        .endif
                                     ;Print the @ or a second backarrow
                                     ;If there were too many.
        JSR     CRDO
        .endif
INLIN:
        LDX     #0
INLINC:
        JSR     INCHR                ;Get a character.
        .if     REALIO != 3
        CMP     #7                   ;Is it bob albrecht ringing the bell
                                     ;For school kids?
        BEQ     GOODCH
        .endif
        CMP     #13                  ;Carriage return?
        BEQ     FININ1               ;Yes, finish up.
        .if     REALIO != 3
        CMP     #32                  ;Check for funny characters.
        BCC     INLINC
        CMP     #125                 ;Is it tilda or delete?
        BCS     INLINC               ;Big bad ones too.
        CMP     #"@"                 ;Line delete?
        BEQ     INLINN               ;Yes.
        CMP     #"_"                 ;Character delete?
        BEQ     LINLIN
        .endif
                                     ;Yes.
GOODCH:
        .if     REALIO != 3
        CPX     #BUFLEN - 1          ;Leave room for null.
                                     ;Commo assures us never more than buflen.
        BCS     OUTBEL
        .endif
        STA     BUF,X
        INX
        .if     REALIO == 2
        SKIP2
        .endif
        .if     REALIO != 2
        BNE     INLINC
        .endif
        .if     REALIO != 3
OUTBEL:
        LDA     #7
        .if     REALIO != 0
        JSR     OUTDO
        .endif
                                     ;Echo it.
        BNE     INLINC
        .endif
                                     ;Cycle always.
FININ1:
        JMP     FININL
        .endif
                                     ;Go to fininl far, far away.
INCHR:
        .if     REALIO == 3
        JSR     CQINCH
        .endif
                                     ;For commodore.
        .if     REALIO == 2
INCHRL:
        LDA     0o176000
        .repeat 4
        NOP
        .endrepeat
        LSR     A
        BCC     INCHRL
        LDA     0o176001             ;Get the character.
        .repeat 4
        NOP
        .endrepeat
        AND     #127
        .endif
        .if     REALIO == 1
        JSR     0o17132
        .endif
                                     ;1E5a for mos tech.
        .if     REALIO == 4
        JSR     CQINCH               ;Fd0c for apple computer.
        AND     #127
        .endif
        .if     REALIO == 0
	TJSR	INSIM##
        .endif
                                     ;Get a character from simulator

        .if     REALIO != 0
        .if     EXTIO != 0
        LDY     CHANNL               ;Cnt-o has no effect if not from term.
        BNE     INCRTS
        .endif
        CMP     #CONTW               ;Suppress output character (^w)*
        BNE     INCRTS               ;No, return.
        PHA
        COM     CNTWFL               ;Complement its state.
        PLA
        .endif
INCRTS:
        RTS                          ;End of inchr.

; All "reserved" words are translated into single
; Bytes with the msb on. this saves space and time
; By allowing for table dispatch during execution.
; Therefore all statements appear together in the
; Reserved word list in the same order they
; Appear in stmdsp.

BUFOFS  =       0                    ;The amount to offset the low byte
                                     ;Of the text pointer to get to buf
                                     ;After txtptr has been setup to point into buf
        .if     BUFPAG != 0
BUFOFS  =       BUF / 256 * 256
        .endif
CRUNCH:
        LDX     TXTPTR               ;Set source pointer.
        LDY     #4                   ;Set destination offset.
        STY     DORES                ;Allow crunching.
KLOOP:
        LDA     BUFOFS,X
        .if     REALIO == 3
        BPL     CMPSPC               ;Go look at spaces.
        CMP     #PI                  ;Pi??
        BEQ     STUFFH               ;Go save it.
        INX                          ;Skip no printing.
        BNE     KLOOP
        .endif
                                     ;Always goes.
CMPSPC:
        CMP     #" "                 ;Is it a space to save?
        BEQ     STUFFH               ;Yes, go save it.
        STA     ENDCHR               ;If it's a quote, this will
                                     ;Stop loop when other quote appears.
        CMP     #34                  ;Quote sign?
        BEQ     STRNG                ;Yes, do special string handling.
        BIT     DORES                ;Test flag.
        BVS     STUFFH               ;No crunch, just store.
        CMP     #"?"                 ;A qmark?
        BNE     KLOOP1
        LDA     #PRINTK              ;Yes, stuff a "print" token.
        BNE     STUFFH               ;Always go to stuffh.
KLOOP1:
        CMP     #"0"                 ;Skip numerics.
        BCC     MUSTCR
        CMP     #60                  ;":" And ";" are entered straightaway.
        BCC     STUFFH
MUSTCR:
        STY     BUFPTR               ;Save buffer pointer.
        LDY     #0                   ;Load reslst pointer.
        STY     COUNT                ;Also clear count.
        DEY
        STX     TXTPTR               ;Save text pointer for later use.
        DEX
RESER:
        INY
RESPUL:
        INX
RESCON:
        LDA     BUFOFS,X
        SEC                          ;Prepare to substarct.
        SBC     RESLST,Y             ;Characters equal?
        BEQ     RESER                ;Yes, continue search.
        CMP     #128                 ;No but maybe the end is here.
        BNE     NTHIS                ;No, truly unequal.
        ORA     COUNT
GETBPT:
        LDY     BUFPTR               ;Get buffer pntr.
STUFFH:
        INX
        INY
        STA     BUF - 5,Y
        LDA     BUF - 5,Y
        BEQ     CRDONE               ;Null implies end of line.
        SEC                          ;Prepare to substarct.
        SBC     #":"                 ;Is it a ":"?
        BEQ     COLIS                ;Yes, allow crunching again.
        CMP     #DATATK - ":"        ;Is it a datatk?
        BNE     NODATT               ;No, see if it is rem token.
COLIS:
        STA     DORES                ;Setup flag.
NODATT:
        SEC                          ;Prep to sbcq
        SBC     #REMTK - ":"         ;Rem only stops on null.
        BNE     KLOOP                ;No, continue crunching.
        STA     ENDCHR               ;Rem stops only on null, not : or "*
STR1:
        LDA     BUFOFS,X
        BEQ     STUFFH               ;Yes, end of line, so done.
        CMP     ENDCHR               ;End of gobble?
        BEQ     STUFFH               ;Yes, done with string.
STRNG:
        INY                          ;Increment buffer pointer.
        STA     BUF - 5,Y
        INX
        BNE     STR1                 ;Process next character.
NTHIS:
        LDX     TXTPTR               ;Restore text pointer.
        INC     COUNT                ;Increment res word count.
NTHIS1:
        INY
        LDA     RESLST - 1,Y         ;Get res character.
        BPL     NTHIS1               ;End of entry?
        LDA     RESLST,Y             ;Yes. is it the end?
        BNE     RESCON               ;No, try the next word.
        LDA     BUFOFS,X             ;Yes, end of table. get 1st chr.
        BPL     GETBPT               ;Store it away (always branches)*
CRDONE:
        STA     BUF - 3,Y            ;So that if this is a dir statement
                                     ;Its end will look like end of program.
        .if     (BUF + BUFLEN) / 256 - (BUF - 1) / 256 != 0
        DEC     TXTPTR + 1
        .endif
        LDA     #(BUF & 255) - 1     ;Make txtptr point to
        STA     TXTPTR               ;Crunched line.
LISTRT:
        RTS                          ;Return to caller.

; Fndlin searches the program text for the line
; Whose number is passed in "linnum"*
; There are two possible returns:

;	1) Carry set.
;	   Lowtr points to the link field in the line
;	   Which is the one searched for.

;	2) Carry not set.
;	   Line not found. [lowtr] points to the line in the
;	   Program greater than the one sought after.

FNDLIN:
        LDWX    TXTTAB               ;Load [x,a] with [txttab]
FNDLNC:
        LDY     #1
        STWX    LOWTR                ;Store [x,a] into lowtr
        LDA     (LOWTR),Y            ;See if link is 0
        BEQ     FLINRT
        INY
        INY
        LDA     LINNUM + 1           ;Comp high orders of line numbers.
        CMP     (LOWTR),Y
        BCC     FLNRTS               ;No such line number.
        BEQ     FNDLO1
        DEY
        BNE     AFFRTS               ;Always branch.
FNDLO1:
        LDA     LINNUM
        DEY
        CMP     (LOWTR),Y            ;Compare low orders.
        BCC     FLNRTS               ;No such number.
        BEQ     FLNRTS               ;Go tit.
AFFRTS:
        DEY
        LDA     (LOWTR),Y            ;Fetch link.
        TAX
        DEY
        LDA     (LOWTR),Y
        BCS     FNDLNC               ;Always branches.
FLINRT:
        CLC                          ;C may be high.
FLNRTS:
        RTS                          ;Return to caller.

; The "new" command clears the program text as well
; As variable space.

SCRATH:
        BNE     FLNRTS               ;Make sure there is a terminator.
SCRTCH:
        LDA     #0                   ;Get a clearer.
        TAY                          ;Set up index.
        STA     (TXTTAB),Y           ;Clear	first link.
        INY
        STA     (TXTTAB),Y
        LDA     TXTTAB
        CLC
        ADC     #2
        STA     VARTAB               ;Setup [vartab]*
        LDA     TXTTAB + 1
        ADC     #0
        STA     VARTAB + 1
RUNC:
        JSR     STXTPT
        LDA     #0                   ;Set zero flag

; This code is for the clear command.

CLEAR:
        BNE     STKRTS               ;Syntax error if no terminator.

; Clear initializes the variable and
; Array space by reseting arytab (the end of simple variable space)
; And strend (the end of array storage)* it falls into "stkini"
; Which resets the stack.

CLEARC:
        LDWD    MEMSIZ               ;Free up string space.
        STWD    FRETOP
        .if     EXTIO != 0
        JSR     CQCALL
        .endif
                                     ;Close all open files.
        LDWD    VARTAB               ;Liberate the
        STWD    ARYTAB               ;Variables and
        STWD    STREND               ;Arrays.
FLOAD:
        JSR     RESTOR               ;Restore data.

; Stkini resets the stack pointer eliminating
; Gosub and for context. string temporaries are freed
; Up, subflg is reset. continuing is prohibited.
; And a dummy entry is left at the bottom of the stack so "fndfor" will always
; Find a non-"for" entry at the bottom of the stack.

STKINI:
        LDX     #TEMPST              ;Initialize string temporaries.
        STX     TEMPPT
        PLA                          ;Setup return address.
        TAY
        PLA
        LDX     #STKEND - 257
        TXS
        PHA
        TYA
        PHA
        LDA     #0
        STA     OLDTXT + 1           ;Disallowing continuing
        STA     SUBFLG               ;Allow subscripts.
STKRTS:
        RTS

STXTPT:
        CLC
        LDA     TXTTAB
        ADC     #255
        STA     TXTPTR
        LDA     TXTTAB + 1
        ADC     #255
        STA     TXTPTR + 1           ;Setup text pointer.
        RTS
        .page
        .subttl THE "LIST" COMMAND.

LIST:
        BCC     GOLST                ;It is a digit.
        BEQ     GOLST                ;It is a terminator.
        CMP     #MINUTK              ;Dash preceding?
        BNE     STKRTS               ;No, so syntax error.
GOLST:
        JSR     LINGET               ;Get line number into numlin.
        JSR     FNDLIN               ;Find line .ge. [numlin]*
        JSR     CHRGOT               ;Get last character.
        BEQ     LSTEND               ;If end of line, # is the end.
        CMP     #MINUTK              ;Dash?
        BNE     FLNRTS               ;If not, syntax error.
        JSR     CHRGET               ;Get next char.
        JSR     LINGET               ;Get end #*
        BNE     FLNRTS               ;If not terminator, error.
LSTEND:
        PLA
        PLA                          ;Get rid of "newstt" rts addr.
        LDA     LINNUM               ;See if it was existent.
        ORA     LINNUM + 1
        BNE     LIST4                ;It was typed.
        LDA     #255
        STA     LINNUM
        STA     LINNUM + 1           ;Make it huge.
LIST4:
        LDY     #1
        .if     REALIO == 3
        STY     DORES
        .endif
        LDA     (LOWTR),Y            ;Is link zero?
        BEQ     GRODY                ;Yes, go to ready.
        .if     REALIO != 0
        JSR     ISCNTC
        .endif
                                     ;Listen for cont-c.
        JSR     CRDO                 ;Print crlf to start with.
        INY
        LDA     (LOWTR),Y
        TAX
        INY
        LDA     (LOWTR),Y            ;Get line number.
        CMP     LINNUM + 1           ;See if beyond last.
        BNE     TSTDUN               ;Go determine relation.
        CPX     LINNUM               ;Was equal so test low order.
        BEQ     TYPLIN               ;Equal, so list it.
TSTDUN:
        BCS     GRODY                ;If line is gr than last, then dune.
TYPLIN:
        STY     LSTPNT
        JSR     LINPRT               ;Print as int without leading space.
        LDA     #" "                 ;Always print space after number.
PRIT4:
        LDY     LSTPNT               ;Get pointer to line back.
        AND     #127
PLOOP:
        JSR     OUTDO                ;Print char.
        .if     REALIO == 3
        CMP     #34
        BNE     PLOOP1
        COM     DORES
        .endif
                                     ;If quote, complement flag.
PLOOP1:
        INY
        BEQ     GRODY                ;If we have printed 256 characters
                                     ;The program must be misformated in
                                     ;Memory due to a bad load or bad
                                     ;Hardware. let the guy recover
        LDA     (LOWTR),Y            ;Get next char. is it zero?
        BNE     QPLOP                ;Yes. end of line.
        TAY
        LDA     (LOWTR),Y
        TAX
        INY
        LDA     (LOWTR),Y
        STX     LOWTR
        STA     LOWTR + 1
        BNE     LIST4                ;Branch if something to list.
GRODY:
        JMP     READY
                                     ;Is it a token?
QPLOP:
        BPL     PLOOP                ;No, head for printer.
        .if     REALIO == 3
        CMP     #PI
        BEQ     PLOOP
        BIT     DORES                ;Inside quote marks?
        BMI     PLOOP
        .endif
                                     ;Yes, just type the character.
        SEC
        SBC     #127                 ;Get rid of sign bit and add 1.
        TAX                          ;Make it a counter.
        STY     LSTPNT               ;Save pointer to line.
        LDY     #255                 ;Look at res'd word list.
RESRCH:
        DEX                          ;Is this the res'd word?
        BEQ     PRIT3                ;Yes, go toss it up..
RESCR1:
        INY
        LDA     RESLST,Y             ;End of entry?
        BPL     RESCR1               ;No, continue passing.
        BMI     RESRCH
PRIT3:
        INY
        LDA     RESLST,Y
        BMI     PRIT4                ;End of reserved word.
        JSR     OUTDO                ;Print it.
        BNE     PRIT3                ;End of entry? no, type rest.
        .page
        .subttl THE "FOR" STATEMENT.

; A "for" entry on the stack has the following format:

; Low address
;	Token (fortk) 1 byte
;	A pointer to the loop variable 2 bytes
;	The step 4+addprc bytes
;	A byte reflecting the sign of the increment 1 byte
;	The upper value 4+addprc bytes
;	The line number of the "for" statement 2 bytes
;	A text pointer into the "for" statement 2 bytes
; High address

; Total 16+2*addprc bytes.

FOR:
        LDA     #128                 ;Don't recognize
        STA     SUBFLG               ;Subscripted variables.
        JSR     LET                  ;Read the variable and assign it
                                     ;The correct initial value and store
                                     ;A pointer to the variable in varpnt.
        JSR     FNDFOR               ;Pntr is in varpnt, and forpnt.
        BNE     NOTOL                ;If no match, don't eliminate anything.
        TXA                          ;Make it arithmetical.
        ADC     #FORSIZ - 3          ;Eliminate almost all.
        TAX                          ;Note c=1, then pla, pla.
        TXS                          ;Manifest.
NOTOL:
        PLA                          ;Get rid of newstt return address
        PLA                          ;In case this is a totally new entry.
        LDA     #8 + ADDPRC
        JSR     GETSTK               ;Make sure 16 bytes are available.
        JSR     DATAN                ;Get a count in [y] of the number of
                                     ;Chacracters left in the "for" statement
                                     ;[Txtptr] is unaffected.
        CLC                          ;Prep to add.
        TYA                          ;Save it for pushing.
        ADC     TXTPTR
        PHA
        LDA     TXTPTR + 1
        ADC     #0
        PHA
        PSHWD   CURLIN               ;Put line number on stack.
        SYNCHK  TOTK                 ;"To" is necessary.
        JSR     CHKNUM               ;Value must be a number.
        JSR     FRMNUM               ;Get upper value into fac.
        LDA     FACSGN               ;Pack fac.
        ORA     #127
        AND     FACHO
        STA     FACHO                ;Set packed sign bit.
        LDWDI   LDFONE
        STWD    INDEX1
        JMP     FORPSH               ;Put fac onto stack, packed.
LDFONE:
        LDWDI   FONE                 ;Put 1.0 into fac.
        JSR     MOVFM
        JSR     CHRGOT
        CMP     #STEPTK              ;A step is given?
        BNE     ONEON                ;No. assume 1.0.
        JSR     CHRGET               ;Yes. advance pointer.
        JSR     FRMNUM               ;Read the step.
ONEON:
        JSR     SIGN                 ;Get sign in acca.
        JSR     PUSHF                ;Push fac onto stack (thru a)*
        PSHWD   FORPNT               ;Put pntr to variable on stack.
NXTCON:
        LDA     #FORTK               ;Put a fortk onto stack.
        PHA
;	Bnea	newstt		;simulate bne to newstt. just fall in.
        .page
        .subttl NEW STATEMENT FETCHER.

; Back here for new statement. character pointed to by txtptr
; Is ":" or end-of-line. the address of this loc is left
; On the stack when a statement is executed so that
; It can merely do a rts when it is done.

NEWSTT:
        .if     REALIO != 0
        JSR     ISCNTC
        .endif
                                     ;Listen for control-c.
        LDWD    TXTPTR               ;Look at current character.
        .if     BUFPAG != 0
        CPY     #BUFPAG
        .endif
                                     ;See if it was direct by check for buf's page number
        BEQ     DIRCON
        STWD    OLDTXT               ;Save in case of restart by input.
        .if     BUFPAG != 0
DIRCON:
        .endif
        LDY     #0
        .if     BUFPAG == 0
DIRCON:
        .endif
        LDA     (TXTPTR),Y
        BNE     MORSTS               ;Not null -- check what it is
        LDY     #2                   ;Look at link.
        LDA     (TXTPTR),Y           ;Is link 0?
        CLC                          ;Clear carry for endcon and math that follows
        JEQ     ENDCON               ;Yes - ran off the end.
        INY                          ;Put line number in curlin.
        LDA     (TXTPTR),Y
        STA     CURLIN
        INY
        LDA     (TXTPTR),Y
        STA     CURLIN + 1
        TYA
        ADC     TXTPTR
        STA     TXTPTR
        BCC     GONE
        INC     TXTPTR + 1
GONE:
        JSR     CHRGET               ;Get the statement type.
        JSR     GONE3
        JMP     NEWSTT
GONE3:
        BEQ     ISCRTS               ;If terminator, try again.
                                     ;No need to set up carry since it will
                                     ;Be on if non-numeric and numerics
                                     ;Will cause a syntax error like they should
GONE2:
        SBC     #ENDTK               ;" On ... goto and gosub" come here.
        BCC     GLET
        CMP     #SCRATK - ENDTK + 1
        BCS     SNERRX               ;Some res'd word but not
                                     ;A statement res'd word.
        ASL     A                    ;Multiply by two.
        TAY                          ;Make an index.
        LDA     STMDSP + 1,Y
        PHA
        LDA     STMDSP,Y
        PHA                          ;Put disp addr onto stack.
        JMP     CHRGET
GLET:
        JMP     LET                  ;Must be a let
MORSTS:
        CMP     #":"
        BEQ     GONE                 ;If a ":" continue statement
SNERR1:
        JMP     SNERR                ;Neither 0 or ":" so syntax error
SNERRX:
        CMP     #GOTK - ENDTK
        BNE     SNERR1
        JSR     CHRGET               ;Read in the character after "go "
        SYNCHK  TOTK
        JMP     GOTO
        .page
        .subttl RESTORE,STOP,END,CONTINUE,NULL,CLEAR.

RESTOR:
        SEC
        LDA     TXTTAB
        SBC     #1
        LDY     TXTTAB + 1
        BCS     RESFIN
        DEY
RESFIN:
        STWD    DATPTR               ;Read finishes come to "resfin"*
ISCRTS:
        RTS

        .if     REALIO == 1
ISCNTC:
        LDA     #1
        BIT     0o13500
        BMI     ISCRTS
        LDX     #8
        LDA     #3
        CMP     #3
        .endif
        .if     REALIO == 2
ISCNTC:
        LDA     0o176000
        .repeat 4
        NOP
        .endrepeat
        LSR     A
        BCC     ISCRTS
        JSR     INCHR                ;Eat char that was typed
        CMP     #3
        .endif
                                     ;Was it a control-c??

        .if     REALIO == 4
ISCNTC:
        LDA     0o140000             ;Check the character
        CMP     #0o203
        BEQ     ISCCAP
        RTS
ISCCAP:
        JSR     INCHR
        CMP     #0o203
        .endif
STOP:
        BCS     STOPC                ;Make [c] nonzero as a flag.
END:
        CLC
STOPC:
        BNE     CONTRT               ;Return if not cont-c or
                                     ;If no terminator for stop or end.
                                     ;[C]=0 so will not print "break"*
        LDWD    TXTPTR
        .if     BUFPAG != 0
        LDX     CURLIN + 1
        INX
        .endif
        BEQ     DIRIS
        STWD    OLDTXT
STPEND:
        LDWD    CURLIN
        STWD    OLDLIN
DIRIS:
        PLA                          ;Pop off newstt addr.
        PLA
ENDCON:
        LDWDI   BRKTXT
        .if     REALIO != 0
        LDX     #0
        STX     CNTWFL
        .endif
        BCC     GORDY                ;Carry clear so don't print "break"*
        JMP     ERRFIN
GORDY:
        JMP     READY                ;Type "ready"*

        .if     REALIO == 0
DDT:
        PLA                          ;Get rid of newstt return.
        PLA
                                     ; Hrrz	14,.jbddt##
	JRST	0(14)
        .endif
CONT:
        BNE     CONTRT               ;Make sure there is a terminator.
        LDX     #ERRCN               ;Continue error.
        LDY     OLDTXT + 1           ;A stored txtptr of zero is setup
                                     ;By stkini and indicates there is
                                     ;Nothing to continue.
        JEQ     ERROR                ;"Stop", "end", typing crlf to
                                     ;"Input" and  ^c setup oldtxt.
        LDA     OLDTXT
        STWD    TXTPTR
        LDWD    OLDLIN
        STWD    CURLIN
CONTRT:
        RTS                          ;Return to caller.

        .if     NULCMD != 0
NULL:
        JSR     GETBYT
        BNE     CONTRT               ;Make sure there is terminator.
        INX
        CPX     #240                 ;Is the number reasonable?
        BCS     FCERR1               ;"Function call" error.
        DEX                          ;Back -1
        STX     NULCNT
        RTS
FCERR1:
        JMP     FCERR
        .endif
        .page
        .subttl LOAD AND SAVE SUBROUTINES.

        .if     REALIO == 1
                                     ;Kim cassette i/o
SAVE:
        TSX                          ;Save stack pointer
        STX     INPFLG
        LDA     #STKEND - 256 - 200
        STA     0o362                ;Setup dummy stack for kim monitor
        LDA     #254                 ;Make id byte equal to ff hex
        STA     0o13771              ;Store into kim id
        LDWD    TXTTAB               ;Start dumping from txttab
        STWD    0o13765              ;Setup sal,sah
        LDWD    VARTAB               ;Stop at vartab
        STWD    0o13767              ;Setup eal,eah
        JMP     0o14000
RETSAV:
        LDX     INPFLG               ;Resore the real stack pointer
        TXS
        LDWDI   TAPMES               ;Say it was done
        JMP     STROUT
GLOAD:
        .text   "LOADED"
        .byte   0
TAPMES:
        .text   "SAVED"
        ACRLF
        .byte   0
PATSAV:
        .fill   20
LOAD:
        LDWD    TXTTAB               ;Start dumping in at txttab
        STWD    0o13765              ;Setup sal,sah
        LDA     #255
        STA     0o13771
        LDWDI   RTLOAD
        STWD    1                    ;Set up return address for load
        JMP     0o14163              ;Go read the data in
RTLOAD:
        LDX     #STKEND - 256        ;Reset the stack
        TXS
        LDWDI   READY
        STWD    1
        LDWDI   GLOAD                ;Tell him it worked
        JSR     STROUT
        LDXY    0o13755              ;Get last location
        TXA                          ;Its one too big
        BNE     DECVRT               ;Decrement [x,y]
        NOP
DECVRT:
        NOP
        STXY    VARTAB               ;Setup new variable location
        JMP     FINI
        .endif
                                     ;Relink the program
        .if     REALIO == 4
SAVE:
        SEC                          ;Calcluate program size in poker
        LDA     VARTAB
        SBC     TXTTAB
        STA     POKER
        LDA     VARTAB + 1
        SBC     TXTTAB + 1
        STA     POKER + 1
        JSR     VARTIO
        JSR     CQCOUT               ;Write program size [poker]
        JSR     PROGIO
        JMP     CQCOUT               ;Write program.

LOAD:
        JSR     VARTIO
        JSR     CQCSIN               ;Read size of program into poker
        CLC
        LDA     TXTTAB               ;Calculate vartab from size and
        ADC     POKER                ;Txttab
        STA     VARTAB
        LDA     TXTTAB + 1
        ADC     POKER + 1
        STA     VARTAB + 1
        JSR     PROGIO
        JSR     CQCSIN               ;Read program.
        LDWDI   TPDONE
        JSR     STROUT
        JMP     FINI

TPDONE:
        .text   "LOADED"
        .byte   0

VARTIO:
        LDWDI   POKER
        STWD    0o74
        LDA     #POKER + 2
        STWD    0o76
        RTS
PROGIO:
        LDWD    TXTTAB
        STWD    0o74
        LDWD    VARTAB
        STWD    0o76
        RTS
        .endif
        .page
        .subttl RUN,GOTO,GOSUB,RETURN.
RUN:
        JEQ     RUNC                 ;If no line # argument.
        JSR     CLEARC               ;Clean up -- reset the stack.
        JMP     RUNC2                ;Must replace rts addr.

; A gosub entry on the stack has the following format:

; Low address:
;	The gosutk one byte
;	The line number of the gosub statement two bytes
;	A pointer into the text of the gosub two bytes

; High address.

; Total five bytes.

GOSUB:
        LDA     #3
        JSR     GETSTK               ;Make sure there is room.
        PSHWD   TXTPTR               ;Push on the text pointer.
        PSHWD   CURLIN               ;Push on the current line number.
        LDA     #GOSUTK
        PHA                          ;Push on a gosub token.
RUNC2:
        JSR     CHRGOT               ;Get character and set codes for linget.
        JSR     GOTO                 ;Use rts scheme to "newstt"*
        JMP     NEWSTT

GOTO:
        JSR     LINGET               ;Pick up the line number in "linnum"*
        JSR     REMN                 ;Skip to end of line.
        LDA     CURLIN + 1
        CMP     LINNUM + 1
        BCS     LUK4IT
        TYA
        SEC
        ADC     TXTPTR
        LDX     TXTPTR + 1
        BCC     LUKALL
        INX
        BCSA    LUKALL               ;Always goes.
LUK4IT:
        LDWX    TXTTAB
LUKALL:
        JSR     FNDLNC               ;[X,a] are all set up.
QFOUND:
        BCC     USERR                ;Goto line is nonexistant.
        LDA     LOWTR
        SBC     #1
        STA     TXTPTR
        LDA     LOWTR + 1
        SBC     #0
        STA     TXTPTR + 1
GORTS:
        RTS                          ;Process the statement.

; "Return" restores the line number and text pntr from the stack
; And eliminates all the "for" entries in front of the "gosub" entry.

RETURN:
        BNE     GORTS                ;No terminator=blow him up.
        LDA     #255
        STA     FORPNT + 1           ;Make sure the variable's pntr
                                     ;Never gets matched.
        JSR     FNDFOR               ;Go past all the "for" entries.
        TXS
        CMP     #GOSUTK              ;Return without gosub?
        BEQ     RETU1
        LDX     #ERRRG
        SKIP2
USERR:
        LDX     #ERRUS               ;No match so "us" error.
        JMP     ERROR                ;Yes.
SNERR2:
        JMP     SNERR
RETU1:
        PLA                          ;Remove gosutk.
        PULWD   CURLIN               ;Get line number "gosub" was from.
        PULWD   TXTPTR               ;Get text pntr from "gosub"*
DATA:
        JSR     DATAN                ;Skip to end of statement
                                     ;Since when "gosub" stuck the text  pntr
                                     ;Onto the stack, the line number arg
                                     ;Hadn't been read yet.
ADDON:
        TYA
        CLC
        ADC     TXTPTR
        STA     TXTPTR
        BCC     REMRTS
        INC     TXTPTR + 1
REMRTS:
        RTS                          ;"Newstt" rts addr is still there.

DATAN:
        LDX     #":"                 ;"Data" terminates on ":" and null.
        SKIP2
REMN:
        LDX     #0                   ;The only terminator is null.
        STX     CHARAC               ;Preserve it.
        LDY     #0                   ;This makes charac=0 after swap.
        STY     ENDCHR
EXCHQT:
        LDA     ENDCHR
        LDX     CHARAC
        STA     CHARAC
        STX     ENDCHR
REMER:
        LDA     (TXTPTR),Y
        BEQ     REMRTS               ;Null always terminates.
        CMP     ENDCHR               ;Is it the other terminator?
        BEQ     REMRTS               ;Yes, it's finished.
        INY                          ;Progress to next character.
        CMP     #34                  ;Is it a quote?
        BNE     REMER                ;No, just continue.
        BEQA    EXCHQT               ;Yes, time to trade.
        .page
        .subttl "IF ... THEN" CODE.
IF:
        JSR     FRMEVL               ;Evaluate a formula.
        JSR     CHRGOT               ;Get current character.
        CMP     #GOTOTK              ;Is terminating character a gototk?
        BEQ     OKGOTO               ;Yes.
        SYNCHK  THENTK               ;No, it must be "then"*
OKGOTO:
        LDA     FACEXP               ;0=False. all others true.
        BNE     DOCOND               ;True !
REM:
        JSR     REMN                 ;Skip rest of statement.
        BEQA    ADDON                ;Will always branch.
DOCOND:
        JSR     CHRGOT               ;Test current character.
        BCS     DOCO                 ;If a number, goto it.
        JMP     GOTO
DOCO:
        JMP     GONE3                ;Interpret new statement.
        .page
        .subttl "ON ... GO TO ..." CODE.
ONGOTO:
        JSR     GETBYT               ;Get value in faclo.
        PHA                          ;Save for later.
        CMP     #GOSUTK              ;An "on ... gosub" perhaps?
        BEQ     ONGLOP               ;Yes.
SNERR3:
        CMP     #GOTOTK              ;Must be "gototk"*
        BNE     SNERR2
ONGLOP:
        DEC     FACLO
        BNE     ONGLP1               ;Skip another line number.
        PLA                          ;Get dispatch character.
        JMP     GONE2
ONGLP1:
        JSR     CHRGET               ;Advance and set codes.
        JSR     LINGET
        CMP     #44                  ;Is it a comma?
        BEQ     ONGLOP
        PLA                          ;Remove stack entry (token)*
ONGRTS:
        RTS                          ;Either end-of-line or syntax error.
        .page
        .subttl LINGET -- READ A LINE NUMBER INTO LINNUM

; "Linget" reads a line number from the current text position.

; Line numbers range from 0 to 64000-1.

; The answer is returned in "linnum"*
; "Txtptr" is updated to point to the terminating charcter
; And [a] = the terminating character with condition
; Codes set up to reflect its value.

LINGET:
        LDX     #0
        STX     LINNUM               ;Initialize line number to zero.
        STX     LINNUM + 1
MORLIN:
        BCS     ONGRTS               ;It is not a digit.
        SBC     #"0" - 1             ;-1 Since c=0.
        STA     CHARAC               ;Save character.
        LDA     LINNUM + 1
        STA     INDEX
        CMP     #25                  ;Line number will be .lt. 64000?
        BCS     SNERR3
        LDA     LINNUM
        ASL     A                    ;Multiply by 10.
        ROL     INDEX
        ASL     A
        ROL     INDEX
        ADC     LINNUM
        STA     LINNUM
        LDA     INDEX
        ADC     LINNUM + 1
        STA     LINNUM + 1
        ASL     LINNUM
        ROL     LINNUM + 1
        LDA     LINNUM
        ADC     CHARAC               ;Add in digit.
        STA     LINNUM
        BCC     NXTLGC
        INC     LINNUM + 1
NXTLGC:
        JSR     CHRGET
        JMP     MORLIN

        .page
        .subttl "LET" CODE.
LET:
        JSR     PTRGET               ;Get pntr to variable into "varpnt"*
        STWD    FORPNT               ;Preserve pointer.
        SYNCHK  EQULTK               ;"=" Is necessary.
        .if     INTPRC != 0
        LDA     INTFLG               ;Save for later.
        PHA
        .endif
        LDA     VALTYP               ;Retain the variable's value type.
        PHA
        JSR     FRMEVL               ;Get value of formula into "fac"*
        PLA
        ROL     A                    ;Carry set for string, off for
                                     ;Numeric.
        JSR     CHKVAL               ;Make sure "valtyp" matches carry.
                                     ;And set zero flag for numeric.
        BNE     COPSTR               ;If numeric, copy it.
COPNUM:
        .if     INTPRC != 0
        PLA                          ;Get number type.
QINTGR:
        BPL     COPFLT               ;Store a flting number.
        JSR     ROUND                ;Round integer.
        JSR     AYINT                ;Make 2-byte number.
        LDY     #0
        LDA     FACMO                ;Get high.
        STA     (FORPNT),Y           ;Store it.
        INY
        LDA     FACLO                ;Get low.
        STA     (FORPNT),Y
        RTS
        .endif
COPFLT:
        JMP     MOVVF                ;Put number @forpnt.

COPSTR:
        .if     INTPRC != 0
        PLA
        .endif
                                     ;If string, no intflg.
INPCOM:
        .if     TIME != 0
        LDY     FORPNT + 1           ;Ti$?
        CPY     #ZERO / 256          ;Only ti$ can be this on assig.
        BNE     GETSPT               ; Was not ti$*
        JSR     FREFAC               ;We wont needit.
        CMP     #6                   ;Length correct?
        BNE     FCERR2
        LDY     #0                   ;Yes. do setup.
        STY     FACEXP               ;Zero fac to start with.
        STY     FACSGN
TIMELP:
        STY     FBUFPT               ;Save posotion.
        JSR     TIMNUM               ;Get a digit.
        JSR     MUL10                ;Whole qty by 10.
        INC     FBUFPT
        LDY     FBUFPT
        JSR     TIMNUM
        JSR     MOVAF
        TAX                          ;If num=0 then no mult.
        BEQ     NOML6                ;If =0, go tit.
        INX                          ;Mult by two.
        TXA
        JSR     FINML6               ;Add in and mult by 2 gives *6.
NOML6:
        LDY     FBUFPT
        INY
        CPY     #6                   ;Done all six?
        BNE     TIMELP
        JSR     MUL10                ;One last time.
        JSR     QINT                 ;Shift it over to the right.
        LDX     #2
        SEI                          ;Disallow interrupts.
TIMEST:
        LDA     FACMOH,X
        STA     CQTIMR,X
        DEX
        BPL     TIMEST               ;Loop 3 times.
        CLI                          ;Turn on ints again.
        RTS
TIMNUM:
        LDA     (INDEX),Y            ;Index set up by frefac.
        JSR     QNUM
        BCC     GOTNUM
FCERR2:
        JMP     FCERR                ;Must be numeric string.
GOTNUM:
        SBC     #"0" - 1             ;C is off.
        JMP     FINLOG
        .endif
                                     ;Add in digit to fac.

GETSPT:
        LDY     #2                   ;Get pntr to descriptor.
        LDA     (FACMO),Y
        CMP     FRETOP + 1           ;See if it points into string space.
        BCC     DNTCPY               ;If [fretop],gt.[2&3,facmo], don't copy.
        BNE     QVARIA               ;It is less.
        DEY
        LDA     (FACMO),Y
        CMP     FRETOP               ;Compare low orders.
        BCC     DNTCPY
QVARIA:
        LDY     FACLO
        CPY     VARTAB + 1           ;If [vartab].gt.[facmo], don't copy.
        BCC     DNTCPY
        BNE     COPY                 ;It is less.
        LDA     FACMO
        CMP     VARTAB               ;Compare low orders.
        BCS     COPY
DNTCPY:
        LDWD    FACMO
        JMP     COPYZC
COPY:
        LDY     #0
        LDA     (FACMO),Y
        JSR     STRINI               ;Get room to copy string into.
        LDWD    DSCPNT               ;Get pointer to old descriptor, so
        STWD    STRNG1               ;Movins can find string.
        JSR     MOVINS               ;Copy it.
        LDWDI   DSCTMP               ;Get pointer to old descriptor.
COPYZC:
        STWD    DSCPNT               ;Remember pointer to descriptor.
        JSR     FRETMS               ;Free up the temporary without
                                     ;Freeing up any string space.
        LDY     #0
        LDA     (DSCPNT),Y
        STA     (FORPNT),Y
        INY                          ;Point to string pntr.
        LDA     (DSCPNT),Y
        STA     (FORPNT),Y
        INY
        LDA     (DSCPNT),Y
        STA     (FORPNT),Y
        RTS
        .page
        .subttl PRINT CODE.
        .if     EXTIO != 0
PRINTN:
        JSR     CMD                  ;Docmd
        JMP     IODONE               ;Release channel.
CMD:
        JSR     GETBYT
        BEQ     SAVEIT
        SYNCHK  44                   ;Comma?
SAVEIT:
        PHP
        JSR     CQOOUT               ;Check and open output channl.
        STX     CHANNL               ;Channl to output on.
        PLP                          ;Get status back.
        JMP     PRINT
        .endif
STRDON:
        JSR     STRPRT
NEWCHR:
        JSR     CHRGOT               ;Reget last character.
PRINT:
        BEQ     CRDO                 ;Terminator so type crlf.
PRINTC:
        BEQ     PRTRTS               ;Here after seeing tab(x) or , or ;
                                     ;In which case a terminator does not
                                     ;Mean type a crlf but just rts.
        CMP     #TABTK               ;Tab function?
        BEQ     TABER                ;Yes.
        CMP     #SPCTK               ;Space function?
        CLC
        BEQ     TABER
        CMP     #44                  ;A comma?
        BEQ     COMPRT               ;Yes.
        CMP     #59                  ;A semicolon?
        BEQ     NOTABR               ;Yes.
        JSR     FRMEVL               ;Evaluate the formula.
        BIT     VALTYP               ;A string?
        BMI     STRDON               ;Yes.
        JSR     FOUT
        JSR     STRLIT               ;Build descriptor.
        .if     REALIO != 3
        LDY     #0                   ;Get the pointer.
        LDA     (FACMO),Y
        CLC
        ADC     TRMPOS               ;Make sure len+pos.lt.width.
        CMP     LINWID               ;Greater than line length?
                                     ;Remember space printed after number.
        BCC     LINCHK               ;Go type.
        JSR     CRDO
        .endif
                                     ;Yes, type crlf first.
LINCHK:
        JSR     STRPRT               ;Print the number.
        JSR     OUTSPC               ;Print a space
        BNEA    NEWCHR               ;Always goes.
        .if     REALIO != 4
        .if     BUFPAG != 0
FININL:
        LDA     #0
        STA     BUF,X
        LDXYI   BUF - 1
        .endif
        .if     BUFPAG == 0
FININL:
        LDY     #0                   ;Put a zero at end of buf.
        STY     BUF,X
        LDX     #BUF - 1
        .endif
                                     ;Setup pointer.
        .if     EXTIO != 0
        LDA     CHANNL               ;No crdo if not terminal.
        BNE     PRTRTS
        .endif
        .endif
CRDO:
        .if     EXTIO == 0
        LDA     #13                  ;Make trmpos less than line length.
        STA     TRMPOS
        .endif
        .if     EXTIO != 0
        .if     REALIO != 3
        LDA     CHANNL
        BNE     GOCR
        STA     TRMPOS
        .endif
GOCR:
        LDA     #13
        .endif
                                     ;X and y must be preserved.
        JSR     OUTDO
        LDA     #10
        JSR     OUTDO
CRFIN:
        .if     EXTIO != 0
        .if     REALIO != 3
        LDA     CHANNL
        BNE     PRTRTS
        .endif
        .endif
        .if     NULCMD == 0
        .if     REALIO != 3
        LDA     #0
        STA     TRMPOS
        .endif
        EOR     #255
        .endif
        .if     NULCMD != 0
        TXA                          ;Preserve [accx]* some need it.
        PHA
        LDX     NULCNT               ;Get number of nulls.
        BEQ     CLRPOS
        LDA     #0
PRTNUL:
        JSR     OUTDO
        DEX                          ;Done with nulls?
        BNE     PRTNUL
CLRPOS:
        STX     TRMPOS
        PLA
        TAX
        .endif
PRTRTS:
        RTS

COMPRT:
        LDA     TRMPOS
NCMPOS  =       (LINLEN / CLMWID - 1) * CLMWID ;Clmwid beyond which there are
        .if     REALIO != 3
                                     ;No more comma fields.
        CMP     NCMWID               ;So all comma does is "crdo"*

        BCC     MORCOM
        JSR     CRDO                 ;Type crlf.
        JMP     NOTABR
        .endif
                                     ;And quit if beyond last field.
MORCOM:
        SEC
MORCO1:
        SBC     #CLMWID              ;Get [a] modulus clmwid.
        BCS     MORCO1
        EOR     #255                 ;Fill print pos out to even clmwid so
        ADC     #1
        BNE     ASPAC                ;Print [a] spaces.

TABER:
        PHP                          ;Remember if spc or tab function.
        JSR     GTBYTC               ;Get value into accx.
        CMP     #41
        BNE     SNERR4
        PLP
        BCC     XSPAC                ;Print [x] spaces.
        TXA
        SBC     TRMPOS
        BCC     NOTABR               ;Negative, don't print any.
ASPAC:
        TAX
XSPAC:
        INX
XSPAC2:
        DEX                          ;Decrement the count.
        BNE     XSPAC1
NOTABR:
        JSR     CHRGET               ;Reget last character.
        JMP     PRINTC               ;Don't call crdo.
XSPAC1:
        JSR     OUTSPC
        BNEA    XSPAC2

; Print the string pointed to by [y,a] which ends with a zero.
; If the string is below dsctmp it will be copied into string space.

STROUT:
        JSR     STRLIT               ;Get a string literal.

; Print the string whose descriptor is pointed to by facmo.

STRPRT:
        JSR     FREFAC               ;Return temp pointer.
        TAX                          ;Put count into counter.
        LDY     #0
        INX                          ;Move one ahead.
STRPR2:
        DEX
        BEQ     PRTRTS               ;All done.
        LDA     (INDEX),Y            ;Pntr to act strng set by frefac.
        JSR     OUTDO
        INY
        CMP     #13
        BNE     STRPR2
        JSR     CRFIN                ;Type rest of carriage return.
        JMP     STRPR2               ;And on and on.

; Outdo outputs the character in acca, using cntwfl
; (Suppress or not), trmpos (print head position)
; Timing, etcq. no registers are changed.

OUTSPC:
        .if     REALIO != 3
        LDA     #" "
        .endif
        .if     REALIO == 3
        LDA     CHANNL
        BEQ     CRTSKP
        LDA     #" "
        SKIP2
CRTSKP:
        LDA     #29
        .endif
                                     ;Commodore's skip character.
        SKIP2
OUTQST:
        LDA     #"?"
OUTDO:
        .if     REALIO != 0
        BIT     CNTWFL               ;Shouldn't affect channel i/o!
        BMI     OUTRTS
        .endif
        .if     REALIO != 3
        PHA
        CMP     #32                  ;Is this a printing char?
        BCC     TRYOUT               ;No, don't include it in trmpos.
        LDA     TRMPOS
        CMP     LINWID               ;Length = terminal width?
        BNE     OUTDO1
        JSR     CRDO                 ;Yes, type crlf
OUTDO1:
        .if     EXTIO != 0
        LDA     CHANNL
        BNE     TRYOUT
        .endif
INCTRM:
        INC     TRMPOS               ;Increment count.
TRYOUT:
        PLA
        .endif
                                     ;Restore the a register

        .if     REALIO == 1
        STY     KIMY
        .endif
                                     ;Preserve y.
        .if     REALIO == 4
        ORA     #0o200
        .endif
                                     ;Turn on b7 for apple.
        .if     REALIO != 0
OUTLOC:
        JSR     OUTCH
        .endif
                                     ;Output the character.
        .if     REALIO == 1
        LDY     KIMY
        .endif
                                     ;Get y back.
        .if     REALIO == 2
        .repeat 4
        NOP
        .endrepeat
        .endif
        .if     REALIO == 4
        AND     #0o177
        .endif
                                     ;Get [a] back from apple.

        .if     REALIO == 0
	TJSR	OUTSIM##
        .endif
                                     ;Call simulator output routine
OUTRTS:
        AND     #255                 ;Set z=0.
GETRTS:
        RTS

        .page
        .subttl INPUT AND READ CODE.

; Here when the data that was typed in or in "data" statements
; Is improperly formatted. for "input" we start again.
; For "read" we give a syntax error at the data line.

TRMNOK:
        LDA     INPFLG
        BEQ     TRMNO1               ;If input try again.
        .if     GETCMD != 0
        BMI     GETDTL
        LDY     #255                 ;Make it look direct.
        BNEA    STCURL               ;Always goes.
GETDTL:
        .endif
        LDWD    DATLIN               ;Get data line number.
STCURL:
        STWD    CURLIN               ;Make it current line.
SNERR4:
        JMP     SNERR
TRMNO1:
        .if     EXTIO != 0
        LDA     CHANNL               ;If not terminal, give bad data.
        BEQ     DOAGIN
        LDX     #ERRBD
        JMP     ERROR
        .endif
DOAGIN:
        LDWDI   TRYAGN
        JSR     STROUT               ;Print "?redo from start"*
        LDWD    OLDTXT               ;Point at start
        STWD    TXTPTR               ;Of this current line.
        RTS                          ;Go to "newstt"*
        .if     GETCMD != 0
GET:
        JSR     ERRDIR               ;Direct is not ok.
        .if     EXTIO != 0
        CMP     #"#"                 ;See if "get#"*
        BNE     GETTTY               ;No, just get tty input.
        JSR     CHRGET               ;Move up to next byte.
        JSR     GETBYT               ;Get channel into x
        SYNCHK  44                   ;Comma?
        JSR     CQOIN                ;Get channel open for input.
        STX     CHANNL
        .endif
GETTTY:
        LDXYI   BUF + 1              ;Point to 0.
        .if     BUFPAG != 0
        LDA     #0                   ;To stuff and to point.
        STA     BUF + 1
        .endif
        .if     BUFPAG == 0
        STY     BUF + 1
        .endif
                                     ;Zero it.
        LDA     #64                  ;Turn on v-bit.
        JSR     INPCO1               ;Do the get.
        .if     EXTIO != 0
        LDX     CHANNL
        BNE     IORELE
        .endif
                                     ;Release.
        RTS
        .endif

        .if     EXTIO != 0
INPUTN:
        JSR     GETBYT               ;Get channel number.
        SYNCHK  44                   ;A comma?
        JSR     CQOIN                ;Go where commodore checks in open.
        STX     CHANNL
        JSR     NOTQTI               ;Do input to variables.
IODONE:
        LDA     CHANNL               ;Release channel.
IORELE:
        JSR     CQCCHN
        LDX     #0                   ;Reset channel to terminal.
        STX     CHANNL
        RTS
        .endif
INPUT:
        .if     REALIO != 0
        LSR     CNTWFL
        .endif
                                     ;Be talkative.
        CMP     #34                  ;A quote?
        BNE     NOTQTI               ;No message.
        JSR     STRTXT               ;Literalize the string in text
        SYNCHK  59                   ;Must end with semicolon.
        JSR     STRPRT               ;Print it out.
NOTQTI:
        JSR     ERRDIR               ;Use common routine since def direct
        LDA     #44                  ;Get comma.
        STA     BUF - 1
                                     ;Is also illegal.
GETAGN:
        JSR     QINLIN               ;Type "?" and input a line of text.
        .if     EXTIO != 0
        LDA     CHANNL
        BEQ     BUFFUL
        LDA     CQSTAT               ;Get status byte.
        AND     #2
        BEQ     BUFFUL               ;A-ok.
        JSR     IODONE               ;Bad. close channel.
        JMP     DATA                 ;Skip rest of input.
BUFFUL:
        .endif
        LDA     BUF                  ;Anything input?
        BNE     INPCON               ;Yes, continue.
        .if     EXTIO != 0
        LDA     CHANNL               ;Blank line means get another.
        BNE     GETAGN
        .endif
                                     ;If not terminal.
        CLC                          ;Make sure dont print break
        JMP     STPEND               ;No, stop.
QINLIN:
        .if     EXTIO != 0
        LDA     CHANNL
        BNE     GINLIN
        .endif
        JSR     OUTQST
        JSR     OUTSPC
GINLIN:
        JMP     INLIN
READ:
        LDXY    DATPTR               ;Get last data location.
        .byte   0o251                ;Lda #tya to make it nonzero.
        .if     BUFPAG == 0
INPCON:
        .endif
        TYA
        .if     BUFPAG != 0
        SKIP2
INPCON:
        LDA     #0
        .endif
                                     ;Set flag that this is input
INPCO1:
        STA     INPFLG               ;Store the flag.

; In the processing of data and read statements:
; One pointer points to the data (ie, the numbers being fetched)
; And another points to the list of variables.

; The pointer into the data always starts pointing to a
; Terminator -- a , : or end-of-line.

; At this point txtptr points to list of variables and
; [Y,x] points to data or input line.

        STXY    INPPTR
INLOOP:
        JSR     PTRGET               ;Read variable list.
        STWD    FORPNT               ;Save pointer for "let" string stuffing.
                                     ;Returns pntr top var in varpnt.
        LDWD    TXTPTR               ;Save text pntr.
        STWD    VARTXT
        LDXY    INPPTR
        STXY    TXTPTR
        JSR     CHRGOT               ;Get it and set z if term.
        BNE     DATBK1
        BIT     INPFLG
        .if     GETCMD != 0
        BVC     QDATA
        JSR     CZGETL               ;Don't want inchr. just one.
        .if     REALIO == 4
        AND     #127
        .endif
        STA     BUF                  ;Make it first character.
        LDXYI   (BUF - 1)            ;Point just before it.
        .if     BUFPAG == 0
        BEQA    DATBK
        .endif
        .if     BUFPAG != 0
        BNEA    DATBK
        .endif
        .endif
                                     ;Go process.
QDATA:
        BMI     DATLOP               ;Search for another data statement.
        .if     EXTIO != 0
        LDA     CHANNL
        BNE     GETNTH
        .endif
        JSR     OUTQST
GETNTH:
        JSR     QINLIN               ;Get another line.
DATBK:
        STXY    TXTPTR               ;Set for "chrget"*
DATBK1:
        JSR     CHRGET
        BIT     VALTYP               ;Get value type.
        BPL     NUMINS               ;Input a number if numeric.
        .if     GETCMD != 0
        BIT     INPFLG               ;Get?
        BVC     SETQUT               ;No, go set quote.
        INX
        STX     TXTPTR
        LDA     #0                   ;Zero terminators.
        STA     CHARAC
        BEQA    RESETC
        .endif
SETQUT:
        STA     CHARAC               ;Assume quoted string.
        CMP     #34                  ;Terminators ok?
        BEQ     NOWGET               ;Yes.
        LDA     #":"                 ;Set terminators to ":" and
        STA     CHARAC
        LDA     #44                  ;Comma.
RESETC:
        CLC
NOWGET:
        STA     ENDCHR
        LDWD    TXTPTR
        ADC     #0                   ;C is set properly above.
        BCC     NOWGE1
        INY
NOWGE1:
        JSR     STRLT2               ;Make a string descriptor for the value
                                     ;And copy if necessary.
        JSR     ST2TXT               ;Set text pointer.
        JSR     INPCOM               ;Do assignment.
        JMP     STRDN2
NUMINS:
        JSR     FIN
        .if     INTPRC == 0
        JSR     MOVVF
        .endif
        .if     INTPRC != 0
        LDA     INTFLG               ;Set codes on flag.
        JSR     QINTGR
        .endif
                                     ;Go decide on float.
STRDN2:
        JSR     CHRGOT               ;Read last character.
        BEQ     TRMOK                ;":" Or eol is ok.
        CMP     #44                  ;A comma?
        JNE     TRMNOK
TRMOK:
        LDWD    TXTPTR
        STWD    INPPTR               ;Save for more reads.
        LDWD    VARTXT
        STWD    TXTPTR               ;Point to variable list.
        JSR     CHRGOT               ;Look at last variable list character.
        BEQ     VAREND               ;That's the end of the list.
        JSR     CHKCOM               ;Not end. check for comma.
        JMP     INLOOP

; Subroutine to find data
; The search is made by using the execution code for data to
; Skip over statements. the start word of each statement
; Is compared with "datatk"* each new line number
; Is stored in "datlin" so that if an error occurs
; While reading data the error message can give the line
; Number of the ill-formatted data.

DATLOP:
        JSR     DATAN                ;Skip some text.
        INY
        TAX                          ;End of line?
        BNE     NOWLIN               ;Sho ain't.
        LDX     #ERROD               ;Yes = "no data" error.
        INY
        LDA     (TXTPTR),Y
        BEQ     ERRGO5
        INY
        LDA     (TXTPTR),Y           ;Get high byte of line number.
        STA     DATLIN
        INY
        LDA     (TXTPTR),Y           ;Get low byte.
        INY
        STA     DATLIN + 1
NOWLIN:
        LDA     (TXTPTR),Y           ;How is it?
        TAX
        JSR     ADDON                ;Add [y] to [txtptr]*
        CPX     #DATATK              ;Is it a "data" statement.
        BNE     DATLOP               ;Not quite right. keep looking.
        JMP     DATBK1               ;This is the one !
VAREND:
        LDWD    INPPTR               ;Put away a new data pntr maybe.
        LDX     INPFLG
        BPL     VARY0
        JMP     RESFIN
VARY0:
        LDY     #0
        LDA     (INPPTR),Y           ;Last data chr could have been
                                     ;Comma or colon but should be null.
        BEQ     INPRTS               ;It is null.
        .if     EXTIO != 0
        LDA     CHANNL               ;If not terminal, no type.
        BNE     INPRTS
        .endif
        LDWDI   EXIGNT
        JMP     STROUT               ;Type "?extra ignored"
INPRTS:
        RTS                          ;Do next statement.
EXIGNT:
        .text   "?EXTRA IGNORED"
        ACRLF
        .byte   0
TRYAGN:
        .text   "?REDO FROM START"
        ACRLF
        .byte   0
        .page
        .subttl THE NEXT CODE IS THE "NEXT CODE"

; A "for" entry on the stack has the following format:

; Low address
;	Token (fortk) 1 byte
;	A pointer to the loop variable 2 bytes
;	The step 4+addprc bytes
;	A byte reflecting the sign of the increment 1 byte
;	The upper value (packed) 4+addprc bytes
;	The line number of the "for" statement 2 bytes
;	A text pointer into the "for" statement 2 bytes
; High address

; Total 16+2*addprc bytes.

NEXT:
        BNE     GETFOR
        LDY     #0                   ;Without arg call "fndfor" with
        BEQA    STXFOR               ;[Forpnt]=0.
GETFOR:
        JSR     PTRGET               ;Get a pointer to loop variable
STXFOR:
        STWD    FORPNT               ;Into "forpnt"*
        JSR     FNDFOR               ;Find the matching entry if any.
        BEQ     HAVFOR
        LDX     #ERRNF               ;"Next without for"*
ERRGO5:
        BEQ     ERRGO4
HAVFOR:
        TXS                          ;Setup stack. chop first.
        TXA
        CLC
        ADC     #4                   ;Point to increment
        PHA                          ;Save this pointer to restore to [a]
        ADC     #5 + ADDPRC          ;Point to upper limit
        STA     INDEX2               ;Save as index
        PLA                          ;Restore pointer to increment
        LDY     #1                   ;Set hi addr of thing to move.
        JSR     MOVFM                ;Get quantity into the fac.
        TSX
        LDA     257 + 7 + ADDPRC,X   ;Set sign correctly.
        STA     FACSGN
        LDWD    FORPNT
        JSR     FADD                 ;Add inc to loop variable.
        JSR     MOVVF                ;Pack the fac into memory.
        LDY     #1
        JSR     FCOMPN               ;Compare fac with upper value.
        TSX
        SEC
        SBC     257 + 7 + ADDPRC,X   ;Subtract sign of inc from sign of
                                     ;Of (current value-final value)*
        BEQ     LOOPDN               ;If sign (final-current)-sign step=0
                                     ;Then loop is done.
        LDA     2 * ADDPRC + 12 + 257,X
        STA     CURLIN               ;Store line number of "for" statement.
        LDA     257 + 13 + 2 * ADDPRC,X
        STA     CURLIN + 1
        LDA     2 * ADDPRC + 15 + 257,X
        STA     TXTPTR               ;Store text pntr into "for" statement.
        LDA     2 * ADDPRC + 14 + 257,X
        STA     TXTPTR + 1
NEWSGO:
        JMP     NEWSTT               ;Process next statement.
LOOPDN:
        TXA
        ADC     #2 * ADDPRC + 15     ;Adds 16 with carry.
        TAX
        TXS                          ;New stack pntr.
        JSR     CHRGOT
        CMP     #44                  ;Comma at end?
        BNE     NEWSGO
        JSR     CHRGET
        JSR     GETFOR               ;Do next but don't allow blank variable
                                     ;Pntr. [varpnt] is the stk pntr which
                                     ;Never matches any pointer.
                                     ;Jsr to put on dummy newstt addr.
        .subttl FORMULA EVALUATION CODE.

; These routines check for certain "valtyp"*
; [C] is not preserved.

FRMNUM:
        JSR     FRMEVL
CHKNUM:
        CLC
        SKIP1
CHKSTR:
        SEC                          ;Set carry.
CHKVAL:
        BIT     VALTYP               ;Will not f up "valtyp"*
        BMI     DOCSTR
        BCS     CHKERR
CHKOK:
        RTS
DOCSTR:
        BCS     CHKOK
CHKERR:
        LDX     #ERRTM
ERRGO4:
        JMP     ERROR

; The formula evaluator starts with
; [Txtptr] pointing to the first character of the formula.
; At the end [txtptr] points to the terminator.
; The result is left in the fac.
; On return [a] does not reflect the terminator.

; The formula evaluator uses the operator list (optab)
; To determine precedence and dispatch addresses for
; Each operator.
; A temporary result on the stack has the following format.
;	The address of the operator routine.
;	The floating point temporary result.
;	The precedence of the operator.

FRMEVL:
        LDX     TXTPTR
        BNE     FRMEV1
        DEC     TXTPTR + 1
FRMEV1:
        DEC     TXTPTR
        LDX     #0                   ;Initial dummy precedence is 0.
        SKIP1
LPOPER:
        PHA                          ;Save low precedence. (mask.)
        TXA
        PHA                          ;Save high precedence.
        LDA     #1
        JSR     GETSTK               ;Make sure there is room for
                                     ;Recursive calls.
        JSR     EVAL                 ;Evaluate something.
        CLR     OPMASK               ;Prepare to build mask maybe.
TSTOP:
        JSR     CHRGOT               ;Reget last character.
LOPREL:
        SEC                          ;Prep to subtract.
        SBC     #GREATK              ;Is current character a relation?
        BCC     ENDREL               ;No. relations all through.
        CMP     #LESSTK - GREATK + 1 ;Really relational?
        BCS     ENDREL               ;No -- just big.
        CMP     #1                   ;Reset carry for zero only.
        ROL     A                    ;0 To 1, 1 to 2, 2 to 4.
        EOR     #1
        EOR     OPMASK               ;Bring in the old bits.
        CMP     OPMASK               ;Make sure the new mask is bigger.
        BCC     SNERR5               ;Syntax error. because two of the same.
        STA     OPMASK               ;Save mask.
        JSR     CHRGET
        JMP     LOPREL               ;Get the next candidate.
ENDREL:
        LDX     OPMASK               ;Were there any?
        BNE     FINREL               ;Yes, handle as special op.
        BCS     QOP                  ;Not an operator.
        ADC     #GREATK - PLUSTK
        BCC     QOP                  ;Not an operator.
        ADC     VALTYP               ;[C]=1.
        JEQ     CAT                  ;Only if [a]=0 and [valtyp]=-1 (a str)*
        ADC     #0o377               ;Get back original [a]*
        STA     INDEX1
        ASL     A                    ;Multiply by 2.
        ADC     INDEX1               ;By three.
        TAY                          ;Set up for later.
QPREC:
        PLA                          ;Get previous precedence.
        CMP     OPTAB,Y              ;Is old precedence greater or equal?
        BCS     QCHNUM               ;Yes, go operate.
        JSR     CHKNUM               ;Can't be string here.
DOPREC:
        PHA                          ;Save old precedence.
NEGPRC:
        JSR     DOPRE1               ;Set a return address for op.
        PLA                          ;Pull off previous precedence.
        LDY     OPPTR                ;Get pointer to op.
        BPL     QPREC1               ;That's a real operator.
        TAX                          ;Done ?
        BEQ     QOPGO                ;Done !
        BNE     PULSTK
FINREL:
        LSR     VALTYP               ;Get value type into "c"*
        TXA
        ROL     A                    ;Put valtyp into low order bit of mask.
        LDX     TXTPTR               ;Decrement text pointer.
        BNE     FINRE2
        DEC     TXTPTR + 1
FINRE2:
        DEC     TXTPTR
        LDY     #PTDORL - OPTAB      ;Make [yreg] point at operator entry.
        STA     OPMASK               ;Save the operation mask.
        BNE     QPREC                ;Save it all. br always.
                                     ;Note b7(valtyp)=0 so chknum call is ok.
QPREC1:
        CMP     OPTAB,Y              ;Last precedence is greater?
        BCS     PULSTK               ;Yes, go operate.
        BCC     DOPREC               ;No save argument and get other operand.
DOPRE1:
        LDA     OPTAB + 2,Y
        PHA                          ;Disp addr goes onto stack.
        LDA     OPTAB + 1,Y
        PHA
        JSR     PUSHF1               ;Save fac on stack unpacked.
        LDA     OPMASK               ;[Acca] may be mask for rel.
        JMP     LPOPER
SNERR5:
        JMP     SNERR                ;Go to an error.
PUSHF1:
        LDA     FACSGN
        LDX     OPTAB,Y              ;Get high precedence.
PUSHF:
        TAY                          ;Get pointer into stack.
        PLA
        STA     INDEX1
        INC     INDEX1
        PLA
        STA     INDEX1 + 1
        TYA
                                     ;Store fac on stack unpacked.
        PHA                          ;Start with sign set up.
FORPSH:
        JSR     ROUND                ;Put rounded fac on stack.
        LDA     FACLO                ;Entry point to skip storing sign.
        PHA
        LDA     FACMO
        PHA
        .if     ADDPRC != 0
        LDA     FACMOH
        PHA
        .endif
        LDA     FACHO
        PHA
        LDA     FACEXP
        PHA
        JMP     (INDEX1)             ;Return.
QOP:
        LDY     #255
        PLA                          ;Get high precedence of last op.
QOPGO:
        BEQ     QOPRTS               ;Done !
QCHNUM:
        CMP     #100                 ;Relational operator?
        BEQ     UNPSTK               ;Yes, don't check operand.
        JSR     CHKNUM               ;Must be number.
UNPSTK:
        STY     OPPTR                ;Save operator's pointer for next time.
PULSTK:
        PLA                          ;Get mask for rel op if it is one.
        LSR     A                    ;Setup [c] for dorel's "chkval"*
        STA     DOMASK               ;Save for "docmp"*
        PLA                          ;Unpack stack into arg.
        STA     ARGEXP
        PLA
        STA     ARGHO
        .if     ADDPRC != 0
        PLA
        STA     ARGMOH
        .endif
        PLA
        STA     ARGMO
        PLA
        STA     ARGLO
        PLA
        STA     ARGSGN
        EOR     FACSGN               ;Get probable result sign.
        STA     ARISGN               ;Arithmetic sign. used by
                                     ;Add, sub, mult, div.
QOPRTS:
        LDA     FACEXP               ;Get it and set codes.
UNPRTS:
        RTS                          ;Return.

EVAL:
        CLR     VALTYP               ;Assume value will be numeric.
EVAL0:
        JSR     CHRGET               ;Get a character.
        BCS     EVAL2
EVAL1:
        JMP     FIN                  ;It is a number.
EVAL2:
        JSR     ISLETC               ;Variable name?
        BCS     ISVAR                ;Yes.
        .if     REALIO == 3
        CMP     #PI
        BNE     QDOT
        LDWDI   PIVAL
        JSR     MOVFM                ;Put value in for pi.
        JMP     CHRGET
PIVAL:
        .byte   0o202
        .byte   0o111
        .byte   0o017
        .byte   0o332
        .byte   0o241
        .endif
QDOT:
        CMP     #"*"                 ;Leading character of constant?
        BEQ     EVAL1
        CMP     #MINUTK              ;Negation?
        BEQ     DOMIN                ;Sho is.
        CMP     #PLUSTK
        BEQ     EVAL0
        CMP     #34                  ;A quote? a string?
        BNE     EVAL3
STRTXT:
        LDWD    TXTPTR
        ADC     #0                   ;To inc, add c=1.
        BCC     STRTX2
        INY
STRTX2:
        JSR     STRLIT               ;Yes. go process it.
        JMP     ST2TXT
EVAL3:
        CMP     #NOTTK               ;Check for "not" operator.
        BNE     EVAL4
        LDY     #NOTTAB - OPTAB      ;"Not" has precedence 90.
        BNE     GONPRC               ;Go do its evaluation.
NOTOP:
        JSR     AYINT                ;Integerize.
        LDA     FACLO                ;Get the argument.
        EOR     #255
        TAY
        LDA     FACMO
        EOR     #255
        JMP     GIVAYF               ;Float [y,a] as result in fac.
                                     ;And return.
EVAL4:
        CMP     #FNTK                ;User-defined function?
        JEQ     FNDOER
        CMP     #ONEFUN              ;A function name?
        BCC     PARCHK               ;Functions are the highest numbered
        JMP     ISFUN                ;Characters so no need to check
                                     ;An upper-bound.
PARCHK:
        JSR     CHKOPN               ;Only possibility left is
        JSR     FRMEVL               ;A formula in parenthesis.
                                     ;Recursively evaluate the formula.
CHKCLS:
        LDA     #41                  ;Check for a right parenthese
        SKIP2
CHKOPN:
        LDA     #40
        SKIP2
CHKCOM:
        LDA     #44

; "Synchk" looks at the current character to make sure it
; Is the specific thing loaded into acca just before the call to
; "Synchk"* if not, it calls the "syntax error" routine.
; Otherwise it gobbles the next char and returns

; [A]=new char and txtptr is advanced by "chrget"*

SYNCHR:
        LDY     #0
        CMP     (TXTPTR),Y           ;Characters equal?
        BNE     SNERR
CHRGO5:
        JMP     CHRGET
SNERR:
        LDX     #ERRSN               ;"Syntax error"
        JMP     ERROR
DOMIN:
        LDY     #NEGTAB - OPTAB      ;A precedence below "^"*
GONPRC:
        PLA                          ;Get rid of rts addr.
        PLA
        JMP     NEGPRC               ;Evalute for negation.

ISVAR:
        JSR     PTRGET               ;Get a pntr to variable.
ISVRET:
        STWD    FACMO
        .if     (TIME | EXTIO) != 0
        LDWD    VARNAM
        .endif
                                     ;Check time,time$,status.
        LDX     VALTYP
        BEQ     GOOO                 ;The string is set up.
        LDX     #0
        STX     FACOV
        .if     TIME != 0
        BIT     FACLO                ;An array?
        BPL     STRRTS               ;Yes.
        CMP     #"T"                 ;Ti$?
        BNE     STRRTS
        CPY     #"I" + 128
        BNE     STRRTS
        JSR     GETTIM               ;Yes. put time in facmoh-lo.
        STY     TENEXP               ;y=0.
        DEY
        STY     FBUFPT
        LDY     #6                   ;Six	digits to print.
        STY     DECCNT
        LDY     #FDCEND - FOUTBL
        JSR     FOUTIM               ;Convert to ascii.
        JMP     TIMSTR
        .endif
STRRTS:
        RTS
GOOO:
        .if     INTPRC != 0
        LDX     INTFLG
        BPL     GOOOOO
        LDY     #0
        LDA     (FACMO),Y            ;Fetch high.
        TAX
        INY
        LDA     (FACMO),Y
        TAY                          ;Put low in y.
        TXA                          ;Get high in a.
        JMP     GIVAYF
        .endif
                                     ;Float and return.
GOOOOO:
        .if     TIME != 0
        BIT     FACLO                ;An array?
        BPL     GOMOVF               ;Yes.
        CMP     #"T"
        BNE     QSTATV
        CPY     #"I"
        BNE     GOMOVF
        JSR     GETTIM
        TYA                          ;For floatb.
        LDX     #160                 ;Set exponnent.
        JMP     FLOATB
GETTIM:
        LDWDI   (CQTIMR - 2)
        SEI                          ;Turn of int sys.
        JSR     MOVFM
        CLI                          ;Back on.
        STY     FACHO                ;Zero highest.
        RTS
        .endif
QSTATV:
        .if     EXTIO != 0
        CMP     #"S"
        BNE     GOMOVF
        CPY     #"T"
        BNE     GOMOVF
        LDA     CQSTAT
        JMP     FLOAT
GOMOVF:
        .endif
        .if     (TIME | EXTIO) != 0
        LDWD    FACMO
        .endif
        JMP     MOVFM                ;Move actual value in.
                                     ;And return.

ISFUN:
        ASL     A                    ;Multiply by two.
        PHA
        TAX
        JSR     CHRGET               ;Set up for synchk.
        CPX     #2 * LASNUM - 256 + 1 ;Is it past "lasnum"?
        BCC     OKNORM               ;No, must be normal function.

; Most functions take a single argument.
; The return address of these functions is "chknum"
; Which ascertains that [valtyp]=0  (numeric)*
; Normal functions that return string results
; (E.g., chr$) must pop off that return addr and
; Return directly to "frmevl"*

; The so-called "funny" functions can take more than one argument
; The first of which must be string and the second of which
; Must be a number between 0 and 255.
; The closed parenthesis must be checked and return is directly
; To "frmevl" with the text pntr pointing beyond the ")"*
; The pointer to the descriptor of the string argument
; Is stored on the stack underneath the value of the
; Integer argument.

        JSR     CHKOPN               ;Check for an open parenthese
        JSR     FRMEVL               ;Eat open paren and first arg.
        JSR     CHKCOM               ;Two args so comma must delimit.
        JSR     CHKSTR               ;Make sure first was string.
        PLA                          ;Get function number.
        TAX
        PSHWD   FACMO                ;Save pointer at string descriptor
        TXA
        PHA                          ;Resave function number.
                                     ;This must be on stack since recursive.
        JSR     GETBYT               ;[X]=value of formula.
        PLA                          ;Get function number.
        TAY
        TXA
        PHA
        JMP     FINGO                ;Dispatch to function.
OKNORM:
        JSR     PARCHK               ;Read a formula surrounded by parens.
        PLA                          ;Get dispatch function.
        TAY
FINGO:
        LDA     FUNDSP - 2 * ONEFUN + 256,Y ;Modify dispatch address.
        STA     JMPER + 1
        LDA     FUNDSP - 2 * ONEFUN + 257,Y
        STA     JMPER + 2
        JSR     JMPER                ;Dispatch!
                                     ;String functions remove this ret addr.
        JMP     CHKNUM               ;Check it for numericness and return.

OROP:
        LDY     #255                 ;Must always complement..
        SKIP2
ANDOP:
        LDY     #0
        STY     COUNT                ;Operator.
        JSR     AYINT                ;[Facmo&lo]=int value and check size.
        LDA     FACMO                ;Use demorgan's law on high
        EOR     COUNT
        STA     INTEGR
        LDA     FACLO                ;And low.
        EOR     COUNT
        STA     INTEGR + 1
        JSR     MOVFA
        JSR     AYINT                ;[Facmo&lo]=int of arg.
        LDA     FACLO
        EOR     COUNT
        AND     INTEGR + 1
        EOR     COUNT                ;Finish out demorgan.
        TAY                          ;Save high.
        LDA     FACMO
        EOR     COUNT
        AND     INTEGR
        EOR     COUNT
        JMP     GIVAYF               ;Float [a.y] and ret to user.

; Time to perform a relational operator.
; [Domask] contains the bits as to which relational
; Operator it was. carry bit on=string compare.

DOREL:
        JSR     CHKVAL               ;Check for match.
        BCS     STRCMP               ;It is a string.
        LDA     ARGSGN               ;Pack arg for fcomp.
        ORA     #127
        AND     ARGHO
        STA     ARGHO
        LDWDI   ARGEXP
        JSR     FCOMP
        TAX
        JMP     QCOMP
STRCMP:
        CLR     VALTYP               ;Result will be numeric.
        DEC     OPMASK               ;Turn off valtyp which was string.
        JSR     FREFAC               ;Free the faclo string.
        STA     DSCTMP               ;Save for later.
        STXY    DSCTMP + 1
        LDWD    ARGMO                ;Get pointer to other string.
        JSR     FRETMP               ;Frees first desc pointer.
        STXY    ARGMO
        TAX                          ;Copy count into x.
        SEC
        SBC     DSCTMP               ;Which is greater. if 0, all set up.
        BEQ     STASGN               ;Just put sign of difference away.
        LDA     #1
        BCC     STASGN               ;Sign is positive.
        LDX     DSCTMP               ;Length of fac is shorter.
        LDA     #0o377               ;Get a minus 1 for negatives.
STASGN:
        STA     FACSGN               ;Keep for later.
        LDY     #255                 ;Set pointer to first string. (arg.)
        INX                          ;To loop properly.
NXTCMP:
        INY
        DEX                          ;Any characters left to compare?
        BNE     GETCMP               ;Not done yet.
        LDX     FACSGN               ;Use sign of length difference
                                     ;Since all characters are the same.
QCOMP:
        BMI     DOCMP                ;C is always set then.
        CLC
        BCC     DOCMP                ;Always branch.
GETCMP:
        LDA     (ARGMO),Y            ;Get next char to compare.
        CMP     (DSCTMP + 1),Y       ;Same?
        BEQ     NXTCMP               ;Yep. try further.
        LDX     #0o377               ;Set a positive difference.
        BCS     DOCMP                ;Put stack back together.
        LDX     #1                   ;Set a negative difference.
DOCMP:
        INX                          ;-1 To 1, 0 to 2, 1 to 4.
        TXA
        ROL     A
        AND     DOMASK
        BEQ     GOFLOT
        LDA     #0o377               ;Map 0 to 0. all others to -1.
GOFLOT:
        JMP     FLOAT                ;Float the one-byte result into fac.

        .page
        .subttl DIMENSION AND VARIABLE SEARCHING.

; The "dim" code sets [dimflg] and then falls into the variable search
; Routine, which looks at dimflg at three different points.
;	1) If an entry is found, "dimflg" being on indicates
;		A "doubly" dimensioned variable.
;	2) When a new entry is being built "dimflg" being on
;		Indictaes the indices should be used for the
;		Size of each index. otherwise the default of ten
;		Is used.
;	3) When the build entry code finishes, only if "dimflg" is off
;		Will indexing be done.

DIM3:
        JSR     CHKCOM               ;Must be a comma
DIM:
        TAX                          ;Set [accx] nonzero.
                                     ;[Acca] must be nonzero to work right.
DIM1:
        JSR     PTRGT1
DIMCON:
        JSR     CHRGOT               ;Get last character.
        BNE     DIM3
        RTS

; Routine to read the variable name at the current text position
; And  put a pointer to its value in varpnt. [txtptr]
; Points to the terminating charcter.. not that evaluating subscripts
; In a variable name can cause recursive calls to "ptrget" so at
; That point all values must be stored on the stack.

PTRGET:
        LDX     #0                   ;Make [accx]=0.
        JSR     CHRGOT               ;Retrieve last character.
PTRGT1:
        STX     DIMFLG               ;Store flag away.
PTRGT2:
        STA     VARNAM
        JSR     CHRGOT               ;Get current character
                                     ;Maybe with function bit off.
        JSR     ISLETC               ;Check for letter.
        BCS     PTRGT3               ;Must have a letter.
INTERR:
        JMP     SNERR
PTRGT3:
        LDX     #0                   ;Assume no second character.
        STX     VALTYP               ;Default is numeric.
        .if     INTPRC != 0
        STX     INTFLG
        .endif
                                     ;Assume floating.
        JSR     CHRGET               ;Get following character.
        BCC     ISSEC                ;Carry reset by chrget if numeric.
        JSR     ISLETC               ;Set carry if not alphabetic.
        BCC     NOSEC                ;Allow alphabetics.
ISSEC:
        TAX                          ;It is a number -- save in accx.
EATEM:
        JSR     CHRGET               ;Look at next character.
        BCC     EATEM                ;Skip numerics.
        JSR     ISLETC
        BCS     EATEM                ;Skip alphabetics.
NOSEC:
        CMP     #"$"                 ;Is it a string?
        BNE     NOTSTR               ;If not, [valtyp]=0.
        LDA     #0o377               ;Set [valtyp]=255 (string !)*
        STA     VALTYP
        .if     INTPRC != 0
        BNEA    TURNON               ;Always goes.
NOTSTR:
        CMP     #"%"                 ;Integer variable?
        BNE     STRNAM               ;No.
        LDA     SUBFLG
        BNE     INTERR
        LDA     #128
        STA     INTFLG               ;Set flag.
        ORA     VARNAM               ;Turn on both high bits.
        STA     VARNAM
        .endif
TURNON:
        TXA
        ORA     #128                 ;Turn on msb of second character.
        TAX
        JSR     CHRGET               ;Get character after $*
        .if     INTPRC == 0
NOTSTR:
        .endif
STRNAM:
        STX     VARNAM + 1           ;Store away second character.
        SEC
        ORA     SUBFLG               ;Add flag whether to allow arrays.
        SBC     #40                  ;(Check for "(") won't match if subflg set.
        JEQ     ISARY                ;It is!
        CLR     SUBFLG               ;Allow subscripts again.
        LDA     VARTAB               ;Place to start search.
        LDX     VARTAB + 1
        LDY     #0
STXFND:
        STX     LOWTR + 1
LOPFND:
        STA     LOWTR
        CPX     ARYTAB + 1           ;At end of table yet?
        BNE     LOPFN
        CMP     ARYTAB
        BEQ     NOTFNS               ;Yes. we couldn't find it.
LOPFN:
        LDA     VARNAM
        CMP     (LOWTR),Y            ;Compare high orders.
        BNE     NOTIT                ;No comparison.
        LDA     VARNAM + 1
        INY
        CMP     (LOWTR),Y            ;And the low part?
        BEQ     FINPTR               ;That's it ! that's it !
        DEY
NOTIT:
        CLC
        LDA     LOWTR
        ADC     #6 + ADDPRC          ;Makes no dif among types.
        BCC     LOPFND
        INX
        BNEA    STXFND               ;Always branches.

; Test for a letter.	/ carry off= not a letter.
;			  Carry on= a letter.

ISLETC:
        CMP     #"A"
        BCC     ISLRTS               ;If less than "a", ret.
        SBC     #"Z" + 1
        SEC
        SBC     #256 - "Z" - 1       ;Reset carry if [a] .gt. "z"*
ISLRTS:
        RTS                          ;Return to caller.

NOTFNS:
        PLA                          ;Check who's calling.
        PHA                          ;Restore it.
        CMP     #ISVRET - 1 - (ISVRET - 1) / 256 * 256 ;Is eval calling?
        BNE     NOTEVL               ;No, carry on.
        .if     REALIO != 3
        TSX
        LDA     258,X
        CMP     #(ISVRET - 1) / 256
        BNE     NOTEVL
        .endif
LDZR:
        LDWDI   ZERO                 ;Set up pntr to simulated zero.
        RTS                          ;For strings or numeric.
                                     ;And for integers too.
NOTEVL:
        .if     (TIME | EXTIO) != 0
        LDWD    VARNAM
        .endif
        .if     TIME != 0
        CMP     #"T"
        BNE     QSTAVR
        CPY     #"I" + 128
        BEQ     LDZR
        CPY     #"I"
        BNE     QSTAVR
        .endif
        .if     (EXTIO | TIME) != 0
GOBADV:
        JMP     SNERR
        .endif
QSTAVR:
        .if     EXTIO != 0
        CMP     #"S"
        BNE     VAROK
        CPY     #"T"
        BEQ     GOBADV
        .endif
VAROK:
        LDWD    ARYTAB
        STWD    LOWTR                ;Lowest thing to move.
        LDWD    STREND               ;Get highest addr to move.
        STWD    HIGHTR
        CLC
        ADC     #6 + ADDPRC
        BCC     NOTEVE
        INY
NOTEVE:
        STWD    HIGHDS               ;Place to stuff it.
        JSR     BLTU                 ;Move it all.
                                     ;Note [y,a] has [highds] for reason.
        LDWD    HIGHDS               ;And set up
        INY
        STWD    ARYTAB               ;New start of array table.
        LDY     #0                   ;Get addr of variable entry.
        LDA     VARNAM
        STA     (LOWTR),Y
        INY
        LDA     VARNAM + 1
        STA     (LOWTR),Y            ;Store name of variable.
        LDA     #0
        INY
        STA     (LOWTR),Y
        INY
        STA     (LOWTR),Y
        INY
        STA     (LOWTR),Y
        INY
        STA     (LOWTR),Y            ;Fourth zero for def func.
        .if     ADDPRC != 0
        INY
        STA     (LOWTR),Y
        .endif
FINPTR:
        LDA     LOWTR
        CLC
        ADC     #2
        LDY     LOWTR + 1
        BCC     FINNOW
        INY
FINNOW:
        STWD    VARPNT               ;This is it.
        RTS
        .page
        .subttl MULTIPLE DIMENSION CODE.
FMAPTR:
        LDA     COUNT
        ASL     A
        ADC     #5                   ;Point to entries. c clr'd by asl.
        ADC     LOWTR
        LDY     LOWTR + 1
        BCC     JSRGM
        INY
JSRGM:
        STWD    ARYPNT
        RTS

N32768:
        .word   144, 128, 0, 0       ;-32768.

; Intidx reads a formula from the current position and
; Turns it into a positive integer
; Leaving the result in facmo&lo. negative arguments
; Are not allowed.

INTIDX:
        JSR     CHRGET
        JSR     FRMEVL               ;Get a number
POSINT:
        JSR     CHKNUM
        LDA     FACSGN
        BMI     NONONO               ;If negative, blow him out.
AYINT:
        LDA     FACEXP
        CMP     #144                 ;Fac .gt. 32767?
        BCC     QINTGO
        LDWDI   N32768               ;Get addr of -32768.
        JSR     FCOMP                ;See if fac=[[y,a]]*
NONONO:
        BNE     FCERR                ;No, fac is too big.
QINTGO:
        JMP     QINT                 ;Go to qint and shove it.

; Format of arrays in core.

; Descriptor:
;	Lowbyte = first character.
;	Highbyte = second character (200 bit is string flag)*
; Length of array in core in bytes (includes everything)*
; Number of dimensions.
; For each dimension starting with the first a list
; (2 Bytes each) of the max indice+1
; The values

ISARY:
        LDA     DIMFLG
        .if     INTPRC != 0
        ORA     INTFLG
        .endif
        PHA                          ;Save [dimflg] for recursion.
        LDA     VALTYP
        PHA                          ;Save [valtyp] for recursion.
        LDY     #0                   ;Set number of dimensions to zero.
INDLOP:
        TYA                          ;Save number of dims.
        PHA
        PSHWD   VARNAM               ;Save looks.
        JSR     INTIDX               ;Evaluate indice into facmo&lo.
        PULWD   VARNAM               ;Get back all... we're home.
        PLA                          ;(# Of dims)*
        TAY
        TSX
        LDA     258,X
        PHA                          ;Push dimflg and valtyp further.
        LDA     257,X
        PHA
        LDA     INDICE               ;Put indice onto stack.
        STA     258,X                ;Under dimflg and valtyp.
        LDA     INDICE + 1
        STA     257,X
        INY                          ;Increment # of dims.
        JSR     CHRGOT               ;Get terminating character.
        CMP     #44                  ;A comma?
        BEQ     INDLOP               ;Yes.
        STY     COUNT                ;Save count of dims.
        JSR     CHKCLS               ;Must be closed paren.
        PLA
        STA     VALTYP               ;Get valtyp and
        PLA
        .if     INTPRC != 0
        STA     INTFLG
        AND     #127
        .endif
        STA     DIMFLG               ;Dimflg off stack.
        LDX     ARYTAB               ;Place to start search.
        LDA     ARYTAB + 1
LOPFDA:
        STX     LOWTR
        STA     LOWTR + 1
        CMP     STREND + 1           ;End of arrays?
        BNE     LOPFDV
        CPX     STREND
        BEQ     NOTFDD               ;A fine thing! no array!*
LOPFDV:
        LDY     #0
        LDA     (LOWTR),Y
        INY
        CMP     VARNAM               ;Compare high orders.
        BNE     NMARY1               ;No way is it this. get out of here.
        LDA     VARNAM + 1
        CMP     (LOWTR),Y            ;Low orders?
        BEQ     GOTARY               ;Well, here it is !!
NMARY1:
        INY
        LDA     (LOWTR),Y            ;Get length.
        CLC
        ADC     LOWTR
        TAX
        INY
        LDA     (LOWTR),Y
        ADC     LOWTR + 1
        BCC     LOPFDA               ;Always branches.
BSERR:
        LDX     #ERRBS               ;Get bad sub error number.
        SKIP2
FCERR:
        LDX     #ERRFC               ;Too big. "function call" error.
ERRGO3:
        JMP     ERROR
GOTARY:
        LDX     #ERRDD               ;Perhaps a "re-dimension" error
        LDA     DIMFLG               ;Test the dimflg
        BNE     ERRGO3
        JSR     FMAPTR
        LDA     COUNT                ;Get number of dims input.
        LDY     #4
        CMP     (LOWTR),Y            ;# Of dims the same?
        BNE     BSERR                ;Same so go get definition.
        JMP     GETDEF

; Here when variable is not found in the array table.

; Building an entry.

;	Put down the descriptor.
;	Setup number of dimensions.
;	Make sure there is room for the new entry.
;	Remember "varpnt"*
;	Tally=4.
;	Skip 2 locs for later fill in of size.
; Loop: get an indice
;	Put down number+1 and increment varptr.
;	Tally=tally*number+1.
;	Decrement number-dims.
;	Bne loop
;	Call "reason" with [y,a] reflecting last loc of variable.
;	Update strend.
;	Zero all.
;	Make tally include maxdims and descriptor.
;	Put down tally.
;	If called by dimension, return.
;	Otherwise index into the variable as if it
;	 Were found on the initial search.

NOTFDD:
        JSR     FMAPTR               ;Form arypnt.
        JSR     REASON
        LDA     #0
        TAY
        STA     CURTOL + 1
        .if     ADDPRC == 0
        LDX     #4
        .endif
        .if     ADDPRC != 0
        LDX     #5
        .endif
        LDA     VARNAM               ;This code only works for intprc=1
        STA     (LOWTR),Y            ;If addprc=1.
        .if     ADDPRC != 0
        BPL     NOTFLT
        DEX
        .endif
NOTFLT:
        INY
        LDA     VARNAM + 1
        STA     (LOWTR),Y
        BPL     STOMLT
        DEX
        .if     ADDPRC != 0
        DEX
        .endif
STOMLT:
        STX     CURTOL
        LDA     COUNT
        .repeat 3
        INY
        .endrepeat
        STA     (LOWTR),Y            ;Save number of dimensions.
LOPPTA:
        LDX     #11                  ;Default size.
        LDA     #0
        BIT     DIMFLG
        BVC     NOTDIM               ;Not in a dim statement.
        PLA                          ;Get low order of indice.
        CLC
        ADC     #1
        TAX
        PLA                          ;Get high part of indice.
        ADC     #0
NOTDIM:
        INY
        STA     (LOWTR),Y            ;Store high part of indice.
        INY
        TXA
        STA     (LOWTR),Y            ;Store low order of indice.
        JSR     UMULT                ;[X,a]=[curtol]*[lowtr,y]
        STX     CURTOL               ;Save new tally.
        STA     CURTOL + 1
        LDY     INDEX
        DEC     COUNT                ;Any more indices left?
        BNE     LOPPTA               ;Yes.
        ADC     ARYPNT + 1
        BCS     OMERR1               ;Overflow.
        STA     ARYPNT + 1           ;Compute where to zero.
        TAY
        TXA
        ADC     ARYPNT
        BCC     GREASE
        INY
        BEQ     OMERR1
GREASE:
        JSR     REASON               ;Get room.
        STWD    STREND               ;New end of storage.
        LDA     #0                   ;Storing [acca] is faster than clear.
        INC     CURTOL + 1
        LDY     CURTOL
        BEQ     DECCUR
ZERITA:
        DEY
        STA     (ARYPNT),Y
        BNE     ZERITA               ;No. continue.
DECCUR:
        DEC     ARYPNT + 1
        DEC     CURTOL + 1
        BNE     ZERITA               ;Do another block.
        INC     ARYPNT + 1           ;Bump back up. will use later.
        SEC
        LDA     STREND               ;Restore [acca]*
        SBC     LOWTR                ;Determine length.
        LDY     #2
        STA     (LOWTR),Y            ;Low.
        LDA     STREND + 1
        INY
        SBC     LOWTR + 1
        STA     (LOWTR),Y            ;High.
        LDA     DIMFLG
        BNE     DIMRTS               ;Bye.
        INY

; At this point [lowtr,y] points beyond the size to the number of
; Dimensions. strategy:
;	Numdim=number of dimensions.
;	Curtol=0.
; Inlpnm:get a new indice.
;	Make sure indice is not too big.
;	Multiply curtol by curmax.
;	Add indice to curtol.
;	Numdim=numdim-1.
;	Bne	inlpnm.
;	Use [curtol]*4 as offset.

GETDEF:
        LDA     (LOWTR),Y
        STA     COUNT                ;Save a counter.
        LDA     #0                   ;Zero [curtol]*
        STA     CURTOL
INLPNM:
        STA     CURTOL + 1
        INY
        PLA                          ;Get low indice.
        TAX
        STA     INDICE
        PLA                          ;And the high part
        STA     INDICE + 1
        CMP     (LOWTR),Y            ;Compare with max indice.
        BCC     INLPN2
        BNE     BSERR7               ;If greater, "bad subscript" error.
        INY
        TXA
        CMP     (LOWTR),Y
        BCC     INLPN1
BSERR7:
        JMP     BSERR
OMERR1:
        JMP     OMERR
INLPN2:
        INY
INLPN1:
        LDA     CURTOL + 1           ;Don't multiply if curtol=0.
        ORA     CURTOL
        CLC                          ;Prepare to get indice back.
        BEQ     ADDIND               ;Get high part of indice back.
        JSR     UMULT                ;Multiply [curtol] by [lowtr,y,y+1]*
        TXA
        ADC     INDICE               ;Add in [indice]*
        TAX
        TYA
        LDY     INDEX1
ADDIND:
        ADC     INDICE + 1
        STX     CURTOL
        DEC     COUNT                ;Any more?
        BNE     INLPNM               ;Yes.
        STA     CURTOL + 1           ;Fix array bug ****
        .if     ADDPRC == 0
        LDX     #4
        .endif
        .if     ADDPRC != 0
        LDX     #5                   ;This code only works for intprc=1
        LDA     VARNAM               ;If addprc=1.
        BPL     NOTFL1
        DEX
        .endif
NOTFL1:
        LDA     VARNAM + 1
        BPL     STOML1
        DEX
        .if     ADDPRC != 0
        DEX
        .endif
STOML1:
        STX     ADDEND
        LDA     #0
        JSR     UMULTD               ;On rts, a&y=hi * x=lo.
        TXA
        ADC     ARYPNT
        STA     VARPNT
        TYA
        ADC     ARYPNT + 1
        STA     VARPNT + 1
        TAY
        LDA     VARPNT
DIMRTS:
        RTS                          ;Return to caller.
        .subttl INTEGER ARITHMETIC ROUTINES.
                                     ;Two byte unsigned integer multiply.
                                     ;This is for multiply dimensioned arrays.
                                     ; [X,y]=[x,a]=[curtol]*[lowtr,y,y+1]*
UMULT:
        STY     INDEX
        LDA     (LOWTR),Y
        STA     ADDEND               ;Low, then high.
        DEY
        LDA     (LOWTR),Y            ;Put [lowtr,y,y+1] in faster memory.
UMULTD:
        STA     ADDEND + 1
        LDA     #16
        STA     DECCNT
        LDX     #0                   ;Clr the accs.
        LDY     #0                   ;Result initially zero.
UMULTC:
        TXA
        ASL     A                    ;Multiply by two.
        TAX
        TYA
        ROL     A
        TAY
        BCS     OMERR1               ;Two much !
        ASL     CURTOL
        ROL     CURTOL + 1
        BCC     UMLCNT               ;Nothing in this position to multiply.
        CLC
        TXA
        ADC     ADDEND
        TAX
        TYA
        ADC     ADDEND + 1
        TAY
        BCS     OMERR1               ;Man, just too much !
UMLCNT:
        DEC     DECCNT               ;Done?
        BNE     UMULTC               ;Keep it up.
UMLRTS:
        RTS                          ;Yes, all done.
        .page
        .subttl FRE FUNCTION AND INTEGER TO FLOATING ROUTINES.
FRE:
        LDA     VALTYP
        BEQ     NOFREF
        JSR     FREFAC
NOFREF:
        JSR     GARBA2
        SEC
        LDA     FRETOP               ;We want
        SBC     STREND               ;[Fretop]-[strend]*
        TAY
        LDA     FRETOP + 1
        SBC     STREND + 1

GIVAYF:
        LDX     #0
        STX     VALTYP
        STWD    FACHO
        LDX     #144                 ;Set exponent to 2^16.
        JMP     FLOATS               ;Turn it to a floating pnt #*

POS:
        LDY     TRMPOS               ;Get position.
SNGFLT:
        LDA     #0
        BEQA    GIVAYF               ;Float it.
        .page
        .subttl SIMPLE-USER-DEFINED-FUNCTION CODE.

; Note only single arguments are allowed to functions
; And functions must be of the single line form:
;	Def fna(x)=x^2+x-2
; No strings can be involved with these functions.

; Idea: create a simple variable entry
; Whose first character has the 200 bit set.
; The value will be:

;	A text pntr to the formula.
;	A pntr to the argument variable.

; Function names can be like "fna4"*

; Subroutine to see if we are in direct mode.
; And complain if so.

ERRDIR:
        LDX     CURLIN + 1           ;Dir mode has [curlin]=0,255
        INX                          ;So now, is result zero?
        BNE     DIMRTS               ;Yes.
        LDX     #ERRID               ;Input direct error code.
        SKIP2
ERRGUF:
        LDX     #ERRUF               ;User defined function never defined
ERRGO1:
        JMP     ERROR

DEF:
        JSR     GETFNM               ;Get a pntr to the function.
        JSR     ERRDIR
        JSR     CHKOPN               ;Must have "("*
        LDA     #128
        STA     SUBFLG               ;Prohibit subscripted variables.
        JSR     PTRGET               ;Get pntr to argument.
        JSR     CHKNUM               ;Is it a number?
        JSR     CHKCLS               ;Must have ")"
        SYNCHK  EQULTK               ;Must have "="*
        .if     ADDPRC != 0
        PHA
        .endif
                                     ;Put crazy byte on.
        PSHWD   VARPNT
        PSHWD   TXTPTR
        JSR     DATA
        JMP     DEFFIN

; Subroutine to get a pntr to a function name.

GETFNM:
        SYNCHK  FNTK                 ;Must start with fn.
        ORA     #128                 ;Put function bit on.
        STA     SUBFLG
        JSR     PTRGT2               ;Get pointer to function or create anew.
        STWD    DEFPNT
        JMP     CHKNUM               ;Make sure it's not a string and return.

FNDOER:
        JSR     GETFNM               ;Get the function's name.
        PSHWD   DEFPNT
        JSR     PARCHK               ;Evaluate parameter.
        JSR     CHKNUM
        PULWD   DEFPNT
        LDY     #2
        LDA     (DEFPNT),Y           ;Get pointer to variable.
        STA     VARPNT               ;Save variable pointer.
        TAX
        INY
        LDA     (DEFPNT),Y
        BEQ     ERRGUF
        STA     VARPNT + 1
        .if     ADDPRC != 0
        INY
        .endif
                                     ;Since def uses only 4.
DEFSTF:
        LDA     (VARPNT),Y
        PHA                          ;Push it all on stack.
        DEY                          ;Since we are recursing maybe.
        BPL     DEFSTF
        LDY     VARPNT + 1
        JSR     MOVMF                ;Put current fac into our arg variable.
        PSHWD   TXTPTR               ;Save text pointer.
        LDA     (DEFPNT),Y           ;Pntr to function.
        STA     TXTPTR
        INY
        LDA     (DEFPNT),Y
        STA     TXTPTR + 1
        PSHWD   VARPNT               ;Save variable pointer.
        JSR     FRMNUM               ;Evaluate formula and check numeric.
        PULWD   DEFPNT
        JSR     CHRGOT
        JNE     SNERR                ;It didn't terminate. huh?
        PULWD   TXTPTR               ;Restore text pntr.
DEFFIN:
        LDY     #0
        PLA                          ;Get old arg value off stack
        STA     (DEFPNT),Y           ;And put it back in variable.
        PLA
        INY
        STA     (DEFPNT),Y
        PLA
        INY
        STA     (DEFPNT),Y
        PLA
        INY
        STA     (DEFPNT),Y
        .if     ADDPRC != 0
        PLA
        INY
        STA     (DEFPNT),Y
        .endif
DEFRTS:
        RTS
        .page
        .subttl STRING FUNCTIONS.

; The str$ function takes a number and gives a string
; With the characters the output of the number
; Would have given.

STR:
        JSR     CHKNUM               ;Arg has to be numeric.
        LDY     #0
        JSR     FOUTC                ;Do its output.
        PLA
        PLA
TIMSTR:
        LDWDI   LOFBUF
        BEQA    STRLIT               ;Scan it and turn it into a string.

; "Strini" get string space for the creation of a string and
; Creates a descriptor for it in "dsctmp"*

STRINI:
        LDXY    FACMO                ;Get facmo to store in dscpnt.
        STXY    DSCPNT               ;Retain the descriptor pointer.
STRSPA:
        JSR     GETSPA               ;Get string space.
        STXY    DSCTMP + 1           ;Save location.
        STA     DSCTMP               ;Save length.
        RTS                          ;All done.

; "Strlt2" takes the string literal whose first character
; Is pointed to by [y,a] and builds a descriptor for it.
; The descriptor is initially built in "dsctmp", but "putnew"
; Transfers it into a temporary and leaves a pointer
; At the temporary in facmo&lo. the characters other than
; Zero that terminate the string should be set up in "charac"
; And "endchr"* if the terminator is a quote, the quote is skipped
; Over. leading quotes should be skipped before jsr. on return
; The character after the string literal is pointed to
; By [strng2]*

STRLIT:
        LDX     #34                  ;Assume string ends on quote.
        STX     CHARAC
        STX     ENDCHR
STRLT2:
        STWD    STRNG1               ;Save pointer to string.
        STWD    DSCTMP + 1           ;In case no strcpy.
        LDY     #255                 ;Initialize character count.
STRGET:
        INY
        LDA     (STRNG1),Y           ;Get character.
        BEQ     STRFI1               ;If zero.
        CMP     CHARAC               ;This terminator?
        BEQ     STRFIN               ;Yes.
        CMP     ENDCHR
        BNE     STRGET               ;Look further.
STRFIN:
        CMP     #34                  ;Quote?
        BEQ     STRFI2
STRFI1:
        CLC                          ;No, back up.
STRFI2:
        STY     DSCTMP               ;Retain count.
        TYA
        ADC     STRNG1               ;Wishing to set [txtptr]*
        STA     STRNG2
        LDX     STRNG1 + 1
        BCC     STRST2
        INX
STRST2:
        STX     STRNG2 + 1
        LDA     STRNG1 + 1           ;If page 0, copy since it is either
                                     ;A string constant in buf or a str$
                                     ;Result in lofbuf
        .if     BUFPAG != 0
        BEQ     STRCP
        CMP     #BUFPAG
        .endif
        BNE     PUTNEW
STRCP:
        TYA
        JSR     STRINI
        LDXY    STRNG1
        JSR     MOVSTR               ;Move string.

; Some string function is returning a result in dsctmp.
; Setup a temp descriptor with dsctmp in it.
; Put a pointer to the descriptor in facmo&lo and flag the
; Result as type string.

PUTNEW:
        LDX     TEMPPT               ;Pointer to first free temp.
        CPX     #TEMPST + STRSIZ * NUMTMP
        BNE     PUTNW1
        LDX     #ERRST               ;String temporary error.
ERRGO2:
        JMP     ERROR                ;Go tell him.
PUTNW1:
        LDA     DSCTMP
        STA     0,X
        LDA     DSCTMP + 1
        STA     1,X
        LDA     DSCTMP + 2
        STA     2,X
        LDY     #0
        STXY    FACMO
        STY     FACOV
        DEY
        STY     VALTYP               ;Type is "string"*
        STX     LASTPT               ;Set pointer to last-used temp.
        INX
        INX
        INX                          ;Point further.
        STX     TEMPPT               ;Save pointer to next temp if any.
        RTS                          ;All done.

; Getspa - get space for character string.
; May force garbage collection.

; # Of characters (bytes) in acca.
; Returns with pointer in [y,x]* otherwise (if can't get
; Space) blows off to "out of string space" type error.
; Also preserves [acca] and sets [frespc]=[y,x]=pntr at space.

GETSPA:
        LSR     GARBFL               ;Signal no garbage collection yet.
TRYAG2:
        PHA                          ;Save for later.
        EOR     #255
        SEC                          ;Add one to complete negation.
        ADC     FRETOP
        LDY     FRETOP + 1
        BCS     TRYAG3
        DEY
TRYAG3:
        CPY     STREND + 1           ;Compare high orders.
        BCC     GARBAG               ;Make room for more.
        BNE     STRFRE               ;Save new fretop.
        CMP     STREND               ;Compare low orders.
        BCC     GARBAG               ;Clean up.
STRFRE:
        STWD    FRETOP               ;Save new [fretop]*
        STWD    FRESPC               ;Put it there old man.
        TAX                          ;Preserve a in x.
        PLA                          ;Get count back in acca.
        RTS                          ;All done.
GARBAG:
        LDX     #ERROM               ;"Out of string space"
        LDA     GARBFL
        BMI     ERRGO2
        JSR     GARBA2
        LDA     #128
        STA     GARBFL
        PLA                          ;Get back string length.
        BNE     TRYAG2               ;Always branches.
GARBA2:
                                     ;Start from top down.
        .if     (REALIO | DISKO) == 0
        LDA     #7                   ;Type "bell"*
        JSR     OUTDO
        .endif
        LDX     MEMSIZ
        LDA     MEMSIZ + 1
FNDVAR:
        STX     FRETOP               ;Like so.
        STA     FRETOP + 1
        LDY     #0
        STY     GRBPNT + 1
        STY     GRBPNT               ;Both bytes set to zero (fix bug)
        LDWX    STREND
        STWX    GRBTOP
        LDWXI   TEMPST
        STWX    INDEX1
TVAR:
        CMP     TEMPPT               ;Done with temps?
        BEQ     SVARS                ;Yep.
        JSR     DVAR
        BEQ     TVAR                 ;Loop.
SVARS:
        LDA     #6 + ADDPRC
        STA     FOUR6
        LDWX    VARTAB               ;Get start of simple variables.
        STWX    INDEX1
SVAR:
        CPX     ARYTAB + 1           ;Done with simple variables?
        BNE     SVARGO               ;No.
        CMP     ARYTAB
        BEQ     ARYVAR               ;Yep.
SVARGO:
        JSR     DVARS                ;Do it , again.
        BEQ     SVAR                 ;Loop.
ARYVAR:
        STWX    ARYPNT               ;Save for addition.
        LDA     #STRSIZ
        STA     FOUR6
ARYVA2:
        LDWX    ARYPNT               ;Get the pointer to variable.
ARYVA3:
        CPX     STREND + 1           ;Done with arrays?
        BNE     ARYVGO               ;No.
        CMP     STREND
        JEQ     GRBPAS               ;Yes, go finish up.
ARYVGO:
        STWX    INDEX1
        LDY     #1 - ADDPRC
        .if     ADDPRC != 0
        LDA     (INDEX1),Y
        TAX
        INY
        .endif
        LDA     (INDEX1),Y
        PHP
        INY
        LDA     (INDEX1),Y
        ADC     ARYPNT
        STA     ARYPNT               ;Form pointer to next array var.
        INY
        LDA     (INDEX1),Y
        ADC     ARYPNT + 1
        STA     ARYPNT + 1
        PLP
        BPL     ARYVA2
        .if     ADDPRC != 0
        TXA
        BMI     ARYVA2
        .endif
        INY
        LDA     (INDEX1),Y
        LDY     #0                   ;Reset index y.
        ASL     A
        ADC     #5                   ;Carry is off and off after add.
        ADC     INDEX1
        STA     INDEX1
        BCC     ARYGET
        INC     INDEX1 + 1
ARYGET:
        LDX     INDEX1 + 1
ARYSTR:
        CPX     ARYPNT + 1           ;End of the array?
        BNE     GOGO
        CMP     ARYPNT
        BEQ     ARYVA3               ;Yes.
GOGO:
        JSR     DVAR
        BEQ     ARYSTR               ;Cycle.
DVARS:
        .if     INTPRC != 0
        LDA     (INDEX1),Y
        BMI     DVARTS
        .endif
        INY
        LDA     (INDEX1),Y
        BPL     DVARTS
        INY
DVAR:
        LDA     (INDEX1),Y           ;Is length=0?
        BEQ     DVARTS               ;Yes, return.
        INY
        LDA     (INDEX1),Y           ;Get low(adr)*
        TAX
        INY
        LDA     (INDEX1),Y
        CMP     FRETOP + 1           ;Compare highs.
        BCC     DVAR2                ;If this string's pntr .ge. [fretop]
        BNE     DVARTS               ;No need to mess with it further.
        CPX     FRETOP               ;Compare lows.
        BCS     DVARTS
DVAR2:
        CMP     GRBTOP + 1
        BCC     DVARTS               ;If this string is below previous
                                     ;Forget it.
        BNE     DVAR3
        CPX     GRBTOP               ;Compare low orders.
        BCC     DVARTS               ;[X,a] .le. [grbtop]*
DVAR3:
        STX     GRBTOP
        STA     GRBTOP + 1
        LDWX    INDEX1
        STWX    GRBPNT
        LDA     FOUR6
        STA     SIZE
DVARTS:
        LDA     FOUR6
        CLC
        ADC     INDEX1
        STA     INDEX1
        BCC     GRBRTS
        INC     INDEX1 + 1
GRBRTS:
        LDX     INDEX1 + 1
        LDY     #0
        RTS                          ;Done.

; Here when made one complete pass through string variables.

GRBPAS:
        LDA     GRBPNT + 1           ;Variable pointer.
        ORA     GRBPNT
        BEQ     GRBRTS               ;All done.
        LDA     SIZE
        AND     #4                   ;Leaves c off.
        LSR     A
        TAY
        STA     SIZE
        LDA     (GRBPNT),Y
                                     ;Note: grbtop=lowtr so no need to set lowtr.
        ADC     LOWTR
        STA     HIGHTR
        LDA     LOWTR + 1
        ADC     #0
        STA     HIGHTR + 1
        LDWX    FRETOP
        STWX    HIGHDS               ;Where it all goes.
        JSR     BLTUC
        LDY     SIZE
        INY
        LDA     HIGHDS               ;Get position of start of result.
        STA     (GRBPNT),Y
        TAX
        INC     HIGHDS + 1
        LDA     HIGHDS + 1
        INY
        STA     (GRBPNT),Y           ;Change addr of string in var.
        JMP     FNDVAR               ;Go to fndvar with something for
                                     ;[Fretop]*

; The following routine concatenates two strings.
; The fac contains the first one at this point.
; [Txtptr] points to the + sign.

CAT:
        LDA     FACLO                ;Psh high order onto stack.
        PHA
        LDA     FACMO                ;And the low.
        PHA
        JSR     EVAL                 ;Can come back here since
                                     ;Operator is known.
        JSR     CHKSTR               ;Result must be string.
        PLA
        STA     STRNG1               ;Get high order of old desc.
        PLA
        STA     STRNG1 + 1
        LDY     #0
        LDA     (STRNG1),Y           ;Get length of old string.
        CLC
        ADC     (FACMO),Y
        BCC     SIZEOK               ;Result is less than 256.
        LDX     #ERRLS               ;Error "long string"*
        JMP     ERROR
SIZEOK:
        JSR     STRINI               ;Initialize string.
        JSR     MOVINS               ;Move it.
        LDWD    DSCPNT               ;Get pointer to second.
        JSR     FRETMP               ;Free it.
        JSR     MOVDO
        LDWD    STRNG1
        JSR     FRETMP
        JSR     PUTNEW
        JMP     TSTOP                ;"Cat" reenters form eval at tstop.

MOVINS:
        LDY     #0                   ;Get addr of string.
        LDA     (STRNG1),Y
        PHA
        INY
        LDA     (STRNG1),Y
        TAX
        INY
        LDA     (STRNG1),Y
        TAY
        PLA
MOVSTR:
        STXY    INDEX
MOVDO:
        TAY
        BEQ     MVDONE
        PHA
MOVLP:
        DEY
        LDA     (INDEX),Y
        STA     (FRESPC),Y
QMOVE:
        TYA
        BNE     MOVLP
        PLA
MVDONE:
        CLC
        ADC     FRESPC
        STA     FRESPC
        BCC     MVSTRT
        INC     FRESPC + 1
MVSTRT:
        RTS

; "Fretmp" is passed a string descriptor pntr in [y,a]*
; A check is made to see if the string descriptor points to the last
; Temporary descriptor allocated by putnew.
; If so, the temporary is freed up by the updating of [temppt]*
; If a temp is freed up, a further check sees if the string data that
; That string temp pnt'd to is the lowest part of string space in use.
; If so, [fretop] is updated to reflect the fact the fact that the space
; Is no longer in use.
; The addr of the actual string is returned in [y,x] and
; Its length in acca.

FRESTR:
        JSR     CHKSTR               ;Make sure its a string.
FREFAC:
        LDWD    FACMO                ;Free up str pnt'd to by fac.
FRETMP:
        STWD    INDEX                ;Get length for later.
        JSR     FRETMS               ;Free up the temporary desc.
        PHP                          ;Save codes.
        LDY     #0                   ;Prep to get stuff.
        LDA     (INDEX),Y            ;Get count and
        PHA                          ;Save it.
        INY
        LDA     (INDEX),Y
        TAX                          ;Save low order.
        INY
        LDA     (INDEX),Y
        TAY                          ;Save high order.
        PLA
        PLP                          ;Return status.
        BNE     FRETRT
        CPY     FRETOP + 1           ;String is last one in?
        BNE     FRETRT
        CPX     FRETOP
        BNE     FRETRT
        PHA
        CLC
        ADC     FRETOP
        STA     FRETOP
        BCC     FREPLA
        INC     FRETOP + 1
FREPLA:
        PLA                          ;Get count back.
FRETRT:
        STXY    INDEX                ;Save for later use.
        RTS
FRETMS:
        CPY     LASTPT + 1           ;Last entry to temp?
        BNE     FRERTS
        CMP     LASTPT
        BNE     FRERTS
        STA     TEMPPT
        SBC     #STRSIZ              ;Point to last one.
        STA     LASTPT               ;Update temp pntr.
        LDY     #0                   ;Also clears zflg so we do rest of fretmp.
FRERTS:
        RTS                          ;All done.

; Chr$(#) creates a string which contains as its only
; Character the ascii equivalent of the integer argument (#)
; Which must be .lt. 255.

CHR:
        JSR     CONINT               ;Get integer in range.
        TXA
        PHA
        LDA     #1                   ;One-character string.
        JSR     STRSPA               ;Get space for string.
        PLA
        LDY     #0
        STA     (DSCTMP + 1),Y
        PLA                          ;Get rid of "chknum" return addr.
        PLA
RLZRET:
        JMP     PUTNEW               ;Setup fac to point to desc.

; The following is the left$($,#) function.
; It takes the leftmost # characters of the string.
; If # .gt. the len of the string, it returns the whole string.

LEFT:
        JSR     PREAM                ;Test parameters.
        CMP     (DSCPNT),Y
        TYA
RLEFT:
        BCC     RLEFT1
        LDA     (DSCPNT),Y
        TAX                          ;Put length into x.
        TYA                          ;Zero a, the offset.
RLEFT1:
        PHA                          ;Save offset.
RLEFT2:
        TXA
RLEFT3:
        PHA                          ;Save length.
        JSR     STRSPA               ;Get space.
        LDWD    DSCPNT
        JSR     FRETMP
        PLA
        TAY
        PLA
        CLC
        ADC     INDEX                ;Compute where to copy.
        STA     INDEX
        BCC     PULMOR
        INC     INDEX + 1
PULMOR:
        TYA
        JSR     MOVDO                ;Go move it.
        JMP     PUTNEW
RIGHT:
        JSR     PREAM
        CLC                          ;[Length des'd]-[length]-1.
        SBC     (DSCPNT),Y
        EOR     #255                 ;Negate.
        JMP     RLEFT

; Mid ($,#) returns string with chars from # position
; Onward. if # .gt. len ($) then return null string.
; Mid ($,#,#) returns string with characters from
; # Position for #2 characters. if #2 goes past end of string
; Return as much as possible.

MID:
        LDA     #255                 ;Default.
        STA     FACLO                ;Save for later compare.
        JSR     CHRGOT               ;Get current character.
        CMP     #41                  ;Is it a right paren )?
        BEQ     MID2                 ;No third param.
        JSR     CHKCOM               ;Must have comma.
        JSR     GETBYT               ;Get the length into "faclo"*
MID2:
        JSR     PREAM                ;Check it out.
        BEQ     GOFUC                ;There is no postion 0
        DEX                          ;Compute offset.
        TXA
        PHA                          ;Prserve awhile.
        CLC
        LDX     #0
        SBC     (DSCPNT),Y           ;Get length of what's left.
        BCS     RLEFT2               ;Give null string.
        EOR     #255                 ;In sub c was 0 so just complement.
        CMP     FACLO                ;Greater than what's desired?
        BCC     RLEFT3               ;No, copy that much.
        LDA     FACLO                ;Get length of what's desired.
        BCS     RLEFT3               ;Copy it.

; Used by right$, left$, mid$ for parameter checking and setup.

PREAM:
        JSR     CHKCLS               ;Param list should end.
        PLA                          ;Get the return address into
        TAY                          ;[Jmper+1,y]
        PLA
        STA     JMPER + 1
        PLA                          ;Get rid of fingo's jsr ret addr.
        PLA
        PLA                          ;Get length.
        TAX
        PULWD   DSCPNT
        LDA     JMPER + 1            ;Put return address back on
        PHA
        TYA
        PHA
        LDY     #0
        TXA
        RTS

; The function len($) returns the length of the string
; Passed as an argument.

LEN:
        JSR     LEN1
        JMP     SNGFLT
LEN1:
        JSR     FRESTR               ;Free up string.
        LDX     #0
        STX     VALTYP               ;Force numeric.
        TAY                          ;Set codes on length.
        RTS                          ;Done.

; The following is the asc($) function. it returns
; An integer which is the decimal ascii equivalent.

ASC:
        JSR     LEN1
        BEQ     GOFUC                ;Null string, bad arg.
        LDY     #0
        LDA     (INDEX1),Y           ;Get character.
        TAY
        JMP     SNGFLT
GOFUC:
        JMP     FCERR                ;Yes.

GTBYTC:
        JSR     CHRGET
GETBYT:
        JSR     FRMNUM               ;Read formula into fac.
CONINT:
        JSR     POSINT               ;Convert the fac to a single byte int.
        LDX     FACMO
        BNE     GOFUC                ;Result must be .le. 255.
        LDX     FACLO
CHRGO2:
        JMP     CHRGOT               ;Set condition codes on terminator.

; The "val" function takes a string and turns it into
; A number by interpreting the ascii digits etcq
; Except for the problem that a terminator must be supplied
; By replacing the character beyond the string, val is merely
; A call to floating point input ("fin")*

VAL:
        JSR     LEN1                 ;Do setup. set result=numeric.
        JEQ     ZEROFC               ;Zero the fac on a null string
        LDXY    TXTPTR
        STXY    STRNG2               ;Save for later.
        LDX     INDEX1
        STX     TXTPTR
        CLC
        ADC     INDEX1
        STA     INDEX2
        LDX     INDEX1 + 1
        STX     TXTPTR + 1
        BCC     VAL2                 ;No carry, no inc.
        INX
VAL2:
        STX     INDEX2 + 1
        LDY     #0
        LDA     (INDEX2),Y           ;Preserve character.
        PHA
        LDA     #0                   ;Set a terminator.
        STA     (INDEX2),Y
        JSR     CHRGOT               ;Get character pnt'd to and set flags.
        JSR     FIN
        PLA                          ;Get pres'd character.
        LDY     #0
        STA     (INDEX2),Y           ;Stuff it back.
ST2TXT:
        LDXY    STRNG2
        STXY    TXTPTR
VALRTS:
        RTS                          ;All done with strings.
        .page
        .subttl PEEK, POKE, AND FNWAIT.

GETNUM:
        JSR     FRMNUM               ;Get address.
        JSR     GETADR               ;Get that location.
COMBYT:
        JSR     CHKCOM               ;Check for a comma.
        JMP     GETBYT               ;Get something to store and return.
GETADR:
        LDA     FACSGN               ;Examine sign.
        BMI     GOFUC                ;Function call error.
        LDA     FACEXP               ;Examine exponent.
        CMP     #145
        BCS     GOFUC                ;Function call error.
        JSR     QINT                 ;Integerize it.
        LDWD    FACMO
        STY     POKER
        STA     POKER + 1
        RTS                          ;It's done !*

PEEK:
        PSHWD   POKER
        JSR     GETADR
        LDY     #0
        .if     REALIO == 3
        CMP     #ROMLOC / 256        ;If within basic
        BCC     GETCON
        CMP     #LASTWR / 256
        BCC     DOSGFL
        .endif
                                     ;Give him zero for an answer.
GETCON:
        LDA     (POKER),Y            ;Get that byte.
        TAY
DOSGFL:
        PULWD   POKER
        JMP     SNGFLT               ;Float it.

POKE:
        JSR     GETNUM
        TXA
        LDY     #0
        STA     (POKER),Y            ;Store value away.
        RTS                          ;Scanned  everything.

; The wait location,mask1,mask2 statement waits until the contents
; Of location is nonzero when xored with mask2
; And then anded with mask1. if mask2 is not present, it
; Is assumed to be zero.

FNWAIT:
        JSR     GETNUM
        STX     ANDMSK
        LDX     #0
        JSR     CHRGOT
        BEQ     ZSTORD
        JSR     COMBYT               ;Get mask2.
STORDO:
        STX     EORMSK
        LDY     #0
WAITER:
        LDA     (POKER),Y
        EOR     EORMSK
        AND     ANDMSK
        BEQ     WAITER
ZERRTS:
        RTS                          ;Got a nonzero.
        .subttl FLOATING POINT MATH PACKAGE CONFIGURATION.

;Radix	8			;!!!! alert !!!!
                                     ;Throughout the math package.

; The floating point format is as follows:

; The sign is the first bit of the mantissa.
; The mantissa is 24 bits long.
; The binary point is to the left of the msb.
; Number = mantissa * 2 ^ exponent.
; The mantissa is positive with a one assumed to be where the sign bit is.
; The sign of the exponent is the first bit of the exponent.
; The exponent is stored in excess 200, i.e. with a bias of +200.
; So, the exponent is a signed 8-bit number with 200 added to it.
; An exponent of zero means the number is zero.
; The other bytes may not be assumed to be zero.
; To keep the same number in the fac while shifting,
; 	To shift right, exp:=exp+1
; 	To shift left,	exp:=exp-1

; In memory the number looks like this:
; 	[The exponent as a signed number +200]
; 	[The sign bit in 7, bits 2-8 of mantissa are in bits 6-0].
; 		(Remember bit 1 of mantissa is always a one.)
; 	[Bits 9-16 of the mantissa]
; 	[Bits 17-24] of the mantissa]

; Arithmetic routine calling conventions:

; For one argument functions:
; 	The argument is in the fac.
; 	The result is left in the fac.
; For two argument operations:
; 	The first argument is in arg (argexp,ho,mo,lo and argsgn).
; 	The second argument is in the fac.
; 	The result is left in the fac.

; The "t" entry points to the two-argument operations have both arguments
; Setup in the respective registers. before calling arg may have been
; Popped off the stack and into arg, for example.
; The other entry point assumes [y,a] points to the argument
; Somewhere in memory. it is unpacked into arg by "conupk".

; On the stack, the sgn is pushed on first, the lo,mo,ho and finally exp.
; Note all things are kept unpacked in arg, fac and on the stack.

; It is only when something is stored away that it is packed to four
; Bytes. the unpacked format has a sgn byte reflecting the sign of the
; Number (positive=0, negative=-1) a ho,mo and lo with the high bit
; Of the ho turned on. the exp is the same as stored format.
; This is done for speed of operation.

        .page
        .subttl FLOATING POINT ADDITION AND SUBTRACTION.
FADDH:
        LDWDI   FHALF                ;Entry to add 1/2.
        JMP     FADD                 ;Unpack and go add it.
FSUB:
        JSR     CONUPK               ;Unpack argument into arg.
FSUBT:
        LDA     FACSGN
        EOR     #0o377               ;Complement it.
        STA     FACSGN
        EOR     ARGSGN               ;Complement arisgn.
        STA     ARISGN
        LDA     FACEXP               ;Set codes on facexp.
        JMP     FADDT                ;[Y]=argexp..
                                     ; Xlist
; .Xcref
        .if     REALIO != 3
ZSTORD  =       STORDO
        .endif
        .if     REALIO == 3
ZSTORD:
        LDA     POKER
        CMP     #0o146
        BNE     STORDO
        LDA     POKER + 1
        SBC     #0o31
        BNE     STORDO
        STA     POKER
        TAY
        LDA     #0o200
        STA     POKER + 1
MRCHKR:
        LDX     #0o12
        .if     1
MRCHR:
        LDA     0o60000,X
        .endif
        .if     1
MRCHR:
        LDA     SINCON + 0o36,X
        .endif
        AND     #0o77
        STA     (POKER),Y
        INY
        BNE     PKINC
        INC     POKER + 1
PKINC:
        DEX
        BNE     MRCHR
        DEC     ANDMSK
        BNE     MRCHKR
        RTS
        .if     1
; Purge zstord
        .endif
        .endif
; .Cref
        .byte   LIST
FADD5:
        JSR     SHIFTR               ;Do a long shift.
        BCC     FADD4                ;Continue with addition.
FADD:
        JSR     CONUPK
FADDT:
        JEQ     MOVFA                ;If fac=0, result is in arg.
        LDX     FACOV
        STX     OLDOV
        LDX     #ARGEXP              ;Default is shift argument.
        LDA     ARGEXP               ;If arg=0, fac is result.
FADDC:
        TAY                          ;Also copy acca into accy.
        BEQ     ZERRTS               ;Return.
        SEC
        SBC     FACEXP
        BEQ     FADD4                ;No shifting.
        BCC     FADDA                ;Br if argexp.lt.facexp.
        STY     FACEXP               ;Resulting exponent.
        LDY     ARGSGN               ;Since arg is bigger, it's
        STY     FACSGN               ;Sign is sign of result.
        EOR     #0o377               ;Shift a negative number of places.
        ADC     #0                   ;Complete negation. w/ c=1.
        LDY     #0                   ;Zero oldov.
        STY     OLDOV
        LDX     #FAC                 ;Shift the fac instead.
        BNE     FADD1
FADDA:
        LDY     #0
        STY     FACOV
FADD1:
        CMP     #0o256 - 7           ;For speed and necessity.  gets
                                     ;Most likely case to shiftr fastest
                                     ;And allows shifting of neg nums
                                     ;By "qint"*
        BMI     FADD5                ;Shift big.
        TAY
        LDA     FACOV                ;Set facov.
        LSR     1,X                  ;Gets 0 in most sig bit.
        JSR     ROLSHF               ;Do the rolling.
FADD4:
        BIT     ARISGN               ;Get resulting sign.
        BPL     FADD2                ;If positive, add.
                                     ;Carry is clear.
FADD3:
        LDY     #FACEXP
        CPX     #ARGEXP              ;Fac is bigger.
        BEQ     SUBIT
        LDY     #ARGEXP              ;Arg is bigger.
SUBIT:
        SEC
        EOR     #0o377
        ADC     OLDOV
        STA     FACOV
        LDA     3 + ADDPRC,Y
        SBC     3 + ADDPRC,X
        STA     FACLO
        LDA     2 + ADDPRC,Y
        SBC     2 + ADDPRC,X
        STA     FACMO
        .if     ADDPRC != 0
        LDA     2,Y
        SBC     2,X
        STA     FACMOH
        .endif
        LDA     1,Y
        SBC     1,X
        STA     FACHO
FADFLT:
        BCS     NORMAL               ;Here if signs differ. if carry
                                     ;Fac is set ok.
        JSR     NEGFAC               ;Negate [fac]*
NORMAL:
        LDY     #0
        TYA
        CLC
NORM3:
        LDX     FACHO
        BNE     NORM1
        LDX     FACHO + 1            ;Shift 8 bits at a time for speed.
        STX     FACHO
        .if     ADDPRC != 0
        LDX     FACMOH + 1
        STX     FACMOH
        .endif
        LDX     FACMO + 1
        STX     FACMO
        LDX     FACOV
        STX     FACLO
        STY     FACOV
        ADC     #0o10
        CMP     #0o10 * ADDPRC + 0o30
        BNE     NORM3
ZEROFC:
        LDA     #0                   ;Not need by normal but by others.
ZEROF1:
        STA     FACEXP               ;Number must be zero.
ZEROML:
        STA     FACSGN               ;Make sign positive.
        RTS                          ;All done.
FADD2:
        ADC     OLDOV
        STA     FACOV
        LDA     FACLO
        ADC     ARGLO
        STA     FACLO
        LDA     FACMO
        ADC     ARGMO
        STA     FACMO
        .if     ADDPRC != 0
        LDA     FACMOH
        ADC     ARGMOH
        STA     FACMOH
        .endif
        LDA     FACHO
        ADC     ARGHO
        STA     FACHO
        JMP     SQUEEZ               ;Go round if signs same.

NORM2:
        ADC     #1                   ;Decrement shift count.
        ASL     FACOV                ;Shift all left one bit.
        ROL     FACLO
        ROL     FACMO
        .if     ADDPRC != 0
        ROL     FACMOH
        .endif
        ROL     FACHO
NORM1:
        BPL     NORM2                ;If msb=0 shift again.
        SEC
        SBC     FACEXP
        BCS     ZEROFC
        EOR     #0o377
        ADC     #1                   ;Complement.
        STA     FACEXP
SQUEEZ:
        BCC     RNDRTS               ;Bits to shift?
RNDSHF:
        INC     FACEXP
        BEQ     OVERR
        ROR     FACHO
        .if     ADDPRC != 0
        ROR     FACMOH
        .endif
        ROR     FACMO
        ROR     FACLO
        ROR     FACOV
RNDRTS:
        RTS                          ;All done adding.

NEGFAC:
        COM     FACSGN               ;Complement fac	 entirely.
NEGFCH:
        COM     FACHO                ;Complement just the number.
        .if     ADDPRC != 0
        COM     FACMOH
        .endif
        COM     FACMO
        COM     FACLO
        COM     FACOV
        INC     FACOV
        BNE     INCFRT
INCFAC:
        INC     FACLO
        BNE     INCFRT
        INC     FACMO
        BNE     INCFRT               ;If no carry, return.
        .if     ADDPRC != 0
        INC     FACMOH
        BNE     INCFRT
        .endif
        INC     FACHO                ;Carry increment.
INCFRT:
        RTS

OVERR:
        LDX     #ERROV
        JMP     ERROR                ;Tell user.

; "Shiftr" shifts [x+1:x+3] [-acca]  bits right.
; Shifts bytes to start with if possible.

MULSHF:
        LDX     #RESHO - 1           ;Entry point for multiplier.
SHFTR2:
        LDY     3 + ADDPRC,X         ;Shift bytes first.
        STY     FACOV
        .if     ADDPRC != 0
        LDY     3,X
        STY     4,X
        .endif
        LDY     2,X                  ;Get mo.
        STY     3,X                  ;Store lo.
        LDY     1,X                  ;Get ho.
        STY     2,X                  ;Store mo.
        LDY     BITS
        STY     1,X                  ;Store ho.
SHIFTR:
        ADC     #0o10
        BMI     SHFTR2
        BEQ     SHFTR2
        SBC     #0o10                ;C can be either 1,0 and it works.
        TAY
        LDA     FACOV
        BCS     SHFTRT               ;Equiv to beq here.
        .if     RORSW != 0
SHFTR3:
        ASL     1,X
        BCC     SHFTR4
        INC     1,X
SHFTR4:
        ROR     1,X
        ROR     1,X
        .endif
                                     ;Yes, two of them.
        .if     RORSW == 0
SHFTR3:
        PHA
        LDA     1,X
        AND     #0o200
        LSR     1,X
        ORA     1,X
        STA     1,X
        SKIP1
        .endif
ROLSHF:
        .if     RORSW != 0
        ROR     2,X
        ROR     3,X
        .if     ADDPRC != 0
        ROR     4,X
        .endif
                                     ;One mo time.
        .endif
        .if     RORSW == 0
        PHA
        LDA     #0
        BCC     SHFTR5
        LDA     #0o200
SHFTR5:
        LSR     2,X
        ORA     2,X
        STA     2,X
        LDA     #0
        BCC     SHFTR6
        LDA     #0o200
SHFTR6:
        LSR     3,X
        ORA     3,X
        STA     3,X
        .if     ADDPRC != 0
        LDA     #0
        BCC     SHFT6A
        LDA     #0o200
SHFT6A:
        LSR     4,X
        ORA     4,X
        STA     4,X
        .endif
        .endif
        .if     RORSW != 0
        ROR     A
        .endif
                                     ;Rotate argument 1 bit right.
        .if     RORSW == 0
        PLA
        PHP
        LSR     A
        PLP
        BCC     SHFTR7
        ORA     #0o200
        .endif
SHFTR7:
        INY
        BNE     SHFTR3               ;$$$ ( Most expensive ! )
SHFTRT:
        CLC                          ;Clear output of facov.
        RTS
        .page
        .subttl NATURAL LOG FUNCTION.

; Calculation is by:
; Ln(f*2^n)=(n+log2(f))*ln(2)
; An approximation polynomial is used to calculate log2(f)*
;  Constants used by log:
FONE:
        .byte   0o201                ; 1.0
        .byte   0
        .byte   0
        .byte   0
        .if     ADDPRC != 0
        .byte   0
        .endif
        .if     ADDPRC == 0
LOGCN2:
        .byte   2                    ; Degree-1
        .byte   0o200                ; 0.59897437
        .byte   0o031
        .byte   0o126
        .byte   0o142
        .byte   0o200                ; 0.96147080
        .byte   0o166
        .byte   0o042
        .byte   0o363
        .byte   0o202                ; 2.88539129
        .byte   0o070
        .byte   0o252
        .byte   0o100
        .endif

        .if     ADDPRC != 0
LOGCN2:
        .byte   3                    ;Degree-1
        .byte   0o177                ;.43425594188
        .byte   0o136
        .byte   0o126
        .byte   0o313
        .byte   0o171
        .byte   0o200                ; .57658454134
        .byte   0o023
        .byte   0o233
        .byte   0o013
        .byte   0o144
        .byte   0o200                ; .96180075921
        .byte   0o166
        .byte   0o070
        .byte   0o223
        .byte   0o026
        .byte   0o202                ; 2.8853900728
        .byte   0o070
        .byte   0o252
        .byte   0o073
        .byte   0o040
        .endif
SQRHLF:
        .byte   0o200                ; Sqr(0.5)
        .byte   0o065
        .byte   4
        .byte   0o363
        .if     ADDPRC != 0
        .byte   0o064
        .endif
SQRTWO:
        .byte   0o201                ; Sqr(2.0)
        .byte   0o065
        .byte   4
        .byte   0o363
        .if     ADDPRC != 0
        .byte   0o064
        .endif
NEGHLF:
        .byte   0o200                ; -1/2
        .byte   0o200
        .byte   0
        .byte   0
        .if     ADDPRC != 0
        .byte   0
        .endif
LOG2:
        .byte   0o200                ; Ln(2)
        .byte   0o061
        .byte   0o162
        .if     ADDPRC == 0
        .byte   0o030
        .endif
        .if     ADDPRC != 0
        .byte   0o027
        .byte   0o370
        .endif

LOG:
        JSR     SIGN                 ;Is it positive?
        BEQ     LOGERR
        BPL     LOG1
LOGERR:
        JMP     FCERR                ;Can't tolerate neg or zero.
LOG1:
        LDA     FACEXP               ;Get exponent into acca.
        SBC     #0o177               ;Remove bias. (carry is off)
        PHA                          ;Save awhile.
        LDA     #0o200
        STA     FACEXP               ;Result is fac in range [0.5,1]*
        LDWDI   SQRHLF               ;Get pointer to sqr(0.5)*

; Calculate (f-sqr(.5))/(f+sqr(.5))

        JSR     FADD                 ;Add to fac.
        LDWDI   SQRTWO               ;Get sqr(2.)*
        JSR     FDIV
        LDWDI   FONE
        JSR     FSUB
        LDWDI   LOGCN2
        JSR     POLYX                ;Evaluate approximation polynomial.
        LDWDI   NEGHLF               ;Add in last constant.
        JSR     FADD
        PLA                          ;Get exponent back.
        JSR     FINLOG               ;Add it in.
MULLN2:
        LDWDI   LOG2                 ;Multiply result by log(2.0)*
;	Jmp	fmult		;multiply together.
        .page
        .subttl FLOATING MULTIPLICATION AND DIVISION.
                                     ;Multiplication		fac:=arg*fac.
FMULT:
        JSR     CONUPK               ;Unpack the constant into arg for use.
FMULTT:
        JEQ     MULTRT               ;If fac=0, return. fac is set.
        JSR     MULDIV               ;Fix up the exponents.
        LDA     #0                   ;To clear result.
        STA     RESHO
        .if     ADDPRC != 0
        STA     RESMOH
        .endif
        STA     RESMO
        STA     RESLO
        LDA     FACOV
        JSR     MLTPLY
        LDA     FACLO                ;Mltply arg by faclo.
        JSR     MLTPLY
        LDA     FACMO                ;Mltply arg by facmo.
        JSR     MLTPLY
        .if     ADDPRC != 0
        LDA     FACMOH
        JSR     MLTPLY
        .endif
        LDA     FACHO                ;Mltply arg by facho.
        JSR     MLTPL1
        JMP     MOVFR                ;Move result into fac
                                     ;Normalize result, and return.
MLTPLY:
        JEQ     MULSHF               ;Shift result right 1 byte.
MLTPL1:
        LSR     A
        ORA     #0o200
MLTPL2:
        TAY
        BCC     MLTPL3               ;It mult bit=0, just shift.
        CLC
        LDA     RESLO
        ADC     ARGLO
        STA     RESLO
        LDA     RESMO
        ADC     ARGMO
        STA     RESMO
        .if     ADDPRC != 0
        LDA     RESMOH
        ADC     ARGMOH
        STA     RESMOH
        .endif
        LDA     RESHO
        ADC     ARGHO
        STA     RESHO
MLTPL3:
        ROR     RESHO
        .if     ADDPRC != 0
        ROR     RESMOH
        .endif
        ROR     RESMO
        ROR     RESLO
        ROR     FACOV                ;Save for rounding.
        TYA
        LSR     A                    ;Clear msb so we get a closer to 0.
        BNE     MLTPL2               ;Slow as a turtle !
MULTRT:
        RTS

                                     ;Routine to unpack memory into arg.
CONUPK:
        STWD    INDEX1
        LDY     #3 + ADDPRC
        LDA     (INDEX1),Y
        STA     ARGLO
        DEY
        LDA     (INDEX1),Y
        STA     ARGMO
        DEY
        .if     ADDPRC != 0
        LDA     (INDEX1),Y
        STA     ARGMOH
        DEY
        .endif
        LDA     (INDEX1),Y
        STA     ARGSGN
        EOR     FACSGN
        STA     ARISGN
        LDA     ARGSGN
        ORA     #0o200
        STA     ARGHO
        DEY
        LDA     (INDEX1),Y
        STA     ARGEXP
        LDA     FACEXP               ;Set codes of facexp.
        RTS

                                     ;Check special cases and add exponents for fmult, fdiv.
MULDIV:
        LDA     ARGEXP               ;Exp of arg=0?
MLDEXP:
        BEQ     ZEREMV               ;So we get zero exponent.
        CLC
        ADC     FACEXP               ;Result is in acca.
        BCC     TRYOFF               ;Find [c] xor [n]*
        BMI     GOOVER               ;Overflow if bits match.
        CLC
        SKIP2
TRYOFF:
        BPL     ZEREMV               ;Underflow.
        ADC     #0o200               ;Add bias.
        STA     FACEXP
        JEQ     ZEROML               ;Zero the rest of it.
        LDA     ARISGN
        STA     FACSGN               ;Arisgn is result's sign.
        RTS                          ;Done.
MLDVEX:
        LDA     FACSGN               ;Get sign.
        EOR     #0o377               ;Complement it.
        BMI     GOOVER
ZEREMV:
        PLA                          ;Get addr off stack.
        PLA
        JMP     ZEROFC               ;Underflow.
GOOVER:
        JMP     OVERR                ;Overflow.

                                     ;Multiply fac by 10.
MUL10:
        JSR     MOVAF                ;Copy fac into arg.
        TAX
        BEQ     MUL10R               ;If [fac]=0, got answer.
        CLC
        ADC     #2                   ;Augment exp by 2.
        BCS     GOOVER               ;Overflow.
FINML6:
        LDX     #0
        STX     ARISGN               ;Signs are same.
        JSR     FADDC                ;Add together.
        INC     FACEXP               ;Multiply by two.
        BEQ     GOOVER               ;Overflow.
MUL10R:
        RTS

                                     ; Divide fac by 10.
TENZC:
        .byte   0o204
        .byte   0o040
        .byte   0
        .byte   0
        .if     ADDPRC != 0
        .byte   0
        .endif
DIV10:
        JSR     MOVAF                ;Move fac to arg.
        LDWDI   TENZC                ;Point to constant of 10.0
        LDX     #0                   ;Signs are both positive.
FDIVF:
        STX     ARISGN
        JSR     MOVFM                ;Put it into fac.
        JMP     FDIVT                ;Skip over next two bytes.
FDIV:
        JSR     CONUPK               ;Unpack constant.
FDIVT:
        BEQ     DV0ERR               ;Can't divide by zero !
                                     ;(Not enough room to store result.)
        JSR     ROUND                ;Take facov into acct in fac.
        LDA     #0                   ;Negate facexp.
        SEC
        SBC     FACEXP
        STA     FACEXP
        JSR     MULDIV               ;Fix up exponents.
        INC     FACEXP               ;Scale it right.
        BEQ     GOOVER               ;Overflow.
        LDX     #0o256 - 3 - ADDPRC  ;Setup procedure.
        LDA     #1
DIVIDE:
                                     ;This is the best code in the whole pile.
        LDY     ARGHO                ;See what relation holds.
        CPY     FACHO
        BNE     SAVQUO               ;[C]=0,1. n(c=0)=0.
        .if     ADDPRC != 0
        LDY     ARGMOH
        CPY     FACMOH
        BNE     SAVQUO
        .endif
        LDY     ARGMO
        CPY     FACMO
        BNE     SAVQUO
        LDY     ARGLO
        CPY     FACLO
SAVQUO:
        PHP
        ROL     A                    ;Save result.
        BCC     QSHFT                ;If not done, continue.
        INX
        STA     RESLO,X
        BEQ     LD100
        BPL     DIVNRM               ;Note this req 1 mo ram then necess.
        LDA     #1
QSHFT:
        PLP                          ;Return condition codes.
        BCS     DIVSUB               ;Fac .le. arg.
SHFARG:
        ASL     ARGLO                ;Shift arg one place left.
        ROL     ARGMO
        .if     ADDPRC != 0
        ROL     ARGMOH
        .endif
        ROL     ARGHO
        BCS     SAVQUO               ;Save a result of one for this position
                                     ;And divide.
        BMI     DIVIDE               ;If msb on, go decide whether to sub.
        BPL     SAVQUO
DIVSUB:
        TAY                          ;Notice c must be on here.
        LDA     ARGLO
        SBC     FACLO
        STA     ARGLO
        LDA     ARGMO
        SBC     FACMO
        STA     ARGMO
        .if     ADDPRC != 0
        LDA     ARGMOH
        SBC     FACMOH
        STA     ARGMOH
        .endif
        LDA     ARGHO
        SBC     FACHO
        STA     ARGHO
        TYA
        JMP     SHFARG
LD100:
        LDA     #0o100               ;Only want two more bits.
        BNE     QSHFT                ;Always branches.
DIVNRM:
        .repeat 6
        ASL     A
        .endrepeat
                                     ;Get last two bits into msb and b6.
        STA     FACOV
        PLP                          ;To get garbage off stack.
        JMP     MOVFR                ;Move result into fac, then
                                     ;Normalize result and return.
DV0ERR:
        LDX     #ERRDV0
        JMP     ERROR
        .page
        .subttl FLOATING POINT MOVEMENT ROUTINES.
                                     ;Move result to fac.
MOVFR:
        LDA     RESHO
        STA     FACHO
        .if     ADDPRC != 0
        LDA     RESMOH
        STA     FACMOH
        .endif
        LDA     RESMO
        STA     FACMO
        LDA     RESLO                ;Move lo and sgn.
        STA     FACLO
        JMP     NORMAL               ;All done.

                                     ;Move memory into fac (unpacked)*
MOVFM:
        STWD    INDEX1
        LDY     #3 + ADDPRC
        LDA     (INDEX1),Y
        STA     FACLO
        DEY
        LDA     (INDEX1),Y
        STA     FACMO
        DEY
        .if     ADDPRC != 0
        LDA     (INDEX1),Y
        STA     FACMOH
        DEY
        .endif
        LDA     (INDEX1),Y
        STA     FACSGN
        ORA     #0o200
        STA     FACHO
        DEY
        LDA     (INDEX1),Y
        STA     FACEXP               ;Leave switches set on exp.
        STY     FACOV
        RTS

                                     ;Move number from fac to memory.
MOV2F:
        LDX     #TEMPF2
        SKIP2
MOV1F:
        LDX     #TEMPF1
MOVML:
        LDY     #0
        BEQ     MOVMF                ;Always branches.
MOVVF:
        LDXY    FORPNT
MOVMF:
        JSR     ROUND
        STXY    INDEX1
        LDY     #3 + ADDPRC
        LDA     FACLO
        STA     (INDEX),Y
        DEY
        LDA     FACMO
        STA     (INDEX),Y
        DEY
        .if     ADDPRC != 0
        LDA     FACMOH
        STA     (INDEX),Y
        DEY
        .endif
        LDA     FACSGN               ;Include sign in ho.
        ORA     #0o177
        AND     FACHO
        STA     (INDEX),Y
        DEY
        LDA     FACEXP
        STA     (INDEX),Y
        STY     FACOV                ;Zero it since rounded.
        RTS                          ;[Y]=0.

                                     ;Move arg into fac.
MOVFA:
        LDA     ARGSGN
MOVFA1:
        STA     FACSGN
        LDX     #4 + ADDPRC
MOVFAL:
        LDA     ARGEXP - 1,X
        STA     FACEXP - 1,X
        DEX
        BNE     MOVFAL
        STX     FACOV
        RTS

                                     ;Move fac into arg.
MOVAF:
        JSR     ROUND
MOVEF:
        LDX     #5 + ADDPRC
MOVAFL:
        LDA     FACEXP - 1,X
        STA     ARGEXP - 1,X
        DEX
        BNE     MOVAFL
        STX     FACOV                ;Zero it since rounded.
MOVRTS:
        RTS

ROUND:
        LDA     FACEXP               ;Zero?
        BEQ     MOVRTS               ;Yes. done rounding.
        ASL     FACOV                ;Round?
        BCC     MOVRTS               ;No. msb off.
INCRND:
        JSR     INCFAC               ;Yes, add one to lsb(fac)*
        BNE     MOVRTS               ;No carry means done.
        JMP     RNDSHF               ;Squeez msb in and rts.
                                     ;Note [c]=1 since incfac doesnt touch c.
        .page
        .subttl SIGN, SGN, FLOAT, NEG, ABS.

                                     ;Put sign of fac in acca.
SIGN:
        LDA     FACEXP
        BEQ     SIGNRT               ;If number is zero, so is result.
FCSIGN:
        LDA     FACSGN
FCOMPS:
        ROL     A
        LDA     #0o377               ;Assume negative.
        BCS     SIGNRT
        LDA     #1                   ;Get +1.
SIGNRT:
        RTS

                                     ;Sgn function.
SGN:
        JSR     SIGN

                                     ;Float the signed integer in acca.
FLOAT:
        STA     FACHO                ;Put [acca] in high order.
        LDA     #0
        STA     FACHO + 1
        LDX     #0o210               ;Get the exponent.

                                     ;Float the signed number in fac.
FLOATS:
        LDA     FACHO
        EOR     #0o377
        ROL     A                    ;Get comp of sign in carry.
FLOATC:
        LDA     #0                   ;Zero [acca] but not carry.
        STA     FACLO
        .if     ADDPRC != 0
        STA     FACMO
        .endif
FLOATB:
        STX     FACEXP
        STA     FACOV
        STA     FACSGN
        JMP     FADFLT

                                     ;Absolute value of fac.
ABS:
        LSR     FACSGN
        RTS

        .page
        .subttl COMPARE TWO NUMBERS.
                                     ;A=1 if arg .lt. fac.
                                     ;A=0 if arg=fac.
                                     ;A=-1 if arg .gt. fac.
FCOMP:
        STA     INDEX2
FCOMPN:
        STY     INDEX2 + 1
        LDY     #0
        LDA     (INDEX2),Y           ;Has argexp.
        INY                          ;Bump pntr up.
        TAX                          ;Save a in x and reset codes.
        BEQ     SIGN
        LDA     (INDEX2),Y
        EOR     FACSGN               ;Signs the same.
        BMI     FCSIGN               ;Signs differ so result is
                                     ;Sign of fac again.
FOUTCP:
        CPX     FACEXP
        BNE     FCOMPC
        LDA     (INDEX2),Y
        ORA     #0o200
        CMP     FACHO
        BNE     FCOMPC
        INY
        .if     ADDPRC != 0
        LDA     (INDEX2),Y
        CMP     FACMOH
        BNE     FCOMPC
        INY
        .endif
        LDA     (INDEX2),Y
        CMP     FACMO
        BNE     FCOMPC
        INY
        LDA     #0o177
        CMP     FACOV
        LDA     (INDEX2),Y
        SBC     FACLO                ;Get zero if equal.
        BEQ     QINTRT
FCOMPC:
        LDA     FACSGN
        BCC     FCOMPD
        EOR     #0o377
FCOMPD:
        JMP     FCOMPS               ;A part of sign sets acca up.

        .page
        .subttl GREATEST INTEGER FUNCTION.
                                     ;Quick greatest integer function.
                                     ;Leaves int(fac) in facho&mo&lo signed.
                                     ;Assumes fac .lt. 2^23 = 8388608
QINT:
        LDA     FACEXP
        BEQ     CLRFAC               ;If zero, got it.
        SEC
        SBC     #8 * ADDPRC + 0o230  ;Get number of places to shift.
        BIT     FACSGN
        BPL     QISHFT
        TAX
        LDA     #0o377
        STA     BITS                 ;Put 377 in when shftr shifts bytes.
        JSR     NEGFCH               ;Truly negate quantity in fac.
        TXA
QISHFT:
        LDX     #FAC
        CMP     #0o256 - 7
        BPL     QINT1                ;If number of places .ge. 7
                                     ;Shift 1 place at a time.
        JSR     SHIFTR               ;Start shifting bytes, then bits.
        STY     BITS                 ;Zero bits since adder wants zero.
QINTRT:
        RTS
QINT1:
        TAY                          ;Put count in counter.
        LDA     FACSGN
        AND     #0o200               ;Get sign bit.
        LSR     FACHO                ;Save first shifted byte.
        ORA     FACHO
        STA     FACHO
        JSR     ROLSHF               ;Shift the rest.
        STY     BITS                 ;Zero [bits]*
        RTS

                                     ;Greatest integer function.
INT:
        LDA     FACEXP
        CMP     #8 * ADDPRC + 0o230
        BCS     INTRTS               ;Forget it.
        JSR     QINT
        STY     FACOV                ;Clr overflow byte.
        LDA     FACSGN
        STY     FACSGN               ;Make fac look positive.
        EOR     #0o200               ;Get complement of sign in carry.
        ROL     A
        LDA     #8 * ADDPRC + 0o230
        STA     FACEXP
        LDA     FACLO
        STA     INTEGR
        JMP     FADFLT
CLRFAC:
        STA     FACHO                ;Make it really zero.
        .if     ADDPRC != 0
        STA     FACMOH
        .endif
        STA     FACMO
        STA     FACLO
        TAY
INTRTS:
        RTS
        .page
        .subttl FLOATING POINT INPUT ROUTINE.
                                     ;Number input is left in fac.
                                     ;At entry [txtptr] points to the first character in a text buffer.
                                     ;The first character is also in acca. fin packs the digits
                                     ;Into the fac as an integer and keeps track of where the
                                     ;Decimal point is. [dptflg] tell whether a dp has been
                                     ;Seen. [deccnt] is the number of digits after the dp.
                                     ;At the end [deccnt] and the exponent are used to
                                     ;Determine how many times to multiply or divide by ten
                                     ;To get the correct number.
FIN:
        LDY     #0                   ;Zero facsgn&sgnflg.
        LDX     #0o11 + ADDPRC       ;Zero exp and ho (and moh)*
FINZLP:
        STY     DECCNT,X             ;Zero mo and lo.
        DEX                          ;Zero tenexp and expsgn
        BPL     FINZLP               ;Zero deccnt, dptflg.
        BCC     FINDGQ               ;Flags still set from chrget.
        CMP     #"-"                 ;A negative sign?
        BNE     QPLUS                ;No, try plus sign.
        STX     SGNFLG               ;It's negative. (x=377)*
        BEQ     FINC                 ;Always branches.
QPLUS:
        CMP     #"+"                 ;Plus sign?
        BNE     FIN1                 ;Yes, skip it.
FINC:
        JSR     CHRGET
FINDGQ:
        BCC     FINDIG
FIN1:
        CMP     #"*"                 ;The dp?
        BEQ     FINDP                ;No kidding.
        CMP     #"E"                 ;Exponent follows.
        BNE     FINE                 ;No.
                                     ;Here to check for sign of exp.
        JSR     CHRGET               ;Yes. get another.
        BCC     FNEDG1               ;It is a digit. (easier than
                                     ;Backing up pointer.)
        CMP     #MINUTK              ;Minus?
        BEQ     FINEC1               ;Negate.
        CMP     #"-"                 ;Minus sign?
        BEQ     FINEC1
        CMP     #PLUSTK              ;Plus?
        BEQ     FINEC
        CMP     #"+"                 ;Plus sign?
        BEQ     FINEC
        BNE     FINEC2
FINEC1:
        ROR     EXPSGN               ;Turn it on.
FINEC:
        JSR     CHRGET               ;Get another.
FNEDG1:
        BCC     FINEDG               ;It is a digit.
FINEC2:
        BIT     EXPSGN
        BPL     FINE
        LDA     #0
        SEC
        SBC     TENEXP
        JMP     FINE1
FINDP:
        ROR     DPTFLG
        BIT     DPTFLG
        BVC     FINC
FINE:
        LDA     TENEXP
FINE1:
        SEC
        SBC     DECCNT               ;Get number of places to shift.
        STA     TENEXP
        BEQ     FINQNG               ;Negate?
        BPL     FINMUL               ;Positive so multiply.
FINDIV:
        JSR     DIV10
        INC     TENEXP               ;Done?
        BNE     FINDIV               ;No.
        BEQ     FINQNG               ;Yes.
FINMUL:
        JSR     MUL10
        DEC     TENEXP               ;Done?
        BNE     FINMUL               ;No
FINQNG:
        LDA     SGNFLG
        BMI     NEGXQS               ;If positive, return.
        RTS
NEGXQS:
        JMP     NEGOP                ;Otherwise, negate and return.

FINDIG:
        PHA
        BIT     DPTFLG
        BPL     FINDG1
        INC     DECCNT
FINDG1:
        JSR     MUL10
        PLA                          ;Get it back.
        SEC
        SBC     #"0"
        JSR     FINLOG               ;Add it in.
        JMP     FINC

FINLOG:
        PHA
        JSR     MOVAF                ;Save fac for later.
        PLA
        JSR     FLOAT                ;Float the value in acca.
        LDA     ARGSGN
        EOR     FACSGN
        STA     ARISGN               ;Resultant sign.
        LDX     FACEXP               ;Set signs on thing to add.
        JMP     FADDT                ;Add together and return.

                                     ;Here pack in the next digit of the exponent.
                                     ;Multiply the old exp by 10 and add in the next
                                     ;Digit. note: exp overflow is not checked for.
FINEDG:
        LDA     TENEXP               ;Get exp so far.
        CMP     #0o12                ;Will result be .ge. 100?
        BCC     MLEX10
        LDA     #0o144               ;Get 100.
        BIT     EXPSGN
        BMI     MLEXMI               ;If neg exp, no chk for overr.
        JMP     OVERR
MLEX10:
        ASL     A                    ;Mult by 2 twice
        ASL     A
        CLC                          ;Possible shift out of high.
        ADC     TENEXP               ;Like multiplying by five.
        ASL     A                    ;And now by ten.
        CLC
        LDY     #0
        ADC     (TXTPTR),Y
        SEC
        SBC     #"0"
MLEXMI:
        STA     TENEXP               ;Save result.
        JMP     FINEC
        .page
        .subttl FLOATING POINT OUTPUT ROUTINE.

        .if     ADDPRC == 0
NZ0999:
        .byte   0o221                ; 99999.9499
        .byte   0o103
        .byte   0o117
        .byte   0o370
NZ9999:
        .byte   0o224                ; 999999.499
        .byte   0o164
        .byte   0o043
        .byte   0o367
NZMIL:
        .byte   0o224                ; 10^6.
        .byte   0o164
        .byte   0o044
        .byte   0
        .endif
        .if     ADDPRC != 0
NZ0999:
        .byte   0o233                ; 99999999.9499
        .byte   0o076
        .byte   0o274
        .byte   0o037
        .byte   0o375
NZ9999:
        .byte   0o236                ; 999999999.499
        .byte   0o156
        .byte   0o153
        .byte   0o047
        .byte   0o375
NZMIL:
        .byte   0o236                ; 10^9
        .byte   0o156
        .byte   0o153
        .byte   0o050
        .byte   0
        .endif
                                     ;Entry to linprt.
INPRT:
        LDWDI   INTXT
        JSR     STROU2
        LDA     CURLIN + 1
        LDX     CURLIN
LINPRT:
        STWX    FACHO
        LDX     #0o220               ;Exponent of 16.
        SEC                          ;Number is positive.
        JSR     FLOATC
        JSR     FOUT
STROU2:
        JMP     STROUT               ;Print and return.

FOUT:
        LDY     #1
FOUTC:
        LDA     #" "                 ;Print space if positive.
        BIT     FACSGN
        BPL     FOUT1
        LDA     #"-"
FOUT1:
        STA     FBUFFR - 1,Y         ;Store the character.
        STA     FACSGN               ;Make fac pos for qint.
        STY     FBUFPT               ;Save for later.
        INY
        LDA     #"0"                 ;Get zero to type if fac=0.
        LDX     FACEXP
        JEQ     FOUT19
        LDA     #0
        CPX     #0o200               ;Is number .lt. 1.0 ?
        BEQ     FOUT37               ;No.
        BCS     FOUT7
FOUT37:
        LDWDI   NZMIL                ;Multiply by 10^6.
        JSR     FMULT
        LDA     #0o256 - 3 * ADDPRC - 6
FOUT7:
        STA     DECCNT               ;Save count or zero it.
FOUT4:
        LDWDI   NZ9999
        JSR     FCOMP                ;Is number .gt. 999999.499 ?
                                     ;Or 999999999.499?
        BEQ     BIGGES
        BPL     FOUT9                ;Yes. make it smaller.
FOUT3:
        LDWDI   NZ0999
        JSR     FCOMP                ;Is number .gt. 99999.9499 ?
                                     ; Or 99999999.9499?
        BEQ     FOUT38
        BPL     FOUT5                ;Yes. done multiplying.
FOUT38:
        JSR     MUL10                ;Make it bigger.
        DEC     DECCNT
        BNE     FOUT3                ;See if that does it.
                                     ;This always goes.
FOUT9:
        JSR     DIV10                ;Make it smaller.
        INC     DECCNT
        BNE     FOUT4                ;See if that does it.
                                     ;This always goes.

FOUT5:
        JSR     FADDH                ;Add a half to round up.
BIGGES:
        JSR     QINT
        LDX     #1                   ;Decimal point count.
        LDA     DECCNT
        CLC
        ADC     #3 * ADDPRC + 7      ;Should number be printed in e notation?
                                     ;Ie, is number .lt. .01 ?
        BMI     FOUTPI               ;Yes.
        CMP     #3 * ADDPRC + 0o10   ;Is it .gt. 999999 (999999999)?
        BCS     FOUT6                ;Yes. use e notation.
        ADC     #0o377               ;Number of places before decimal point.
        TAX                          ;Put into accx.
        LDA     #2                   ;No e notation.
FOUTPI:
        SEC
FOUT6:
        SBC     #2                   ;Effectively add 5 to orig exp.
        STA     TENEXP               ;That is the exponent to print.
        STX     DECCNT               ;Number of decimal places.
        TXA
        BEQ     FOUT39
        BPL     FOUT8                ;Some places before dec pnt.
FOUT39:
        LDY     FBUFPT               ;Get pointer to output.
        LDA     #"*"                 ;Put in "*"
        INY
        STA     FBUFFR - 1,Y
        TXA
        BEQ     FOUT16
        LDA     #"0"                 ;Get the ensuing zero.
        INY
        STA     FBUFFR - 1,Y
FOUT16:
        STY     FBUFPT               ;Save for later.
FOUT8:
        LDY     #0
FOUTIM:
        LDX     #0o200               ;First pass thru, accx has msb set.
FOUT2:
        LDA     FACLO
        CLC
        ADC     FOUTBL + 2 + ADDPRC,Y
        STA     FACLO
        LDA     FACMO
        ADC     FOUTBL + 1 + ADDPRC,Y
        STA     FACMO
        .if     ADDPRC != 0
        LDA     FACMOH
        ADC     FOUTBL + 1,Y
        STA     FACMOH
        .endif
        LDA     FACHO
        ADC     FOUTBL,Y
        STA     FACHO
        INX                          ;It was done yet another time.
        BCS     FOUT41
        BPL     FOUT2
        BMI     FOUT40
FOUT41:
        BMI     FOUT2
FOUT40:
        TXA
        BCC     FOUTYP               ;Can use acca as is.
        EOR     #0o377               ;Find 11.-[a]*
        ADC     #0o12                ;C is still on to complete negation.
                                     ;And will always be on after.
FOUTYP:
        ADC     #"0" - 1             ;Get a character to print.
        .repeat 3 + ADDPRC
        INY
        .endrepeat
                                     ;Bump pointer up.
        STY     FDECPT
        LDY     FBUFPT
        INY                          ;Point to place to store output.
        TAX
        AND     #0o177               ;Get rid of msb.
        STA     FBUFFR - 1,Y
        DEC     DECCNT
        BNE     STXBUF               ;Not time for dp yet.
        LDA     #"*"
        INY
        STA     FBUFFR - 1,Y         ;Store dp.
STXBUF:
        STY     FBUFPT               ;Store pntr for later.
        LDY     FDECPT
FOUTCM:
        TXA                          ;Complement accx
        EOR     #0o377               ;Complement acca.
        AND     #0o200               ;Save only msb.
        TAX
        CPY     #FDCEND - FOUTBL
        .if     TIME != 0
        BEQ     FOULDY
        CPY     #TIMEND - FOUTBL
        .endif
        BNE     FOUT2                ;Continue with output.
FOULDY:
        LDY     FBUFPT               ;Get back output pntr.
FOUT11:
        LDA     FBUFFR - 1,Y         ;Remove trailing zeroes.
        DEY
        CMP     #"0"
        BEQ     FOUT11
        CMP     #"*"
        BEQ     FOUT12               ;Run into dp. stop.
        INY                          ;Something else. save it.
FOUT12:
        LDA     #"+"
        LDX     TENEXP
        BEQ     FOUT17               ;No exponent to output.
        BPL     FOUT14
        LDA     #0
        SEC
        SBC     TENEXP
        TAX
        LDA     #"-"                 ;Exponent is negative.
FOUT14:
        STA     FBUFFR - 1 + 2,Y     ;Store sign of exp
        LDA     #"E"
        STA     FBUFFR - 1 + 1,Y     ;Store the "e" character.
        TXA
        LDX     #"0" - 1
        SEC
FOUT15:
        INX                          ;Move closer to output value.
        SBC     #0o12                ;Subtract 10.
        BCS     FOUT15               ;Not negative yet.
        ADC     #"0" + 0o12          ;Get second output character.
        STA     FBUFFR - 1 + 4,Y     ;Store high digit.
        TXA
        STA     FBUFFR - 1 + 3,Y     ;Store	low digit.
        LDA     #0                   ;Put in terminator.
        STA     FBUFFR - 1 + 5,Y
        BEQA    FOUT20               ;Return. (always branches)*
FOUT19:
        STA     FBUFFR - 1,Y         ;Store the character.
FOUT17:
        LDA     #0                   ;A terminator.
        STA     FBUFFR - 1 + 1,Y
FOUT20:
        LDWDI   FBUFFR
FPWRRT:
        RTS                          ;All done.
FHALF:
        .byte   0o200                ;1/2
        .byte   0
ZERO:
        .byte   0
        .byte   0
        .if     ADDPRC != 0
        .byte   0
        .endif

;Power of ten table
        .if     ADDPRC == 0
FOUTBL:
        .byte   0o376                ;-100000
        .byte   0o171
        .byte   0o140
        .byte   0                    ;10000
        .byte   0o047
        .byte   0o020
        .byte   0o377                ;-1000
        .byte   0o374
        .byte   0o030
        .byte   0                    ;100
        .byte   0
        .byte   0o144
        .byte   0o377                ;-10
        .byte   0o377
        .byte   0o366
        .byte   0                    ;1
        .byte   0
        .byte   1
        .endif

        .if     ADDPRC != 0
FOUTBL:
        .byte   0o372                ;-100,000,000
        .byte   0o012
        .byte   0o037
        .byte   0
        .byte   0                    ;10,000,000
        .byte   0o230
        .byte   0o226
        .byte   0o200
        .byte   0o377                ;-1,000,000
        .byte   0o360
        .byte   0o275
        .byte   0o300
        .byte   0                    ;100,000
        .byte   1
        .byte   0o206
        .byte   0o240
        .byte   0o377                ;-10,000
        .byte   0o377
        .byte   0o330
        .byte   0o360
        .byte   0                    ;1000
        .byte   0
        .byte   3
        .byte   0o350
        .byte   0o377                ;-100
        .byte   0o377
        .byte   0o377
        .byte   0o234
        .byte   0                    ;10
        .byte   0
        .byte   0
        .byte   0o012
        .byte   0o377                ;-1
        .byte   0o377
        .byte   0o377
        .byte   0o377
        .endif
FDCEND:
        .if     TIME != 0
        .byte   0o377                ; -2160000 For time converter.
        .byte   0o337
        .byte   0o012
        .byte   0o200
        .byte   0                    ; 216000
        .byte   3
        .byte   0o113
        .byte   0o300
        .byte   0o377                ; -36000
        .byte   0o377
        .byte   0o163
        .byte   0o140
        .byte   0                    ; 3600
        .byte   0
        .byte   0o016
        .byte   0o020
        .byte   0o377                ; -600
        .byte   0o377
        .byte   0o375
        .byte   0o250
        .byte   0                    ; 60
        .byte   0
        .byte   0
        .byte   0o074
TIMEND:
        .endif

        .page
        .subttl EXPONENTIATION AND SQUARE ROOT FUNCTION.
                                     ;Square root function --- sqr(a)
                                     ;Use sqr(x)=x^.5
SQR:
        JSR     MOVAF                ;Move fac into arg.
        LDWDI   FHALF
        JSR     MOVFM                ;Put memory into fac.
                                     ;Last thing fetched is facexp. into accx.
;	Jmp	fpwrt		;fall into fpwrt.

                                     ;Exponentiation ---  x^y.
                                     ;N.b.  0^0=1
                                     ;First check if y=0. if so, the result is 1.
                                     ;Next check if x=0. if so the result is 0.
                                     ;Then check if x.gt.0. if not check that y is an integer.
                                     ;If so, negate x, so that log doesn't give fcerr.
                                     ;If x is negative and y is odd, negate the result
                                     ;Returned by exp.
                                     ;To compute the result use x^y=exp((y*log(x))*
FPWRT:
        BEQ     EXP                  ;If fac=0, just exponentiate that.
        LDA     ARGEXP               ;Is x=0?
        BNE     FPWRT1
        JMP     ZEROF1               ;Zero fac.
FPWRT1:
        LDXYI   TEMPF3               ;Save for later in a temp.
        JSR     MOVMF
                                     ;Y=0 already. good in case no one calls int.
        LDA     ARGSGN
        BPL     FPWR1                ;No problems if x.gt.0.
        JSR     INT                  ;Integerize the fac.
        LDWDI   TEMPF3               ;Get addr of comperand.
        JSR     FCOMP                ;Equal?
        BNE     FPWR1                ;Leave x neg. log will blow him out.
                                     ;A=-1 and y is irrelevant.
        TYA                          ;Negate x. make positive.
        LDY     INTEGR               ;Get evenness.
FPWR1:
        JSR     MOVFA1               ;Alternate entry point.
        TYA
        PHA                          ;Save evenness for later.
        JSR     LOG                  ;Find log.
        LDWDI   TEMPF3               ;Multiply fac times log(x)*
        JSR     FMULT
        JSR     EXP                  ;Exponentiate the fac.
        PLA
        LSR     A                    ;Is it even?
        BCC     NEGRTS               ;Yes. or x.gt.0.
                                     ;Negate the number in fac.
NEGOP:
        LDA     FACEXP
        BEQ     NEGRTS
        COM     FACSGN
NEGRTS:
        RTS

        .page
        .subttl EXPONENTIATION FUNCTION.
                                     ;First save the original argument and multiply the fac by
                                     ;Log2(e)* the result is used to determine if overflow
                                     ;Will occur since exp(x)=2^(x*log2(e)) where
                                     ;Log2(e)=log(e) base 2. then save the integer part of
                                     ;This to scale the answer at the end. since
                                     ;2^Y=2^int(y)*2^(y-int(y)) and 2^int(y) is easy to compute.
                                     ;Now compute 2^(x*log2(e)-int(x*log2(e)) by
                                     ;P(ln(2)*(int(x*log2(e))+1)-x) where p is an approximation
                                     ;Polynomial. the result is then scaled by the power of 2
                                     ;Previously saved.

LOGEB2:
        .byte   0o201                ;Log(e) base 2.
        .byte   0o070
        .byte   0o252
        .byte   0o073
        .if     ADDPRC != 0
        .byte   0o051
        .endif

        .if     ADDPRC == 0
EXPCON:
        .byte   6                    ; degree -1.
        .byte   0o164                ; .00021702255
        .byte   0o143
        .byte   0o220
        .byte   0o214
        .byte   0o167                ; .0012439688
        .byte   0o043
        .byte   0o014
        .byte   0o253
        .byte   0o172                ; .0096788410
        .byte   0o036
        .byte   0o224
        .byte   0
        .byte   0o174                ; .055483342
        .byte   0o143
        .byte   0o102
        .byte   0o200
        .byte   0o176                ; .24022984
        .byte   0o165
        .byte   0o376
        .byte   0o320
        .byte   0o200                ; .69314698
        .byte   0o061
        .byte   0o162
        .byte   0o025
        .byte   0o201                ; 1.0
        .byte   0
        .byte   0
        .byte   0
        .endif

        .if     ADDPRC != 0
EXPCON:
        .byte   7                    ;Degree-1
        .byte   0o161                ; .000021498763697
        .byte   0o064
        .byte   0o130
        .byte   0o076
        .byte   0o126
        .byte   0o164                ; .00014352314036
        .byte   0o026
        .byte   0o176
        .byte   0o263
        .byte   0o033
        .byte   0o167                ; .0013422634824
        .byte   0o057
        .byte   0o356
        .byte   0o343
        .byte   0o205
        .byte   0o172                ; .0096140170119
        .byte   0o035
        .byte   0o204
        .byte   0o034
        .byte   0o052
        .byte   0o174                ; .055505126860
        .byte   0o143
        .byte   0o131
        .byte   0o130
        .byte   0o012
        .byte   0o176                ; .24022638462
        .byte   0o165
        .byte   0o375
        .byte   0o347
        .byte   0o306
        .byte   0o200                ; .69314718608
        .byte   0o061
        .byte   0o162
        .byte   0o030
        .byte   0o020
        .byte   0o201                ; 1.0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .endif

EXP:
        LDWDI   LOGEB2               ;Multiply by log(e) base 2.
        JSR     FMULT
        LDA     FACOV
        ADC     #0o120
        BCC     STOLD
        JSR     INCRND
STOLD:
        STA     OLDOV
        JSR     MOVEF                ;To save in arg without round.
        LDA     FACEXP
        CMP     #0o210               ;If abs(fac) .ge. 128, too big.
        BCC     EXP1
GOMLDV:
        JSR     MLDVEX               ;Overflow or overflow.
EXP1:
        JSR     INT
        LDA     INTEGR               ;Get low part.
        CLC
        ADC     #0o201
        BEQ     GOMLDV               ;Overflow or overflow !!
        SEC
        SBC     #1                   ;Subtract 1.
        PHA                          ;Save a while.
        LDX     #4 + ADDPRC          ;Prep to swap fac and arg.
SWAPLP:
        LDA     ARGEXP,X
        LDY     FACEXP,X
        STA     FACEXP,X
        STY     ARGEXP,X
        DEX
        BPL     SWAPLP
        LDA     OLDOV
        STA     FACOV
        JSR     FSUBT
        JSR     NEGOP                ;Negate fac.
        LDWDI   EXPCON
        JSR     POLY
        CLR     ARISGN               ;Multiply by positive 1.0.
        PLA                          ;Get scale factor.
        JSR     MLDEXP               ;Modify facexp and check for overflow.
        RTS                          ;Has to do jsr due to pulas in muldiv.

        .page
        .subttl POLYNOMIAL EVALUATOR AND THE RANDOM NUMBER GENERATOR.
                                     ;Evaluate p(x^2)*x
                                     ;Pointer to degree is in [y,a]*
                                     ;The constants follow the degree.
                                     ;For x=fac, compute:
                                     ; C0*x+c1*x^3+c2*x^5+c3*x^7+...+c(n)*x^(2*n+1)
POLYX:
        STWD    POLYPT               ;Retain polynomial pointer for later.
        JSR     MOV1F                ;Save fac in factmp.
        LDA     #TEMPF1
        JSR     FMULT                ;Compute x^2.
        JSR     POLY1                ;Compute p(x^2)*
        LDWDI   TEMPF1
        JMP     FMULT                ;Multiply by fac again.

                                     ;Polynomial evaluator.
                                     ;Pointer to degree is in [y,a]*
                                     ;Compute:
                                     ; C0+c1*x+c2*x^2+c3*x^3+c4*x^4+...+c(n-1)*x^(n-1)+c(n)*x^n.
POLY:
        STWD    POLYPT
POLY1:
        JSR     MOV2F                ;Save fac.
        LDA     (POLYPT),Y
        STA     DEGREE
        LDY     POLYPT
        INY
        TYA
        BNE     POLY3
        INC     POLYPT + 1
POLY3:
        STA     POLYPT
        LDY     POLYPT + 1
POLY2:
        JSR     FMULT
        LDWD    POLYPT               ;Get current pointer.
        CLC
        ADC     #4 + ADDPRC
        BCC     POLY4
        INY
POLY4:
        STWD    POLYPT
        JSR     FADD                 ;Add in constant.
        LDWDI   TEMPF2               ;Multiply the original fac.
        DEC     DEGREE               ;Done?
        BNE     POLY2
RANDRT:
        RTS                          ;Yes.

                                     ;Psuedo-random number generator.
                                     ;If arg=0, the last random number generated is returned.
                                     ;If arg .lt. 0, a new sequence of random numbers is
                                     ;Started using the argument.
                                     ;   To form the next random number in the sequence
                                     ;Multiply the previous random number by a random constant
                                     ;And add in another random constant. the then ho
                                     ;And lo bytes are switched, the exponent is put where
                                     ;It will be shifted in by normal, and the exponent in the fac
                                     ;Is set to 200 so the result will be less than 1. this
                                     ;Is then normalized and saved for the next time.
                                     ;The ho and low bytes were switched so there will be a
                                     ;Random chance of getting a number less than or greater
                                     ;Than .5 *

RMULZC:
        .byte   0o230
        .byte   0o065
        .byte   0o104
        .byte   0o172
RADDZC:
        .byte   0o150
        .byte   0o050
        .byte   0o261
        .byte   0o106

RND:
        JSR     SIGN                 ;Get sign into accx.
        .if     REALIO != 3
        TAX
        .endif
                                     ;Get into accx, since "movfm" uses accx.
        BMI     RND1                 ;Start new sequence if negative.
        .if     REALIO == 3
        BNE     QSETNR
                                     ;Timers are at 9044(l0),45(hi),48(lo),49(hi) hex.
                                     ;First two are always free running.
                                     ;Second pair is not. lo is freer than hi then.
                                     ;So order in fac is 44,48,45,49.
        LDA     CQHTIM
        STA     FACHO
        LDA     CQHTIM + 4
        STA     FACMOH
        LDA     CQHTIM + 1
        STA     FACMO
        LDA     CQHTIM + 5
        STA     FACLO
        JMP     STRNEX
        .endif
QSETNR:
        LDWDI   RNDX                 ;Get last one into fac.
        JSR     MOVFM
        .if     REALIO != 3
        TXA                          ;Fac was zero?
        BEQ     RANDRT
        .endif
                                     ;Restore last one.
        LDWDI   RMULZC               ;Multiply by random constant.
        JSR     FMULT
        LDWDI   RADDZC
        JSR     FADD                 ;Add random constant.
RND1:
        LDX     FACLO
        LDA     FACHO
        STA     FACLO
        STX     FACHO                ;Reverse ho and lo.
        .if     REALIO == 3
        LDX     FACMOH
        LDA     FACMO
        STA     FACMOH
        STX     FACMO
        .endif
STRNEX:
        CLR     FACSGN               ;Make number positive.
        LDA     FACEXP               ;Put exp where it will
        STA     FACOV                ;Be shifted in by normal.
        LDA     #0o200
        STA     FACEXP               ;Make result between 0 and 1.
        JSR     NORMAL               ;Normalize.
        LDXYI   RNDX
GMOVMF:
        JMP     MOVMF                ;Put new one into memory.

        .page
        .subttl SINE, COSINE AND TANGENT FUNCTIONS.
        .if     KIMROM == 0
                                     ;Cosine function.
                                     ;Use cos(x)=sin(x+pi/2)
COS:
        LDWDI   PI2                  ;Pntr to pi/2.
        JSR     FADD                 ;Add it in.
                                     ;Fall into sin.

                                     ;Sine function.
                                     ;Use identities to get fac in quadrants i or iv.
                                     ;The fac is divided by 2*pi and the integer part is ignored
                                     ;Because sin(x+2*pi)=sin(x)* then the argument can be compared
                                     ;With pi/2 by comparing the result of the division
                                     ;With pi/2/(2*pi)=1/4.
                                     ;Identities are then used to get the result in quadrants
                                     ;I or iv. an approximation polynomial is then used to
                                     ;Compute sin(x)*
SIN:
        JSR     MOVAF
        LDWDI   TWOPI                ;Get pntr to divisor.
        LDX     ARGSGN               ;Get sign of result.
        JSR     FDIVF
        JSR     MOVAF                ;Get result into arg.
        JSR     INT                  ;Integerize fac.
        CLR     ARISGN               ;Always have the same sign.
        JSR     FSUBT                ;Keep only the fractional part.
        LDWDI   FR4                  ;Get pntr to 1/4.
        JSR     FSUB                 ;Compute 1/4-fac.
        LDA     FACSGN               ;Save sign for later.
        PHA
        BPL     SIN1                 ;First quadrant.
        JSR     FADDH                ;Add 1/2 to fac.
        LDA     FACSGN               ;Sign is negative?
        BMI     SIN2
        COM     TANSGN               ;Quadrants ii and iii come here.
SIN1:
        JSR     NEGOP                ;If positive, negate it.
SIN2:
        LDWDI   FR4                  ;Pointer to 1/4.
        JSR     FADD                 ;Add it in.
        PLA                          ;Get original quadrant.
        BPL     SIN3
        JSR     NEGOP                ;If negative, negate result.
SIN3:
        LDWDI   SINCON
GPOLYX:
        JMP     POLYX                ;Do approximation polynomial.

                                     ;Tangent function.
TAN:
        JSR     MOV1F                ;Move fac into temporary.
        CLR     TANSGN               ;Remember whether to negate.
        JSR     SIN                  ;Compute the sin.
        LDXYI   TEMPF3
        JSR     GMOVMF               ;Put sign into other temp.
        LDWDI   TEMPF1
        JSR     MOVFM                ;Put this memory loc into fac.
        CLR     FACSGN               ;Start off positive.
        LDA     TANSGN
        JSR     COSC                 ;Compute cosine.
        LDWDI   TEMPF3               ;Address of sine value.
GFDIV:
        JMP     FDIV                 ;Divide sine by cosine and return.
COSC:
        PHA
        JMP     SIN1

PI2:
        .byte   0o201                ;Pi/2
        .byte   0o111
        .byte   0o017
        .byte   0o333 - ADDPRC
        .if     ADDPRC != 0
        .byte   0o242
        .endif
TWOPI:
        .byte   0o203                ;2*Pi.
        .byte   0o111
        .byte   0o017
        .byte   0o333 - ADDPRC
        .if     ADDPRC != 0
        .byte   0o242
        .endif
FR4:
        .byte   0o177                ;1/4
        .byte   0
        .byte   0
        .byte   0
        .if     ADDPRC != 0
        .byte   0
        .endif
        .if     ADDPRC == 0
SINCON:
        .byte   4                    ;Degree-1.
        .byte   0o206                ;39.710899
        .byte   0o036
        .byte   0o327
        .byte   0o373
        .byte   0o207                ;-76.574956
        .byte   0o231
        .byte   0o046
        .byte   0o145
        .byte   0o207                ;81.602231
        .byte   0o043
        .byte   0o064
        .byte   0o130
        .byte   0o206                ;-41.341677
        .byte   0o245
        .byte   0o135
        .byte   0o341
        .byte   0o203                ;6.2831853
        .byte   0o111
        .byte   0o017
        .byte   0o333
        .endif

        .if     ADDPRC != 0
SINCON:
        .byte   5                    ;Degree-1.
        .byte   0o204                ; -14.381383816
        .byte   0o346
        .byte   0o032
        .byte   0o055
        .byte   0o033
        .byte   0o206                ; 42.07777095
        .byte   0o050
        .byte   7
        .byte   0o373
        .byte   0o370
        .byte   0o207                ; -76.704133676
        .byte   0o231
        .byte   0o150
        .byte   0o211
        .byte   1
        .byte   0o207                ; 81.605223690
        .byte   0o043
        .byte   0o065
        .byte   0o337
        .byte   0o341
        .byte   0o206                ; -41.34170209
        .byte   0o245
        .byte   0o135
        .byte   0o347
        .byte   0o050
        .byte   0o203                ; 6.2831853070
        .byte   0o111
        .byte   0o017
        .byte   0o332
        .byte   0o242
        .byte   0o241                ; 7.2362932E7
        .byte   0o124
        .byte   0o106
        .byte   0o217
        .byte   0o23
        .byte   0o217                ; 73276.2515
        .byte   0o122
        .byte   0o103
        .byte   0o211
        .byte   0o315
        .endif
        .page
        .subttl ARCTANGENT FUNCTION.
                                     ;Use identities to get arg between 0 and 1 and then use an
                                     ;Approximation polynomial to compute arctan(x)*
ATN:
        LDA     FACSGN               ;What is sign?
        PHA                          ;(Meanwhile save for later.)
        BPL     ATN1
        JSR     NEGOP                ;If negative, negate fac.
                                     ;Use arctan(x)=-arctan(-x) *
ATN1:
        LDA     FACEXP
        PHA                          ;Save this too for later.
        CMP     #0o201               ;See if fac .ge. 1.0 *
        BCC     ATN2                 ;It is less than 1.
        LDWDI   FONE                 ;Get pntr to 1.0 *
        JSR     FDIV                 ;Compute reciprocal.
                                     ;Use arctan(x)=pi/2-arctan(1/x) *
ATN2:
        LDWDI   ATNCON               ;Pntr to arctan constants.
        JSR     POLYX
        PLA
        CMP     #0o201               ;Was original argument .lt. 1 ?
        BCC     ATN3                 ;Yes.
        LDWDI   PI2
        JSR     FSUB                 ;Subtract arctagn from pi/2.
ATN3:
        PLA                          ;Was original argument positive?
        BPL     ATN4                 ;Yes.
        JMP     NEGOP                ;If negative, negate result.
ATN4:
        RTS                          ;All done.

        .if     ADDPRC == 0
ATNCON:
        .byte   0o10                 ;Degree-1.
        .byte   0o170                ;.0028498896
        .byte   0o072
        .byte   0o305
        .byte   0o067
        .byte   0o173                ;-.016068629
        .byte   0o203
        .byte   0o242
        .byte   0o134
        .byte   0o174                ;.042691519
        .byte   0o056
        .byte   0o335
        .byte   0o115
        .byte   0o175                ;-.075042945
        .byte   0o231
        .byte   0o260
        .byte   0o036
        .byte   0o175                ;.10640934
        .byte   0o131
        .byte   0o355
        .byte   0o044
        .byte   0o176                ;-.14203644
        .byte   0o221
        .byte   0o162
        .byte   0
        .byte   0o176                ;.19992619
        .byte   0o114
        .byte   0o271
        .byte   0o163
        .byte   0o177                ;*-33333073
        .byte   0o252
        .byte   0o252
        .byte   0o123
        .byte   0o201                ;1.0
        .byte   0
        .byte   0
        .byte   0
        .endif

        .if     ADDPRC != 0
ATNCON:
        .byte   0o13                 ;Degree-1.
        .byte   0o166                ; -.0006847939119
        .byte   0o263
        .byte   0o203
        .byte   0o275
        .byte   0o323
        .byte   0o171                ; .004850942156
        .byte   0o036
        .byte   0o364
        .byte   0o246
        .byte   0o365
        .byte   0o173                ; -.01611170184
        .byte   0o203
        .byte   0o374
        .byte   0o260
        .byte   0o020
        .byte   0o174                ; .03420963805
        .byte   0o014
        .byte   0o037
        .byte   0o147
        .byte   0o312
        .byte   0o174                ; -.05427913276
        .byte   0o336
        .byte   0o123
        .byte   0o313
        .byte   0o301
        .byte   0o175                ; .07245719654
        .byte   0o024
        .byte   0o144
        .byte   0o160
        .byte   0o114
        .byte   0o175                ; -.08980239538
        .byte   0o267
        .byte   0o352
        .byte   0o121
        .byte   0o172
        .byte   0o175                ; .1109324134
        .byte   0o143
        .byte   0o060
        .byte   0o210
        .byte   0o176
        .byte   0o176                ; -.1428398077
        .byte   0o222
        .byte   0o104
        .byte   0o231
        .byte   0o072
        .byte   0o176                ; .1999991205
        .byte   0o114
        .byte   0o314
        .byte   0o221
        .byte   0o307
        .byte   0o177                ; -.3333333157
        .byte   0o252
        .byte   0o252
        .byte   0o252
        .byte   0o023
        .byte   0o201                ; 1.0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .endif
        .endif
        .page
        .subttl SYSTEM INITIALIZATION CODE.
;Radix	10		;in all non-math-package code.
; This initializes the basic interpreter for the m6502 and should be
; Located where it will be wiped out in ram if code is all in ram.

        .if     ROMSW == 0
        .fill   1
        .endif
                                     ;So zeroing at txttab doesn't prevent
                                     ;Restarting init
INITAT:
        INC     CHRGET + 7           ;Increment the whole txtptr.
        BNE     CHZGOT
        INC     CHRGET + 8
CHZGOT:
        LDA     60000                ;A load with an ext addr.
        CMP     #":"                 ;Is it a ":"?
        BCS     CHZRTS               ;It is .ge. ":"
        CMP     #" "                 ;Skip spaces.
        BEQ     INITAT
        SEC
        SBC     #"0"                 ;All chars .gt. "9" have ret'd so
        SEC
        SBC     #256 - "0"           ;See if numeric.
                                     ;Turn carry on if numeric.
                                     ;Also, setz if null.
CHZRTS:
        RTS                          ;Return to caller.

        .byte   128                  ;Loaded or from rom.
        .byte   79                   ;The initial random number.
        .byte   199
        .byte   82
        .if     ADDPRC != 0
        .byte   88
        .endif
        .if     REALIO != 3
        .if     KIMROM == 0
TYPAUT:
        LDWDI   AUTTXT
        JSR     STROUT
        .endif
        .endif
INIT:
        .if     REALIO != 3
        LDX     #255                 ;Make it look direct in case of
        STX     CURLIN + 1
        .endif
                                     ;Error message.
        .if     STKEND != 511
        LDX     #STKEND - 256
        .endif
        TXS
        .if     REALIO != 3
        LDWDI   INIT                 ;Allow restart.
        STWD    START + 1
        STWD    RDYJSR + 1           ;Rts here on errors.
        LDWDI   AYINT
        STWD    ADRAYI
        LDWDI   GIVAYF
        STWD    ADRGAY
        .endif
        LDA     #76                  ;Jmp instruction.
        .if     REALIO == 0
HRLI 1,0o1000
        .endif
                                     ;Make an inst.
        .if     REALIO != 3
        STA     START
        STA     RDYJSR
        .endif
        STA     JMPER
        .if     ROMSW != 0
        STA     USRPOK
        LDWDI   FCERR
        STWD    USRPOK + 1
        .endif
        LDA     #LINLEN              ;These must be non-zero so chead will
        STA     LINWID               ;Work after moving a new line in buf
                                     ;Into the program
        LDA     #NCMPOS
        STA     NCMWID
        LDX     #RNDX + 4 - CHRGET
MOVCHG:
        LDA     INITAT - 1,X
        STA     CHRGET - 1,X         ;Move to ram.
        DEX
        BNE     MOVCHG
        LDA     #STRSIZ
        STA     FOUR6
        TXA                          ;Set const in ram.
        STA     BITS
        .if     EXTIO != 0
        STA     CHANNL
        .endif
        STA     LASTPT + 1
        .if     NULCMD != 0
        STA     NULCNT
        .endif
        PHA                          ;Put zero at the end of the stack
                                     ;So fndfor will stop
        .if     REALIO != 0
        STA     CNTWFL
        .endif
                                     ;Be talkative.
        .if     BUFPAG != 0
        INX                          ;Make [x]=1
        STX     BUF - 3              ;Set pre-buf bytes non-zero for chead
        STX     BUF - 4
        .endif
        .if     REALIO != 3
        JSR     CRDO
        .endif
                                     ;Type a cr.
        LDX     #TEMPST
        STX     TEMPPT               ;Set up string temporaries.
        .if     (REALIO | LONGI) != 0
        .if     REALIO != 3
        LDWDI   MEMORY
        JSR     STROUT
        JSR     QINLIN               ;Get a line of input.
        STXY    TXTPTR               ;Read this !
        JSR     CHRGET               ;Get the first character.
        .if     KIMROM == 0
        CMP     #"A"                 ;Is it an "a"?
        BEQ     TYPAUT
        .endif
                                     ;Yes type author's name.
        TAY                          ;Null input?
        BNE     USEDE9
        .endif
                                     ;No.
        .if     REALIO == 3
        LDY     #RAMLOC / 256
        .endif
        .if     REALIO != 3
        .if     ROMSW == 0
        LDWDI   LASTWR
        .endif
                                     ;Yes get pntr to last word.
        .if     ROMSW != 0
        LDWDI   RAMLOC
        .endif
        .endif
        .if     ROMSW != 0
        STWD    TXTTAB
        .endif
                                     ;Set up start of program location
        STWD    LINNUM
        .if     REALIO == 3
        TAY
        .endif
        .if     REALIO != 3
        LDY     #0
        .endif
LOOPMM:
        INC     LINNUM
        BNE     LOOPM1
        INC     LINNUM + 1
        .if     REALIO == 3
        BMI     USEDEC
        .endif
LOOPM1:
        LDA     #85                  ;Put random info into mem.
        STA     (LINNUM),Y
        CMP     (LINNUM),Y           ;Was it saved?
        BNE     USEDEC               ;No. that is end of memory.
        ASL     A                    ;Looks like it. try another.
        STA     (LINNUM),Y
        CMP     (LINNUM),Y           ;Was it saved?
        .if     REALIO != 3
        BNE     USEDEC
        .endif
                                     ;No. this is the end.
        .if     REALIO != 2
        BEQ     LOOPMM
        .endif
        .if     REALIO == 2
        BNE     USEDEC
        CMP     0                    ;See if hitting page 0
        BNE     LOOPMM
        LDA     #76
        STA     0
        BNEA    USEDEC
        .endif
        .if     REALIO != 3
USEDE9:
        JSR     CHRGOT               ;Get current character.
        JSR     LINGET               ;Get decimal argument.
        TAY                          ;Make sure a terminator exists.
        BEQ     USEDEC               ;It does.
        JMP     SNERR
        .endif
                                     ;It doesn't.
USEDEC:
        LDWD    LINNUM               ;Get size of memory input.
USEDEF:
        .endif
                                     ;Highest address.
        .if     (REALIO | LONGI) == 0
        LDWDI   16190
        .endif
                                     ;A strange number.
        STWD    MEMSIZ               ;This is the size of memory.
        STWD    FRETOP               ;Top of strings too.
TTYW:
        .if     REALIO != 3
        .if     (REALIO | LONGI) != 0
        LDWDI   TTYWID
        JSR     STROUT
        JSR     QINLIN               ;Get line of input.
        STXY    TXTPTR               ;Read this !
        JSR     CHRGET               ;Get first character.
        TAY                          ;Test acca but don't affect carry.
        BEQ     ASKAGN
        JSR     LINGET               ;Get argument.
        LDA     LINNUM + 1
        BNE     TTYW                 ;Width must be .lt. 256.
        LDA     LINNUM
        CMP     #16                  ;Width must be greater than 16.
        BCC     TTYW
        STA     LINWID               ;That is the line width.
MORCPS:
        SBC     #CLMWID              ;Compute position beyond which
        BCS     MORCPS               ;There are no more fields.
        EOR     #255
        SBC     #CLMWID - 2
        CLC
        ADC     LINWID
        STA     NCMWID
        .endif
ASKAGN:
        .if     ROMSW == 0
        .if     (REALIO | LONGI) != 0
        LDWDI   FNS
        JSR     STROUT
        JSR     QINLIN
        STXY    TXTPTR               ;Read this !
        JSR     CHRGET
        LDXYI   INITAT               ;Default.
        CMP     #"Y"
        BEQ     HAVFNS               ;Save all functions.
        CMP     #"A"
        BEQ     OKCHAR               ;Save all but atn.
        CMP     #"N"
        BNE     ASKAGN               ;Bad input.
                                     ;Save nothing.
OKCHAR:
        LDXYI   FCERR
        STXY    ATNFIX               ;Get rid of atn function.
        LDXYI   ATN                  ;Until we know that we should del more.
        CMP     #"A"
        BEQ     HAVFNS               ;Just get rid of atn.
        LDXYI   FCERR
        STXY    COSFIX               ;Get rid of the rest.
        STXY    TANFIX
        STXY    SINFIX
        LDXYI   COS                  ;And get rid of all back to "cos"*
HAVFNS:
        .endif
        .if     (REALIO | LONGI) == 0
        LDXYI   INITAT - 1
        .endif
        .endif
        .endif
                                     ;Get rid of all up to "initat"*
        .if     ROMSW != 0
        LDXYI   RAMLOC
        STXY    TXTTAB
        .endif
        LDY     #0
        TYA
        STA     (TXTTAB),Y           ;Set up text table.
        INC     TXTTAB
        .if     REALIO != 3
        BNE     QROOM
        INC     TXTTAB + 1
        .endif
QROOM:
        LDWD    TXTTAB               ;Prepare to use "reason"*
        JSR     REASON
        .if     REALIO == 3
        LDWDI   FREMES
        JSR     STROUT
        .endif
        .if     REALIO != 3
        JSR     CRDO
        .endif
        LDA     MEMSIZ               ;Compute [memsiz]-[vartab]*
        SEC
        SBC     TXTTAB
        TAX
        LDA     MEMSIZ + 1
        SBC     TXTTAB + 1
        JSR     LINPRT               ;Type this value.
        LDWDI   WORDS                ;More bullshit.
        JSR     STROUT
        JSR     SCRTCH               ;Set up everything else.
        .if     REALIO == 3
        JMP     READY
        .endif
        .if     REALIO != 3
        LDWDI   STROUT
        STWD    RDYJSR + 1
        LDWDI   READY
        STWD    START + 1
        JMP     (START + 1)

        .if     ROMSW == 0
FNS:
        .text   "WANT SIN-COS-TAN-ATN"
        .byte   0
        .endif
        .if     KIMROM == 0
AUTTXT:
        ACRLF
        .byte   12                   ;Another line feed.
        .text   "WRITTEN "
        .text   "BY WEILAND & GATES"
        ACRLF
        .byte   0
        .endif
MEMORY:
        .text   "MEMORY SIZE"
        .byte   0
TTYWID:
        .if     KIMROM == 0
        .text   "TERMINAL "
        .endif
        .text   "WIDTH"
        .byte   0
        .endif
WORDS:
        .text   " BYTES FREE"
        .if     REALIO != 3
        ACRLF
        ACRLF
        .endif
        .if     REALIO == 3
        .word   0o15
        .byte   0
FREMES:
        .endif
        .if     REALIO == 0
        .text   "SIMULATED BASIC FOR THE 6502 V1.1"
        .endif
        .if     REALIO == 1
        .text   "KIM BASIC V1.1"
        .endif
        .if     REALIO == 2
        .text   "OSI 6502 BASIC VERSION 1.1"
        .endif
        .if     REALIO == 3
        .text   "### COMMODORE BASIC ###"
        .word   0o15
        .word   0o15
        .endif
        .if     REALIO == 4
        .text   "APPLE BASIC V1.1"
        .endif
        .if     REALIO == 5
        .text   "STM BASIC V1.1"
        .endif
        .if     REALIO != 3
        ACRLF
        .text   "COPYRIGHT 1978 MICROSOFT"
        ACRLF
        .endif
        .byte   0
LASTWR:
        .fill   100                  ;Space for temp stack.
        .if     REALIO == 0
TSTACK:
        .fill   13600
        .endif

        .if     1
                                     ; Purge	a,x,y
        .endif
; Ifndef	start,(start = 0)
                                     ; End	$z+start

