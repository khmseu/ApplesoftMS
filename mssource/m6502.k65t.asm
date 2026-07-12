        .title  BASIC M6502 8K VER 1.1 BY MICRO-SOFT
        .include "M6502.lib.asm"
;Sall
;Radix 10			;throughout all but math-pak.

$Z:
                                     ;Starting point FOR m6502 simulator
        .org    0                    ;START off at location ZERO.
        .subttl SWITCHES,MACROS.

REALIO  =       4                    ;5=Stm
                                     ;4=Apple.
                                     ;3=Commodore.
                                     ;2=Osi
                                     ;1=Mos tech,kim
                                     ;0=Pdp-10 simulating 6502
INTPRC  =       1                    ;Integer arrays.
ADDPRC  =       1                    ;FOR additional precision.
LNGERR  =       0                    ;Long ERROR messages.
TIME    =       0                    ;Capability to set and READ a clk.
EXTIO   =       0                    ;External i/o.
DISKO   =       0                    ;SAVE and LOAD commands
NULCMD  =       1                    ;FOR the "null" command
GETCMD  =       1
RORSW   =       1
ROMSW   =       1                    ;Tells IF this is on rom.
CLMWID  =       14
LONGI   =       1                    ;Long initialization switch.
STKEND  =       511
BUFPAG  =       0
LINLEN  =       72                   ;Terminal line length.
BUFLEN  =       72                   ;INPUT buffer SIZE.
ROMLOC  =       0o20000              ;Address of START of pure segment.
KIMROM  =       1
        .IF     ROMSW == 0
KIMROM  =       0
        .endif
        .IF     REALIO != 1
KIMROM  =       0
        .endif
        .IF     ROMSW != 0
RAMLOC  =       0o40000              ;Used only IF ROMSW=1
        .IF     REALIO == 0
ROMLOC  =       0o20000              ;START at 8k.
RAMLOC  =       0o1400
        .endif
        .endif
        .IF     REALIO == 3
DISKO   =       1
RAMLOC  =       0o2000
ROMLOC  =       0o140000
NULCMD  =       0
GETCMD  =       1
LINLEN  =       40
BUFLEN  =       81
CQOPEN  =       0o177700
CQCLOS  =       0o177703
CQOIN   =       0o177706             ;Open channel FOR INPUT
CQOOUT  =       0o177711             ;Fill FOR commo.
CQCCHN  =       0o177714
CQINCH  =       0o177717             ;INCHR's call to GET a character
OUTCH   =       0o177722
CQLOAD  =       0o177725
CQSAVE  =       0o177730
CQVERF  =       0o177733
CQSYS   =       0o177736
ISCNTC  =       0o177741
CZGETL  =       0o177744             ;Call point FOR "GET"
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
PI      =       255                  ;Value of pi character FOR commodore.
ROMSW   =       1
RORSW   =       1
TRMPOS  =       0o306
        .endif
        .IF     REALIO == 1
GETCMD  =       1
DISKO   =       1
OUTCH   =       0o17240              ;1Ea0
ROMLOC  =       0o20000
RORSW   =       0
CZGETL  =       0o17132
        .endif
        .IF     REALIO == 2
RORSW   =       0
RAMLOC  =       0o1000
        .IF     ROMSW != 0
RORSW   =       0
RAMLOC  =       0o100000
        .endif
OUTCH   =       0o177013
        .endif
        .IF     REALIO == 4
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
        .IF     RORSW == 0
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
                                     ;Bit ZERO page trick.
        .macro  SKIP2
        .byte   0o054
        .endmacro
                                     ;Bit ABS trick.
        .IF     1
        .IF     REALIO == 0
        .PRINT  SIMULATE
        .endif
        .IF     REALIO == 1
        .PRINT  KIM
        .endif
        .IF     REALIO == 2
        .PRINT  OSI
        .endif
        .IF     REALIO == 3
        .PRINT  COMMODORE
        .endif
        .IF     REALIO == 4
        .PRINT  APPLE
        .endif
        .IF     REALIO == 5
        .PRINT  STM
        .endif
        .IF     ADDPRC != 0
        .PRINT  ADDITIONAL PRECISION
        .endif
        .IF     INTPRC != 0
        .PRINT  INTEGER ARRAYS
        .endif
        .IF     LNGERR != 0
        .PRINT  LONG ERRORS
        .endif
        .IF     DISKO != 0
        .PRINT  SAVE AND LOAD
        .endif
        .IF     ROMSW == 0
        .PRINT  RAM
        .endif
        .IF     ROMSW != 0
        .PRINT  ROM
        .endif
        .IF     RORSW == 0
        .PRINT  NO ROR
        .endif
        .IF     RORSW != 0
        .PRINT  ROR ASSUMED
        .endif
        .endif
        .page
        .subttl INTRODUCTION AND COMPILATION PARAMETERS.

; --------- ---- -- ---------
; Copyright 1976 by microsoft
; --------- ---- -- ---------
; 7/27/78 Fixed bug where FOR variable at byte ff matched RETURN searching
; 	FOR GOSUB entry on stack in FNDFOR call by changing sta FORPNT
; 	To sta FORPNT+1. this is a serious bug in all versions.
; 7/27/78 Fixed bug at NEWSTT under ifn BUFPAG when check of CURLIN
; 	Was done before CURLIN set up so INPUT retries of first statement
; 	Was giving syntax ERROR instead of redo from START (code was 12/1/77 fix)
; 7/1/78	Saved a few bytes in INIT FOR commodore (14)
; 7/1/78 Fixed bug where replacing a line overflowing MEMORY LEFT links
; 	In a bad state. (code at NODEL and FINI) bug#4
; 7/1/78 Fixed bug where garbage collection never(!) collects temps
; 	(Sty GRBPNT  at FNDVAR, lda GRBPNT ora GRBPNT+1 at GRBPAS)
; 	This was commodore bug #2
; 7/1/78 Fixed bug where delete/insert of line could cause a garbage collection with bad VARTAB IF out of MEMORY
; 	 (Ldwd MEMSIZ stwd FRETOP=jsr RUNC clc also at NODEL)
; 3/9/78 Edit to fix commo TRMPOS and change LEFT$ and RIGHT$ to allow a second argument of 0 and RETURN a null string
; 2/25/78 Fixed bug that INPFLG was set wrong when BUFPAG.ne.0
; 	Increased NUMLEV from 19 to 23
; 2/11/78 Disallowed spaces in reserved WORDS. put in special check FOR "go to"
; 2/11/78 Fixed bug where rounding of the FAC before pushing could cause a string pointer
; 	In the FAC to be incremented
; 1/24/78 fixed problem where user defined function undefined check fix was smashing ERROR number in [x]
; 12/1/77 Fixed problem where PEEK was smashing (POKER) causing POKE of PEEK to fail
; 12/1/77 Fixed problem where problem with VARTXT=LINNUM=BUF-2 causing BUF-1 comma to disappear
; 12/1/77 Fixed BUFPAG.ne.0 problem at NEWSTT and STOP : code was still
; 	Assuming TXTPTR+1.eq.0 iff statement was direct

NUMLEV  =       23                   ;Number of stack levels reserved
                                     ;By an explicit call to "GETSTK"*
STRSIZ  =       3                    ;# Of locs per string descriptor.
NUMTMP  =       3                    ;Number of string temporaries.
CONTW   =       15                   ;Character to suppress output.

        .page
        .subttl SOME EXPLANATION.

; M6502 basic configures basic as follows

; Low locations
; 	Page	ZERO

; 		Startup:
; 		Initially a jmp to initialization code but
; 		Changed to a jmp to "READY".
; 		Restarting the machine at loc 0 during program
; 		Execution can leave things messed up.

; 		Loc of FAC to integer and integer to FAC
; 		Routines.

; 		"Direct" MEMORY:
; 		These are the most commonly used locations.
; 		They hold bookkeeping info and all other
; 		Frequently used information.
; 		All temporaries, flags, pointers, the buffer area,
; 		The floating accumulator, and anything else that
; 		Is used to store a changing value should be located
; 		In this area. care must be made in moving locations
; 		In this area since the juxtaposition of two locations
; 		Is often depended upon.

; 		Still in ram we have the beginning of the "CHRGET"
; 		Subroutine. it is here so [TXTPTR] can be the
; 		Extended address of a LOAD instruction.
; 		This saves having to bother any registers.

; 	Page	one
; 		The stack.

; 	Storage page two and on
; 		In ram versions these DATA structures come at the
; 		END of basic. in rom version they are at RAMLOC which
; 		Can either be above or below ROMLOC, which is where
; 		Basic itself resides.

; 				A ZERO.
; 		[TXTTAB]	pointer to NEXT line's pointer.
; 				Line # of this line (2 bytes).
; 				Characters on this line.
; 				ZERO.
; 				Pointer at NEXT line's pointer
; 					(Pointed to by the above pointer).
; 				... Repeats ...
; 		Last line:	pointer at ZERO pointer.
; 				Line # of this line.
; 				Characters on this line.
; 				ZERO.
; 				Double ZERO (pointed to by the above pointer).
; 		[VARTAB]	simple variables. 6 bytes per value.
; 				2 Bytes give the name, 4 bytes the value.
; 				... Repeats ...
; 		[ARYTAB]	array variables. 2 bytes name, 2 byte
; 				Length, number of dimensions , extent of
; 				Each dimension (2bytes/), values
; 				... Repeats ...
; 		[STREND]	free space.
; 				... Repeats ...
; 		[FRETOP]	string space in use.
; 				... Repeats ...
; 		[MEMSIZ]	highest machine location.
; 				Unused except by the VAL function.

; 		Rom -- constants and code.

; 	Function dispatch addresses (at ROMLOC)
; 		"FUNDSP" contains the addresses of the
; 		Function routines in the order of the
; 		Function names in the CRUNCH LIST.
; 		The functions that take more than one argument
; 		Are at the END. see the explanation at "ISFUN".

; 	The operator LIST
; 		The "OPTAB" LIST contains an operator's precedence
; 		Followed by the address of the routine to perform
; 		The operation. the INDEX into the
; 		Operator LIST is made by subtracting off the CRUNCH value
; 		Of the lowest numbered operator. the order
; 		Of operators in the CRUNCH LIST and in "OPTAB" is identical.
; 		The precedences are arbitrary except FOR their
; 		Comparative sizes. note that the precedence FOR
; 		Unary operators such as "not" and negation are
; 		Setup specially without using the LIST.

; 	The reserved word or CRUNCH LIST
; 		When a command or program line is typed in
; 		It is stored in "BUF". as soon as the whole line
; 		Has been typed in ("INLIN" returns) "CRUNCH" is
; 		Called to convert all reserved WORDS to their
; 		Crunched values. this reduces the SIZE of the
; 		Program and speeds up execution by allowing
; 		LIST dispatches to perform functions, statements,
; 		And operations. this is because all the statement
; 		Names are stored consecutively in the CRUNCH LIST.
; 		When a match is found between a string
; 		Of characters and a word in the CRUNCH LIST
; 		The entire text of the matched word is taken out of
; 		The INPUT line and a reserved word token is put
; 		In its place. a reserved word token is always equal
; 		To octal 200 plus the position of the matched word
; 		In the CRUNCH LIST.

; 	Statement dispatch addresses
; 		When a statement is to be executed, the first
; 		Character of the statement is examined
; 		To see IF it is less than the reserved
; 		Word token FOR the lowest numbered statement name.
; 		IF so, the "LET" code is called to
; 		Treat the statement as an assignment statement.
; 		Otherwise a check is made to make sure the
; 		Reserved word number is not too large to be a
; 		Statement type number. IF not the address
; 		To dispatch to is fetched from "STMDSP" (the statement
; 		Dispatch LIST) using the reserved word
; 		Number FOR the statement to calculate an INDEX into
; 		The LIST.

; 	ERROR messages
; 		When an ERROR condition is detected,
; 		[Accx] must be set up to indicate which ERROR
; 		Message is appropriate and a branch must be made
; 		To "ERROR". the stack will be reset and all
; 		Program context will be lost. variables
; 		Values and the actual program remain intact.
; 		Only the value of [accx] is important when
; 		The branch is made to ERROR. [accx] is used as an
; 		INDEX into "ERRTAB" which gives the two
; 		Character ERROR message that will be printed on the
; 		User's terminal.

; 	Textual messages
; 		Constant messages are stored here. unless
; 		The code to check IF a string must be copied
; 		Is changed these strings must be stored above
; 		Page ZERO, or else they will be copied before
; 		They are printed.

; 	FNDFOR
; 		Most small routines are fairly simple
; 		And are documented in place. "FNDFOR" is
; 		Used FOR finding "FOR" entries on
; 		The stack. whenever a "FOR" is executed, a
; 		16-Byte entry is pushed onto the stack.
; 		Before this is done, however, a check
; 		Must be made to see IF there
; 		Are any "FOR" entries already on the stack
; 		FOR the same loop variable. IF so, that "FOR" entry
; 		And all other "FOR" entries that were made after it
; 		Are eliminated from the stack. this is so a
; 		Program that jumps out of the middle
; 		Of a "FOR" loop and then restarts the loop again
; 		And again won't use up 18 bytes of stack
; 		Space every TIME. the "NEXT" code also
; 		Calls "FNDFOR" to search FOR a "FOR" entry with
; 		The loop variable in
; 		The "NEXT". at whatever point a match is found
; 		The stack is reset. IF no match is found a
; 		"NEXT without FOR"  ERROR occurs. GOSUB execution
; 		Also puts a 5-byte entry on stack.
; 		When a RETURN is executed "FNDFOR" is
; 		Called with a variable pointer that can't
; 		Be matched. when "FNDFOR" has RUN
; 		Through all the "FOR" entries on the stack
; 		It returns and the RETURN code makes
; 		Sure the entry that was stopped
; 		On is a GOSUB entry. this assures that
; 		IF you GOSUB to a section of code
; 		In which a FOR loop is entered but never
; 		Exited the RETURN will still be
; 		Able to find the most recent
; 		GOSUB entry. the "RETURN" code eliminates the
; 		"GOSUB" entry and all "FOR" entries made after
; 		The GOSUB entry.

; 	Non-runtime stuff
; 		The code to INPUT a line, CRUNCH it, give errors,
; 		Find a specific line in the program,
; 		Perform a "new", "CLEAR", and "LIST" are
; 		All in this area. given the explanation of
; 		Program storage set forth above, these are
; 		All straightforward.

; 	NEWSTT
; 		Whenever a statement finishes execution it
; 		Does a "rts" which takes
; 		Execution back to "NEWSTT". statements that
; 		Create or look at semi-permanent stack entries
; 		Must GET rid of the RETURN address of "NEWSTT" and
; 		Jmp to "NEWSTT" when done. "NEWSTT" always
; 		Chrgets the first character after the statement
; 		Name before dispatching. when returning
; 		Back to "NEWSTT" the only thing that
; 		Must be set up is the text pointer in
; 		"TXTPTR". "NEWSTT" will check to make sure
; 		"TXTPTR" is pointing to a statement terminator.
; 		IF a statement shouldn't be performed unless
; 		It is properly formatted (i.e. "new") it can
; 		Simply do a RETURN after reading all of
; 		Its arguments. since the ZERO flag
; 		Being off indicates there is not
; 		A statement terminator "NEWSTT" will
; 		Do the jmp to the "syntax ERROR"
; 		Routine. IF a statement should be started
; 		Over it can do ldwd OLDTXT, stwd TXTPTR rts since the text pntr
; 		At "NEWSTT" is always stored in "OLDTXT".
; 		The ^c code stores [CURLIN] (the
; 		Current line number) in "OLDLIN" since the ^c check
; 		Is made before the statement pointed to is
; 		Executed. "STOP" and "END" store the text pointer
; 		From "TXTPTR", which points at their terminating
; 		Character, in "OLDTXT".

; 	Statement code
; 		The individual statement code comes
; 		NEXT. the approach used in executing each
; 		Statement is documented in the statement code
; 		Itself.

; 	FRMEVL, the formula evaluator
; 		Given a text pointer pointing to the starting
; 		Character of a formula, "FRMEVL"
; 		Evaluates the formula and leaves
; 		The value in the floating accumulator (FAC).
; 		"TXTPTR" is returned pointing to the first character
; 		That could not be interpreted as part of the
; 		Formula. the algorithm uses the stack
; 		To store temporary results:

; 			0. Put a dummy precedence of ZERO on
; 				The stack.
; 			1. READ lexeme (constant,function,
; 				Variable,formula in parens)
; 				And take the last precedence value
; 				Off the stack.
; 			2. See IF the NEXT character is an operator.
; 				IF not, check previous one. this may cause
; 				Operator application or an actual
; 				RETURN from "FRMEVL".
; 			3. IF it is, see what precedence it has
; 				And compare it to the precedence
; 				Of the last operator on the stack.
; 			4. IF = or less remember the operator
; 				Pointer of this operator
; 				And branch to "QCHNUM" to cause
; 				Application of the last operator.
; 				Eventually RETURN to step 2
; 				By returning to just after "DOPREC".
; 			5. IF greater put the last precedence
; 				Back on, SAVE the operator address,
; 				Current temporary result,
; 				And precedence and RETURN to step 1.

; 		Relational operators are all handled through
; 		A common routine. special
; 		Care is taken to detect type mismatches such as 3+"f".

; 	EVAL -- the routine to READ a lexeme
; 		"EVAL" checks FOR the different types of
; 		Entities it is supposed to detect.
; 		Leading pluses are ignored,
; 		Digits and "." cause "FIN" (floating INPUT)
; 		To be called. function names cause the
; 		Formula inside the parentheses to be evaluated
; 		And the function routine to be called. variable
; 		Names cause "PTRGET" to be called to GET a pointer
; 		To the value, and then the value is put into
; 		The FAC. an open parenthesis causes "FRMEVL"
; 		To be called (recursively), and the ")" to
; 		Be checked FOR. unary operators (not and
; 		Negation)  put their precedence on the stack
; 		And enter formula evaluation at step 1, so
; 		That everything up to an operator greater than
; 		Their precedence or the END of the formula
; 		Will be evaluated.

; 	Dimension and variable searching
; 		Space is allocated FOR variables as they are
; 		Encountered. thus "DIM" statements must be
; 		Executed to have effect. 6 bytes are allocated
; 		FOR each simple variable, whether it is a string,
; 		Number or user defined function. the first two
; 		Bytes give the name of the variable and the last four
; 		Give its value. [VARTAB] gives the first location
; 		Where a simple variable name is found and [ARYTAB]
; 		Gives the location to STOP searching FOR simple
; 		Variables. a "FOR" entry has a text pointer
; 		And a pointer to a variable value so neither
; 		The program or the simple variables can be
; 		Moved while there are active "FOR" entries on the stack.
; 		User defined function values also contain
; 		Pointers into simple variable space so no user-defined
; 		Function values can be retained IF simple variables
; 		Are moved. adding a simple variable is just
; 		Adding six to [ARYTAB] and [STREND], block transfering
; 		The array variables up by six and making sure the
; 		New [STREND] is not too close to the strings.
; 		This movement of array variables means
; 		That no pointer to an array will stay valid when
; 		New simple variables can be encountered. this is
; 		Why array variables are not allowed FOR "FOR"
; 		Loop variables. setting up a new array variable
; 		Merely involves building the descriptor,
; 		Updating [STREND], and making sure there is
; 		Still enough room between [STREND] and string space.
; 		"PTRGET", the routine which returns a pointer
; 		To a variable value, has two important flags. one is
; 		"DIMFLG" which indicates whether "DIM" called "PTRGET"
; 		Or not. IF so, no prior entry FOR the variable in
; 		Question should be found, and the INDEX indicates
; 		How much space to set aside. simple variables can
; 		Be "dimensioned", but the only effect will be to
; 		Set aside space FOR the variable IF it hasn't been
; 		Encountered yet. the other important flag is "SUBFLG"
; 		Which indicates whether a subscripted variable should be
; 		Allowed in the current context. IF [SUBFLG] is non-ZERO
; 		The open parenthesis FOR a subscripted variable
; 		Will not be scanned by "PTRGET", and "PTRGET" will RETURN
; 		With a text pointer pointing to the "(", IF
; 		There was one.
; 	Strings
; 		In the variable tables strings are stored just like
; 		Numeric variables. simple strings have three value
; 		Bytes which are initialized to all zeros (which
; 		Represents the null string). the only difference
; 		In handling is that when "PTRGET" sees a "$" after the
; 		Name of a variable, "PTRGET" sets [VALTYP]
; 		To negative one and turns
; 		On the msb (most-signifigant-bit) of the value of
; 		The first character of the variable name.
; 		Having this bit on in the name of the variable ensures
; 		That the search routine will not match
; 		'A' with 'a$' or 'a$' with 'a'. the meaning of
; 		The three value bytes are:
; 			Low
; 				Length of the string
; 				Low 8 BITS
; 				High 8 BITS  of the address
; 					Of the characters in the
; 					String IF length.ne.0.
; 					Meaningless otherwise.
; 			High
; 		The value of a string variable (these 3 bytes)
; 		Is called the string descriptor to distinguish
; 		It from the actual string DATA. whenever a
; 		String constant is encountered in a formula or as
; 		Part of an INPUT string, or as part of DATA, "STRLIT"
; 		Is called, causing a descriptor to be built FOR
; 		The string. when assignment is made to a string pointing into
; 		"BUF" the value is copied into string space since [BUF]
; 		Is always changing.

; 		String functions and the one string operator "+"
; 		Always RETURN their values in string space.
; 		Assigning a string a constant value in a program
; 		Through a "READ" or assignment statement
; 		Will not use any string space since
; 		The string descriptor  will point into the
; 		Program itself. in general, copying is done
; 		When a string value is in "BUF", or it is in string
; 		Space and there is an active pointer to it.
; 		Thus f$=g$ will cause copying IF g$ has its
; 		String DATA in string space. f$=CHR$(7)
; 		Will use one byte of string space to store the
; 		New one character string created by "CHR$", but
; 		The assignment itself will cause no copying since
; 		The only pointer at the new string is a
; 		Temporary descriptor created by "FRMEVL" which will
; 		Go away as soon as the assignment is done.
; 		It is the nature of garbage collection that
; 		Disallows having two string descriptors point to the same
; 		Area in string space. string functions and operators
; 		Must proceed as follows:
; 			1) Figure out the length of their result.

; 			2) Call "GETSPA" to find space FOR their
; 			Result. the arguments to the function
; 			Or operator may change since garbage collection
; 			May be invoked. the only thing that can
; 			Be saved during the call to "GETSPA" is a pointer
; 			To the descriptors of the arguments.
; 			3) Construct the result descriptor in "DSCTMP".
; 			"GETSPA" returns the location of the available
; 			Space.
; 			4) Create the new value by copying parts
; 			Of the arguments or whatever.
; 			5) Free up the arguments by calling "FRETMP".
; 			6) Jump to "PUTNEW" to GET the descriptor in
; 			"DSCTMP" transferred into a new string temporary.

; 		The REASON FOR string temporaries is that garbage
; 		Collection has to know about all active string descriptors
; 		So it knows what is and isn't in use. string temporaries are
; 		Used to store the descriptors of string expressions.

; 		Instead of having an actual value stored in the
; 		FAC, and having the value of a temporary result
; 		Being saved on the stack, as happens with numeric
; 		Variables, strings have the pointer to a string descriptor
; 		Stored in the FAC, and it is this pointer
; 		That gets saved on the stack by formula evaluation.
; 		String functions cannot free their arguments up RIGHT
; 		Away since "GETSPA" may force
; 		Garbage collection and the argument strings
; 		May be over-written since garbage collection
; 		Will not be able to find an active pointer to
; 		Them. function and operator results are built in
; 		"DSCTMP" since string temporaries are allocated
; 		(PUTNEW) and deallocated (FRETMP) in a fifo ordering
; 		(I.e. a stack) so the new temporary cannot
; 		Be set up until the old one(s) are freed. trying
; 		To build a result in a temporary after
; 		Freeing up the argument temporaries could result
; 		In one of the argument temporaries being overwritten
; 		Too soon by the new result.

; 		String space is allocated at the very top
; 		Of MEMORY. "MEMSIZ" points beyond the last location of
; 		String space. strings are stored in high locations
; 		First. whenever string space is allocated (GETSPA).
; 		[FRETOP], which is initialized to [MEMSIZ], is updated
; 		To give the highest location in string space
; 		That is not in use. the result is that
; 		[FRETOP] gets smaller and smaller, until some
; 		Allocation would make [FRETOP] less than or equal to
; 		[STREND]. this means string space has RUN into the
; 		The arrays and that garbage collection must be called.

; 		Garbage collection:
; 			0. [Minptr]=[STREND] [FRETOP]=[MEMSIZ]
; 			1. [Remmin]=0
; 			2. FOR each string descriptor
; 			(Temporaries, simple strings, string arrays)
; 			IF the string is not null and its pointer is
; 			.Gt.minptr and .lt.FRETOP,
; 			[Minptr]=this string descriptor's pointer,
; 			[Remmin]=pointer at this string descriptor.
; 			END.
; 			3. IF remmin.ne.0 (we found an uncollected string),
; 			Block transfer the string DATA pointed
; 			To in the string descriptor pointed to by "remmin"
; 			So that the last byte of string DATA is at
; 			[FRETOP]. update [FRETOP] so that it
; 			Points to the location just below the one
; 			The string DATA was moved into. update
; 			The pointer in the descriptor so it points
; 			To the new location of the string DATA.
; 			Go to step 1.

; 		After calling garbage collection "GETSPA" again checks
; 		To see IF [acca] characters are available between
; 		[STREND] and [FRETOP]; IF not, an "out of string"
; 		ERROR is invoked.

; 	Math package
; 		The math package contains floating INPUT (FIN),
; 		Floating output (FOUT), floating compare (FCOMP)
; 		... And all the numeric operators and functions.
; 		The formats, conventions and entry points are all
; 		Described in the math package itself.

; 	INIT -- the initialization routine
; 		The amount of MEMORY,
; 		Terminal width, and which functions to be retained
; 		Are ascertained from the user. a ZERO is put down
; 		At the first location not used by the math-package
; 		And [TXTTAB] is set up to point at the NEXT location.
; 		This determines where program storage will START.
; 		Special checks are made to make sure
; 		All questions in "INIT" are answered reasonably, since
; 		Once "INIT" finishes, the locations it uses are
; 		Used FOR program storage. the last thing "INIT" does is
; 		Change location ZERO to be a jump to "READY" instead
; 		Of "INIT". once this is done there is no way to restart
; 		"INIT".
; High locations

        .page
        .subttl PAGE ZERO.
        .IF     REALIO != 3
START:
        JMP     INIT                 ;Initialize - setup certain locations
                                     ;And delete functions IF not needed
                                     ;And change this to "jmp READY"
                                     ;In case user restarts at loc ZERO.
RDYJSR:
        JMP     INIT                 ;Changed to "jmp STROUT" by "INIT"
                                     ;To handle errors.
ADRAYI:
        .word   AYINT                ;Store here the addr of the
                                     ;Routine to turn the FAC into a
                                     ;Two byte signed integer in [y,a]
ADRGAY:
        .word   GIVAYF
        .endif
                                     ;Store here the addr of the
                                     ;Routine to convert [y,a] to a floating
                                     ;Point number in the FAC.
        .IF     ROMSW != 0
USRPOK:
        JMP     FCERR
        .endif
                                     ;Set up orig by INIT.

; This is the "volatile" storage area and none of it
; Can be kept in rom. any constants in this area cannot
; Be kept in a rom, but must be loaded in by the
; Program instructions in rom.

; --- General ram ---:
CHARAC:
        .fill   1                    ;A delimiting character.
INTEGR  =       CHARAC               ;A one-byte integer from "QINT"*
ENDCHR:
        .fill   1                    ;The other delimiting character.
COUNT:
        .fill   1                    ;A general counter.

; --- Flags ---:
DIMFLG:
        .fill   1                    ;In getting a pointer to a variable
                                     ;It is important to remember whether it
                                     ;Is being done FOR "DIM" or not.
                                     ;DIMFLG and VALTYP must be
                                     ;Consecutive locations.
KIMY    =       DIMFLG               ;Place to preserve y during out.
VALTYP:
        .fill   1                    ;The type indicator.
                                     ;0=Numeric 1=string.
        .IF     INTPRC != 0
INTFLG:
        .fill   1
        .endif
                                     ;Tells IF integer.
DORES:
        .fill   1                    ;Whether can or can't CRUNCH res'd WORDS.
                                     ;Turned on when "DATA"
                                     ;Being scanned by CRUNCH so unquoted
                                     ;Strings won't be crunched.
GARBFL  =       DORES                ;Whether to do garbage collection.
SUBFLG:
        .fill   1                    ;Flag whether sub'd variable allowed.
                                     ;"FOR" and user-defined function
                                     ;Pointer fetching turn
                                     ;This on before calling "PTRGET"
                                     ;So arrays won't be detected.
                                     ;"STKINI" and "PTRGET" CLEAR it.
                                     ;Also disallows integers there.
INPFLG:
        .fill   1                    ;Flags whether we are doing "INPUT"
                                     ;Or "READ"*
TANSGN:
        .fill   1                    ;Used in determining SIGN of tangent.
        .IF     REALIO != 0
CNTWFL:
        .fill   1
        .endif
                                     ;Suppress output flag.
                                     ;Non-ZERO means suppress.
                                     ;Reset by "INPUT", READY and errors.
                                     ;Complemented by INPUT of ^o.

        .IF     REALIO == 4
        .org    80
        .endif
                                     ;Room FOR apple page 0 stuff.
; --- Ram dealing with terminal handling ---:
        .IF     EXTIO != 0
CHANNL:
        .fill   1
        .endif
                                     ;Holds channel number.
        .IF     NULCMD != 0
NULCNT:
        .byte   0
        .endif
                                     ;Number of nulls to PRINT.
        .IF     REALIO != 3
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
        .byte   0                    ;Location to store line number before BUF
                                     ;So that "BLTUC" can store it all away at once.
        .byte   44                   ;A comma (preload or from rom)
                                     ;Used by INPUT statement since the
                                     ;DATA pointer always starts on a
                                     ;Comma or terminator.
        .IF     BUFPAG == 0
BUF:
        .fill   BUFLEN
        .endif
                                     ;Type in stored here.
                                     ;Direct statements execute out of
                                     ;Here. remember "INPUT" smashes BUF.
                                     ;Must be on page ZERO
                                     ;Or assignment of string
                                     ;Values in direct statements won't COPY
                                     ;Into string space -- which it must.
                                     ;N.b. two nonzero bytes must precede "buflnm"*

; --- Storage FOR temporary things ---:
TEMPPT:
        .fill   1                    ;Pointer at first free temp descriptor.
                                     ;Initialized to point to TEMPST.
LASTPT:
        .fill   2                    ;Pointer to last-used string temporary.
TEMPST:
        .fill   STRSIZ * NUMTMP      ;Storage FOR NUMTMP temp descriptors.
INDEX1:
        .fill   2                    ;Indexes.
INDEX   =       INDEX1
INDEX2:
        .fill   2
RESHO:
        .fill   1                    ;Result of multiplier and divider.
        .IF     ADDPRC != 0
RESMOH:
        .fill   1
        .endif
                                     ;One more byte.
RESMO:
        .fill   1
RESLO:
        .fill   1
ADDEND  =       RESMO                ;Temporary used by "UMULT"*
        .byte   0                    ;Overflow FOR res.

; --- Pointers into dynamic DATA structures ---;
TXTTAB:
        .fill   2                    ;Pointer to beginning of text.
                                     ;Doesn't change after being
                                     ;Setup by "INIT"*
VARTAB:
        .fill   2                    ;Pointer to START of simple
                                     ;Variable space.
                                     ;Updated whenever the SIZE of the
                                     ;Program changes, set to [TXTTAB]
                                     ;By "scratch" ("new")*
ARYTAB:
        .fill   2                    ;Pointer to beginning of array
                                     ;Table.
                                     ;Incremented by 6 whenever
                                     ;A new simple variable is found, and
                                     ;Set to [VARTAB] by "CLEARC"*
STREND:
        .fill   2                    ;END of storage in use.
                                     ;Increased whenever a new array
                                     ;Or simple variable is encountered.
                                     ;Set to [VARTAB] by "CLEARC"*
FRETOP:
        .fill   2                    ;Top of string free space.
FRESPC:
        .fill   2                    ;Pointer to new string.
MEMSIZ:
        .fill   2                    ;Highest location in MEMORY.

; --- Line numbers and textual pointers ---:
CURLIN:
        .fill   2                    ;Current line #*
                                     ;Set to 0,255 FOR direct statements.
OLDLIN:
        .fill   2                    ;Old line number (setup by ^c,"STOP"
                                     ;Or "END" in a program)*
POKER   =       LINNUM               ;Set up location used by POKE.
                                     ;Temporary FOR INPUT and READ code
OLDTXT:
        .fill   2                    ;Old text pointer.
                                     ;Points at statement to be exec'd NEXT.
DATLIN:
        .fill   2                    ;DATA line # -- remember FOR errors.
DATPTR:
        .fill   2                    ;Pointer to DATA. initialized to point
                                     ;At the ZERO in front of [TXTTAB]
                                     ;By "restore" which is called by "CLEARC"*
                                     ;Updated by execution of a "READ"*
INPPTR:
        .fill   2                    ;This remembers where INPUT is coming from.

; --- Stuff used in evaluations ---:
VARNAM:
        .fill   2                    ;Variable's name is stored here.
VARPNT:
        .fill   2                    ;Pointer to variable in MEMORY.
FDECPT  =       VARPNT               ;Pointer into power of tens of "FOUT"*
FORPNT:
        .fill   2                    ;A variable's pointer FOR "FOR" loops
                                     ;And "LET" statements.
LSTPNT  =       FORPNT               ;Pntr to LIST string.
ANDMSK  =       FORPNT               ;The mask used by wait FOR anding.
EORMSK  =       FORPNT + 1           ;The mask FOR eoring in wait.
OPPTR:
        .fill   2                    ;Pointer to current op's entry in "OPTAB"*
VARTXT  =       OPPTR                ;Pointer into LIST of variables.
OPMASK:
        .fill   1                    ;Mask created by current operator.
DOMASK  =       TANSGN               ;Mask in use by relation operations.
DEFPNT:
        .fill   2                    ;Pointer used in function definition.
GRBPNT  =       DEFPNT               ;Another used in garbage collection.
DSCPNT:
        .fill   2                    ;Pointer to a string descriptor.
        .IF     ADDPRC != 0
        .fill   1
        .endif
                                     ;FOR TEMPF3.
FOUR6:
        .word   STRSIZ               ;Variable constant used by garb collect.

; --- Et cetera ---:
JMPER:
        JMP     60000
SIZE    =       JMPER + 1
OLDOV   =       JMPER + 2            ;The old overflow.
TEMPF3  =       DEFPNT               ;A third FAC temporary (4 bytes)*
TEMPF1:
        .IF     ADDPRC != 0
        .byte   0
        .endif
                                     ;FOR tempf1s extra byte.
HIGHDS:
        .fill   2                    ;Desination of highest element in blt.
HIGHTR:
        .fill   2                    ;Source of highest element to move.
TEMPF2:
        .IF     ADDPRC != 0
        .byte   0
        .endif
                                     ;FOR tempf2s extra byte.
LOWDS:
        .fill   2                    ;Location of last byte transferred into.
LOWTR:
        .fill   2                    ;Last thing to move in blt.
ARYPNT  =       HIGHDS               ;A pointer used in array building.
GRBTOP  =       LOWTR                ;A pointer used in garbage collection.
DECCNT  =       LOWDS                ;Number of places before decimal point.
TENEXP  =       LOWDS + 1            ;Has a dpt been INPUT?
DPTFLG  =       LOWTR                ;Base ten exponent.
EXPSGN  =       LOWTR + 1            ;SIGN of base ten exponent.

; --- The floating accumulator ---:
FAC:
FACEXP:
        .byte   0
FACHO:
        .byte   0                    ;Most significant byte of mantissa.
        .IF     ADDPRC != 0
FACMOH:
        .byte   0
        .endif
                                     ;One more.
FACMO:
        .byte   0                    ;Middle order of mantissa.
FACLO:
        .byte   0                    ;Least sig byte of mantissa.
FACSGN:
        .byte   0                    ;SIGN of FAC (0 or -1) when unpacked.
SGNFLG:
        .byte   0                    ;SIGN of FAC is preserved bere by "FIN"*
DEGREE  =       SGNFLG               ;A COUNT used by polynomials.
DSCTMP  =       FAC                  ;This is where temp descs are built.
INDICE  =       FACMO                ;INDICE is set up here by "QINT"*
BITS:
        .byte   0                    ;Something FOR "SHIFTR" to use.

; --- The floating argument (unpacked) ---:
ARGEXP:
        .byte   0
ARGHO:
        .byte   0
        .IF     ADDPRC != 0
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
        .byte   0                    ;A SIGN reflecting the result.
FACOV:
        .byte   0                    ;Overflow byte of the FAC.
STRNG1  =       ARISGN               ;Pointer to a string or descriptor.

FBUFPT:
        .fill   2                    ;Pointer into FBUFFR used by FOUT.
BUFPTR  =       FBUFPT               ;Pointer to BUF used by "CRUNCH"*
STRNG2  =       FBUFPT               ;Pointer to string or desc.
POLYPT  =       FBUFPT               ;Pointer into polynomial coefficients.
CURTOL  =       FBUFPT               ;Absolute linear INDEX is formed here.
        .page
        .subttl RAM CODE.
; This code gets changed throughout execution.
; It is made to be fast this way.
; Also, [x] and [y] are not disturbed

; "CHRGET" using [TXTPTR] as the current text pntr
; Fetches a new character into acca after incrementing [TXTPTR]
; And sets condition codes according to what's in acca.
;	Not c=	numeric	  ("0" thru "9")
;	Z=	":" or END-of-line (a null)

; [Acca] = new char.
; [TXTPTR]=[TXTPTR]+1

; The following exists in rom IF rom exists and is loaded
; Down here by INIT. otherwise it is just loaded into this
; Ram like all the rest of ram is loaded.

CHRGET:
        INC     CHRGET + 7           ;Increment the whole TXTPTR.
        BNE     CHRGOT
        INC     CHRGET + 8
CHRGOT:
        LDA     60000                ;A LOAD with an ext addr.
TXTPTR  =       CHRGOT + 1
        CMP     #" "                 ;Skip spaces.
        BEQ     CHRGET
QNUM:
        CMP     #":"                 ;Is it a ":"?
        BCS     CHRRTS               ;It is .ge. ":"
        SEC
        SBC     #"0"                 ;All chars .gt. "9" have ret'd so
        SEC
        SBC     #256 - "0"           ;See IF numeric.
                                     ;Turn carry on IF numeric.
                                     ;Also, setz IF null.
CHRRTS:
        RTS                          ;RETURN to caller.

RNDX:
        .byte   128                  ;Loaded or from rom.
        .byte   79                   ;The initial random number.
        .byte   199
        .byte   82
        .IF     ADDPRC != 0
        .byte   89
        .endif
                                     ;One more byte.

        .org    255                  ;Page 1 stuff coming up.
LOFBUF:
        .fill   1                    ;The low FAC buffer. copyable.
;---  Page ZERO/one boundary ---*
                                     ;Must have 13 contiguous bytes.
FBUFFR:
        .fill   3 * ADDPRC + 13      ;Buffer FOR "FOUT"*
                                     ;On page 1 so that string is not copied.

;Stack is located here. ie from the END of FBUFFR to STKEND.
        .page
        .subttl DISPATCH TABLES, RESERVED WORDS, AND ERROR TEXTS.

        .org    ROMLOC

STMDSP:
        .word   END - 1
        .word   FOR - 1
        .word   NEXT - 1
        .word   DATA - 1
        .IF     EXTIO != 0
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
        .IF     NULCMD != 0
        .word   NULL - 1
        .endif
        .word   FNWAIT - 1
        .IF     DISKO != 0
        .IF     REALIO == 3
        .word   CQLOAD - 1
        .word   CQSAVE - 1
        .word   CQVERF - 1
        .endif
        .IF     REALIO != 0
        .IF     REALIO != 2
        .IF     REALIO != 3
        .IF     REALIO != 5
        .word   LOAD - 1
        .word   SAVE - 1
        .endif
        .endif
        .endif
        .endif
        .IF     REALIO != 1
        .IF     REALIO != 3
        .IF     REALIO != 4
        .word   511                  ;Address of LOAD
        .word   511
        .endif
        .endif
        .endif
        .endif
                                     ;Address of SAVE
        .word   DEF - 1
        .word   POKE - 1
        .IF     EXTIO != 0
        .word   PRINTN - 1
        .endif
        .word   PRINT - 1
        .word   CONT - 1
        .IF     REALIO == 0
        .word   DDT - 1
        .endif
        .word   LIST - 1
        .word   CLEAR - 1
        .IF     EXTIO != 0
        .word   CMD - 1
        .word   CQSYS - 1
        .word   CQOPEN - 1
        .word   CQCLOS - 1
        .endif
        .IF     GETCMD != 0
        .word   GET - 1
        .endif
                                     ;Fill w/ GET addr.
        .word   SCRATH - 1

FUNDSP:
        .word   SGN
        .word   INT
        .word   ABS
        .IF     ROMSW == 0
USRLOC:
        .word   FCERR
        .endif
                                     ;Initially no user routine.
        .IF     ROMSW != 0
USRLOC:
        .word   USRPOK
        .endif
        .word   FRE
        .word   POS
        .word   SQR
        .word   RND
        .word   LOG
        .word   EXP
        .IF     KIMROM != 0
        .repeat 4
        .word   FCERR
        .endrepeat
        .endif
        .IF     KIMROM == 0
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

; Tokens FOR reserved WORDS always have the most
; Significant bit on.
; The LIST of reserved WORDS:

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
        .IF     EXTIO != 0
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
        .IF     NULCMD != 0
        DCI     "NULL"
        .endif
        DCI     "WAIT"
        .IF     DISKO != 0
        DCI     "LOAD"
        DCI     "SAVE"
        .IF     REALIO == 3
        DCI     "VERIFY"
        .endif
        .endif
        DCI     "DEF"
        DCI     "POKE"
        .IF     EXTIO != 0
        DCI     "PRINT#"
        .endif
        DCI     "PRINT"
PRINTK  =       Q
        DCI     "CONT"
        .IF     REALIO == 0
        DCI     "DDT"
        .endif
        DCI     "LIST"
        .IF     REALIO != 3
        DCI     "CLEAR"
        .endif
        .IF     REALIO == 3
        DCI     "CLR"
        .endif
        .IF     EXTIO != 0
        DCI     "CMD"
        DCI     "SYS"
        DCI     "OPEN"
        DCI     "CLOSE"
        .endif
        .IF     GETCMD != 0
        DCI     "GET"
        .endif
        DCI     "NEW"
SCRATK  =       Q
; END of command LIST.
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
        .byte   190                  ;A greater than SIGN
Q       =       Q + 1
GREATK  =       Q
        DCI     "="
EQULTK  =       Q
        .byte   188
Q       =       Q + 1                ;A less than SIGN
LESSTK  =       Q

; Note danger of one reserved word being a part
; Of another:
; Ie * * IF 2 greater than f or t=5 then...
; Will not work!!! since "FOR" will be crunched!!
; In any case make sure the smaller word appears
; Second in the reserved word table ("inp" and "INPUT")
; Another example: IF t or Q then ... "to" is crunched

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
        .byte   0                    ;Marks END of reserved word LIST

        .IF     LNGERR == 0
Q       =       0 - 2
        .macro  DCE, X1
Q       =       Q + 2
        .textc  \X1
        .endmacro
ERRTAB:
        DCE     "NF"
ERRNF   =       Q                    ;NEXT without FOR.
        DCE     "SN"
ERRSN   =       Q                    ;Syntax
        DCE     "RG"
ERRRG   =       Q                    ;RETURN without GOSUB.
        DCE     "OD"
ERROD   =       Q                    ;Out of DATA.
        DCE     "FC"
ERRFC   =       Q                    ;Illegal quantity.
        DCE     "OV"
ERROV   =       Q                    ;Overflow.
        DCE     "OM"
ERROM   =       Q                    ;Out of MEMORY.
        DCE     "US"
ERRUS   =       Q                    ;Undefined statement.
        DCE     "BS"
ERRBS   =       Q                    ;Bad subscript.
        DCE     "DD"
ERRDD   =       Q                    ;Redimensioned array.
        DCE     "/0"
ERRDV0  =       Q                    ;Division by ZERO.
        DCE     "ID"
ERRID   =       Q                    ;Illegal direct.
        DCE     "TM"
ERRTM   =       Q                    ;Type mismatch.
        DCE     "LS"
ERRLS   =       Q                    ;String too long.
        .IF     EXTIO != 0
        DCE     "FD"                 ;File DATA.
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

        .IF     LNGERR != 0
Q       =       0
; Note: this ERROR COUNT technique will not work IF there are more
; Than 256 characters of ERROR messages
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
        .IF     EXTIO != 0
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

; Needed FOR messages in all versions.

ERR:
        .text   " ERROR"
        .byte   0
INTXT:
        .text   " IN "
        .byte   0
REDDY:
        ACRLF
        .IF     REALIO == 3
        .text   "READY."
        .endif
        .IF     REALIO != 3
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

; Find a "FOR" entry on the stack via "VARPNT"*

FORSIZ  =       2 * ADDPRC + 16
FNDFOR:
        TSX                          ;LOAD xreg with stk pntr.
        .repeat 4
        INX
        .endrepeat
                                     ;IGNORE .word NEWSTT AND RTS ADDR.
FFLOOP:
        LDA     257,X                ;GET stack entry.
        CMP     #FORTK               ;Is it a "FOR" token?
        BNE     FFRTS                ;No, no "FOR" loops with this pntr.
        LDA     FORPNT + 1           ;GET high.
        BNE     CMPFOR
        LDA     258,X                ;Pntr is ZERO, so assume this one.
        STA     FORPNT
        LDA     259,X
        STA     FORPNT + 1
CMPFOR:
        CMP     259,X
        BNE     ADDFRS               ;Not this one.
        LDA     FORPNT               ;GET down.
        CMP     258,X
        BEQ     FFRTS                ;We got it! we got it!
ADDFRS:
        TXA
        CLC                          ;Add 16 to x.
        ADC     #FORSIZ
        TAX                          ;Result back into x.
        BNE     FFLOOP
FFRTS:
        RTS                          ;RETURN to caller.

; THIS IS THE .fill TRANSFER ROUTINE.
; It makes space by shoving everything forward.

; On entry:
; [Y,a]=[HIGHDS]    (FOR REASON)*
; [HIGHDS]= destination of [high address]*
; [LOWTR]= lowest addr to be transferred.
; [HIGHTR]= highest addr to be transferred.

; A check is made to ascertain that a reasonable
; Amount of space remains between the bottom
; Of the strings and the highest location transferred into.

; On exit:
; [LOWTR] are unchanged.
; [HIGHTR]=[LOWTR]-200 octal.
; [HIGHDS]=lowest addr transferred into minus 200 octal.

BLTU:
        JSR     REASON               ;Ascertain that string space won't
                                     ;Be overrun.
        STWD    STREND
BLTUC:
        SEC                          ;Prepare to subtract.
        LDA     HIGHTR
        SBC     LOWTR                ;Compute number of things to move.
        STA     INDEX                ;SAVE FOR later.
        TAY
        LDA     HIGHTR + 1
        SBC     LOWTR + 1
        TAX                          ;Put it in a counter register.
        INX                          ;So that counter algorithm works.
        TYA                          ;See IF low part of COUNT is ZERO.
        BEQ     DECBLT               ;Yes, go START moving blocks.
        LDA     HIGHTR               ;No, must modify base addr.
        SEC
        SBC     INDEX                ;Borrow is off since [HIGHTR].gt.[LOWTR]*
        STA     HIGHTR               ;SAVE modified base addr.
        BCS     BLT1                 ;IF no borrow, go shove it.
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
        DEC     HIGHDS + 1           ;START on new blocks.
        DEX
        BNE     MOREN1
        RTS                          ;RETURN to caller.

; This routine is used to ascertain that a given
; Number of locs remain available FOR the stack.
;    The call is:
;	Lda #number of 2-byte entries needed.
;	Jsr	GETSTK

; This routine must be called by any routine which puts
; An arbitrary amount of stuff on the stack
; I.e., any recursive routine like "FRMEVL"*
; It is also called by routines such as "GOSUB" and "FOR"
; Which make permanent entries on the stack.

; Routines which merely use and free up the guaranteed
; NUMLEV locations need not call this.

; On exit:
;    [A] and [x] have been modified.

GETSTK:
        ASL     A                    ;Mult [a] by 2. nb, clears c bit.
        ADC     #2 * NUMLEV + 3 * ADDPRC + 13 ;Make sure 2*NUMLEV+13 locs
                                     ;(13 Because of FBUFFR)
        BCS     OMERR                ;Will remain in stack.
        STA     INDEX
        TSX                          ;GET stacked.
        CPX     INDEX                ;Compare.
        BCC     OMERR                ;IF stack.le.INDEX1, om.
        RTS

; [Y,a] is a certain address. "REASON" makes sure
; It is less than [FRETOP]*

REASON:
        CPY     FRETOP + 1
        BCC     REARTS
        BNE     TRYMOR               ;Go garb collect.
        CMP     FRETOP
        BCC     REARTS
TRYMOR:
        PHA
        LDX     #8 + ADDPRC          ;IF TEMPF2 has ZERO in between.
        TYA
REASAV:
        PHA
        LDA     HIGHDS - 1,X         ;SAVE HIGHDS on stack.
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
        .IF     REALIO != 0
        LSR     CNTWFL
        .endif
                                     ;Force output.
        .IF     EXTIO != 0
        LDA     CHANNL               ;Close non-terminal channel.
        BEQ     ERRCRD
        JSR     CQCCHN               ;Close it.
        LDA     #0
        STA     CHANNL
        .endif
ERRCRD:
        JSR     CRDO                 ;Output crlf.
        JSR     OUTQST               ;PRINT a question mark
        .IF     LNGERR == 0
        LDA     ERRTAB,X             ;GET first CHR of ERR msg.
        JSR     OUTDO                ;Output it.
        LDA     ERRTAB + 1,X         ;GET second CHR.
        JSR     OUTDO
        .endif
                                     ;Output it.
        .IF     LNGERR != 0
GETERR:
        LDA     ERRTAB,X
        PHA
        AND     #127                 ;GET rid of high bit.
        JSR     OUTDO                ;Output it.
        INX
        PLA                          ;Last char of message?
        BPL     GETERR
        .endif
                                     ;No. go GET NEXT and output it.
TYPERR:
        JSR     STKINI               ;Reset the stack and flags.
        LDWDI   ERR                  ;GET pntr to " ERROR"*
ERRFIN:
        JSR     STROUT               ;Output it.
        LDY     CURLIN + 1
        INY                          ;Was number 64000?
        BEQ     READY                ;Yes, don't type line number.
        JSR     INPRT
READY:
        .IF     REALIO != 0
        LSR     CNTWFL
        .endif
                                     ;Turn output back on IF supressed
        LDWDI   REDDY                ;Say "ok"*
        .IF     REALIO != 3
        JSR     RDYJSR
        .endif
                                     ;Or go to INIT IF INIT ERROR.
        .IF     REALIO == 3
        JSR     STROUT
        .endif
                                     ;No INIT errors possible.
MAIN:
        JSR     INLIN                ;GET a line from terminal.
        STXY    TXTPTR
        JSR     CHRGET
        TAX                          ;Set ZERO flag based on [a]
                                     ;This distinguishes ":" and 0
        BEQ     MAIN                 ;IF blank line, GET another.
        LDX     #255                 ;Set direct line number.
        STX     CURLIN + 1
        BCC     MAIN1                ;Is a line number. not direct.
        JSR     CRUNCH               ;Compactify.
        JMP     GONE                 ;Execute it.
MAIN1:
        JSR     LINGET               ;READ line number into "LINNUM"*
        JSR     CRUNCH
        STY     COUNT                ;Retain character COUNT.
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
        ADC     VARTAB               ;Compute new VARTAB.
        STA     VARTAB
        STA     INDEX2               ;Set low of trans to.
        LDA     VARTAB + 1
        ADC     #255
        STA     VARTAB + 1           ;Compute high of VARTAB.
        SBC     LOWTR + 1            ;Compute number of blocks to move.
        TAX
        SEC
        LDA     LOWTR
        SBC     VARTAB               ;Compute offset.
        TAY
        BCS     QDECT1               ;IF VARTAB.le.LOWTR
        INX                          ;Decr due to carry, and
        DEC     INDEX2 + 1           ;Decrement store so carry works.
QDECT1:
        CLC
        ADC     INDEX1
        BCC     MLOOP
        DEC     INDEX1 + 1
        CLC                          ;FOR later adcq
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
                                     ;Collection caused by REASON will work
        JSR     LNKPRG               ;Fix up the links
        LDA     BUF                  ;See IF anythng there
        BEQ     MAIN
        CLC
        LDA     VARTAB
        STA     HIGHTR               ;Setup HIGHTR.
        ADC     COUNT                ;Add length of line to insert.
        STA     HIGHDS               ;This gives dest addr.
        LDY     VARTAB + 1
        STY     HIGHTR + 1           ;Same FOR high orders.
        BCC     NODELC
        INY
NODELC:
        STY     HIGHDS + 1
        JSR     BLTU
        .IF     BUFPAG != 0
        LDWD    LINNUM               ;Position the binary line number
        STWD    BUF - 2
        .endif
                                     ;In front of BUF
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
        JSR     RUNC                 ;Do CLEAR & set up stack.
                                     ;And set [TXTPTR] to [TXTTAB]-1.
        JSR     LNKPRG               ;Fix up program links
        JMP     MAIN
LNKPRG:
        LDWD    TXTTAB               ;Set [INDEX] to [TXTTAB]*
        STWD    INDEX
        CLC

; CHEAD goes through program storage and fixes
; Up all the links. the END of each line is found
; By searching FOR the ZERO at the END.
; The double ZERO link is used to detect the END of the program.

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

; This is the line INPUT routine.
; It reads characters into BUF using backarrow (underscore, or
; Shift o) as the delete character and @ as the
; Line delete character. IF more than BUFLEN characters
; Are typed, no echoing is done until a backarrow or @ or cr
; Is typed. control-g will be typed FOR each extra character.
; The routine is entered at INLIN.

        .IF     REALIO == 4
INLIN:
        LDX     #128                 ;No prompt character
        STX     CQPRMP
        JSR     CQINLN               ;GET a line onto page 2
        CPX     #BUFLEN - 1
        BCS     GDBUFS               ;Not too many characters
        LDX     #BUFLEN - 1
GDBUFS:
        LDA     #0                   ;Put a ZERO at the END
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
        .IF     REALIO != 4
        .IF     REALIO != 3
LINLIN:
        .IF     REALIO == 2
        JSR     OUTDO
        .endif
                                     ;Echo it.
        DEX                          ;Backarrow so backup pntr and
        BPL     INLINC               ;GET another IF COUNT is positive.
INLINN:
        .IF     REALIO == 2
        JSR     OUTDO
        .endif
                                     ;PRINT the @ or a second backarrow
                                     ;IF there were too many.
        JSR     CRDO
        .endif
INLIN:
        LDX     #0
INLINC:
        JSR     INCHR                ;GET a character.
        .IF     REALIO != 3
        CMP     #7                   ;Is it bob albrecht ringing the bell
                                     ;FOR school kids?
        BEQ     GOODCH
        .endif
        CMP     #13                  ;Carriage RETURN?
        BEQ     FININ1               ;Yes, finish up.
        .IF     REALIO != 3
        CMP     #32                  ;Check FOR funny characters.
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
        .IF     REALIO != 3
        CPX     #BUFLEN - 1          ;Leave room FOR null.
                                     ;Commo assures us never more than BUFLEN.
        BCS     OUTBEL
        .endif
        STA     BUF,X
        INX
        .IF     REALIO == 2
        SKIP2
        .endif
        .IF     REALIO != 2
        BNE     INLINC
        .endif
        .IF     REALIO != 3
OUTBEL:
        LDA     #7
        .IF     REALIO != 0
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
        .IF     REALIO == 3
        JSR     CQINCH
        .endif
                                     ;FOR commodore.
        .IF     REALIO == 2
INCHRL:
        LDA     0o176000
        .repeat 4
        NOP
        .endrepeat
        LSR     A
        BCC     INCHRL
        LDA     0o176001             ;GET the character.
        .repeat 4
        NOP
        .endrepeat
        AND     #127
        .endif
        .IF     REALIO == 1
        JSR     0o17132
        .endif
                                     ;1E5a FOR mos tech.
        .IF     REALIO == 4
        JSR     CQINCH               ;Fd0c FOR apple computer.
        AND     #127
        .endif
        .IF     REALIO == 0
	TJSR	INSIM##
        .endif
                                     ;GET a character from simulator

        .IF     REALIO != 0
        .IF     EXTIO != 0
        LDY     CHANNL               ;Cnt-o has no effect IF not from term.
        BNE     INCRTS
        .endif
        CMP     #CONTW               ;Suppress output character (^w)*
        BNE     INCRTS               ;No, RETURN.
        PHA
        COM     CNTWFL               ;Complement its state.
        PLA
        .endif
INCRTS:
        RTS                          ;END of INCHR.

; All "reserved" WORDS are translated into single
; Bytes with the msb on. this saves space and TIME
; By allowing FOR table dispatch during execution.
; Therefore all statements appear together in the
; Reserved word LIST in the same order they
; Appear in STMDSP.

BUFOFS  =       0                    ;The amount to offset the low byte
                                     ;Of the text pointer to GET to BUF
                                     ;After TXTPTR has been setup to point into BUF
        .IF     BUFPAG != 0
BUFOFS  =       BUF / 256 * 256
        .endif
CRUNCH:
        LDX     TXTPTR               ;Set source pointer.
        LDY     #4                   ;Set destination offset.
        STY     DORES                ;Allow crunching.
KLOOP:
        LDA     BUFOFS,X
        .IF     REALIO == 3
        BPL     CMPSPC               ;Go look at spaces.
        CMP     #PI                  ;Pi??
        BEQ     STUFFH               ;Go SAVE it.
        INX                          ;Skip no printing.
        BNE     KLOOP
        .endif
                                     ;Always goes.
CMPSPC:
        CMP     #" "                 ;Is it a space to SAVE?
        BEQ     STUFFH               ;Yes, go SAVE it.
        STA     ENDCHR               ;IF it's a quote, this will
                                     ;STOP loop when other quote appears.
        CMP     #34                  ;Quote SIGN?
        BEQ     STRNG                ;Yes, do special string handling.
        BIT     DORES                ;Test flag.
        BVS     STUFFH               ;No CRUNCH, just store.
        CMP     #"?"                 ;A qmark?
        BNE     KLOOP1
        LDA     #PRINTK              ;Yes, stuff a "PRINT" token.
        BNE     STUFFH               ;Always go to STUFFH.
KLOOP1:
        CMP     #"0"                 ;Skip numerics.
        BCC     MUSTCR
        CMP     #60                  ;":" And ";" are entered straightaway.
        BCC     STUFFH
MUSTCR:
        STY     BUFPTR               ;SAVE buffer pointer.
        LDY     #0                   ;LOAD RESLST pointer.
        STY     COUNT                ;Also CLEAR COUNT.
        DEY
        STX     TXTPTR               ;SAVE text pointer FOR later use.
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
        CMP     #128                 ;No but maybe the END is here.
        BNE     NTHIS                ;No, truly unequal.
        ORA     COUNT
GETBPT:
        LDY     BUFPTR               ;GET buffer pntr.
STUFFH:
        INX
        INY
        STA     BUF - 5,Y
        LDA     BUF - 5,Y
        BEQ     CRDONE               ;Null implies END of line.
        SEC                          ;Prepare to substarct.
        SBC     #":"                 ;Is it a ":"?
        BEQ     COLIS                ;Yes, allow crunching again.
        CMP     #DATATK - ":"        ;Is it a DATATK?
        BNE     NODATT               ;No, see IF it is REM token.
COLIS:
        STA     DORES                ;Setup flag.
NODATT:
        SEC                          ;Prep to sbcq
        SBC     #REMTK - ":"         ;REM only stops on null.
        BNE     KLOOP                ;No, continue crunching.
        STA     ENDCHR               ;REM stops only on null, not : or "*
STR1:
        LDA     BUFOFS,X
        BEQ     STUFFH               ;Yes, END of line, so done.
        CMP     ENDCHR               ;END of gobble?
        BEQ     STUFFH               ;Yes, done with string.
STRNG:
        INY                          ;Increment buffer pointer.
        STA     BUF - 5,Y
        INX
        BNE     STR1                 ;Process NEXT character.
NTHIS:
        LDX     TXTPTR               ;Restore text pointer.
        INC     COUNT                ;Increment res word COUNT.
NTHIS1:
        INY
        LDA     RESLST - 1,Y         ;GET res character.
        BPL     NTHIS1               ;END of entry?
        LDA     RESLST,Y             ;Yes. is it the END?
        BNE     RESCON               ;No, try the NEXT word.
        LDA     BUFOFS,X             ;Yes, END of table. GET 1st CHR.
        BPL     GETBPT               ;Store it away (always branches)*
CRDONE:
        STA     BUF - 3,Y            ;So that IF this is a dir statement
                                     ;Its END will look like END of program.
        .IF     (BUF + BUFLEN) / 256 - (BUF - 1) / 256 != 0
        DEC     TXTPTR + 1
        .endif
        LDA     #(BUF & 255) - 1     ;Make TXTPTR point to
        STA     TXTPTR               ;Crunched line.
LISTRT:
        RTS                          ;RETURN to caller.

; FNDLIN searches the program text FOR the line
; Whose number is passed in "LINNUM"*
; There are two possible returns:

;	1) Carry set.
;	   LOWTR points to the link field in the line
;	   Which is the one searched FOR.

;	2) Carry not set.
;	   Line not found. [LOWTR] points to the line in the
;	   Program greater than the one sought after.

FNDLIN:
        LDWX    TXTTAB               ;LOAD [x,a] with [TXTTAB]
FNDLNC:
        LDY     #1
        STWX    LOWTR                ;Store [x,a] into LOWTR
        LDA     (LOWTR),Y            ;See IF link is 0
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
        RTS                          ;RETURN to caller.

; The "new" command clears the program text as well
; As variable space.

SCRATH:
        BNE     FLNRTS               ;Make sure there is a terminator.
SCRTCH:
        LDA     #0                   ;GET a clearer.
        TAY                          ;Set up INDEX.
        STA     (TXTTAB),Y           ;CLEAR	first link.
        INY
        STA     (TXTTAB),Y
        LDA     TXTTAB
        CLC
        ADC     #2
        STA     VARTAB               ;Setup [VARTAB]*
        LDA     TXTTAB + 1
        ADC     #0
        STA     VARTAB + 1
RUNC:
        JSR     STXTPT
        LDA     #0                   ;Set ZERO flag

; This code is FOR the CLEAR command.

CLEAR:
        BNE     STKRTS               ;Syntax ERROR IF no terminator.

; CLEAR initializes the variable and
; Array space by reseting ARYTAB (the END of simple variable space)
; And STREND (the END of array storage)* it falls into "STKINI"
; Which resets the stack.

CLEARC:
        LDWD    MEMSIZ               ;Free up string space.
        STWD    FRETOP
        .IF     EXTIO != 0
        JSR     CQCALL
        .endif
                                     ;Close all open files.
        LDWD    VARTAB               ;Liberate the
        STWD    ARYTAB               ;Variables and
        STWD    STREND               ;Arrays.
FLOAD:
        JSR     RESTOR               ;Restore DATA.

; STKINI resets the stack pointer eliminating
; GOSUB and FOR context. string temporaries are freed
; Up, SUBFLG is reset. continuing is prohibited.
; And a dummy entry is LEFT at the bottom of the stack so "FNDFOR" will always
; Find a non-"FOR" entry at the bottom of the stack.

STKINI:
        LDX     #TEMPST              ;Initialize string temporaries.
        STX     TEMPPT
        PLA                          ;Setup RETURN address.
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
        BNE     STKRTS               ;No, so syntax ERROR.
GOLST:
        JSR     LINGET               ;GET line number into numlin.
        JSR     FNDLIN               ;Find line .ge. [numlin]*
        JSR     CHRGOT               ;GET last character.
        BEQ     LSTEND               ;IF END of line, # is the END.
        CMP     #MINUTK              ;Dash?
        BNE     FLNRTS               ;IF not, syntax ERROR.
        JSR     CHRGET               ;GET NEXT char.
        JSR     LINGET               ;GET END #*
        BNE     FLNRTS               ;IF not terminator, ERROR.
LSTEND:
        PLA
        PLA                          ;GET rid of "NEWSTT" rts addr.
        LDA     LINNUM               ;See IF it was existent.
        ORA     LINNUM + 1
        BNE     LIST4                ;It was typed.
        LDA     #255
        STA     LINNUM
        STA     LINNUM + 1           ;Make it huge.
LIST4:
        LDY     #1
        .IF     REALIO == 3
        STY     DORES
        .endif
        LDA     (LOWTR),Y            ;Is link ZERO?
        BEQ     GRODY                ;Yes, go to READY.
        .IF     REALIO != 0
        JSR     ISCNTC
        .endif
                                     ;Listen FOR CONT-c.
        JSR     CRDO                 ;PRINT crlf to START with.
        INY
        LDA     (LOWTR),Y
        TAX
        INY
        LDA     (LOWTR),Y            ;GET line number.
        CMP     LINNUM + 1           ;See IF beyond last.
        BNE     TSTDUN               ;Go determine relation.
        CPX     LINNUM               ;Was equal so test low order.
        BEQ     TYPLIN               ;Equal, so LIST it.
TSTDUN:
        BCS     GRODY                ;IF line is gr than last, then dune.
TYPLIN:
        STY     LSTPNT
        JSR     LINPRT               ;PRINT as INT without leading space.
        LDA     #" "                 ;Always PRINT space after number.
PRIT4:
        LDY     LSTPNT               ;GET pointer to line back.
        AND     #127
PLOOP:
        JSR     OUTDO                ;PRINT char.
        .IF     REALIO == 3
        CMP     #34
        BNE     PLOOP1
        COM     DORES
        .endif
                                     ;IF quote, complement flag.
PLOOP1:
        INY
        BEQ     GRODY                ;IF we have printed 256 characters
                                     ;The program must be misformated in
                                     ;MEMORY due to a bad LOAD or bad
                                     ;Hardware. LET the guy recover
        LDA     (LOWTR),Y            ;GET NEXT char. is it ZERO?
        BNE     QPLOP                ;Yes. END of line.
        TAY
        LDA     (LOWTR),Y
        TAX
        INY
        LDA     (LOWTR),Y
        STX     LOWTR
        STA     LOWTR + 1
        BNE     LIST4                ;Branch IF something to LIST.
GRODY:
        JMP     READY
                                     ;Is it a token?
QPLOP:
        BPL     PLOOP                ;No, head FOR printer.
        .IF     REALIO == 3
        CMP     #PI
        BEQ     PLOOP
        BIT     DORES                ;Inside quote marks?
        BMI     PLOOP
        .endif
                                     ;Yes, just type the character.
        SEC
        SBC     #127                 ;GET rid of SIGN bit and add 1.
        TAX                          ;Make it a counter.
        STY     LSTPNT               ;SAVE pointer to line.
        LDY     #255                 ;Look at res'd word LIST.
RESRCH:
        DEX                          ;Is this the res'd word?
        BEQ     PRIT3                ;Yes, go toss it up..
RESCR1:
        INY
        LDA     RESLST,Y             ;END of entry?
        BPL     RESCR1               ;No, continue passing.
        BMI     RESRCH
PRIT3:
        INY
        LDA     RESLST,Y
        BMI     PRIT4                ;END of reserved word.
        JSR     OUTDO                ;PRINT it.
        BNE     PRIT3                ;END of entry? no, type rest.
        .page
        .subttl THE "FOR" STATEMENT.

; A "FOR" entry on the stack has the following format:

; Low address
;	Token (FORTK) 1 byte
;	A pointer to the loop variable 2 bytes
;	The step 4+ADDPRC bytes
;	A byte reflecting the SIGN of the increment 1 byte
;	The upper value 4+ADDPRC bytes
;	The line number of the "FOR" statement 2 bytes
;	A text pointer into the "FOR" statement 2 bytes
; High address

; Total 16+2*ADDPRC bytes.

FOR:
        LDA     #128                 ;Don't recognize
        STA     SUBFLG               ;Subscripted variables.
        JSR     LET                  ;READ the variable and assign it
                                     ;The correct initial value and store
                                     ;A pointer to the variable in VARPNT.
        JSR     FNDFOR               ;Pntr is in VARPNT, and FORPNT.
        BNE     NOTOL                ;IF no match, don't eliminate anything.
        TXA                          ;Make it arithmetical.
        ADC     #FORSIZ - 3          ;Eliminate almost all.
        TAX                          ;Note c=1, then pla, pla.
        TXS                          ;Manifest.
NOTOL:
        PLA                          ;GET rid of NEWSTT RETURN address
        PLA                          ;In case this is a totally new entry.
        LDA     #8 + ADDPRC
        JSR     GETSTK               ;Make sure 16 bytes are available.
        JSR     DATAN                ;GET a COUNT in [y] of the number of
                                     ;Chacracters LEFT in the "FOR" statement
                                     ;[TXTPTR] is unaffected.
        CLC                          ;Prep to add.
        TYA                          ;SAVE it FOR pushing.
        ADC     TXTPTR
        PHA
        LDA     TXTPTR + 1
        ADC     #0
        PHA
        PSHWD   CURLIN               ;Put line number on stack.
        SYNCHK  TOTK                 ;"To" is necessary.
        JSR     CHKNUM               ;Value must be a number.
        JSR     FRMNUM               ;GET upper value into FAC.
        LDA     FACSGN               ;Pack FAC.
        ORA     #127
        AND     FACHO
        STA     FACHO                ;Set packed SIGN bit.
        LDWDI   LDFONE
        STWD    INDEX1
        JMP     FORPSH               ;Put FAC onto stack, packed.
LDFONE:
        LDWDI   FONE                 ;Put 1.0 into FAC.
        JSR     MOVFM
        JSR     CHRGOT
        CMP     #STEPTK              ;A step is given?
        BNE     ONEON                ;No. assume 1.0.
        JSR     CHRGET               ;Yes. advance pointer.
        JSR     FRMNUM               ;READ the step.
ONEON:
        JSR     SIGN                 ;GET SIGN in acca.
        JSR     PUSHF                ;Push FAC onto stack (thru a)*
        PSHWD   FORPNT               ;Put pntr to variable on stack.
NXTCON:
        LDA     #FORTK               ;Put a FORTK onto stack.
        PHA
;	Bnea	NEWSTT		;simulate bne to NEWSTT. just fall in.
        .page
        .subttl NEW STATEMENT FETCHER.

; Back here FOR new statement. character pointed to by TXTPTR
; Is ":" or END-of-line. the address of this loc is LEFT
; On the stack when a statement is executed so that
; It can merely do a rts when it is done.

NEWSTT:
        .IF     REALIO != 0
        JSR     ISCNTC
        .endif
                                     ;Listen FOR control-c.
        LDWD    TXTPTR               ;Look at current character.
        .IF     BUFPAG != 0
        CPY     #BUFPAG
        .endif
                                     ;See IF it was direct by check FOR BUF's page number
        BEQ     DIRCON
        STWD    OLDTXT               ;SAVE in case of restart by INPUT.
        .IF     BUFPAG != 0
DIRCON:
        .endif
        LDY     #0
        .IF     BUFPAG == 0
DIRCON:
        .endif
        LDA     (TXTPTR),Y
        BNE     MORSTS               ;Not null -- check what it is
        LDY     #2                   ;Look at link.
        LDA     (TXTPTR),Y           ;Is link 0?
        CLC                          ;CLEAR carry FOR ENDCON and math that follows
        JEQ     ENDCON               ;Yes - ran off the END.
        INY                          ;Put line number in CURLIN.
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
        JSR     CHRGET               ;GET the statement type.
        JSR     GONE3
        JMP     NEWSTT
GONE3:
        BEQ     ISCRTS               ;IF terminator, try again.
                                     ;No need to set up carry since it will
                                     ;Be on IF non-numeric and numerics
                                     ;Will cause a syntax ERROR like they should
GONE2:
        SBC     #ENDTK               ;" On ... GOTO and GOSUB" come here.
        BCC     GLET
        CMP     #SCRATK - ENDTK + 1
        BCS     SNERRX               ;Some res'd word but not
                                     ;A statement res'd word.
        ASL     A                    ;Multiply by two.
        TAY                          ;Make an INDEX.
        LDA     STMDSP + 1,Y
        PHA
        LDA     STMDSP,Y
        PHA                          ;Put disp addr onto stack.
        JMP     CHRGET
GLET:
        JMP     LET                  ;Must be a LET
MORSTS:
        CMP     #":"
        BEQ     GONE                 ;IF a ":" continue statement
SNERR1:
        JMP     SNERR                ;Neither 0 or ":" so syntax ERROR
SNERRX:
        CMP     #GOTK - ENDTK
        BNE     SNERR1
        JSR     CHRGET               ;READ in the character after "go "
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
        STWD    DATPTR               ;READ finishes come to "RESFIN"*
ISCRTS:
        RTS

        .IF     REALIO == 1
ISCNTC:
        LDA     #1
        BIT     0o13500
        BMI     ISCRTS
        LDX     #8
        LDA     #3
        CMP     #3
        .endif
        .IF     REALIO == 2
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

        .IF     REALIO == 4
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
        BNE     CONTRT               ;RETURN IF not CONT-c or
                                     ;IF no terminator FOR STOP or END.
                                     ;[C]=0 so will not PRINT "break"*
        LDWD    TXTPTR
        .IF     BUFPAG != 0
        LDX     CURLIN + 1
        INX
        .endif
        BEQ     DIRIS
        STWD    OLDTXT
STPEND:
        LDWD    CURLIN
        STWD    OLDLIN
DIRIS:
        PLA                          ;Pop off NEWSTT addr.
        PLA
ENDCON:
        LDWDI   BRKTXT
        .IF     REALIO != 0
        LDX     #0
        STX     CNTWFL
        .endif
        BCC     GORDY                ;Carry CLEAR so don't PRINT "break"*
        JMP     ERRFIN
GORDY:
        JMP     READY                ;Type "READY"*

        .IF     REALIO == 0
DDT:
        PLA                          ;GET rid of NEWSTT RETURN.
        PLA
                                     ; Hrrz	14,.jbddt##
	JRST	0(14)
        .endif
CONT:
        BNE     CONTRT               ;Make sure there is a terminator.
        LDX     #ERRCN               ;Continue ERROR.
        LDY     OLDTXT + 1           ;A stored TXTPTR of ZERO is setup
                                     ;By STKINI and indicates there is
                                     ;Nothing to continue.
        JEQ     ERROR                ;"STOP", "END", typing crlf to
                                     ;"INPUT" and  ^c setup OLDTXT.
        LDA     OLDTXT
        STWD    TXTPTR
        LDWD    OLDLIN
        STWD    CURLIN
CONTRT:
        RTS                          ;RETURN to caller.

        .IF     NULCMD != 0
NULL:
        JSR     GETBYT
        BNE     CONTRT               ;Make sure there is terminator.
        INX
        CPX     #240                 ;Is the number reasonable?
        BCS     FCERR1               ;"Function call" ERROR.
        DEX                          ;Back -1
        STX     NULCNT
        RTS
FCERR1:
        JMP     FCERR
        .endif
        .page
        .subttl LOAD AND SAVE SUBROUTINES.

        .IF     REALIO == 1
                                     ;Kim cassette i/o
SAVE:
        TSX                          ;SAVE stack pointer
        STX     INPFLG
        LDA     #STKEND - 256 - 200
        STA     0o362                ;Setup dummy stack FOR kim monitor
        LDA     #254                 ;Make id byte equal to ff hex
        STA     0o13771              ;Store into kim id
        LDWD    TXTTAB               ;START dumping from TXTTAB
        STWD    0o13765              ;Setup sal,sah
        LDWD    VARTAB               ;STOP at VARTAB
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
        LDWD    TXTTAB               ;START dumping in at TXTTAB
        STWD    0o13765              ;Setup sal,sah
        LDA     #255
        STA     0o13771
        LDWDI   RTLOAD
        STWD    1                    ;Set up RETURN address FOR LOAD
        JMP     0o14163              ;Go READ the DATA in
RTLOAD:
        LDX     #STKEND - 256        ;Reset the stack
        TXS
        LDWDI   READY
        STWD    1
        LDWDI   GLOAD                ;Tell him it worked
        JSR     STROUT
        LDXY    0o13755              ;GET last location
        TXA                          ;Its one too big
        BNE     DECVRT               ;Decrement [x,y]
        NOP
DECVRT:
        NOP
        STXY    VARTAB               ;Setup new variable location
        JMP     FINI
        .endif
                                     ;Relink the program
        .IF     REALIO == 4
SAVE:
        SEC                          ;Calcluate program SIZE in POKER
        LDA     VARTAB
        SBC     TXTTAB
        STA     POKER
        LDA     VARTAB + 1
        SBC     TXTTAB + 1
        STA     POKER + 1
        JSR     VARTIO
        JSR     CQCOUT               ;Write program SIZE [POKER]
        JSR     PROGIO
        JMP     CQCOUT               ;Write program.

LOAD:
        JSR     VARTIO
        JSR     CQCSIN               ;READ SIZE of program into POKER
        CLC
        LDA     TXTTAB               ;Calculate VARTAB from SIZE and
        ADC     POKER                ;TXTTAB
        STA     VARTAB
        LDA     TXTTAB + 1
        ADC     POKER + 1
        STA     VARTAB + 1
        JSR     PROGIO
        JSR     CQCSIN               ;READ program.
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
        JEQ     RUNC                 ;IF no line # argument.
        JSR     CLEARC               ;Clean up -- reset the stack.
        JMP     RUNC2                ;Must replace rts addr.

; A GOSUB entry on the stack has the following format:

; Low address:
;	The GOSUTK one byte
;	The line number of the GOSUB statement two bytes
;	A pointer into the text of the GOSUB two bytes

; High address.

; Total five bytes.

GOSUB:
        LDA     #3
        JSR     GETSTK               ;Make sure there is room.
        PSHWD   TXTPTR               ;Push on the text pointer.
        PSHWD   CURLIN               ;Push on the current line number.
        LDA     #GOSUTK
        PHA                          ;Push on a GOSUB token.
RUNC2:
        JSR     CHRGOT               ;GET character and set codes FOR LINGET.
        JSR     GOTO                 ;Use rts scheme to "NEWSTT"*
        JMP     NEWSTT

GOTO:
        JSR     LINGET               ;Pick up the line number in "LINNUM"*
        JSR     REMN                 ;Skip to END of line.
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
        BCC     USERR                ;GOTO line is nonexistant.
        LDA     LOWTR
        SBC     #1
        STA     TXTPTR
        LDA     LOWTR + 1
        SBC     #0
        STA     TXTPTR + 1
GORTS:
        RTS                          ;Process the statement.

; "RETURN" restores the line number and text pntr from the stack
; And eliminates all the "FOR" entries in front of the "GOSUB" entry.

RETURN:
        BNE     GORTS                ;No terminator=blow him up.
        LDA     #255
        STA     FORPNT + 1           ;Make sure the variable's pntr
                                     ;Never gets matched.
        JSR     FNDFOR               ;Go past all the "FOR" entries.
        TXS
        CMP     #GOSUTK              ;RETURN without GOSUB?
        BEQ     RETU1
        LDX     #ERRRG
        SKIP2
USERR:
        LDX     #ERRUS               ;No match so "us" ERROR.
        JMP     ERROR                ;Yes.
SNERR2:
        JMP     SNERR
RETU1:
        PLA                          ;Remove GOSUTK.
        PULWD   CURLIN               ;GET line number "GOSUB" was from.
        PULWD   TXTPTR               ;GET text pntr from "GOSUB"*
DATA:
        JSR     DATAN                ;Skip to END of statement
                                     ;Since when "GOSUB" stuck the text  pntr
                                     ;Onto the stack, the line number arg
                                     ;Hadn't been READ yet.
ADDON:
        TYA
        CLC
        ADC     TXTPTR
        STA     TXTPTR
        BCC     REMRTS
        INC     TXTPTR + 1
REMRTS:
        RTS                          ;"NEWSTT" rts addr is still there.

DATAN:
        LDX     #":"                 ;"DATA" terminates on ":" and null.
        SKIP2
REMN:
        LDX     #0                   ;The only terminator is null.
        STX     CHARAC               ;Preserve it.
        LDY     #0                   ;This makes CHARAC=0 after swap.
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
        INY                          ;Progress to NEXT character.
        CMP     #34                  ;Is it a quote?
        BNE     REMER                ;No, just continue.
        BEQA    EXCHQT               ;Yes, TIME to trade.
        .page
        .subttl "IF ... THEN" CODE.
IF:
        JSR     FRMEVL               ;Evaluate a formula.
        JSR     CHRGOT               ;GET current character.
        CMP     #GOTOTK              ;Is terminating character a GOTOTK?
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
        BCS     DOCO                 ;IF a number, GOTO it.
        JMP     GOTO
DOCO:
        JMP     GONE3                ;Interpret new statement.
        .page
        .subttl "ON ... GO TO ..." CODE.
ONGOTO:
        JSR     GETBYT               ;GET value in FACLO.
        PHA                          ;SAVE FOR later.
        CMP     #GOSUTK              ;An "on ... GOSUB" perhaps?
        BEQ     ONGLOP               ;Yes.
SNERR3:
        CMP     #GOTOTK              ;Must be "GOTOTK"*
        BNE     SNERR2
ONGLOP:
        DEC     FACLO
        BNE     ONGLP1               ;Skip another line number.
        PLA                          ;GET dispatch character.
        JMP     GONE2
ONGLP1:
        JSR     CHRGET               ;Advance and set codes.
        JSR     LINGET
        CMP     #44                  ;Is it a comma?
        BEQ     ONGLOP
        PLA                          ;Remove stack entry (token)*
ONGRTS:
        RTS                          ;Either END-of-line or syntax ERROR.
        .page
        .subttl LINGET -- READ A LINE NUMBER INTO LINNUM

; "LINGET" reads a line number from the current text position.

; Line numbers range from 0 to 64000-1.

; The answer is returned in "LINNUM"*
; "TXTPTR" is updated to point to the terminating charcter
; And [a] = the terminating character with condition
; Codes set up to reflect its value.

LINGET:
        LDX     #0
        STX     LINNUM               ;Initialize line number to ZERO.
        STX     LINNUM + 1
MORLIN:
        BCS     ONGRTS               ;It is not a digit.
        SBC     #"0" - 1             ;-1 Since c=0.
        STA     CHARAC               ;SAVE character.
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
        JSR     PTRGET               ;GET pntr to variable into "VARPNT"*
        STWD    FORPNT               ;Preserve pointer.
        SYNCHK  EQULTK               ;"=" Is necessary.
        .IF     INTPRC != 0
        LDA     INTFLG               ;SAVE FOR later.
        PHA
        .endif
        LDA     VALTYP               ;Retain the variable's value type.
        PHA
        JSR     FRMEVL               ;GET value of formula into "FAC"*
        PLA
        ROL     A                    ;Carry set FOR string, off FOR
                                     ;Numeric.
        JSR     CHKVAL               ;Make sure "VALTYP" matches carry.
                                     ;And set ZERO flag FOR numeric.
        BNE     COPSTR               ;IF numeric, COPY it.
COPNUM:
        .IF     INTPRC != 0
        PLA                          ;GET number type.
QINTGR:
        BPL     COPFLT               ;Store a flting number.
        JSR     ROUND                ;ROUND integer.
        JSR     AYINT                ;Make 2-byte number.
        LDY     #0
        LDA     FACMO                ;GET high.
        STA     (FORPNT),Y           ;Store it.
        INY
        LDA     FACLO                ;GET low.
        STA     (FORPNT),Y
        RTS
        .endif
COPFLT:
        JMP     MOVVF                ;Put number @FORPNT.

COPSTR:
        .IF     INTPRC != 0
        PLA
        .endif
                                     ;IF string, no INTFLG.
INPCOM:
        .IF     TIME != 0
        LDY     FORPNT + 1           ;Ti$?
        CPY     #ZERO / 256          ;Only ti$ can be this on assig.
        BNE     GETSPT               ; Was not ti$*
        JSR     FREFAC               ;We wont needit.
        CMP     #6                   ;Length correct?
        BNE     FCERR2
        LDY     #0                   ;Yes. do setup.
        STY     FACEXP               ;ZERO FAC to START with.
        STY     FACSGN
TIMELP:
        STY     FBUFPT               ;SAVE posotion.
        JSR     TIMNUM               ;GET a digit.
        JSR     MUL10                ;Whole qty by 10.
        INC     FBUFPT
        LDY     FBUFPT
        JSR     TIMNUM
        JSR     MOVAF
        TAX                          ;IF num=0 then no mult.
        BEQ     NOML6                ;IF =0, go tit.
        INX                          ;Mult by two.
        TXA
        JSR     FINML6               ;Add in and mult by 2 gives *6.
NOML6:
        LDY     FBUFPT
        INY
        CPY     #6                   ;Done all six?
        BNE     TIMELP
        JSR     MUL10                ;One last TIME.
        JSR     QINT                 ;Shift it over to the RIGHT.
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
        LDA     (INDEX),Y            ;INDEX set up by FREFAC.
        JSR     QNUM
        BCC     GOTNUM
FCERR2:
        JMP     FCERR                ;Must be numeric string.
GOTNUM:
        SBC     #"0" - 1             ;C is off.
        JMP     FINLOG
        .endif
                                     ;Add in digit to FAC.

GETSPT:
        LDY     #2                   ;GET pntr to descriptor.
        LDA     (FACMO),Y
        CMP     FRETOP + 1           ;See IF it points into string space.
        BCC     DNTCPY               ;IF [FRETOP],gt.[2&3,FACMO], don't COPY.
        BNE     QVARIA               ;It is less.
        DEY
        LDA     (FACMO),Y
        CMP     FRETOP               ;Compare low orders.
        BCC     DNTCPY
QVARIA:
        LDY     FACLO
        CPY     VARTAB + 1           ;IF [VARTAB].gt.[FACMO], don't COPY.
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
        JSR     STRINI               ;GET room to COPY string into.
        LDWD    DSCPNT               ;GET pointer to old descriptor, so
        STWD    STRNG1               ;MOVINS can find string.
        JSR     MOVINS               ;COPY it.
        LDWDI   DSCTMP               ;GET pointer to old descriptor.
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
        .IF     EXTIO != 0
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
        PLP                          ;GET status back.
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
        .IF     REALIO != 3
        LDY     #0                   ;GET the pointer.
        LDA     (FACMO),Y
        CLC
        ADC     TRMPOS               ;Make sure LEN+POS.lt.width.
        CMP     LINWID               ;Greater than line length?
                                     ;Remember space printed after number.
        BCC     LINCHK               ;Go type.
        JSR     CRDO
        .endif
                                     ;Yes, type crlf first.
LINCHK:
        JSR     STRPRT               ;PRINT the number.
        JSR     OUTSPC               ;PRINT a space
        BNEA    NEWCHR               ;Always goes.
        .IF     REALIO != 4
        .IF     BUFPAG != 0
FININL:
        LDA     #0
        STA     BUF,X
        LDXYI   BUF - 1
        .endif
        .IF     BUFPAG == 0
FININL:
        LDY     #0                   ;Put a ZERO at END of BUF.
        STY     BUF,X
        LDX     #BUF - 1
        .endif
                                     ;Setup pointer.
        .IF     EXTIO != 0
        LDA     CHANNL               ;No CRDO IF not terminal.
        BNE     PRTRTS
        .endif
        .endif
CRDO:
        .IF     EXTIO == 0
        LDA     #13                  ;Make TRMPOS less than line length.
        STA     TRMPOS
        .endif
        .IF     EXTIO != 0
        .IF     REALIO != 3
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
        .IF     EXTIO != 0
        .IF     REALIO != 3
        LDA     CHANNL
        BNE     PRTRTS
        .endif
        .endif
        .IF     NULCMD == 0
        .IF     REALIO != 3
        LDA     #0
        STA     TRMPOS
        .endif
        EOR     #255
        .endif
        .IF     NULCMD != 0
        TXA                          ;Preserve [accx]* some need it.
        PHA
        LDX     NULCNT               ;GET number of nulls.
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
NCMPOS  =       (LINLEN / CLMWID - 1) * CLMWID ;CLMWID beyond which there are
        .IF     REALIO != 3
                                     ;No more comma fields.
        CMP     NCMWID               ;So all comma does is "CRDO"*

        BCC     MORCOM
        JSR     CRDO                 ;Type crlf.
        JMP     NOTABR
        .endif
                                     ;And quit IF beyond last field.
MORCOM:
        SEC
MORCO1:
        SBC     #CLMWID              ;GET [a] modulus CLMWID.
        BCS     MORCO1
        EOR     #255                 ;Fill PRINT POS out to even CLMWID so
        ADC     #1
        BNE     ASPAC                ;PRINT [a] spaces.

TABER:
        PHP                          ;Remember IF spc or tab function.
        JSR     GTBYTC               ;GET value into accx.
        CMP     #41
        BNE     SNERR4
        PLP
        BCC     XSPAC                ;PRINT [x] spaces.
        TXA
        SBC     TRMPOS
        BCC     NOTABR               ;Negative, don't PRINT any.
ASPAC:
        TAX
XSPAC:
        INX
XSPAC2:
        DEX                          ;Decrement the COUNT.
        BNE     XSPAC1
NOTABR:
        JSR     CHRGET               ;Reget last character.
        JMP     PRINTC               ;Don't call CRDO.
XSPAC1:
        JSR     OUTSPC
        BNEA    XSPAC2

; PRINT the string pointed to by [y,a] which ends with a ZERO.
; IF the string is below DSCTMP it will be copied into string space.

STROUT:
        JSR     STRLIT               ;GET a string literal.

; PRINT the string whose descriptor is pointed to by FACMO.

STRPRT:
        JSR     FREFAC               ;RETURN temp pointer.
        TAX                          ;Put COUNT into counter.
        LDY     #0
        INX                          ;Move one ahead.
STRPR2:
        DEX
        BEQ     PRTRTS               ;All done.
        LDA     (INDEX),Y            ;Pntr to act STRNG set by FREFAC.
        JSR     OUTDO
        INY
        CMP     #13
        BNE     STRPR2
        JSR     CRFIN                ;Type rest of carriage RETURN.
        JMP     STRPR2               ;And on and on.

; OUTDO outputs the character in acca, using CNTWFL
; (Suppress or not), TRMPOS (PRINT head position)
; Timing, etcq. no registers are changed.

OUTSPC:
        .IF     REALIO != 3
        LDA     #" "
        .endif
        .IF     REALIO == 3
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
        .IF     REALIO != 0
        BIT     CNTWFL               ;Shouldn't affect channel i/o!
        BMI     OUTRTS
        .endif
        .IF     REALIO != 3
        PHA
        CMP     #32                  ;Is this a printing char?
        BCC     TRYOUT               ;No, don't include it in TRMPOS.
        LDA     TRMPOS
        CMP     LINWID               ;Length = terminal width?
        BNE     OUTDO1
        JSR     CRDO                 ;Yes, type crlf
OUTDO1:
        .IF     EXTIO != 0
        LDA     CHANNL
        BNE     TRYOUT
        .endif
INCTRM:
        INC     TRMPOS               ;Increment COUNT.
TRYOUT:
        PLA
        .endif
                                     ;Restore the a register

        .IF     REALIO == 1
        STY     KIMY
        .endif
                                     ;Preserve y.
        .IF     REALIO == 4
        ORA     #0o200
        .endif
                                     ;Turn on b7 FOR apple.
        .IF     REALIO != 0
OUTLOC:
        JSR     OUTCH
        .endif
                                     ;Output the character.
        .IF     REALIO == 1
        LDY     KIMY
        .endif
                                     ;GET y back.
        .IF     REALIO == 2
        .repeat 4
        NOP
        .endrepeat
        .endif
        .IF     REALIO == 4
        AND     #0o177
        .endif
                                     ;GET [a] back from apple.

        .IF     REALIO == 0
	TJSR	OUTSIM##
        .endif
                                     ;Call simulator output routine
OUTRTS:
        AND     #255                 ;Set z=0.
GETRTS:
        RTS

        .page
        .subttl INPUT AND READ CODE.

; Here when the DATA that was typed in or in "DATA" statements
; Is improperly formatted. FOR "INPUT" we START again.
; FOR "READ" we give a syntax ERROR at the DATA line.

TRMNOK:
        LDA     INPFLG
        BEQ     TRMNO1               ;IF INPUT try again.
        .IF     GETCMD != 0
        BMI     GETDTL
        LDY     #255                 ;Make it look direct.
        BNEA    STCURL               ;Always goes.
GETDTL:
        .endif
        LDWD    DATLIN               ;GET DATA line number.
STCURL:
        STWD    CURLIN               ;Make it current line.
SNERR4:
        JMP     SNERR
TRMNO1:
        .IF     EXTIO != 0
        LDA     CHANNL               ;IF not terminal, give bad DATA.
        BEQ     DOAGIN
        LDX     #ERRBD
        JMP     ERROR
        .endif
DOAGIN:
        LDWDI   TRYAGN
        JSR     STROUT               ;PRINT "?redo from START"*
        LDWD    OLDTXT               ;Point at START
        STWD    TXTPTR               ;Of this current line.
        RTS                          ;Go to "NEWSTT"*
        .IF     GETCMD != 0
GET:
        JSR     ERRDIR               ;Direct is not ok.
        .IF     EXTIO != 0
        CMP     #"#"                 ;See IF "GET#"*
        BNE     GETTTY               ;No, just GET tty INPUT.
        JSR     CHRGET               ;Move up to NEXT byte.
        JSR     GETBYT               ;GET channel into x
        SYNCHK  44                   ;Comma?
        JSR     CQOIN                ;GET channel open FOR INPUT.
        STX     CHANNL
        .endif
GETTTY:
        LDXYI   BUF + 1              ;Point to 0.
        .IF     BUFPAG != 0
        LDA     #0                   ;To stuff and to point.
        STA     BUF + 1
        .endif
        .IF     BUFPAG == 0
        STY     BUF + 1
        .endif
                                     ;ZERO it.
        LDA     #64                  ;Turn on v-bit.
        JSR     INPCO1               ;Do the GET.
        .IF     EXTIO != 0
        LDX     CHANNL
        BNE     IORELE
        .endif
                                     ;Release.
        RTS
        .endif

        .IF     EXTIO != 0
INPUTN:
        JSR     GETBYT               ;GET channel number.
        SYNCHK  44                   ;A comma?
        JSR     CQOIN                ;Go where commodore checks in open.
        STX     CHANNL
        JSR     NOTQTI               ;Do INPUT to variables.
IODONE:
        LDA     CHANNL               ;Release channel.
IORELE:
        JSR     CQCCHN
        LDX     #0                   ;Reset channel to terminal.
        STX     CHANNL
        RTS
        .endif
INPUT:
        .IF     REALIO != 0
        LSR     CNTWFL
        .endif
                                     ;Be talkative.
        CMP     #34                  ;A quote?
        BNE     NOTQTI               ;No message.
        JSR     STRTXT               ;Literalize the string in text
        SYNCHK  59                   ;Must END with semicolon.
        JSR     STRPRT               ;PRINT it out.
NOTQTI:
        JSR     ERRDIR               ;Use common routine since DEF direct
        LDA     #44                  ;GET comma.
        STA     BUF - 1
                                     ;Is also illegal.
GETAGN:
        JSR     QINLIN               ;Type "?" and INPUT a line of text.
        .IF     EXTIO != 0
        LDA     CHANNL
        BEQ     BUFFUL
        LDA     CQSTAT               ;GET status byte.
        AND     #2
        BEQ     BUFFUL               ;A-ok.
        JSR     IODONE               ;Bad. close channel.
        JMP     DATA                 ;Skip rest of INPUT.
BUFFUL:
        .endif
        LDA     BUF                  ;Anything INPUT?
        BNE     INPCON               ;Yes, continue.
        .IF     EXTIO != 0
        LDA     CHANNL               ;Blank line means GET another.
        BNE     GETAGN
        .endif
                                     ;IF not terminal.
        CLC                          ;Make sure dont PRINT break
        JMP     STPEND               ;No, STOP.
QINLIN:
        .IF     EXTIO != 0
        LDA     CHANNL
        BNE     GINLIN
        .endif
        JSR     OUTQST
        JSR     OUTSPC
GINLIN:
        JMP     INLIN
READ:
        LDXY    DATPTR               ;GET last DATA location.
        .byte   0o251                ;Lda #tya to make it nonzero.
        .IF     BUFPAG == 0
INPCON:
        .endif
        TYA
        .IF     BUFPAG != 0
        SKIP2
INPCON:
        LDA     #0
        .endif
                                     ;Set flag that this is INPUT
INPCO1:
        STA     INPFLG               ;Store the flag.

; In the processing of DATA and READ statements:
; One pointer points to the DATA (ie, the numbers being fetched)
; And another points to the LIST of variables.

; The pointer into the DATA always starts pointing to a
; Terminator -- a , : or END-of-line.

; At this point TXTPTR points to LIST of variables and
; [Y,x] points to DATA or INPUT line.

        STXY    INPPTR
INLOOP:
        JSR     PTRGET               ;READ variable LIST.
        STWD    FORPNT               ;SAVE pointer FOR "LET" string stuffing.
                                     ;Returns pntr top var in VARPNT.
        LDWD    TXTPTR               ;SAVE text pntr.
        STWD    VARTXT
        LDXY    INPPTR
        STXY    TXTPTR
        JSR     CHRGOT               ;GET it and set z IF term.
        BNE     DATBK1
        BIT     INPFLG
        .IF     GETCMD != 0
        BVC     QDATA
        JSR     CZGETL               ;Don't want INCHR. just one.
        .IF     REALIO == 4
        AND     #127
        .endif
        STA     BUF                  ;Make it first character.
        LDXYI   (BUF - 1)            ;Point just before it.
        .IF     BUFPAG == 0
        BEQA    DATBK
        .endif
        .IF     BUFPAG != 0
        BNEA    DATBK
        .endif
        .endif
                                     ;Go process.
QDATA:
        BMI     DATLOP               ;Search FOR another DATA statement.
        .IF     EXTIO != 0
        LDA     CHANNL
        BNE     GETNTH
        .endif
        JSR     OUTQST
GETNTH:
        JSR     QINLIN               ;GET another line.
DATBK:
        STXY    TXTPTR               ;Set FOR "CHRGET"*
DATBK1:
        JSR     CHRGET
        BIT     VALTYP               ;GET value type.
        BPL     NUMINS               ;INPUT a number IF numeric.
        .IF     GETCMD != 0
        BIT     INPFLG               ;GET?
        BVC     SETQUT               ;No, go set quote.
        INX
        STX     TXTPTR
        LDA     #0                   ;ZERO terminators.
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
        JSR     STRLT2               ;Make a string descriptor FOR the value
                                     ;And COPY IF necessary.
        JSR     ST2TXT               ;Set text pointer.
        JSR     INPCOM               ;Do assignment.
        JMP     STRDN2
NUMINS:
        JSR     FIN
        .IF     INTPRC == 0
        JSR     MOVVF
        .endif
        .IF     INTPRC != 0
        LDA     INTFLG               ;Set codes on flag.
        JSR     QINTGR
        .endif
                                     ;Go decide on FLOAT.
STRDN2:
        JSR     CHRGOT               ;READ last character.
        BEQ     TRMOK                ;":" Or eol is ok.
        CMP     #44                  ;A comma?
        JNE     TRMNOK
TRMOK:
        LDWD    TXTPTR
        STWD    INPPTR               ;SAVE FOR more reads.
        LDWD    VARTXT
        STWD    TXTPTR               ;Point to variable LIST.
        JSR     CHRGOT               ;Look at last variable LIST character.
        BEQ     VAREND               ;That's the END of the LIST.
        JSR     CHKCOM               ;Not END. check FOR comma.
        JMP     INLOOP

; Subroutine to find DATA
; The search is made by using the execution code FOR DATA to
; Skip over statements. the START word of each statement
; Is compared with "DATATK"* each new line number
; Is stored in "DATLIN" so that IF an ERROR occurs
; While reading DATA the ERROR message can give the line
; Number of the ill-formatted DATA.

DATLOP:
        JSR     DATAN                ;Skip some text.
        INY
        TAX                          ;END of line?
        BNE     NOWLIN               ;Sho ain't.
        LDX     #ERROD               ;Yes = "no DATA" ERROR.
        INY
        LDA     (TXTPTR),Y
        BEQ     ERRGO5
        INY
        LDA     (TXTPTR),Y           ;GET high byte of line number.
        STA     DATLIN
        INY
        LDA     (TXTPTR),Y           ;GET low byte.
        INY
        STA     DATLIN + 1
NOWLIN:
        LDA     (TXTPTR),Y           ;How is it?
        TAX
        JSR     ADDON                ;Add [y] to [TXTPTR]*
        CPX     #DATATK              ;Is it a "DATA" statement.
        BNE     DATLOP               ;Not quite RIGHT. keep looking.
        JMP     DATBK1               ;This is the one !
VAREND:
        LDWD    INPPTR               ;Put away a new DATA pntr maybe.
        LDX     INPFLG
        BPL     VARY0
        JMP     RESFIN
VARY0:
        LDY     #0
        LDA     (INPPTR),Y           ;Last DATA CHR could have been
                                     ;Comma or colon but should be null.
        BEQ     INPRTS               ;It is null.
        .IF     EXTIO != 0
        LDA     CHANNL               ;IF not terminal, no type.
        BNE     INPRTS
        .endif
        LDWDI   EXIGNT
        JMP     STROUT               ;Type "?extra ignored"
INPRTS:
        RTS                          ;Do NEXT statement.
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

; A "FOR" entry on the stack has the following format:

; Low address
;	Token (FORTK) 1 byte
;	A pointer to the loop variable 2 bytes
;	The step 4+ADDPRC bytes
;	A byte reflecting the SIGN of the increment 1 byte
;	The upper value (packed) 4+ADDPRC bytes
;	The line number of the "FOR" statement 2 bytes
;	A text pointer into the "FOR" statement 2 bytes
; High address

; Total 16+2*ADDPRC bytes.

NEXT:
        BNE     GETFOR
        LDY     #0                   ;Without arg call "FNDFOR" with
        BEQA    STXFOR               ;[FORPNT]=0.
GETFOR:
        JSR     PTRGET               ;GET a pointer to loop variable
STXFOR:
        STWD    FORPNT               ;Into "FORPNT"*
        JSR     FNDFOR               ;Find the matching entry IF any.
        BEQ     HAVFOR
        LDX     #ERRNF               ;"NEXT without FOR"*
ERRGO5:
        BEQ     ERRGO4
HAVFOR:
        TXS                          ;Setup stack. chop first.
        TXA
        CLC
        ADC     #4                   ;Point to increment
        PHA                          ;SAVE this pointer to restore to [a]
        ADC     #5 + ADDPRC          ;Point to upper limit
        STA     INDEX2               ;SAVE as INDEX
        PLA                          ;Restore pointer to increment
        LDY     #1                   ;Set hi addr of thing to move.
        JSR     MOVFM                ;GET quantity into the FAC.
        TSX
        LDA     257 + 7 + ADDPRC,X   ;Set SIGN correctly.
        STA     FACSGN
        LDWD    FORPNT
        JSR     FADD                 ;Add inc to loop variable.
        JSR     MOVVF                ;Pack the FAC into MEMORY.
        LDY     #1
        JSR     FCOMPN               ;Compare FAC with upper value.
        TSX
        SEC
        SBC     257 + 7 + ADDPRC,X   ;Subtract SIGN of inc from SIGN of
                                     ;Of (current value-final value)*
        BEQ     LOOPDN               ;IF SIGN (final-current)-SIGN step=0
                                     ;Then loop is done.
        LDA     2 * ADDPRC + 12 + 257,X
        STA     CURLIN               ;Store line number of "FOR" statement.
        LDA     257 + 13 + 2 * ADDPRC,X
        STA     CURLIN + 1
        LDA     2 * ADDPRC + 15 + 257,X
        STA     TXTPTR               ;Store text pntr into "FOR" statement.
        LDA     2 * ADDPRC + 14 + 257,X
        STA     TXTPTR + 1
NEWSGO:
        JMP     NEWSTT               ;Process NEXT statement.
LOOPDN:
        TXA
        ADC     #2 * ADDPRC + 15     ;Adds 16 with carry.
        TAX
        TXS                          ;New stack pntr.
        JSR     CHRGOT
        CMP     #44                  ;Comma at END?
        BNE     NEWSGO
        JSR     CHRGET
        JSR     GETFOR               ;Do NEXT but don't allow blank variable
                                     ;Pntr. [VARPNT] is the stk pntr which
                                     ;Never matches any pointer.
                                     ;Jsr to put on dummy NEWSTT addr.
        .subttl FORMULA EVALUATION CODE.

; These routines check FOR certain "VALTYP"*
; [C] is not preserved.

FRMNUM:
        JSR     FRMEVL
CHKNUM:
        CLC
        SKIP1
CHKSTR:
        SEC                          ;Set carry.
CHKVAL:
        BIT     VALTYP               ;Will not f up "VALTYP"*
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
; [TXTPTR] pointing to the first character of the formula.
; At the END [TXTPTR] points to the terminator.
; The result is LEFT in the FAC.
; On RETURN [a] does not reflect the terminator.

; The formula evaluator uses the operator LIST (OPTAB)
; To determine precedence and dispatch addresses FOR
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
        PHA                          ;SAVE low precedence. (mask.)
        TXA
        PHA                          ;SAVE high precedence.
        LDA     #1
        JSR     GETSTK               ;Make sure there is room FOR
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
        CMP     #1                   ;Reset carry FOR ZERO only.
        ROL     A                    ;0 To 1, 1 to 2, 2 to 4.
        EOR     #1
        EOR     OPMASK               ;Bring in the old BITS.
        CMP     OPMASK               ;Make sure the new mask is bigger.
        BCC     SNERR5               ;Syntax ERROR. because two of the same.
        STA     OPMASK               ;SAVE mask.
        JSR     CHRGET
        JMP     LOPREL               ;GET the NEXT candidate.
ENDREL:
        LDX     OPMASK               ;Were there any?
        BNE     FINREL               ;Yes, handle as special op.
        BCS     QOP                  ;Not an operator.
        ADC     #GREATK - PLUSTK
        BCC     QOP                  ;Not an operator.
        ADC     VALTYP               ;[C]=1.
        JEQ     CAT                  ;Only IF [a]=0 and [VALTYP]=-1 (a STR)*
        ADC     #0o377               ;GET back original [a]*
        STA     INDEX1
        ASL     A                    ;Multiply by 2.
        ADC     INDEX1               ;By three.
        TAY                          ;Set up FOR later.
QPREC:
        PLA                          ;GET previous precedence.
        CMP     OPTAB,Y              ;Is old precedence greater or equal?
        BCS     QCHNUM               ;Yes, go operate.
        JSR     CHKNUM               ;Can't be string here.
DOPREC:
        PHA                          ;SAVE old precedence.
NEGPRC:
        JSR     DOPRE1               ;Set a RETURN address FOR op.
        PLA                          ;Pull off previous precedence.
        LDY     OPPTR                ;GET pointer to op.
        BPL     QPREC1               ;That's a real operator.
        TAX                          ;Done ?
        BEQ     QOPGO                ;Done !
        BNE     PULSTK
FINREL:
        LSR     VALTYP               ;GET value type into "c"*
        TXA
        ROL     A                    ;Put VALTYP into low order bit of mask.
        LDX     TXTPTR               ;Decrement text pointer.
        BNE     FINRE2
        DEC     TXTPTR + 1
FINRE2:
        DEC     TXTPTR
        LDY     #PTDORL - OPTAB      ;Make [yreg] point at operator entry.
        STA     OPMASK               ;SAVE the operation mask.
        BNE     QPREC                ;SAVE it all. br always.
                                     ;Note b7(VALTYP)=0 so CHKNUM call is ok.
QPREC1:
        CMP     OPTAB,Y              ;Last precedence is greater?
        BCS     PULSTK               ;Yes, go operate.
        BCC     DOPREC               ;No SAVE argument and GET other operand.
DOPRE1:
        LDA     OPTAB + 2,Y
        PHA                          ;Disp addr goes onto stack.
        LDA     OPTAB + 1,Y
        PHA
        JSR     PUSHF1               ;SAVE FAC on stack unpacked.
        LDA     OPMASK               ;[Acca] may be mask FOR rel.
        JMP     LPOPER
SNERR5:
        JMP     SNERR                ;Go to an ERROR.
PUSHF1:
        LDA     FACSGN
        LDX     OPTAB,Y              ;GET high precedence.
PUSHF:
        TAY                          ;GET pointer into stack.
        PLA
        STA     INDEX1
        INC     INDEX1
        PLA
        STA     INDEX1 + 1
        TYA
                                     ;Store FAC on stack unpacked.
        PHA                          ;START with SIGN set up.
FORPSH:
        JSR     ROUND                ;Put rounded FAC on stack.
        LDA     FACLO                ;Entry point to skip storing SIGN.
        PHA
        LDA     FACMO
        PHA
        .IF     ADDPRC != 0
        LDA     FACMOH
        PHA
        .endif
        LDA     FACHO
        PHA
        LDA     FACEXP
        PHA
        JMP     (INDEX1)             ;RETURN.
QOP:
        LDY     #255
        PLA                          ;GET high precedence of last op.
QOPGO:
        BEQ     QOPRTS               ;Done !
QCHNUM:
        CMP     #100                 ;Relational operator?
        BEQ     UNPSTK               ;Yes, don't check operand.
        JSR     CHKNUM               ;Must be number.
UNPSTK:
        STY     OPPTR                ;SAVE operator's pointer FOR NEXT TIME.
PULSTK:
        PLA                          ;GET mask FOR rel op IF it is one.
        LSR     A                    ;Setup [c] FOR DOREL's "CHKVAL"*
        STA     DOMASK               ;SAVE FOR "DOCMP"*
        PLA                          ;Unpack stack into arg.
        STA     ARGEXP
        PLA
        STA     ARGHO
        .IF     ADDPRC != 0
        PLA
        STA     ARGMOH
        .endif
        PLA
        STA     ARGMO
        PLA
        STA     ARGLO
        PLA
        STA     ARGSGN
        EOR     FACSGN               ;GET probable result SIGN.
        STA     ARISGN               ;Arithmetic SIGN. used by
                                     ;Add, sub, mult, div.
QOPRTS:
        LDA     FACEXP               ;GET it and set codes.
UNPRTS:
        RTS                          ;RETURN.

EVAL:
        CLR     VALTYP               ;Assume value will be numeric.
EVAL0:
        JSR     CHRGET               ;GET a character.
        BCS     EVAL2
EVAL1:
        JMP     FIN                  ;It is a number.
EVAL2:
        JSR     ISLETC               ;Variable name?
        BCS     ISVAR                ;Yes.
        .IF     REALIO == 3
        CMP     #PI
        BNE     QDOT
        LDWDI   PIVAL
        JSR     MOVFM                ;Put value in FOR pi.
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
        CMP     #NOTTK               ;Check FOR "not" operator.
        BNE     EVAL4
        LDY     #NOTTAB - OPTAB      ;"Not" has precedence 90.
        BNE     GONPRC               ;Go do its evaluation.
NOTOP:
        JSR     AYINT                ;Integerize.
        LDA     FACLO                ;GET the argument.
        EOR     #255
        TAY
        LDA     FACMO
        EOR     #255
        JMP     GIVAYF               ;FLOAT [y,a] as result in FAC.
                                     ;And RETURN.
EVAL4:
        CMP     #FNTK                ;User-defined function?
        JEQ     FNDOER
        CMP     #ONEFUN              ;A function name?
        BCC     PARCHK               ;Functions are the highest numbered
        JMP     ISFUN                ;Characters so no need to check
                                     ;An upper-bound.
PARCHK:
        JSR     CHKOPN               ;Only possibility LEFT is
        JSR     FRMEVL               ;A formula in parenthesis.
                                     ;Recursively evaluate the formula.
CHKCLS:
        LDA     #41                  ;Check FOR a RIGHT parenthese
        SKIP2
CHKOPN:
        LDA     #40
        SKIP2
CHKCOM:
        LDA     #44

; "Synchk" looks at the current character to make sure it
; Is the specific thing loaded into acca just before the call to
; "Synchk"* IF not, it calls the "syntax ERROR" routine.
; Otherwise it gobbles the NEXT char and returns

; [A]=new char and TXTPTR is advanced by "CHRGET"*

SYNCHR:
        LDY     #0
        CMP     (TXTPTR),Y           ;Characters equal?
        BNE     SNERR
CHRGO5:
        JMP     CHRGET
SNERR:
        LDX     #ERRSN               ;"Syntax ERROR"
        JMP     ERROR
DOMIN:
        LDY     #NEGTAB - OPTAB      ;A precedence below "^"*
GONPRC:
        PLA                          ;GET rid of rts addr.
        PLA
        JMP     NEGPRC               ;Evalute FOR negation.

ISVAR:
        JSR     PTRGET               ;GET a pntr to variable.
ISVRET:
        STWD    FACMO
        .IF     (TIME | EXTIO) != 0
        LDWD    VARNAM
        .endif
                                     ;Check TIME,TIME$,status.
        LDX     VALTYP
        BEQ     GOOO                 ;The string is set up.
        LDX     #0
        STX     FACOV
        .IF     TIME != 0
        BIT     FACLO                ;An array?
        BPL     STRRTS               ;Yes.
        CMP     #"T"                 ;Ti$?
        BNE     STRRTS
        CPY     #"I" + 128
        BNE     STRRTS
        JSR     GETTIM               ;Yes. put TIME in FACMOH-lo.
        STY     TENEXP               ;y=0.
        DEY
        STY     FBUFPT
        LDY     #6                   ;Six	digits to PRINT.
        STY     DECCNT
        LDY     #FDCEND - FOUTBL
        JSR     FOUTIM               ;Convert to ascii.
        JMP     TIMSTR
        .endif
STRRTS:
        RTS
GOOO:
        .IF     INTPRC != 0
        LDX     INTFLG
        BPL     GOOOOO
        LDY     #0
        LDA     (FACMO),Y            ;Fetch high.
        TAX
        INY
        LDA     (FACMO),Y
        TAY                          ;Put low in y.
        TXA                          ;GET high in a.
        JMP     GIVAYF
        .endif
                                     ;FLOAT and RETURN.
GOOOOO:
        .IF     TIME != 0
        BIT     FACLO                ;An array?
        BPL     GOMOVF               ;Yes.
        CMP     #"T"
        BNE     QSTATV
        CPY     #"I"
        BNE     GOMOVF
        JSR     GETTIM
        TYA                          ;FOR FLOATB.
        LDX     #160                 ;Set exponnent.
        JMP     FLOATB
GETTIM:
        LDWDI   (CQTIMR - 2)
        SEI                          ;Turn of INT sys.
        JSR     MOVFM
        CLI                          ;Back on.
        STY     FACHO                ;ZERO highest.
        RTS
        .endif
QSTATV:
        .IF     EXTIO != 0
        CMP     #"S"
        BNE     GOMOVF
        CPY     #"T"
        BNE     GOMOVF
        LDA     CQSTAT
        JMP     FLOAT
GOMOVF:
        .endif
        .IF     (TIME | EXTIO) != 0
        LDWD    FACMO
        .endif
        JMP     MOVFM                ;Move actual value in.
                                     ;And RETURN.

ISFUN:
        ASL     A                    ;Multiply by two.
        PHA
        TAX
        JSR     CHRGET               ;Set up FOR synchk.
        CPX     #2 * LASNUM - 256 + 1 ;Is it past "LASNUM"?
        BCC     OKNORM               ;No, must be NORMAL function.

; Most functions take a single argument.
; The RETURN address of these functions is "CHKNUM"
; Which ascertains that [VALTYP]=0  (numeric)*
; NORMAL functions that RETURN string results
; (E.g., CHR$) must pop off that RETURN addr and
; RETURN directly to "FRMEVL"*

; The so-called "funny" functions can take more than one argument
; The first of which must be string and the second of which
; Must be a number between 0 and 255.
; The closed parenthesis must be checked and RETURN is directly
; To "FRMEVL" with the text pntr pointing beyond the ")"*
; The pointer to the descriptor of the string argument
; Is stored on the stack underneath the value of the
; Integer argument.

        JSR     CHKOPN               ;Check FOR an open parenthese
        JSR     FRMEVL               ;Eat open paren and first arg.
        JSR     CHKCOM               ;Two args so comma must delimit.
        JSR     CHKSTR               ;Make sure first was string.
        PLA                          ;GET function number.
        TAX
        PSHWD   FACMO                ;SAVE pointer at string descriptor
        TXA
        PHA                          ;Resave function number.
                                     ;This must be on stack since recursive.
        JSR     GETBYT               ;[X]=value of formula.
        PLA                          ;GET function number.
        TAY
        TXA
        PHA
        JMP     FINGO                ;Dispatch to function.
OKNORM:
        JSR     PARCHK               ;READ a formula surrounded by parens.
        PLA                          ;GET dispatch function.
        TAY
FINGO:
        LDA     FUNDSP - 2 * ONEFUN + 256,Y ;Modify dispatch address.
        STA     JMPER + 1
        LDA     FUNDSP - 2 * ONEFUN + 257,Y
        STA     JMPER + 2
        JSR     JMPER                ;Dispatch!
                                     ;String functions remove this ret addr.
        JMP     CHKNUM               ;Check it FOR numericness and RETURN.

OROP:
        LDY     #255                 ;Must always complement..
        SKIP2
ANDOP:
        LDY     #0
        STY     COUNT                ;Operator.
        JSR     AYINT                ;[FACMO&lo]=INT value and check SIZE.
        LDA     FACMO                ;Use demorgan's law on high
        EOR     COUNT
        STA     INTEGR
        LDA     FACLO                ;And low.
        EOR     COUNT
        STA     INTEGR + 1
        JSR     MOVFA
        JSR     AYINT                ;[FACMO&lo]=INT of arg.
        LDA     FACLO
        EOR     COUNT
        AND     INTEGR + 1
        EOR     COUNT                ;Finish out demorgan.
        TAY                          ;SAVE high.
        LDA     FACMO
        EOR     COUNT
        AND     INTEGR
        EOR     COUNT
        JMP     GIVAYF               ;FLOAT [a.y] and ret to user.

; TIME to perform a relational operator.
; [DOMASK] contains the BITS as to which relational
; Operator it was. carry bit on=string compare.

DOREL:
        JSR     CHKVAL               ;Check FOR match.
        BCS     STRCMP               ;It is a string.
        LDA     ARGSGN               ;Pack arg FOR FCOMP.
        ORA     #127
        AND     ARGHO
        STA     ARGHO
        LDWDI   ARGEXP
        JSR     FCOMP
        TAX
        JMP     QCOMP
STRCMP:
        CLR     VALTYP               ;Result will be numeric.
        DEC     OPMASK               ;Turn off VALTYP which was string.
        JSR     FREFAC               ;Free the FACLO string.
        STA     DSCTMP               ;SAVE FOR later.
        STXY    DSCTMP + 1
        LDWD    ARGMO                ;GET pointer to other string.
        JSR     FRETMP               ;Frees first desc pointer.
        STXY    ARGMO
        TAX                          ;COPY COUNT into x.
        SEC
        SBC     DSCTMP               ;Which is greater. IF 0, all set up.
        BEQ     STASGN               ;Just put SIGN of difference away.
        LDA     #1
        BCC     STASGN               ;SIGN is positive.
        LDX     DSCTMP               ;Length of FAC is shorter.
        LDA     #0o377               ;GET a minus 1 FOR negatives.
STASGN:
        STA     FACSGN               ;Keep FOR later.
        LDY     #255                 ;Set pointer to first string. (arg.)
        INX                          ;To loop properly.
NXTCMP:
        INY
        DEX                          ;Any characters LEFT to compare?
        BNE     GETCMP               ;Not done yet.
        LDX     FACSGN               ;Use SIGN of length difference
                                     ;Since all characters are the same.
QCOMP:
        BMI     DOCMP                ;C is always set then.
        CLC
        BCC     DOCMP                ;Always branch.
GETCMP:
        LDA     (ARGMO),Y            ;GET NEXT char to compare.
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
        JMP     FLOAT                ;FLOAT the one-byte result into FAC.

        .page
        .subttl DIMENSION AND VARIABLE SEARCHING.

; The "DIM" code sets [DIMFLG] and then falls into the variable search
; Routine, which looks at DIMFLG at three different points.
;	1) IF an entry is found, "DIMFLG" being on indicates
;		A "doubly" dimensioned variable.
;	2) When a new entry is being built "DIMFLG" being on
;		Indictaes the indices should be used FOR the
;		SIZE of each INDEX. otherwise the default of ten
;		Is used.
;	3) When the build entry code finishes, only IF "DIMFLG" is off
;		Will indexing be done.

DIM3:
        JSR     CHKCOM               ;Must be a comma
DIM:
        TAX                          ;Set [accx] nonzero.
                                     ;[Acca] must be nonzero to work RIGHT.
DIM1:
        JSR     PTRGT1
DIMCON:
        JSR     CHRGOT               ;GET last character.
        BNE     DIM3
        RTS

; Routine to READ the variable name at the current text position
; And  put a pointer to its value in VARPNT. [TXTPTR]
; Points to the terminating charcter.. not that evaluating subscripts
; In a variable name can cause recursive calls to "PTRGET" so at
; That point all values must be stored on the stack.

PTRGET:
        LDX     #0                   ;Make [accx]=0.
        JSR     CHRGOT               ;Retrieve last character.
PTRGT1:
        STX     DIMFLG               ;Store flag away.
PTRGT2:
        STA     VARNAM
        JSR     CHRGOT               ;GET current character
                                     ;Maybe with function bit off.
        JSR     ISLETC               ;Check FOR letter.
        BCS     PTRGT3               ;Must have a letter.
INTERR:
        JMP     SNERR
PTRGT3:
        LDX     #0                   ;Assume no second character.
        STX     VALTYP               ;Default is numeric.
        .IF     INTPRC != 0
        STX     INTFLG
        .endif
                                     ;Assume floating.
        JSR     CHRGET               ;GET following character.
        BCC     ISSEC                ;Carry reset by CHRGET IF numeric.
        JSR     ISLETC               ;Set carry IF not alphabetic.
        BCC     NOSEC                ;Allow alphabetics.
ISSEC:
        TAX                          ;It is a number -- SAVE in accx.
EATEM:
        JSR     CHRGET               ;Look at NEXT character.
        BCC     EATEM                ;Skip numerics.
        JSR     ISLETC
        BCS     EATEM                ;Skip alphabetics.
NOSEC:
        CMP     #"$"                 ;Is it a string?
        BNE     NOTSTR               ;IF not, [VALTYP]=0.
        LDA     #0o377               ;Set [VALTYP]=255 (string !)*
        STA     VALTYP
        .IF     INTPRC != 0
        BNEA    TURNON               ;Always goes.
NOTSTR:
        CMP     #"%"                 ;Integer variable?
        BNE     STRNAM               ;No.
        LDA     SUBFLG
        BNE     INTERR
        LDA     #128
        STA     INTFLG               ;Set flag.
        ORA     VARNAM               ;Turn on both high BITS.
        STA     VARNAM
        .endif
TURNON:
        TXA
        ORA     #128                 ;Turn on msb of second character.
        TAX
        JSR     CHRGET               ;GET character after $*
        .IF     INTPRC == 0
NOTSTR:
        .endif
STRNAM:
        STX     VARNAM + 1           ;Store away second character.
        SEC
        ORA     SUBFLG               ;Add flag whether to allow arrays.
        SBC     #40                  ;(Check FOR "(") won't match IF SUBFLG set.
        JEQ     ISARY                ;It is!
        CLR     SUBFLG               ;Allow subscripts again.
        LDA     VARTAB               ;Place to START search.
        LDX     VARTAB + 1
        LDY     #0
STXFND:
        STX     LOWTR + 1
LOPFND:
        STA     LOWTR
        CPX     ARYTAB + 1           ;At END of table yet?
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

; Test FOR a letter.	/ carry off= not a letter.
;			  Carry on= a letter.

ISLETC:
        CMP     #"A"
        BCC     ISLRTS               ;IF less than "a", ret.
        SBC     #"Z" + 1
        SEC
        SBC     #256 - "Z" - 1       ;Reset carry IF [a] .gt. "z"*
ISLRTS:
        RTS                          ;RETURN to caller.

NOTFNS:
        PLA                          ;Check who's calling.
        PHA                          ;Restore it.
        CMP     #ISVRET - 1 - (ISVRET - 1) / 256 * 256 ;Is EVAL calling?
        BNE     NOTEVL               ;No, carry on.
        .IF     REALIO != 3
        TSX
        LDA     258,X
        CMP     #(ISVRET - 1) / 256
        BNE     NOTEVL
        .endif
LDZR:
        LDWDI   ZERO                 ;Set up pntr to simulated ZERO.
        RTS                          ;FOR strings or numeric.
                                     ;And FOR integers too.
NOTEVL:
        .IF     (TIME | EXTIO) != 0
        LDWD    VARNAM
        .endif
        .IF     TIME != 0
        CMP     #"T"
        BNE     QSTAVR
        CPY     #"I" + 128
        BEQ     LDZR
        CPY     #"I"
        BNE     QSTAVR
        .endif
        .IF     (EXTIO | TIME) != 0
GOBADV:
        JMP     SNERR
        .endif
QSTAVR:
        .IF     EXTIO != 0
        CMP     #"S"
        BNE     VAROK
        CPY     #"T"
        BEQ     GOBADV
        .endif
VAROK:
        LDWD    ARYTAB
        STWD    LOWTR                ;Lowest thing to move.
        LDWD    STREND               ;GET highest addr to move.
        STWD    HIGHTR
        CLC
        ADC     #6 + ADDPRC
        BCC     NOTEVE
        INY
NOTEVE:
        STWD    HIGHDS               ;Place to stuff it.
        JSR     BLTU                 ;Move it all.
                                     ;Note [y,a] has [HIGHDS] FOR REASON.
        LDWD    HIGHDS               ;And set up
        INY
        STWD    ARYTAB               ;New START of array table.
        LDY     #0                   ;GET addr of variable entry.
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
        STA     (LOWTR),Y            ;Fourth ZERO FOR DEF func.
        .IF     ADDPRC != 0
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

; INTIDX reads a formula from the current position and
; Turns it into a positive integer
; Leaving the result in FACMO&lo. negative arguments
; Are not allowed.

INTIDX:
        JSR     CHRGET
        JSR     FRMEVL               ;GET a number
POSINT:
        JSR     CHKNUM
        LDA     FACSGN
        BMI     NONONO               ;IF negative, blow him out.
AYINT:
        LDA     FACEXP
        CMP     #144                 ;FAC .gt. 32767?
        BCC     QINTGO
        LDWDI   N32768               ;GET addr of -32768.
        JSR     FCOMP                ;See IF FAC=[[y,a]]*
NONONO:
        BNE     FCERR                ;No, FAC is too big.
QINTGO:
        JMP     QINT                 ;Go to QINT and shove it.

; Format of arrays in core.

; Descriptor:
;	Lowbyte = first character.
;	Highbyte = second character (200 bit is string flag)*
; Length of array in core in bytes (includes everything)*
; Number of dimensions.
; FOR each dimension starting with the first a LIST
; (2 Bytes each) of the max INDICE+1
; The values

ISARY:
        LDA     DIMFLG
        .IF     INTPRC != 0
        ORA     INTFLG
        .endif
        PHA                          ;SAVE [DIMFLG] FOR recursion.
        LDA     VALTYP
        PHA                          ;SAVE [VALTYP] FOR recursion.
        LDY     #0                   ;Set number of dimensions to ZERO.
INDLOP:
        TYA                          ;SAVE number of dims.
        PHA
        PSHWD   VARNAM               ;SAVE looks.
        JSR     INTIDX               ;Evaluate INDICE into FACMO&lo.
        PULWD   VARNAM               ;GET back all... we're home.
        PLA                          ;(# Of dims)*
        TAY
        TSX
        LDA     258,X
        PHA                          ;Push DIMFLG and VALTYP further.
        LDA     257,X
        PHA
        LDA     INDICE               ;Put INDICE onto stack.
        STA     258,X                ;Under DIMFLG and VALTYP.
        LDA     INDICE + 1
        STA     257,X
        INY                          ;Increment # of dims.
        JSR     CHRGOT               ;GET terminating character.
        CMP     #44                  ;A comma?
        BEQ     INDLOP               ;Yes.
        STY     COUNT                ;SAVE COUNT of dims.
        JSR     CHKCLS               ;Must be closed paren.
        PLA
        STA     VALTYP               ;GET VALTYP and
        PLA
        .IF     INTPRC != 0
        STA     INTFLG
        AND     #127
        .endif
        STA     DIMFLG               ;DIMFLG off stack.
        LDX     ARYTAB               ;Place to START search.
        LDA     ARYTAB + 1
LOPFDA:
        STX     LOWTR
        STA     LOWTR + 1
        CMP     STREND + 1           ;END of arrays?
        BNE     LOPFDV
        CPX     STREND
        BEQ     NOTFDD               ;A FINE thing! no array!*
LOPFDV:
        LDY     #0
        LDA     (LOWTR),Y
        INY
        CMP     VARNAM               ;Compare high orders.
        BNE     NMARY1               ;No way is it this. GET out of here.
        LDA     VARNAM + 1
        CMP     (LOWTR),Y            ;Low orders?
        BEQ     GOTARY               ;Well, here it is !!
NMARY1:
        INY
        LDA     (LOWTR),Y            ;GET length.
        CLC
        ADC     LOWTR
        TAX
        INY
        LDA     (LOWTR),Y
        ADC     LOWTR + 1
        BCC     LOPFDA               ;Always branches.
BSERR:
        LDX     #ERRBS               ;GET bad sub ERROR number.
        SKIP2
FCERR:
        LDX     #ERRFC               ;Too big. "function call" ERROR.
ERRGO3:
        JMP     ERROR
GOTARY:
        LDX     #ERRDD               ;Perhaps a "re-dimension" ERROR
        LDA     DIMFLG               ;Test the DIMFLG
        BNE     ERRGO3
        JSR     FMAPTR
        LDA     COUNT                ;GET number of dims INPUT.
        LDY     #4
        CMP     (LOWTR),Y            ;# Of dims the same?
        BNE     BSERR                ;Same so go GET definition.
        JMP     GETDEF

; Here when variable is not found in the array table.

; Building an entry.

;	Put down the descriptor.
;	Setup number of dimensions.
;	Make sure there is room FOR the new entry.
;	Remember "VARPNT"*
;	Tally=4.
;	Skip 2 locs FOR later fill in of SIZE.
; Loop: GET an INDICE
;	Put down number+1 and increment varptr.
;	Tally=tally*number+1.
;	Decrement number-dims.
;	Bne loop
;	Call "REASON" with [y,a] reflecting last loc of variable.
;	Update STREND.
;	ZERO all.
;	Make tally include maxdims and descriptor.
;	Put down tally.
;	IF called by dimension, RETURN.
;	Otherwise INDEX into the variable as IF it
;	 Were found on the initial search.

NOTFDD:
        JSR     FMAPTR               ;Form ARYPNT.
        JSR     REASON
        LDA     #0
        TAY
        STA     CURTOL + 1
        .IF     ADDPRC == 0
        LDX     #4
        .endif
        .IF     ADDPRC != 0
        LDX     #5
        .endif
        LDA     VARNAM               ;This code only works FOR INTPRC=1
        STA     (LOWTR),Y            ;IF ADDPRC=1.
        .IF     ADDPRC != 0
        BPL     NOTFLT
        DEX
        .endif
NOTFLT:
        INY
        LDA     VARNAM + 1
        STA     (LOWTR),Y
        BPL     STOMLT
        DEX
        .IF     ADDPRC != 0
        DEX
        .endif
STOMLT:
        STX     CURTOL
        LDA     COUNT
        .repeat 3
        INY
        .endrepeat
        STA     (LOWTR),Y            ;SAVE number of dimensions.
LOPPTA:
        LDX     #11                  ;Default SIZE.
        LDA     #0
        BIT     DIMFLG
        BVC     NOTDIM               ;Not in a DIM statement.
        PLA                          ;GET low order of INDICE.
        CLC
        ADC     #1
        TAX
        PLA                          ;GET high part of INDICE.
        ADC     #0
NOTDIM:
        INY
        STA     (LOWTR),Y            ;Store high part of INDICE.
        INY
        TXA
        STA     (LOWTR),Y            ;Store low order of INDICE.
        JSR     UMULT                ;[X,a]=[CURTOL]*[LOWTR,y]
        STX     CURTOL               ;SAVE new tally.
        STA     CURTOL + 1
        LDY     INDEX
        DEC     COUNT                ;Any more indices LEFT?
        BNE     LOPPTA               ;Yes.
        ADC     ARYPNT + 1
        BCS     OMERR1               ;Overflow.
        STA     ARYPNT + 1           ;Compute where to ZERO.
        TAY
        TXA
        ADC     ARYPNT
        BCC     GREASE
        INY
        BEQ     OMERR1
GREASE:
        JSR     REASON               ;GET room.
        STWD    STREND               ;New END of storage.
        LDA     #0                   ;Storing [acca] is faster than CLEAR.
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

; At this point [LOWTR,y] points beyond the SIZE to the number of
; Dimensions. strategy:
;	Numdim=number of dimensions.
;	CURTOL=0.
; INLPNM:GET a new INDICE.
;	Make sure INDICE is not too big.
;	Multiply CURTOL by curmax.
;	Add INDICE to CURTOL.
;	Numdim=numdim-1.
;	Bne	INLPNM.
;	Use [CURTOL]*4 as offset.

GETDEF:
        LDA     (LOWTR),Y
        STA     COUNT                ;SAVE a counter.
        LDA     #0                   ;ZERO [CURTOL]*
        STA     CURTOL
INLPNM:
        STA     CURTOL + 1
        INY
        PLA                          ;GET low INDICE.
        TAX
        STA     INDICE
        PLA                          ;And the high part
        STA     INDICE + 1
        CMP     (LOWTR),Y            ;Compare with max INDICE.
        BCC     INLPN2
        BNE     BSERR7               ;IF greater, "bad subscript" ERROR.
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
        LDA     CURTOL + 1           ;Don't multiply IF CURTOL=0.
        ORA     CURTOL
        CLC                          ;Prepare to GET INDICE back.
        BEQ     ADDIND               ;GET high part of INDICE back.
        JSR     UMULT                ;Multiply [CURTOL] by [LOWTR,y,y+1]*
        TXA
        ADC     INDICE               ;Add in [INDICE]*
        TAX
        TYA
        LDY     INDEX1
ADDIND:
        ADC     INDICE + 1
        STX     CURTOL
        DEC     COUNT                ;Any more?
        BNE     INLPNM               ;Yes.
        STA     CURTOL + 1           ;Fix array bug ****
        .IF     ADDPRC == 0
        LDX     #4
        .endif
        .IF     ADDPRC != 0
        LDX     #5                   ;This code only works FOR INTPRC=1
        LDA     VARNAM               ;IF ADDPRC=1.
        BPL     NOTFL1
        DEX
        .endif
NOTFL1:
        LDA     VARNAM + 1
        BPL     STOML1
        DEX
        .IF     ADDPRC != 0
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
        RTS                          ;RETURN to caller.
        .subttl INTEGER ARITHMETIC ROUTINES.
                                     ;Two byte unsigned integer multiply.
                                     ;This is FOR multiply dimensioned arrays.
                                     ; [X,y]=[x,a]=[CURTOL]*[LOWTR,y,y+1]*
UMULT:
        STY     INDEX
        LDA     (LOWTR),Y
        STA     ADDEND               ;Low, then high.
        DEY
        LDA     (LOWTR),Y            ;Put [LOWTR,y,y+1] in faster MEMORY.
UMULTD:
        STA     ADDEND + 1
        LDA     #16
        STA     DECCNT
        LDX     #0                   ;Clr the accs.
        LDY     #0                   ;Result initially ZERO.
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
        SBC     STREND               ;[FRETOP]-[STREND]*
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
        LDY     TRMPOS               ;GET position.
SNGFLT:
        LDA     #0
        BEQA    GIVAYF               ;FLOAT it.
        .page
        .subttl SIMPLE-USER-DEFINED-FUNCTION CODE.

; Note only single arguments are allowed to functions
; And functions must be of the single line form:
;	DEF fna(x)=x^2+x-2
; No strings can be involved with these functions.

; Idea: create a simple variable entry
; Whose first character has the 200 bit set.
; The value will be:

;	A text pntr to the formula.
;	A pntr to the argument variable.

; Function names can be like "fna4"*

; Subroutine to see IF we are in direct mode.
; And complain IF so.

ERRDIR:
        LDX     CURLIN + 1           ;Dir mode has [CURLIN]=0,255
        INX                          ;So now, is result ZERO?
        BNE     DIMRTS               ;Yes.
        LDX     #ERRID               ;INPUT direct ERROR code.
        SKIP2
ERRGUF:
        LDX     #ERRUF               ;User defined function never defined
ERRGO1:
        JMP     ERROR

DEF:
        JSR     GETFNM               ;GET a pntr to the function.
        JSR     ERRDIR
        JSR     CHKOPN               ;Must have "("*
        LDA     #128
        STA     SUBFLG               ;Prohibit subscripted variables.
        JSR     PTRGET               ;GET pntr to argument.
        JSR     CHKNUM               ;Is it a number?
        JSR     CHKCLS               ;Must have ")"
        SYNCHK  EQULTK               ;Must have "="*
        .IF     ADDPRC != 0
        PHA
        .endif
                                     ;Put crazy byte on.
        PSHWD   VARPNT
        PSHWD   TXTPTR
        JSR     DATA
        JMP     DEFFIN

; Subroutine to GET a pntr to a function name.

GETFNM:
        SYNCHK  FNTK                 ;Must START with fn.
        ORA     #128                 ;Put function bit on.
        STA     SUBFLG
        JSR     PTRGT2               ;GET pointer to function or create anew.
        STWD    DEFPNT
        JMP     CHKNUM               ;Make sure it's not a string and RETURN.

FNDOER:
        JSR     GETFNM               ;GET the function's name.
        PSHWD   DEFPNT
        JSR     PARCHK               ;Evaluate parameter.
        JSR     CHKNUM
        PULWD   DEFPNT
        LDY     #2
        LDA     (DEFPNT),Y           ;GET pointer to variable.
        STA     VARPNT               ;SAVE variable pointer.
        TAX
        INY
        LDA     (DEFPNT),Y
        BEQ     ERRGUF
        STA     VARPNT + 1
        .IF     ADDPRC != 0
        INY
        .endif
                                     ;Since DEF uses only 4.
DEFSTF:
        LDA     (VARPNT),Y
        PHA                          ;Push it all on stack.
        DEY                          ;Since we are recursing maybe.
        BPL     DEFSTF
        LDY     VARPNT + 1
        JSR     MOVMF                ;Put current FAC into our arg variable.
        PSHWD   TXTPTR               ;SAVE text pointer.
        LDA     (DEFPNT),Y           ;Pntr to function.
        STA     TXTPTR
        INY
        LDA     (DEFPNT),Y
        STA     TXTPTR + 1
        PSHWD   VARPNT               ;SAVE variable pointer.
        JSR     FRMNUM               ;Evaluate formula and check numeric.
        PULWD   DEFPNT
        JSR     CHRGOT
        JNE     SNERR                ;It didn't terminate. huh?
        PULWD   TXTPTR               ;Restore text pntr.
DEFFIN:
        LDY     #0
        PLA                          ;GET old arg value off stack
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
        .IF     ADDPRC != 0
        PLA
        INY
        STA     (DEFPNT),Y
        .endif
DEFRTS:
        RTS
        .page
        .subttl STRING FUNCTIONS.

; The STR$ function takes a number and gives a string
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

; "STRINI" GET string space FOR the creation of a string and
; Creates a descriptor FOR it in "DSCTMP"*

STRINI:
        LDXY    FACMO                ;GET FACMO to store in DSCPNT.
        STXY    DSCPNT               ;Retain the descriptor pointer.
STRSPA:
        JSR     GETSPA               ;GET string space.
        STXY    DSCTMP + 1           ;SAVE location.
        STA     DSCTMP               ;SAVE length.
        RTS                          ;All done.

; "STRLT2" takes the string literal whose first character
; Is pointed to by [y,a] and builds a descriptor FOR it.
; The descriptor is initially built in "DSCTMP", but "PUTNEW"
; Transfers it into a temporary and leaves a pointer
; At the temporary in FACMO&lo. the characters other than
; ZERO that terminate the string should be set up in "CHARAC"
; And "ENDCHR"* IF the terminator is a quote, the quote is skipped
; Over. leading quotes should be skipped before jsr. on RETURN
; The character after the string literal is pointed to
; By [STRNG2]*

STRLIT:
        LDX     #34                  ;Assume string ends on quote.
        STX     CHARAC
        STX     ENDCHR
STRLT2:
        STWD    STRNG1               ;SAVE pointer to string.
        STWD    DSCTMP + 1           ;In case no strcpy.
        LDY     #255                 ;Initialize character COUNT.
STRGET:
        INY
        LDA     (STRNG1),Y           ;GET character.
        BEQ     STRFI1               ;IF ZERO.
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
        STY     DSCTMP               ;Retain COUNT.
        TYA
        ADC     STRNG1               ;Wishing to set [TXTPTR]*
        STA     STRNG2
        LDX     STRNG1 + 1
        BCC     STRST2
        INX
STRST2:
        STX     STRNG2 + 1
        LDA     STRNG1 + 1           ;IF page 0, COPY since it is either
                                     ;A string constant in BUF or a STR$
                                     ;Result in LOFBUF
        .IF     BUFPAG != 0
        BEQ     STRCP
        CMP     #BUFPAG
        .endif
        BNE     PUTNEW
STRCP:
        TYA
        JSR     STRINI
        LDXY    STRNG1
        JSR     MOVSTR               ;Move string.

; Some string function is returning a result in DSCTMP.
; Setup a temp descriptor with DSCTMP in it.
; Put a pointer to the descriptor in FACMO&lo and flag the
; Result as type string.

PUTNEW:
        LDX     TEMPPT               ;Pointer to first free temp.
        CPX     #TEMPST + STRSIZ * NUMTMP
        BNE     PUTNW1
        LDX     #ERRST               ;String temporary ERROR.
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
        STX     TEMPPT               ;SAVE pointer to NEXT temp IF any.
        RTS                          ;All done.

; GETSPA - GET space FOR character string.
; May force garbage collection.

; # Of characters (bytes) in acca.
; Returns with pointer in [y,x]* otherwise (IF can't GET
; Space) blows off to "out of string space" type ERROR.
; Also preserves [acca] and sets [FRESPC]=[y,x]=pntr at space.

GETSPA:
        LSR     GARBFL               ;Signal no garbage collection yet.
TRYAG2:
        PHA                          ;SAVE FOR later.
        EOR     #255
        SEC                          ;Add one to complete negation.
        ADC     FRETOP
        LDY     FRETOP + 1
        BCS     TRYAG3
        DEY
TRYAG3:
        CPY     STREND + 1           ;Compare high orders.
        BCC     GARBAG               ;Make room FOR more.
        BNE     STRFRE               ;SAVE new FRETOP.
        CMP     STREND               ;Compare low orders.
        BCC     GARBAG               ;Clean up.
STRFRE:
        STWD    FRETOP               ;SAVE new [FRETOP]*
        STWD    FRESPC               ;Put it there old man.
        TAX                          ;Preserve a in x.
        PLA                          ;GET COUNT back in acca.
        RTS                          ;All done.
GARBAG:
        LDX     #ERROM               ;"Out of string space"
        LDA     GARBFL
        BMI     ERRGO2
        JSR     GARBA2
        LDA     #128
        STA     GARBFL
        PLA                          ;GET back string length.
        BNE     TRYAG2               ;Always branches.
GARBA2:
                                     ;START from top down.
        .IF     (REALIO | DISKO) == 0
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
        STY     GRBPNT               ;Both bytes set to ZERO (fix bug)
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
        LDWX    VARTAB               ;GET START of simple variables.
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
        STWX    ARYPNT               ;SAVE FOR addition.
        LDA     #STRSIZ
        STA     FOUR6
ARYVA2:
        LDWX    ARYPNT               ;GET the pointer to variable.
ARYVA3:
        CPX     STREND + 1           ;Done with arrays?
        BNE     ARYVGO               ;No.
        CMP     STREND
        JEQ     GRBPAS               ;Yes, go finish up.
ARYVGO:
        STWX    INDEX1
        LDY     #1 - ADDPRC
        .IF     ADDPRC != 0
        LDA     (INDEX1),Y
        TAX
        INY
        .endif
        LDA     (INDEX1),Y
        PHP
        INY
        LDA     (INDEX1),Y
        ADC     ARYPNT
        STA     ARYPNT               ;Form pointer to NEXT array var.
        INY
        LDA     (INDEX1),Y
        ADC     ARYPNT + 1
        STA     ARYPNT + 1
        PLP
        BPL     ARYVA2
        .IF     ADDPRC != 0
        TXA
        BMI     ARYVA2
        .endif
        INY
        LDA     (INDEX1),Y
        LDY     #0                   ;Reset INDEX y.
        ASL     A
        ADC     #5                   ;Carry is off and off after add.
        ADC     INDEX1
        STA     INDEX1
        BCC     ARYGET
        INC     INDEX1 + 1
ARYGET:
        LDX     INDEX1 + 1
ARYSTR:
        CPX     ARYPNT + 1           ;END of the array?
        BNE     GOGO
        CMP     ARYPNT
        BEQ     ARYVA3               ;Yes.
GOGO:
        JSR     DVAR
        BEQ     ARYSTR               ;Cycle.
DVARS:
        .IF     INTPRC != 0
        LDA     (INDEX1),Y
        BMI     DVARTS
        .endif
        INY
        LDA     (INDEX1),Y
        BPL     DVARTS
        INY
DVAR:
        LDA     (INDEX1),Y           ;Is length=0?
        BEQ     DVARTS               ;Yes, RETURN.
        INY
        LDA     (INDEX1),Y           ;GET low(adr)*
        TAX
        INY
        LDA     (INDEX1),Y
        CMP     FRETOP + 1           ;Compare highs.
        BCC     DVAR2                ;IF this string's pntr .ge. [FRETOP]
        BNE     DVARTS               ;No need to mess with it further.
        CPX     FRETOP               ;Compare lows.
        BCS     DVARTS
DVAR2:
        CMP     GRBTOP + 1
        BCC     DVARTS               ;IF this string is below previous
                                     ;Forget it.
        BNE     DVAR3
        CPX     GRBTOP               ;Compare low orders.
        BCC     DVARTS               ;[X,a] .le. [GRBTOP]*
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
                                     ;Note: GRBTOP=LOWTR so no need to set LOWTR.
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
        LDA     HIGHDS               ;GET position of START of result.
        STA     (GRBPNT),Y
        TAX
        INC     HIGHDS + 1
        LDA     HIGHDS + 1
        INY
        STA     (GRBPNT),Y           ;Change addr of string in var.
        JMP     FNDVAR               ;Go to FNDVAR with something FOR
                                     ;[FRETOP]*

; The following routine concatenates two strings.
; The FAC contains the first one at this point.
; [TXTPTR] points to the + SIGN.

CAT:
        LDA     FACLO                ;Psh high order onto stack.
        PHA
        LDA     FACMO                ;And the low.
        PHA
        JSR     EVAL                 ;Can come back here since
                                     ;Operator is known.
        JSR     CHKSTR               ;Result must be string.
        PLA
        STA     STRNG1               ;GET high order of old desc.
        PLA
        STA     STRNG1 + 1
        LDY     #0
        LDA     (STRNG1),Y           ;GET length of old string.
        CLC
        ADC     (FACMO),Y
        BCC     SIZEOK               ;Result is less than 256.
        LDX     #ERRLS               ;ERROR "long string"*
        JMP     ERROR
SIZEOK:
        JSR     STRINI               ;Initialize string.
        JSR     MOVINS               ;Move it.
        LDWD    DSCPNT               ;GET pointer to second.
        JSR     FRETMP               ;Free it.
        JSR     MOVDO
        LDWD    STRNG1
        JSR     FRETMP
        JSR     PUTNEW
        JMP     TSTOP                ;"CAT" reenters form EVAL at TSTOP.

MOVINS:
        LDY     #0                   ;GET addr of string.
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

; "FRETMP" is passed a string descriptor pntr in [y,a]*
; A check is made to see IF the string descriptor points to the last
; Temporary descriptor allocated by PUTNEW.
; IF so, the temporary is freed up by the updating of [TEMPPT]*
; IF a temp is freed up, a further check sees IF the string DATA that
; That string temp pnt'd to is the lowest part of string space in use.
; IF so, [FRETOP] is updated to reflect the fact the fact that the space
; Is no longer in use.
; The addr of the actual string is returned in [y,x] and
; Its length in acca.

FRESTR:
        JSR     CHKSTR               ;Make sure its a string.
FREFAC:
        LDWD    FACMO                ;Free up STR pnt'd to by FAC.
FRETMP:
        STWD    INDEX                ;GET length FOR later.
        JSR     FRETMS               ;Free up the temporary desc.
        PHP                          ;SAVE codes.
        LDY     #0                   ;Prep to GET stuff.
        LDA     (INDEX),Y            ;GET COUNT and
        PHA                          ;SAVE it.
        INY
        LDA     (INDEX),Y
        TAX                          ;SAVE low order.
        INY
        LDA     (INDEX),Y
        TAY                          ;SAVE high order.
        PLA
        PLP                          ;RETURN status.
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
        PLA                          ;GET COUNT back.
FRETRT:
        STXY    INDEX                ;SAVE FOR later use.
        RTS
FRETMS:
        CPY     LASTPT + 1           ;Last entry to temp?
        BNE     FRERTS
        CMP     LASTPT
        BNE     FRERTS
        STA     TEMPPT
        SBC     #STRSIZ              ;Point to last one.
        STA     LASTPT               ;Update temp pntr.
        LDY     #0                   ;Also clears zflg so we do rest of FRETMP.
FRERTS:
        RTS                          ;All done.

; CHR$(#) creates a string which contains as its only
; Character the ascii equivalent of the integer argument (#)
; Which must be .lt. 255.

CHR:
        JSR     CONINT               ;GET integer in range.
        TXA
        PHA
        LDA     #1                   ;One-character string.
        JSR     STRSPA               ;GET space FOR string.
        PLA
        LDY     #0
        STA     (DSCTMP + 1),Y
        PLA                          ;GET rid of "CHKNUM" RETURN addr.
        PLA
RLZRET:
        JMP     PUTNEW               ;Setup FAC to point to desc.

; The following is the LEFT$($,#) function.
; It takes the leftmost # characters of the string.
; IF # .gt. the LEN of the string, it returns the whole string.

LEFT:
        JSR     PREAM                ;Test parameters.
        CMP     (DSCPNT),Y
        TYA
RLEFT:
        BCC     RLEFT1
        LDA     (DSCPNT),Y
        TAX                          ;Put length into x.
        TYA                          ;ZERO a, the offset.
RLEFT1:
        PHA                          ;SAVE offset.
RLEFT2:
        TXA
RLEFT3:
        PHA                          ;SAVE length.
        JSR     STRSPA               ;GET space.
        LDWD    DSCPNT
        JSR     FRETMP
        PLA
        TAY
        PLA
        CLC
        ADC     INDEX                ;Compute where to COPY.
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

; MID ($,#) returns string with chars from # position
; Onward. IF # .gt. LEN ($) then RETURN null string.
; MID ($,#,#) returns string with characters from
; # Position FOR #2 characters. IF #2 goes past END of string
; RETURN as much as possible.

MID:
        LDA     #255                 ;Default.
        STA     FACLO                ;SAVE FOR later compare.
        JSR     CHRGOT               ;GET current character.
        CMP     #41                  ;Is it a RIGHT paren )?
        BEQ     MID2                 ;No third param.
        JSR     CHKCOM               ;Must have comma.
        JSR     GETBYT               ;GET the length into "FACLO"*
MID2:
        JSR     PREAM                ;Check it out.
        BEQ     GOFUC                ;There is no postion 0
        DEX                          ;Compute offset.
        TXA
        PHA                          ;Prserve awhile.
        CLC
        LDX     #0
        SBC     (DSCPNT),Y           ;GET length of what's LEFT.
        BCS     RLEFT2               ;Give null string.
        EOR     #255                 ;In sub c was 0 so just complement.
        CMP     FACLO                ;Greater than what's desired?
        BCC     RLEFT3               ;No, COPY that much.
        LDA     FACLO                ;GET length of what's desired.
        BCS     RLEFT3               ;COPY it.

; Used by RIGHT$, LEFT$, MID$ FOR parameter checking and setup.

PREAM:
        JSR     CHKCLS               ;Param LIST should END.
        PLA                          ;GET the RETURN address into
        TAY                          ;[JMPER+1,y]
        PLA
        STA     JMPER + 1
        PLA                          ;GET rid of FINGO's jsr ret addr.
        PLA
        PLA                          ;GET length.
        TAX
        PULWD   DSCPNT
        LDA     JMPER + 1            ;Put RETURN address back on
        PHA
        TYA
        PHA
        LDY     #0
        TXA
        RTS

; The function LEN($) returns the length of the string
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

; The following is the ASC($) function. it returns
; An integer which is the decimal ascii equivalent.

ASC:
        JSR     LEN1
        BEQ     GOFUC                ;Null string, bad arg.
        LDY     #0
        LDA     (INDEX1),Y           ;GET character.
        TAY
        JMP     SNGFLT
GOFUC:
        JMP     FCERR                ;Yes.

GTBYTC:
        JSR     CHRGET
GETBYT:
        JSR     FRMNUM               ;READ formula into FAC.
CONINT:
        JSR     POSINT               ;Convert the FAC to a single byte INT.
        LDX     FACMO
        BNE     GOFUC                ;Result must be .le. 255.
        LDX     FACLO
CHRGO2:
        JMP     CHRGOT               ;Set condition codes on terminator.

; The "VAL" function takes a string and turns it into
; A number by interpreting the ascii digits etcq
; Except FOR the problem that a terminator must be supplied
; By replacing the character beyond the string, VAL is merely
; A call to floating point INPUT ("FIN")*

VAL:
        JSR     LEN1                 ;Do setup. set result=numeric.
        JEQ     ZEROFC               ;ZERO the FAC on a null string
        LDXY    TXTPTR
        STXY    STRNG2               ;SAVE FOR later.
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
        JSR     CHRGOT               ;GET character pnt'd to and set flags.
        JSR     FIN
        PLA                          ;GET pres'd character.
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
        JSR     FRMNUM               ;GET address.
        JSR     GETADR               ;GET that location.
COMBYT:
        JSR     CHKCOM               ;Check FOR a comma.
        JMP     GETBYT               ;GET something to store and RETURN.
GETADR:
        LDA     FACSGN               ;Examine SIGN.
        BMI     GOFUC                ;Function call ERROR.
        LDA     FACEXP               ;Examine exponent.
        CMP     #145
        BCS     GOFUC                ;Function call ERROR.
        JSR     QINT                 ;Integerize it.
        LDWD    FACMO
        STY     POKER
        STA     POKER + 1
        RTS                          ;It's done !*

PEEK:
        PSHWD   POKER
        JSR     GETADR
        LDY     #0
        .IF     REALIO == 3
        CMP     #ROMLOC / 256        ;IF within basic
        BCC     GETCON
        CMP     #LASTWR / 256
        BCC     DOSGFL
        .endif
                                     ;Give him ZERO FOR an answer.
GETCON:
        LDA     (POKER),Y            ;GET that byte.
        TAY
DOSGFL:
        PULWD   POKER
        JMP     SNGFLT               ;FLOAT it.

POKE:
        JSR     GETNUM
        TXA
        LDY     #0
        STA     (POKER),Y            ;Store value away.
        RTS                          ;Scanned  everything.

; The wait location,mask1,mask2 statement waits until the contents
; Of location is nonzero when xored with mask2
; And then anded with mask1. IF mask2 is not present, it
; Is assumed to be ZERO.

FNWAIT:
        JSR     GETNUM
        STX     ANDMSK
        LDX     #0
        JSR     CHRGOT
        BEQ     ZSTORD
        JSR     COMBYT               ;GET mask2.
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

; The SIGN is the first bit of the mantissa.
; The mantissa is 24 BITS long.
; The binary point is to the LEFT of the msb.
; Number = mantissa * 2 ^ exponent.
; The mantissa is positive with a one assumed to be where the SIGN bit is.
; The SIGN of the exponent is the first bit of the exponent.
; The exponent is stored in excess 200, i.e. with a bias of +200.
; So, the exponent is a signed 8-bit number with 200 added to it.
; An exponent of ZERO means the number is ZERO.
; The other bytes may not be assumed to be ZERO.
; To keep the same number in the FAC while shifting,
; 	To shift RIGHT, EXP:=EXP+1
; 	To shift LEFT,	EXP:=EXP-1

; In MEMORY the number looks like this:
; 	[The exponent as a signed number +200]
; 	[The SIGN bit in 7, BITS 2-8 of mantissa are in BITS 6-0].
; 		(Remember bit 1 of mantissa is always a one.)
; 	[BITS 9-16 of the mantissa]
; 	[BITS 17-24] of the mantissa]

; Arithmetic routine calling conventions:

; FOR one argument functions:
; 	The argument is in the FAC.
; 	The result is LEFT in the FAC.
; FOR two argument operations:
; 	The first argument is in arg (ARGEXP,ho,mo,lo and ARGSGN).
; 	The second argument is in the FAC.
; 	The result is LEFT in the FAC.

; The "t" entry points to the two-argument operations have both arguments
; Setup in the respective registers. before calling arg may have been
; Popped off the stack and into arg, FOR example.
; The other entry point assumes [y,a] points to the argument
; Somewhere in MEMORY. it is unpacked into arg by "CONUPK".

; On the stack, the SGN is pushed on first, the lo,mo,ho and finally EXP.
; Note all things are kept unpacked in arg, FAC and on the stack.

; It is only when something is stored away that it is packed to four
; Bytes. the unpacked format has a SGN byte reflecting the SIGN of the
; Number (positive=0, negative=-1) a ho,mo and lo with the high bit
; Of the ho turned on. the EXP is the same as stored format.
; This is done FOR speed of operation.

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
        EOR     ARGSGN               ;Complement ARISGN.
        STA     ARISGN
        LDA     FACEXP               ;Set codes on FACEXP.
        JMP     FADDT                ;[Y]=ARGEXP..
                                     ; Xlist
; .Xcref
        .IF     REALIO != 3
ZSTORD  =       STORDO
        .endif
        .IF     REALIO == 3
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
        .IF     1
MRCHR:
        LDA     0o60000,X
        .endif
        .IF     1
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
        .IF     1
; Purge ZSTORD
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
        JEQ     MOVFA                ;IF FAC=0, result is in arg.
        LDX     FACOV
        STX     OLDOV
        LDX     #ARGEXP              ;Default is shift argument.
        LDA     ARGEXP               ;IF arg=0, FAC is result.
FADDC:
        TAY                          ;Also COPY acca into accy.
        BEQ     ZERRTS               ;RETURN.
        SEC
        SBC     FACEXP
        BEQ     FADD4                ;No shifting.
        BCC     FADDA                ;Br IF ARGEXP.lt.FACEXP.
        STY     FACEXP               ;Resulting exponent.
        LDY     ARGSGN               ;Since arg is bigger, it's
        STY     FACSGN               ;SIGN is SIGN of result.
        EOR     #0o377               ;Shift a negative number of places.
        ADC     #0                   ;Complete negation. w/ c=1.
        LDY     #0                   ;ZERO OLDOV.
        STY     OLDOV
        LDX     #FAC                 ;Shift the FAC instead.
        BNE     FADD1
FADDA:
        LDY     #0
        STY     FACOV
FADD1:
        CMP     #0o256 - 7           ;FOR speed and necessity.  gets
                                     ;Most likely case to SHIFTR fastest
                                     ;And allows shifting of neg nums
                                     ;By "QINT"*
        BMI     FADD5                ;Shift big.
        TAY
        LDA     FACOV                ;Set FACOV.
        LSR     1,X                  ;Gets 0 in most sig bit.
        JSR     ROLSHF               ;Do the rolling.
FADD4:
        BIT     ARISGN               ;GET resulting SIGN.
        BPL     FADD2                ;IF positive, add.
                                     ;Carry is CLEAR.
FADD3:
        LDY     #FACEXP
        CPX     #ARGEXP              ;FAC is bigger.
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
        .IF     ADDPRC != 0
        LDA     2,Y
        SBC     2,X
        STA     FACMOH
        .endif
        LDA     1,Y
        SBC     1,X
        STA     FACHO
FADFLT:
        BCS     NORMAL               ;Here IF signs differ. IF carry
                                     ;FAC is set ok.
        JSR     NEGFAC               ;Negate [FAC]*
NORMAL:
        LDY     #0
        TYA
        CLC
NORM3:
        LDX     FACHO
        BNE     NORM1
        LDX     FACHO + 1            ;Shift 8 BITS at a TIME FOR speed.
        STX     FACHO
        .IF     ADDPRC != 0
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
        LDA     #0                   ;Not need by NORMAL but by others.
ZEROF1:
        STA     FACEXP               ;Number must be ZERO.
ZEROML:
        STA     FACSGN               ;Make SIGN positive.
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
        .IF     ADDPRC != 0
        LDA     FACMOH
        ADC     ARGMOH
        STA     FACMOH
        .endif
        LDA     FACHO
        ADC     ARGHO
        STA     FACHO
        JMP     SQUEEZ               ;Go ROUND IF signs same.

NORM2:
        ADC     #1                   ;Decrement shift COUNT.
        ASL     FACOV                ;Shift all LEFT one bit.
        ROL     FACLO
        ROL     FACMO
        .IF     ADDPRC != 0
        ROL     FACMOH
        .endif
        ROL     FACHO
NORM1:
        BPL     NORM2                ;IF msb=0 shift again.
        SEC
        SBC     FACEXP
        BCS     ZEROFC
        EOR     #0o377
        ADC     #1                   ;Complement.
        STA     FACEXP
SQUEEZ:
        BCC     RNDRTS               ;BITS to shift?
RNDSHF:
        INC     FACEXP
        BEQ     OVERR
        ROR     FACHO
        .IF     ADDPRC != 0
        ROR     FACMOH
        .endif
        ROR     FACMO
        ROR     FACLO
        ROR     FACOV
RNDRTS:
        RTS                          ;All done adding.

NEGFAC:
        COM     FACSGN               ;Complement FAC	 entirely.
NEGFCH:
        COM     FACHO                ;Complement just the number.
        .IF     ADDPRC != 0
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
        BNE     INCFRT               ;IF no carry, RETURN.
        .IF     ADDPRC != 0
        INC     FACMOH
        BNE     INCFRT
        .endif
        INC     FACHO                ;Carry increment.
INCFRT:
        RTS

OVERR:
        LDX     #ERROV
        JMP     ERROR                ;Tell user.

; "SHIFTR" shifts [x+1:x+3] [-acca]  BITS RIGHT.
; Shifts bytes to START with IF possible.

MULSHF:
        LDX     #RESHO - 1           ;Entry point FOR multiplier.
SHFTR2:
        LDY     3 + ADDPRC,X         ;Shift bytes first.
        STY     FACOV
        .IF     ADDPRC != 0
        LDY     3,X
        STY     4,X
        .endif
        LDY     2,X                  ;GET mo.
        STY     3,X                  ;Store lo.
        LDY     1,X                  ;GET ho.
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
        .IF     RORSW != 0
SHFTR3:
        ASL     1,X
        BCC     SHFTR4
        INC     1,X
SHFTR4:
        ROR     1,X
        ROR     1,X
        .endif
                                     ;Yes, two of them.
        .IF     RORSW == 0
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
        .IF     RORSW != 0
        ROR     2,X
        ROR     3,X
        .IF     ADDPRC != 0
        ROR     4,X
        .endif
                                     ;One mo TIME.
        .endif
        .IF     RORSW == 0
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
        .IF     ADDPRC != 0
        LDA     #0
        BCC     SHFT6A
        LDA     #0o200
SHFT6A:
        LSR     4,X
        ORA     4,X
        STA     4,X
        .endif
        .endif
        .IF     RORSW != 0
        ROR     A
        .endif
                                     ;Rotate argument 1 bit RIGHT.
        .IF     RORSW == 0
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
        CLC                          ;CLEAR output of FACOV.
        RTS
        .page
        .subttl NATURAL LOG FUNCTION.

; Calculation is by:
; Ln(f*2^n)=(n+LOG2(f))*ln(2)
; An approximation polynomial is used to calculate LOG2(f)*
;  Constants used by LOG:
FONE:
        .byte   0o201                ; 1.0
        .byte   0
        .byte   0
        .byte   0
        .IF     ADDPRC != 0
        .byte   0
        .endif
        .IF     ADDPRC == 0
LOGCN2:
        .byte   2                    ; DEGREE-1
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

        .IF     ADDPRC != 0
LOGCN2:
        .byte   3                    ;DEGREE-1
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
        .byte   0o200                ; SQR(0.5)
        .byte   0o065
        .byte   4
        .byte   0o363
        .IF     ADDPRC != 0
        .byte   0o064
        .endif
SQRTWO:
        .byte   0o201                ; SQR(2.0)
        .byte   0o065
        .byte   4
        .byte   0o363
        .IF     ADDPRC != 0
        .byte   0o064
        .endif
NEGHLF:
        .byte   0o200                ; -1/2
        .byte   0o200
        .byte   0
        .byte   0
        .IF     ADDPRC != 0
        .byte   0
        .endif
LOG2:
        .byte   0o200                ; Ln(2)
        .byte   0o061
        .byte   0o162
        .IF     ADDPRC == 0
        .byte   0o030
        .endif
        .IF     ADDPRC != 0
        .byte   0o027
        .byte   0o370
        .endif

LOG:
        JSR     SIGN                 ;Is it positive?
        BEQ     LOGERR
        BPL     LOG1
LOGERR:
        JMP     FCERR                ;Can't tolerate neg or ZERO.
LOG1:
        LDA     FACEXP               ;GET exponent into acca.
        SBC     #0o177               ;Remove bias. (carry is off)
        PHA                          ;SAVE awhile.
        LDA     #0o200
        STA     FACEXP               ;Result is FAC in range [0.5,1]*
        LDWDI   SQRHLF               ;GET pointer to SQR(0.5)*

; Calculate (f-SQR(.5))/(f+SQR(.5))

        JSR     FADD                 ;Add to FAC.
        LDWDI   SQRTWO               ;GET SQR(2.)*
        JSR     FDIV
        LDWDI   FONE
        JSR     FSUB
        LDWDI   LOGCN2
        JSR     POLYX                ;Evaluate approximation polynomial.
        LDWDI   NEGHLF               ;Add in last constant.
        JSR     FADD
        PLA                          ;GET exponent back.
        JSR     FINLOG               ;Add it in.
MULLN2:
        LDWDI   LOG2                 ;Multiply result by LOG(2.0)*
;	Jmp	FMULT		;multiply together.
        .page
        .subttl FLOATING MULTIPLICATION AND DIVISION.
                                     ;Multiplication		FAC:=arg*FAC.
FMULT:
        JSR     CONUPK               ;Unpack the constant into arg FOR use.
FMULTT:
        JEQ     MULTRT               ;IF FAC=0, RETURN. FAC is set.
        JSR     MULDIV               ;Fix up the exponents.
        LDA     #0                   ;To CLEAR result.
        STA     RESHO
        .IF     ADDPRC != 0
        STA     RESMOH
        .endif
        STA     RESMO
        STA     RESLO
        LDA     FACOV
        JSR     MLTPLY
        LDA     FACLO                ;MLTPLY arg by FACLO.
        JSR     MLTPLY
        LDA     FACMO                ;MLTPLY arg by FACMO.
        JSR     MLTPLY
        .IF     ADDPRC != 0
        LDA     FACMOH
        JSR     MLTPLY
        .endif
        LDA     FACHO                ;MLTPLY arg by FACHO.
        JSR     MLTPL1
        JMP     MOVFR                ;Move result into FAC
                                     ;Normalize result, and RETURN.
MLTPLY:
        JEQ     MULSHF               ;Shift result RIGHT 1 byte.
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
        .IF     ADDPRC != 0
        LDA     RESMOH
        ADC     ARGMOH
        STA     RESMOH
        .endif
        LDA     RESHO
        ADC     ARGHO
        STA     RESHO
MLTPL3:
        ROR     RESHO
        .IF     ADDPRC != 0
        ROR     RESMOH
        .endif
        ROR     RESMO
        ROR     RESLO
        ROR     FACOV                ;SAVE FOR rounding.
        TYA
        LSR     A                    ;CLEAR msb so we GET a closer to 0.
        BNE     MLTPL2               ;Slow as a turtle !
MULTRT:
        RTS

                                     ;Routine to unpack MEMORY into arg.
CONUPK:
        STWD    INDEX1
        LDY     #3 + ADDPRC
        LDA     (INDEX1),Y
        STA     ARGLO
        DEY
        LDA     (INDEX1),Y
        STA     ARGMO
        DEY
        .IF     ADDPRC != 0
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
        LDA     FACEXP               ;Set codes of FACEXP.
        RTS

                                     ;Check special cases and add exponents FOR FMULT, FDIV.
MULDIV:
        LDA     ARGEXP               ;EXP of arg=0?
MLDEXP:
        BEQ     ZEREMV               ;So we GET ZERO exponent.
        CLC
        ADC     FACEXP               ;Result is in acca.
        BCC     TRYOFF               ;Find [c] xor [n]*
        BMI     GOOVER               ;Overflow IF BITS match.
        CLC
        SKIP2
TRYOFF:
        BPL     ZEREMV               ;Underflow.
        ADC     #0o200               ;Add bias.
        STA     FACEXP
        JEQ     ZEROML               ;ZERO the rest of it.
        LDA     ARISGN
        STA     FACSGN               ;ARISGN is result's SIGN.
        RTS                          ;Done.
MLDVEX:
        LDA     FACSGN               ;GET SIGN.
        EOR     #0o377               ;Complement it.
        BMI     GOOVER
ZEREMV:
        PLA                          ;GET addr off stack.
        PLA
        JMP     ZEROFC               ;Underflow.
GOOVER:
        JMP     OVERR                ;Overflow.

                                     ;Multiply FAC by 10.
MUL10:
        JSR     MOVAF                ;COPY FAC into arg.
        TAX
        BEQ     MUL10R               ;IF [FAC]=0, got answer.
        CLC
        ADC     #2                   ;Augment EXP by 2.
        BCS     GOOVER               ;Overflow.
FINML6:
        LDX     #0
        STX     ARISGN               ;Signs are same.
        JSR     FADDC                ;Add together.
        INC     FACEXP               ;Multiply by two.
        BEQ     GOOVER               ;Overflow.
MUL10R:
        RTS

                                     ; DIVIDE FAC by 10.
TENZC:
        .byte   0o204
        .byte   0o040
        .byte   0
        .byte   0
        .IF     ADDPRC != 0
        .byte   0
        .endif
DIV10:
        JSR     MOVAF                ;Move FAC to arg.
        LDWDI   TENZC                ;Point to constant of 10.0
        LDX     #0                   ;Signs are both positive.
FDIVF:
        STX     ARISGN
        JSR     MOVFM                ;Put it into FAC.
        JMP     FDIVT                ;Skip over NEXT two bytes.
FDIV:
        JSR     CONUPK               ;Unpack constant.
FDIVT:
        BEQ     DV0ERR               ;Can't DIVIDE by ZERO !
                                     ;(Not enough room to store result.)
        JSR     ROUND                ;Take FACOV into acct in FAC.
        LDA     #0                   ;Negate FACEXP.
        SEC
        SBC     FACEXP
        STA     FACEXP
        JSR     MULDIV               ;Fix up exponents.
        INC     FACEXP               ;Scale it RIGHT.
        BEQ     GOOVER               ;Overflow.
        LDX     #0o256 - 3 - ADDPRC  ;Setup procedure.
        LDA     #1
DIVIDE:
                                     ;This is the best code in the whole pile.
        LDY     ARGHO                ;See what relation holds.
        CPY     FACHO
        BNE     SAVQUO               ;[C]=0,1. n(c=0)=0.
        .IF     ADDPRC != 0
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
        ROL     A                    ;SAVE result.
        BCC     QSHFT                ;IF not done, continue.
        INX
        STA     RESLO,X
        BEQ     LD100
        BPL     DIVNRM               ;Note this req 1 mo ram then necess.
        LDA     #1
QSHFT:
        PLP                          ;RETURN condition codes.
        BCS     DIVSUB               ;FAC .le. arg.
SHFARG:
        ASL     ARGLO                ;Shift arg one place LEFT.
        ROL     ARGMO
        .IF     ADDPRC != 0
        ROL     ARGMOH
        .endif
        ROL     ARGHO
        BCS     SAVQUO               ;SAVE a result of one FOR this position
                                     ;And DIVIDE.
        BMI     DIVIDE               ;IF msb on, go decide whether to sub.
        BPL     SAVQUO
DIVSUB:
        TAY                          ;Notice c must be on here.
        LDA     ARGLO
        SBC     FACLO
        STA     ARGLO
        LDA     ARGMO
        SBC     FACMO
        STA     ARGMO
        .IF     ADDPRC != 0
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
        LDA     #0o100               ;Only want two more BITS.
        BNE     QSHFT                ;Always branches.
DIVNRM:
        .repeat 6
        ASL     A
        .endrepeat
                                     ;GET last two BITS into msb and b6.
        STA     FACOV
        PLP                          ;To GET garbage off stack.
        JMP     MOVFR                ;Move result into FAC, then
                                     ;Normalize result and RETURN.
DV0ERR:
        LDX     #ERRDV0
        JMP     ERROR
        .page
        .subttl FLOATING POINT MOVEMENT ROUTINES.
                                     ;Move result to FAC.
MOVFR:
        LDA     RESHO
        STA     FACHO
        .IF     ADDPRC != 0
        LDA     RESMOH
        STA     FACMOH
        .endif
        LDA     RESMO
        STA     FACMO
        LDA     RESLO                ;Move lo and SGN.
        STA     FACLO
        JMP     NORMAL               ;All done.

                                     ;Move MEMORY into FAC (unpacked)*
MOVFM:
        STWD    INDEX1
        LDY     #3 + ADDPRC
        LDA     (INDEX1),Y
        STA     FACLO
        DEY
        LDA     (INDEX1),Y
        STA     FACMO
        DEY
        .IF     ADDPRC != 0
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
        STA     FACEXP               ;Leave switches set on EXP.
        STY     FACOV
        RTS

                                     ;Move number from FAC to MEMORY.
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
        .IF     ADDPRC != 0
        LDA     FACMOH
        STA     (INDEX),Y
        DEY
        .endif
        LDA     FACSGN               ;Include SIGN in ho.
        ORA     #0o177
        AND     FACHO
        STA     (INDEX),Y
        DEY
        LDA     FACEXP
        STA     (INDEX),Y
        STY     FACOV                ;ZERO it since rounded.
        RTS                          ;[Y]=0.

                                     ;Move arg into FAC.
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

                                     ;Move FAC into arg.
MOVAF:
        JSR     ROUND
MOVEF:
        LDX     #5 + ADDPRC
MOVAFL:
        LDA     FACEXP - 1,X
        STA     ARGEXP - 1,X
        DEX
        BNE     MOVAFL
        STX     FACOV                ;ZERO it since rounded.
MOVRTS:
        RTS

ROUND:
        LDA     FACEXP               ;ZERO?
        BEQ     MOVRTS               ;Yes. done rounding.
        ASL     FACOV                ;ROUND?
        BCC     MOVRTS               ;No. msb off.
INCRND:
        JSR     INCFAC               ;Yes, add one to lsb(FAC)*
        BNE     MOVRTS               ;No carry means done.
        JMP     RNDSHF               ;SQUEEZ msb in and rts.
                                     ;Note [c]=1 since INCFAC doesnt touch c.
        .page
        .subttl SIGN, SGN, FLOAT, NEG, ABS.

                                     ;Put SIGN of FAC in acca.
SIGN:
        LDA     FACEXP
        BEQ     SIGNRT               ;IF number is ZERO, so is result.
FCSIGN:
        LDA     FACSGN
FCOMPS:
        ROL     A
        LDA     #0o377               ;Assume negative.
        BCS     SIGNRT
        LDA     #1                   ;GET +1.
SIGNRT:
        RTS

                                     ;SGN function.
SGN:
        JSR     SIGN

                                     ;FLOAT the signed integer in acca.
FLOAT:
        STA     FACHO                ;Put [acca] in high order.
        LDA     #0
        STA     FACHO + 1
        LDX     #0o210               ;GET the exponent.

                                     ;FLOAT the signed number in FAC.
FLOATS:
        LDA     FACHO
        EOR     #0o377
        ROL     A                    ;GET comp of SIGN in carry.
FLOATC:
        LDA     #0                   ;ZERO [acca] but not carry.
        STA     FACLO
        .IF     ADDPRC != 0
        STA     FACMO
        .endif
FLOATB:
        STX     FACEXP
        STA     FACOV
        STA     FACSGN
        JMP     FADFLT

                                     ;Absolute value of FAC.
ABS:
        LSR     FACSGN
        RTS

        .page
        .subttl COMPARE TWO NUMBERS.
                                     ;A=1 IF arg .lt. FAC.
                                     ;A=0 IF arg=FAC.
                                     ;A=-1 IF arg .gt. FAC.
FCOMP:
        STA     INDEX2
FCOMPN:
        STY     INDEX2 + 1
        LDY     #0
        LDA     (INDEX2),Y           ;Has ARGEXP.
        INY                          ;Bump pntr up.
        TAX                          ;SAVE a in x and reset codes.
        BEQ     SIGN
        LDA     (INDEX2),Y
        EOR     FACSGN               ;Signs the same.
        BMI     FCSIGN               ;Signs differ so result is
                                     ;SIGN of FAC again.
FOUTCP:
        CPX     FACEXP
        BNE     FCOMPC
        LDA     (INDEX2),Y
        ORA     #0o200
        CMP     FACHO
        BNE     FCOMPC
        INY
        .IF     ADDPRC != 0
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
        SBC     FACLO                ;GET ZERO IF equal.
        BEQ     QINTRT
FCOMPC:
        LDA     FACSGN
        BCC     FCOMPD
        EOR     #0o377
FCOMPD:
        JMP     FCOMPS               ;A part of SIGN sets acca up.

        .page
        .subttl GREATEST INTEGER FUNCTION.
                                     ;Quick greatest integer function.
                                     ;Leaves INT(FAC) in FACHO&mo&lo signed.
                                     ;Assumes FAC .lt. 2^23 = 8388608
QINT:
        LDA     FACEXP
        BEQ     CLRFAC               ;IF ZERO, got it.
        SEC
        SBC     #8 * ADDPRC + 0o230  ;GET number of places to shift.
        BIT     FACSGN
        BPL     QISHFT
        TAX
        LDA     #0o377
        STA     BITS                 ;Put 377 in when shftr shifts bytes.
        JSR     NEGFCH               ;Truly negate quantity in FAC.
        TXA
QISHFT:
        LDX     #FAC
        CMP     #0o256 - 7
        BPL     QINT1                ;IF number of places .ge. 7
                                     ;Shift 1 place at a TIME.
        JSR     SHIFTR               ;START shifting bytes, then BITS.
        STY     BITS                 ;ZERO BITS since adder wants ZERO.
QINTRT:
        RTS
QINT1:
        TAY                          ;Put COUNT in counter.
        LDA     FACSGN
        AND     #0o200               ;GET SIGN bit.
        LSR     FACHO                ;SAVE first shifted byte.
        ORA     FACHO
        STA     FACHO
        JSR     ROLSHF               ;Shift the rest.
        STY     BITS                 ;ZERO [BITS]*
        RTS

                                     ;Greatest integer function.
INT:
        LDA     FACEXP
        CMP     #8 * ADDPRC + 0o230
        BCS     INTRTS               ;Forget it.
        JSR     QINT
        STY     FACOV                ;Clr overflow byte.
        LDA     FACSGN
        STY     FACSGN               ;Make FAC look positive.
        EOR     #0o200               ;GET complement of SIGN in carry.
        ROL     A
        LDA     #8 * ADDPRC + 0o230
        STA     FACEXP
        LDA     FACLO
        STA     INTEGR
        JMP     FADFLT
CLRFAC:
        STA     FACHO                ;Make it really ZERO.
        .IF     ADDPRC != 0
        STA     FACMOH
        .endif
        STA     FACMO
        STA     FACLO
        TAY
INTRTS:
        RTS
        .page
        .subttl FLOATING POINT INPUT ROUTINE.
                                     ;Number INPUT is LEFT in FAC.
                                     ;At entry [TXTPTR] points to the first character in a text buffer.
                                     ;The first character is also in acca. FIN packs the digits
                                     ;Into the FAC as an integer and keeps track of where the
                                     ;Decimal point is. [DPTFLG] tell whether a dp has been
                                     ;Seen. [DECCNT] is the number of digits after the dp.
                                     ;At the END [DECCNT] and the exponent are used to
                                     ;Determine how many times to multiply or DIVIDE by ten
                                     ;To GET the correct number.
FIN:
        LDY     #0                   ;ZERO FACSGN&SGNFLG.
        LDX     #0o11 + ADDPRC       ;ZERO EXP and ho (and moh)*
FINZLP:
        STY     DECCNT,X             ;ZERO mo and lo.
        DEX                          ;ZERO TENEXP and EXPSGN
        BPL     FINZLP               ;ZERO DECCNT, DPTFLG.
        BCC     FINDGQ               ;Flags still set from CHRGET.
        CMP     #"-"                 ;A negative SIGN?
        BNE     QPLUS                ;No, try plus SIGN.
        STX     SGNFLG               ;It's negative. (x=377)*
        BEQ     FINC                 ;Always branches.
QPLUS:
        CMP     #"+"                 ;Plus SIGN?
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
                                     ;Here to check FOR SIGN of EXP.
        JSR     CHRGET               ;Yes. GET another.
        BCC     FNEDG1               ;It is a digit. (easier than
                                     ;Backing up pointer.)
        CMP     #MINUTK              ;Minus?
        BEQ     FINEC1               ;Negate.
        CMP     #"-"                 ;Minus SIGN?
        BEQ     FINEC1
        CMP     #PLUSTK              ;Plus?
        BEQ     FINEC
        CMP     #"+"                 ;Plus SIGN?
        BEQ     FINEC
        BNE     FINEC2
FINEC1:
        ROR     EXPSGN               ;Turn it on.
FINEC:
        JSR     CHRGET               ;GET another.
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
        SBC     DECCNT               ;GET number of places to shift.
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
        BMI     NEGXQS               ;IF positive, RETURN.
        RTS
NEGXQS:
        JMP     NEGOP                ;Otherwise, negate and RETURN.

FINDIG:
        PHA
        BIT     DPTFLG
        BPL     FINDG1
        INC     DECCNT
FINDG1:
        JSR     MUL10
        PLA                          ;GET it back.
        SEC
        SBC     #"0"
        JSR     FINLOG               ;Add it in.
        JMP     FINC

FINLOG:
        PHA
        JSR     MOVAF                ;SAVE FAC FOR later.
        PLA
        JSR     FLOAT                ;FLOAT the value in acca.
        LDA     ARGSGN
        EOR     FACSGN
        STA     ARISGN               ;Resultant SIGN.
        LDX     FACEXP               ;Set signs on thing to add.
        JMP     FADDT                ;Add together and RETURN.

                                     ;Here pack in the NEXT digit of the exponent.
                                     ;Multiply the old EXP by 10 and add in the NEXT
                                     ;Digit. note: EXP overflow is not checked FOR.
FINEDG:
        LDA     TENEXP               ;GET EXP so far.
        CMP     #0o12                ;Will result be .ge. 100?
        BCC     MLEX10
        LDA     #0o144               ;GET 100.
        BIT     EXPSGN
        BMI     MLEXMI               ;IF neg EXP, no chk FOR OVERR.
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
        STA     TENEXP               ;SAVE result.
        JMP     FINEC
        .page
        .subttl FLOATING POINT OUTPUT ROUTINE.

        .IF     ADDPRC == 0
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
        .IF     ADDPRC != 0
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
                                     ;Entry to LINPRT.
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
        JMP     STROUT               ;PRINT and RETURN.

FOUT:
        LDY     #1
FOUTC:
        LDA     #" "                 ;PRINT space IF positive.
        BIT     FACSGN
        BPL     FOUT1
        LDA     #"-"
FOUT1:
        STA     FBUFFR - 1,Y         ;Store the character.
        STA     FACSGN               ;Make FAC POS FOR QINT.
        STY     FBUFPT               ;SAVE FOR later.
        INY
        LDA     #"0"                 ;GET ZERO to type IF FAC=0.
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
        STA     DECCNT               ;SAVE COUNT or ZERO it.
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
        BNE     FOUT3                ;See IF that does it.
                                     ;This always goes.
FOUT9:
        JSR     DIV10                ;Make it smaller.
        INC     DECCNT
        BNE     FOUT4                ;See IF that does it.
                                     ;This always goes.

FOUT5:
        JSR     FADDH                ;Add a half to ROUND up.
BIGGES:
        JSR     QINT
        LDX     #1                   ;Decimal point COUNT.
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
        SBC     #2                   ;Effectively add 5 to orig EXP.
        STA     TENEXP               ;That is the exponent to PRINT.
        STX     DECCNT               ;Number of decimal places.
        TXA
        BEQ     FOUT39
        BPL     FOUT8                ;Some places before dec pnt.
FOUT39:
        LDY     FBUFPT               ;GET pointer to output.
        LDA     #"*"                 ;Put in "*"
        INY
        STA     FBUFFR - 1,Y
        TXA
        BEQ     FOUT16
        LDA     #"0"                 ;GET the ensuing ZERO.
        INY
        STA     FBUFFR - 1,Y
FOUT16:
        STY     FBUFPT               ;SAVE FOR later.
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
        .IF     ADDPRC != 0
        LDA     FACMOH
        ADC     FOUTBL + 1,Y
        STA     FACMOH
        .endif
        LDA     FACHO
        ADC     FOUTBL,Y
        STA     FACHO
        INX                          ;It was done yet another TIME.
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
        ADC     #"0" - 1             ;GET a character to PRINT.
        .repeat 3 + ADDPRC
        INY
        .endrepeat
                                     ;Bump pointer up.
        STY     FDECPT
        LDY     FBUFPT
        INY                          ;Point to place to store output.
        TAX
        AND     #0o177               ;GET rid of msb.
        STA     FBUFFR - 1,Y
        DEC     DECCNT
        BNE     STXBUF               ;Not TIME FOR dp yet.
        LDA     #"*"
        INY
        STA     FBUFFR - 1,Y         ;Store dp.
STXBUF:
        STY     FBUFPT               ;Store pntr FOR later.
        LDY     FDECPT
FOUTCM:
        TXA                          ;Complement accx
        EOR     #0o377               ;Complement acca.
        AND     #0o200               ;SAVE only msb.
        TAX
        CPY     #FDCEND - FOUTBL
        .IF     TIME != 0
        BEQ     FOULDY
        CPY     #TIMEND - FOUTBL
        .endif
        BNE     FOUT2                ;Continue with output.
FOULDY:
        LDY     FBUFPT               ;GET back output pntr.
FOUT11:
        LDA     FBUFFR - 1,Y         ;Remove trailing zeroes.
        DEY
        CMP     #"0"
        BEQ     FOUT11
        CMP     #"*"
        BEQ     FOUT12               ;RUN into dp. STOP.
        INY                          ;Something else. SAVE it.
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
        STA     FBUFFR - 1 + 2,Y     ;Store SIGN of EXP
        LDA     #"E"
        STA     FBUFFR - 1 + 1,Y     ;Store the "e" character.
        TXA
        LDX     #"0" - 1
        SEC
FOUT15:
        INX                          ;Move closer to output value.
        SBC     #0o12                ;Subtract 10.
        BCS     FOUT15               ;Not negative yet.
        ADC     #"0" + 0o12          ;GET second output character.
        STA     FBUFFR - 1 + 4,Y     ;Store high digit.
        TXA
        STA     FBUFFR - 1 + 3,Y     ;Store	low digit.
        LDA     #0                   ;Put in terminator.
        STA     FBUFFR - 1 + 5,Y
        BEQA    FOUT20               ;RETURN. (always branches)*
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
        .IF     ADDPRC != 0
        .byte   0
        .endif

;Power of ten table
        .IF     ADDPRC == 0
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

        .IF     ADDPRC != 0
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
        .IF     TIME != 0
        .byte   0o377                ; -2160000 FOR TIME converter.
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
                                     ;Square root function --- SQR(a)
                                     ;Use SQR(x)=x^.5
SQR:
        JSR     MOVAF                ;Move FAC into arg.
        LDWDI   FHALF
        JSR     MOVFM                ;Put MEMORY into FAC.
                                     ;Last thing fetched is FACEXP. into accx.
;	Jmp	FPWRT		;fall into FPWRT.

                                     ;Exponentiation ---  x^y.
                                     ;N.b.  0^0=1
                                     ;First check IF y=0. IF so, the result is 1.
                                     ;NEXT check IF x=0. IF so the result is 0.
                                     ;Then check IF x.gt.0. IF not check that y is an integer.
                                     ;IF so, negate x, so that LOG doesn't give FCERR.
                                     ;IF x is negative and y is odd, negate the result
                                     ;Returned by EXP.
                                     ;To compute the result use x^y=EXP((y*LOG(x))*
FPWRT:
        BEQ     EXP                  ;IF FAC=0, just exponentiate that.
        LDA     ARGEXP               ;Is x=0?
        BNE     FPWRT1
        JMP     ZEROF1               ;ZERO FAC.
FPWRT1:
        LDXYI   TEMPF3               ;SAVE FOR later in a temp.
        JSR     MOVMF
                                     ;Y=0 already. good in case no one calls INT.
        LDA     ARGSGN
        BPL     FPWR1                ;No problems IF x.gt.0.
        JSR     INT                  ;Integerize the FAC.
        LDWDI   TEMPF3               ;GET addr of comperand.
        JSR     FCOMP                ;Equal?
        BNE     FPWR1                ;Leave x neg. LOG will blow him out.
                                     ;A=-1 and y is irrelevant.
        TYA                          ;Negate x. make positive.
        LDY     INTEGR               ;GET evenness.
FPWR1:
        JSR     MOVFA1               ;Alternate entry point.
        TYA
        PHA                          ;SAVE evenness FOR later.
        JSR     LOG                  ;Find LOG.
        LDWDI   TEMPF3               ;Multiply FAC times LOG(x)*
        JSR     FMULT
        JSR     EXP                  ;Exponentiate the FAC.
        PLA
        LSR     A                    ;Is it even?
        BCC     NEGRTS               ;Yes. or x.gt.0.
                                     ;Negate the number in FAC.
NEGOP:
        LDA     FACEXP
        BEQ     NEGRTS
        COM     FACSGN
NEGRTS:
        RTS

        .page
        .subttl EXPONENTIATION FUNCTION.
                                     ;First SAVE the original argument and multiply the FAC by
                                     ;LOG2(e)* the result is used to determine IF overflow
                                     ;Will occur since EXP(x)=2^(x*LOG2(e)) where
                                     ;LOG2(e)=LOG(e) base 2. then SAVE the integer part of
                                     ;This to scale the answer at the END. since
                                     ;2^Y=2^INT(y)*2^(y-INT(y)) and 2^INT(y) is easy to compute.
                                     ;Now compute 2^(x*LOG2(e)-INT(x*LOG2(e)) by
                                     ;P(ln(2)*(INT(x*LOG2(e))+1)-x) where p is an approximation
                                     ;Polynomial. the result is then scaled by the power of 2
                                     ;Previously saved.

LOGEB2:
        .byte   0o201                ;LOG(e) base 2.
        .byte   0o070
        .byte   0o252
        .byte   0o073
        .IF     ADDPRC != 0
        .byte   0o051
        .endif

        .IF     ADDPRC == 0
EXPCON:
        .byte   6                    ; DEGREE -1.
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

        .IF     ADDPRC != 0
EXPCON:
        .byte   7                    ;DEGREE-1
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
        LDWDI   LOGEB2               ;Multiply by LOG(e) base 2.
        JSR     FMULT
        LDA     FACOV
        ADC     #0o120
        BCC     STOLD
        JSR     INCRND
STOLD:
        STA     OLDOV
        JSR     MOVEF                ;To SAVE in arg without ROUND.
        LDA     FACEXP
        CMP     #0o210               ;IF ABS(FAC) .ge. 128, too big.
        BCC     EXP1
GOMLDV:
        JSR     MLDVEX               ;Overflow or overflow.
EXP1:
        JSR     INT
        LDA     INTEGR               ;GET low part.
        CLC
        ADC     #0o201
        BEQ     GOMLDV               ;Overflow or overflow !!
        SEC
        SBC     #1                   ;Subtract 1.
        PHA                          ;SAVE a while.
        LDX     #4 + ADDPRC          ;Prep to swap FAC and arg.
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
        JSR     NEGOP                ;Negate FAC.
        LDWDI   EXPCON
        JSR     POLY
        CLR     ARISGN               ;Multiply by positive 1.0.
        PLA                          ;GET scale factor.
        JSR     MLDEXP               ;Modify FACEXP and check FOR overflow.
        RTS                          ;Has to do jsr due to pulas in MULDIV.

        .page
        .subttl POLYNOMIAL EVALUATOR AND THE RANDOM NUMBER GENERATOR.
                                     ;Evaluate p(x^2)*x
                                     ;Pointer to DEGREE is in [y,a]*
                                     ;The constants follow the DEGREE.
                                     ;FOR x=FAC, compute:
                                     ; C0*x+c1*x^3+c2*x^5+c3*x^7+...+c(n)*x^(2*n+1)
POLYX:
        STWD    POLYPT               ;Retain polynomial pointer FOR later.
        JSR     MOV1F                ;SAVE FAC in factmp.
        LDA     #TEMPF1
        JSR     FMULT                ;Compute x^2.
        JSR     POLY1                ;Compute p(x^2)*
        LDWDI   TEMPF1
        JMP     FMULT                ;Multiply by FAC again.

                                     ;Polynomial evaluator.
                                     ;Pointer to DEGREE is in [y,a]*
                                     ;Compute:
                                     ; C0+c1*x+c2*x^2+c3*x^3+c4*x^4+...+c(n-1)*x^(n-1)+c(n)*x^n.
POLY:
        STWD    POLYPT
POLY1:
        JSR     MOV2F                ;SAVE FAC.
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
        LDWD    POLYPT               ;GET current pointer.
        CLC
        ADC     #4 + ADDPRC
        BCC     POLY4
        INY
POLY4:
        STWD    POLYPT
        JSR     FADD                 ;Add in constant.
        LDWDI   TEMPF2               ;Multiply the original FAC.
        DEC     DEGREE               ;Done?
        BNE     POLY2
RANDRT:
        RTS                          ;Yes.

                                     ;Psuedo-random number generator.
                                     ;IF arg=0, the last random number generated is returned.
                                     ;IF arg .lt. 0, a new sequence of random numbers is
                                     ;Started using the argument.
                                     ;   To form the NEXT random number in the sequence
                                     ;Multiply the previous random number by a random constant
                                     ;And add in another random constant. the then ho
                                     ;And lo bytes are switched, the exponent is put where
                                     ;It will be shifted in by NORMAL, and the exponent in the FAC
                                     ;Is set to 200 so the result will be less than 1. this
                                     ;Is then normalized and saved FOR the NEXT TIME.
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
        JSR     SIGN                 ;GET SIGN into accx.
        .IF     REALIO != 3
        TAX
        .endif
                                     ;GET into accx, since "MOVFM" uses accx.
        BMI     RND1                 ;START new sequence IF negative.
        .IF     REALIO == 3
        BNE     QSETNR
                                     ;Timers are at 9044(l0),45(hi),48(lo),49(hi) hex.
                                     ;First two are always free running.
                                     ;Second pair is not. lo is freer than hi then.
                                     ;So order in FAC is 44,48,45,49.
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
        LDWDI   RNDX                 ;GET last one into FAC.
        JSR     MOVFM
        .IF     REALIO != 3
        TXA                          ;FAC was ZERO?
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
        .IF     REALIO == 3
        LDX     FACMOH
        LDA     FACMO
        STA     FACMOH
        STX     FACMO
        .endif
STRNEX:
        CLR     FACSGN               ;Make number positive.
        LDA     FACEXP               ;Put EXP where it will
        STA     FACOV                ;Be shifted in by NORMAL.
        LDA     #0o200
        STA     FACEXP               ;Make result between 0 and 1.
        JSR     NORMAL               ;Normalize.
        LDXYI   RNDX
GMOVMF:
        JMP     MOVMF                ;Put new one into MEMORY.

        .page
        .subttl SINE, COSINE AND TANGENT FUNCTIONS.
        .IF     KIMROM == 0
                                     ;Cosine function.
                                     ;Use COS(x)=SIN(x+pi/2)
COS:
        LDWDI   PI2                  ;Pntr to pi/2.
        JSR     FADD                 ;Add it in.
                                     ;Fall into SIN.

                                     ;Sine function.
                                     ;Use identities to GET FAC in quadrants i or iv.
                                     ;The FAC is divided by 2*pi and the integer part is ignored
                                     ;Because SIN(x+2*pi)=SIN(x)* then the argument can be compared
                                     ;With pi/2 by comparing the result of the division
                                     ;With pi/2/(2*pi)=1/4.
                                     ;Identities are then used to GET the result in quadrants
                                     ;I or iv. an approximation polynomial is then used to
                                     ;Compute SIN(x)*
SIN:
        JSR     MOVAF
        LDWDI   TWOPI                ;GET pntr to divisor.
        LDX     ARGSGN               ;GET SIGN of result.
        JSR     FDIVF
        JSR     MOVAF                ;GET result into arg.
        JSR     INT                  ;Integerize FAC.
        CLR     ARISGN               ;Always have the same SIGN.
        JSR     FSUBT                ;Keep only the fractional part.
        LDWDI   FR4                  ;GET pntr to 1/4.
        JSR     FSUB                 ;Compute 1/4-FAC.
        LDA     FACSGN               ;SAVE SIGN FOR later.
        PHA
        BPL     SIN1                 ;First quadrant.
        JSR     FADDH                ;Add 1/2 to FAC.
        LDA     FACSGN               ;SIGN is negative?
        BMI     SIN2
        COM     TANSGN               ;Quadrants ii and iii come here.
SIN1:
        JSR     NEGOP                ;IF positive, negate it.
SIN2:
        LDWDI   FR4                  ;Pointer to 1/4.
        JSR     FADD                 ;Add it in.
        PLA                          ;GET original quadrant.
        BPL     SIN3
        JSR     NEGOP                ;IF negative, negate result.
SIN3:
        LDWDI   SINCON
GPOLYX:
        JMP     POLYX                ;Do approximation polynomial.

                                     ;Tangent function.
TAN:
        JSR     MOV1F                ;Move FAC into temporary.
        CLR     TANSGN               ;Remember whether to negate.
        JSR     SIN                  ;Compute the SIN.
        LDXYI   TEMPF3
        JSR     GMOVMF               ;Put SIGN into other temp.
        LDWDI   TEMPF1
        JSR     MOVFM                ;Put this MEMORY loc into FAC.
        CLR     FACSGN               ;START off positive.
        LDA     TANSGN
        JSR     COSC                 ;Compute cosine.
        LDWDI   TEMPF3               ;Address of sine value.
GFDIV:
        JMP     FDIV                 ;DIVIDE sine by cosine and RETURN.
COSC:
        PHA
        JMP     SIN1

PI2:
        .byte   0o201                ;Pi/2
        .byte   0o111
        .byte   0o017
        .byte   0o333 - ADDPRC
        .IF     ADDPRC != 0
        .byte   0o242
        .endif
TWOPI:
        .byte   0o203                ;2*Pi.
        .byte   0o111
        .byte   0o017
        .byte   0o333 - ADDPRC
        .IF     ADDPRC != 0
        .byte   0o242
        .endif
FR4:
        .byte   0o177                ;1/4
        .byte   0
        .byte   0
        .byte   0
        .IF     ADDPRC != 0
        .byte   0
        .endif
        .IF     ADDPRC == 0
SINCON:
        .byte   4                    ;DEGREE-1.
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

        .IF     ADDPRC != 0
SINCON:
        .byte   5                    ;DEGREE-1.
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
                                     ;Use identities to GET arg between 0 and 1 and then use an
                                     ;Approximation polynomial to compute arctan(x)*
ATN:
        LDA     FACSGN               ;What is SIGN?
        PHA                          ;(Meanwhile SAVE FOR later.)
        BPL     ATN1
        JSR     NEGOP                ;IF negative, negate FAC.
                                     ;Use arctan(x)=-arctan(-x) *
ATN1:
        LDA     FACEXP
        PHA                          ;SAVE this too FOR later.
        CMP     #0o201               ;See IF FAC .ge. 1.0 *
        BCC     ATN2                 ;It is less than 1.
        LDWDI   FONE                 ;GET pntr to 1.0 *
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
        JMP     NEGOP                ;IF negative, negate result.
ATN4:
        RTS                          ;All done.

        .IF     ADDPRC == 0
ATNCON:
        .byte   0o10                 ;DEGREE-1.
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

        .IF     ADDPRC != 0
ATNCON:
        .byte   0o13                 ;DEGREE-1.
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
; This initializes the basic interpreter FOR the m6502 and should be
; Located where it will be wiped out in ram IF code is all in ram.

        .IF     ROMSW == 0
        .fill   1
        .endif
                                     ;So zeroing at TXTTAB doesn't prevent
                                     ;Restarting INIT
INITAT:
        INC     CHRGET + 7           ;Increment the whole TXTPTR.
        BNE     CHZGOT
        INC     CHRGET + 8
CHZGOT:
        LDA     60000                ;A LOAD with an ext addr.
        CMP     #":"                 ;Is it a ":"?
        BCS     CHZRTS               ;It is .ge. ":"
        CMP     #" "                 ;Skip spaces.
        BEQ     INITAT
        SEC
        SBC     #"0"                 ;All chars .gt. "9" have ret'd so
        SEC
        SBC     #256 - "0"           ;See IF numeric.
                                     ;Turn carry on IF numeric.
                                     ;Also, setz IF null.
CHZRTS:
        RTS                          ;RETURN to caller.

        .byte   128                  ;Loaded or from rom.
        .byte   79                   ;The initial random number.
        .byte   199
        .byte   82
        .IF     ADDPRC != 0
        .byte   88
        .endif
        .IF     REALIO != 3
        .IF     KIMROM == 0
TYPAUT:
        LDWDI   AUTTXT
        JSR     STROUT
        .endif
        .endif
INIT:
        .IF     REALIO != 3
        LDX     #255                 ;Make it look direct in case of
        STX     CURLIN + 1
        .endif
                                     ;ERROR message.
        .IF     STKEND != 511
        LDX     #STKEND - 256
        .endif
        TXS
        .IF     REALIO != 3
        LDWDI   INIT                 ;Allow restart.
        STWD    START + 1
        STWD    RDYJSR + 1           ;Rts here on errors.
        LDWDI   AYINT
        STWD    ADRAYI
        LDWDI   GIVAYF
        STWD    ADRGAY
        .endif
        LDA     #76                  ;Jmp instruction.
        .IF     REALIO == 0
HRLI 1,0o1000
        .endif
                                     ;Make an inst.
        .IF     REALIO != 3
        STA     START
        STA     RDYJSR
        .endif
        STA     JMPER
        .IF     ROMSW != 0
        STA     USRPOK
        LDWDI   FCERR
        STWD    USRPOK + 1
        .endif
        LDA     #LINLEN              ;These must be non-ZERO so CHEAD will
        STA     LINWID               ;Work after moving a new line in BUF
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
        .IF     EXTIO != 0
        STA     CHANNL
        .endif
        STA     LASTPT + 1
        .IF     NULCMD != 0
        STA     NULCNT
        .endif
        PHA                          ;Put ZERO at the END of the stack
                                     ;So FNDFOR will STOP
        .IF     REALIO != 0
        STA     CNTWFL
        .endif
                                     ;Be talkative.
        .IF     BUFPAG != 0
        INX                          ;Make [x]=1
        STX     BUF - 3              ;Set pre-BUF bytes non-ZERO FOR CHEAD
        STX     BUF - 4
        .endif
        .IF     REALIO != 3
        JSR     CRDO
        .endif
                                     ;Type a cr.
        LDX     #TEMPST
        STX     TEMPPT               ;Set up string temporaries.
        .IF     (REALIO | LONGI) != 0
        .IF     REALIO != 3
        LDWDI   MEMORY
        JSR     STROUT
        JSR     QINLIN               ;GET a line of INPUT.
        STXY    TXTPTR               ;READ this !
        JSR     CHRGET               ;GET the first character.
        .IF     KIMROM == 0
        CMP     #"A"                 ;Is it an "a"?
        BEQ     TYPAUT
        .endif
                                     ;Yes type author's name.
        TAY                          ;Null INPUT?
        BNE     USEDE9
        .endif
                                     ;No.
        .IF     REALIO == 3
        LDY     #RAMLOC / 256
        .endif
        .IF     REALIO != 3
        .IF     ROMSW == 0
        LDWDI   LASTWR
        .endif
                                     ;Yes GET pntr to last word.
        .IF     ROMSW != 0
        LDWDI   RAMLOC
        .endif
        .endif
        .IF     ROMSW != 0
        STWD    TXTTAB
        .endif
                                     ;Set up START of program location
        STWD    LINNUM
        .IF     REALIO == 3
        TAY
        .endif
        .IF     REALIO != 3
        LDY     #0
        .endif
LOOPMM:
        INC     LINNUM
        BNE     LOOPM1
        INC     LINNUM + 1
        .IF     REALIO == 3
        BMI     USEDEC
        .endif
LOOPM1:
        LDA     #85                  ;Put random info into mem.
        STA     (LINNUM),Y
        CMP     (LINNUM),Y           ;Was it saved?
        BNE     USEDEC               ;No. that is END of MEMORY.
        ASL     A                    ;Looks like it. try another.
        STA     (LINNUM),Y
        CMP     (LINNUM),Y           ;Was it saved?
        .IF     REALIO != 3
        BNE     USEDEC
        .endif
                                     ;No. this is the END.
        .IF     REALIO != 2
        BEQ     LOOPMM
        .endif
        .IF     REALIO == 2
        BNE     USEDEC
        CMP     0                    ;See IF hitting page 0
        BNE     LOOPMM
        LDA     #76
        STA     0
        BNEA    USEDEC
        .endif
        .IF     REALIO != 3
USEDE9:
        JSR     CHRGOT               ;GET current character.
        JSR     LINGET               ;GET decimal argument.
        TAY                          ;Make sure a terminator exists.
        BEQ     USEDEC               ;It does.
        JMP     SNERR
        .endif
                                     ;It doesn't.
USEDEC:
        LDWD    LINNUM               ;GET SIZE of MEMORY INPUT.
USEDEF:
        .endif
                                     ;Highest address.
        .IF     (REALIO | LONGI) == 0
        LDWDI   16190
        .endif
                                     ;A strange number.
        STWD    MEMSIZ               ;This is the SIZE of MEMORY.
        STWD    FRETOP               ;Top of strings too.
TTYW:
        .IF     REALIO != 3
        .IF     (REALIO | LONGI) != 0
        LDWDI   TTYWID
        JSR     STROUT
        JSR     QINLIN               ;GET line of INPUT.
        STXY    TXTPTR               ;READ this !
        JSR     CHRGET               ;GET first character.
        TAY                          ;Test acca but don't affect carry.
        BEQ     ASKAGN
        JSR     LINGET               ;GET argument.
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
        .IF     ROMSW == 0
        .IF     (REALIO | LONGI) != 0
        LDWDI   FNS
        JSR     STROUT
        JSR     QINLIN
        STXY    TXTPTR               ;READ this !
        JSR     CHRGET
        LDXYI   INITAT               ;Default.
        CMP     #"Y"
        BEQ     HAVFNS               ;SAVE all functions.
        CMP     #"A"
        BEQ     OKCHAR               ;SAVE all but ATN.
        CMP     #"N"
        BNE     ASKAGN               ;Bad INPUT.
                                     ;SAVE nothing.
OKCHAR:
        LDXYI   FCERR
        STXY    ATNFIX               ;GET rid of ATN function.
        LDXYI   ATN                  ;Until we know that we should del more.
        CMP     #"A"
        BEQ     HAVFNS               ;Just GET rid of ATN.
        LDXYI   FCERR
        STXY    COSFIX               ;GET rid of the rest.
        STXY    TANFIX
        STXY    SINFIX
        LDXYI   COS                  ;And GET rid of all back to "COS"*
HAVFNS:
        .endif
        .IF     (REALIO | LONGI) == 0
        LDXYI   INITAT - 1
        .endif
        .endif
        .endif
                                     ;GET rid of all up to "INITAT"*
        .IF     ROMSW != 0
        LDXYI   RAMLOC
        STXY    TXTTAB
        .endif
        LDY     #0
        TYA
        STA     (TXTTAB),Y           ;Set up text table.
        INC     TXTTAB
        .IF     REALIO != 3
        BNE     QROOM
        INC     TXTTAB + 1
        .endif
QROOM:
        LDWD    TXTTAB               ;Prepare to use "REASON"*
        JSR     REASON
        .IF     REALIO == 3
        LDWDI   FREMES
        JSR     STROUT
        .endif
        .IF     REALIO != 3
        JSR     CRDO
        .endif
        LDA     MEMSIZ               ;Compute [MEMSIZ]-[VARTAB]*
        SEC
        SBC     TXTTAB
        TAX
        LDA     MEMSIZ + 1
        SBC     TXTTAB + 1
        JSR     LINPRT               ;Type this value.
        LDWDI   WORDS                ;More bullshit.
        JSR     STROUT
        JSR     SCRTCH               ;Set up everything else.
        .IF     REALIO == 3
        JMP     READY
        .endif
        .IF     REALIO != 3
        LDWDI   STROUT
        STWD    RDYJSR + 1
        LDWDI   READY
        STWD    START + 1
        JMP     (START + 1)

        .IF     ROMSW == 0
FNS:
        .text   "WANT SIN-COS-TAN-ATN"
        .byte   0
        .endif
        .IF     KIMROM == 0
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
        .IF     KIMROM == 0
        .text   "TERMINAL "
        .endif
        .text   "WIDTH"
        .byte   0
        .endif
WORDS:
        .text   " BYTES FREE"
        .IF     REALIO != 3
        ACRLF
        ACRLF
        .endif
        .IF     REALIO == 3
        .word   0o15
        .byte   0
FREMES:
        .endif
        .IF     REALIO == 0
        .text   "SIMULATED BASIC FOR THE 6502 V1.1"
        .endif
        .IF     REALIO == 1
        .text   "KIM BASIC V1.1"
        .endif
        .IF     REALIO == 2
        .text   "OSI 6502 BASIC VERSION 1.1"
        .endif
        .IF     REALIO == 3
        .text   "### COMMODORE BASIC ###"
        .word   0o15
        .word   0o15
        .endif
        .IF     REALIO == 4
        .text   "APPLE BASIC V1.1"
        .endif
        .IF     REALIO == 5
        .text   "STM BASIC V1.1"
        .endif
        .IF     REALIO != 3
        ACRLF
        .text   "COPYRIGHT 1978 MICROSOFT"
        ACRLF
        .endif
        .byte   0
LASTWR:
        .fill   100                  ;Space FOR temp stack.
        .IF     REALIO == 0
TSTACK:
        .fill   13600
        .endif

        .IF     1
                                     ; Purge	a,x,y
        .endif
; Ifndef	START,(START = 0)
                                     ; END	$z+START

