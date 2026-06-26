.org $D000

                                                         ; --------------------------------

                                                         ; Applesoft BASIC, V2

                                                         ; Written by Marc McDonald and Randy Wigginton.

                                                         ; Original copyright 1976 by Microsoft,
                                                         ; 1977 by Apple Computer.

                                                         ; Disassembled by (unknown).
                                                         ; Fixed by Chris Mosher.

                                                         ; For the cc65.org Assembler (ca65)

                                                         ; Applesoft BASIC was first written by
                                                         ; Marc McDonald, the first employee of Microsoft,
                                                         ; in mid-1976. That version was bought by Apple
                                                         ; and released (on casette) in Nov. 1977.

                                                         ; Version 2 was written by Randy Wigginton and
                                                         ; others at Apple in spring 1978. This version
                                                         ; was released in several different forms. The
                                                         ; one reproduced by this source assembly file is
                                                         ; the main-board ROM form, which appeared in the
                                                         ; Apple ][ plus ROM at $D000-$F7FF.

                                                         ; --------------------------------

                                                         ; --------------------------------
                                                         ; ZERO PAGE LOCATIONS:
                                                         ; --------------------------------
MS_Z_START       =                $00                    ; GETS "JMP RESTART"
MS_Z_RDYJSR      =                $03                    ; GETS "JMP STROUT"
MS_Z_ADRAYI      =                $06
MS_Z_ADRGAY      =                $08
MS_Z_USRPOK      =                $0A                    ; GETS "JMP <USER ADDR>"
                                                         ; (INITIALLY $E199)
MS_Z_CHARAC      =                $0D                    ; ALTERNATE STRING TERMINATOR
MS_Z_INTEGR      =                MS_Z_CHARAC
MS_Z_ENDCHR      =                $0E                    ; STRING TERMINATOR
MS_Z_COUNT       =                $0F                    ; USED IN PARSE
AS_EOL_PNTR      =                $0F                    ; USED IN NXLIN
AS_NUMDIM        =                $0F                    ; USED IN ARRAY ROUTINES
MS_Z_DIMFLG      =                $10
MS_Z_KIMY        =                MS_Z_DIMFLG
MS_Z_VALTYP      =                $11                    ; $:VALTYP=$FF; %:VALTYP+1=$80
MS_Z_INTFLG      =                $12
MS_Z_DORES       =                $13                    ; USED IN PARSE
MS_Z_GARBFL      =                $13                    ; USED IN GARBAG
MS_Z_SUBFLG      =                $14
MS_Z_INPFLG      =                $15                    ; = $40 FOR GET, $98 FOR READ
AS_CPRMASK       =                $16                    ; RECEIVES CPRTYP IN FRMEVL
MS_Z_TANSGN      =                $16                    ; FLAGS SIGN IN TAN
AS_HGR_SHAPE     =                $1A
AS_HGR_BITS      =                $1C
AS_HGR_COUNT     =                $1D
MON_CH           =                $24
MON_GBASL        =                $26
MON_GBASH        =                $27
MON_H2           =                $2C
MON_V2           =                $2D
MON_MASK         =                $2E
MON_HMASK        =                $30
MON_COLOR        =                $30
MON_INVFLG       =                $32
MON_PROMPT       =                $33
MON_A1L          =                $3C                    ; USED BY TAPE I/O ROUTINES
MON_A1H          =                $3D                    ; "
MON_A2L          =                $3E                    ; "
MON_A2H          =                $3F                    ; "
MS_Z_LINNUM      =                $50                    ; CONVERTED LINE #
MS_Z_TEMPPT      =                $52                    ; LAST USED TEMP STRING DESC
MS_Z_LASTPT      =                $53                    ; LAST USED TEMP STRING PNTR
MS_Z_TEMPST      =                $55                    ; HOLDS UP TO 3 DESCRIPTORS
MS_Z_INDEX       =                $5E
AS_DEST          =                $60
AS_RESULT        =                $62                    ; RESULT OF LAST * OR /
MS_Z_TXTTAB      =                $67                    ; START OF PROGRAM TEXT
MS_Z_VARTAB      =                $69                    ; START OF VARIABLE STORAGE
MS_Z_ARYTAB      =                $6B                    ; START OF ARRAY STORAGE
MS_Z_STREND      =                $6D                    ; END OF ARRAY STORAGE
MS_Z_FRETOP      =                $6F                    ; START OF STRING STORAGE
MS_Z_FRESPC      =                $71                    ; TEMP PNTR, STRING ROUTINES
MS_Z_MEMSIZ      =                $73                    ; END OF STRING SPACE (HIMEM)
MS_Z_CURLIN      =                $75                    ; CURRENT LINE NUMBER
                                                         ; ( = $FFXX IF IN DIRECT MODE)
MS_Z_OLDLIN      =                $77                    ; ADDR. OF LAST LINE EXECUTED
MS_Z_POKER       =                MS_Z_LINNUM
MS_Z_OLDTXT      =                $79
MS_Z_DATLIN      =                $7B                    ; LINE # OF CURRENT DATA STT.
MS_Z_DATPTR      =                $7D                    ; ADDR OF CURRENT DATA STT.
MS_Z_INPPTR      =                $7F
MS_Z_VARNAM      =                $81                    ; NAME OF VARIABLE
MS_Z_VARPNT      =                $83                    ; ADDR OF VARIABLE
MS_Z_FDECPT      =                MS_Z_VARPNT
MS_Z_FORPNT      =                $85
MS_Z_LSTPNT      =                MS_Z_FORPNT
MS_Z_ANDMSK      =                MS_Z_FORPNT
MS_Z_EORMSK      =                MS_Z_FORPNT + 1
MS_Z_VARTXT      =                $87                    ; USED IN INPUT
MS_Z_OPPTR       =                $87                    ; SCRATCH FLAG USED IN FRMEVL
MS_Z_OPMASK      =                $89                    ; >,=,< FLAG IN FRMEVL
MS_Z_DOMASK      =                MS_Z_TANSGN
MS_Z_GRBPNT      =                $8A
MS_Z_DEFPNT      =                $8A
MS_Z_DSCPNT      =                $8C
MS_Z_FOUR6       =                $8F                    ; USED IN GARBAG
MS_Z_JMPER       =                $90                    ; GETS "JMP ...."
MS_Z_SIZE        =                $91                    ; USED IN GARBAG
MS_Z_OLDOV       =                $92                    ; FP EXTRA PRECISION
MS_Z_TEMPF3      =                MS_Z_DEFPNT
MS_Z_TEMPF1      =                $93                    ; SAVE AREAS FOR FAC
MS_Z_ARYPNT      =                $94                    ; USED IN GARBAG
MS_Z_HIGHDS      =                $94                    ; PNTR FOR BLTU
MS_Z_HIGHTR      =                $96                    ; PNTR FOR BLTU
MS_Z_TEMPF2      =                $98
AS_TMPEXP        =                $99                    ; USED IN FIN (EVAL)
AS_INDX          =                $99                    ; USED BY ARRAY RTNS
MS_Z_TENEXP      =                $9A                    ; "
MS_Z_DPTFLG      =                $9B                    ; FLAGS DEC PNT IN FIN
MS_Z_LOWTR       =                $9B
MS_Z_EXPSGN      =                $9C
MS_Z_FAC         =                $9D                    ; MAIN FLT PT ACCUMULATOR
MS_Z_FACEXP      =                MS_Z_FAC
MS_Z_DSCTMP      =                $9D
AS_VPNT          =                $A0                    ; TEMP VAR PTR
MS_Z_FACSGN      =                $A2                    ; HOLDS UNPACKED SIGN
MS_Z_DEGREE      =                $A3                    ; HOLDS LENGTH OF SERIES-1
MS_Z_BITS        =                $A4                    ; SIGN EXTENSION, RIGHT SHIFTS
MS_Z_ARGEXP      =                $A5                    ; SECONDARY FP ACC
MS_Z_ARGSGN      =                $AA
MS_Z_ARISGN      =                $AB                    ; FLAGS OPP SIGN IN FP ROUT.
MS_Z_FACOV       =                $AC                    ; FAC EXTENSION BYTE
MS_Z_POLYPT      =                $AD                    ; PNTR TO SERIES DATA IN FP
MS_Z_STRNG1      =                $AB
MS_Z_BUFPTR      =                $ad
MS_Z_STRNG2      =                $AD
AS_PRGEND        =                $AF
MS_Z_CHRGET      =                $B1
MS_Z_CHRGOT      =                $B7
MS_Z_TXTPTR      =                $B8
MS_Z_RNDX        =                $C9
AS_HGR_DX        =                $D0
AS_HGR_DY        =                $D2
AS_HGR_QUADRANT  =                $D3
AS_HGR_E         =                $D4
AS_LOCK          =                $D6                    ; NO USER ACCESS IF > 127
AS_ERRFLG        =                $D8                    ; $80 IF ON ERR ACTIVE
AS_ERRLIN        =                $DA                    ; LINE # WHERE ERROR OCCURRED
AS_ERRPOS        =                $DC                    ; TXTPTR SAVE FOR HANDLERR
AS_ERRNUM        =                $DE                    ; WHICH ERROR OCCURRED
AS_ERRSTK        =                $DF                    ; STACK PNTR BEFORE ERROR
AS_HGR_X         =                $E0
AS_HGR_Y         =                $E2
AS_HGR_COLOR     =                $E4
AS_HGR_HORIZ     =                $E5                    ; BYTE INDEX FROM GBASH,L
AS_HGR_PAGE      =                $E6                    ; HGR=$20, HGR2=$40
AS_HGR_SCALE     =                $E7
AS_HGR_SHAPE_PNTR =                $E8
AS_HGR_COLLISIONS =                $EA
AS_FIRST         =                $F0
AS_SPEEDZ        =                $F1                    ; OUTPUT SPEED
AS_TRCFLG        =                $F2
AS_FLASH_BIT     =                $F3                    ; = $40 FOR FLASH, ELSE =$00
AS_TXTPSV        =                $F4
AS_CURLSV        =                $F6
AS_REMSTK        =                $F8                    ; STACK PNTR BEFORE EACH STT.
AS_HGR_ROTATION  =                $F9
                                                         ; $FF IS ALSO USED BY THE STRING OUT ROUTINES
                                                         ; --------------------------------
AS_STACK         =                $0100
MS_A_BUFOFS      =                $0200
AS_AMPERSAND_VECTOR =                $03F5                  ; - 3F7   GETS "JMP ...."
                                                         ; --------------------------------
                                                         ; I/O & SOFT SWITCHES
                                                         ; --------------------------------
AS_KEYBOARD      =                $C000
AS_SW_TXTCLR     =                $C050
AS_SW_MIXCLR     =                $C052
AS_SW_MIXSET     =                $C053
AS_SW_LOWSCR     =                $C054
AS_SW_HISCR      =                $C055
AS_SW_LORES      =                $C056
AS_SW_HIRES      =                $C057
                                                         ; --------------------------------
                                                         ; MONITOR SUBROUTINES
                                                         ; --------------------------------
;MON_PLOT            = $F800
;MON_HLINE           = $F819
;MON_VLINE           = $F828
;MON_SETCOL          = $F864
;MON_SCRN            = $F871
;MON_PREAD           = $FB1E
;MON_SETTXT          = $FB39
;MON_SETGR           = $FB40
;MON_TABV            = $FB5B
;MON_HOME            = $FC58
;MON_WAIT            = $FCA8
;MON_RD2BIT          = $FCFA
;MS_CQINCH           = $FD0C
;MON_GETLN           = $FD6A
;MON_COUT            = $FDED
;MON_INPORT          = $FE8B
;MON_OUTPORT         = $FE95
;MON_WRITE           = $FECD
;MON_READ            = $FEFD
;MON_READ2           = $FF02
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; APPLESOFT TOKENS
                                                         ; --------------------------------
MS_FORTK         =                $81
MS_DATATK        =                $83
AS_TOKEN_POP     =                $A1
MS_GOTOTK        =                $AB
MS_GOSUTK        =                $B0
MS_REMTK         =                $B2
MS_PRINTK        =                $BA
MS_TABTK         =                $C0
MS_TOTK          =                $C1
MS_FNTK          =                $C2
MS_SPCTK         =                $C3
MS_THENTK        =                $C4
AS_TOKENDB       =                $C5
MS_NOTTK         =                $C6
MS_STEPTK        =                $C7
MS_PLUSTK        =                $C8
MS_MINUTK        =                $C9
MS_GREATK        =                $CF
MS_EQULTK        =                $D0
MS_ONEFUN        =                $D2
AS_TOKEN_SCRN    =                $D7
AS_TOKEN_LEFTSTR =                $E8
                                                         ; --------------------------------
                                                         ; BRANCH TABLE FOR TOKENS
                                                         ; --------------------------------
MS_STMDSP:       .word            MS_END - 1             ; $80...128...END
                 .word            MS_FOR - 1             ; $81...129...FOR
                 .word            MS_NEXT - 1            ; $82...130...NEXT
                 .word            MS_DATA - 1            ; $83...131..DWTA
                 .word            MS_INPUT - 1           ; $84...132...INPUT
                 .word            AS_DEL - 1             ; $85...133...DEL
                 .word            MS_DIM - 1             ; $86...134...DIM
                 .word            MS_READ - 1            ; $87...135...READ
                 .word            AS_GR - 1              ; $88...136...GR
                 .word            AS_TEXT - 1            ; $89...137...TEXT
                 .word            AS_PR_NUMBER - 1       ; $8A...138...PR#
                 .word            AS_IN_NUMBER - 1       ; $8B...139...IN#
                 .word            AS_CALL - 1            ; $8C...140...CALL
                 .word            AS_PLOT - 1            ; $8D...141...PLOT
                 .word            AS_HLIN - 1            ; $8E...142...HLIN
                 .word            AS_VLIN - 1            ; $8F...143...VLIN
                 .word            AS_HGR2 - 1            ; $90...144...HGR2
                 .word            AS_HGR - 1             ; $91...145...HGR
                 .word            AS_HCOLOR - 1          ; $92...146...HCOLOR=
                 .word            AS_HPLOT - 1           ; $93...147...HPLOT
                 .word            AS_DRAW - 1            ; $94...148...DRAW
                 .word            AS_XDRAW - 1           ; $95...149...XDRAW
                 .word            AS_HTAB - 1            ; $96...150...HTAB
                 .word            MON_HOME - 1           ; $97...151...HOME
                 .word            AS_ROT - 1             ; $98...152...ROT=
                 .word            AS_SCALE - 1           ; $99...153...SCALE=
                 .word            AS_SHLOAD - 1          ; $9A...154...SHLOAD
                 .word            AS_TRACE - 1           ; $9B...155...TRACE
                 .word            AS_NOTRACE - 1         ; $9C...156...NOTRACE
                 .word            AS_NORMAL - 1          ; $9D...157...NORMAL
                 .word            AS_INVERSE - 1         ; $9E...158...INVERSE
                 .word            AS_FLASH - 1           ; $9F...159...FLASH
                 .word            AS_COLOR - 1           ; $A0...160...COLOR=
                 .word            MS_RETURN - 1          ; $A1...161...POP
                 .word            AS_VTAB - 1            ; $A2...162...VTAB
                 .word            AS_HIMEM - 1           ; $A3...163...HIMEM:
                 .word            AS_LOMEM - 1           ; $A4...164...LOMEM:
                 .word            AS_ONERR - 1           ; $A5...165...ONERR
                 .word            AS_RESUME - 1          ; $A6...166...RESUME
                 .word            AS_RECALL - 1          ; $A7...167...RECALL
                 .word            AS_STORE - 1           ; $A8...168...STORE
                 .word            AS_SPEED - 1           ; $A9...169...SPEED=
                 .word            MS_LET - 1             ; $AA...170...LET
                 .word            MS_GOTO - 1            ; $AB...171...GOTO
                 .word            MS_RUN - 1             ; $AC...172...RUN
                 .word            MS_IF - 1              ; $AD...173...IF
                 .word            MS_RESTOR - 1          ; $AE...174...RESTORE
                 .word            AS_AMPERSAND_VECTOR - 1 ; $AF...175...&
                 .word            MS_GOSUB - 1           ; $B0...176...GOSUB
                 .word            MS_RETURN - 1          ; $B1...177...RETURN
                 .word            MS_REM - 1             ; $B2...178...REM
                 .word            MS_STOP - 1            ; $B3...179...STOP
                 .word            MS_ONGOTO - 1          ; $B4...180...ON
                 .word            MS_FNWAIT - 1          ; $B5...181...WAIT
                 .word            MS_LOAD - 1            ; $B6...182...LOAD
                 .word            MS_SAVE - 1            ; $B7...183...SAVE
                 .word            MS_DEF - 1             ; $B8...184...DEF
                 .word            MS_POKE - 1            ; $B9...185...POKE
                 .word            MS_PRINT - 1           ; $BA...186...PRINT
                 .word            MS_CONT - 1            ; $BB...187...CONT
                 .word            MS_LIST - 1            ; $BC...188...LIST
                 .word            MS_CLEAR - 1           ; $BD...189...CLEAR
                 .word            MS_GET - 1             ; $BE...190...GET
                 .word            MS_SCRATH - 1          ; $BF...191...NEW
                                                         ; --------------------------------
MS_FUNDSP:       .word            MS_SGN                 ; $D2...210...SGN
                 .word            MS_INT                 ; $D3...211...INT
                 .word            MS_ABS                 ; $D4...212...ABS
                 .word            MS_Z_USRPOK            ; $D5...213...USR
                 .word            MS_FRE                 ; $D6...214...FRE
                 .word            MS_ERROR               ; $D7...215...SCRN(
                 .word            AS_PDL                 ; $D8...216...PDL
                 .word            MS_POS                 ; $D9...217...POS
                 .word            MS_SQR                 ; $DA...218...SQR
                 .word            MS_RND                 ; $DB...219...RND
                 .word            MS_LOG                 ; $DC...220...LOG
                 .word            MS_EXP                 ; $DD...221...EXP
                 .word            MS_COS                 ; $DE...222...COS
                 .word            MS_SIN                 ; $DF...223...SIN
                 .word            MS_TAN                 ; $E0...224...TAN
                 .word            MS_ATN                 ; $E1...225...ATN
                 .word            MS_PEEK                ; $E2...226...PEEK
                 .word            MS_LEN                 ; $E3...227...LEN
                 .word            MS_STR                 ; $E4...228...STR$
                 .word            MS_VAL                 ; $E5...229...VAL
                 .word            MS_ASC                 ; $E6...230...ASC
                 .word            MS_CHR                 ; $E7...231...CHR$
                 .word            MS_LEFT                ; $E8...232...LEFT$
                 .word            MS_RIGHT               ; $E9...233...RIGHT$
                 .word            MS_MID                 ; $EA...234...MID$
                                                         ; --------------------------------
                                                         ; MATH OPERATOR BRANCH TABLE

                                                         ; ONE-BYTE PRECEDENCE CODE
                                                         ; TWO-BYTE ADDRESS
                                                         ; --------------------------------
AS_P_OR          =                $46                    ; "OR" IS LOWEST PRECEDENCE
AS_P_AND         =                $50
AS_P_REL         =                $64                    ; RELATIONAL OPERATORS
AS_P_ADD         =                $79                    ; BINARY + AND -
AS_P_MUL         =                $7B                    ; * AND /
AS_P_PWR         =                $7D                    ; EXPONENTIATION
AS_P_NEQ         =                $7F                    ; UNARY - AND COMPARISON =
                                                         ; --------------------------------
MS_OPTAB             .BYTE AS_P_ADD
                 .word            MS_FADDT - 1           ; $C8...200...+
                    .BYTE AS_P_ADD
                 .word            MS_FSUBT - 1           ; $C9...201...-
                    .BYTE AS_P_MUL
                 .word            MS_FMULTT - 1          ; $CA...202...*
                    .BYTE AS_P_MUL
                 .word            MS_FDIVT - 1           ; $CB...203.../
                    .BYTE AS_P_PWR
                 .word            MS_FPWRT - 1           ; $CC...204...^
                    .BYTE AS_P_AND
                 .word            MS_ANDOP - 1           ; $CD...205...AND
                    .BYTE AS_P_OR
                 .word            MS_OROP - 1            ; $CE...206...OR
MS_NEGTAB               .BYTE AS_P_NEQ
                 .word            MS_NEGOP - 1           ; $CF...207...>
MS_NOTTAB               .BYTE AS_P_NEQ
                 .word            MS_NOTOP - 1           ; $D0...208...=
MS_PTDORL               .BYTE AS_P_REL
                 .word            MS_DOREL - 1           ; $D1...209...<

                                                         ; --------------------------------
                                                         ; TOKEN NAME TABLE
                                                         ; --------------------------------

MS_RESLST    .BYTE ("E"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("D"|%10000000)
                                                         ; $80...128
                    .BYTE ("F"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("R"|%10000000)
                                                         ; $81...129
                    .BYTE ("N"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("X"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $82...130
                    .BYTE ("D"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("A"|%10000000)
                                                         ; $83...131
                    .BYTE ("I"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("P"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $84...132
                    .BYTE ("D"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("L"|%10000000)
                                                         ; $85...133
                    .BYTE ("D"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("M"|%10000000)
                                                         ; $86...134
                    .BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("D"|%10000000)
                                                         ; $87...135
                    .BYTE ("G"&%01111111)
.BYTE ("R"|%10000000)
                                                         ; $88...136
                    .BYTE ("T"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("X"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $89...137
                    .BYTE ("P"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("#"|%10000000)
                                                         ; $8A...138
                    .BYTE ("I"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("#"|%10000000)
                                                         ; $8B...139
                    .BYTE ("C"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("L"|%10000000)
                                                         ; $8C...140
                    .BYTE ("P"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $8D...141
                    .BYTE ("H"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $8E...142
                    .BYTE ("V"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $8F...143
                    .BYTE ("H"&%01111111)
.BYTE ("G"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("2"|%10000000)
                                                         ; $90...144
                    .BYTE ("H"&%01111111)
.BYTE ("G"&%01111111)
.BYTE ("R"|%10000000)
                                                         ; $91...145
                    .BYTE ("H"&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("="|%10000000)
                                                         ; $92...146
                    .BYTE ("H"&%01111111)
.BYTE ("P"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $93...147
                    .BYTE ("D"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("W"|%10000000)
                                                         ; $94...148
                    .BYTE ("X"&%01111111)
.BYTE ("D"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("W"|%10000000)
                                                         ; $95...149
                    .BYTE ("H"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("B"|%10000000)
                                                         ; $96...150
                    .BYTE ("H"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("E"|%10000000)
                                                         ; $97...151
                    .BYTE ("R"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("="|%10000000)
                                                         ; $98...152
                    .BYTE ("S"&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("="|%10000000)
                                                         ; $99...153
                    .BYTE ("S"&%01111111)
.BYTE ("H"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("D"|%10000000)
                                                         ; $9A...154
                    .BYTE ("T"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("E"|%10000000)
                                                         ; $9B...155
                    .BYTE ("N"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("E"|%10000000)
                                                         ; $9C...156
                    .BYTE ("N"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("L"|%10000000)
                                                         ; $9D...157
                    .BYTE ("I"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("V"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("E"|%10000000)
                                                         ; $9E...158
                    .BYTE ("F"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("H"|%10000000)
                                                         ; $9F...159
                    .BYTE ("C"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("="|%10000000)
                                                         ; $A0...160
                    .BYTE ("P"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("P"|%10000000)
                                                         ; $A1...161
                    .BYTE ("V"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("B"|%10000000)
                                                         ; $A2...162
                    .BYTE ("H"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("M"&%01111111)
.BYTE (":"|%10000000)
                                                         ; $A3...163
                    .BYTE ("L"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("M"&%01111111)
.BYTE (":"|%10000000)
                                                         ; $A4...164
                    .BYTE ("O"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("R"|%10000000)
                                                         ; $A5...165
                    .BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("E"|%10000000)
                                                         ; $A6...166
                    .BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("L"|%10000000)
                                                         ; $A7...167
                    .BYTE ("S"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("E"|%10000000)
                                                         ; $A8...168
                    .BYTE ("S"&%01111111)
.BYTE ("P"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("D"&%01111111)
.BYTE ("="|%10000000)
                                                         ; $A9...169
                    .BYTE ("L"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $AA...170
                    .BYTE ("G"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("O"|%10000000)
                                                         ; $AB...171
                    .BYTE ("R"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $AC...172
                    .BYTE ("I"&%01111111)
.BYTE ("F"|%10000000)
                                                         ; $AD...173
                    .BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("E"|%10000000)
                                                         ; $AE...174
                    .BYTE ("&"|%10000000)
                                                         ; $AF...175
                    .BYTE ("G"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("B"|%10000000)
                                                         ; $B0...176
                    .BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $B1...177
                    .BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("M"|%10000000)
                                                         ; $B2...178
                    .BYTE ("S"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("P"|%10000000)
                                                         ; $B3...179
                    .BYTE ("O"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $B4...180
                    .BYTE ("W"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $B5...181
                    .BYTE ("L"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("D"|%10000000)
                                                         ; $B6...182
                    .BYTE ("S"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("V"&%01111111)
.BYTE ("E"|%10000000)
                                                         ; $B7...183
                    .BYTE ("D"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("F"|%10000000)
                                                         ; $B8...184
                    .BYTE ("P"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("K"&%01111111)
.BYTE ("E"|%10000000)
                                                         ; $B9...185
                    .BYTE ("P"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $BA...186
                    .BYTE ("C"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $BB...187
                    .BYTE ("L"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $BC...188
                    .BYTE ("C"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("R"|%10000000)
                                                         ; $BD...189
                    .BYTE ("G"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $BE...190
                    .BYTE ("N"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("W"|%10000000)
                                                         ; $BF...191
.BYTE ("T"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("B"&%01111111)
                                                         ; $C0...192
.BYTE $A8
                    .BYTE ("T"&%01111111)
.BYTE ("O"|%10000000)
                                                         ; $C1...193
                    .BYTE ("F"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $C2...194
.BYTE ("S"&%01111111)
.BYTE ("P"&%01111111)
.BYTE ("C"&%01111111)
                                                         ; $C3...195
.BYTE $A8
                    .BYTE ("T"&%01111111)
.BYTE ("H"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $C4...196
                    .BYTE ("A"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $C5...197
                    .BYTE ("N"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $C6...198
                    .BYTE ("S"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("P"|%10000000)
                                                         ; $C7...199
                    .BYTE ("+"|%10000000)
                                                         ; $C8...200
                    .BYTE ("-"|%10000000)
                                                         ; $C9...201
                    .BYTE ("*"|%10000000)
                                                         ; $CA...202
                    .BYTE ("/"|%10000000)
                                                         ; $CB...203
.BYTE $DE
;                    LHASCII(`^')                     ; $CC...204
                    .BYTE ("A"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("D"|%10000000)
                                                         ; $CD...205
                    .BYTE ("O"&%01111111)
.BYTE ("R"|%10000000)
                                                         ; $CE...206
                    .BYTE (">"|%10000000)
                                                         ; $CF...207
                    .BYTE ("="|%10000000)
                                                         ; $D0...208
                    .BYTE ("<"|%10000000)
                                                         ; $D1...209
                    .BYTE ("S"&%01111111)
.BYTE ("G"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $D2...210
                    .BYTE ("I"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("T"|%10000000)
                                                         ; $D3...211
                    .BYTE ("A"&%01111111)
.BYTE ("B"&%01111111)
.BYTE ("S"|%10000000)
                                                         ; $D4...212
                    .BYTE ("U"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("R"|%10000000)
                                                         ; $D5...213
                    .BYTE ("F"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("E"|%10000000)
                                                         ; $D6...214
.BYTE ("S"&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("N"&%01111111)
                                                         ; $D7...215
.BYTE $A8
                    .BYTE ("P"&%01111111)
.BYTE ("D"&%01111111)
.BYTE ("L"|%10000000)
                                                         ; $D8...216
                    .BYTE ("P"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("S"|%10000000)
                                                         ; $D9...217
                    .BYTE ("S"&%01111111)
.BYTE ("Q"&%01111111)
.BYTE ("R"|%10000000)
                                                         ; $DA...218
                    .BYTE ("R"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("D"|%10000000)
                                                         ; $DB...219
                    .BYTE ("L"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("G"|%10000000)
                                                         ; $DC...220
                    .BYTE ("E"&%01111111)
.BYTE ("X"&%01111111)
.BYTE ("P"|%10000000)
                                                         ; $DD...221
                    .BYTE ("C"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("S"|%10000000)
                                                         ; $DE...222
                    .BYTE ("S"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $DF...223
                    .BYTE ("T"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $E0...224
                    .BYTE ("A"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $E1...225
                    .BYTE ("P"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("K"|%10000000)
                                                         ; $E2...226
                    .BYTE ("L"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("N"|%10000000)
                                                         ; $E3...227
                    .BYTE ("S"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("$"|%10000000)
                                                         ; $E4...228
                    .BYTE ("V"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("L"|%10000000)
                                                         ; $E5...229
                    .BYTE ("A"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("C"|%10000000)
                                                         ; $E6...230
                    .BYTE ("C"&%01111111)
.BYTE ("H"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("$"|%10000000)
                                                         ; $E7...231
                    .BYTE ("L"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("F"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("$"|%10000000)
                                                         ; $E8...232
                    .BYTE ("R"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("G"&%01111111)
.BYTE ("H"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("$"|%10000000)
                                                         ; $E9...233
                    .BYTE ("M"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("D"&%01111111)
.BYTE ("$"|%10000000)
                                                         ; $EA...234

                    .BYTE 0                         ; END OF TOKEN NAME TABLE
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; ERROR MESSAGES
                                                         ; --------------------------------
MS_ERRTAB:
MS_ERRNF         =                * - MS_ERRTAB
                    .BYTE ("N"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("X"&%01111111)
.BYTE ("T"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("W"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("H"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("T"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("F"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("R"|%10000000)

MS_ERRSN         =                * - MS_ERRTAB
                    .BYTE ("S"&%01111111)
.BYTE ("Y"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("X"|%10000000)

MS_ERRRG         =                * - MS_ERRTAB
                    .BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("N"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("W"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("H"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("T"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("G"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("B"|%10000000)

MS_ERROD         =                * - MS_ERRTAB
                    .BYTE ("O"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("T"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("F"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("D"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("A"|%10000000)

MS_ERRFC         =                * - MS_ERRTAB
                    .BYTE ("I"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("G"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("L"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("Q"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("Y"|%10000000)

MS_ERROV         =                * - MS_ERRTAB
                    .BYTE ("O"&%01111111)
.BYTE ("V"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("F"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("W"|%10000000)

MS_ERROM         =                * - MS_ERRTAB
                    .BYTE ("O"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("T"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("F"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("Y"|%10000000)

MS_ERRUS         =                * - MS_ERRTAB
.BYTE ("U"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("D"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("F"&%01111111)

.BYTE $27
                    .BYTE ("D"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("T"|%10000000)

MS_ERRBS         =                * - MS_ERRTAB
                    .BYTE ("B"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("D"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("B"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("P"&%01111111)
.BYTE ("T"|%10000000)

MS_ERRDD         =                * - MS_ERRTAB
.BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("D"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("M"&%01111111)

.BYTE $27
                    .BYTE ("D"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("Y"|%10000000)

MS_ERRDV0        =                * - MS_ERRTAB
                    .BYTE ("D"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("V"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("N"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("B"&%01111111)
.BYTE ("Y"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("Z"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("O"|%10000000)

MS_ERRID         =                * - MS_ERRTAB
                    .BYTE ("I"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("G"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("L"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("D"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("T"|%10000000)

MS_ERRTM         =                * - MS_ERRTAB
                    .BYTE ("T"&%01111111)
.BYTE ("Y"&%01111111)
.BYTE ("P"&%01111111)
.BYTE ("E"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("S"&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("H"|%10000000)

MS_ERRLS         =                * - MS_ERRTAB
                    .BYTE ("S"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("G"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("O"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("G"|%10000000)

MS_ERRST         =                * - MS_ERRTAB
                    .BYTE ("F"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("A"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("O"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("M"&%01111111)
.BYTE ("P"&%01111111)
.BYTE ("L"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("X"|%10000000)

MS_ERRCN         =                * - MS_ERRTAB
.BYTE ("C"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("N"&%01111111)

.BYTE $27
                    .BYTE ("T"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("E"|%10000000)

MS_ERRUF         =                * - MS_ERRTAB
.BYTE ("U"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("D"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("F"&%01111111)

.BYTE $27
                    .BYTE ("D"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("F"&%01111111)
.BYTE ("U"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("C"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("N"|%10000000)

                                                         ; --------------------------------

MS_ERR            .BYTE (" "&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("R"&%01111111)

                    .BYTE $07,0

MS_INTXT               .BYTE (" "&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("N"&%01111111)
.BYTE (" "&%01111111)

                    .BYTE 0

MS_BRKTXT            .BYTE $0D
                    .BYTE ("B"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("A"&%01111111)
.BYTE ("K"&%01111111)

                    .BYTE $07,0
                                                         ; --------------------------------
                                                         ; CALLED BY "NEXT" AND "FOR" TO SCAN THROUGH
                                                         ; THE STACK FOR A FRAME WITH THE SAME VARIABLE.

                                                         ; (FORPNT) = ADDRESS OF VARIABLE IF "FOR" OR "NEXT"
                                                         ; = $XXFF IF CALLED FROM "RETURN"
                                                         ; <<< BUG: SHOULD BE $FFXX >>>

                                                         ; RETURNS .NE. IF VARIABLE NOT FOUND,
                                                         ; (X) = STACK PNTR AFTER SKIPPING ALL FRAMES

                                                         ; EQU. IF FOUND
                                                         ; (X) = STACK PNTR OF FRAME FOUND
                                                         ; --------------------------------
MS_FNDFOR:
                 TSX
                 INX
                 INX
                 INX
                 INX
MS_FFLOOP:       LDA              AS_STACK + 1,X         ; "FOR" FRAME HERE?
                 CMP              #MS_FORTK
                 BNE              MS_FFRTS               ; NO
                 LDA              MS_Z_FORPNT + 1        ; YES -- "NEXT" WITH NO VARIABLE?
                 BNE              MS_CMPFOR              ; NO, VARIABLE SPECIFIED
                 LDA              AS_STACK + 2,X         ; YES, SO USE THIS FRAME
                 STA              MS_Z_FORPNT
                 LDA              AS_STACK + 3,X
                 STA              MS_Z_FORPNT + 1
MS_CMPFOR:       CMP              AS_STACK + 3,X         ; IS VARIABLE IN THIS FRAME?
                 BNE              MS_ADDFRS              ; NO
                 LDA              MS_Z_FORPNT            ; LOOK AT 2ND BYTE TOO
                 CMP              AS_STACK + 2,X         ; SAME VARIABLE?
                 BEQ              MS_FFRTS               ; YES
MS_ADDFRS:        TXA                    ; NO, SO TRY NEXT FRAME (IF ANY)
                 CLC                                     ; 18 BYTES PER FRAME
                 ADC              #18
                 TAX
                 BNE              MS_FFLOOP              ; ...ALWAYS?
MS_FFRTS:         RTS
                                                         ; --------------------------------
                                                         ; MOVE BLOCK OF MEMORY UP

                                                         ; ON ENTRY:
                                                         ; (Y,A) = (HIGHDS) = DESTINATION END+1
                                                         ; (LOWTR) = LOWEST ADDRESS OF SOURCE
                                                         ; (HIGHTR) = HIGHEST SOURCE ADDRESS+1
                                                         ; --------------------------------
MS_BLTU:         JSR              MS_REASON              ; BE SURE (Y,A) < FRETOP
                 STA              MS_Z_STREND            ; NEW TOP OF ARRAY STORAGE
                 STY              MS_Z_STREND + 1
MS_BLTUC:         SEC
                 LDA              MS_Z_HIGHTR            ; COMPUTE # OF BYTES TO BE MOVED
                 SBC              MS_Z_LOWTR             ; (FROM LOWTR THRU HIGHTR-1)
                 STA              MS_Z_INDEX             ; PARTIAL PAGE AMOUNT
                 TAY
                 LDA              MS_Z_HIGHTR + 1
                 SBC              MS_Z_LOWTR + 1
                 TAX                                     ; # OF WHOLE PAGES IN X-REG
                 INX
                 TYA                                     ; # BYTES IN PARTIAL PAGE
                 BEQ              MS_DECBLT              ; NO PARTIAL PAGE
                 LDA              MS_Z_HIGHTR            ; BACK UP HIGHTR # BYTES IN PARTIAL PAGE
                 SEC
                 SBC              MS_Z_INDEX
                 STA              MS_Z_HIGHTR
                 BCS              MS_BLT1
                 DEC              MS_Z_HIGHTR + 1
                 SEC
MS_BLT1:         LDA              MS_Z_HIGHDS            ; BACK UP HIGHDS # BYTES IN PARTIAL PAGE
                 SBC              MS_Z_INDEX
                 STA              MS_Z_HIGHDS
                 BCS              MS_MOREN1
                 DEC              MS_Z_HIGHDS + 1
                 BCC              MS_MOREN1              ; ...ALWAYS
MS_BLTLP:        LDA              (MS_Z_HIGHTR),Y        ; MOVE THE BYTES
                 STA              (MS_Z_HIGHDS),Y
MS_MOREN1:        DEY
                 BNE              MS_BLTLP               ; LOOP TO END OF THIS 256 BYTES
                 LDA              (MS_Z_HIGHTR),Y        ; MOVE ONE MORE BYTE
                 STA              (MS_Z_HIGHDS),Y
MS_DECBLT:       DEC              MS_Z_HIGHTR + 1        ; DOWN TO NEXT BLOCK OF 256
                 DEC              MS_Z_HIGHDS + 1
                 DEX                                     ; ANOTHER BLOCK OF 256 TO MOVE?
                 BNE              MS_MOREN1              ; YES
                 RTS                                     ; NO, FINISHED
                                                         ; --------------------------------
                                                         ; CHECK IF ENOUGH ROOM LEFT ON STACK
                                                         ; FOR "FOR", "GOSUB", OR EXPRESSION EVALUATION
                                                         ; --------------------------------
MS_GETSTK:        ASL
                 ADC              #54
                 BCS              MS_OMERR               ; ...MEM FULL ERR
                 STA              MS_Z_INDEX
                 TSX
                 CPX              MS_Z_INDEX
                 BCC              MS_OMERR               ; ...MEM FULL ERR
                 RTS
                                                         ; --------------------------------
                                                         ; CHECK IF ENOUGH ROOM BETWEEN ARRAYS AND STRINGS
                                                         ; (Y,A) = ADDR ARRAYS NEED TO GROW TO
                                                         ; --------------------------------
MS_REASON:       CPY              MS_Z_FRETOP + 1        ; HIGH BYTE
                 BCC              MS_REARTS              ; PLENTY OF ROOM
                 BNE              MS_TRYMOR              ; NOT ENOUGH, TRY GARBAGE COLLECTION
                 CMP              MS_Z_FRETOP            ; LOW BYTE
                 BCC              MS_REARTS              ; ENOUGH ROOM
                                                         ; --------------------------------
MS_TRYMOR:        PHA                    ; SAVE (Y,A), TEMP1, AND TEMP2
                 LDX              #MS_Z_FAC - MS_Z_TEMPF1 - 1
                 TYA
MS_REASAV:        PHA
                 LDA              MS_Z_TEMPF1,X
                 DEX
                 BPL              MS_REASAV
                 JSR              MS_GARBA2              ; MAKE AS MUCH ROOM AS POSSIBLE
                 LDX              #MS_Z_TEMPF1 + 256 - MS_Z_FAC + 1 ; RESTORE TEMP1 AND TEMP2
MS_REASTO:        PLA                    ; AND (Y,A)
                 STA              MS_Z_FAC,X
                 INX
                 BMI              MS_REASTO
                 PLA
                 TAY
                 PLA                                     ; DID WE FIND ENOUGH ROOM?
                 CPY              MS_Z_FRETOP + 1        ; HIGH BYTE
                 BCC              MS_REARTS              ; YES, AT LEAST A PAGE
                 BNE              MS_OMERR               ; NO, MEM FULL ERR
                 CMP              MS_Z_FRETOP            ; LOW BYTE
                 BCS              MS_OMERR               ; NO, MEM FULL ERR
MS_REARTS:        RTS                    ; YES, RETURN
                                                         ; --------------------------------
MS_OMERR:        LDX              #MS_ERROM
                                                         ; --------------------------------
                                                         ; HANDLE AN ERROR

                                                         ; (X)=OFFSET IN ERROR MESSAGE TABLE
                                                         ; (ERRFLG) > 128 IF "ON ERR" TURNED ON
                                                         ; (CURLIN+1) = $FF IF IN DIRECT MODE
                                                         ; --------------------------------
MS_ERROR:        BIT              AS_ERRFLG              ; "ON ERR" TURNED ON?
                 BPL              MS_ERRCRD              ; NO
                 JMP              AS_HANDLERR            ; YES
MS_ERRCRD:       JSR              MS_CRDO                ; PRINT <RETURN>
                 JSR              MS_OUTQST              ; PRINT "?"
MS_GETERR:       LDA              MS_ERRTAB,X
                 PHA                                     ; PRINT MESSAGE
                 JSR              MS_OUTDO
                 INX
                 PLA
                 BPL              MS_GETERR
                 JSR              MS_STKINI              ; FIX STACK, ET AL
                 LDA              #<MS_ERR               ; PRINT " ERROR" AND BELL
                 LDY              #>MS_ERR
                                                         ; --------------------------------
                                                         ; PRINT STRING AT (Y,A)
                                                         ; PRINT CURRENT LINE # UNLESS IN DIRECT MODE
                                                         ; FALL INTO WARM RESTART
                                                         ; --------------------------------
MS_ERRFIN:
                 JSR              AS_STROUT              ; PRINT STRING AT (Y,A)
                 LDY              MS_Z_CURLIN + 1        ; RUNNING, OR DIRECT?
                 INY
                 BEQ              MS_MAIN                ; WAS $FF, SO DIRECT MODE
                 JSR              MS_INPRT               ; RUNNING, SO PRINT LINE NUMBER
                                                         ; --------------------------------
                                                         ; WARM RESTART ENTRY

                                                         ; COME HERE FROM MONITOR BY CTL-C, 0G, 3D0G, OR E003G
                                                         ; --------------------------------
MS_MAIN:
                 JSR              MS_CRDO                ; PRINT <RETURN>
                 LDX              #"]" | %10000000       ; PROMPT CHARACTER
                 JSR              MS_INLIN2              ; READ A LINE
                 STX              MS_Z_TXTPTR            ; SET UP CHRGET TO SCAN THE LINE
                 STY              MS_Z_TXTPTR + 1
                 LSR              AS_ERRFLG              ; CLEAR FLAG
                 JSR              MS_Z_CHRGET
                 TAX
                 BEQ              MS_MAIN                ; EMPTY LINE
                 LDX              #$FF                   ; $FF IN HI-BYTE OF CURLIN MEANS
                 STX              MS_Z_CURLIN + 1        ; WE ARE IN DIRECT MODE
                 BCC              MS_MAIN1               ; CHRGET SAW DIGIT, NUMBERED LINE
                 JSR              MS_CRUNCH              ; NO NUMBER, SO PARSE IT
                 JMP              AS_TRACE_              ; AND TRY EXECUTING IT
                                                         ; --------------------------------
                                                         ; HANDLE NUMBERED LINE
                                                         ; --------------------------------
MS_MAIN1:
                 LDX              AS_PRGEND              ; SQUASH VARIABLE TABLE
                 STX              MS_Z_VARTAB
                 LDX              AS_PRGEND + 1
                 STX              MS_Z_VARTAB + 1
                 JSR              MS_LINGET              ; GET LINE #
                 JSR              MS_CRUNCH              ; AND PARSE THE INPUT LINE
                 STY              AS_EOL_PNTR            ; SAVE INDEX TO INPUT BUFFER
                 JSR              MS_FNDLIN              ; IS THIS LINE # ALREADY IN PROGRAM?
                 BCC              MS_NODEL               ; NO
                 LDY              #1                     ; YES, SO DELETE IT
                 LDA              (MS_Z_LOWTR),Y         ; LOWTR POINTS AT LINE
                 STA              MS_Z_INDEX + 1         ; GET HIGH BYTE OF FORWARD PNTR
                 LDA              MS_Z_VARTAB
                 STA              MS_Z_INDEX
                 LDA              MS_Z_LOWTR + 1
                 STA              AS_DEST + 1
                 LDA              MS_Z_LOWTR
                 DEY
                 SBC              (MS_Z_LOWTR),Y
                 CLC
                 ADC              MS_Z_VARTAB
                 STA              MS_Z_VARTAB
                 STA              AS_DEST
                 LDA              MS_Z_VARTAB + 1
                 ADC              #$FF
                 STA              MS_Z_VARTAB + 1
                 SBC              MS_Z_LOWTR + 1
                 TAX
                 SEC
                 LDA              MS_Z_LOWTR
                 SBC              MS_Z_VARTAB
                 TAY
                 BCS              MS_QDECT1
                 INX
                 DEC              AS_DEST + 1
MS_QDECT1:        CLC
                 ADC              MS_Z_INDEX
                 BCC              MS_MLOOP
                 DEC              MS_Z_INDEX + 1
                 CLC
                                                         ; --------------------------------
MS_MLOOP:        LDA              (MS_Z_INDEX),Y         ; MOVE HIGHER LINES OF PROGRAM
                 STA              (AS_DEST),Y            ; DOWN OVER THE DELETED LINE.
                 INY
                 BNE              MS_MLOOP
                 INC              MS_Z_INDEX + 1
                 INC              AS_DEST + 1
                 DEX
                 BNE              MS_MLOOP
                                                         ; --------------------------------
MS_NODEL:
                 LDA              MS_A_BUFOFS            ; ANY CHARACTERS AFTER LINE #?
                 BEQ              MS_FINI                ; NO, SO NOTHING TO INSERT.
                 LDA              MS_Z_MEMSIZ            ; YES, SO MAKE ROOM AND INSERT LINE
                 LDY              MS_Z_MEMSIZ + 1        ; WIPE STRING AREA CLEAN
                 STA              MS_Z_FRETOP
                 STY              MS_Z_FRETOP + 1
                 LDA              MS_Z_VARTAB            ; SET UP BLTU SUBROUTINE
                 STA              MS_Z_HIGHTR            ; INSERT NEW LINE.
                 ADC              AS_EOL_PNTR
                 STA              MS_Z_HIGHDS
                 LDY              MS_Z_VARTAB + 1
                 STY              MS_Z_HIGHTR + 1
                 BCC              MS_NODELC
                 INY
MS_NODELC:       STY              MS_Z_HIGHDS + 1
                 JSR              MS_BLTU                ; MAKE ROOM FOR THE LINE
                 LDA              MS_Z_LINNUM            ; PUT LINE NUMBER IN LINE IMAGE
                 LDY              MS_Z_LINNUM + 1
                 STA              MS_A_BUFOFS - 2
                 STY              MS_A_BUFOFS - 1
                 LDA              MS_Z_STREND
                 LDY              MS_Z_STREND + 1
                 STA              MS_Z_VARTAB
                 STY              MS_Z_VARTAB + 1
                 LDY              AS_EOL_PNTR
                                                         ; ---COPY LINE INTO PROGRAM-------
MS_STOLOP:       LDA              MS_A_BUFOFS - 5,Y
                 DEY
                 STA              (MS_Z_LOWTR),Y
                 BNE              MS_STOLOP
                                                         ; --------------------------------
                                                         ; CLEAR ALL VARIABLES
                                                         ; RE-ESTABLISH ALL FORWARD LINKS
                                                         ; --------------------------------
MS_FINI:
                 JSR              MS_RUNC                ; CLEAR ALL VARIABLES
                 LDA              MS_Z_TXTTAB            ; POINT INDEX AT START OF PROGRAM
                 LDY              MS_Z_TXTTAB + 1
                 STA              MS_Z_INDEX
                 STY              MS_Z_INDEX + 1
                 CLC
MS_CHEAD:        LDY              #1                     ; HI-BYTE OF NEXT FORWARD PNTR
                 LDA              (MS_Z_INDEX),Y         ; END OF PROGRAM YET?
                 BNE              AS_L_FIX_LINKS_2       ; NO, KEEP GOING
                 LDA              MS_Z_VARTAB            ; YES
                 STA              AS_PRGEND
                 LDA              MS_Z_VARTAB + 1
                 STA              AS_PRGEND + 1
                 JMP              MS_MAIN
AS_L_FIX_LINKS_2: LDY              #4                     ; FIND END OF THIS LINE
MS_CZLOOP:        INY                    ; (NOTE MAXIMUM LENGTH < 256)
                 LDA              (MS_Z_INDEX),Y
                 BNE              MS_CZLOOP
                 INY                                     ; COMPUTE ADDRESS OF NEXT LINE
                 TYA
                 ADC              MS_Z_INDEX
                 TAX
                 LDY              #0                     ; STORE FORWARD PNTR IN THIS LINE
                 STA              (MS_Z_INDEX),Y
                 LDA              MS_Z_INDEX + 1
                 ADC              #0                     ; (NOTE: THIS CLEARS CARRY)
                 INY
                 STA              (MS_Z_INDEX),Y
                 STX              MS_Z_INDEX
                 STA              MS_Z_INDEX + 1
                 BCC              MS_CHEAD               ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; READ A LINE, AND STRIP OFF SIGN BITS
                                                         ; --------------------------------
MS_INLIN:        LDX              #$80                   ; NULL PROMPT
MS_INLIN2:       STX              MON_PROMPT
                 JSR              MON_GETLN
                 CPX              #239                   ; MAXIMUM LINE LENGTH
                 BCC              MS_GDBUFS
                 LDX              #239                   ; TRUNCATE AT 239 CHARS
MS_GDBUFS:       LDA              #0                     ; MARK END OF LINE WITH $00 BYTE
                 STA              MS_A_BUFOFS,X
                 TXA
                 BEQ              MS_NOCHR               ; NULL INPUT LINE
MS_LOPBHT:       LDA              MS_A_BUFOFS - 1,X      ; DROP SIGN BITS
                 AND              #$7F
                 STA              MS_A_BUFOFS - 1,X
                 DEX
                 BNE              MS_LOPBHT
MS_NOCHR:        LDA              #0                     ; (Y,X) POINTS AT BUFFER-1
                 LDX              #<(MS_A_BUFOFS - 1)
                 LDY              #>(MS_A_BUFOFS - 1)
                 RTS
                                                         ; --------------------------------
MS_INCHR:        JSR              MS_CQINCH              ; *** OUGHT TO BE "BIT $C010" ***
                 AND              #$7F
                 RTS
                                                         ; --------------------------------
                                                         ; TOKENIZE THE INPUT LINE
                                                         ; --------------------------------
MS_CRUNCH:
                 LDX              MS_Z_TXTPTR            ; INDEX INTO UNPARSED LINE
                 DEX                                     ; PREPARE FOR INX AT "PARSE"
                 LDY              #4                     ; INDEX TO PARSED OUTPUT LINE
                 STY              MS_Z_DORES             ; CLEAR SIGN-BIT OF DATAFLG
                 BIT              AS_LOCK                ; IS THIS PROGRAM LOCKED?
                 BPL              AS_PARSE               ; NO, GO AHEAD AND PARSE THE LINE
                 PLA                                     ; YES, IGNORE INPUT AND "RUN"
                 PLA                                     ; THE PROGRAM
                 JSR              MS_RUNC                ; CLEAR ALL VARIABLES
                 JMP              AS_NEWSTT              ; START RUNNING
                                                         ; --------------------------------
AS_PARSE:         INX                    ; NEXT INPUT CHARACTER
AS_L_PARSE_1:    LDA              MS_A_BUFOFS,X
                 BIT              MS_Z_DORES             ; IN A "DATA" STATEMENT?
                 BVS              AS_L_PARSE_2           ; YES (DATAFLG = $49)
                 CMP              #" " & %01111111       ; IGNORE BLANKS
                 BEQ              AS_PARSE
AS_L_PARSE_2:    STA              MS_Z_ENDCHR
                 CMP              #$22                   ; START OF QUOTATION?
                 BEQ              MS_STRNG
                 BVS              MS_STUFFH              ; BRANCH IF IN "DATA" STATEMENT
                 CMP              #"?" & %01111111       ; SHORTHAND FOR "PRINT"?
                 BNE              MS_KLOOP1              ; NO
                 LDA              #MS_PRINTK             ; YES, REPLACE WITH "PRINT" TOKEN
                 BNE              MS_STUFFH              ; ...ALWAYS
MS_KLOOP1:       CMP              #"0" & %01111111       ; IS IT A DIGIT, COLON, OR SEMI-COLON?
                 BCC              MS_MUSTCR              ; NO, PUNCTUATION !"#$%&'()*+,-./
                    CMP #(";"&%01111111)+1
                 BCC              MS_STUFFH              ; YES, NOT A TOKEN
                                                         ; --------------------------------
                                                         ; SEARCH TOKEN NAME TABLE FOR MATCH STARTING
                                                         ; WITH CURRENT CHAR FROM INPUT LINE
                                                         ; --------------------------------
MS_MUSTCR:       STY              MS_Z_STRNG2            ; SAVE INDEX TO OUTPUT LINE
                 LDA              #<(MS_RESLST - $100)
                 STA              MS_Z_FAC               ; MAKE PNTR FOR SEARCH
                 LDA              #>(MS_RESLST - $100)
                 STA              MS_Z_FAC + 1
                 LDY              #0                     ; USE Y-REG WITH (FAC) TO ADDRESS TABLE
                 STY              MS_Z_COUNT             ; HOLDS CURRENT TOKEN-$80
                 DEY                                     ; PREPARE FOR "INY" A FEW LINES DOWN
                 STX              MS_Z_TXTPTR            ; SAVE POSITION IN INPUT LINE
                 DEX                                     ; PREPARE FOR "INX" A FEW LINES DOWN
MS_RESER:         INY                    ; ADVANCE POINTER TO TOKEN TABLE
                 BNE              AS_L_PARSE_6           ; Y=Y+1 IS ENOUGH
                 INC              MS_Z_FAC + 1           ; ALSO NEED TO BUMP THE PAGE
AS_L_PARSE_6:     INX                    ; ADVANCE POINTER TO INPUT LINE
MS_A_RESCON:     LDA              MS_A_BUFOFS,X          ; NEXT CHAR FROM INPUT LINE
                 CMP              #" " & %01111111       ; THIS CHAR A BLANK?
                 BEQ              AS_L_PARSE_6           ; YES, IGNORE ALL BLANKS
                 SEC                                     ; NO, COMPARE TO CHAR IN TABLE
                 SBC              (MS_Z_FAC),Y           ; SAME AS NEXT CHAR OF TOKEN NAME?
                 BEQ              MS_RESER               ; YES, CONTINUE MATCHING
                 CMP              #$80                   ; MAYBE; WAS IT SAME EXCEPT FOR BIT 7?
                 BNE              MS_NTHIS               ; NO, SKIP TO NEXT TOKEN
                 ORA              MS_Z_COUNT             ; YES, END OF TOKEN; GET TOKEN #
                 CMP              #AS_TOKENDB            ; DID WE MATCH "AT"?
                 BNE              MS_GETBPT              ; NO, SO NO AMBIGUITY
                 LDA              MS_A_BUFOFS + 1,X      ; "AT" COULD BE "ATN" OR "A TO"
                 CMP              #"N" & %01111111       ; "ATN" HAS PRECEDENCE OVER "AT"
                 BEQ              MS_NTHIS               ; IT IS "ATN", FIND IT THE HARD WAY
                 CMP              #"O" & %01111111       ; "TO" HAS PRECEDENCE OVER "AT"
                 BEQ              MS_NTHIS               ; IT IS "A TO", FIN IT THE HARD WAY
                 LDA              #AS_TOKENDB            ; NOT "ATN" OR "A TO", SO USE "AT"
                                                         ; --------------------------------
                                                         ; STORE CHARACTER OR TOKEN IN OUTPUT LINE
                                                         ; --------------------------------
MS_GETBPT:       LDY              MS_Z_STRNG2            ; GET INDEX TO OUTPUT LINE IN Y-REG
MS_STUFFH:        INX                    ; ADVANCE INPUT INDEX
                 INY                                     ; ADVANCE OUTPUT INDEX
                 STA              MS_A_BUFOFS - 5,Y      ; STORE CHAR OR TOKEN
                 LDA              MS_A_BUFOFS - 5,Y      ; TEST FOR EOL OR EOS
                 BEQ              MS_CRDONE              ; END OF LINE
                 SEC
                 SBC              #":" & %01111111       ; END OF STATEMENT?
                 BEQ              MS_COLIS               ; YES, CLEAR DATAFLG
                 CMP              #MS_DATATK + 128 - $BA ; "DATA" TOKEN?
                 BNE              MS_NODATT              ; NO, LEAVE DATAFLG ALONE
MS_COLIS:        STA              MS_Z_DORES             ; DATAFLG = 0 OR $83-$3A = $49
MS_NODATT:        SEC                    ; IS IT A "REM" TOKEN?
                 SBC              #MS_REMTK + 128 - $BA
                 BNE              AS_L_PARSE_1           ; NO, CONTINUE PARSING LINE
                 STA              MS_Z_ENDCHR            ; YES, CLEAR LITERAL FLAG
                                                         ; --------------------------------
                                                         ; HANDLE LITERAL (BETWEEN QUOTES) OR REMARK,
                                                         ; BY COPYING CHARS UP TO ENDCHR.
                                                         ; --------------------------------
AS_L_PARSE_12:   LDA              MS_A_BUFOFS,X
                 BEQ              MS_STUFFH              ; END OF LINE
                 CMP              MS_Z_ENDCHR
                 BEQ              MS_STUFFH              ; FOUND ENDCHR
MS_STRNG:         INY                    ; NEXT OUTPUT CHAR
                 STA              MS_A_BUFOFS - 5,Y
                 INX                                     ; NEXT INPUT CHAR
                 BNE              AS_L_PARSE_12          ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; ADVANCE POINTER TO NEXT TOKEN NAME
                                                         ; --------------------------------
MS_NTHIS:        LDX              MS_Z_TXTPTR            ; GET POINTER TO INPUT LINE IN X-REG
                 INC              MS_Z_COUNT             ; BUMP (TOKEN # - $80)
AS_L_PARSE_15:   LDA              (MS_Z_FAC),Y           ; SCAN THROUGH TABLE FOR BIT7 = 1
                 INY                                     ; NEXT TOKEN ONE BEYOND THAT
                 BNE              AS_L_PARSE_16          ; ...USUALLY ENOUGH TO BUMP Y-REG
                 INC              MS_Z_FAC + 1           ; NEXT SET OF 256 TOKEN CHARS
AS_L_PARSE_16:    ASL                    ; SEE IF SIGN BIT SET ON CHAR
                 BCC              AS_L_PARSE_15          ; NO, MORE IN THIS NAME
                 LDA              (MS_Z_FAC),Y           ; YES, AT NEXT NAME.  END OF TABLE?
                 BNE              MS_A_RESCON            ; NO, NOT END OF TABLE
                 LDA              MS_A_BUFOFS,X          ; YES, SO NOT A KEYWORD
                 BPL              MS_GETBPT              ; ...ALWAYS, COPY CHAR AS IS
                                                         ; ---END OF LINE------------------
MS_CRDONE:       STA              MS_A_BUFOFS - 3,Y      ; STORE ANOTHER 00 ON END
                 DEC              MS_Z_TXTPTR + 1        ; SET TXTPTR = INPUT.BUFFER-1
                 LDA              #<(MS_A_BUFOFS - 1)
                 STA              MS_Z_TXTPTR
                 RTS
                                                         ; --------------------------------
                                                         ; SEARCH FOR LINE

                                                         ; (LINNUM) = LINE # TO FIND
                                                         ; IF NOT FOUND:  CARRY = 0
                                                         ; LOWTR POINTS AT NEXT LINE
                                                         ; IF FOUND:      CARRY = 1
                                                         ; LOWTR POINTS AT LINE
                                                         ; --------------------------------
MS_FNDLIN:       LDA              MS_Z_TXTTAB            ; SEARCH FROM BEGINNING OF PROGRAM
                 LDX              MS_Z_TXTTAB + 1
MS_FNDLNC:       LDY              #1                     ; SEARCH FROM (X,A)
                 STA              MS_Z_LOWTR
                 STX              MS_Z_LOWTR + 1
                 LDA              (MS_Z_LOWTR),Y
                 BEQ              MS_FLINRT              ; END OF PROGRAM, AND NOT FOUND
                 INY
                 INY
                 LDA              MS_Z_LINNUM + 1
                 CMP              (MS_Z_LOWTR),Y
                 BCC              MS_FLNRTS              ; IF NOT FOUND
                 BEQ              MS_FNDLO1
                 DEY
                 BNE              MS_AFFRTS
MS_FNDLO1:       LDA              MS_Z_LINNUM
                 DEY
                 CMP              (MS_Z_LOWTR),Y
                 BCC              MS_FLNRTS              ; PAST LINE, NOT FOUND
                 BEQ              MS_FLNRTS              ; IF FOUND
MS_AFFRTS:        DEY
                 LDA              (MS_Z_LOWTR),Y
                 TAX
                 DEY
                 LDA              (MS_Z_LOWTR),Y
                 BCS              MS_FNDLNC              ; ALWAYS
MS_FLINRT:        CLC                    ; RETURN CARRY = 0
MS_FLNRTS:        RTS
                                                         ; --------------------------------
                                                         ; "NEW" STATEMENT
                                                         ; --------------------------------
MS_SCRATH:       BNE              MS_FLNRTS              ; IGNORE IF MORE TO THE STATEMENT
MS_SCRTCH:       LDA              #0
                 STA              AS_LOCK
                 TAY
                 STA              (MS_Z_TXTTAB),Y
                 INY
                 STA              (MS_Z_TXTTAB),Y
                 LDA              MS_Z_TXTTAB
                 ADC              #2                     ; (CARRY WASN'T CLEARED, SO "NEW" USUALLY
                 STA              MS_Z_VARTAB            ; ADDS 3, WHEREAS "FP" ADDS 2.)
                 STA              AS_PRGEND
                 LDA              MS_Z_TXTTAB + 1
                 ADC              #0
                 STA              MS_Z_VARTAB + 1
                 STA              AS_PRGEND + 1
                                                         ; --------------------------------
MS_RUNC:
                 JSR              MS_STXTPT              ; SET TXTPTR TO TXTTAB - 1
                 LDA              #0                     ; (THIS COULD HAVE BEEN ".HS 2C")
                                                         ; --------------------------------
                                                         ; "CLEAR" STATEMENT
                                                         ; --------------------------------
MS_CLEAR:        BNE              MS_STKRTS              ; IGNORE IF NOT AT END OF STATEMENT
MS_CLEARC:       LDA              MS_Z_MEMSIZ            ; CLEAR STRING AREA
                 LDY              MS_Z_MEMSIZ + 1
                 STA              MS_Z_FRETOP
                 STY              MS_Z_FRETOP + 1
                 LDA              MS_Z_VARTAB            ; CLEAR ARRAY AREA
                 LDY              MS_Z_VARTAB + 1
                 STA              MS_Z_ARYTAB
                 STY              MS_Z_ARYTAB + 1
                 STA              MS_Z_STREND            ; LOW END OF FREE SPACE
                 STY              MS_Z_STREND + 1
                 JSR              MS_RESTOR              ; SET "DATA" POINTER TO BEGINNING
                                                         ; --------------------------------
MS_STKINI:       LDX              #MS_Z_TEMPST
                 STX              MS_Z_TEMPPT
                 PLA                                     ; SAVE RETURN ADDRESS
                 TAY
                 PLA
                 LDX              #$F8                   ; START STACK AT $F8,
                 TXS                                     ; LEAVING ROOM FOR PARSING LINES
                 PHA                                     ; RESTORE RETURN ADDRESS
                 TYA
                 PHA
                 LDA              #0
                 STA              MS_Z_OLDTXT + 1
                 STA              MS_Z_SUBFLG
MS_STKRTS:        RTS
                                                         ; --------------------------------
                                                         ; SET TXTPTR TO BEGINNING OF PROGRAM
                                                         ; --------------------------------
MS_STXTPT:        CLC                    ; TXTPTR = TXTTAB - 1
                 LDA              MS_Z_TXTTAB
                 ADC              #$FF
                 STA              MS_Z_TXTPTR
                 LDA              MS_Z_TXTTAB + 1
                 ADC              #$FF
                 STA              MS_Z_TXTPTR + 1
                 RTS
                                                         ; --------------------------------
                                                         ; "LIST" STATEMENT
                                                         ; --------------------------------
MS_LIST:         BCC              MS_GOLST               ; NO  LINE # SPECIFIED
                 BEQ              MS_GOLST               ; ---DITTO---
                 CMP              #MS_MINUTK             ; IF DASH OR COMMA, START AT LINE 0
                 BEQ              MS_GOLST               ; IS IS A DASH
                 CMP              #"," & %01111111       ; COMMA?
                 BNE              MS_STKRTS              ; NO, ERROR
MS_GOLST:        JSR              MS_LINGET              ; CONVERT LINE NUMBER IF ANY
                 JSR              MS_FNDLIN              ; POINT LOWTR TO 1ST LINE
                 JSR              MS_Z_CHRGOT            ; RANGE SPECIFIED?
                 BEQ              MS_LSTEND              ; NO
                 CMP              #MS_MINUTK
                 BEQ              AS_L_LIST_2
                 CMP              #"," & %01111111
                 BNE              MS_FLNRTS
AS_L_LIST_2:     JSR              MS_Z_CHRGET            ; GET NEXT CHAR
                 JSR              MS_LINGET              ; CONVERT SECOND LINE #
                 BNE              MS_STKRTS              ; BRANCH IF SYNTAX ERR
MS_LSTEND:        PLA                    ; POP RETURN ADRESS
                 PLA                                     ; (GET BACK BY "JMP NEWSTT")
                 LDA              MS_Z_LINNUM            ; IF NO SECOND NUMBER, USE $FFFF
                 ORA              MS_Z_LINNUM + 1
                 BNE              MS_LIST4               ; THERE WAS A SECOND NUMBER
                 LDA              #$FF                   ; MAX END RANGE
                 STA              MS_Z_LINNUM
                 STA              MS_Z_LINNUM + 1
MS_LIST4:        LDY              #1
                 LDA              (MS_Z_LOWTR),Y         ; HIGH BYTE OF LINK
                 BEQ              AS_LIST_3              ; END OF PROGRAM
                 JSR              MS_ISCNTC              ; CHECK IF CONTROL-C HAS BEEN TYPED
                 JSR              MS_CRDO                ; NO, PRINT <RETURN>
                 INY
                 LDA              (MS_Z_LOWTR),Y         ; GET LINE #, COMPARE WITH END RANGE
                 TAX
                 INY
                 LDA              (MS_Z_LOWTR),Y
                 CMP              MS_Z_LINNUM + 1
                 BNE              MS_TSTDUN
                 CPX              MS_Z_LINNUM
                 BEQ              MS_TYPLIN              ; ON LAST LINE OF RANGE
MS_TSTDUN:       BCS              AS_LIST_3              ; FINISHED THE RANGE
                                                         ; ---LIST ONE LINE----------------
MS_TYPLIN:       STY              MS_Z_FORPNT
                 JSR              MS_LINPRT              ; PRINT LINE # FROM X,A
                 LDA              #" " & %01111111       ; PRINT SPACE AFTER LINE #
MS_PRIT4:        LDY              MS_Z_FORPNT
                 AND              #$7F
MS_PLOOP:        JSR              MS_OUTDO
                 LDA              MON_CH                 ; IF PAST COLUMN 33, START A NEW LINE
                 CMP              #33
                 BCC              AS_L_LIST_2_1          ; < 33
                 JSR              MS_CRDO                ; PRINT <RETURN>
                 LDA              #5                     ; AND TAB OVER 5
                 STA              MON_CH
AS_L_LIST_2_1:    INY
                 LDA              (MS_Z_LOWTR),Y
                 BNE              AS_LIST_4              ; NOT END OF LINE YET
                 TAY                                     ; END OF LINE
                 LDA              (MS_Z_LOWTR),Y         ; GET LINK TO NEXT LINE
                 TAX
                 INY
                 LDA              (MS_Z_LOWTR),Y
                 STX              MS_Z_LOWTR             ; POINT TO NEXT LINE
                 STA              MS_Z_LOWTR + 1
                 BNE              MS_LIST4               ; BRANCH IF NOT END OF PROGRAM
AS_LIST_3:       LDA              #$0D                   ; PRINT <RETURN>
                 JSR              MS_OUTDO
                 JMP              AS_NEWSTT              ; TO NEXT STATEMENT
                                                         ; --------------------------------
AS_GETCHR:        INY                    ; PICK UP CHAR FROM TABLE
                 BNE              AS_L_GETCHR_1
                 INC              MS_Z_FAC + 1
AS_L_GETCHR_1:   LDA              (MS_Z_FAC),Y
                 RTS
                                                         ; --------------------------------
AS_LIST_4:       BPL              MS_PLOOP               ; BRANCH IF NOT A TOKEN
                 SEC
                 SBC              #$7F                   ; CONVERT TOKEN TO INDEX
                 TAX
                 STY              MS_Z_FORPNT            ; SAVE LINE POINTER
                 LDY              #<(MS_RESLST - $100)
                 STY              MS_Z_FAC               ; POINT FAC TO TABLE
                 LDY              #>(MS_RESLST - $100)
                 STY              MS_Z_FAC + 1
                 LDY              #$FF
MS_RESRCH:        DEX                    ; SKIP KEYWORDS UNTIL REACH THIS ONE
                 BEQ              MS_PRIT3
AS_L_LIST_4_2:   JSR              AS_GETCHR              ; BUMP Y, GET CHAR FROM TABLE
                 BPL              AS_L_LIST_4_2          ; NOT AT END OF KEYWORD YET
                 BMI              MS_RESRCH              ; END OF KEYWORD, ALWAYS BRANCHES
MS_PRIT3:        LDA              #" " & %01111111       ; FOUND THE RIGHT KEYWORD
                 JSR              MS_OUTDO               ; PRINT LEADING SPACE
AS_L_LIST_4_4:   JSR              AS_GETCHR              ; PRINT THE KEYWORD
                 BMI              AS_L_LIST_4_5          ; LAST CHAR OF KEYWORD
                 JSR              MS_OUTDO
                 BNE              AS_L_LIST_4_4          ; ...ALWAYS
AS_L_LIST_4_5:   JSR              MS_OUTDO               ; PRINT LAST CHAR OF KEYWORD
                 LDA              #" " & %01111111       ; PRINT TRAILING SPACE
                 BNE              MS_PRIT4               ; ...ALWAYS, BACK TO ACTUAL LINE
                                                         ; --------------------------------
                                                         ; "FOR" STATEMENT

                                                         ; FOR PUSHES 18 BYTES ON THE STACK:
                                                         ; 2 -- TXTPTR
                                                         ; 2 -- LINE NUMBER
                                                         ; 5 -- INITIAL (CURRENT)  FOR VARIABLE VALUE
                                                         ; 1 -- STEP SIGN
                                                         ; 5 -- STEP VALUE
                                                         ; 2 -- ADDRESS OF FOR VARIABLE IN VARTAB
                                                         ; 1 -- FOR TOKEN ($81)
                                                         ; --------------------------------
MS_FOR:          LDA              #$80
                 STA              MS_Z_SUBFLG            ; SUBSCRIPTS NOT ALLOWED
                 JSR              MS_LET                 ; DO <VAR> = <EXP>, STORE ADDR IN FORPNT
                 JSR              MS_FNDFOR              ; IS THIS FOR VARIABLE ACTIVE?
                 BNE              MS_NOTOL               ; NO
                 TXA                                     ; YES, CANCEL IT AND ENCLOSED LOOPS
                 ADC              #15                    ; CARRY=1, THIS ADDS 16
                 TAX                                     ; X WAS ALREADY S+2
                 TXS
MS_NOTOL:         PLA                    ; POP RETURN ADDRESS TOO
                 PLA
                 LDA              #9                     ; BE CERTAIN ENOUGH ROOM IN STACK
                 JSR              MS_GETSTK
                 JSR              MS_DATAN               ; SCAN AHEAD TO NEXT STATEMENT
                 CLC                                     ; PUSH STATEMENT ADDRESS ON STACK
                 TYA
                 ADC              MS_Z_TXTPTR
                 PHA
                 LDA              MS_Z_TXTPTR + 1
                 ADC              #0
                 PHA
                 LDA              MS_Z_CURLIN + 1        ; PUSH LINE NUMBER ON STACK
                 PHA
                 LDA              MS_Z_CURLIN
                 PHA
                 LDA              #MS_TOTK
                 JSR              AS_SYNCHR              ; REQUIRE "TO"
                 JSR              AS_CHKNUM              ; <VAR> = <EXP> MUST BE NUMERIC
                 JSR              AS_FRMNUM              ; GET FINAL VALUE, MUST BE NUMERIC
                 LDA              MS_Z_FACSGN            ; PUT SIGN INTO VALUE IN FAC
                 ORA              #$7F
                 AND              MS_Z_FAC + 1
                 STA              MS_Z_FAC + 1
                 LDA              #<MS_LDFONE            ; SET UP FOR RETURN
                 LDY              #>MS_LDFONE            ; TO STEP
                 STA              MS_Z_INDEX
                 STY              MS_Z_INDEX + 1
                 JMP              AS_FRM_STACK_3         ; RETURNS BY "JMP (INDEX)"
                                                         ; --------------------------------
                                                         ; "STEP" PHRASE OF "FOR" STATEMENT
                                                         ; --------------------------------
MS_LDFONE:       LDA              #<MS_FONE              ; STEP DEFAULT=1
                 LDY              #>MS_FONE
                 JSR              AS_LOAD_FAC_FROM_YA
                 JSR              MS_Z_CHRGOT
                 CMP              #MS_STEPTK
                 BNE              MS_ONEON               ; USE DEFAULT VALUE OF 1.0
                 JSR              MS_Z_CHRGET            ; STEP SPECIFIED, GET IT
                 JSR              AS_FRMNUM
MS_ONEON:        JSR              AS_SIGN
                 JSR              AS_FRM_STACK_2
                 LDA              MS_Z_FORPNT + 1
                 PHA
                 LDA              MS_Z_FORPNT
                 PHA
                 LDA              #MS_FORTK
                 PHA
                                                         ; --------------------------------
                                                         ; PERFORM NEXT STATEMENT
                                                         ; --------------------------------
AS_NEWSTT:        TSX                    ; REMEMBER THE STACK POSITION
                 STX              AS_REMSTK
                 JSR              MS_ISCNTC              ; SEE IF CONTROL-C HAS BEEN TYPED
                 LDA              MS_Z_TXTPTR            ; NO, KEEP EXECUTING
                 LDY              MS_Z_TXTPTR + 1
                 LDX              MS_Z_CURLIN + 1        ; =$FF IF IN DIRECT MODE
                 INX                                     ; $FF TURNS INTO $00
                 BEQ              MS_DIRCON              ; IN DIRECT MODE
                 STA              MS_Z_OLDTXT            ; IN RUNNING MODE
                 STY              MS_Z_OLDTXT + 1
MS_DIRCON:       LDY              #0
                 LDA              (MS_Z_TXTPTR),Y        ; END OF LINE YET?
                 BNE              AS_COLON_              ; NO
                 LDY              #2                     ; YES, SEE IF END OF PROGRAM
                 LDA              (MS_Z_TXTPTR),Y
                 CLC
                 BEQ              AS_GOEND               ; YES, END OF PROGRAM
                 INY
                 LDA              (MS_Z_TXTPTR),Y        ; GET LINE # OF NEXT LINE
                 STA              MS_Z_CURLIN
                 INY
                 LDA              (MS_Z_TXTPTR),Y
                 STA              MS_Z_CURLIN + 1
                 TYA                                     ; ADJUST TXTPTR TO START
                 ADC              MS_Z_TXTPTR            ; OF NEW LINE
                 STA              MS_Z_TXTPTR
                 BCC              AS_L_NEWSTT_2
                 INC              MS_Z_TXTPTR + 1
AS_L_NEWSTT_2:
                                                         ; --------------------------------
AS_TRACE_:       BIT              AS_TRCFLG              ; IS TRACE ON?
                 BPL              AS_L_TRACE__1          ; NO
                 LDX              MS_Z_CURLIN + 1        ; YES, ARE WE RUNNING?
                 INX
                 BEQ              AS_L_TRACE__1          ; NOT RUNNING, SO DON'T TRACE
                 LDA              #"#" & %01111111       ; PRINT "#"
                 JSR              MS_OUTDO
                 LDX              MS_Z_CURLIN
                 LDA              MS_Z_CURLIN + 1
                 JSR              MS_LINPRT              ; PRINT LINE NUMBER
                 JSR              AS_OUTSP               ; PRINT TRAILING SPACE
AS_L_TRACE__1:   JSR              MS_Z_CHRGET            ; GET FIRST CHR OF STATEMENT
                 JSR              AS_EXECUTE_STATEMENT   ; AND START PROCESSING
                 JMP              AS_NEWSTT              ; BACK FOR MORE
                                                         ; --------------------------------
AS_GOEND:        BEQ              AS_END4
                                                         ; --------------------------------
                                                         ; EXECUTE A STATEMENT

                                                         ; (A) IS FIRST CHAR OF STATEMENT
                                                         ; CARRY IS SET
                                                         ; --------------------------------
AS_EXECUTE_STATEMENT:
                 BEQ              AS_RTS_3               ; END OF LINE, NULL STATEMENT
AS_EXECUTE_STATEMENT_1:
                 SBC              #$80                   ; FIRST CHAR A TOKEN?
                 BCC              AS_L_EXECUTE_STATEMENT_1_1 ; NOT TOKEN, MUST BE "LET"
                 CMP              #$40                   ; STATEMENT-TYPE TOKEN?
                 BCS              AS_SYNERR_1            ; NO, SYNTAX ERROR
                 ASL                                     ; DOUBLE TO GET INDEX
                 TAY                                     ; INTO ADDRESS TABLE
                 LDA              MS_STMDSP + 1,Y
                 PHA                                     ; PUT ADDRESS ON STACK
                 LDA              MS_STMDSP,Y
                 PHA
                 JMP              MS_Z_CHRGET            ; GET NEXT CHR & RTS TO ROUTINE
                                                         ; --------------------------------
AS_L_EXECUTE_STATEMENT_1_1: JMP              MS_LET                 ; MUST BE <VAR> = <EXP>
                                                         ; --------------------------------
AS_COLON_:       CMP              #":" & %01111111
                 BEQ              AS_TRACE_
AS_SYNERR_1:     JMP              AS_SYNERR
                                                         ; --------------------------------
                                                         ; "RESTORE" STATEMENT
                                                         ; --------------------------------
MS_RESTOR:
                 SEC                                     ; SET DATPTR TO BEGINNING OF PROGRAM
                 LDA              MS_Z_TXTTAB
                 SBC              #1
                 LDY              MS_Z_TXTTAB + 1
                 BCS              AS_SETDA
                 DEY
                                                         ; ---SET DATPTR TO Y,A------------
AS_SETDA:        STA              MS_Z_DATPTR
                 STY              MS_Z_DATPTR + 1
AS_RTS_3:         RTS
                                                         ; --------------------------------
                                                         ; SEE IF CONTROL-C TYPED
                                                         ; --------------------------------
MS_ISCNTC:       LDA              AS_KEYBOARD
                 CMP              #$83
                 BEQ              MS_ISCCAP
                 RTS
MS_ISCCAP:       JSR              MS_INCHR               ; <<< SHOULD BE "BIT $C010" >>>
AS_CONTROL_C_TYPED:
                 LDX              #$FF                   ; CONTROL C ATTEMPTED
                 BIT              AS_ERRFLG              ; "ON ERR" ENABLED?
                 BPL              AS_L_CONTROL_C_TYPED_2 ; NO
                 JMP              AS_HANDLERR            ; YES, RETURN ERR CODE = 255
AS_L_CONTROL_C_TYPED_2: CMP              #3                     ; SINCE IT IS CTRL-C, SET Z AND C BITS
                                                         ; --------------------------------
                                                         ; "STOP" STATEMENT
                                                         ; --------------------------------
MS_STOP:         BCS              AS_END2                ; CARRY=1 TO FORCE PRINTING "BREAK AT.."
                                                         ; --------------------------------
                                                         ; "END" STATEMENT
                                                         ; --------------------------------
MS_END:           CLC                    ; CARRY=0 TO AVOID PRINTING MESSAGE
AS_END2:         BNE              AS_RTS_4               ; IF NOT END OF STATEMENT, DO NOTHING
                 LDA              MS_Z_TXTPTR
                 LDY              MS_Z_TXTPTR + 1
                 LDX              MS_Z_CURLIN + 1
                 INX                                     ; RUNNING?
                 BEQ              AS_L_END2_1            ; NO, DIRECT MODE
                 STA              MS_Z_OLDTXT
                 STY              MS_Z_OLDTXT + 1
                 LDA              MS_Z_CURLIN
                 LDY              MS_Z_CURLIN + 1
                 STA              MS_Z_OLDLIN
                 STY              MS_Z_OLDLIN + 1
AS_L_END2_1:      PLA
                 PLA
AS_END4:         LDA              #<MS_BRKTXT            ; " BREAK" AND BELL
                 LDY              #>MS_BRKTXT
                 BCC              AS_L_END4_1
                 JMP              MS_ERRFIN
AS_L_END4_1:     JMP              MS_MAIN
                                                         ; --------------------------------
                                                         ; "CONT" COMMAND
                                                         ; --------------------------------
MS_CONT:         BNE              AS_RTS_4               ; IF NOT END OF STATEMENT, DO NOTHING
                 LDX              #MS_ERRCN
                 LDY              MS_Z_OLDTXT + 1        ; MEANINGFUL RE-ENTRY?
                 BNE              AS_L_CONT_1            ; YES
                 JMP              MS_ERROR               ; NO
AS_L_CONT_1:     LDA              MS_Z_OLDTXT            ; RESTORE TXTPTR
                 STA              MS_Z_TXTPTR
                 STY              MS_Z_TXTPTR + 1
                 LDA              MS_Z_OLDLIN            ; RESTORE LINE NUMBER
                 LDY              MS_Z_OLDLIN + 1
                 STA              MS_Z_CURLIN
                 STY              MS_Z_CURLIN + 1
AS_RTS_4:         RTS
                                                         ; --------------------------------
                                                         ; "SAVE" COMMAND
                                                         ; WRITES PROGRAM ON CASSETTE TAPE
                                                         ; --------------------------------
MS_SAVE:          SEC
                 LDA              AS_PRGEND              ; COMPUTE PROGRAM LENGTH
                 SBC              MS_Z_TXTTAB
                 STA              MS_Z_LINNUM
                 LDA              AS_PRGEND + 1
                 SBC              MS_Z_TXTTAB + 1
                 STA              MS_Z_LINNUM + 1
                 JSR              AS_VARTIO              ; SET UP TO WRITE 3 BYTE HEADER
                 JSR              MON_WRITE              ; WRITE 'EM
                 JSR              AS_PROGIO              ; SET UP TO WRITE THE PROGRAM
                 JMP              MON_WRITE              ; WRITE IT
                                                         ; --------------------------------
                                                         ; "LOAD" COMMAND
                                                         ; READS A PROGRAM FROM CASSETTE TAPE
                                                         ; --------------------------------
MS_LOAD:         JSR              AS_VARTIO              ; SET UP TO READ 3 BYTE HEADER
                 JSR              MON_READ               ; READ LENGTH, LOCK BYTE
                 CLC
                 LDA              MS_Z_TXTTAB            ; COMPUTE END ADDRESS
                 ADC              MS_Z_LINNUM
                 STA              MS_Z_VARTAB
                 LDA              MS_Z_TXTTAB + 1
                 ADC              MS_Z_LINNUM + 1
                 STA              MS_Z_VARTAB + 1
                 LDA              MS_Z_TEMPPT            ; LOCK BYTE
                 STA              AS_LOCK
                 JSR              AS_PROGIO              ; SET UP TO READ PROGRAM
                 JSR              MON_READ               ; READ IT
                 BIT              AS_LOCK                ; IF LOCKED, START RUNNING NOW
                 BPL              AS_L_LOAD_1            ; NOT LOCKED
                 JMP              MS_RUNC                ; LOCKED, START RUNNING
AS_L_LOAD_1:     JMP              MS_FINI                ; JUST FIX FORWARD POINTERS
                                                         ; --------------------------------
AS_VARTIO:       LDA              #MS_Z_LINNUM           ; SET UP TO READ/WRITE 3 BYTE HEADER
                 LDY              #0
                 STA              MON_A1L
                 STY              MON_A1H
                 LDA              #MS_Z_TEMPPT
                 STA              MON_A2L
                 STY              MON_A2H
                 STY              AS_LOCK
                 RTS
                                                         ; --------------------------------
AS_PROGIO:       LDA              MS_Z_TXTTAB            ; SET UP TO READ/WRITE PROGRAM
                 LDY              MS_Z_TXTTAB + 1
                 STA              MON_A1L
                 STY              MON_A1H
                 LDA              MS_Z_VARTAB
                 LDY              MS_Z_VARTAB + 1
                 STA              MON_A2L
                 STY              MON_A2H
                 RTS
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; "RUN" COMMAND
                                                         ; --------------------------------
MS_RUN:           PHP                    ; SAVE STATUS WHILE SUBTRACTING
                 DEC              MS_Z_CURLIN + 1        ; IF WAS $FF (MEANING DIRECT MODE)
                                                         ; MAKE IT "RUNNING MODE"
                 PLP                                     ; GET STATUS AGAIN (FROM CHRGET)
                 BNE              AS_L_RUN_1             ; PROBABLY A LINE NUMBER
                 JMP              MS_RUNC                ; START AT BEGINNING OF PROGRAM
AS_L_RUN_1:      JSR              MS_CLEARC              ; CLEAR VARIABLES
                 JMP              MS_RUNC2               ; JOIN GOSUB STATEMENT
                                                         ; --------------------------------
                                                         ; "GOSUB" STATEMENT

                                                         ; LEAVES 7 BYTES ON STACK:
                                                         ; 2 -- RETURN ADDRESS (NEWSTT)
                                                         ; 2 -- TXTPTR
                                                         ; 2 -- LINE #
                                                         ; 1 -- GOSUB TOKEN ($B0)
                                                         ; --------------------------------
MS_GOSUB:        LDA              #3                     ; BE SURE ENOUGH ROOM ON STACK
                 JSR              MS_GETSTK
                 LDA              MS_Z_TXTPTR + 1
                 PHA
                 LDA              MS_Z_TXTPTR
                 PHA
                 LDA              MS_Z_CURLIN + 1
                 PHA
                 LDA              MS_Z_CURLIN
                 PHA
                 LDA              #MS_GOSUTK
                 PHA
MS_RUNC2:
                 JSR              MS_Z_CHRGOT
                 JSR              MS_GOTO
                 JMP              AS_NEWSTT
                                                         ; --------------------------------
                                                         ; "GOTO" STATEMENT
                                                         ; ALSO USED BY "RUN" AND "GOSUB"
                                                         ; --------------------------------
MS_GOTO:         JSR              MS_LINGET              ; GET GOTO LINE
                 JSR              MS_REMN                ; POINT Y TO EOL
                 LDA              MS_Z_CURLIN + 1        ; IS CURRENT PAGE < GOTO PAGE?
                 CMP              MS_Z_LINNUM + 1
                 BCS              MS_LUK4IT              ; SEARCH FROM PROG START IF NOT
                 TYA                                     ; OTHERWISE SEARCH FROM NEXT LINE
                 SEC
                 ADC              MS_Z_TXTPTR
                 LDX              MS_Z_TXTPTR + 1
                 BCC              MS_LUKALL
                 INX
                 BCS              MS_LUKALL
MS_LUK4IT:       LDA              MS_Z_TXTTAB            ; GET PROGRAM BEGINNING
                 LDX              MS_Z_TXTTAB + 1
MS_LUKALL:       JSR              MS_FNDLNC              ; SEARCH FOR GOTO LINE
                 BCC              MS_USERR               ; ERROR IF NOT THERE
                 LDA              MS_Z_LOWTR             ; TXTPTR = START OF THE DESTINATION LINE
                 SBC              #1
                 STA              MS_Z_TXTPTR
                 LDA              MS_Z_LOWTR + 1
                 SBC              #0
                 STA              MS_Z_TXTPTR + 1
MS_GORTS:         RTS                    ; RETURN TO NEWSTT OR GOSUB
                                                         ; --------------------------------
                                                         ; "POP" AND "RETURN" STATEMENTS
                                                         ; --------------------------------
MS_RETURN:       BNE              MS_GORTS
                 LDA              #$FF
                 STA              MS_Z_FORPNT            ; <<< BUG: SHOULD BE FORPNT+1 >>>
                                                         ; <<< SEE "ALL ABOUT APPLESOFT", PAGES 100,101 >>>
                 JSR              MS_FNDFOR              ; TO CANCEL FOR/NEXT IN SUB
                 TXS
                 CMP              #MS_GOSUTK             ; LAST GOSUB FOUND?
                 BEQ              AS_RETURN
                 LDX              #MS_ERRRG
                    .BYTE $2C                       ; FAKE
MS_USERR:        LDX              #MS_ERRUS
                 JMP              MS_ERROR
                                                         ; --------------------------------
MS_SNERR2:       JMP              AS_SYNERR
                                                         ; --------------------------------
AS_RETURN:        PLA                    ; DISCARD GOSUB TOKEN
                 PLA
                 CPY              #<(AS_TOKEN_POP * 2)
                 BEQ              AS_PULL3               ; BRANCH IF A POP
                 STA              MS_Z_CURLIN            ; PULL LINE #
                 PLA
                 STA              MS_Z_CURLIN + 1
                 PLA
                 STA              MS_Z_TXTPTR            ; PULL TXTPTR
                 PLA
                 STA              MS_Z_TXTPTR + 1
                                                         ; --------------------------------
                                                         ; "DATA" STATEMENT
                                                         ; EXECUTED BY SKIPPING TO NEXT COLON OR EOL
                                                         ; --------------------------------
MS_DATA:         JSR              MS_DATAN               ; MOVE TO NEXT STATEMENT
                                                         ; --------------------------------
                                                         ; ADD (Y) TO TXTPTR
                                                         ; --------------------------------
MS_ADDON:         TYA
                 CLC
                 ADC              MS_Z_TXTPTR
                 STA              MS_Z_TXTPTR
                 BCC              AS_L_ADDON_1
                 INC              MS_Z_TXTPTR + 1
AS_L_ADDON_1:
MS_REMRTS:        RTS
                                                         ; --------------------------------
                                                         ; SCAN AHEAD TO NEXT ":" OR EOL
                                                         ; --------------------------------
MS_DATAN:        LDX              #":" & %01111111       ; GET OFFSET IN Y TO EOL OR ":"
                    .BYTE $2C                       ; FAKE
                                                         ; --------------------------------
MS_REMN:         LDX              #0                     ; TO EOL ONLY
                 STX              MS_Z_CHARAC
                 LDY              #0
                 STY              MS_Z_ENDCHR
MS_EXCHQT:       LDA              MS_Z_ENDCHR            ; TRICK TO COUNT QUOTE PARITY
                 LDX              MS_Z_CHARAC
                 STA              MS_Z_CHARAC
                 STX              MS_Z_ENDCHR
MS_REMER:        LDA              (MS_Z_TXTPTR),Y
                 BEQ              MS_REMRTS              ; END OF LINE
                 CMP              MS_Z_ENDCHR
                 BEQ              MS_REMRTS              ; COLON IF LOOKING FOR COLONS
                 INY
                 CMP              #$22
                 BNE              MS_REMER
                 BEQ              MS_EXCHQT              ; ...ALWAYS
                                                         ; --------------------------------
AS_PULL3:         PLA
                 PLA
                 PLA
                 RTS
                                                         ; --------------------------------
                                                         ; "IF" STATEMENT
                                                         ; --------------------------------
MS_IF:           JSR              AS_FRMEVL
                 JSR              MS_Z_CHRGOT
                 CMP              #MS_GOTOTK
                 BEQ              AS_L_IF_1
                 LDA              #MS_THENTK
                 JSR              AS_SYNCHR
AS_L_IF_1:       LDA              MS_Z_FAC               ; CONDITION TRUE OR FALSE?
                 BNE              AS_IF_TRUE             ; BRANCH IF TRUE
                                                         ; --------------------------------
                                                         ; "REM" STATEMENT, OR FALSE "IF" STATEMENT
                                                         ; --------------------------------
MS_REM:          JSR              MS_REMN                ; SKIP REST OF LINE
                 BEQ              MS_ADDON               ; ...ALWAYS
                                                         ; --------------------------------
AS_IF_TRUE:
                 JSR              MS_Z_CHRGOT            ; COMMAND OR NUMBER?
                 BCS              AS_L_IF_TRUE_1         ; COMMAND
                 JMP              MS_GOTO                ; NUMBER
AS_L_IF_TRUE_1:  JMP              AS_EXECUTE_STATEMENT
                                                         ; --------------------------------
                                                         ; "ON" STATEMENT

                                                         ; ON <EXP> GOTO <LIST>
                                                         ; ON <EXP> GOSUB <LIST>
                                                         ; --------------------------------
MS_ONGOTO:       JSR              AS_GETBYT              ; EVALUATE <EXP>, AS BYTE IN FAC+4
                 PHA                                     ; SAVE NEXT CHAR ON STACK
                 CMP              #MS_GOSUTK
                 BEQ              AS_ON_2
AS_ON_1:         CMP              #MS_GOTOTK
                 BNE              MS_SNERR2
AS_ON_2:         DEC              MS_Z_FAC + 4           ; COUNTED TO RIGHT ONE YET?
                 BNE              AS_L_ON_2_3            ; NO, KEEP LOOKING
                 PLA                                     ; YES, RETRIEVE CMD
                 JMP              AS_EXECUTE_STATEMENT_1 ; AND GO.
AS_L_ON_2_3:     JSR              MS_Z_CHRGET            ; PRIME CONVERT SUBROUTINE
                 JSR              MS_LINGET              ; CONVERT LINE #
                 CMP              #"," & %01111111       ; TERMINATE WITH COMMA?
                 BEQ              AS_ON_2                ; YES
                 PLA                                     ; NO, END OF LIST, SO IGNORE
AS_RTS_7:         RTS
                                                         ; --------------------------------
                                                         ; CONVERT LINE NUMBER
                                                         ; --------------------------------
MS_LINGET:       LDX              #0                     ; ASC # TO HEX ADDRESS
                 STX              MS_Z_LINNUM            ; IN LINNUM.
                 STX              MS_Z_LINNUM + 1
AS_L_LINGET_1:   BCS              AS_RTS_7               ; NOT A DIGIT
                 SBC              #("0" & %01111111) - 1 ; CONVERT DIGIT TO BINARY
                 STA              MS_Z_CHARAC            ; SAVE THE DIGIT
                 LDA              MS_Z_LINNUM + 1        ; CHECK RANGE
                 STA              MS_Z_INDEX
                 CMP              #>6400                 ; LINE # TOO LARGE?
                 BCS              AS_ON_1                ; YES, > 63999, GO INDIRECTLY TO
                                                         ; "SYNTAX ERROR".
                                                         ; <<<<<DANGEROUS CODE>>>>>
                                                         ; NOTE THAT IF (A) = $AB ON THE LINE ABOVE,
                                                         ; ON_1 WILL COMPARE = AND CAUSE A CATASTROPHIC
                                                         ; JUMP TO $22D9 (FOR GOTO), OR OTHER LOCATIONS
                                                         ; FOR OTHER CALLS TO LINGET.

                                                         ; YOU CAN SEE THIS IS YOU FIRST PUT "BRK" IN $22D9,
                                                         ; THEN TYPE "GO TO 437761".

                                                         ; ANY VALUE FROM 437760 THROUGH 440319 WILL CAUSE
                                                         ; THE PROBLEM.  ($AB00 - $ABFF)
                                                         ; <<<<<DANGEROUS CODE>>>>>
                 LDA              MS_Z_LINNUM            ; MULTIPLY BY TEN
                 ASL
                 ROL              MS_Z_INDEX
                 ASL
                 ROL              MS_Z_INDEX
                 ADC              MS_Z_LINNUM
                 STA              MS_Z_LINNUM
                 LDA              MS_Z_INDEX
                 ADC              MS_Z_LINNUM + 1
                 STA              MS_Z_LINNUM + 1
                 ASL              MS_Z_LINNUM
                 ROL              MS_Z_LINNUM + 1
                 LDA              MS_Z_LINNUM
                 ADC              MS_Z_CHARAC            ; ADD DIGIT
                 STA              MS_Z_LINNUM
                 BCC              AS_L_LINGET_2
                 INC              MS_Z_LINNUM + 1
AS_L_LINGET_2:   JSR              MS_Z_CHRGET            ; GET NEXT CHAR
                 JMP              AS_L_LINGET_1          ; MORE CONVERTING
                                                         ; --------------------------------
                                                         ; "LET" STATEMENT

                                                         ; LET <VAR> = <EXP>
                                                         ; <VAR> = <EXP>
                                                         ; --------------------------------
MS_LET:          JSR              AS_PTRGET              ; GET <VAR>
                 STA              MS_Z_FORPNT
                 STY              MS_Z_FORPNT + 1
                 LDA              #MS_EQULTK
                 JSR              AS_SYNCHR
                 LDA              MS_Z_VALTYP + 1        ; SAVE VARIABLE TYPE
                 PHA
                 LDA              MS_Z_VALTYP
                 PHA
                 JSR              AS_FRMEVL              ; EVALUATE <EXP>
                 PLA
                 ROL
                 JSR              AS_CHKVAL
                 BNE              AS_LET_STRING
                 PLA
                                                         ; --------------------------------
AS_LET2:         BPL              AS_L_LET2_1            ; REAL VARIABLE
                 JSR              AS_ROUND_FAC           ; INTEGER VAR: ROUND TO 32 BITS
                 JSR              AS_AYINT               ; TRUNCATE TO 16-BITS
                 LDY              #0
                 LDA              MS_Z_FAC + 3
                 STA              (MS_Z_FORPNT),Y
                 INY
                 LDA              MS_Z_FAC + 4
                 STA              (MS_Z_FORPNT),Y
                 RTS
                                                         ; --------------------------------
                                                         ; REAL VARIABLE = EXPRESSION
                                                         ; --------------------------------
AS_L_LET2_1:     JMP              AS_SETFOR
                                                         ; --------------------------------
AS_LET_STRING:
                 PLA
                                                         ; --------------------------------
                                                         ; INSTALL STRING, DESCRIPTOR ADDRESS IS AT FAC+3,4
                                                         ; --------------------------------
AS_PUTSTR:       LDY              #2                     ; STRING DATA ALREADY IN STRING AREA?
                 LDA              (MS_Z_FAC + 3),Y       ; (STRING AREA IS BTWN FRETOP
                 CMP              MS_Z_FRETOP + 1        ; HIMEM)
                 BCC              AS_L_PUTSTR_2          ; YES, DATA ALREADY UP THERE
                 BNE              AS_L_PUTSTR_1          ; NO
                 DEY                                     ; MAYBE, TEST LOW BYTE OF POINTER
                 LDA              (MS_Z_FAC + 3),Y
                 CMP              MS_Z_FRETOP
                 BCC              AS_L_PUTSTR_2          ; YES, ALREADY THERE
AS_L_PUTSTR_1:   LDY              MS_Z_FAC + 4           ; NO. DESCRIPTOR ALREADY AMONG VARIABLES?
                 CPY              MS_Z_VARTAB + 1
                 BCC              AS_L_PUTSTR_2          ; NO
                 BNE              AS_L_PUTSTR_3          ; YES
                 LDA              MS_Z_FAC + 3           ; MAYBE, COMPARE LO-BYTE
                 CMP              MS_Z_VARTAB
                 BCS              AS_L_PUTSTR_3          ; YES, DESCRIPTOR IS AMONG VARIABLES
AS_L_PUTSTR_2:   LDA              MS_Z_FAC + 3           ; EITHER STRING ALREADY ON TOP, OR
                 LDY              MS_Z_FAC + 4           ; DESCRIPTOR IS NOT A VARIABLE
                 JMP              AS_L_PUTSTR_4          ; SO JUST STORE THE DESCRIPTOR
                                                         ; --------------------------------
                                                         ; STRING NOT YET IN STRING AREA,
                                                         ; AND DESCRIPTOR IS A VARIABLE
                                                         ; --------------------------------
AS_L_PUTSTR_3:   LDY              #0                     ; POINT AT LENGTH IN DESCRIPTOR
                 LDA              (MS_Z_FAC + 3),Y       ; GET LENGTH
                 JSR              AS_STRINI              ; MAKE A STRING THAT LONG UP ABOVE
                 LDA              MS_Z_DSCPNT            ; SET UP SOURCE PNTR FOR MONINS
                 LDY              MS_Z_DSCPNT + 1
                 STA              MS_Z_STRNG1
                 STY              MS_Z_STRNG1 + 1
                 JSR              AS_MOVINS              ; MOVE STRING DATA TO NEW AREA
                 LDA              #<MS_Z_FAC             ; ADDRESS OF DESCRIPTOR IS IN FAC
                 LDY              #>MS_Z_FAC
AS_L_PUTSTR_4:   STA              MS_Z_DSCPNT
                 STY              MS_Z_DSCPNT + 1
                 JSR              AS_FRETMS              ; DISCARD DESCRIPTOR IF 'TWAS TEMPORARY
                 LDY              #0                     ; COPY STRING DESCRIPTOR
                 LDA              (MS_Z_DSCPNT),Y
                 STA              (MS_Z_FORPNT),Y
                 INY
                 LDA              (MS_Z_DSCPNT),Y
                 STA              (MS_Z_FORPNT),Y
                 INY
                 LDA              (MS_Z_DSCPNT),Y
                 STA              (MS_Z_FORPNT),Y
                 RTS
                                                         ; --------------------------------
AS_PR_STRING:
                 JSR              AS_STRPRT
                 JSR              MS_Z_CHRGOT
                                                         ; --------------------------------
                                                         ; "PRINT" STATEMENT
                                                         ; --------------------------------
MS_PRINT:        BEQ              MS_CRDO                ; NO MORE LIST, PRINT <RETURN>
                                                         ; --------------------------------
AS_PRINT2:       BEQ              AS_RTS_8               ; NO MORE LIST, DON'T PRINT <RETURN>
                 CMP              #MS_TABTK
                 BEQ              AS_PR_TAB_OR_SPC       ; C=1 FOR TAB(
                 CMP              #MS_SPCTK
                 CLC
                 BEQ              AS_PR_TAB_OR_SPC       ; C=0 FOR SPC(
                 CMP              #"," & %01111111
                 CLC                                     ; <<< NO PURPOSE TO THIS >>>
                 BEQ              AS_PR_COMMA
                    CMP #(";"&%01111111)
                 BEQ              AS_PR_NEXT_CHAR
                 JSR              AS_FRMEVL              ; EVALUATE EXPRESSION
                 BIT              MS_Z_VALTYP            ; STRING OR FP VALUE?
                 BMI              AS_PR_STRING           ; STRING
                 JSR              AS_FOUT                ; FP: CONVERT INTO BUFFER
                 JSR              AS_STRLIT              ; MAKE BUFFER INTO STRING
                 JMP              AS_PR_STRING           ; PRINT THE STRING
                                                         ; --------------------------------
MS_CRDO:         LDA              #$0D                   ; PRINT <RETURN>
                 JSR              MS_OUTDO
AS_NEGATE:       EOR              #$FF                   ; <<< WHY??? >>>
AS_RTS_8:         RTS
                                                         ; --------------------------------
                                                         ; TAB TO NEXT COMMA COLUMN
                                                         ; <<< NOTE BUG IF WIDTH OF WINDOW LESS THAN 33 >>>
AS_PR_COMMA:
                 LDA              MON_CH
                 CMP              #24                    ; <<< BUG:  IT SHOULD BE 32 >>>
                 BCC              AS_L_PR_COMMA_1        ; NEXT COLUMN, SAME LINE
                 JSR              MS_CRDO                ; FIRST COLUMN, NEXT LINT
                 BNE              AS_PR_NEXT_CHAR        ; ...ALWAYS
AS_L_PR_COMMA_1: ADC              #16
                 AND              #$F0                   ; ROUND TO 16 OR 32
                 STA              MON_CH
                 BCC              AS_PR_NEXT_CHAR        ; ...ALWAYS
                                                         ; --------------------------------
AS_PR_TAB_OR_SPC:
                 PHP                                     ; C=0 FOR SPC(, C=1 FOR TAB(
                 JSR              AS_GTBYTC              ; GET VALUE
                 CMP              #")" & %01111111       ; TRAILING PARENTHESIS
                 BEQ              AS_L_PR_TAB_OR_SPC_1   ; GOOD
                 JMP              AS_SYNERR              ; NO, SYNTAX ERROR
AS_L_PR_TAB_OR_SPC_1: PLP                    ; TAB( OR SPC(
                 BCC              AS_L_PR_TAB_OR_SPC_2   ; SPC(
                 DEX                                     ; TAB(
                 TXA                                     ; CALCULATE SPACES NEEDED FOR TAB(
                 SBC              MON_CH
                 BCC              AS_PR_NEXT_CHAR        ; ALREADY PAST THAT COLUMN
                 TAX                                     ; NOW DO A SPC( TO THE SPECIFIED COLUMN
AS_L_PR_TAB_OR_SPC_2: INX
AS_NXSPC:         DEX
                 BNE              AS_DOSPC               ; MORE SPACES TO PRINT
                                                         ; --------------------------------
AS_PR_NEXT_CHAR:
                 JSR              MS_Z_CHRGET
                 JMP              AS_PRINT2              ; CONTINUE PARSING PRINT LIST
                                                         ; --------------------------------
AS_DOSPC:        JSR              AS_OUTSP
                 BNE              AS_NXSPC               ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; PRINT STRING AT (Y,A)
AS_STROUT:       JSR              AS_STRLIT              ; MAKE (Y,A) PRINTABLE
                                                         ; --------------------------------
                                                         ; PRINT STRING AT (FACMO,FACLO)
                                                         ; --------------------------------
AS_STRPRT:       JSR              AS_FREFAC              ; GET ADDRESS INTO INDEX, (A)=LENGTH
                 TAX                                     ; USE X-REG FOR COUNTER
                 LDY              #0                     ; USE Y-REG FOR SCANNER
                 INX
AS_L_STRPRT_1:    DEX
                 BEQ              AS_RTS_8               ; FINISHED
                 LDA              (MS_Z_INDEX),Y         ; NEXT CHAR FROM STRING
                 JSR              MS_OUTDO               ; PRINT THE CHAR
                 INY
                                                         ; <<< NEXT THREE LINES ARE USELESS >>>
                 CMP              #$0D                   ; WAS IT <RETURN>?
                 BNE              AS_L_STRPRT_1          ; NO
                 JSR              AS_NEGATE              ; EOR #$FF WOULD DO IT, BUT WHY?
                                                         ; <<< ABOVE THREE LINES ARE USELESS >>>
                 JMP              AS_L_STRPRT_1
                                                         ; --------------------------------
AS_OUTSP:        LDA              #" " & %01111111       ; PRINT A SPACE
                    .BYTE $2C                       ; SKIP OVER NEXT LINE
MS_OUTQST:       LDA              #"?" & %01111111       ; PRINT QUESTION MARK
                                                         ; --------------------------------
                                                         ; PRINT CHAR FROM (A)

                                                         ; NOTE: POKE 243,32 ($20 IN $F3) WILL CONVERT
                                                         ; OUTPUT TO LOWER CASE.  THIS CAN BE CANCELLED
                                                         ; BY NORMAL, INVERSE, OR FLASH OR POKE 243,0.
                                                         ; --------------------------------
MS_OUTDO:        ORA              #$80                   ; PRINT (A)
                 CMP              #$A0                   ; CONTROL CHR?
                 BCC              AS_L_OUTDO_1           ; SKIP IF SO
                 ORA              AS_FLASH_BIT           ; =$40 FOR FLASH, ELSE $00
AS_L_OUTDO_1:    JSR              MON_COUT               ; "AND"S WITH $3F (INVERSE), $7F (FLASH)
                 AND              #$7F
                 PHA
                 LDA              AS_SPEEDZ              ; COMPLEMENT OF SPEED #
                 JSR              MON_WAIT               ; SO SPEED=255 BECOMES (A)=1
                 PLA
                 RTS
                                                         ; --------------------------------
                                                         ; INPUT CONVERSION ERROR:  ILLEGAL CHARACTER
                                                         ; IN NUMERIC FIELD.  MUST DISTINGUISH
                                                         ; BETWEEN INPUT, READ, AND GET
                                                         ; --------------------------------
AS_INPUTERR:
                 LDA              MS_Z_INPFLG
                 BEQ              AS_RESPERR             ; TAKEN IF INPUT
                 BMI              AS_READERR             ; TAKEN IF READ
                 LDY              #$FF                   ; FROM A GET
                 BNE              AS_ERLIN               ; ...ALWAYS
                                                         ; --------------------------------
AS_READERR:
                 LDA              MS_Z_DATLIN            ; TELL WHERE THE "DATA" IS, RATHER
                 LDY              MS_Z_DATLIN + 1        ; THAN THE "READ"
                                                         ; --------------------------------
AS_ERLIN:        STA              MS_Z_CURLIN
                 STY              MS_Z_CURLIN + 1
                 JMP              AS_SYNERR
                                                         ; --------------------------------
AS_INPERR:        PLA
                                                         ; --------------------------------
AS_RESPERR:
                 BIT              AS_ERRFLG              ; "ON ERR" TURNED ON?
                 BPL              AS_L_RESPERR_1         ; NO, GIVE REENTRY A TRY
                 LDX              #254                   ; ERROR CODE = 254
                 JMP              AS_HANDLERR
AS_L_RESPERR_1:  LDA              #<AS_ERR_REENTRY       ; "?REENTER"
                 LDY              #>AS_ERR_REENTRY
                 JSR              AS_STROUT
                 LDA              MS_Z_OLDTXT            ; RE-EXECUTE THE WHOLE INPUT STATEMENT
                 LDY              MS_Z_OLDTXT + 1
                 STA              MS_Z_TXTPTR
                 STY              MS_Z_TXTPTR + 1
                 RTS
                                                         ; --------------------------------
                                                         ; "GET" STATEMENT
                                                         ; --------------------------------
MS_GET:          JSR              AS_ERRDIR              ; ILLEGAL IF IN DIRECT MODE
                 LDX              #<(MS_A_BUFOFS + 1)    ; SIMULATE INPUT
                 LDY              #>(MS_A_BUFOFS + 1)
                 LDA              #0
                 STA              MS_A_BUFOFS + 1
                 LDA              #$40                   ; SET UP INPUTFLG
                 JSR              AS_PROCESS_INPUT_LIST  ; <<< CAN SAVE 1 BYTE HERE>>>
                 RTS                                     ; <<<BY "JMP PROCESS.INPUT.LIST">>>
                                                         ; --------------------------------
                                                         ; "INPUT" STATEMENT
                                                         ; --------------------------------
MS_INPUT:        CMP              #$22                   ; CHECK FOR OPTIONAL PROMPT STRING
                 BNE              AS_L_INPUT_1           ; NO, PRINT "?" PROMPT
                 JSR              AS_STRTXT              ; MAKE A PRINTABLE STRING OUT OF IT
                    LDA #(";"&%01111111)                        ; MUST HAVE ; NOW
                 JSR              AS_SYNCHR
                 JSR              AS_STRPRT              ; PRINT THE STRING
                 JMP              AS_L_INPUT_2
AS_L_INPUT_1:    JSR              MS_OUTQST              ; NO STRING, PRINT "?"
AS_L_INPUT_2:    JSR              AS_ERRDIR              ; ILLEGAL IF IN DIRECT MODE
                 LDA              #"," & %01111111       ; PRIME THE BUFFER
                 STA              MS_A_BUFOFS - 1
                 JSR              MS_INLIN
                 LDA              MS_A_BUFOFS
                 CMP              #$03                   ; CONTROL C?
                 BNE              AS_INPUT_FLAG_ZERO     ; NO
                 JMP              AS_CONTROL_C_TYPED
                                                         ; --------------------------------
AS_NXIN:         JSR              MS_OUTQST              ; PRINT "?"
                 JMP              MS_INLIN
                                                         ; --------------------------------
                                                         ; "READ" STATEMENT
                                                         ; --------------------------------
MS_READ:         LDX              MS_Z_DATPTR            ; Y,X POINTS AT NEXT DATA STATEMENT
                 LDY              MS_Z_DATPTR + 1
                 LDA              #$98                   ; SET INPUTFLG = $98
                    .BYTE $2C                       ; TRICK TO PROCESS.INPUT.LIST
                                                         ; --------------------------------
AS_INPUT_FLAG_ZERO: LDA              #0                     ; SET INPUTFLG = $00
                                                         ; --------------------------------
                                                         ; PROCESS INPUT LIST

                                                         ; (Y,X) IS ADDRESS OF INPUT DATA STRING
                                                         ; (A) = VALUE FOR INPUTFLG:  $00 FOR INPUT
                                                         ; $40 FOR GET
                                                         ; $98 FOR READ
                                                         ; --------------------------------
AS_PROCESS_INPUT_LIST: STA              MS_Z_INPFLG
                 STX              MS_Z_INPPTR            ; ADDRESS OF INPUT STRING
                 STY              MS_Z_INPPTR + 1
                                                         ; --------------------------------
AS_PROCESS_INPUT_ITEM: JSR              AS_PTRGET              ; GET ADDRESS OF VARIABLE
                 STA              MS_Z_FORPNT
                 STY              MS_Z_FORPNT + 1
                 LDA              MS_Z_TXTPTR            ; SAVE CURRENT TXTPTR,
                 LDY              MS_Z_TXTPTR + 1        ; WHICH POINTS INTO PROGRAM
                 STA              MS_Z_VARTXT
                 STY              MS_Z_VARTXT + 1
                 LDX              MS_Z_INPPTR            ; SET TXTPTR TO POINT AT INPUT BUFFER
                 LDY              MS_Z_INPPTR + 1        ; OR "DATA" LINE
                 STX              MS_Z_TXTPTR
                 STY              MS_Z_TXTPTR + 1
                 JSR              MS_Z_CHRGOT            ; GET CHAR AT PNTR
                 BNE              AS_INSTART             ; NOT END OF LINE OR COLON
                 BIT              MS_Z_INPFLG            ; DOING A "GET"?
                 BVC              AS_L_PROCESS_INPUT_ITEM_1 ; NO
                 JSR              MS_CQINCH              ; YES, GET CHAR
                 AND              #$7F
                 STA              MS_A_BUFOFS
                 LDX              #<(MS_A_BUFOFS - 1)
                 LDY              #>(MS_A_BUFOFS - 1)
                 BNE              AS_L_PROCESS_INPUT_ITEM_2 ; ...ALWAYS
                                                         ; --------------------------------
AS_L_PROCESS_INPUT_ITEM_1: BMI              AS_FINDATA             ; DOING A "READ"
                 JSR              MS_OUTQST              ; DOING AN "INPUT", PRINT "?"
                 JSR              AS_NXIN                ; PRINT ANOTHER "?", AND INPUT A LINE
AS_L_PROCESS_INPUT_ITEM_2: STX              MS_Z_TXTPTR
                 STY              MS_Z_TXTPTR + 1
                                                         ; --------------------------------
AS_INSTART:
                 JSR              MS_Z_CHRGET            ; GET NEXT INPUT CHAR
                 BIT              MS_Z_VALTYP            ; STRING OR NUMERIC?
                 BPL              AS_L_INSTART_5         ; NUMERIC
                 BIT              MS_Z_INPFLG            ; STRING -- NOW WHAT INPUT TYPE?
                 BVC              AS_L_INSTART_1         ; NOT A "GET"
                 INX                                     ; "GET"
                 STX              MS_Z_TXTPTR
                 LDA              #0
                 STA              MS_Z_CHARAC            ; NO OTHER TERMINATORS THAN $00
                 BEQ              AS_L_INSTART_2         ; ...ALWAYS
                                                         ; --------------------------------
AS_L_INSTART_1:  STA              MS_Z_CHARAC
                 CMP              #$22                   ; TERMINATE ON $00 OR QUOTE
                 BEQ              AS_L_INSTART_3
                 LDA              #":" & %01111111       ; TERMINATE ON $00, COLON, OR COMMA
                 STA              MS_Z_CHARAC
                 LDA              #"," & %01111111
AS_L_INSTART_2:   CLC
AS_L_INSTART_3:  STA              MS_Z_ENDCHR
                 LDA              MS_Z_TXTPTR
                 LDY              MS_Z_TXTPTR + 1
                 ADC              #0                     ; SKIP OVER QUOTATION MARK, IF
                 BCC              AS_L_INSTART_4         ; THERE WAS ONE
                 INY
AS_L_INSTART_4:  JSR              AS_STRLT2              ; BUILD STRING STARTING AT (Y,A)
                                                         ; TERMINATED BY $00, (CHARAC), OR (ENDCHR)
                 JSR              AS_POINT               ; SET TXTPTR TO POINT AT STRING
                 JSR              AS_PUTSTR              ; STORE STRING IN VARIABLE
                 JMP              AS_INPUT_MORE
                                                         ; --------------------------------
AS_L_INSTART_5:   PHA
                 LDA              MS_A_BUFOFS            ; ANYTHING IN BUFFER?
                 BEQ              AS_INPFIN              ; NO, SEE IF READ OR INPUT
                                                         ; --------------------------------
AS_INPUTDWTA:
                 PLA                                     ; "READ"
                 JSR              AS_FIN                 ; GET FP NUMBER AT TXTPTR
                 LDA              MS_Z_VALTYP + 1
                 JSR              AS_LET2                ; STORE RESULT IN VARIABLE
                                                         ; --------------------------------
AS_INPUT_MORE:
                 JSR              MS_Z_CHRGOT
                 BEQ              AS_L_INPUT_MORE_1      ; END OF LINE OR COLON
                 CMP              #"," & %01111111       ; COMMA IN INPUT?
                 BEQ              AS_L_INPUT_MORE_1      ; YES
                 JMP              AS_INPUTERR            ; NOTHING ELSE WILL DO
AS_L_INPUT_MORE_1: LDA              MS_Z_TXTPTR            ; SAVE POSITION IN INPUT BUFFER
                 LDY              MS_Z_TXTPTR + 1
                 STA              MS_Z_INPPTR
                 STY              MS_Z_INPPTR + 1
                 LDA              MS_Z_VARTXT            ; RESTORE PROGRAM POINTER
                 LDY              MS_Z_VARTXT + 1
                 STA              MS_Z_TXTPTR
                 STY              MS_Z_TXTPTR + 1
                 JSR              MS_Z_CHRGOT            ; NEXT CHAR FROM PROGRAM
                 BEQ              AS_INPDONE             ; END OF STATEMENT
                 JSR              AS_CHKCOM              ; BETTER BE A COMMA THEN
                 JMP              AS_PROCESS_INPUT_ITEM
                                                         ; --------------------------------
AS_INPFIN:       LDA              MS_Z_INPFLG            ; "INPUT" OR "READ"
                 BNE              AS_INPUTDWTA           ; "READ"
                 JMP              AS_INPERR
                                                         ; --------------------------------
AS_FINDATA:
                 JSR              MS_DATAN               ; GET OFFSET TO NEXT COLON OR EOL
                 INY                                     ; TO FIRST CHAR OF NEXT LINE
                 TAX                                     ; WHICH:  EOL OR COLON?
                 BNE              AS_L_FINDATA_1         ; COLON
                 LDX              #MS_ERROD              ; EOL: MIGHT BE OUT OF DATA
                 INY                                     ; CHECK HI-BYTE OF FORWARD PNTR
                 LDA              (MS_Z_TXTPTR),Y        ; END OF PROGRAM?
                 BEQ              AS_GERR                ; YES, WE ARE OUT OF DATA
                 INY                                     ; PICK UP THE LINE #
                 LDA              (MS_Z_TXTPTR),Y
                 STA              MS_Z_DATLIN
                 INY
                 LDA              (MS_Z_TXTPTR),Y
                 INY                                     ; POINT AT FIRST TEXT CHAR IN LINE
                 STA              MS_Z_DATLIN + 1
AS_L_FINDATA_1:  LDA              (MS_Z_TXTPTR),Y        ; GET 1ST TOKEN OF STATEMENT
                 TAX                                     ; SAVE TOKEN IN X-REG
                 JSR              MS_ADDON               ; ADD (Y) TO TXTPTR
                 CPX              #MS_DATATK             ; DID WE FIND A "DATA" STATEMENT?
                 BNE              AS_FINDATA             ; NOT YET
                 JMP              AS_INSTART             ; YES, READ IT
                                                         ; ---NO MORE INPUT REQUESTED------
AS_INPDONE:
                 LDA              MS_Z_INPPTR            ; GET POINTER IN CASE IT WAS "READ"
                 LDY              MS_Z_INPPTR + 1
                 LDX              MS_Z_INPFLG            ; "READ" OR "INPUT"?
                 BPL              AS_L_INPDONE_1         ; "INPUT"
                 JMP              AS_SETDA               ; "DATA", SO STORE (Y,X) AT DATPTR
AS_L_INPDONE_1:  LDY              #0                     ; "INPUT":  ANY MORE CHARS ON LINE?
                 LDA              (MS_Z_INPPTR),Y
                 BEQ              AS_L_INPDONE_2         ; NO, ALL IS WELL
                 LDA              #<AS_ERR_EXTRA         ; YES, ERROR
                 LDY              #>AS_ERR_EXTRA         ; "EXTRA IGNORED"
                 JMP              AS_STROUT
AS_L_INPDONE_2:   RTS
                                                         ; --------------------------------
AS_ERR_EXTRA           .BYTE ("?"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("X"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("A"&%01111111)
.BYTE (" "&%01111111)
.BYTE ("I"&%01111111)
.BYTE ("G"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("O"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("D"&%01111111)

                    .BYTE $0D,0

AS_ERR_REENTRY         .BYTE ("?"&%01111111)
.BYTE ("R"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("N"&%01111111)
.BYTE ("T"&%01111111)
.BYTE ("E"&%01111111)
.BYTE ("R"&%01111111)

                    .BYTE $0D,0
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; "NEXT" STATEMENT
                                                         ; --------------------------------
MS_NEXT:         BNE              MS_NEXT_1              ; VARIABLE AFTER "NEXT"
                 LDY              #0                     ; FLAG BY SETTING FORPNT+1 = 0
                 BEQ              MS_NEXT_2              ; ...ALWAYS
                                                         ; --------------------------------
MS_NEXT_1:       JSR              AS_PTRGET              ; GET PNTR TO VARIABLE IN (Y,A)
MS_NEXT_2:       STA              MS_Z_FORPNT
                 STY              MS_Z_FORPNT + 1
                 JSR              MS_FNDFOR              ; FIND FOR-FRAME FOR THIS VARIABLE
                 BEQ              MS_NEXT_3              ; FOUND IT
                 LDX              #MS_ERRNF              ; NOT THERE, ABORT
AS_GERR:         BEQ              AS_JERROR              ; ...ALWAYS
MS_NEXT_3:        TXS                    ; SET STACK PTR TO POINT TO THIS FRAME,
                 INX                                     ; WHICH TRIMS OFF ANY INNER LOOPS
                 INX
                 INX
                 INX
                 TXA                                     ; LOW BYTE OF ADRS OF STEP VALUE
                 INX
                 INX
                 INX
                 INX
                 INX
                 INX
                 STX              AS_DEST                ; LOW BYTE ADRS OF FOR VAR VALUE
                 LDY              #>AS_STACK             ; (Y,A) IS ADDRESS OF STEP VALUE
                 JSR              AS_LOAD_FAC_FROM_YA    ; STEP TO FAC
                 TSX
                 LDA              AS_STACK + 9,X
                 STA              MS_Z_FACSGN
                 LDA              MS_Z_FORPNT
                 LDY              MS_Z_FORPNT + 1
                 JSR              AS_FADD                ; ADD TO FOR VALUE
                 JSR              AS_SETFOR              ; PUT NEW VALUE BACK
                 LDY              #>AS_STACK             ; (Y,A) IS ADDRESS OF END VALUE
                 JSR              AS_FCOMP2              ; COMPARE TO END VALUE
                 TSX
                 SEC
                 SBC              AS_STACK + 9,X         ; SIGN OF STEP
                 BEQ              AS_L_NEXT_3_2          ; BRANCH IF FOR COMPLETE
                 LDA              AS_STACK + 15,X        ; OTHERWISE SET UP
                 STA              MS_Z_CURLIN            ; FOR LINE #
                 LDA              AS_STACK + 16,X
                 STA              MS_Z_CURLIN + 1
                 LDA              AS_STACK + 18,X        ; AND SET TXTPTR TO JUST
                 STA              MS_Z_TXTPTR            ; AFTER FOR STATEMENT
                 LDA              AS_STACK + 17,X
                 STA              MS_Z_TXTPTR + 1
AS_L_NEXT_3_1:   JMP              AS_NEWSTT
AS_L_NEXT_3_2:    TXA                    ; POP OFF FOR-FRAME, LOOP IS DONE
                 ADC              #17                    ; CARRY IS SET, SO ADDS 18
                 TAX
                 TXS
                 JSR              MS_Z_CHRGOT            ; CHAR AFTER VARIABLE
                 CMP              #"," & %01111111       ; ANOTHER VARIABLE IN NEXT_
                 BNE              AS_L_NEXT_3_1          ; NO, GO TO NEXT STATEMENT
                 JSR              MS_Z_CHRGET            ; YES, PRIME FOR NEXT VARIABLE
                 JSR              MS_NEXT_1              ; (DOES NOT RETURN)
                                                         ; --------------------------------
                                                         ; EVALUATE EXPRESSION, MAKE SURE IT IS NUMERIC
                                                         ; --------------------------------
AS_FRMNUM:       JSR              AS_FRMEVL
                                                         ; --------------------------------
                                                         ; MAKE SURE (FAC) IS NUMERIC
                                                         ; --------------------------------
AS_CHKNUM:        CLC
                    .BYTE $24                       ; DUMMY FOR SKIP
                                                         ; --------------------------------
                                                         ; MAKE SURE (FAC) IS STRING
                                                         ; --------------------------------
AS_CHKSTR:        SEC
                                                         ; --------------------------------
                                                         ; MAKE SURE (FAC) IS CORRECT TYPE
                                                         ; IF C=0, TYPE MUST BE NUMERIC
                                                         ; IF C=1, TYPE MUST BE STRING
                                                         ; --------------------------------
AS_CHKVAL:       BIT              MS_Z_VALTYP            ; $00 IF NUMERIC, $FF IF STRING
                 BMI              AS_L_CHKVAL_2          ; TYPE IS STRING
                 BCS              AS_L_CHKVAL_3          ; NOT STRING, BUT WE NEED STRING
AS_L_CHKVAL_1:    RTS                    ; TYPE IS CORRECT
AS_L_CHKVAL_2:   BCS              AS_L_CHKVAL_1          ; IS STRING AND WE WANTED STRING
AS_L_CHKVAL_3:   LDX              #MS_ERRTM              ; TYPE MISMATCH
AS_JERROR:       JMP              MS_ERROR
                                                         ; --------------------------------
                                                         ; EVALUATE THE EXPRESSION AT TXTPTR, LEAVING THE
                                                         ; RESULT IN FAC.  WORKS FOR BOTH STRING AND NUMERIC
                                                         ; EXPRESSIONS.
                                                         ; --------------------------------
AS_FRMEVL:       LDX              MS_Z_TXTPTR            ; DECREMENT TXTPTR
                 BNE              AS_L_FRMEVL_1
                 DEC              MS_Z_TXTPTR + 1
AS_L_FRMEVL_1:   DEC              MS_Z_TXTPTR
                 LDX              #0                     ; START WITH PRECEDENCE = 0
                    .BYTE $24                       ; TRICK TO SKIP FOLLOWING "PHA"
                                                         ; --------------------------------
AS_FRMEVL_1:
                 PHA                                     ; PUSH RELOPS FLAGS
                 TXA
                 PHA                                     ; SAVE LAST PRECEDENCE
                 LDA              #1
                 JSR              MS_GETSTK              ; CHECK IF ENOUGH ROOM ON STACK
                 JSR              AS_FRM_ELEMENT         ; GET AN ELEMENT
                 LDA              #0
                 STA              MS_Z_OPMASK            ; CLEAR COMPARISON OPERATOR FLAGS
                                                         ; --------------------------------
AS_FRMEVL_2:
                 JSR              MS_Z_CHRGOT            ; CHECK FOR RELATIONAL OPERATORS
AS_L_FRMEVL_2_1:  SEC                    ; > IS $CF, = IS $D0, < IS $D1
                 SBC              #MS_GREATK             ; > IS 0, = IS 1, < IS 2
                 BCC              AS_L_FRMEVL_2_2        ; NOT RELATIONAL OPERATOR
                 CMP              #3
                 BCS              AS_L_FRMEVL_2_2        ; NOT RELATIONAL OPERATOR
                 CMP              #1                     ; SET CARRY IF "=" OR "<"
                 ROL                                     ; NOW > IS 0, = IS 3, < IS 5
                 EOR              #1                     ; NOW > IS 1, = IS 2, < IS 4
                 EOR              MS_Z_OPMASK            ; SET BITS OF CPRTYP:  00000<=>
                 CMP              MS_Z_OPMASK            ; CHECK FOR ILLEGAL COMBINATIONS
                 BCC              AS_SNTXERR             ; IF LESS THAN, A RELOP WAS REPEATED
                 STA              MS_Z_OPMASK
                 JSR              MS_Z_CHRGET            ; ANOTHER OPERATOR?
                 JMP              AS_L_FRMEVL_2_1        ; CHECK FOR <,=,> AGAIN
                                                         ; --------------------------------
AS_L_FRMEVL_2_2: LDX              MS_Z_OPMASK            ; DID WE FIND A RELATIONAL OPERATOR?
                 BNE              AS_FRM_RELATIONAL      ; YES
                 BCS              AS_NOTMATH             ; NO, AND NEXT TOKEN IS > $D1
                 ADC              #$CF - MS_PLUSTK       ; NO, AND NEXT TOKEN < $CF
                 BCC              AS_NOTMATH             ; IF NEXT TOKEN < "+"
                 ADC              MS_Z_VALTYP            ; + AND LAST RESULT A STRING?
                 BNE              AS_L_FRMEVL_2_3        ; BRANCH IF NOT
                 JMP              AS_CAT                 ; CONCATENATE IF SO.
                                                         ; --------------------------------
AS_L_FRMEVL_2_3: ADC              #$FF                   ; +-*/ IS 0123
                 STA              MS_Z_INDEX
                 ASL                                     ; MULTIPLY BY 3
                 ADC              MS_Z_INDEX             ; +-*/ IS 0,3,6,9
                 TAY
                                                         ; --------------------------------
AS_FRM_PRECEDENCE_TEST:
                 PLA                                     ; GET LAST PRECEDENCE
                 CMP              MS_OPTAB,Y
                 BCS              AS_FRM_PERFORM_1       ; DO NOW IF HIGHER PRECEDENCE
                 JSR              AS_CHKNUM              ; WAS LAST RESULT A #?
AS_NXOP:          PHA                    ; YES, SAVE PRECEDENCE ON STACK
AS_SAVOP:        JSR              AS_FRM_RECURSE         ; SAVE REST, CALL FRMEVL RECURSIVELY
                 PLA
                 LDY              MS_Z_OPPTR
                 BPL              AS_PREFNC
                 TAX
                 BEQ              AS_GOEX                ; EXIT IF NO MATH IN EXPRESSION
                 BNE              AS_FRM_PERFORM_2       ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; FOUND ONE OR MORE RELATIONAL OPERATORS <,=,>
                                                         ; --------------------------------
AS_FRM_RELATIONAL:
                 LSR              MS_Z_VALTYP            ; (VALTYP) = 0 (NUMERIC), = $FF (STRING)
                 TXA                                     ; SET CPRTYP TO 0000<=>C
                 ROL                                     ; WHERE C=0 IF #, C=1 IF STRING
                 LDX              MS_Z_TXTPTR            ; BACK UP TXTPTR
                 BNE              AS_L_FRM_RELATIONAL_1
                 DEC              MS_Z_TXTPTR + 1
AS_L_FRM_RELATIONAL_1: DEC              MS_Z_TXTPTR
                 LDY              #MS_PTDORL - MS_OPTAB  ; POINT AT RELOPS ENTRY
                 STA              MS_Z_OPMASK
                 BNE              AS_FRM_PRECEDENCE_TEST ; ...ALWAYS
                                                         ; --------------------------------
AS_PREFNC:       CMP              MS_OPTAB,Y
                 BCS              AS_FRM_PERFORM_2       ; DO NOW IF HIGHER PRECEDENCE
                 BCC              AS_NXOP                ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; STACK THIS OPERATION AND CALL FRMEVL FOR
                                                         ; ANOTHER ONE
                                                         ; --------------------------------
AS_FRM_RECURSE:
                 LDA              MS_OPTAB + 2,Y
                 PHA                                     ; PUSH ADDRESS OF OPERATION PERFORMER
                 LDA              MS_OPTAB + 1,Y
                 PHA
                 JSR              AS_FRM_STACK_1         ; STACK FAC.SIGN AND FAC
                 LDA              MS_Z_OPMASK            ; A=RELOP FLAGS, X=PRECEDENCE BYTE
                 JMP              AS_FRMEVL_1            ; RECURSIVELY CALL FRMEVL
                                                         ; --------------------------------
AS_SNTXERR:      JMP              AS_SYNERR
                                                         ; --------------------------------
                                                         ; STACK (FAC)

                                                         ; THREE ENTRY POINTS:
                                                         ; L_SNTXERR_1, FROM FRMEVL
                                                         ; L_SNTXERR_2, FROM "STEP"
                                                         ; L_SNTXERR_3, FROM "FOR"
                                                         ; --------------------------------
AS_FRM_STACK_1:
                 LDA              MS_Z_FACSGN            ; GET FAC.SIGN TO PUSH IT
; Note: XA65 assembler (Andre Fachat) requires ! here when asm with "xa -R -bt 0" for some reason:
                 LDX              !MS_OPTAB,Y            ; PRECEDENCE BYTE FROM MATHTBL
                                                         ; --------------------------------
                                                         ; ENTER HERE FROM "STEP", TO PUSH STEP SIGN AND VALUE
                                                         ; --------------------------------
AS_FRM_STACK_2:
                 TAY                                     ; FAC.SIGN OR SGN(STEP VALUE)
                 PLA                                     ; PULL RETURN ADDRESS AND ADD 1
                 STA              MS_Z_INDEX             ; <<< ASSUMES NOT ON PAGE BOUNDARY! >>>
                 INC              MS_Z_INDEX             ; PLACE BUMPED RETURN ADDRESS IN
                 PLA                                     ; INDEX,INDEX+1
                 STA              MS_Z_INDEX + 1
                 TYA                                     ; FAC.SIGN OR SGN(STEP VALUE)
                 PHA                                     ; PUSH FAC.SIGN OR SGN(STEP VALUE)
                                                         ; --------------------------------
                                                         ; ENTER HERE FROM "FOR", WITH (INDEX) = STEP,
                                                         ; TO PUSH INITIAL VALUE OF "FOR" VARIABLE
                                                         ; --------------------------------
AS_FRM_STACK_3:
                 JSR              AS_ROUND_FAC           ; ROUND TO 32 BITS
                 LDA              MS_Z_FAC + 4           ; PUSH (FAC)
                 PHA
                 LDA              MS_Z_FAC + 3
                 PHA
                 LDA              MS_Z_FAC + 2
                 PHA
                 LDA              MS_Z_FAC + 1
                 PHA
                 LDA              MS_Z_FAC
                 PHA
                 JMP              (MS_Z_INDEX)           ; DO RTS FUNNY WAY
                                                         ; --------------------------------

                                                         ; --------------------------------
AS_NOTMATH:      LDY              #$FF                   ; SET UP TO EXIT ROUTINE
                 PLA
AS_GOEX:         BEQ              AS_EXIT                ; EXIT IF NO MATH TO DO
                                                         ; --------------------------------
                                                         ; PERFORM STACKED OPERATION

                                                         ; (A) = PRECEDENCE BYTE
                                                         ; STACK:  1 -- CPRMASK
                                                         ; 5 -- (ARG)
                                                         ; 2 -- ADDR OF PERFORMER
                                                         ; --------------------------------
AS_FRM_PERFORM_1:
                 CMP              #AS_P_REL              ; WAS IT RELATIONAL OPERATOR?
                 BEQ              AS_L_FRM_PERFORM_1_1   ; YES, ALLOW STRING COMPARE
                 JSR              AS_CHKNUM              ; MUST BE NUMERIC VALUE
AS_L_FRM_PERFORM_1_1: STY              MS_Z_OPPTR
                                                         ; --------------------------------
AS_FRM_PERFORM_2:
                 PLA                                     ; GET 0000<=>C FROM STACK
                 LSR                                     ; SHIFT TO 00000<=> FORM
                 STA              AS_CPRMASK             ; 00000<=>
                 PLA
                 STA              MS_Z_ARGEXP            ; GET FLOATING POINT VALUE OFF STACK,
                 PLA                                     ; AND PUT IT IN ARG
                 STA              MS_Z_ARGEXP + 1
                 PLA
                 STA              MS_Z_ARGEXP + 2
                 PLA
                 STA              MS_Z_ARGEXP + 3
                 PLA
                 STA              MS_Z_ARGEXP + 4
                 PLA
                 STA              MS_Z_ARGEXP + 5
                 EOR              MS_Z_FACSGN            ; SAVE EOR OF SIGNS OF THE OPERANDS,
                 STA              MS_Z_ARISGN            ; IN CASE OF MULTIPLY OR DIVIDE
AS_EXIT:         LDA              MS_Z_FAC               ; FAC EXPONENT IN A-REG
                 RTS                                     ; STATUS EQU. IF (FAC)=0
                                                         ; RTS GOES TO PERFORM OPERATION
                                                         ; --------------------------------
                                                         ; GET ELEMENT IN EXPRESSION

                                                         ; GET VALUE OF VARIABLE OR NUMBER AT TXTPNT, OR POINT
                                                         ; TO STRING DESCRIPTOR IF A STRING, AND PUT IN FAC.
                                                         ; --------------------------------
AS_FRM_ELEMENT:
                 LDA              #0                     ; ASSUME NUMERIC
                 STA              MS_Z_VALTYP
AS_L_FRM_ELEMENT_1: JSR              MS_Z_CHRGET
                 BCS              AS_L_FRM_ELEMENT_3     ; NOT A DIGIT
AS_L_FRM_ELEMENT_2: JMP              AS_FIN                 ; NUMERIC CONSTANT
AS_L_FRM_ELEMENT_3: JSR              AS_ISLETC              ; VARIABLE NAME?
                 BCS              AS_FRM_VARIABLE        ; YES
                 CMP              #"." & %01111111       ; DECIMAL POINT
                 BEQ              AS_L_FRM_ELEMENT_2     ; YES, NUMERIC CONSTANT
                 CMP              #MS_MINUTK             ; UNARY MINUS?
                 BEQ              AS_MIN                 ; YES
                 CMP              #MS_PLUSTK             ; UNARY PLUS
                 BEQ              AS_L_FRM_ELEMENT_1     ; YES
                 CMP              #$22                   ; STRING CONSTANT?
                 BNE              AS_NOT_                ; NO
                                                         ; --------------------------------
                                                         ; STRING CONSTANT ELEMENT

                                                         ; SET Y,A = (TXTPTR)+CARRY
                                                         ; --------------------------------
AS_STRTXT:       LDA              MS_Z_TXTPTR            ; ADD (CARRY) TO GET ADDRESS OF 1ST CHAR
                 LDY              MS_Z_TXTPTR + 1        ; OF STRING IN Y,A
                 ADC              #0
                 BCC              AS_L_STRTXT_1
                 INY
AS_L_STRTXT_1:   JSR              AS_STRLIT              ; BUILD DESCRIPTOR TO STRING
                                                         ; GET ADDRESS OF DESCRIPTOR IN FAC
                 JMP              AS_POINT               ; POINT TXTPTR AFTER TRAILING QUOTE
                                                         ; --------------------------------
                                                         ; "NOT" FUNCTION
                                                         ; IF FAC=0, RETURN FAC=1
                                                         ; IF FAC<>0, RETURN FAC=0
                                                         ; --------------------------------
AS_NOT_:         CMP              #MS_NOTTK
                 BNE              AS_FN_                 ; NOT "NOT", TRY "FN"
                 LDY              #MS_NOTTAB - MS_OPTAB  ; POINT AT = COMPARISON
                 BNE              AS_EQUL                ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; COMPARISON FOR EQUALITY (= OPERATOR)
                                                         ; ALSO USED TO EVALUATE "NOT" FUNCTION
                                                         ; --------------------------------
MS_NOTOP:        LDA              MS_Z_FAC               ; SET "TRUE" IF (FAC) = ZERO
                 BNE              AS_L_EQUOP_1           ; FALSE
                 LDY              #1                     ; TRUE
                    .BYTE $2C                       ; TRICK TO SKIP NEXT 2 BYTES
AS_L_EQUOP_1:    LDY              #0                     ; FALSE
                 JMP              AS_SNGFLT
                                                         ; --------------------------------
AS_FN_:          CMP              #MS_FNTK
                 BNE              AS_SGN_
                 JMP              AS_FUNCT
                                                         ; --------------------------------
AS_SGN_:         CMP              #MS_ONEFUN
                 BCC              AS_PARCHK
                 JMP              AS_UNARY
                                                         ; --------------------------------
                                                         ; EVALUATE "(EXPRESSION)"
                                                         ; --------------------------------
AS_PARCHK:       JSR              AS_CHKOPN              ; IS THERE A '(' AT TXTPTR?
                 JSR              AS_FRMEVL              ; YES, EVALUATE EXPRESSION
                                                         ; --------------------------------
AS_CHKCLS:       LDA              #$29                   ; CHECK FOR ')'
                    .BYTE $2C                       ; TRICK
                                                         ; --------------------------------
AS_CHKOPN:       LDA              #$28
                    .BYTE $2C                       ; TRICK
                                                         ; --------------------------------
AS_CHKCOM:       LDA              #"," & %01111111       ; COMMA AT TXTPTR?
                                                         ; --------------------------------
                                                         ; UNLESS CHAR AT TXTPTR = (A), SYNTAX ERROR
                                                         ; --------------------------------
AS_SYNCHR:       LDY              #0
                 CMP              (MS_Z_TXTPTR),Y
                 BNE              AS_SYNERR
                 JMP              MS_Z_CHRGET            ; MATCH, GET NEXT CHAR & RETURN
                                                         ; --------------------------------
AS_SYNERR:       LDX              #MS_ERRSN
                 JMP              MS_ERROR
                                                         ; --------------------------------
AS_MIN:          LDY              #MS_NEGTAB - MS_OPTAB  ; POINT AT UNARY MINUS
AS_EQUL:          PLA
                 PLA
                 JMP              AS_SAVOP
                                                         ; --------------------------------
AS_FRM_VARIABLE:
                 JSR              AS_PTRGET
AS_FRM_VARIABLE_CALL =                * - 1                  ; SO PTRGET CAN TELL WE CALLED
                 STA              AS_VPNT                ; ADDRESS OF VARIABLE
                 STY              AS_VPNT + 1
                 LDX              MS_Z_VALTYP            ; NUMERIC OR STRING?
                 BEQ              AS_L_FRM_VARIABLE_CALL_1 ; NUMERIC
                 LDX              #0                     ; STRING
                 STX              MS_Z_STRNG1 + 1
                 RTS
AS_L_FRM_VARIABLE_CALL_1: LDX              MS_Z_VALTYP + 1        ; NUMERIC, WHICH TYPE?
                 BPL              AS_L_FRM_VARIABLE_CALL_2 ; FLOATING POINT
                 LDY              #0                     ; INTEGER
                 LDA              (AS_VPNT),Y
                 TAX                                     ; GET VALUE IN A,Y
                 INY
                 LDA              (AS_VPNT),Y
                 TAY
                 TXA
                 JMP              AS_GIVAYF              ; CONVERT A,Y TO FLOATING POINT
AS_L_FRM_VARIABLE_CALL_2: JMP              AS_LOAD_FAC_FROM_YA
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; "SCRN(" FUNCTION
                                                         ; --------------------------------
AS_SCREEN:       JSR              MS_Z_CHRGET
                 JSR              AS_PLOTFNS             ; GET COLUMN AND ROW
                 TXA                                     ; ROW
                 LDY              AS_FIRST               ; COLUMN
                 JSR              MON_SCRN               ; GET 4-BIT COLOR THERE
                 TAY
                 JSR              AS_SNGFLT              ; CONVERT (Y) TO REAL IN FAC
                 JMP              AS_CHKCLS              ; REQUIRE ")"
                                                         ; --------------------------------
                                                         ; PROCESS UNARY OPERATORS (FUNCTIONS)
                                                         ; --------------------------------
AS_UNARY:        CMP              #AS_TOKEN_SCRN         ; NOT UNARY, DO SPECIAL
                 BEQ              AS_SCREEN
                 ASL                                     ; DOUBLE TOKEN TO GET INDEX
                 PHA
                 TAX
                 JSR              MS_Z_CHRGET
                 CPX              #<(AS_TOKEN_LEFTSTR * 2 - 1) ; LEFT$, RIGHT$, AND MID$
                 BCC              AS_L_UNARY_1           ; NOT ONE OF THE STRING FUNCTIONS
                 JSR              AS_CHKOPN              ; STRING FUNCTION, NEED "("
                 JSR              AS_FRMEVL              ; EVALUATE EXPRESSION FOR STRING
                 JSR              AS_CHKCOM              ; REQUIRE A COMMA
                 JSR              AS_CHKSTR              ; MAKE SURE EXPRESSION IS A STRING
                 PLA
                 TAX                                     ; RETRIEVE ROUTINE POINTER
                 LDA              AS_VPNT + 1            ; STACK ADDRESS OF STRING
                 PHA
                 LDA              AS_VPNT
                 PHA
                 TXA
                 PHA                                     ; STACK DOUBLED TOKEN
                 JSR              AS_GETBYT              ; CONVERT NEXT EXPRESSION TO BYTE IN X-REG
                 PLA                                     ; GET DOUBLED TOKEN OFF STACK
                 TAY                                     ; USE AS INDEX TO BRANCH
                 TXA                                     ; VALUE OF SECOND PARAMETER
                 PHA                                     ; PUSH 2ND PARAM
                 JMP              AS_L_UNARY_2           ; JOIN UNARY FUNCTIONS
AS_L_UNARY_1:    JSR              AS_PARCHK              ; REQUIRE "(EXPRESSION)"
                 PLA
                 TAY                                     ; INDEX INTO FUNCTION ADDRESS TABLE
AS_L_UNARY_2:    LDA              MS_FUNDSP - MS_ONEFUN - MS_ONEFUN + $100,Y
                 STA              MS_Z_JMPER + 1         ; PREPARE TO JSR TO ADDRESS
                 LDA              MS_FUNDSP - MS_ONEFUN - MS_ONEFUN + $101,Y
                 STA              MS_Z_JMPER + 2
                 JSR              MS_Z_JMPER             ; DOES NOT RETURN FOR
                                                         ; CHR$, LEFT$, RIGHT$, OR MID$
                 JMP              AS_CHKNUM              ; REQUIRE NUMERIC RESULT
                                                         ; --------------------------------
MS_OROP:         LDA              MS_Z_ARGEXP            ; "OR" OPERATOR
                 ORA              MS_Z_FAC               ; IF RESULT NONZERO, IT IS TRUE
                 BNE              AS_TRUE
                                                         ; --------------------------------
MS_ANDOP:        LDA              MS_Z_ARGEXP            ; "AND" OPERATOR
                 BEQ              AS_FALSE               ; IF EITHER IS ZERO, RESULT IS FALSE
                 LDA              MS_Z_FAC
                 BNE              AS_TRUE
                                                         ; --------------------------------
AS_FALSE:        LDY              #0                     ; RETURN FAC=0
                    .BYTE $2C                       ; TRICK
                                                         ; --------------------------------
AS_TRUE:         LDY              #1                     ; RETURN FAC=1
                 JMP              AS_SNGFLT
                                                         ; --------------------------------
                                                         ; PERFORM RELATIONAL OPERATIONS
                                                         ; --------------------------------
MS_DOREL:        JSR              AS_CHKVAL              ; MAKE SURE FAC IS CORRECT TYPE
                 BCS              AS_STRCMP              ; TYPE MATCHES, BRANCH IF STRINGS
                 LDA              MS_Z_ARGSGN            ; NUMERIC COMPARISON
                 ORA              #$7F                   ; RE-PACK VALUE IN ARG FOR FCOMP
                 AND              MS_Z_ARGEXP + 1
                 STA              MS_Z_ARGEXP + 1
                 LDA              #<MS_Z_ARGEXP
                 LDY              #>MS_Z_ARGEXP
                 JSR              AS_FCOMP               ; RETURN A-REG = -1,0,1
                 TAX                                     ; AS ARG <,=,> FAC
                 JMP              AS_NUMCMP
                                                         ; --------------------------------
                                                         ; STRING COMPARISON
                                                         ; --------------------------------
AS_STRCMP:       LDA              #0                     ; SET RESULT TYPE TO NUMERIC
                 STA              MS_Z_VALTYP
                 DEC              MS_Z_OPMASK            ; MAKE CPRTYP 0000<=>0
                 JSR              AS_FREFAC
                 STA              MS_Z_FAC               ; STRING LENGTH
                 STX              MS_Z_FAC + 1
                 STY              MS_Z_FAC + 2
                 LDA              MS_Z_ARGEXP + 3
                 LDY              MS_Z_ARGEXP + 4
                 JSR              AS_FRETMP
                 STX              MS_Z_ARGEXP + 3
                 STY              MS_Z_ARGEXP + 4
                 TAX                                     ; LEN (ARG) STRING
                 SEC
                 SBC              MS_Z_FAC               ; SET X TO SMALLER LEN
                 BEQ              AS_L_STRCMP_1
                 LDA              #1
                 BCC              AS_L_STRCMP_1
                 LDX              MS_Z_FAC
                 LDA              #$FF
AS_L_STRCMP_1:   STA              MS_Z_FACSGN            ; FLAG WHICH SHORTER
                 LDY              #$FF
                 INX
AS_STRCMP_1:
                 INY
                 DEX
                 BNE              AS_STRCMP_2            ; MORE CHARS IN BOTH STRINGS
                 LDX              MS_Z_FACSGN            ; IF = SO FAR, DECIDE BY LENGTH
                                                         ; --------------------------------
AS_NUMCMP:       BMI              AS_CMPDONE
                 CLC
                 BCC              AS_CMPDONE             ; ...ALWAYS
                                                         ; --------------------------------
AS_STRCMP_2:
                 LDA              (MS_Z_ARGEXP + 3),Y
                 CMP              (MS_Z_FAC + 1),Y
                 BEQ              AS_STRCMP_1            ; SAME, KEEP COMPARING
                 LDX              #$FF                   ; IN CASE ARG GREATER
                 BCS              AS_CMPDONE             ; IT IS
                 LDX              #1                     ; FAC GREATER
                                                         ; --------------------------------
AS_CMPDONE:
                 INX                                     ; CONVERT FF,0,1 TO 0,1,2
                 TXA
                 ROL                                     ; AND TO 0,2,4 IF C=0, ELSE 1,2,5
                 AND              AS_CPRMASK             ; 00000<=>
                 BEQ              AS_L_CMPDONE_1         ; IF NO MATCH: FALSE
                 LDA              #1                     ; AT LEAST ONE MATCH: TRUE
AS_L_CMPDONE_1:  JMP              AS_FLOAT
                                                         ; --------------------------------
                                                         ; "PDL" FUNCTION
                                                         ; <<< NOTE: ARG<4 IS NOT CHECKED >>>
                                                         ; --------------------------------
AS_PDL:          JSR              AS_CONINT              ; GET # IN X
                 JSR              MON_PREAD              ; READ PADDLE
                 JMP              AS_SNGFLT              ; FLOAT RESULT
                                                         ; --------------------------------
                                                         ; "DIM" STATEMENT
                                                         ; --------------------------------
AS_NXDIM:        JSR              AS_CHKCOM              ; SEPARATED BY COMMAS
MS_DIM:           TAX                    ; NON-ZERO, FLAGS PTRGET DIM CALLED
                 JSR              AS_PTRGET2             ; ALLOCATE THE ARRAY
                 JSR              MS_Z_CHRGOT            ; NEXT CHAR
                 BNE              AS_NXDIM               ; NOT END OF STATEMENT
                 RTS
                                                         ; --------------------------------
                                                         ; PTRGET -- GENERAL VARIABLE SCAN

                                                         ; SCANS VARIABLE NAME AT TXTPTR, AND SEARCHES THE
                                                         ; VARTAB AND ARYTAB FOR THE NAME.
                                                         ; IF NOT FOUND, CREATE VARIABLE OF APPROPRIATE TYPE.
                                                         ; RETURN WITH ADDRESS IN VARPNT AND Y,A

                                                         ; ACTUAL ACTIVITY CONTROLLED SOMEWHAT BY TWO FLAGS:
                                                         ; DIMFLG -- NONZERO IF CALLED FROM "DIM"
                                                         ; ELSE = 0

                                                         ; SUBFLG -- = $00
                                                         ; = $40 IF CALLED FROM "GETARYPT"
                                                         ; = $80 IF CALLED FROM "DEF FN"
                                                         ; = $C1-DA IF CALLED FROM "FN"
                                                         ; --------------------------------
AS_PTRGET:       LDX              #0
                 JSR              MS_Z_CHRGOT            ; GET FIRST CHAR OF VARIABLE NAME
                                                         ; --------------------------------
AS_PTRGET2:
                 STX              MS_Z_DIMFLG            ; X IS NONZERO IF FROM DIM
                                                         ; --------------------------------
AS_PTRGET3:
                 STA              MS_Z_VARNAM
                 JSR              MS_Z_CHRGOT
                 JSR              AS_ISLETC              ; IS IT A LETTER?
                 BCS              AS_NAMOK               ; YES, OKAY SO FAR
AS_BADNAM:       JMP              AS_SYNERR              ; NO, SYNTAX ERROR
AS_NAMOK:        LDX              #0
                 STX              MS_Z_VALTYP
                 STX              MS_Z_VALTYP + 1
                 JMP              AS_PTRGET4             ; TO BRANCH ACROSS $E000 VECTORS
                                                         ; --------------------------------
                                                         ; DOS AND MONITOR CALL BASIC AT $E000 AND $E003
                                                         ; --------------------------------
AS_BASIC:        JMP              AS_COLD_START
AS_BASIC2:       JMP              MS_MAIN
                 BRK                                     ; <<< WASTED BYTE >>>
                                                         ; --------------------------------
AS_PTRGET4:
                 JSR              MS_Z_CHRGET            ; SECOND CHAR OF VARIABLE NAME
                 BCC              AS_L_PTRGET4_1         ; NUMERIC
                 JSR              AS_ISLETC              ; LETTER?
                 BCC              AS_L_PTRGET4_3         ; NO, END OF NAME
AS_L_PTRGET4_1:   TAX                    ; SAVE SECOND CHAR OF NAME IN X
AS_L_PTRGET4_2:  JSR              MS_Z_CHRGET            ; SCAN TO END OF VARIABLE NAME
                 BCC              AS_L_PTRGET4_2         ; NUMERIC
                 JSR              AS_ISLETC
                 BCS              AS_L_PTRGET4_2         ; ALPHA
AS_L_PTRGET4_3:  CMP              #"$" & %01111111       ; STRING?
                 BNE              AS_L_PTRGET4_4         ; NO
                 LDA              #$FF
                 STA              MS_Z_VALTYP
                 BNE              AS_L_PTRGET4_5         ; ...ALWAYS
AS_L_PTRGET4_4:  CMP              #"%" & %01111111       ; INTEGER?
                 BNE              AS_L_PTRGET4_6         ; NO
                 LDA              MS_Z_SUBFLG            ; YES; INTEGER VARIABLE ALLOWED?
                 BMI              AS_BADNAM              ; NO, SYNTAX ERROR
                 LDA              #$80                   ; YES
                 STA              MS_Z_VALTYP + 1        ; FLAG INTEGER MODE
                 ORA              MS_Z_VARNAM
                 STA              MS_Z_VARNAM            ; SET SIGN BIT ON VARNAME
AS_L_PTRGET4_5:   TXA                    ; SECOND CHAR OF NAME
                 ORA              #$80                   ; SET SIGN
                 TAX
                 JSR              MS_Z_CHRGET            ; GET TERMINATING CHAR
AS_L_PTRGET4_6:  STX              MS_Z_VARNAM + 1        ; STORE SECOND CHAR OF NAME
                 SEC
                 ORA              MS_Z_SUBFLG            ; $00 OR $40 IF SUBSCRIPTS OK, ELSE $80
                 SBC              #$28                   ; IF SUBFLG=$00 AND CHAR="("...
                 BNE              AS_L_PTRGET4_8         ; NOPE
AS_L_PTRGET4_7:  JMP              AS_ARRAY               ; YES
AS_L_PTRGET4_8:  BIT              MS_Z_SUBFLG            ; CHECK TOP TWO BITS OF SUBFLG
                 BMI              AS_L_PTRGET4_9         ; $80
                 BVS              AS_L_PTRGET4_7         ; $40, CALLED FROM GETARYPT
AS_L_PTRGET4_9:  LDA              #0                     ; CLEAR SUBFLG
                 STA              MS_Z_SUBFLG
                 LDA              MS_Z_VARTAB            ; START LOWTR AT SIMPLE VARIABLE TABLE
                 LDX              MS_Z_VARTAB + 1
                 LDY              #0
AS_L_PTRGET4_10: STX              MS_Z_LOWTR + 1
AS_L_PTRGET4_11: STA              MS_Z_LOWTR
                 CPX              MS_Z_ARYTAB + 1        ; END OF SIMPLE VARIABLES?
                 BNE              AS_L_PTRGET4_12        ; NO, GO ON
                 CMP              MS_Z_ARYTAB            ; YES; END OF ARRAYS?
                 BEQ              AS_NAME_NOT_FOUND      ; YES, MAKE ONE
AS_L_PTRGET4_12: LDA              MS_Z_VARNAM            ; SAME FIRST LETTER?
                 CMP              (MS_Z_LOWTR),Y
                 BNE              AS_L_PTRGET4_13        ; NOT SAME FIRST LETTER
                 LDA              MS_Z_VARNAM + 1        ; SAME SECOND LETTER?
                 INY
                 CMP              (MS_Z_LOWTR),Y
                 BEQ              AS_SET_VARPNT_AND_YA   ; YES, SAME VARIABLE NAME
                 DEY                                     ; NO, BUMP TO NEXT NAME
AS_L_PTRGET4_13:  CLC
                 LDA              MS_Z_LOWTR
                 ADC              #7
                 BCC              AS_L_PTRGET4_11
                 INX
                 BNE              AS_L_PTRGET4_10        ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; CHECK IF (A) IS ASCII LETTER A-Z

                                                         ; RETURN CARRY = 1 IF A-Z
                                                         ; = 0 IF NOT

                                                         ; <<<NOTE FASTER AND SHORTER CODE:    >>>
                                                         ; <<<    CMP #LOCHAR(`Z')+1  COMPARE HI END
                                                         ; <<<    BCS L_PTRGET4_1      ABOVE A-Z
                                                         ; <<<    CMP #LOCHAR(`A')    COMPARE LO END
                                                         ; <<<    RTS         C=0 IF LO, C=1 IF A-Z
                                                         ; <<<L_PTRGET4_1  CLC         C=0 IF HI
                                                         ; <<<    RTS
                                                         ; --------------------------------
AS_ISLETC:       CMP              #"A" & %01111111       ; COMPARE LO END
                 BCC              AS_L_ISLETC_1          ; C=0 IF LOW
                 SBC              #("Z" & %01111111) + 1 ; PREPARE HI END TEST
                 SEC                                     ; TEST HI END, RESTORING (A)
                 SBC              #255 - 'Z'             ; C=0 IF LO, C=1 IF A-Z
AS_L_ISLETC_1:    RTS
                                                         ; --------------------------------
                                                         ; VARIABLE NOT FOUND, SO MAKE ONE
                                                         ; --------------------------------
AS_NAME_NOT_FOUND:
                 PLA                                     ; LOOK AT RETURN ADDRESS ON STACK TO
                 PHA                                     ; SEE IF CALLED FROM FRM.VARIABLE
                 CMP              #<AS_FRM_VARIABLE_CALL
                 BNE              AS_MAKE_NEW_VARIABLE   ; NO
                 TSX
                 LDA              AS_STACK + 2,X
                 CMP              #>AS_FRM_VARIABLE_CALL
                 BNE              AS_MAKE_NEW_VARIABLE   ; NO
                 LDA              #<AS_C_ZERO            ; YES, CALLED FROM FRM.VARIABLE
                 LDY              #>AS_C_ZERO            ; POINT TO A CONSTANT ZERO
                 RTS                                     ; NEW VARIABLE USED IN EXPRESSION = 0
                                                         ; --------------------------------
AS_C_ZERO              .BYTE 00,00                     ; INTEGER OR REAL ZERO, OR NULL STRING
                                                         ; --------------------------------
                                                         ; MAKE A NEW SIMPLE VARIABLE

                                                         ; MOVE ARRAYS UP 7 BYTES TO MAKE ROOM FOR NEW VARIABLE
                                                         ; ENTER 7-BYTE VARIABLE DATA IN THE HOLE
                                                         ; --------------------------------
AS_MAKE_NEW_VARIABLE:
                 LDA              MS_Z_ARYTAB            ; SET UP CALL TO BLTU TO
                 LDY              MS_Z_ARYTAB + 1        ; TO MOVE FROM ARYTAB THRU STREND-1
                 STA              MS_Z_LOWTR             ; 7 BYTES HIGHER
                 STY              MS_Z_LOWTR + 1
                 LDA              MS_Z_STREND
                 LDY              MS_Z_STREND + 1
                 STA              MS_Z_HIGHTR
                 STY              MS_Z_HIGHTR + 1
                 CLC
                 ADC              #7
                 BCC              AS_L_MAKE_NEW_VARIABLE_1
                 INY
AS_L_MAKE_NEW_VARIABLE_1: STA              MS_Z_ARYPNT
                 STY              MS_Z_ARYPNT + 1
                 JSR              MS_BLTU                ; MOVE ARRAY BLOCK UP
                 LDA              MS_Z_ARYPNT            ; STORE NEW START OF ARRAYS
                 LDY              MS_Z_ARYPNT + 1
                 INY
                 STA              MS_Z_ARYTAB
                 STY              MS_Z_ARYTAB + 1
                 LDY              #0
                 LDA              MS_Z_VARNAM            ; FIRST CHAR OF NAME
                 STA              (MS_Z_LOWTR),Y
                 INY
                 LDA              MS_Z_VARNAM + 1        ; SECOND CHAR OF NAME
                 STA              (MS_Z_LOWTR),Y
                 LDA              #0                     ; SET FIVE-BYTE VALUE TO 0
                 INY
                 STA              (MS_Z_LOWTR),Y
                 INY
                 STA              (MS_Z_LOWTR),Y
                 INY
                 STA              (MS_Z_LOWTR),Y
                 INY
                 STA              (MS_Z_LOWTR),Y
                 INY
                 STA              (MS_Z_LOWTR),Y
                                                         ; --------------------------------
                                                         ; PUT ADDRESS OF VALUE OF VARIABLE IN VARPNT AND Y,A
                                                         ; --------------------------------
AS_SET_VARPNT_AND_YA:
                 LDA              MS_Z_LOWTR             ; LOWTR POINTS AT NAME OF VARIABLE,
                 CLC                                     ; SO ADD 2 TO GET TO VALUE
                 ADC              #2
                 LDY              MS_Z_LOWTR + 1
                 BCC              AS_L_SET_VARPNT_AND_YA_1
                 INY
AS_L_SET_VARPNT_AND_YA_1: STA              MS_Z_VARPNT            ; ADDRESS IN VARPNT AND Y,A
                 STY              MS_Z_VARPNT + 1
                 RTS
                                                         ; --------------------------------
                                                         ; COMPUTE ADDRESS OF FIRST VALUE IN ARRAY
                                                         ; ARYPNT = (LOWTR) + #DIMS*2 + 5
                                                         ; --------------------------------
AS_GETARY:       LDA              AS_NUMDIM              ; GET # OF DIMENSIONS
                                                         ; --------------------------------
AS_GETARY2:
                 ASL                                     ; #DIMS*2 (SIZE OF EACH DIM IN 2 BYTES)
                 ADC              #5                     ; + 5 (2 FOR NAME, 2 FOR OFFSET TO NEXT
                                                         ; ARRAY, AND 1 FOR #DIMS
                 ADC              MS_Z_LOWTR             ; ADDRESS OF TH IS ARRAY IN ARYTAB
                 LDY              MS_Z_LOWTR + 1
                 BCC              AS_L_GETARY2_1
                 INY
AS_L_GETARY2_1:  STA              MS_Z_ARYPNT            ; ADDRESS OF FIRST VALUE IN ARRAY
                 STY              MS_Z_ARYPNT + 1
                 RTS
                                                         ; --------------------------------

AS_NEG32768            .BYTE $90,$80,$00,$00           ; -32768.00049 IN FLOATING POINT
                                                         ; <<<  MEANT TO BE -32768, WHICH WOULD BE 9080000000 >>>
                                                         ; <<<  1 BYTE SHORT, SO PICKS UP $20 FROM NEXT INSTRUCTION
                                                         ; --------------------------------
                                                         ; EVALUATE NUMERIC FORMULA AT TXTPTR
                                                         ; CONVERTING RESULT TO INTEGER 0 <= X <= 32767
                                                         ; IN FAC+3,4
                                                         ; --------------------------------
AS_MAKINT:       JSR              MS_Z_CHRGET
                 JSR              AS_FRMNUM
                                                         ; --------------------------------
                                                         ; CONVERT FAC TO INTEGER
                                                         ; MUST BE POSITIVE AND LESS THAN 32768
                                                         ; --------------------------------
AS_MKINT:        LDA              MS_Z_FACSGN            ; ERROR IF -
                 BMI              AS_MI1
                                                         ; --------------------------------
                                                         ; CONVERT FAC TO INTEGER
                                                         ; MUST BE -32767 <= FAC <= 32767
                                                         ; --------------------------------
AS_AYINT:        LDA              MS_Z_FAC               ; EXPONENT OF VALUE IN FAC
                 CMP              #$90                   ; ABS(VALUE) < 32768?
                 BCC              AS_MI2                 ; YES, OK FOR INTEGER
                 LDA              #<AS_NEG32768          ; NO; NEXT FEW LINES ARE SUPPOSED TO
                 LDY              #>AS_NEG32768          ; ALLOW -32768 ($8000), BUT DO NOT!
                 JSR              AS_FCOMP               ; BECAUSE COMPARED TO -32768.00049
                                                         ; <<< BUG:  A=-32768.00049:A%=A IS ACCEPTED >>>
                                                         ; <<<       BUT PRINT A,A% SHOWS THAT       >>>
                                                         ; <<<       A=-32768.0005 (OK), A%=32767    >>>
                                                         ; <<<       WRONG! WRONG! WRONG!            >>>
                                                         ; --------------------------------
AS_MI1:          BNE              AS_IQERR               ; ILLEGAL QUANTITY
AS_MI2:          JMP              AS_QINT                ; CONVERT TO INTEGER
                                                         ; --------------------------------
                                                         ; LOCATE ARRAY ELEMENT OR CREATE AN ARRAY
                                                         ; --------------------------------
AS_ARRAY:        LDA              MS_Z_SUBFLG            ; SUBSCRIPTS GIVEN?
                 BNE              AS_L_ARRAY_2           ; NO
                                                         ; --------------------------------
                                                         ; PARSE THE SUBSCRIPT LIST
                                                         ; --------------------------------
                 LDA              MS_Z_DIMFLG            ; YES
                 ORA              MS_Z_VALTYP + 1        ; SET HIGH BIT IF %
                 PHA                                     ; SAVE VALTYP AND DIMFLG ON STACK
                 LDA              MS_Z_VALTYP
                 PHA
                 LDY              #0                     ; COUNT # DIMENSIONS IN Y-REG
AS_L_ARRAY_1:     TYA                    ; SAVE #DIMS ON STACK
                 PHA
                 LDA              MS_Z_VARNAM + 1        ; SAVE VARIABLE NAME ON STACK
                 PHA
                 LDA              MS_Z_VARNAM
                 PHA
                 JSR              AS_MAKINT              ; EVALUATE SUBSCRIPT AS INTEGER
                 PLA                                     ; RESTORE VARIABLE NAME
                 STA              MS_Z_VARNAM
                 PLA
                 STA              MS_Z_VARNAM + 1
                 PLA                                     ; RESTORE # DIMS TO Y-REG
                 TAY
                 TSX                                     ; COPY VALTYP AND DIMFLG ON STACK
                 LDA              AS_STACK + 2,X         ; TO LEAVE ROOM FOR THE SUBSCRIPT
                 PHA
                 LDA              AS_STACK + 1,X
                 PHA
                 LDA              MS_Z_FAC + 3           ; GET SUBSCRIPT VALUE AND PLACE IN THE
                 STA              AS_STACK + 2,X         ; STACK WHERE VALTYP & DIMFLG WERE
                 LDA              MS_Z_FAC + 4
                 STA              AS_STACK + 1,X
                 INY                                     ; COUNT THE SUBSCRIPT
                 JSR              MS_Z_CHRGOT            ; NEXT CHAR
                 CMP              #"," & %01111111
                 BEQ              AS_L_ARRAY_1           ; COMMA, PARSE ANOTHER SUBSCRIPT
                 STY              AS_NUMDIM              ; NO MORE SUBSCRIPTS, SAVE #
                 JSR              AS_CHKCLS              ; NOW NEED ")"
                 PLA                                     ; RESTORE VALTYPE AND DIMFLG
                 STA              MS_Z_VALTYP
                 PLA
                 STA              MS_Z_VALTYP + 1
                 AND              #$7F                   ; ISOLATE DIMFLG
                 STA              MS_Z_DIMFLG
                                                         ; --------------------------------
                                                         ; SEARCH ARRAY TABLE FOR THIS ARRAY NAME
                                                         ; --------------------------------
AS_L_ARRAY_2:    LDX              MS_Z_ARYTAB            ; (A,X) = START OF ARRAY TABLE
                 LDA              MS_Z_ARYTAB + 1
AS_L_ARRAY_3:    STX              MS_Z_LOWTR             ; USE LOWTR FOR RUNNING POINTER
                 STA              MS_Z_LOWTR + 1
                 CMP              MS_Z_STREND + 1        ; DID WE REACH THE END OF ARRAYS YET?
                 BNE              AS_L_ARRAY_4           ; NO, KEEP SEARCHING
                 CPX              MS_Z_STREND
                 BEQ              AS_MAKE_NEW_ARRAY      ; YES, THIS IS A NEW ARRAY NAME
AS_L_ARRAY_4:    LDY              #0                     ; POINT AT 1ST CHAR OF ARRAY NAME
                 LDA              (MS_Z_LOWTR),Y         ; GET 1ST CHAR OF NAME
                 INY                                     ; POINT AT 2ND CHAR
                 CMP              MS_Z_VARNAM            ; 1ST CHAR SAME?
                 BNE              AS_L_ARRAY_5           ; NO, MOVE TO NEXT ARRAY
                 LDA              MS_Z_VARNAM + 1        ; YES, TRY 2ND CHAR
                 CMP              (MS_Z_LOWTR),Y         ; SAME?
                 BEQ              AS_USE_OLD_ARRAY       ; YES, ARRAY FOUND
AS_L_ARRAY_5:     INY                    ; POINT AT OFFSET TO NEXT ARRAY
                 LDA              (MS_Z_LOWTR),Y         ; ADD OFFSET TO RUNNING POINTER
                 CLC
                 ADC              MS_Z_LOWTR
                 TAX
                 INY
                 LDA              (MS_Z_LOWTR),Y
                 ADC              MS_Z_LOWTR + 1
                 BCC              AS_L_ARRAY_3           ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; ERROR:  BAD SUBSCRIPTS
                                                         ; --------------------------------
AS_SUBERR:       LDX              #MS_ERRBS
                    .BYTE $2C                       ; TRICK TO SKIP NEXT LINE
                                                         ; --------------------------------
                                                         ; ERROR:  ILLEGAL QUANTITY
                                                         ; --------------------------------
AS_IQERR:        LDX              #MS_ERRFC
AS_JER:          JMP              MS_ERROR
                                                         ; --------------------------------
                                                         ; FOUND THE ARRAY
                                                         ; --------------------------------
AS_USE_OLD_ARRAY:
                 LDX              #MS_ERRDD              ; SET UP FOR REDIM'D ARRAY ERROR
                 LDA              MS_Z_DIMFLG            ; CALLED FROM "DIM" STATEMENT?
                 BNE              AS_JER                 ; YES, ERROR
                 LDA              MS_Z_SUBFLG            ; NO, CHECK IF ANY SUBSCRIPTS
                 BEQ              AS_L_USE_OLD_ARRAY_1   ; YES, NEED TO CHECK THE NUMBER
                 SEC                                     ; NO, SIGNAL ARRAY FOUND
                 RTS
                                                         ; --------------------------------
AS_L_USE_OLD_ARRAY_1: JSR              AS_GETARY              ; SET (ARYPNT) = ADDR OF FIRST ELEMENT
                 LDA              AS_NUMDIM              ; COMPARE NUMBER OF DIMENSIONS
                 LDY              #4
                 CMP              (MS_Z_LOWTR),Y
                 BNE              AS_SUBERR              ; NOT SAME, SUBSCRIPT ERROR
                 JMP              AS_FIND_ARRAY_ELEMENT
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; CREATE A NEW ARRAY, UNLESS CALLED FROM GETARYPT
                                                         ; --------------------------------
AS_MAKE_NEW_ARRAY:
                 LDA              MS_Z_SUBFLG            ; CALLED FROM GETARYPT?
                 BEQ              AS_L_MAKE_NEW_ARRAY_1  ; NO
                 LDX              #MS_ERROD              ; YES, GIVE "OUT OF DATA" ERROR
                 JMP              MS_ERROR
AS_L_MAKE_NEW_ARRAY_1: JSR              AS_GETARY              ; PUT ADDR OF 1ST ELEMENT IN ARYPNT
                 JSR              MS_REASON              ; MAKE SURE ENOUGH MEMORY LEFT
                                                         ; --------------------------------
                                                         ; <<< NEXT 3 LINES COULD BE WRITTEN:   >>>
                                                         ; LDY #0
                                                         ; STY STRNG2+1
                                                         ; --------------------------------
                 LDA              #0                     ; POINT Y-REG AT VARIABLE NAME SLOT
                 TAY
                 STA              MS_Z_STRNG2 + 1        ; START SIZE COMPUTATION
                 LDX              #5                     ; ASSUME 5-BYTES PER ELEMENT
                 LDA              MS_Z_VARNAM            ; STUFF VARIABLE NAME IN ARRAY
                 STA              (MS_Z_LOWTR),Y
                 BPL              AS_L_MAKE_NEW_ARRAY_2  ; NOT INTEGER ARRAY
                 DEX                                     ; INTEGER ARRAY, DECR. SIZE TO 4-BYTES
AS_L_MAKE_NEW_ARRAY_2: INY                    ; POINT Y-REG AT NEXT CHAR OF NAME
                 LDA              MS_Z_VARNAM + 1        ; REST OF ARRAY NAME
                 STA              (MS_Z_LOWTR),Y
                 BPL              AS_L_MAKE_NEW_ARRAY_3  ; REAL ARRAY, STICK WITH SIZE = 5 BYTES
                 DEX                                     ; INTEGER OR STRING ARRAY, ADJUST SIZE
                 DEX                                     ; TO INTEGER=3, STRING=2 BYTES
AS_L_MAKE_NEW_ARRAY_3: STX              MS_Z_STRNG2            ; STORE LOW-BYTE OF ARRAY ELEMENT SIZE
                 LDA              AS_NUMDIM              ; STORE NUMBER OF DIMENSIONS
                 INY                                     ; IN 5TH BYTE OF ARRAY
                 INY
                 INY
                 STA              (MS_Z_LOWTR),Y
AS_L_MAKE_NEW_ARRAY_4: LDX              #11                    ; DEFAULT DIMENSION = 11 ELEMENTS
                 LDA              #0                     ; FOR HI-BYTE OF DIMENSION IF DEFAULT
                 BIT              MS_Z_DIMFLG            ; DIMENSIONED ARRAY?
                 BVC              AS_L_MAKE_NEW_ARRAY_5  ; NO, USE DEFAULT VALUE
                 PLA                                     ; GET SPECIFIED DIM IN A,X
                 CLC                                     ; # ELEMENTS IS 1 LARGER THAN
                 ADC              #1                     ; DIMENSION VALUE
                 TAX
                 PLA
                 ADC              #0
AS_L_MAKE_NEW_ARRAY_5: INY                    ; ADD THIS DIMENSION TO ARRAY DESCRIPTOR
                 STA              (MS_Z_LOWTR),Y
                 INY
                 TXA
                 STA              (MS_Z_LOWTR),Y
                 JSR              AS_MULTIPLY_SUBSCRIPT  ; MULTIPLY THIS
                                                         ; DIMENSION BY RUNNING SIZE
                                                         ; ((LOWTR)) * (STRNG2) --> A,X
                 STX              MS_Z_STRNG2            ; STORE RUNNING SIZE IN STRNG2
                 STA              MS_Z_STRNG2 + 1
                 LDY              MS_Z_INDEX             ; RETRIEVE Y SAVED BY MULTIPLY.SUBSCRIPT
                 DEC              AS_NUMDIM              ; COUNT DOWN # DIMS
                 BNE              AS_L_MAKE_NEW_ARRAY_4  ; LOOP TILL DONE
                                                         ; --------------------------------
                                                         ; NOW A,X HAS TOTAL # BYTES OF ARRAY ELEMENTS
                                                         ; --------------------------------
                 ADC              MS_Z_ARYPNT + 1        ; COMPUTE ADDRESS OF END OF THIS ARRAY
                 BCS              AS_GME                 ; ...TOO LARGE, ERROR
                 STA              MS_Z_ARYPNT + 1
                 TAY
                 TXA
                 ADC              MS_Z_ARYPNT
                 BCC              AS_L_MAKE_NEW_ARRAY_6
                 INY
                 BEQ              AS_GME                 ; ...TOO LARGE, ERROR
AS_L_MAKE_NEW_ARRAY_6: JSR              MS_REASON              ; MAKE SURE THERE IS ROOM UP TO Y,A
                 STA              MS_Z_STREND            ; THERE IS ROOM SO SAVE NEW END OF TABLE
                 STY              MS_Z_STREND + 1        ; AND ZERO THE ARRAY
                 LDA              #0
                 INC              MS_Z_STRNG2 + 1        ; PREPARE FOR FAST ZEROING LOOP
                 LDY              MS_Z_STRNG2            ; # BYTES MOD 256
                 BEQ              AS_L_MAKE_NEW_ARRAY_8  ; FULL PAGE
AS_L_MAKE_NEW_ARRAY_7: DEY                    ; CLEAR PAGE FULL
                 STA              (MS_Z_ARYPNT),Y
                 BNE              AS_L_MAKE_NEW_ARRAY_7
AS_L_MAKE_NEW_ARRAY_8: DEC              MS_Z_ARYPNT + 1        ; POINT TO NEXT PAGE
                 DEC              MS_Z_STRNG2 + 1        ; COUNT THE PAGES
                 BNE              AS_L_MAKE_NEW_ARRAY_7  ; STILL MORE TO CLEAR
                 INC              MS_Z_ARYPNT + 1        ; RECOVER LAST DEC, POINT AT 1ST ELEMENT
                 SEC
                 LDA              MS_Z_STREND            ; COMPUTE OFFSET TO END OF ARRAYS
                 SBC              MS_Z_LOWTR             ; AND STORE IN ARRAY DESCRIPTOR
                 LDY              #2
                 STA              (MS_Z_LOWTR),Y
                 LDA              MS_Z_STREND + 1
                 INY
                 SBC              MS_Z_LOWTR + 1
                 STA              (MS_Z_LOWTR),Y
                 LDA              MS_Z_DIMFLG            ; WAS THIS CALLED FROM "DIM" STATEMENT?
                 BNE              AS_RTS_9               ; YES, WE ARE FINISHED
                 INY                                     ; NO, NOW NEED TO FIND THE ELEMENT
                                                         ; --------------------------------
                                                         ; FIND SPECIFIED ARRAY ELEMENT

                                                         ; (LOWTR),Y POINTS AT # OF DIMS IN ARRAY DESCRIPTOR
                                                         ; THE SUBSCRIPTS ARE ALL ON THE STACK AS INTEGERS
                                                         ; --------------------------------
AS_FIND_ARRAY_ELEMENT:
                 LDA              (MS_Z_LOWTR),Y         ; GET # OF DIMENSIONS
                 STA              AS_NUMDIM
                 LDA              #0                     ; ZERO SUBSCRIPT ACCUMULATOR
                 STA              MS_Z_STRNG2
AS_FAE_1:        STA              MS_Z_STRNG2 + 1
                 INY
                 PLA                                     ; PULL NEXT SUBSCRIPT FROM STACK
                 TAX                                     ; SAVE IN FAC+3,4
                 STA              MS_Z_FAC + 3           ; AND COMPARE WITH DIMENSIONED SIZE
                 PLA
                 STA              MS_Z_FAC + 4
                 CMP              (MS_Z_LOWTR),Y
                 BCC              AS_FAE_2               ; SUBSCRIPT NOT TOO LARGE
                 BNE              AS_GSE                 ; SUBSCRIPT IS TOO LARGE
                 INY                                     ; CHECK LOW-BYTE OF SUBSCRIPT
                 TXA
                 CMP              (MS_Z_LOWTR),Y
                 BCC              AS_FAE_3               ; NOT TOO LARGE
                                                         ; --------------------------------
AS_GSE:          JMP              AS_SUBERR              ; BAD SUBSCRIPTS ERROR
AS_GME:          JMP              MS_OMERR               ; MEM FULL ERROR
                                                         ; --------------------------------
AS_FAE_2:         INY                    ; BUMP POINTER INTO DESCRIPTOR
AS_FAE_3:        LDA              MS_Z_STRNG2 + 1        ; BYPASS MULTIPLICATION IF VALUE SO
                 ORA              MS_Z_STRNG2            ; FAR = 0
                 CLC
                 BEQ              AS_L_FAE_3_1           ; IT IS ZERO SO FAR
                 JSR              AS_MULTIPLY_SUBSCRIPT  ; NOT ZERO, SO MULTIPLY
                 TXA                                     ; ADD CURRENT SUBSCRIPT
                 ADC              MS_Z_FAC + 3
                 TAX
                 TYA
                 LDY              MS_Z_INDEX             ; RETRIEVE Y SAVED BY MULTIPLY.SUBSCRIPT
AS_L_FAE_3_1:    ADC              MS_Z_FAC + 4           ; FINISH ADDING CURRENT SUBSCRIPT
                 STX              MS_Z_STRNG2            ; STORE ACCUMULATED OFFSET
                 DEC              AS_NUMDIM              ; LAST SUBSCRIPT YET?
                 BNE              AS_FAE_1               ; NO, LOOP TILL DONE
                 STA              MS_Z_STRNG2 + 1        ; YES, NOW MULTIPLY BE ELEMENT SIZE
                 LDX              #5                     ; START WITH SIZE = 5
                 LDA              MS_Z_VARNAM            ; DETERMINE VARIABLE TYPE
                 BPL              AS_L_FAE_3_2           ; NOT INTEGER
                 DEX                                     ; INTEGER, BACK DOWN SIZE TO 4 BYTES
AS_L_FAE_3_2:    LDA              MS_Z_VARNAM + 1        ; DISCRIMINATE BETWEEN REAL AND STR
                 BPL              AS_L_FAE_3_3           ; IT IS REAL
                 DEX                                     ; SIZE = 3 IF STRING, =2 IF INTEGER
                 DEX
AS_L_FAE_3_3:    STX              AS_RESULT + 2          ; SET UP MULTIPLIER
                 LDA              #0                     ; HI-BYTE OF MULTIPLIER
                 JSR              AS_MULTIPLY_SUBS_1     ; (STRNG2) BY ELEMENT SIZE
                 TXA                                     ; ADD ACCUMULATED OFFSET
                 ADC              MS_Z_ARYPNT            ; TO ADDRESS OF 1ST ELEMENT
                 STA              MS_Z_VARPNT            ; TO GET ADDRESS OF SPECIFIED ELEMENT
                 TYA
                 ADC              MS_Z_ARYPNT + 1
                 STA              MS_Z_VARPNT + 1
                 TAY                                     ; RETURN WITH ADDR IN VARPNT
                 LDA              MS_Z_VARPNT            ; AND IN Y,A
AS_RTS_9:         RTS
                                                         ; --------------------------------
                                                         ; MULTIPLY (STRNG2) BY ((LOWTR),Y)
                                                         ; LEAVING PRODUCT IN A,X.  (HI-BYTE ALSO IN Y.)
                                                         ; USED ONLY BY ARRAY SUBSCRIPT ROUTINES
                                                         ; --------------------------------
AS_MULTIPLY_SUBSCRIPT:
                 STY              MS_Z_INDEX             ; SAVE Y-REG
                 LDA              (MS_Z_LOWTR),Y         ; GET MULTIPLIER
                 STA              AS_RESULT + 2          ; SAVE IN RESULT+2,3
                 DEY
                 LDA              (MS_Z_LOWTR),Y
                                                         ; --------------------------------
AS_MULTIPLY_SUBS_1:
                 STA              AS_RESULT + 3          ; LOW BYTE OF MULTIPLIER
                 LDA              #16                    ; MULTIPLY 16 BITS
                 STA              AS_INDX
                 LDX              #0                     ; PRODUCT = 0 INITIALLY
                 LDY              #0
AS_L_MULTIPLY_SUBS_1_1: TXA                    ; DOUBLE PRODUCT
                 ASL                                     ; LOW BYTE
                 TAX
                 TYA                                     ; HIGH BYTE
                 ROL                                     ; IF TOO LARGE, SET CARRY
                 TAY
                 BCS              AS_GME                 ; TOO LARGE, "MEM FULL ERROR"
                 ASL              MS_Z_STRNG2            ; NEXT BIT OF MUTLPLICAND
                 ROL              MS_Z_STRNG2 + 1        ; INTO CARRY
                 BCC              AS_L_MULTIPLY_SUBS_1_2 ; BIT=0, DON'T NEED TO ADD
                 CLC                                     ; BIT=1, ADD INTO PARTIAL PRODUCT
                 TXA
                 ADC              AS_RESULT + 2
                 TAX
                 TYA
                 ADC              AS_RESULT + 3
                 TAY
                 BCS              AS_GME                 ; TOO LARGE, "MEM FULL ERROR"
AS_L_MULTIPLY_SUBS_1_2: DEC              AS_INDX                ; 16-BITS YET?
                 BNE              AS_L_MULTIPLY_SUBS_1_1 ; NO, KEEP SHUFFLING
                 RTS                                     ; YES, PRODUCT IN Y,X AND A,X
                                                         ; --------------------------------
                                                         ; "FRE" FUNCTION

                                                         ; COLLECTS GARBAGE AND RETURNS # BYTES OF MEMORY LEFT
                                                         ; --------------------------------
MS_FRE:          LDA              MS_Z_VALTYP            ; LOOK AT VALUE OF ARGUMENT
                 BEQ              AS_L_FRE_1             ; =0 MEANS REAL, =$FF MEANS STRING
                 JSR              AS_FREFAC              ; STRING, SO SET IT FREE IS TEMP
AS_L_FRE_1:      JSR              MS_GARBA2              ; COLLECT ALL THE GARBAGE IN SIGHT
                 SEC                                     ; COMPUTE SPACE BETWEEN ARRAYS AND
                 LDA              MS_Z_FRETOP            ; STRING TEMP AREA
                 SBC              MS_Z_STREND
                 TAY
                 LDA              MS_Z_FRETOP + 1
                 SBC              MS_Z_STREND + 1        ; FREE SPACE IN Y,A
                                                         ; FALL INTO GIVAYF TO FLOAT THE VALUE
                                                         ; NOTE THAT VALUES OVER 32767 WILL RETURN AS NEGATIVE
                                                         ; --------------------------------
                                                         ; FLOAT THE SIGNED INTEGER IN A,Y
                                                         ; --------------------------------
AS_GIVAYF:       LDX              #0                     ; MARK FAC VALUE TYPE REAL
                 STX              MS_Z_VALTYP
                 STA              MS_Z_FAC + 1           ; SAVE VALUE FROM A,Y IN MANTISSA
                 STY              MS_Z_FAC + 2
                 LDX              #$90                   ; SET EXPONENT TO 2^16
                 JMP              AS_FLOAT_1             ; CONVERT TO SIGNED FP
                                                         ; --------------------------------
                                                         ; "POS" FUNCTION

                                                         ; RETURNS CURRENT LINE POSITION FROM MON.CH
                                                         ; --------------------------------
MS_POS:          LDY              MON_CH                 ; GET A,Y = (MON.CH, GO TO GIVAYF
                                                         ; --------------------------------
                                                         ; FLOAT (Y) INTO FAC, GIVING VALUE 0-255
                                                         ; --------------------------------
AS_SNGFLT:       LDA              #0                     ; MSB = 0
                 SEC                                     ; <<< NO PURPOSE WHATSOEVER >>>
                 BEQ              AS_GIVAYF              ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; CHECK FOR DIRECT OR RUNNING MODE
                                                         ; GIVING ERROR IF DIRECT MODE
                                                         ; --------------------------------
AS_ERRDIR:       LDX              MS_Z_CURLIN + 1        ; =$FF IF DIRECT MODE
                 INX                                     ; MAKES $FF INTO ZERO
                 BNE              AS_RTS_9               ; RETURN IF RUNNING MODE
                 LDX              #MS_ERRID              ; DIRECT MODE, GIVE ERROR
                    .BYTE $2C                       ; TRICK TO SKIP NEXT 2 BYTES
                                                         ; --------------------------------
AS_UNDFNC:       LDX              #MS_ERRUF              ; UNDEFINDED FUNCTION ERROR
                 JMP              MS_ERROR
                                                         ; --------------------------------
                                                         ; "DEF" STATEMENT
                                                         ; --------------------------------
MS_DEF:          JSR              AS_FNC_                ; PARSE "FN", FUNCTION NAME
                 JSR              AS_ERRDIR              ; ERROR IF IN DIRECT MODE
                 JSR              AS_CHKOPN              ; NEED "("
                 LDA              #$80                   ; FLAG PTRGET THAT CALLED FROM "DEF FN"
                 STA              MS_Z_SUBFLG            ; ALLOW ONLY SIMPLE FP VARIABLE FOR ARG
                 JSR              AS_PTRGET              ; GET PNTR TO ARGUMENT
                 JSR              AS_CHKNUM              ; MUST BE NUMERIC
                 JSR              AS_CHKCLS              ; MUST HAVE ")" NOW
                 LDA              #MS_EQULTK             ; NOW NEED "="
                 JSR              AS_SYNCHR              ; OR ELSE SYNTAX ERROR
                 PHA                                     ; SAVE CHAR AFTER "="
                 LDA              MS_Z_VARPNT + 1        ; SAVE PNTR TO ARGUMENT
                 PHA
                 LDA              MS_Z_VARPNT
                 PHA
                 LDA              MS_Z_TXTPTR + 1        ; SAVE TXTPTR
                 PHA
                 LDA              MS_Z_TXTPTR
                 PHA
                 JSR              MS_DATA                ; SCAN TO NEXT STATEMENT
                 JMP              AS_FNCDATA             ; STORE ABOVE 5 BYTES IN "VALUE"
                                                         ; --------------------------------
                                                         ; COMMON ROUTINE FOR "DEFFN" AND "FN", TO
                                                         ; PARSE "FN" AND THE FUNCTION NAME
                                                         ; --------------------------------
AS_FNC_:         LDA              #MS_FNTK               ; MUST NOW SEE "FN" TOKEN
                 JSR              AS_SYNCHR              ; OR ELSE SYNTAX ERROR
                 ORA              #$80                   ; SET SIGN BIT ON 1ST CHAR OF NAME,
                 STA              MS_Z_SUBFLG            ; MAKING $C0 < SUBFLG < $DB
                 JSR              AS_PTRGET3             ; WHICH TELLS PTRGET WHO CALLED
                 STA              MS_Z_DEFPNT            ; FOUND VALID FUNCTION NAME, SO
                 STY              MS_Z_DEFPNT + 1        ; SAVE ADDRESS
                 JMP              AS_CHKNUM              ; MUST BE NUMERIC
                                                         ; --------------------------------
                                                         ; "FN" FUNCTION CALL
                                                         ; --------------------------------
AS_FUNCT:        JSR              AS_FNC_                ; PARSE "FN", FUNCTION NAME
                 LDA              MS_Z_DEFPNT + 1        ; STACK FUNCTION ADDRESS
                 PHA                                     ; IN CASE OF A NESTED FN CALL
                 LDA              MS_Z_DEFPNT
                 PHA
                 JSR              AS_PARCHK              ; MUST NOW HAVE "(EXPRESSION)"
                 JSR              AS_CHKNUM              ; MUST BE NUMERIC EXPRESSION
                 PLA                                     ; GET FUNCTION ADDRESS BACK
                 STA              MS_Z_DEFPNT
                 PLA
                 STA              MS_Z_DEFPNT + 1
                 LDY              #2                     ; POINT AT ADD OF ARGUMENT VARIABLE
                 LDA              (MS_Z_DEFPNT),Y
                 STA              MS_Z_VARPNT
                 TAX
                 INY
                 LDA              (MS_Z_DEFPNT),Y
                 BEQ              AS_UNDFNC              ; UNDEFINED FUNCTION
                 STA              MS_Z_VARPNT + 1
                 INY                                     ; Y=4 NOW
AS_L_FUNCT_1:    LDA              (MS_Z_VARPNT),Y        ; SAVE OLD VALUE OF ARGUMENT VARIABLE
                 PHA                                     ; ON STACK, IN CASE ALSO USED AS
                 DEY                                     ; A NORMAL VARIABLE!
                 BPL              AS_L_FUNCT_1
                 LDY              MS_Z_VARPNT + 1        ; (Y,X)= ADDRESS, STORE FAC IN VARIABLE
                 JSR              AS_STORE_FACDB_YX_ROUNDED
                 LDA              MS_Z_TXTPTR + 1        ; REMEMBER TXTPTR AFTER FN CALL
                 PHA
                 LDA              MS_Z_TXTPTR
                 PHA
                 LDA              (MS_Z_DEFPNT),Y        ; Y=0 FROM MOVMF
                 STA              MS_Z_TXTPTR            ; POINT TO FUNCTION DEF'N
                 INY
                 LDA              (MS_Z_DEFPNT),Y
                 STA              MS_Z_TXTPTR + 1
                 LDA              MS_Z_VARPNT + 1        ; SAVE ADDRESS OF ARGUMENT VARIABLE
                 PHA
                 LDA              MS_Z_VARPNT
                 PHA
                 JSR              AS_FRMNUM              ; EVALUATE THE FUNCTION EXPRESSION
                 PLA                                     ; GET ADDRESS OF ARGUMENT VARIABLE
                 STA              MS_Z_DEFPNT            ; AND SAVE IT
                 PLA
                 STA              MS_Z_DEFPNT + 1
                 JSR              MS_Z_CHRGOT            ; MUST BE AT ":" OR EOL
                 BEQ              AS_L_FUNCT_2           ; WE ARE
                 JMP              AS_SYNERR              ; WE ARE NOT, SLYNTAX ERROR
AS_L_FUNCT_2:     PLA                    ; RETRIEVE TXTPTR AFTER "FN" CALL
                 STA              MS_Z_TXTPTR
                 PLA
                 STA              MS_Z_TXTPTR + 1
                                                         ; STACK NOW HAS 5-BYTE VALUE
                                                         ; OF THE ARGUMENT VARIABLE,
                                                         ; AND FNCNAM POINTS AT THE VARIABLE
                                                         ; --------------------------------
                                                         ; STORE FIVE BYTES FROM STACK AT (FNCNAM)
                                                         ; --------------------------------
AS_FNCDATA:
                 LDY              #0
                 PLA
                 STA              (MS_Z_DEFPNT),Y
                 PLA
                 INY
                 STA              (MS_Z_DEFPNT),Y
                 PLA
                 INY
                 STA              (MS_Z_DEFPNT),Y
                 PLA
                 INY
                 STA              (MS_Z_DEFPNT),Y
                 PLA
                 INY
                 STA              (MS_Z_DEFPNT),Y
                 RTS
                                                         ; --------------------------------
                                                         ; "STR$" FUNCTION
                                                         ; --------------------------------
MS_STR:          JSR              AS_CHKNUM              ; EXPRESSION MUST BE NUMERIC
                 LDY              #0                     ; START STRING AT STACK-1 ($00FF)
                                                         ; SO STRLIT CAN DIFFRENTIATE STR$ CALLS
                 JSR              AS_FOUT_1              ; CONVERT FAC TO STRING
                 PLA                                     ; POP RETURN OFF STACK
                 PLA
                 LDA              #<AS_STACK - 1         ; POINT TO STACK-1
                 LDY              #>AS_STACK - 1         ; (WHICH=0)
                 BEQ              AS_STRLIT              ; ...ALWAYS, CREATE DESC & MOVE STRING
                                                         ; --------------------------------
                                                         ; GET SPACE AND MAKE DESCRIPTOR FOR STRING WHOSE
                                                         ; ADDRESS IS IN FAC+3,4 AND WHOSE LENGTH IS IN A-REG
                                                         ; --------------------------------
AS_STRINI:       LDX              MS_Z_FAC + 3           ; Y,X = STRING ADDRESS
                 LDY              MS_Z_FAC + 4
                 STX              MS_Z_DSCPNT
                 STY              MS_Z_DSCPNT + 1
                                                         ; --------------------------------
                                                         ; GET SPACE AND MAKE DESCRIPTOR FOR STRING WHOSE
                                                         ; ADDRESS IS IN Y,X AND WHOSE LENGTH IS IN A-REG
                                                         ; --------------------------------
AS_STRSPA:       JSR              AS_GETSPA              ; A HOLDS LENGTH
                 STX              MS_Z_FAC + 1           ; SAVE DESCRIPTOR IN FAC
                 STY              MS_Z_FAC + 2           ; ---FAC--- --FAC+1-- --FAC+2--
                 STA              MS_Z_FAC               ; <LENGTH>  <ADDR-LO> <ADDR-HI>
                 RTS
                                                         ; --------------------------------
                                                         ; BUILD A DESCRIPTOR FOR STRING STARTING AT Y,A
                                                         ; AND TERMINATED BY $00 OR QUOTATION MARK
                                                         ; RETURN WITH DESCRIPTOR IN A TEMPORARY
                                                         ; AND ADDRESS OF DESCRIPTOR IN FAC+3,4
                                                         ; --------------------------------
AS_STRLIT:       LDX              #$22                   ; SET UP LITERAL SCAN TO STOP ON
                 STX              MS_Z_CHARAC            ; QUOTATION MARK OR $00
                 STX              MS_Z_ENDCHR
                                                         ; --------------------------------
                                                         ; BUILD A DESCRIPTOR FOR STRING STARTING AT Y,A
                                                         ; AND TERMINATED BY $00, (CHARAC), OR (ENDCHR)

                                                         ; RETURN WITH DESCRIPTOR IN A TEMPORARY
                                                         ; AND ADDRESS OF DESCRIPTOR IN FAC+3,4
                                                         ; --------------------------------
AS_STRLT2:       STA              MS_Z_STRNG1            ; SAVE ADDRESS OF STRING
                 STY              MS_Z_STRNG1 + 1
                 STA              MS_Z_FAC + 1           ; ...AGAIN
                 STY              MS_Z_FAC + 2
                 LDY              #$FF
AS_L_STRLT2_1:    INY                    ; FIND END OF STRING
                 LDA              (MS_Z_STRNG1),Y        ; NEXT STRING CHAR
                 BEQ              AS_L_STRLT2_3          ; END OF STRING
                 CMP              MS_Z_CHARAC            ; ALTERNATE TERMINATOR # 1?
                 BEQ              AS_L_STRLT2_2          ; YES
                 CMP              MS_Z_ENDCHR            ; ALTERNATE TERMINATOR # 2?
                 BNE              AS_L_STRLT2_1          ; NO, KEEP SCANNING
AS_L_STRLT2_2:   CMP              #$22                   ; IS STRING ENDED WITH QUOTE MARK?
                 BEQ              AS_L_STRLT2_4          ; YES, C=1 TO INCLUDE " IN STRING
AS_L_STRLT2_3:    CLC
AS_L_STRLT2_4:   STY              MS_Z_FAC               ; SAVE LENGTH
                 TYA
                 ADC              MS_Z_STRNG1            ; COMPUTE ADDRESS OF END OF STRING
                 STA              MS_Z_STRNG2            ; (OF 00 BYTE, OR JUST AFTER ")
                 LDX              MS_Z_STRNG1 + 1
                 BCC              AS_L_STRLT2_5
                 INX
AS_L_STRLT2_5:   STX              MS_Z_STRNG2 + 1
                 LDA              MS_Z_STRNG1 + 1        ; WHERE DOES THE STRING START?
                 BEQ              AS_L_STRLT2_6          ; PAGE 0, MUST BE FROM STR$ FUNCTION
                 CMP              #2                     ; PAGE 2?
                 BNE              AS_PUTNEW              ; NO, NOT PAGE 0 OR 2
AS_L_STRLT2_6:    TYA                    ; LENGTH OF STRING
                 JSR              AS_STRINI              ; MAKE SPACE FOR STRING
                 LDX              MS_Z_STRNG1
                 LDY              MS_Z_STRNG1 + 1
                 JSR              AS_MOVSTR              ; MOVE IT IN
                                                         ; --------------------------------
                                                         ; STORE DESCRIPTOR IN TEMPORARY DESCRIPTOR STACK

                                                         ; THE DESCRIPTOR IS NOW IN FAC, FAC+1, FAC+2
                                                         ; PUT ADDRESS OF TEMP DESCRIPTOR IN FAC+3,4
                                                         ; --------------------------------
AS_PUTNEW:       LDX              MS_Z_TEMPPT            ; POINTER TO NEXT TEMP STRING SLOT
                 CPX              #MS_Z_TEMPST + 9       ; MAX OF 3 TEMP STRINGS
                 BNE              AS_PUTEMP              ; ROOM FOR ANOTHER ONE
                 LDX              #MS_ERRST              ; TOO MANY, FORMULA TOO COMPLEX
AS_JERR:         JMP              MS_ERROR
                                                         ; --------------------------------
AS_PUTEMP:       LDA              MS_Z_FAC               ; COPY TEMP DESCRIPTOR INTO TEMP STACK
                 STA              0,X
                 LDA              MS_Z_FAC + 1
                 STA              1,X
                 LDA              MS_Z_FAC + 2
                 STA              2,X
                 LDY              #0
                 STX              MS_Z_FAC + 3           ; ADDRESS OF TEMP DESCRIPTOR
                 STY              MS_Z_FAC + 4           ; IN Y,X AND FAC+3,4
                 DEY                                     ; Y=$FF
                 STY              MS_Z_VALTYP            ; FLAG (FAC ) AS STRING
                 STX              MS_Z_LASTPT            ; INDEX OF LAST POINTER
                 INX                                     ; UPDATE FOR NEXT TEMP ENTRY
                 INX
                 INX
                 STX              MS_Z_TEMPPT
                 RTS
                                                         ; --------------------------------
                                                         ; MAKE SPACE FOR STRING AT BOTTOM OF STRING SPACE
                                                         ; (A)=# BYTES SPACE TO MAKE

                                                         ; RETURN WITH (A) SAME,
                                                         ; AND Y,X = ADDRESS OF SPACE ALLOCATED
                                                         ; --------------------------------
AS_GETSPA:       LSR              MS_Z_GARBFL            ; CLEAR SIGNBIT OF FLAG
AS_L_GETSPA_1:    PHA                    ; A HOLDS LENGTH
                 EOR              #$FF                   ; GET -LENGTH
                 SEC
                 ADC              MS_Z_FRETOP            ; COMPUTE STARTING ADDRESS OF SPACE
                 LDY              MS_Z_FRETOP + 1        ; FOR THE STRING
                 BCS              AS_L_GETSPA_2
                 DEY
AS_L_GETSPA_2:   CPY              MS_Z_STREND + 1        ; SEE IF FITS IN REMAINING MEMORY
                 BCC              AS_L_GETSPA_4          ; NO, TRY GARBAGE
                 BNE              AS_L_GETSPA_3          ; YES, IT FITS
                 CMP              MS_Z_STREND            ; HAVE TO CHECK LOWER BYTES
                 BCC              AS_L_GETSPA_4          ; NOT ENUF ROOM YET
AS_L_GETSPA_3:   STA              MS_Z_FRETOP            ; THERE IS ROOM SO SAVE NEW FRETOP
                 STY              MS_Z_FRETOP + 1
                 STA              MS_Z_FRESPC
                 STY              MS_Z_FRESPC + 1
                 TAX                                     ; ADDR IN Y,X
                 PLA                                     ; LENGTH IN A
                 RTS
AS_L_GETSPA_4:   LDX              #MS_ERROM
                 LDA              MS_Z_GARBFL            ; GARBAGE DONE YET?
                 BMI              AS_JERR                ; YES, MEMORY IS REALLY FULL
                 JSR              MS_GARBA2              ; NO, TRY COLLECTING NOW
                 LDA              #$80                   ; FLAG THAT COLLECTED GARBAGE ALREADY
                 STA              MS_Z_GARBFL
                 PLA                                     ; GET STRING LENGTH AGAIN
                 BNE              AS_L_GETSPA_1          ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; SHOVE ALL REFERENCED STRINGS AS HIGH AS POSSIBLE
                                                         ; IN MEMORY (AGAINST HIMEM), FREEING UP SPACE
                                                         ; BELOW STRING AREA DOWN TO STREND.
                                                         ; --------------------------------
MS_GARBA2:       LDX              MS_Z_MEMSIZ            ; COLLECT FROM TOP DOWN
                 LDA              MS_Z_MEMSIZ + 1
AS_FIND_HIGHEST_STRING:
                 STX              MS_Z_FRETOP            ; ONE PASS THROUGH ALL VARS
                 STA              MS_Z_FRETOP + 1        ; FOR EACH ACTIVE STRING!
                 LDY              #0
                 STY              MS_Z_DEFPNT + 1        ; FLAG IN CASE NO STRINGS TO COLLECT
                 LDA              MS_Z_STREND
                 LDX              MS_Z_STREND + 1
                 STA              MS_Z_LOWTR
                 STX              MS_Z_LOWTR + 1
                                                         ; --------------------------------
                                                         ; START BY COLLECTING TEMPORARIES
                                                         ; --------------------------------
                 LDA              #<MS_Z_TEMPST
                 LDX              #>MS_Z_TEMPST
                 STA              MS_Z_INDEX
                 STX              MS_Z_INDEX + 1
AS_L_FIND_HIGHEST_STRING_1: CMP              MS_Z_TEMPPT            ; FINISHED WITH TEMPS YET?
                 BEQ              AS_L_FIND_HIGHEST_STRING_2 ; YES, NOW DO SIMPLE VARIABLES
                 JSR              AS_CHECK_VARIABLE      ; DO A TEMP
                 BEQ              AS_L_FIND_HIGHEST_STRING_1 ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; NOW COLLECT SIMPLE VARIABLES
                                                         ; --------------------------------
AS_L_FIND_HIGHEST_STRING_2: LDA              #7                     ; LENGTH OF EACH VARIABLE IS 7 BYTES
                 STA              MS_Z_FOUR6
                 LDA              MS_Z_VARTAB            ; START AT BEGINNING OF VARTAB
                 LDX              MS_Z_VARTAB + 1
                 STA              MS_Z_INDEX
                 STX              MS_Z_INDEX + 1
AS_L_FIND_HIGHEST_STRING_3: CPX              MS_Z_ARYTAB + 1        ; FINISHED WITH SIMPLE VARIABLES?
                 BNE              AS_L_FIND_HIGHEST_STRING_4 ; NO
                 CMP              MS_Z_ARYTAB            ; MAYBE, CHECK LO-BYTE
                 BEQ              AS_L_FIND_HIGHEST_STRING_5 ; YES, NOW DO ARRAYS
AS_L_FIND_HIGHEST_STRING_4: JSR              AS_CHECK_SIMPLE_VARIABLE
                 BEQ              AS_L_FIND_HIGHEST_STRING_3 ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; NOW COLLECT ARRAY VARIABLES
                                                         ; --------------------------------
AS_L_FIND_HIGHEST_STRING_5: STA              MS_Z_ARYPNT
                 STX              MS_Z_ARYPNT + 1
                 LDA              #3                     ; DESCRIPTORS IN ARRAYS ARE 3-BYTES EACH
                 STA              MS_Z_FOUR6
AS_L_FIND_HIGHEST_STRING_6: LDA              MS_Z_ARYPNT            ; COMPARE TO END OF ARRAYS
                 LDX              MS_Z_ARYPNT + 1
AS_L_FIND_HIGHEST_STRING_7: CPX              MS_Z_STREND + 1        ; FINISHED WITH ARRAYS YET?
                 BNE              AS_L_FIND_HIGHEST_STRING_8 ; NOT YET
                 CMP              MS_Z_STREND            ; MAYBE, CHECK LO-BYTE
                 BNE              AS_L_FIND_HIGHEST_STRING_8 ; NOT FINISHED YET
                 JMP              AS_MOVE_HIGHEST_STRING_TO_TOP ; FINISHED
AS_L_FIND_HIGHEST_STRING_8: STA              MS_Z_INDEX             ; SET UP PNTR TO START OF ARRAY
                 STX              MS_Z_INDEX + 1
                 LDY              #0                     ; POINT AT NAME OF ARRAY
                 LDA              (MS_Z_INDEX),Y
                 TAX                                     ; 1ST LETTER OF NAME IN X-REG
                 INY
                 LDA              (MS_Z_INDEX),Y
                 PHP                                     ; STATUS FROM SECOND LETTER OF NAME
                 INY
                 LDA              (MS_Z_INDEX),Y         ; OFFSET TO NEXT ARRAY
                 ADC              MS_Z_ARYPNT            ; (CARRY ALWAYS CLEAR)
                 STA              MS_Z_ARYPNT            ; CALCULATE START OF NEXT ARRAY
                 INY
                 LDA              (MS_Z_INDEX),Y         ; HI-BYTE OF OFFSET
                 ADC              MS_Z_ARYPNT + 1
                 STA              MS_Z_ARYPNT + 1
                 PLP                                     ; GET STATUS FROM 2ND CHAR OF NAME
                 BPL              AS_L_FIND_HIGHEST_STRING_6 ; NOT A STRING ARRAY
                 TXA                                     ; SET STATUS WITH 1ST CHAR OF NAME
                 BMI              AS_L_FIND_HIGHEST_STRING_6 ; NOT A STRING ARRAY
                 INY
                 LDA              (MS_Z_INDEX),Y         ; # OF DIMENSIONS FOR THIS ARRAY
                 LDY              #0
                 ASL                                     ; PREAMBLE SIZE = 2*#DIMS + 5
                 ADC              #5
                 ADC              MS_Z_INDEX             ; MAKE INDEX POINT AT FIRST ELEMENT
                 STA              MS_Z_INDEX             ; IN THE ARRAY
                 BCC              AS_L_FIND_HIGHEST_STRING_9
                 INC              MS_Z_INDEX + 1
AS_L_FIND_HIGHEST_STRING_9:
                 LDX              MS_Z_INDEX + 1         ; STEP THRU EACH STRING IN THIS ARRAY
AS_L_FIND_HIGHEST_STRING_10: CPX              MS_Z_ARYPNT + 1        ; ARRAY DONE?
                 BNE              AS_L_FIND_HIGHEST_STRING_11 ; NO, PROCESS NEXT ELEMENT
                 CMP              MS_Z_ARYPNT            ; MAYBE, CHECK LO-BYTE
                 BEQ              AS_L_FIND_HIGHEST_STRING_7 ; YES, MOVE TO NEXT ARRAY
AS_L_FIND_HIGHEST_STRING_11: JSR              AS_CHECK_VARIABLE      ; PROCESS THE ARRAY
                 BEQ              AS_L_FIND_HIGHEST_STRING_10 ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; PROCESS A SIMPLE VARIABLE
                                                         ; --------------------------------
AS_CHECK_SIMPLE_VARIABLE:
                 LDA              (MS_Z_INDEX),Y         ; LOOK AT 1ST CHAR OF NAME
                 BMI              AS_CHECK_BUMP          ; NOT A STRING VARIABLE
                 INY
                 LDA              (MS_Z_INDEX),Y         ; LOOK AT 2ND CHAR OF NAME
                 BPL              AS_CHECK_BUMP          ; NOT A STRING VARIABLE
                 INY
                                                         ; --------------------------------
                                                         ; IF STRING IS NOT EMPTY, CHECK IF IT IS HIGHEST
                                                         ; --------------------------------
AS_CHECK_VARIABLE:
                 LDA              (MS_Z_INDEX),Y         ; GET LENGTH OF STRING
                 BEQ              AS_CHECK_BUMP          ; IGNORE STRING IF LENGTH IS ZERO
                 INY
                 LDA              (MS_Z_INDEX),Y         ; GET ADDRESS OF STRING
                 TAX
                 INY
                 LDA              (MS_Z_INDEX),Y
                 CMP              MS_Z_FRETOP + 1        ; CHECK IF ALREADY COLLECTED
                 BCC              AS_L_CHECK_VARIABLE_1  ; NO, BELOW FRETOP
                 BNE              AS_CHECK_BUMP          ; YES, ABOVE FRETOP
                 CPX              MS_Z_FRETOP            ; MAYBE, CHECK LO-BYTE
                 BCS              AS_CHECK_BUMP          ; YES, ABOVE FRETOP
AS_L_CHECK_VARIABLE_1: CMP              MS_Z_LOWTR + 1         ; ABOVE HIGHEST STRING FOUND?
                 BCC              AS_CHECK_BUMP          ; NO, IGNORE FOR NOW
                 BNE              AS_L_CHECK_VARIABLE_2  ; YES, THIS IS THE NEW HIGHEST
                 CPX              MS_Z_LOWTR             ; MAYBE, TRY LO-BYTE
                 BCC              AS_CHECK_BUMP          ; NO, IGNORE FOR NOW
AS_L_CHECK_VARIABLE_2: STX              MS_Z_LOWTR             ; MAKE THIS THE HIGHEST STRING
                 STA              MS_Z_LOWTR + 1
                 LDA              MS_Z_INDEX             ; SAVE ADDRESS OF DESCRIPTOR TOO
                 LDX              MS_Z_INDEX + 1
                 STA              MS_Z_DEFPNT
                 STX              MS_Z_DEFPNT + 1
                 LDA              MS_Z_FOUR6
                 STA              MS_Z_SIZE
                                                         ; --------------------------------
                                                         ; ADD (DSCLEN) TO PNTR IN INDEX
                                                         ; RETURN WITH Y=0, PNTR ALSO IN X,A
                                                         ; --------------------------------
AS_CHECK_BUMP:
                 LDA              MS_Z_FOUR6             ; BUMP TO NEXT VARIABLE
                 CLC
                 ADC              MS_Z_INDEX
                 STA              MS_Z_INDEX
                 BCC              AS_CHECK_EXIT
                 INC              MS_Z_INDEX + 1
                                                         ; --------------------------------
AS_CHECK_EXIT:
                 LDX              MS_Z_INDEX + 1
                 LDY              #0
                 RTS
                                                         ; --------------------------------
                                                         ; FOUND HIGHEST NON-EMPTY STRING, SO MOVE IT
                                                         ; TO TOP AND GO BACK FOR ANOTHER
                                                         ; --------------------------------
AS_MOVE_HIGHEST_STRING_TO_TOP:
                 LDX              MS_Z_DEFPNT + 1        ; ANY STRING FOUND?
                 BEQ              AS_CHECK_EXIT          ; NO, RETURN
                 LDA              MS_Z_SIZE              ; GET LENGTH OF VARIABLE ELEMENT
                 AND              #4                     ; WAS 7 OR 3, MAKE 4 OR 0
                 LSR                                     ; 2 0R 0; IN SIMPLE VARIABLES,
                 TAY                                     ; NAME PRECEDES DESCRIPTOR
                 STA              MS_Z_SIZE              ; 2 OR 0
                 LDA              (MS_Z_DEFPNT),Y        ; GET LENGTH FROM DESCRIPTOR
                 ADC              MS_Z_LOWTR             ; CARRY ALREADY CLEARED BY LSR
                 STA              MS_Z_HIGHTR            ; STRING IS BTWN (LOWTR) AND (HIGHTR)
                 LDA              MS_Z_LOWTR + 1
                 ADC              #0
                 STA              MS_Z_HIGHTR + 1
                 LDA              MS_Z_FRETOP            ; HIGH END DESTINATION
                 LDX              MS_Z_FRETOP + 1
                 STA              MS_Z_HIGHDS
                 STX              MS_Z_HIGHDS + 1
                 JSR              MS_BLTUC               ; MOVE STRING UP
                 LDY              MS_Z_SIZE              ; FIX ITS DESCRIPTOR
                 INY                                     ; POINT AT ADDRESS IN DESCRIPTOR
                 LDA              MS_Z_HIGHDS            ; STORE NEW ADDRESS
                 STA              (MS_Z_DEFPNT),Y
                 TAX
                 INC              MS_Z_HIGHDS + 1        ; CORRECT BLTU'S OVERSHOOT
                 LDA              MS_Z_HIGHDS + 1
                 INY
                 STA              (MS_Z_DEFPNT),Y
                 JMP              AS_FIND_HIGHEST_STRING
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; CONCATENATE TWO STRINGS
                                                         ; --------------------------------
AS_CAT:          LDA              MS_Z_FAC + 4           ; SAVE ADDRESS OF FIRST DESCRIPTOR
                 PHA
                 LDA              MS_Z_FAC + 3
                 PHA
                 JSR              AS_FRM_ELEMENT         ; GET SECOND STRING ELEMENT
                 JSR              AS_CHKSTR              ; MUST BE A STRING
                 PLA                                     ; RECOVER ADDRES OF 1ST DESCRIPTOR
                 STA              MS_Z_STRNG1
                 PLA
                 STA              MS_Z_STRNG1 + 1
                 LDY              #0
                 LDA              (MS_Z_STRNG1),Y        ; ADD LENGTHS, GET CONCATENATED SIZE
                 CLC
                 ADC              (MS_Z_FAC + 3),Y
                 BCC              AS_L_CAT_1             ; OK IF < $100
                 LDX              #MS_ERRLS
                 JMP              MS_ERROR
AS_L_CAT_1:      JSR              AS_STRINI              ; GET SPACE FOR CONCATENATED STRINGS
                 JSR              AS_MOVINS              ; MOVE 1ST STRING
                 LDA              MS_Z_DSCPNT
                 LDY              MS_Z_DSCPNT + 1
                 JSR              AS_FRETMP
                 JSR              AS_MOVSTR_1            ; MOVE 2ND STRING
                 LDA              MS_Z_STRNG1
                 LDY              MS_Z_STRNG1 + 1
                 JSR              AS_FRETMP
                 JSR              AS_PUTNEW              ; SET UP DESCRIPTOR
                 JMP              AS_FRMEVL_2            ; FINISH EXPRESSION
                                                         ; --------------------------------
                                                         ; GET STRING DESCRIPTOR POINTED AT BY (STRNG1)
                                                         ; AND MOVE DESCRIBED STRING TO (FRESPC)
                                                         ; --------------------------------
AS_MOVINS:       LDY              #0
                 LDA              (MS_Z_STRNG1),Y
                 PHA                                     ; LENGTH
                 INY
                 LDA              (MS_Z_STRNG1),Y
                 TAX                                     ; PUT STRING POINTER IN X,Y
                 INY
                 LDA              (MS_Z_STRNG1),Y
                 TAY
                 PLA                                     ; RETRIEVE LENGTH
                                                         ; --------------------------------
                                                         ; MOVE STRING AT (Y,X) WITH LENGTH (A)
                                                         ; TO DESTINATION WHOSE ADDRESS IS IN FRESPC,FRESPC+1
                                                         ; --------------------------------
AS_MOVSTR:       STX              MS_Z_INDEX             ; PUT POINTER IN INDEX
                 STY              MS_Z_INDEX + 1
AS_MOVSTR_1:
                 TAY                                     ; LENGTH TO Y-REG
                 BEQ              AS_L_MOVSTR_1_2        ; IF LENGTH IS ZERO, FINISHED
                 PHA                                     ; SAVE LENGTH ON STACK
AS_L_MOVSTR_1_1:  DEY                    ; MOVE BYTES FROM (INDEX) TO (FRESPC)
                 LDA              (MS_Z_INDEX),Y
                 STA              (MS_Z_FRESPC),Y
                 TYA                                     ; TEST IF ANY LEFT TO MOVE
                 BNE              AS_L_MOVSTR_1_1        ; YES, KEEP MOVING
                 PLA                                     ; NO, FINISHED.  GET LENGTH
AS_L_MOVSTR_1_2:  CLC                    ; AND ADD TO FRESPC, SO
                 ADC              MS_Z_FRESPC            ; FRESPC POINTS TO NEXT HIGHER
                 STA              MS_Z_FRESPC            ; BYTE.  (USED BY CONCATENATION)
                 BCC              AS_L_MOVSTR_1_3
                 INC              MS_Z_FRESPC + 1
AS_L_MOVSTR_1_3:  RTS
                                                         ; --------------------------------
                                                         ; IF (FAC) IS A TEMPORARY STRING, RELEASE DESCRIPTOR
                                                         ; --------------------------------
AS_FRESTR:       JSR              AS_CHKSTR              ; LAST RESULT A STRING?
                                                         ; --------------------------------
                                                         ; IF STRING DESCRIPTOR POINTED TO BY FAC+3,4 IS
                                                         ; A TEMPORARY STRING, RELEASE IT.
                                                         ; --------------------------------
AS_FREFAC:       LDA              MS_Z_FAC + 3           ; GET DESCRIPTOR POINTER
                 LDY              MS_Z_FAC + 4
                                                         ; --------------------------------
                                                         ; IF STRING DESCRIPTOR WHOSE ADDRESS IS IN Y,A IS
                                                         ; A TEMPORARY STRING, RELEASE IT.
                                                         ; --------------------------------
AS_FRETMP:       STA              MS_Z_INDEX             ; SAVE THE ADDRESS OF THE DESCRIPTOR
                 STY              MS_Z_INDEX + 1
                 JSR              AS_FRETMS              ; FREE DESCRIPTOR IF IT IS TEMPORARY
                 PHP                                     ; REMEMBER IF TEMP
                 LDY              #0                     ; POINT AT LENGTH OF STRING
                 LDA              (MS_Z_INDEX),Y
                 PHA                                     ; SAVE LENGTH ON STACK
                 INY
                 LDA              (MS_Z_INDEX),Y
                 TAX                                     ; GET ADDRESS OF STRING IN Y,X
                 INY
                 LDA              (MS_Z_INDEX),Y
                 TAY
                 PLA                                     ; LENGTH IN A
                 PLP                                     ; RETRIEVE STATUS, Z=1 IF TEMP
                 BNE              AS_L_FRETMP_2          ; NOT A TEMPORARY STRING
                 CPY              MS_Z_FRETOP + 1        ; IS IT THE LOWEST STRING?
                 BNE              AS_L_FRETMP_2          ; NO
                 CPX              MS_Z_FRETOP
                 BNE              AS_L_FRETMP_2          ; NO
                 PHA                                     ; YES, PUSH LENGTH AGAIN
                 CLC                                     ; RECOVER THE SPACE USED BY
                 ADC              MS_Z_FRETOP            ; THE STRING
                 STA              MS_Z_FRETOP
                 BCC              AS_L_FRETMP_1
                 INC              MS_Z_FRETOP + 1
AS_L_FRETMP_1:    PLA                    ; RETRIEVE LENGTH AGAIN
AS_L_FRETMP_2:   STX              MS_Z_INDEX             ; ADDRESS OF STRING IN Y,X
                 STY              MS_Z_INDEX + 1         ; LENGTH OF STRING IN A-REG
                 RTS
                                                         ; --------------------------------
                                                         ; RELEASE TEMPORARY DESCRIPTOR IF Y,A = LASTPT
                                                         ; --------------------------------
AS_FRETMS:       CPY              MS_Z_LASTPT + 1        ; COMPARE Y,A TO LATEST TEMP
                 BNE              AS_L_FRETMS_1          ; NOT SAME ONE, CANNOT RELEASE
                 CMP              MS_Z_LASTPT
                 BNE              AS_L_FRETMS_1          ; NOT SAME ONE, CANNOT RELEASE
                 STA              MS_Z_TEMPPT            ; UPDATE TEMPT FOR NEXT TEMP
                 SBC              #3                     ; BACK OFF LASTPT
                 STA              MS_Z_LASTPT
                 LDY              #0                     ; NOW Y,A POINTS TO TOP TEMP
AS_L_FRETMS_1:    RTS                    ; Z=0 IF NOT TEMP, Z=1 IF TEMP
                                                         ; --------------------------------
                                                         ; "CHR$" FUNCTION
                                                         ; --------------------------------
MS_CHR:          JSR              AS_CONINT              ; CONVERT ARGUMENT TO BYTE IN X
                 TXA
                 PHA                                     ; SAVE IT
                 LDA              #1                     ; GET SPACE FOR STRING OF LENGTH 1
                 JSR              AS_STRSPA
                 PLA                                     ; RECALL THE CHARACTER
                 LDY              #0                     ; PUT IN STRING
                 STA              (MS_Z_FAC + 1),Y
                 PLA                                     ; POP RETURN ADDRESS
                 PLA
                 JMP              AS_PUTNEW              ; MAKE IT A TEMPORARY STRING
                                                         ; --------------------------------
                                                         ; "LEFT$" FUNCTION
                                                         ; --------------------------------
MS_LEFT:
                 JSR              AS_SUBSTRING_SETUP
                 CMP              (MS_Z_DSCPNT),Y        ; COMPARE 1ST PARAMETER TO LENGTH
                 TYA                                     ; Y=A=0
AS_SUBSTRING_1:
                 BCC              AS_L_SUBSTRING_1_1     ; 1ST PARAMETER SMALLER, USE IT
                 LDA              (MS_Z_DSCPNT),Y        ; 1ST IS LONGER, USE STRING LENGTH
                 TAX                                     ; IN X-REG
                 TYA                                     ; Y=A=0 AGAIN
AS_L_SUBSTRING_1_1: PHA                    ; PUSH LEFT END OF SUBSTRING
AS_SUBSTRING_2:
                 TXA
AS_SUBSTRING_3:
                 PHA                                     ; PUSH LENGTH OF SUBSTRING
                 JSR              AS_STRSPA              ; MAKE ROOM FOR STRING OF (A) BYTES
                 LDA              MS_Z_DSCPNT            ; RELEASE PARAMETER STRING IF TEMP
                 LDY              MS_Z_DSCPNT + 1
                 JSR              AS_FRETMP
                 PLA                                     ; GET LENGTH OF SUBSTRING
                 TAY                                     ; IN Y-REG
                 PLA                                     ; GET LEFT END OF SUBSTRING
                 CLC                                     ; ADD TO POINTER TO STRING
                 ADC              MS_Z_INDEX
                 STA              MS_Z_INDEX
                 BCC              AS_L_SUBSTRING_3_1
                 INC              MS_Z_INDEX + 1
AS_L_SUBSTRING_3_1: TYA                    ; LENGTH
                 JSR              AS_MOVSTR_1            ; COPY STRING INTO SPACE
                 JMP              AS_PUTNEW              ; ADD TO TEMPS
                                                         ; --------------------------------
                                                         ; "RIGHT$" FUNCTION
                                                         ; --------------------------------
MS_RIGHT:
                 JSR              AS_SUBSTRING_SETUP
                 CLC                                     ; COMPUTE LENGTH-WIDTH OF SUBSTRING
                 SBC              (MS_Z_DSCPNT),Y        ; TO GET STARTING POINT IN STRING
                 EOR              #$FF
                 JMP              AS_SUBSTRING_1         ; JOIN LEFT$
                                                         ; --------------------------------
                                                         ; "MID$" FUNCTION
                                                         ; --------------------------------
MS_MID:          LDA              #$FF                   ; FLAG WHETHER 2ND PARAMETER
                 STA              MS_Z_FAC + 4
                 JSR              MS_Z_CHRGOT            ; SEE IF ")" YET
                 CMP              #")" & %01111111
                 BEQ              AS_L_MIDSTR_1          ; YES, NO 2ND PARAMETER
                 JSR              AS_CHKCOM              ; NO, MUST HAVE COMMA
                 JSR              AS_GETBYT              ; GET 2ND PARAM IN X-REG
AS_L_MIDSTR_1:   JSR              AS_SUBSTRING_SETUP
                 DEX                                     ; 1ST PARAMETER - 1
                 TXA
                 PHA
                 CLC
                 LDX              #0
                 SBC              (MS_Z_DSCPNT),Y
                 BCS              AS_SUBSTRING_2
                 EOR              #$FF
                 CMP              MS_Z_FAC + 4           ; USE SMALLER OF TWO
                 BCC              AS_SUBSTRING_3
                 LDA              MS_Z_FAC + 4
                 BCS              AS_SUBSTRING_3         ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; COMMON SETUP ROUTINE FOR LEFT$, RIGHT$, MID$:
                                                         ; REQUIRE ")"; POP RETURN ADRS, GET DESCRIPTOR
                                                         ; ADDRESS, GET 1ST PARAMETER OF COMMAND
                                                         ; --------------------------------
AS_SUBSTRING_SETUP:
                 JSR              AS_CHKCLS              ; REQUIRE ")"
                 PLA                                     ; SAVE RETURN ADDRESS
                 TAY                                     ; IN Y-REG AND LENGTH
                 PLA
                 STA              MS_Z_SIZE
                 PLA                                     ; POP PREVIOUS RETURN ADDRESS
                 PLA                                     ; (FROM GOROUT).
                 PLA                                     ; RETRIEVE 1ST PARAMETER
                 TAX
                 PLA                                     ; GET ADDRESS OF STRING DESCRIPTOR
                 STA              MS_Z_DSCPNT
                 PLA
                 STA              MS_Z_DSCPNT + 1
                 LDA              MS_Z_SIZE              ; RESTORE RETURN ADDRESS
                 PHA
                 TYA
                 PHA
                 LDY              #0
                 TXA                                     ; GET 1ST PARAMETER IN A-REG
                 BEQ              AS_GOIQ                ; ERROR IF 0
                 RTS
                                                         ; --------------------------------
                                                         ; "LEN" FUNCTION
                                                         ; --------------------------------
MS_LEN:          JSR              AS_GETSTR              ; GET LENTGH IN Y-REG, MAKE FAC NUMERIC
                 JMP              AS_SNGFLT              ; FLOAT Y-REG INTO FAC
                                                         ; --------------------------------
                                                         ; IF LAST RESULT IS A TEMPORARY STRING, FREE IT
                                                         ; MAKE VALTYP NUMERIC, RETURN LENGTH IN Y-REG
                                                         ; --------------------------------
AS_GETSTR:       JSR              AS_FRESTR              ; IF LAST RESULT IS A STRING, FREE IT
                 LDX              #0                     ; MAKE VALTYP NUMERIC
                 STX              MS_Z_VALTYP
                 TAY                                     ; LENGTH OF STRING TO Y-REG
                 RTS
                                                         ; --------------------------------
                                                         ; "ASC" FUNCTION
                                                         ; --------------------------------
MS_ASC:          JSR              AS_GETSTR              ; GET STRING, GET LENGTH IN Y-REG
                 BEQ              AS_GOIQ                ; ERROR IF LENGTH 0
                 LDY              #0
                 LDA              (MS_Z_INDEX),Y         ; GET 1ST CHAR OF STRING
                 TAY
                 JMP              AS_SNGFLT              ; FLOAT Y-REG INTO FAC
                                                         ; --------------------------------
AS_GOIQ:         JMP              AS_IQERR               ; ILLEGAL QUANTITY ERROR
                                                         ; --------------------------------
                                                         ; SCAN TO NEXT CHARACTER AND CONVERT EXPRESSION
                                                         ; TO SINGLE BYTE IN X-REG
                                                         ; --------------------------------
AS_GTBYTC:       JSR              MS_Z_CHRGET
                                                         ; --------------------------------
                                                         ; EVALUATE EXPRESSION AT TXTPTR, AND
                                                         ; CONVERT IT TO SINGLE BYTE IN X-REG
                                                         ; --------------------------------
AS_GETBYT:       JSR              AS_FRMNUM
                                                         ; --------------------------------
                                                         ; CONVERT (FAC) TO SINGLE BYTE INTEGER IN X-REG
                                                         ; --------------------------------
AS_CONINT:       JSR              AS_MKINT               ; CONVERT IF IN RANGE -32767 TO +32767
                 LDX              MS_Z_FAC + 3           ; HI-BYTE MUST BE ZERO
                 BNE              AS_GOIQ                ; VALUE > 255, ERROR
                 LDX              MS_Z_FAC + 4           ; VALUE IN X-REG
                 JMP              MS_Z_CHRGOT            ; GET NEXT CHAR IN A-REG
                                                         ; --------------------------------
                                                         ; "VAL" FUNCTION
                                                         ; --------------------------------
MS_VAL:          JSR              AS_GETSTR              ; GET POINTER TO STRING IN INDEX
                 BNE              AS_L_VAL_1             ; LENGTH NON-ZERO
                 JMP              AS_ZERO_FAC            ; RETURN 0 IF LENGTH=0
AS_L_VAL_1:      LDX              MS_Z_TXTPTR            ; SAVE CURRENT TXTPTR
                 LDY              MS_Z_TXTPTR + 1
                 STX              MS_Z_STRNG2
                 STY              MS_Z_STRNG2 + 1
                 LDX              MS_Z_INDEX
                 STX              MS_Z_TXTPTR            ; POINT TXTPTR TO START OF STRING
                 CLC
                 ADC              MS_Z_INDEX             ; ADD LENGTH
                 STA              AS_DEST                ; POINT DEST TO END OF STRING + 1
                 LDX              MS_Z_INDEX + 1
                 STX              MS_Z_TXTPTR + 1
                 BCC              AS_L_VAL_2
                 INX
AS_L_VAL_2:      STX              AS_DEST + 1
                 LDY              #0                     ; SAVE BYTE THAT FOLLOWS STRING
                 LDA              (AS_DEST),Y            ; ON STACK
                 PHA
                 LDA              #0                     ; AND STORE $00 IN ITS PLACE
                 STA              (AS_DEST),Y
                                                         ; <<< THAT CAUSES A BUG IF HIMEM = $BFFF, >>>
                                                         ; <<< BECAUSE STORING $00 AT $C000 IS NO  >>>
                                                         ; <<< USE; $C000 WILL ALWAYS BE LAST CHAR >>>
                                                         ; <<< TYPED, SO FIN WON'T TERMINATE UNTIL >>>
                                                         ; <<< IT SEES A ZERO AT $C010!            >>>
                 JSR              MS_Z_CHRGOT            ; PRIME THE PUMP
                 JSR              AS_FIN                 ; EVALUATE STRING
                 PLA                                     ; GET BYTE THAT SHOULD FOLLOW STRING
                 LDY              #0                     ; AND PUT IT BACK
                 STA              (AS_DEST),Y
                                                         ; RESTORE TXTPTR
                                                         ; --------------------------------
                                                         ; COPY STRNG2 INTO TXTPTR
                                                         ; --------------------------------
AS_POINT:        LDX              MS_Z_STRNG2
                 LDY              MS_Z_STRNG2 + 1
                 STX              MS_Z_TXTPTR
                 STY              MS_Z_TXTPTR + 1
                 RTS
                                                         ; --------------------------------
                                                         ; EVALUATE "EXP1,EXP2"

                                                         ; CONVERT EXP1 TO 16-BIT NUMBER IN LINNUM
                                                         ; CONVERT EXP2 TO 8-BIT NUMBER IN X-REG
                                                         ; --------------------------------
AS_GTNUM:        JSR              AS_FRMNUM
                 JSR              AS_GETADR
                                                         ; --------------------------------
                                                         ; EVALUATE ",EXPRESSION"
                                                         ; CONVERT EXPRESSION TO SINGLE BYTE IN X-REG
                                                         ; --------------------------------
AS_COMBYTE:
                 JSR              AS_CHKCOM              ; MUST HAVE COMMA FIRST
                 JMP              AS_GETBYT              ; CONVERT EXPRESSION TO BYTE IN X-REG
                                                         ; --------------------------------
                                                         ; CONVERT (FAC) TO A 16-BIT VALUE IN LINNUM
                                                         ; --------------------------------
AS_GETADR:       LDA              MS_Z_FAC               ; FAC < 2^16?
                 CMP              #$91
                 BCS              AS_GOIQ                ; NO, ILLEGAL QUANTITY
                 JSR              AS_QINT                ; CONVERT TO INTEGER
                 LDA              MS_Z_FAC + 3           ; COPY IT INTO LINNUM
                 LDY              MS_Z_FAC + 4
                 STY              MS_Z_LINNUM            ; TO LINNUM
                 STA              MS_Z_LINNUM + 1
                 RTS
                                                         ; --------------------------------
                                                         ; "PEEK" FUNCTION
                                                         ; --------------------------------
MS_PEEK:         LDA              MS_Z_LINNUM            ; SAVE (LINNUM) ON STACK DURING PEEK
                 PHA
                 LDA              MS_Z_LINNUM + 1
                 PHA
                 JSR              AS_GETADR              ; GET ADDRESS PEEKING AT
                 LDY              #0
                 LDA              (MS_Z_LINNUM),Y        ; TAKE A QUICK LOOK
                 TAY                                     ; VALUE IN Y-REG
                 PLA                                     ; RESTORE LINNUM FROM STACK
                 STA              MS_Z_LINNUM + 1
                 PLA
                 STA              MS_Z_LINNUM
                 JMP              AS_SNGFLT              ; FLOAT Y-REG INTO FAC
                                                         ; --------------------------------
                                                         ; "POKE" STATEMENT
                                                         ; --------------------------------
MS_POKE:         JSR              AS_GTNUM               ; GET THE ADDRESS AND VALUE
                 TXA                                     ; VALUE IN A,
                 LDY              #0
                 STA              (MS_Z_LINNUM),Y        ; STORE IT AWAY,
                 RTS                                     ; AND THAT'S ALL FOR TODAY
                                                         ; --------------------------------
                                                         ; "WAIT" STATEMENT
                                                         ; --------------------------------
MS_FNWAIT:       JSR              AS_GTNUM               ; GET ADDRESS IN LINNUM, MASK IN X
                 STX              MS_Z_FORPNT            ; SAVE MASK
                 LDX              #0
                 JSR              MS_Z_CHRGOT            ; ANOTHER PARAMETER?
                 BEQ              AS_L_WAIT_1            ; NO, USE $00 FOR EXCLUSIVE-OR
                 JSR              AS_COMBYTE             ; GET XOR-MASK
AS_L_WAIT_1:     STX              MS_Z_FORPNT + 1        ; SAVE XOR-MASK HERE
                 LDY              #0
AS_L_WAIT_2:     LDA              (MS_Z_LINNUM),Y        ; GET BYTE AT ADDRESS
                 EOR              MS_Z_FORPNT + 1        ; INVERT SPECIFIED BITS
                 AND              MS_Z_FORPNT            ; SELECT SPECIFIED BITS
                 BEQ              AS_L_WAIT_2            ; LOOP TILL NOT 0
AS_RTS_10:        RTS
                                                         ; --------------------------------
                                                         ; ADD 0L_RTS_10_5 TO FAC
                                                         ; --------------------------------
AS_FADDH:        LDA              #<AS_CON_HALF          ; FAC+1/2 -> FAC
                 LDY              #>AS_CON_HALF
                 JMP              AS_FADD
                                                         ; --------------------------------
                                                         ; FAC = (Y,A) - FAC
                                                         ; --------------------------------
AS_FSUB:         JSR              AS_LOAD_ARG_FROM_YA
                                                         ; --------------------------------
                                                         ; FAC = ARG - FAC
                                                         ; --------------------------------
MS_FSUBT:        LDA              MS_Z_FACSGN            ; COMPLEMENT FAC AND ADD
                 EOR              #$FF
                 STA              MS_Z_FACSGN
                 EOR              MS_Z_ARGSGN            ; FIX SGNCPR TOO
                 STA              MS_Z_ARISGN
                 LDA              MS_Z_FAC               ; MAKE STATUS SHOW FAC EXPONENT
                 JMP              MS_FADDT               ; JOIN FADD
                                                         ; --------------------------------
                                                         ; SHIFT SMALLER ARGUMENT MORE THAN 7 BITS
                                                         ; --------------------------------
AS_FADD_1:       JSR              AS_SHIFT_RIGHT         ; ALIGN RADIX BY SHIFTING
                 BCC              AS_FADD_3              ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; FAC = (Y,A) + FAC
                                                         ; --------------------------------
AS_FADD:         JSR              AS_LOAD_ARG_FROM_YA
                                                         ; --------------------------------
                                                         ; FAC = ARG + FAC
                                                         ; --------------------------------
MS_FADDT:        BNE              AS_L_FADDT_1           ; FAC IS NON-ZERO
                 JMP              AS_COPY_ARG_TO_FAC     ; FAC = 0 + ARG
AS_L_FADDT_1:    LDX              MS_Z_FACOV
                 STX              MS_Z_OLDOV
                 LDX              #MS_Z_ARGEXP           ; SET UP TO SHIFT ARG
                 LDA              MS_Z_ARGEXP            ; EXPONENT
                                                         ; --------------------------------
AS_FADD_2:        TAY
                 BEQ              AS_RTS_10              ; IF ARG=0, WE ARE FINISHED
                 SEC
                 SBC              MS_Z_FAC               ; GET DIFFNCE OF EXP
                 BEQ              AS_FADD_3              ; GO ADD IF SAME EXP
                 BCC              AS_L_FADD_2_1          ; ARG HAS SMALLER EXPONENT
                 STY              MS_Z_FAC               ; EXP HAS SMALLER EXPONENT
                 LDY              MS_Z_ARGSGN
                 STY              MS_Z_FACSGN
                 EOR              #$FF                   ; COMPLEMENT SHIFT COUNT
                 ADC              #0                     ; CARRY WAS SET
                 LDY              #0
                 STY              MS_Z_OLDOV
                 LDX              #MS_Z_FAC              ; SET UP TO SHIFT FAC
                 BNE              AS_L_FADD_2_2          ; ...ALWAYS
AS_L_FADD_2_1:   LDY              #0
                 STY              MS_Z_FACOV
AS_L_FADD_2_2:   CMP              #$F9                   ; SHIFT MORE THAN 7 BITS?
                 BMI              AS_FADD_1              ; YES
                 TAY                                     ; INDEX TO # OF SHIFTS
                 LDA              MS_Z_FACOV
                 LSR              1,X                    ; START SHIFTING...
                 JSR              AS_SHIFT_RIGHT_4       ; ...COMPLETE SHIFTING
AS_FADD_3:       BIT              MS_Z_ARISGN            ; DO FAC AND ARG HAVE SAME SIGNS?
                 BPL              AS_FADD_4              ; YES, ADD THE MANTISSAS
                 LDY              #MS_Z_FAC              ; NO, SUBTRACT SMALLER FROM LARGER
                 CPX              #MS_Z_ARGEXP           ; WHICH WAS ADJUSTED?
                 BEQ              AS_L_FADD_3_1          ; IF ARG, DO FAC-ARG
                 LDY              #MS_Z_ARGEXP           ; IF FAC, DO ARG-FAC
AS_L_FADD_3_1:    SEC                    ; SUBTRACT SMALLER FROM LARGER (WE HOPE)
                 EOR              #$FF                   ; (IF EXPONENTS WERE EQUAL, WE MIGHT BE
                 ADC              MS_Z_OLDOV             ; SUBTRACTING LARGER FROM SMALLER)
                 STA              MS_Z_FACOV
                 LDA              4,Y
                 SBC              4,X
                 STA              MS_Z_FAC + 4
                 LDA              3,Y
                 SBC              3,X
                 STA              MS_Z_FAC + 3
                 LDA              2,Y
                 SBC              2,X
                 STA              MS_Z_FAC + 2
                 LDA              1,Y
                 SBC              1,X
                 STA              MS_Z_FAC + 1
                                                         ; --------------------------------
                                                         ; NORMALIZE VALUE IN FAC
                                                         ; --------------------------------
AS_NORMALIZE_FAC_1:
                 BCS              AS_NORMALIZE_FAC_2
                 JSR              AS_COMPLEMENT_FAC
                                                         ; --------------------------------
AS_NORMALIZE_FAC_2:
                 LDY              #0                     ; SHIFT UP SIGNIF DIGIT
                 TYA                                     ; START A=0, COUNT SHIFTS IN A-REG
                 CLC
AS_L_NORMALIZE_FAC_2_1: LDX              MS_Z_FAC + 1           ; LOOK AT MOST SIGNIFICANT BYTE
                 BNE              AS_NORMALIZE_FAC_4     ; SOME 1-BITS HERE
                 LDX              MS_Z_FAC + 2           ; HI-BYTE OF MANTISSA STILL ZERO,
                 STX              MS_Z_FAC + 1           ; SO DO A FAST 8-BIT SHUFFLE
                 LDX              MS_Z_FAC + 3
                 STX              MS_Z_FAC + 2
                 LDX              MS_Z_FAC + 4
                 STX              MS_Z_FAC + 3
                 LDX              MS_Z_FACOV
                 STX              MS_Z_FAC + 4
                 STY              MS_Z_FACOV             ; ZERO EXTENSION BYTE
                 ADC              #8                     ; BUMP SHIFT COUNT
                 CMP              #32                    ; DONE 4 TIMES YET?
                 BNE              AS_L_NORMALIZE_FAC_2_1 ; NO, STILL MIGHT BE SOME 1'S
                                                         ; YES, VALUE OF FAC IS ZERO
                                                         ; --------------------------------
                                                         ; SET FAC = 0
                                                         ; (ONLY NECESSARY TO ZERO EXPONENT AND SIGN CELLS)
                                                         ; --------------------------------
AS_ZERO_FAC:
                 LDA              #0
                                                         ; --------------------------------
AS_STA_IN_FAC_SIGN_AND_EXP:
                 STA              MS_Z_FAC
                                                         ; --------------------------------
AS_STA_IN_FAC_SIGN:
                 STA              MS_Z_FACSGN
                 RTS
                                                         ; --------------------------------
                                                         ; ADD MANTISSAS OF FAC AND ARG INTO FAC
                                                         ; --------------------------------
AS_FADD_4:       ADC              MS_Z_OLDOV
                 STA              MS_Z_FACOV
                 LDA              MS_Z_FAC + 4
                 ADC              MS_Z_ARGEXP + 4
                 STA              MS_Z_FAC + 4
                 LDA              MS_Z_FAC + 3
                 ADC              MS_Z_ARGEXP + 3
                 STA              MS_Z_FAC + 3
                 LDA              MS_Z_FAC + 2
                 ADC              MS_Z_ARGEXP + 2
                 STA              MS_Z_FAC + 2
                 LDA              MS_Z_FAC + 1
                 ADC              MS_Z_ARGEXP + 1
                 STA              MS_Z_FAC + 1
                 JMP              AS_NORMALIZE_FAC_5
                                                         ; --------------------------------
                                                         ; FINISH NORMALIZING FAC
                                                         ; --------------------------------
AS_NORMALIZE_FAC_3:
                 ADC              #1                     ; COUNT BITS SHIFTED
                 ASL              MS_Z_FACOV
                 ROL              MS_Z_FAC + 4
                 ROL              MS_Z_FAC + 3
                 ROL              MS_Z_FAC + 2
                 ROL              MS_Z_FAC + 1
                                                         ; --------------------------------
AS_NORMALIZE_FAC_4:
                 BPL              AS_NORMALIZE_FAC_3     ; UNTIL TOP BIT = 1
                 SEC
                 SBC              MS_Z_FAC               ; ADJUST EXPONENT BY BITS SHIFTED
                 BCS              AS_ZERO_FAC            ; UNDERFLOW, RETURN ZERO
                 EOR              #$FF
                 ADC              #1                     ; 2'S COMPLEMENT
                 STA              MS_Z_FAC               ; CARRY=0 NOW
                                                         ; --------------------------------
AS_NORMALIZE_FAC_5:
                 BCC              AS_RTS_11              ; UNLESS MANTISSA CARRIED
                                                         ; --------------------------------
AS_NORMALIZE_FAC_6:
                 INC              MS_Z_FAC               ; MANTISSA CARRIED, SO SHIFT RIGHT
                 BEQ              AS_OVERFLOW            ; OVERFLOW IF EXPONENT TOO BIG
                 ROR              MS_Z_FAC + 1
                 ROR              MS_Z_FAC + 2
                 ROR              MS_Z_FAC + 3
                 ROR              MS_Z_FAC + 4
                 ROR              MS_Z_FACOV
AS_RTS_11:        RTS
                                                         ; --------------------------------
                                                         ; 2'S COMPLEMENT OF FAC
                                                         ; --------------------------------
AS_COMPLEMENT_FAC:
                 LDA              MS_Z_FACSGN
                 EOR              #$FF
                 STA              MS_Z_FACSGN
                                                         ; --------------------------------
                                                         ; 2'S COMPLEMENT OF FAC MANTISSA ONLY
                                                         ; --------------------------------
AS_COMPLEMENT_FAC_MANTISSA:
                 LDA              MS_Z_FAC + 1
                 EOR              #$FF
                 STA              MS_Z_FAC + 1
                 LDA              MS_Z_FAC + 2
                 EOR              #$FF
                 STA              MS_Z_FAC + 2
                 LDA              MS_Z_FAC + 3
                 EOR              #$FF
                 STA              MS_Z_FAC + 3
                 LDA              MS_Z_FAC + 4
                 EOR              #$FF
                 STA              MS_Z_FAC + 4
                 LDA              MS_Z_FACOV
                 EOR              #$FF
                 STA              MS_Z_FACOV
                 INC              MS_Z_FACOV             ; START INCREMENTING MANTISSA
                 BNE              AS_RTS_12
                                                         ; --------------------------------
                                                         ; INCREMENT FAC MANTISSA
                                                         ; --------------------------------
AS_INCREMENT_FAC_MANTISSA:
                 INC              MS_Z_FAC + 4           ; ADD CARRY FROM EXTRA
                 BNE              AS_RTS_12
                 INC              MS_Z_FAC + 3
                 BNE              AS_RTS_12
                 INC              MS_Z_FAC + 2
                 BNE              AS_RTS_12
                 INC              MS_Z_FAC + 1
AS_RTS_12:        RTS
                                                         ; --------------------------------
AS_OVERFLOW:
                 LDX              #MS_ERROV
                 JMP              MS_ERROR
                                                         ; --------------------------------
                                                         ; SHIFT 1,X THRU 5,X RIGHT
                                                         ; (A) = NEGATIVE OF SHIFT COUNT
                                                         ; (X) = POINTER TO BYTES TO BE SHIFTED

                                                         ; RETURN WITH (Y)=0, CARRY=0, EXTENSION BITS IN A-REG
                                                         ; --------------------------------
AS_SHIFT_RIGHT_1:
                 LDX              #AS_RESULT - 1         ; SHIFT RESULT RIGHT
AS_SHIFT_RIGHT_2:
                 LDY              4,X                    ; SHIFT 8 BITS RIGHT
                 STY              MS_Z_FACOV
                 LDY              3,X
                 STY              4,X
                 LDY              2,X
                 STY              3,X
                 LDY              1,X
                 STY              2,X
                 LDY              MS_Z_BITS              ; $00 IF +, $FF IF -
                 STY              1,X
                                                         ; --------------------------------
                                                         ; MAIN ENTRY TO RIGHT SHIFT SUBROUTINE
                                                         ; --------------------------------
AS_SHIFT_RIGHT:
                 ADC              #8
                 BMI              AS_SHIFT_RIGHT_2       ; STILL MORE THAN 8 BITS TO GO
                 BEQ              AS_SHIFT_RIGHT_2       ; EXACTLY 8 MORE BITS TO GO
                 SBC              #8                     ; UNDO ADC ABOVE
                 TAY                                     ; REMAINING SHIFT COUNT
                 LDA              MS_Z_FACOV
                 BCS              AS_SHIFT_RIGHT_5       ; FINISHED SHIFTING
AS_SHIFT_RIGHT_3:
AS_L:            ASL              1,X                    ; SIGN -> CARRY (SIGN EXTENSION)
                 BCC              AS_L_L_1               ; SIGN +
                 INC              1,X                    ; PUT SIGN IN LSB
AS_L_L_1:        ROR              1,X                    ; RESTORE VALUE, SIGN STILL IN CARRY
                 ROR              1,X                    ; START RIGHT SHIFT, INSERTING SIGN
                                                         ; --------------------------------
                                                         ; ENTER HERE FOR SHORT SHIFTS WITH NO SIGN EXTENSION
                                                         ; --------------------------------
AS_SHIFT_RIGHT_4:
                 ROR              2,X
                 ROR              3,X
                 ROR              4,X
                 ROR                                     ; EXTENSION
                 INY                                     ; COUNT THE SHIFT
                 BNE              AS_SHIFT_RIGHT_3
AS_SHIFT_RIGHT_5:
                 CLC                                     ; RETURN WITH CARRY CLEAR
                 RTS
                                                         ; --------------------------------
                                                         ; --------------------------------

MS_FONE             .BYTE $81,$00,$00,$00,$00
                                                         ; --------------------------------
AS_POLY_LOG            .BYTE 3                         ; # OF COEFFICIENTS - 1
                    .BYTE $7F,$5E,$56,$CB,$79       ; * X^7 +
                    .BYTE $80,$13,$9B,$0B,$64       ; * X^5 +
                    .BYTE $80,$76,$38,$93,$16       ; * X^3 +
                    .BYTE $82,$38,$AA,$3B,$20       ; * X
                                                         ; --------------------------------

AS_CON_SQR_HALF        .BYTE $80,$35,$04,$F3,$34
AS_CON_SQR_TWO         .BYTE $81,$35,$04,$F3,$34
AS_CON_NEG_HALF        .BYTE $80,$80,$00,$00,$00
AS_CON_LOG_TWO         .BYTE $80,$31,$72,$17,$F8
                                                         ; --------------------------------
                                                         ; "LOG" FUNCTION
                                                         ; --------------------------------
MS_LOG:          JSR              AS_SIGN                ; GET -1,0,+1 IN A-REG FOR FAC
                 BEQ              AS_GIQ                 ; LOG (0) IS ILLEGAL
                 BPL              AS_LOG_2               ; >0 IS OK
AS_GIQ:          JMP              AS_IQERR               ; <= 0 IS NO GOOD
AS_LOG_2:        LDA              MS_Z_FAC               ; FIRST GET LOG BASE 2
                 SBC              #$7F                   ; SAVE UNBIASED EXPONENT
                 PHA
                 LDA              #$80                   ; NORMALIZE BETWEEN L_LOG_2_5 AND 1
                 STA              MS_Z_FAC
                 LDA              #<AS_CON_SQR_HALF
                 LDY              #>AS_CON_SQR_HALF
                 JSR              AS_FADD                ; COMPUTE VIA SERIES OF ODD
                 LDA              #<AS_CON_SQR_TWO       ; POWERS OF
                 LDY              #>AS_CON_SQR_TWO       ; (SQR(2)X-1)/(SQR(2)X+1)
                 JSR              AS_FDIV
                 LDA              #<MS_FONE
                 LDY              #>MS_FONE
                 JSR              AS_FSUB
                 LDA              #<AS_POLY_LOG
                 LDY              #>AS_POLY_LOG
                 JSR              AS_POLYNOMIAL_ODD
                 LDA              #<AS_CON_NEG_HALF
                 LDY              #>AS_CON_NEG_HALF
                 JSR              AS_FADD
                 PLA
                 JSR              AS_ADDACC              ; ADD ORIGINAL EXPONENT
                 LDA              #<AS_CON_LOG_TWO       ; MULTIPLY BY LOG(2) TO FORM
                 LDY              #>AS_CON_LOG_TWO       ; NATURAL LOG OF X
                                                         ; --------------------------------
                                                         ; FAC = (Y,A) * FAC
                                                         ; --------------------------------
AS_FMULT:        JSR              AS_LOAD_ARG_FROM_YA
                                                         ; --------------------------------
                                                         ; FAC = ARG * FAC
                                                         ; --------------------------------
MS_FMULTT:       BNE              AS_L_FMULTT_1          ; FAC .NE. ZERO
                 JMP              AS_RTS_13              ; FAC = 0 * ARG = 0
                                                         ; <<< WHY IS LINE ABOVE JUST "RTS"? >>>
                                                         ; --------------------------------

                                                         ; --------------------------------
AS_L_FMULTT_1:   JSR              AS_ADD_EXPONENTS
                 LDA              #0
                 STA              AS_RESULT              ; INIT PRODUCT = 0
                 STA              AS_RESULT + 1
                 STA              AS_RESULT + 2
                 STA              AS_RESULT + 3
                 LDA              MS_Z_FACOV
                 JSR              AS_MULTIPLY_1
                 LDA              MS_Z_FAC + 4
                 JSR              AS_MULTIPLY_1
                 LDA              MS_Z_FAC + 3
                 JSR              AS_MULTIPLY_1
                 LDA              MS_Z_FAC + 2
                 JSR              AS_MULTIPLY_1
                 LDA              MS_Z_FAC + 1
                 JSR              AS_MULTIPLY_2
                 JMP              AS_COPY_RESULT_INTO_FAC
                                                         ; --------------------------------
                                                         ; MULTIPLY ARG BY (A) INTO RESULT
                                                         ; --------------------------------
AS_MULTIPLY_1:
                 BNE              AS_MULTIPLY_2          ; THIS BYTE NON-ZERO
                 JMP              AS_SHIFT_RIGHT_1       ; (A)=0, JUST SHIFT ARG RIGHT 8
                                                         ; --------------------------------
AS_MULTIPLY_2:
                 LSR                                     ; SHIFT BIT INTO CARRY
                 ORA              #$80                   ; SUPPLY SENTINEL BIT
AS_L_MULTIPLY_2_1: TAY                    ; REMAINING MULTIPLIER TO Y
                 BCC              AS_L_MULTIPLY_2_2      ; THIS MULTIPLIER BIT = 0
                 CLC                                     ; = 1, SO ADD ARG TO RESULT
                 LDA              AS_RESULT + 3
                 ADC              MS_Z_ARGEXP + 4
                 STA              AS_RESULT + 3
                 LDA              AS_RESULT + 2
                 ADC              MS_Z_ARGEXP + 3
                 STA              AS_RESULT + 2
                 LDA              AS_RESULT + 1
                 ADC              MS_Z_ARGEXP + 2
                 STA              AS_RESULT + 1
                 LDA              AS_RESULT
                 ADC              MS_Z_ARGEXP + 1
                 STA              AS_RESULT
AS_L_MULTIPLY_2_2: ROR              AS_RESULT              ; SHIFT RESULT RIGHT 1
                 ROR              AS_RESULT + 1
                 ROR              AS_RESULT + 2
                 ROR              AS_RESULT + 3
                 ROR              MS_Z_FACOV
                 TYA                                     ; REMAINING MULTIPLIER
                 LSR                                     ; LSB INTO CARRY
                 BNE              AS_L_MULTIPLY_2_1      ; IF SENTINEL STILL HERE, MULTIPLY
AS_RTS_13:        RTS                    ; 8 X 32 COMPLETED
                                                         ; --------------------------------
                                                         ; UNPACK NUMBER AT (Y,A) INTO ARG
                                                         ; --------------------------------
AS_LOAD_ARG_FROM_YA:
                 STA              MS_Z_INDEX             ; USE INDEX FOR PNTR
                 STY              MS_Z_INDEX + 1
                 LDY              #4                     ; FIVE BYTES TO MOVE
                 LDA              (MS_Z_INDEX),Y
                 STA              MS_Z_ARGEXP + 4
                 DEY
                 LDA              (MS_Z_INDEX),Y
                 STA              MS_Z_ARGEXP + 3
                 DEY
                 LDA              (MS_Z_INDEX),Y
                 STA              MS_Z_ARGEXP + 2
                 DEY
                 LDA              (MS_Z_INDEX),Y
                 STA              MS_Z_ARGSGN
                 EOR              MS_Z_FACSGN            ; SET COMBINED SIGN FOR MULT/DIV
                 STA              MS_Z_ARISGN
                 LDA              MS_Z_ARGSGN            ; TURN ON NORMALIZED INVISIBLE BIT
                 ORA              #$80                   ; TO COMPLETE MANTISSA
                 STA              MS_Z_ARGEXP + 1
                 DEY
                 LDA              (MS_Z_INDEX),Y
                 STA              MS_Z_ARGEXP            ; EXPONENT
                 LDA              MS_Z_FAC               ; SET STATUS BITS ON FAC EXPONENT
                 RTS
                                                         ; --------------------------------
                                                         ; ADD EXPONENTS OF ARG AND FAC
                                                         ; (CALLED BY FMULT AND FDIV)

                                                         ; ALSO CHECK FOR OVERFLOW, AND SET RESULT SIGN
                                                         ; --------------------------------
AS_ADD_EXPONENTS:
                 LDA              MS_Z_ARGEXP
                                                         ; --------------------------------
AS_ADD_EXPONENTS_1:
                 BEQ              AS_ZERO                ; IF ARG=0, RESULT IS ZERO
                 CLC
                 ADC              MS_Z_FAC
                 BCC              AS_L_ADD_EXPONENTS_1_1 ; IN RANGE
                 BMI              AS_JOV                 ; OVERFLOW
                 CLC
                    .BYTE $2C                       ; TRICK TO SKIP
AS_L_ADD_EXPONENTS_1_1: BPL              AS_ZERO                ; OVERFLOW
                 ADC              #$80                   ; RE-BIAS
                 STA              MS_Z_FAC               ; RESULT
                 BNE              AS_L_ADD_EXPONENTS_1_2
                 JMP              AS_STA_IN_FAC_SIGN     ; RESULT IS ZERO
                                                         ; <<< CRAZY TO JUMP WAY BACK THERE! >>>
                                                         ; <<< SAME IDENTICAL CODE IS BELOW! >>>
                                                         ; <<< INSTEAD OF BNE L_ADD_EXPONENTS_1_2, JMP STA.IN.FAC.SIGN   >>>
                                                         ; <<< ONLY NEEDED BEQ L_ADD_EXPONENTS_1_3            >>>
AS_L_ADD_EXPONENTS_1_2: LDA              MS_Z_ARISGN            ; SET SIGN OF RESULT
AS_L_ADD_EXPONENTS_1_3: STA              MS_Z_FACSGN
                 RTS
                                                         ; --------------------------------
                                                         ; IF (FAC) IS POSITIVE, GIVE "OVERFLOW" ERROR
                                                         ; IF (FAC) IS NEGATIVE, SET FAC=0, POP ONE RETURN, AND RTS
                                                         ; CALLED FROM "EXP" FUNCTION
                                                         ; --------------------------------
AS_OUTOFRNG:
                 LDA              MS_Z_FACSGN
                 EOR              #$FF
                 BMI              AS_JOV                 ; ERROR IF POSITIVE #
                                                         ; --------------------------------
                                                         ; POP RETURN ADDRESS AND SET FAC=0
                                                         ; --------------------------------
AS_ZERO:          PLA
                 PLA
                 JMP              AS_ZERO_FAC
                                                         ; --------------------------------
AS_JOV:          JMP              AS_OVERFLOW
                                                         ; --------------------------------
                                                         ; MULTIPLY FAC BY 10
                                                         ; --------------------------------
AS_MUL10:        JSR              AS_COPY_FAC_TO_ARG_ROUNDED
                 TAX                                     ; TEXT FAC EXPONENT
                 BEQ              AS_L_MUL10_1           ; FINISHED IF FAC=0
                 CLC
                 ADC              #2                     ; ADD 2 TO EXPONENT GIVES (FAC)*4
                 BCS              AS_JOV                 ; OVERFLOW
                 LDX              #0
                 STX              MS_Z_ARISGN
                 JSR              AS_FADD_2              ; MAKES (FAC)*5
                 INC              MS_Z_FAC               ; *2, MAKES (FAC)*10
                 BEQ              AS_JOV                 ; OVERFLOW
AS_L_MUL10_1:     RTS
                                                         ; --------------------------------

AS_CON_TEN             .BYTE $84,$20,$00,$00,$00
                                                         ; --------------------------------
                                                         ; DIVIDE FAC BY 10
                                                         ; --------------------------------
AS_DIV10:        JSR              AS_COPY_FAC_TO_ARG_ROUNDED
                 LDA              #<AS_CON_TEN           ; SET UP TO PUT
                 LDY              #>AS_CON_TEN           ; 10 IN FAC
                 LDX              #0
                                                         ; --------------------------------
                                                         ; FAC = ARG / (Y,A)
                                                         ; --------------------------------
AS_DIV:          STX              MS_Z_ARISGN
                 JSR              AS_LOAD_FAC_FROM_YA
                 JMP              MS_FDIVT               ; DIVIDE ARG BY FAC
                                                         ; --------------------------------
                                                         ; FAC = (Y,A) / FAC
                                                         ; --------------------------------
AS_FDIV:         JSR              AS_LOAD_ARG_FROM_YA
                                                         ; --------------------------------
                                                         ; FAC = ARG / FAC
                                                         ; --------------------------------
MS_FDIVT:        BEQ              AS_L_FDIVT_8           ; FAC = 0, DIVIDE BY ZERO ERROR
                 JSR              AS_ROUND_FAC
                 LDA              #0                     ; NEGATE FAC EXPONENT, SO
                 SEC                                     ; ADD.EXPONENTS FORMS DIFFERENCE
                 SBC              MS_Z_FAC
                 STA              MS_Z_FAC
                 JSR              AS_ADD_EXPONENTS
                 INC              MS_Z_FAC
                 BEQ              AS_JOV                 ; OVERFLOW
                 LDX              #$FC                   ; INDEX FOR RESULT
                 LDA              #1                     ; SENTINEL
AS_L_FDIVT_1:    LDY              MS_Z_ARGEXP + 1        ; SEE IF FAC CAN BE SUBTRACTED
                 CPY              MS_Z_FAC + 1
                 BNE              AS_L_FDIVT_2
                 LDY              MS_Z_ARGEXP + 2
                 CPY              MS_Z_FAC + 2
                 BNE              AS_L_FDIVT_2
                 LDY              MS_Z_ARGEXP + 3
                 CPY              MS_Z_FAC + 3
                 BNE              AS_L_FDIVT_2
                 LDY              MS_Z_ARGEXP + 4
                 CPY              MS_Z_FAC + 4
AS_L_FDIVT_2:     PHP                    ; SAVE THE ANSWER, AND ALSO ROLL THE
                 ROL                                     ; BIT INTO THE QUOTIENT, SENTINEL OUT
                 BCC              AS_L_FDIVT_3           ; NO SENTINEL, STILL NOT 8 TRIPS
                 INX                                     ; 8 TRIPS, STORE BYTE OF QUOTIENT
                 STA              AS_RESULT + 3,X
                 BEQ              AS_L_FDIVT_6           ; 32-BITS COMPLETED
                 BPL              AS_L_FDIVT_7           ; FINAL EXIT WHEN X=1
                 LDA              #1                     ; RE-START SENTINEL
AS_L_FDIVT_3:     PLP                    ; GET ANSWER, CAN FAC BE SUBTRACTED?
                 BCS              AS_L_FDIVT_5           ; YES, DO IT
AS_L_FDIVT_4:    ASL              MS_Z_ARGEXP + 4        ; NO, SHIFT ARG LEFT
                 ROL              MS_Z_ARGEXP + 3
                 ROL              MS_Z_ARGEXP + 2
                 ROL              MS_Z_ARGEXP + 1
                 BCS              AS_L_FDIVT_2           ; ANOTHER TRIP
                 BMI              AS_L_FDIVT_1           ; HAVE TO COMPARE FIRST
                 BPL              AS_L_FDIVT_2           ; ...ALWAYS
AS_L_FDIVT_5:     TAY                    ; SAVE QUOTIENT/SENTINEL BYTE
                 LDA              MS_Z_ARGEXP + 4        ; SUBTRACT FAC FROM ARG ONCE
                 SBC              MS_Z_FAC + 4
                 STA              MS_Z_ARGEXP + 4
                 LDA              MS_Z_ARGEXP + 3
                 SBC              MS_Z_FAC + 3
                 STA              MS_Z_ARGEXP + 3
                 LDA              MS_Z_ARGEXP + 2
                 SBC              MS_Z_FAC + 2
                 STA              MS_Z_ARGEXP + 2
                 LDA              MS_Z_ARGEXP + 1
                 SBC              MS_Z_FAC + 1
                 STA              MS_Z_ARGEXP + 1
                 TYA                                     ; RESTORE QUOTIENT/SENTINEL BYTE
                 JMP              AS_L_FDIVT_4           ; GO TO SHIFT ARG AND CONTINUE
                                                         ; --------------------------------
AS_L_FDIVT_6:    LDA              #$40                   ; DO A FEW EXTENSION BITS
                 BNE              AS_L_FDIVT_3           ; ...ALWAYS
                                                         ; --------------------------------
AS_L_FDIVT_7:     ASL                    ; LEFT JUSTIFY THE EXTENSION BITS WE DID
                 ASL
                 ASL
                 ASL
                 ASL
                 ASL
                 STA              MS_Z_FACOV
                 PLP
                 JMP              AS_COPY_RESULT_INTO_FAC
                                                         ; --------------------------------
AS_L_FDIVT_8:    LDX              #MS_ERRDV0
                 JMP              MS_ERROR
                                                         ; --------------------------------
                                                         ; COPY RESULT INTO FAC MANTISSA, AND NORMALIZE
                                                         ; --------------------------------
AS_COPY_RESULT_INTO_FAC:
                 LDA              AS_RESULT
                 STA              MS_Z_FAC + 1
                 LDA              AS_RESULT + 1
                 STA              MS_Z_FAC + 2
                 LDA              AS_RESULT + 2
                 STA              MS_Z_FAC + 3
                 LDA              AS_RESULT + 3
                 STA              MS_Z_FAC + 4
                 JMP              AS_NORMALIZE_FAC_2
                                                         ; --------------------------------
                                                         ; UNPACK (Y,A) INTO FAC
                                                         ; --------------------------------
AS_LOAD_FAC_FROM_YA:
                 STA              MS_Z_INDEX             ; USE INDEX FOR PNTR
                 STY              MS_Z_INDEX + 1
                 LDY              #4                     ; PICK UP 5 BYTES
                 LDA              (MS_Z_INDEX),Y
                 STA              MS_Z_FAC + 4
                 DEY
                 LDA              (MS_Z_INDEX),Y
                 STA              MS_Z_FAC + 3
                 DEY
                 LDA              (MS_Z_INDEX),Y
                 STA              MS_Z_FAC + 2
                 DEY
                 LDA              (MS_Z_INDEX),Y
                 STA              MS_Z_FACSGN            ; FIRST BIT IS SIGN
                 ORA              #$80                   ; SET NORMALIZED INVISIBLE BIT
                 STA              MS_Z_FAC + 1
                 DEY
                 LDA              (MS_Z_INDEX),Y
                 STA              MS_Z_FAC               ; EXPONENT
                 STY              MS_Z_FACOV             ; Y=0
                 RTS
                                                         ; --------------------------------
                                                         ; ROUND FAC, STORE IN TEMP2
                                                         ; --------------------------------
AS_STORE_FAC_IN_TEMP2_ROUNDED:
                 LDX              #MS_Z_TEMPF2           ; PACK FAC INTO TEMP2
                    .BYTE $2C                       ; TRICK TO BRANCH
                                                         ; --------------------------------
                                                         ; ROUND FAC, STORE IN TEMP1
                                                         ; --------------------------------
AS_STORE_FAC_IN_TEMP1_ROUNDED:
                 LDX              #<MS_Z_TEMPF1          ; PACK FAC INTO TEMP1
                 LDY              #>MS_Z_TEMPF1          ; HI-BYTE OF TEMP1 SAME AS TEMP2
                 BEQ              AS_STORE_FACDB_YX_ROUNDED ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; ROUND FAC, AND STORE WHERE FORPNT POINTS
                                                         ; --------------------------------
AS_SETFOR:       LDX              MS_Z_FORPNT
                 LDY              MS_Z_FORPNT + 1
                                                         ; --------------------------------
                                                         ; ROUND FAC, AND STORE AT (Y,X)
                                                         ; --------------------------------
AS_STORE_FACDB_YX_ROUNDED:
                 JSR              AS_ROUND_FAC           ; ROUND VALUE IN FAC USING EXTENSION
                 STX              MS_Z_INDEX             ; USE INDEX FOR PNTR
                 STY              MS_Z_INDEX + 1
                 LDY              #4                     ; STORING 5 PACKED BYTES
                 LDA              MS_Z_FAC + 4
                 STA              (MS_Z_INDEX),Y
                 DEY
                 LDA              MS_Z_FAC + 3
                 STA              (MS_Z_INDEX),Y
                 DEY
                 LDA              MS_Z_FAC + 2
                 STA              (MS_Z_INDEX),Y
                 DEY
                 LDA              MS_Z_FACSGN            ; PACK SIGN IN TOP BIT OF MANTISSA
                 ORA              #$7F
                 AND              MS_Z_FAC + 1
                 STA              (MS_Z_INDEX),Y
                 DEY
                 LDA              MS_Z_FAC               ; EXPONENT
                 STA              (MS_Z_INDEX),Y
                 STY              MS_Z_FACOV             ; ZERO THE EXTENSION
                 RTS
                                                         ; --------------------------------
                                                         ; COPY ARG INTO FAC
                                                         ; --------------------------------
AS_COPY_ARG_TO_FAC:
                 LDA              MS_Z_ARGSGN            ; COPY SIGN
AS_MFA:          STA              MS_Z_FACSGN
                 LDX              #5                     ; MOVE 5 BYTES
AS_L_MFA_1:      LDA              MS_Z_ARGEXP - 1,X
                 STA              MS_Z_FAC - 1,X
                 DEX
                 BNE              AS_L_MFA_1
                 STX              MS_Z_FACOV             ; ZERO EXTENSION
                 RTS
                                                         ; --------------------------------
                                                         ; ROUND FAC AND COPY TO ARG
                                                         ; --------------------------------
AS_COPY_FAC_TO_ARG_ROUNDED:
                 JSR              AS_ROUND_FAC           ; ROUND FAC USING EXTENSION
AS_MAF:          LDX              #6                     ; COPY 6 BYTES, INCLUDES SIGN
AS_L_MAF_1:      LDA              MS_Z_FAC - 1,X
                 STA              MS_Z_ARGEXP - 1,X
                 DEX
                 BNE              AS_L_MAF_1
                 STX              MS_Z_FACOV             ; ZERO FAC EXTENSION
AS_RTS_14:        RTS
                                                         ; --------------------------------
                                                         ; ROUND FAC USING EXTENSION BYTE
                                                         ; --------------------------------
AS_ROUND_FAC:
                 LDA              MS_Z_FAC
                 BEQ              AS_RTS_14              ; FAC = 0, RETURN
                 ASL              MS_Z_FACOV             ; IS FAC.EXTENSION >= 128?
                 BCC              AS_RTS_14              ; NO, FINISHED
                                                         ; --------------------------------
                                                         ; INCREMENT MANTISSA AND RE-NORMALIZE IF CARRY
                                                         ; --------------------------------
AS_INCREMENT_MANTISSA:
                 JSR              AS_INCREMENT_FAC_MANTISSA ; YES, INCREMENT FAC
                 BNE              AS_RTS_14              ; HIGH BYTE HAS BITS, FINISHED
                 JMP              AS_NORMALIZE_FAC_6     ; HI-BYTE=0, SO SHIFT LEFT
                                                         ; --------------------------------
                                                         ; TEST FAC FOR ZERO AND SIGN

                                                         ; FAC > 0, RETURN +1
                                                         ; FAC = 0, RETURN  0
                                                         ; FAC < 0, RETURN -1
                                                         ; --------------------------------
AS_SIGN:         LDA              MS_Z_FAC               ; CHECK SIGN OF FAC AND
                 BEQ              AS_RTS_15              ; RETURN -1,0,1 IN A-REG
                                                         ; --------------------------------
AS_SIGN1:        LDA              MS_Z_FACSGN
                                                         ; --------------------------------
AS_SIGN2:         ROL                    ; MSBIT TO CARRY
                 LDA              #$FF                   ; -1
                 BCS              AS_RTS_15              ; MSBIT = 1
                 LDA              #1                     ; +1
AS_RTS_15:        RTS
                                                         ; --------------------------------
                                                         ; "SGN" FUNCTION
                                                         ; --------------------------------
MS_SGN:          JSR              AS_SIGN                ; CONVERT FAC TO -1,0,1
                                                         ; --------------------------------
                                                         ; CONVERT (A) INTO FAC, AS SIGNED VALUE -128 TO +127
                                                         ; --------------------------------
AS_FLOAT:        STA              MS_Z_FAC + 1           ; PUT IN HIGH BYTE OF MANTISSA
                 LDA              #0                     ; CLEAR 2ND BYTE OF MANTISSA
                 STA              MS_Z_FAC + 2
                 LDX              #$88                   ; USE EXPONENT 2^9
                                                         ; --------------------------------
                                                         ; FLOAT UNSIGNED VALUE IN FAC+1,2
                                                         ; (X) = EXPONENT
                                                         ; --------------------------------
AS_FLOAT_1:
                 LDA              MS_Z_FAC + 1           ; MSBIT=0, SET CARRY; =1, CLEAR CARRY
                 EOR              #$FF
                 ROL
                                                         ; --------------------------------
                                                         ; FLOAT UNSIGNED VALUE IN FAC+1,2
                                                         ; (X) = EXPONENT
                                                         ; C=0 TO MAKE VALUE NEGATIVE
                                                         ; C=1 TO MAKE VALUE POSITIVE
                                                         ; --------------------------------
AS_FLOAT_2:
                 LDA              #0                     ; CLEAR LOWER 16-BITS OF MANTISSA
                 STA              MS_Z_FAC + 4
                 STA              MS_Z_FAC + 3
                 STX              MS_Z_FAC               ; STORE EXPONENT
                 STA              MS_Z_FACOV             ; CLEAR EXTENSION
                 STA              MS_Z_FACSGN            ; MAKE SIGN POSITIVE
                 JMP              AS_NORMALIZE_FAC_1     ; IF C=0, WILL NEGATE FAC
                                                         ; --------------------------------
                                                         ; "ABS" FUNCTION
                                                         ; --------------------------------
MS_ABS:          LSR              MS_Z_FACSGN            ; CHANGE SIGN TO +
                 RTS
                                                         ; --------------------------------
                                                         ; COMPARE FAC WITH PACKED # AT (Y,A)
                                                         ; RETURN A=1,0,-1 AS (Y,A) IS <,=,> FAC
                                                         ; --------------------------------
AS_FCOMP:        STA              AS_DEST                ; USE DEST FOR PNTR
                                                         ; --------------------------------
                                                         ; SPECIAL ENTRY FROM "NEXT" PROCESSOR
                                                         ; "DEST" ALREADY SET UP
                                                         ; --------------------------------
AS_FCOMP2:       STY              AS_DEST + 1
                 LDY              #0                     ; GET EXPONENT OF COMPARAND
                 LDA              (AS_DEST),Y
                 INY                                     ; POINT AT NEXT BYTE
                 TAX                                     ; EXPONENT TO X-REG
                 BEQ              AS_SIGN                ; IF COMPARAND=0, "SIGN" COMPARES FAC
                 LDA              (AS_DEST),Y            ; GET HI-BYTE OF MANTISSA
                 EOR              MS_Z_FACSGN            ; COMPARE WITH FAC SIGN
                 BMI              AS_SIGN1               ; DIFFERENT SIGNS, "SIGN" GIVES ANSWER
                 CPX              MS_Z_FAC               ; SAME SIGN, SO COMPARE EXPONENTS
                 BNE              AS_L_FCOMP2_1          ; DIFFERENT, SO SUFFICIENT TEST
                 LDA              (AS_DEST),Y            ; SAME EXPONENT, COMPARE MANTISSA
                 ORA              #$80                   ; SET INVISIBLE NORMALIZED BIT
                 CMP              MS_Z_FAC + 1
                 BNE              AS_L_FCOMP2_1          ; NOT SAME, SO SUFFICIENT
                 INY                                     ; SAME, COMPARE MORE MANTISSA
                 LDA              (AS_DEST),Y
                 CMP              MS_Z_FAC + 2
                 BNE              AS_L_FCOMP2_1          ; NOT SAME, SO SUFFICIENT
                 INY                                     ; SAME, COMPARE MORE MANTISSA
                 LDA              (AS_DEST),Y
                 CMP              MS_Z_FAC + 3
                 BNE              AS_L_FCOMP2_1          ; NOT SAME, SO SUFFICIENT
                 INY                                     ; SAME, COMPARE REST OF MANTISSA
                 LDA              #$7F                   ; ARTIFICIAL EXTENSION BYTE FOR COMPARAND
                 CMP              MS_Z_FACOV
                 LDA              (AS_DEST),Y
                 SBC              MS_Z_FAC + 4
                 BEQ              AS_RTS_16              ; NUMBERS ARE EQUAL, RETURN (A)=0
AS_L_FCOMP2_1:   LDA              MS_Z_FACSGN            ; NUMBERS ARE DIFFERENT
                 BCC              AS_L_FCOMP2_2          ; FAC IS LARGER MAGNITUDE
                 EOR              #$FF                   ; FAC IS SMALLER MAGNITUDE
                                                         ; <<<  NOTE THAT ABOVE THREE LINES CAN BE SHORTENED: >>>
                                                         ; <<<  L_FCOMP2_1  ROR              PUT CARRY INTO SIGN BIT  >>>
                                                         ; <<<      EOR FAC.SIGN     TOGGLE WITH SIGN OF FAC  >>>
AS_L_FCOMP2_2:   JMP              AS_SIGN2               ; CONVERT +1 OR -1
                                                         ; --------------------------------
                                                         ; QUICK INTEGER FUNCTION

                                                         ; CONVERTS FP VALUE IN FAC TO INTEGER VALUE
                                                         ; IN FAC+1...FAC+4, BY SHIFTING RIGHT WITH SIGN
                                                         ; EXTENSION UNTIL FRACTIONAL BITS ARE OUT.

                                                         ; THIS SUBROUTINE ASSUMES THE EXPONENT < 32.
                                                         ; --------------------------------
AS_QINT:         LDA              MS_Z_FAC               ; LOOK AT FAC EXPONENT
                 BEQ              AS_QINT_3              ; FAC=0, SO FINISHED
                 SEC                                     ; GET -(NUMBER OF FRACTIONAL BITS)
                 SBC              #$A0                   ; IN A-REG FOR SHIFT COUNT
                 BIT              MS_Z_FACSGN            ; CHECK SIGN OF FAC
                 BPL              AS_L_QINT_1            ; POSITIVE, CONTINUE
                 TAX                                     ; NEGATIVE, SO COMPLEMENT MANTISSA
                 LDA              #$FF                   ; AND SET SIGN EXTENSION FOR SHIFT
                 STA              MS_Z_BITS
                 JSR              AS_COMPLEMENT_FAC_MANTISSA
                 TXA                                     ; RESTORE BIT COUNT TO A-REG
AS_L_QINT_1:     LDX              #MS_Z_FAC              ; POINT SHIFT SUBROUTINE AT FAC
                 CMP              #$F9                   ; MORE THAN 7 BITS TO SHIFT?
                 BPL              AS_QINT_2              ; NO, SHORT SHIFT
                 JSR              AS_SHIFT_RIGHT         ; YES, USE GENERAL ROUTINE
                 STY              MS_Z_BITS              ; Y=0, CLEAR SIGN EXTENSION
AS_RTS_16:        RTS
                                                         ; --------------------------------
AS_QINT_2:        TAY                    ; SAVE SHIFT COUNT
                 LDA              MS_Z_FACSGN            ; GET SIGN BIT
                 AND              #$80
                 LSR              MS_Z_FAC + 1           ; START RIGHT SHIFT
                 ORA              MS_Z_FAC + 1           ; AND MERGE WITH SIGN
                 STA              MS_Z_FAC + 1
                 JSR              AS_SHIFT_RIGHT_4       ; JUMP INTO MIDDLE OF SHIFTER
                 STY              MS_Z_BITS              ; Y=0, CLEAR SIGN EXTENSION
                 RTS
                                                         ; --------------------------------
                                                         ; "INT" FUNCTION

                                                         ; USES QINT TO CONVERT (FAC) TO INTEGER FORM,
                                                         ; AND THEN REFLOATS THE INTEGER.
                                                         ; <<< A FASTER APPROACH WOULD SIMPLY CLEAR >>>
                                                         ; <<< THE FRACTIONAL BITS BY ZEROING THEM  >>>
                                                         ; --------------------------------
MS_INT:          LDA              MS_Z_FAC               ; CHECK IF EXPONENT < 32
                 CMP              #$A0                   ; BECAUSE IF > 31 THERE IS NO FRACTION
                 BCS              AS_RTS_17              ; NO FRACTION, WE ARE FINISHED
                 JSR              AS_QINT                ; USE GENERAL INTEGER CONVERSION
                 STY              MS_Z_FACOV             ; Y=0, CLEAR EXTENSION
                 LDA              MS_Z_FACSGN            ; GET SIGN OF VALUE
                 STY              MS_Z_FACSGN            ; Y=0, CLEAR SIGN
                 EOR              #$80                   ; TOGGLE ACTUAL SIGN
                 ROL                                     ; AND SAVE IN CARRY
                 LDA              #$A0                   ; SET EXPONENT TO 32
                 STA              MS_Z_FAC               ; BECAUSE 4-BYTE INTEGER NOW
                 LDA              MS_Z_FAC + 4           ; SAVE LOW 8-BITS OF INTEGER FORM
                 STA              MS_Z_CHARAC            ; FOR EXP AND POWER
                 JMP              AS_NORMALIZE_FAC_1     ; NORMALIZE TO FINISH CONVERSION
                                                         ; --------------------------------
AS_QINT_3:       STA              MS_Z_FAC + 1           ; FAC=0, SO CLEAR ALL 4 BYTES FOR
                 STA              MS_Z_FAC + 2           ; INTEGER VERSION
                 STA              MS_Z_FAC + 3
                 STA              MS_Z_FAC + 4
                 TAY                                     ; Y=0 TOO
AS_RTS_17:        RTS
                                                         ; --------------------------------
                                                         ; CONVERT STRING TO FP VALUE IN FAC

                                                         ; STRING POINTED TO BY TXTPTR
                                                         ; FIRST CHAR ALREADY SCANNED BY CHRGET
                                                         ; (A) = FIRST CHAR, C=0 IF DIGIT.
                                                         ; --------------------------------
AS_FIN:          LDY              #0                     ; CLEAR WORKING AREA ($99...$A3)
                 LDX              #10                    ; TMPEXP, EXPON, DPFLG, EXPSGN, FAC, SERLEN
AS_L_FIN_1:      STY              AS_TMPEXP,X
                 DEX
                 BPL              AS_L_FIN_1
                                                         ; --------------------------------
                 BCC              AS_FIN_2               ; FIRST CHAR IS A DIGIT
                 CMP              #"-" & %01111111       ; CHECK FOR LEADING SIGN
                 BNE              AS_L_FIN_2             ; NOT MINUS
                 STX              MS_Z_DEGREE            ; MINUS, SET SERLEN = $FF FOR FLAG
                 BEQ              AS_FIN_1               ; ...ALWAYS
AS_L_FIN_2:      CMP              #"+" & %01111111       ; MIGHT BE PLUS
                 BNE              AS_FIN_3               ; NOT PLUS EITHER, CHECK DECIMAL POINT
                                                         ; --------------------------------
AS_FIN_1:        JSR              MS_Z_CHRGET            ; GET NEXT CHAR OF STRING
                                                         ; --------------------------------
AS_FIN_2:        BCC              AS_FIN_9               ; INSERT THIS DIGIT
                                                         ; --------------------------------
AS_FIN_3:        CMP              #"." & %01111111       ; CHECK FOR DECIMAL POINT
                 BEQ              AS_FIN_10              ; YES
                 CMP              #"E" & %01111111       ; CHECK FOR EXPONENT PART
                 BNE              AS_FIN_7               ; NO, END OF NUMBER
                 JSR              MS_Z_CHRGET            ; YES, START CONVERTING EXPONENT
                 BCC              AS_FIN_5               ; EXPONENT DIGIT
                 CMP              #MS_MINUTK             ; NEGATIVE EXPONENT?
                 BEQ              AS_L_FIN_3_1           ; YES
                 CMP              #"-" & %01111111       ; MIGHT NOT BE TOKENIZED YET
                 BEQ              AS_L_FIN_3_1           ; YES, IT IS NEGATIVE
                 CMP              #MS_PLUSTK             ; OPTIONAL "+"
                 BEQ              AS_FIN_4               ; YES
                 CMP              #"+" & %01111111       ; MIGHT NOT BE TOKENIZED YET
                 BEQ              AS_FIN_4               ; YES, FOUND "+"
                 BNE              AS_FIN_6               ; ...ALWAYS, NUMBER COMPLETED
AS_L_FIN_3_1:    ROR              MS_Z_EXPSGN            ; C=1, SET FLAG NEGATIVE
                                                         ; --------------------------------
AS_FIN_4:        JSR              MS_Z_CHRGET            ; GET NEXT DIGIT OF EXPONENT
                                                         ; --------------------------------
AS_FIN_5:        BCC              AS_GETEXP              ; CHAR IS A DIGIT OF EXPONENT
                                                         ; --------------------------------
AS_FIN_6:        BIT              MS_Z_EXPSGN            ; END OF NUMBER, CHECK EXP SIGN
                 BPL              AS_FIN_7               ; POSITIVE EXPONENT
                 LDA              #0                     ; NEGATIVE EXPONENT
                 SEC                                     ; MAKE 2'S COMPLEMENT OF EXPONENT
                 SBC              MS_Z_TENEXP
                 JMP              AS_FIN_8
                                                         ; --------------------------------
                                                         ; FOUND A DECIMAL POINT
                                                         ; --------------------------------
AS_FIN_10:       ROR              MS_Z_DPTFLG            ; C=1, SET DPFLG FOR DECIMAL POINT
                 BIT              MS_Z_DPTFLG            ; CHECK IF PREVIOUS DEC. PT.
                 BVC              AS_FIN_1               ; NO PREVIOUS DECIMAL POINT
                                                         ; A SECOND DECIMAL POINT IS TAKEN AS A TERMINATOR
                                                         ; TO THE NUMERIC STRING.
                                                         ; "A=11..22" WILL GIVE A SYNTAX ERROR, BECAUSE
                                                         ; IT IS TWO NUMBERS WITH NO OPERATOR BETWEEN.
                                                         ; "PRINT 11..22" GIVES NO ERROR, BECAUSE IT IS
                                                         ; JUST THE CONCATENATION OF TWO NUMBERS.
                                                         ; --------------------------------
                                                         ; NUMBER TERMINATED, ADJUST EXPONENT NOW
                                                         ; --------------------------------
AS_FIN_7:        LDA              MS_Z_TENEXP            ; E-VALUE
AS_FIN_8:         SEC                    ; MODIFY WITH COUNT OF DIGITS
                 SBC              AS_TMPEXP              ; AFTER THE DECIMAL POINT
                 STA              MS_Z_TENEXP            ; COMPLETE CURRENT EXPONENT
                 BEQ              AS_L_FIN_8_15          ; NO ADJUST NEEDED IF EXP=0
                 BPL              AS_L_FIN_8_14          ; EXP>0, MULTIPLY BY TEN
AS_L_FIN_8_13:   JSR              AS_DIV10               ; EXP<0, DIVIDE BY TEN
                 INC              MS_Z_TENEXP            ; UNTIL EXP=0
                 BNE              AS_L_FIN_8_13
                 BEQ              AS_L_FIN_8_15          ; ...ALWAYS, WE ARE FINISHED
AS_L_FIN_8_14:   JSR              AS_MUL10               ; EXP>0, MULTIPLY BKY TEN
                 DEC              MS_Z_TENEXP            ; UNTIL EXP=0
                 BNE              AS_L_FIN_8_14
AS_L_FIN_8_15:   LDA              MS_Z_DEGREE            ; IS WHOLE NUMBER NEGATIVE?
                 BMI              AS_L_FIN_8_16          ; YES
                 RTS                                     ; NO, RETURN, WHOLE JOB DONE!
AS_L_FIN_8_16:   JMP              MS_NEGOP               ; NEGATIVE NUMBER, SO NEGATE FAC
                                                         ; --------------------------------
                                                         ; ACCUMULATE A DIGIT INTO FAC
                                                         ; --------------------------------
AS_FIN_9:         PHA                    ; SAVE DIGIT
                 BIT              MS_Z_DPTFLG            ; SEEN A DECIMAL POINT YET?
                 BPL              AS_L_FIN_9_1           ; NO, STILL IN INTEGER PART
                 INC              AS_TMPEXP              ; YES, COUNT THE FRACTIONAL DIGIT
AS_L_FIN_9_1:    JSR              AS_MUL10               ; FAC = FAC * 10
                 PLA                                     ; CURRENT DIGIT
                 SEC                                     ; <<<SHORTER HERE TO JUST "AND #$0F">>>
                 SBC              #"0" & %01111111       ; <<<TO CONVERT ASCII TO BINARY FORM>>>
                 JSR              AS_ADDACC              ; ADD THE DIGIT
                 JMP              AS_FIN_1               ; GO BACK FOR MORE
                                                         ; --------------------------------
                                                         ; ADD (A) TO FAC
                                                         ; --------------------------------
AS_ADDACC:        PHA                    ; SAVE ADDEND
                 JSR              AS_COPY_FAC_TO_ARG_ROUNDED
                 PLA                                     ; GET ADDEND AGAIN
                 JSR              AS_FLOAT               ; CONVERT TO FP VALUE IN FAC
                 LDA              MS_Z_ARGSGN
                 EOR              MS_Z_FACSGN
                 STA              MS_Z_ARISGN
                 LDX              MS_Z_FAC               ; TO SIGNAL IF FAC=0
                 JMP              MS_FADDT               ; PERFORM THE ADDITION
                                                         ; --------------------------------
                                                         ; ACCUMULATE DIGIT OF EXPONENT
                                                         ; --------------------------------
AS_GETEXP:       LDA              MS_Z_TENEXP            ; CHECK CURRENT VALUE
                 CMP              #10                    ; FOR MORE THAN 2 DIGITS
                 BCC              AS_L_GETEXP_1          ; NO, THIS IS 1ST OR 2ND DIGIT
                 LDA              #100                   ; EXPONENT TOO BIG
                 BIT              MS_Z_EXPSGN            ; UNLESS IT IS NEGATIVE
                 BMI              AS_L_GETEXP_2          ; LARGE NEGATIVE EXPONENT MAKES FAC=0
                 JMP              AS_OVERFLOW            ; LARGE POSITIVE EXPONENT IS ERROR
AS_L_GETEXP_1:    ASL                    ; EXPONENT TIMES 10
                 ASL
                 CLC
                 ADC              MS_Z_TENEXP
                 ASL
                 CLC                                     ; <<< ASL ALREADY DID THIS! >>>
                 LDY              #0                     ; ADD THE NEW DIGIT
                 ADC              (MS_Z_TXTPTR),Y        ; BUT THIS IS IN ASCII,
                 SEC                                     ; SO ADJUST BACK TO BINARY
                 SBC              #"0" & %01111111
AS_L_GETEXP_2:   STA              MS_Z_TENEXP            ; NEW VALUE
                 JMP              AS_FIN_4               ; BACK FOR MORE
                                                         ; --------------------------------
                                                         ; --------------------------------

AS_CON_99999999P9      .BYTE $9B,$3E,$BC,$1F,$FD       ; 99,999,999.9
AS_CON_999999999       .BYTE $9E,$6E,$6B,$27,$FD       ; 999,999,999
AS_CON_BILLION         .BYTE $9E,$6E,$6B,$28,$00       ; 1,000,000,000
                                                         ; --------------------------------
                                                         ; PRINT "IN <LINE #>"
                                                         ; --------------------------------
MS_INPRT:        LDA              #<MS_INTXT             ; PRINT " IN "
                 LDY              #>MS_INTXT
                 JSR              AS_GO_STROUT
                 LDA              MS_Z_CURLIN + 1
                 LDX              MS_Z_CURLIN
                                                         ; --------------------------------
                                                         ; PRINT A,X AS DECIMAL INTEGER
                                                         ; --------------------------------
MS_LINPRT:       STA              MS_Z_FAC + 1           ; PRINT A,X IN DECIMAL
                 STX              MS_Z_FAC + 2
                 LDX              #$90                   ; EXPONENT = 2^16
                 SEC                                     ; CONVERT UNSIGNED
                 JSR              AS_FLOAT_2             ; CONVERT LINE # TO FP
                                                         ; --------------------------------
                                                         ; CONVERT (FAC) TO STRING, AND PRINT IT
                                                         ; --------------------------------
AS_PRINT_FAC:
                 JSR              AS_FOUT                ; CONVERT (FAC) TO STRING AT STACK
                                                         ; --------------------------------
                                                         ; PRINT STRING STARTING AT Y,A
                                                         ; --------------------------------
AS_GO_STROUT:
                 JMP              AS_STROUT              ; PRINT STRING AT A,Y
                                                         ; --------------------------------
                                                         ; CONVERT (FAC) TO STRING STARTING AT STACK
                                                         ; RETURN WITH (Y,A) POINTING AT STRING
                                                         ; --------------------------------
AS_FOUT:         LDY              #1                     ; NORMAL ENTRY PUTS STRING AT STACK...
                                                         ; --------------------------------
                                                         ; "STR$" FUNCTION ENTERS HERE, WITH (Y)=0
                                                         ; SO THAT RESULT STRING STARTS AT STACK-1
                                                         ; (THIS IS USED AS A FLAG)
                                                         ; --------------------------------
AS_FOUT_1:       LDA              #"-" & %01111111       ; IN CASE VALUE NEGATIVE
                 DEY                                     ; BACK UP PNTR
                 BIT              MS_Z_FACSGN
                 BPL              AS_L_FOUT_1_1          ; VALUE IS +
                 INY                                     ; VALUE IS -
                 STA              AS_STACK - 1,Y         ; EMIT "-"
AS_L_FOUT_1_1:   STA              MS_Z_FACSGN            ; MAKE FAC.SIGN POSITIVE ($2D)
                 STY              MS_Z_STRNG2            ; SAVE STRING PNTR
                 INY
                 LDA              #"0" & %01111111       ; IN CASE (FAC)=0
                 LDX              MS_Z_FAC               ; NUMBER=0?
                 BNE              AS_L_FOUT_1_2          ; NO, (FAC) NOT ZERO
                 JMP              AS_FOUT_4              ; YES, FINISHED
                                                         ; --------------------------------
AS_L_FOUT_1_2:   LDA              #0                     ; STARTING VALUE FOR TMPEXP
                 CPX              #$80                   ; ANY INTEGER PART?
                 BEQ              AS_L_FOUT_1_3          ; NO, BTWN L_FOUT_1_5 AND L_FOUT_1_999999999
                 BCS              AS_L_FOUT_1_4          ; YES
                                                         ; --------------------------------
AS_L_FOUT_1_3:   LDA              #<AS_CON_BILLION       ; MULTIPLY BY 1E9
                 LDY              #>AS_CON_BILLION       ; TO GIVE ADJUSTMENT A HEAD START
                 JSR              AS_FMULT
                 LDA              #$100 - 9              ; EXPONENT ADJUSTMENT
AS_L_FOUT_1_4:   STA              AS_TMPEXP              ; 0 OR -9
                                                         ; --------------------------------
                                                         ; ADJUST UNTIL 1E8 <= (FAC) <1E9
                                                         ; --------------------------------
AS_L_FOUT_1_5:   LDA              #<AS_CON_999999999
                 LDY              #>AS_CON_999999999
                 JSR              AS_FCOMP               ; COMPARE TO 1E9-1
                 BEQ              AS_L_FOUT_1_10         ; (FAC) = 1E9-1
                 BPL              AS_L_FOUT_1_8          ; TOO LARGE, DIVIDE BY TEN
AS_L_FOUT_1_6:   LDA              #<AS_CON_99999999P9    ; COMPARE TO 1E8-L_FOUT_1_1
                 LDY              #>AS_CON_99999999P9
                 JSR              AS_FCOMP               ; COMPARE TO 1E8-L_FOUT_1_1
                 BEQ              AS_L_FOUT_1_7          ; (FAC) = 1E8-L_FOUT_1_1
                 BPL              AS_L_FOUT_1_9          ; IN RANGE, ADJUSTMENT FINISHED
AS_L_FOUT_1_7:   JSR              AS_MUL10               ; TOO SMALL, MULTIPLY BY TEN
                 DEC              AS_TMPEXP              ; KEEP TRACK OF MULTIPLIES
                 BNE              AS_L_FOUT_1_6          ; ...ALWAYS
AS_L_FOUT_1_8:   JSR              AS_DIV10               ; TOO LARGE, DIVIDE BY TEN
                 INC              AS_TMPEXP              ; KEEP TRACK OF DIVISIONS
                 BNE              AS_L_FOUT_1_5          ; ...ALWAYS
                                                         ; --------------------------------
AS_L_FOUT_1_9:   JSR              AS_FADDH               ; ROUND ADJUSTED RESULT
AS_L_FOUT_1_10:  JSR              AS_QINT                ; CONVERT ADJUSTED VALUE TO 32-BIT INTEGER
                                                         ; --------------------------------
                                                         ; FAC+1...FAC+4 IS NOW IN INTEGER FORM
                                                         ; WITH POWER OF TEN ADJUSTMENT IN TMPEXP

                                                         ; IF -10 < TMPEXP > 1, PRINT IN DECIMAL FORM
                                                         ; OTHERWISE, PRINT IN EXPONENTIAL FORM
                                                         ; --------------------------------
AS_FOUT_2:       LDX              #1                     ; ASSUME 1 DIGIT BEFORE "."
                 LDA              AS_TMPEXP              ; CHECK RANGE
                 CLC
                 ADC              #10
                 BMI              AS_L_FOUT_2_1          ; < .01, USE EXPONENTIAL FORM
                 CMP              #11
                 BCS              AS_L_FOUT_2_2          ; >= 1E10, USE EXPONENTIAL FORM
                 ADC              #$FF                   ; LESS 1 GIVES INDEX FOR "."
                 TAX
                 LDA              #2                     ; SET REMAINING EXPONENT = 0
AS_L_FOUT_2_1:    SEC                    ; COMPUTE REMAINING EXPONENT
AS_L_FOUT_2_2:   SBC              #2
                 STA              MS_Z_TENEXP            ; VALUE FOR "E+XX" OR "E-XX"
                 STX              AS_TMPEXP              ; INDEX FOR DECIMAL POINT
                 TXA                                     ; SEE IF "." COMES FIRST
                 BEQ              AS_L_FOUT_2_3          ; YES
                 BPL              AS_L_FOUT_2_5          ; NO, LATER
AS_L_FOUT_2_3:   LDY              MS_Z_STRNG2            ; GET INDEX INTO STRING BEING BUILT
                 LDA              #"." & %01111111       ; STORE A DECIMAL POINT
                 INY
                 STA              AS_STACK - 1,Y
                 TXA                                     ; SEE IF NEED ".0"
                 BEQ              AS_L_FOUT_2_4          ; NO
                 LDA              #"0" & %01111111       ; YES, STORE "0"
                 INY
                 STA              AS_STACK - 1,Y
AS_L_FOUT_2_4:   STY              MS_Z_STRNG2            ; SAVE OUTPUT INDEX AGAIN
                                                         ; --------------------------------
                                                         ; NOW DIVIDE BY POWERS OF TEN TO GET SUCCESSIVE DIGITS
                                                         ; --------------------------------
AS_L_FOUT_2_5:   LDY              #0                     ; INDEX TO TABLE OF POWERS OF TEN
                 LDX              #$80                   ; STARTING VALUE FOR DIGIT WITH DIRECTION
AS_L_FOUT_2_6:   LDA              MS_Z_FAC + 4           ; START BY ADDING -100000000 UNTIL
                 CLC                                     ; OVERSHOOT.  THEN ADD +10000000,
                 ADC              AS_DECTBL + 3,Y        ; THEN ADD -1000000, THEN ADD
                 STA              MS_Z_FAC + 4           ; +100000, AND SO ON.
                 LDA              MS_Z_FAC + 3           ; THE # OF TIMES EACH POWER IS ADDED
                 ADC              AS_DECTBL + 2,Y        ; IS 1 MORE THAN CORRESPONDING DIGIT
                 STA              MS_Z_FAC + 3
                 LDA              MS_Z_FAC + 2
                 ADC              AS_DECTBL + 1,Y
                 STA              MS_Z_FAC + 2
                 LDA              MS_Z_FAC + 1
                 ADC              AS_DECTBL,Y
                 STA              MS_Z_FAC + 1
                 INX                                     ; COUNT THE ADD
                 BCS              AS_L_FOUT_2_7          ; IF C=1 AND X NEGATIVE, KEEP ADDING
                 BPL              AS_L_FOUT_2_6          ; IF C=0 AND X POSITIVE, KEEP ADDING
                 BMI              AS_L_FOUT_2_8          ; IF C=0 AND X NEGATIVE, WE OVERSHOT
AS_L_FOUT_2_7:   BMI              AS_L_FOUT_2_6          ; IF C=1 AND X POSITIVE, WE OVERSHOT
AS_L_FOUT_2_8:    TXA                    ; OVERSHOT, SO MAKE X INTO A DIGIT
                 BCC              AS_L_FOUT_2_9          ; HOW DEPENDS ON DIRECTION WE WERE GOING
                 EOR              #$FF                   ; DIGIT = 9-X
                 ADC              #10
AS_L_FOUT_2_9:   ADC              #("0" & %01111111) - 1 ; MAKE DIGIT INTO ASCII
                 INY                                     ; ADVANCE TO NEXT SMALLER POWER OF TEN
                 INY
                 INY
                 INY
                 STY              MS_Z_VARPNT            ; SAVE PNTR TO POWERS
                 LDY              MS_Z_STRNG2            ; GET OUTPUT PNTR
                 INY                                     ; STORE THE DIGIT
                 TAX                                     ; SAVE DIGIT, HI-BIT IS DIRECTION
                 AND              #$7F                   ; MAKE SURE MON_COLOR...$39 FOR STRING
                 STA              AS_STACK - 1,Y
                 DEC              AS_TMPEXP              ; COUNT THE DIGIT
                 BNE              AS_L_FOUT_2_10         ; NOT TIME FOR "." YET
                 LDA              #"." & %01111111       ; TIME, SO STORE THE DECIMAL POINT
                 INY
                 STA              AS_STACK - 1,Y
AS_L_FOUT_2_10:  STY              MS_Z_STRNG2            ; SAVE OUTPUT PNTR AGAIN
                 LDY              MS_Z_VARPNT            ; GET PNTR TO POWERS
                 TXA                                     ; GET DIGIT WITH HI-BIT = DIRECTION
                 EOR              #$FF                   ; CHANGE DIRECTION
                 AND              #$80                   ; $00 IF ADDING, $80 IF SUBTRACTING
                 TAX
                 CPY              #AS_DECTBL_END - AS_DECTBL
                 BNE              AS_L_FOUT_2_6          ; NOT FINISHED YET
                                                         ; --------------------------------
                                                         ; NINE DIGITS HAVE BEEN STORED IN STRING.  NOW LOOK
                                                         ; BACK AND LOP OFF TRAILING ZEROES AND A TRAILING
                                                         ; DECIMAL POINT.
                                                         ; --------------------------------
AS_FOUT_3:       LDY              MS_Z_STRNG2            ; POINTS AT LAST STORED CHAR
AS_L_FOUT_3_1:   LDA              AS_STACK - 1,Y         ; SEE IF LOPPABLE
                 DEY
                 CMP              #"0" & %01111111       ; SUPPRESS TRAILING ZEROES
                 BEQ              AS_L_FOUT_3_1          ; YES, KEEP LOOPING
                 CMP              #"." & %01111111       ; SUPPRESS TRAILING DECIMAL POINT
                 BEQ              AS_L_FOUT_3_2          ; ".", SO WRITE OVER IT
                 INY                                     ; NOT ".", SO INCLUDE IN STRING AGAIN
AS_L_FOUT_3_2:   LDA              #"+" & %01111111       ; PREPARE FOR POSITIVE EXPONENT "E+XX"
                 LDX              MS_Z_TENEXP            ; SEE IF ANY E-VALUE
                 BEQ              AS_FOUT_5              ; NO, JUST MARK END OF STRING
                 BPL              AS_L_FOUT_3_3          ; YES, AND IT IS POSITIVE
                 LDA              #0                     ; YES, AND IT IS NEGATIVE
                 SEC                                     ; COMPLEMENT THE VALUE
                 SBC              MS_Z_TENEXP
                 TAX                                     ; GET MAGNITUDE IN X
                 LDA              #"-" & %01111111       ; E SIGN
AS_L_FOUT_3_3:   STA              AS_STACK + 1,Y         ; STORE SIGN IN STRING
                 LDA              #"E" & %01111111       ; STORE "E" IN STRING BEFORE SIGN
                 STA              AS_STACK,Y
                 TXA                                     ; EXPONENT MAGNITUDE IN A-REG
                 LDX              #("0" & %01111111) - 1 ; SEED FOR EXPONENT DIGIT
                 SEC                                     ; CONVERT TO DECIMAL
AS_L_FOUT_3_4:    INX                    ; COUNT THE SUBTRACTION
                 SBC              #10                    ; TEN'S DIGIT
                 BCS              AS_L_FOUT_3_4          ; MORE TENS TO SUBTRACT
                 ADC              #("0" & %01111111) + 10 ; CONVERT REMAINDER TO ONE'S DIGIT
                 STA              AS_STACK + 3,Y         ; STORE ONE'S DIGIT
                 TXA
                 STA              AS_STACK + 2,Y         ; STORE TEN'S DIGIT
                 LDA              #0                     ; MARK END OF STRING WITH $00
                 STA              AS_STACK + 4,Y
                 BEQ              AS_FOUT_6              ; ...ALWAYS
AS_FOUT_4:       STA              AS_STACK - 1,Y         ; STORE "0" IN ASCII
AS_FOUT_5:       LDA              #0                     ; STORE $00 ON END OF STRING
                 STA              AS_STACK,Y
AS_FOUT_6:       LDA              #<AS_STACK             ; POINT Y,A AT BEGINNING OF STRING
                 LDY              #>AS_STACK             ; (STR$ STARTED STRING AT STACK-1, BUT
                 RTS                                     ; STR$ DOESN'T USE Y,A ANYWAY.)
                                                         ; --------------------------------

AS_CON_HALF            .BYTE $80,$00,$00,$00,$00       ; FP CONSTANT 0L_CON_HALF_5
                                                         ; --------------------------------
                                                         ; POWERS OF 10 FROM 1E8 DOWN TO 1,
                                                         ; AS 32-BIT INTEGERS, WITH ALTERNATING SIGNS
                                                         ; --------------------------------

AS_DECTBL              .BYTE $FA,$0A,$1F,$00           ; -100000000
                    .BYTE $00,$98,$96,$80           ; 10000000
                    .BYTE $FF,$F0,$BD,$C0           ; -1000000
                    .BYTE $00,$01,$86,$A0           ; 100000
                    .BYTE $FF,$FF,$D8,$F0           ; -10000
                    .BYTE $00,$00,$03,$E8           ; 1000
                    .BYTE $FF,$FF,$FF,$9C           ; -100
                    .BYTE $00,$00,$00,$0A           ; 10
                    .BYTE $FF,$FF,$FF,$FF           ; -1
AS_DECTBL_END:
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; "SQR" FUNCTION

                                                         ; <<< UNFORTUNATELY, RATHER THAN A NEWTON-RAPHSON >>>
                                                         ; <<< ITERATION, APPLESOFT USES EXPONENTIATION    >>>
                                                         ; <<< SQR(X) = X^L_DECTBL_END_5                               >>>
                                                         ; --------------------------------
MS_SQR:          JSR              AS_COPY_FAC_TO_ARG_ROUNDED
                 LDA              #<AS_CON_HALF          ; SET UP POWER OF 0L_SQR_5
                 LDY              #>AS_CON_HALF
                 JSR              AS_LOAD_FAC_FROM_YA
                                                         ; --------------------------------
                                                         ; EXPONENTIATION OPERATION

                                                         ; ARG ^ FAC  =  EXP( LOG(ARG) * FAC )
                                                         ; --------------------------------
MS_FPWRT:        BEQ              MS_EXP                 ; IF FAC=0, ARG^FAC=EXP(0)
                 LDA              MS_Z_ARGEXP            ; IF ARG=0, ARG^FAC=0
                 BNE              AS_L_FPWRT_1           ; NEITHER IS ZERO
                 JMP              AS_STA_IN_FAC_SIGN_AND_EXP ; SET FAC = 0
AS_L_FPWRT_1:    LDX              #MS_Z_GRBPNT           ; SAVE FAC IN TEMP3
                 LDY              #0
                 JSR              AS_STORE_FACDB_YX_ROUNDED
                 LDA              MS_Z_ARGSGN            ; NORMALLY, ARG MUST BE POSITIVE
                 BPL              AS_L_FPWRT_2           ; IT IS POSITIVE, SO ALL IS WELL
                 JSR              MS_INT                 ; NEGATIVE, BUT OK IF INTEGRAL POWER
                 LDA              #MS_Z_GRBPNT           ; SEE IF INT(FAC)=FAC
                 LDY              #0
                 JSR              AS_FCOMP               ; IS IT AN INTEGER POWER?
                 BNE              AS_L_FPWRT_2           ; NOT INTEGRAL,  WILL CAUSE ERROR LATER
                 TYA                                     ; MAKE ARG SIGN + AS IT IS MOVED TO FAC
                 LDY              MS_Z_CHARAC            ; INTEGRAL, SO ALLOW NEGATIVE ARG
AS_L_FPWRT_2:    JSR              AS_MFA                 ; MOVE ARGUMENT TO FAC
                 TYA                                     ; SAVE FLAG FOR NEGATIVE ARG (0=+)
                 PHA
                 JSR              MS_LOG                 ; GET LOG(ARG)
                 LDA              #MS_Z_GRBPNT           ; MULTIPLY BY POWER
                 LDY              #0
                 JSR              AS_FMULT
                 JSR              MS_EXP                 ; E ^ LOG(FAC)
                 PLA                                     ; GET FLAG FOR NEGATIVE ARG
                 LSR                                     ; <<<LSR,BCC COULD BE MERELY BPL>>>
                 BCC              AS_RTS_18              ; NOT NEGATIVE, FINISHED
                                                         ; NEGATIVE ARG, SO NEGATE RESULT
                                                         ; --------------------------------
                                                         ; NEGATE VALUE IN FAC
                                                         ; --------------------------------
MS_NEGOP:        LDA              MS_Z_FAC               ; IF FAC=0, NO NEED TO COMPLEMENT
                 BEQ              AS_RTS_18              ; YES, FAC=0
                 LDA              MS_Z_FACSGN            ; NO, SO TOGGLE SIGN
                 EOR              #$FF
                 STA              MS_Z_FACSGN
AS_RTS_18:        RTS
                                                         ; --------------------------------

AS_CON_LOG_E           .BYTE $81,$38,$AA,$3B,$29       ; LOG(E) TO BASE 2
                                                         ; --------------------------------
AS_POLY_EXP            .BYTE 7                         ; ( # OF TERMS IN POLYNOMIAL) - 1
                    .BYTE $71,$34,$58,$3E,$56       ; (LOG(2)^7)/8!
                    .BYTE $74,$16,$7E,$B3,$1B       ; (LOG(2)^6)/7!
                    .BYTE $77,$2F,$EE,$E3,$85       ; (LOG(2)^5)/6!
                    .BYTE $7A,$1D,$84,$1C,$2A       ; (LOG(2)^4)/5!
                    .BYTE $7C,$63,$59,$58,$0A       ; (LOG(2)^3)/4!
                    .BYTE $7E,$75,$FD,$E7,$C6       ; (LOG(2)^2)/3!
                    .BYTE $80,$31,$72,$18,$10       ; LOG(2)/2!
                    .BYTE $81,$00,$00,$00,$00       ; 1
                                                         ; --------------------------------
                                                         ; "EXP" FUNCTION

                                                         ; FAC = E ^ FAC
                                                         ; --------------------------------
MS_EXP:          LDA              #<AS_CON_LOG_E         ; CONVERT TO POWER OF TWO PROBLEM
                 LDY              #>AS_CON_LOG_E         ; E^X = 2^(LOG2(E)*X)
                 JSR              AS_FMULT
                 LDA              MS_Z_FACOV             ; NON-STANDARD ROUNDING HERE
                 ADC              #$50                   ; ROUND UP IF EXTENSION > $AF
                 BCC              AS_L_EXP_1             ; NO, DON'T ROUND UP
                 JSR              AS_INCREMENT_MANTISSA
AS_L_EXP_1:      STA              MS_Z_OLDOV             ; STRANGE VALUE
                 JSR              AS_MAF                 ; COPY FAC INTO ARG
                 LDA              MS_Z_FAC               ; MAXIMUM EXPONENT IS < 128
                 CMP              #$88                   ; WITHIN RANGE?
                 BCC              AS_L_EXP_3             ; YES
AS_L_EXP_2:      JSR              AS_OUTOFRNG            ; OVERFLOW IF +, RETURN 0.0 IF -
AS_L_EXP_3:      JSR              MS_INT                 ; GET INT(FAC)
                 LDA              MS_Z_CHARAC            ; THIS IS THE INETGRAL PART OF THE POWER
                 CLC                                     ; ADD TO EXPONENT BIAS + 1
                 ADC              #$81
                 BEQ              AS_L_EXP_2             ; OVERFLOW
                 SEC                                     ; BACK OFF TO NORMAL BIAS
                 SBC              #1
                 PHA                                     ; SAVE EXPONENT
                                                         ; --------------------------------
                 LDX              #5                     ; SWAP ARG AND FAC
AS_L_EXP_4:      LDA              MS_Z_ARGEXP,X          ; <<< WHY SWAP? IT IS DOING      >>>
                 LDY              MS_Z_FAC,X             ; <<< -(A-B) WHEN (B-A) IS THE   >>>
                 STA              MS_Z_FAC,X             ; <<< SAME THING!                >>>
                 STY              MS_Z_ARGEXP,X
                 DEX
                 BPL              AS_L_EXP_4
                 LDA              MS_Z_OLDOV
                 STA              MS_Z_FACOV
                 JSR              MS_FSUBT               ; POWER-INT(POWER) --> FRACTIONAL PART
                 JSR              MS_NEGOP
                 LDA              #<AS_POLY_EXP
                 LDY              #>AS_POLY_EXP
                 JSR              AS_POLYNOMIAL          ; COMPUTE F(X) ON FRACTIONAL PART
                 LDA              #0
                 STA              MS_Z_ARISGN
                 PLA                                     ; GET EXPONENT
                 JSR              AS_ADD_EXPONENTS_1
                 RTS                                     ; <<< WASTED BYTE HERE, COULD HAVE >>>
                                                         ; <<< JUST USED "JMP ADD.EXPO..."  >>>
                                                         ; --------------------------------
                                                         ; ODD POLYNOMIAL SUBROUTINE

                                                         ; F(X) = X * P(X^2)

                                                         ; WHERE:  X IS VALUE IN FAC
                                                         ; Y,A POINTS AT COEFFICIENT TABLE
                                                         ; FIRST BYTE OF COEFF. TABLE IS N
                                                         ; COEFFICIENTS FOLLOW, HIGHEST POWER FIRST

                                                         ; P(X^2) COMPUTED USING NORMAL POLYNOMIAL SUBROUTINE

                                                         ; --------------------------------
AS_POLYNOMIAL_ODD:
                 STA              MS_Z_POLYPT            ; SAVE ADDRESS OF COEFFICIENT TABLE
                 STY              MS_Z_POLYPT + 1
                 JSR              AS_STORE_FAC_IN_TEMP1_ROUNDED
                 LDA              #MS_Z_TEMPF1           ; Y=0 ALREADY, SO Y,A POINTS AT TEMP1
                 JSR              AS_FMULT               ; FORM X^2
                 JSR              AS_SERMAIN             ; DO SERIES IN X^2
                 LDA              #<MS_Z_TEMPF1          ; GET X AGAIN
                 LDY              #>MS_Z_TEMPF1
                 JMP              AS_FMULT               ; MULTIPLY X BY P(X^2) AND EXIT
                                                         ; --------------------------------
                                                         ; NORMAL POLYNOMIAL SUBROUTINE

                                                         ; P(X) = C(0)*X^N + C(1)*X^(N-1) + ... + C(N)

                                                         ; WHERE:  X IS VALUE IN FAC
                                                         ; Y,A POINTS AT COEFFICIENT TABLE
                                                         ; FIRST BYTE OF COEFF. TABLE IS N
                                                         ; COEFFICIENTS FOLLOW, HIGHEST POWER FIRST

                                                         ; --------------------------------
AS_POLYNOMIAL:
                 STA              MS_Z_POLYPT            ; POINTER TO COEFFICIENT TABLE
                 STY              MS_Z_POLYPT + 1
                                                         ; --------------------------------
AS_SERMAIN:
                 JSR              AS_STORE_FAC_IN_TEMP2_ROUNDED
                 LDA              (MS_Z_POLYPT),Y        ; GET N
                 STA              MS_Z_DEGREE            ; SAVE N
                 LDY              MS_Z_POLYPT            ; BUMP PNTR TO HIGHEST COEFFICIENT
                 INY                                     ; AND GET PNTR INTO Y,A
                 TYA
                 BNE              AS_L_SERMAIN_1
                 INC              MS_Z_POLYPT + 1
AS_L_SERMAIN_1:  STA              MS_Z_POLYPT
                 LDY              MS_Z_POLYPT + 1
AS_L_SERMAIN_2:  JSR              AS_FMULT               ; ACCUMULATE SERIES TERMS
                 LDA              MS_Z_POLYPT            ; BUMP PNTR TO NEXT COEFFICIENT
                 LDY              MS_Z_POLYPT + 1
                 CLC
                 ADC              #5
                 BCC              AS_L_SERMAIN_3
                 INY
AS_L_SERMAIN_3:  STA              MS_Z_POLYPT
                 STY              MS_Z_POLYPT + 1
                 JSR              AS_FADD                ; ADD NEXT COEFFICIENT
                 LDA              #MS_Z_TEMPF2           ; POINT AT X AGAIN
                 LDY              #0
                 DEC              MS_Z_DEGREE            ; IF SERIES NOT FINISHED,
                 BNE              AS_L_SERMAIN_2         ; THEN ADD ANOTHER TERM
AS_RTS_19:        RTS                    ; FINISHED
                                                         ; --------------------------------

AS_CON_RND_1           .BYTE $98,$35,$44,$7A           ; <<< THESE ARE MISSING ONE BYTE >>>
AS_CON_RND_2           .BYTE $68,$28,$B1,$46           ; <<< FOR FP VALUES              >>>
                                                         ; --------------------------------
                                                         ; "RND" FUNCTION
                                                         ; --------------------------------
MS_RND:          JSR              AS_SIGN                ; REDUCE ARGUMENT TO -1, 0, OR +1
                 TAX                                     ; SAVE ARGUMENT
                 BMI              AS_L_RND_1             ; = -1, USE CURRENT ARGUMENT FOR SEED
                 LDA              #<MS_Z_RNDX            ; USE CURRENT SEED
                 LDY              #>MS_Z_RNDX
                 JSR              AS_LOAD_FAC_FROM_YA
                 TXA                                     ; RECALL SIGN OF ARGUMENT
                 BEQ              AS_RTS_19              ; =0, RETURN SEED UNCHANGED
                 LDA              #<AS_CON_RND_1         ; VERY POOR RND ALGORITHM
                 LDY              #>AS_CON_RND_1
                 JSR              AS_FMULT
                 LDA              #<AS_CON_RND_2         ; ALSO, CONSTANTS ARE TRUNCATED
                 LDY              #>AS_CON_RND_2         ; <<<THIS DOES NOTHING, DUE TO >>>
                                                         ; <<<SMALL EXPONENT            >>>
                 JSR              AS_FADD
AS_L_RND_1:      LDX              MS_Z_FAC + 4           ; SHUFFLE HI AND LO BYTES
                 LDA              MS_Z_FAC + 1           ; TO SUPPOSEDLY MAKE IT MORE RANDOM
                 STA              MS_Z_FAC + 4
                 STX              MS_Z_FAC + 1
                 LDA              #0                     ; MAKE IT POSITIVE
                 STA              MS_Z_FACSGN
                 LDA              MS_Z_FAC               ; A SOMEWHAT RANDOM EXTENSION
                 STA              MS_Z_FACOV
                 LDA              #$80                   ; EXPONENT TO MAKE VALUE < 1.0
                 STA              MS_Z_FAC
                 JSR              AS_NORMALIZE_FAC_2
                 LDX              #<MS_Z_RNDX            ; MOVE FAC TO RND SEED
                 LDY              #>MS_Z_RNDX
AS_GO_MOVMF:     JMP              AS_STORE_FACDB_YX_ROUNDED
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; "COS" FUNCTION
                                                         ; --------------------------------
MS_COS:          LDA              #<AS_CON_PI_HALF       ; COS(X)=SIN(X + PI/2)
                 LDY              #>AS_CON_PI_HALF
                 JSR              AS_FADD
                                                         ; --------------------------------
                                                         ; "SIN" FUNCTION
                                                         ; --------------------------------
MS_SIN:          JSR              AS_COPY_FAC_TO_ARG_ROUNDED
                 LDA              #<AS_CON_PI_DOUB       ; REMOVE MULTIPLES OF 2*PI
                 LDY              #>AS_CON_PI_DOUB       ; BY DIVIDING AND SAVING
                 LDX              MS_Z_ARGSGN            ; THE FRACTIONAL PART
                 JSR              AS_DIV                 ; USE SIGN OF ARGUMENT
                 JSR              AS_COPY_FAC_TO_ARG_ROUNDED
                 JSR              MS_INT                 ; TAKE INTEGER PART
                 LDA              #0                     ; <<< WASTED LINES, BECAUSE FSUBT >>>
                 STA              MS_Z_ARISGN            ; <<< CHANGES SGNCPR AGAIN        >>>
                 JSR              MS_FSUBT               ; SUBTRACT TO GET FRACTIONAL PART
                                                         ; --------------------------------
                                                         ; (FAC) = ANGLE AS A FRACTION OF A FULL CIRCLE

                                                         ; NOW FOLD THE RANGE INTO A QUARTER CIRCLE

                                                         ; <<< THERE ARE MUCH SIMPLER WAYS TO DO THIS >>>
                                                         ; --------------------------------
                 LDA              #<AS_QUARTER           ; 1/4 - FRACTION MAKES
                 LDY              #>AS_QUARTER           ; -3/4 <= FRACTION < 1/4
                 JSR              AS_FSUB
                 LDA              MS_Z_FACSGN            ; TEST SIGN OF RESULT
                 PHA                                     ; SAVE SIGN FOR LATER UNFOLDING
                 BPL              AS_SIN_1               ; ALREADY 0...1/4
                 JSR              AS_FADDH               ; ADD 1/2 TO SHIFT TO -1/4...1/2
                 LDA              MS_Z_FACSGN            ; TEST SIGN
                 BMI              AS_SIN_2               ; -1/4...0
                                                         ; 0...1/2
                 LDA              MS_Z_TANSGN            ; SIGNFLG INITIALIZED = 0 IN "TAN"
                 EOR              #$FF                   ; FUNCTION
                 STA              MS_Z_TANSGN            ; "TAN" IS ONLY USER OF SIGNFLG TOO
                                                         ; --------------------------------
                                                         ; IF FALL THRU, RANGE IS 0...1/2
                                                         ; IF BRANCH HERE, RANGE IS 0...1/4
                                                         ; --------------------------------
AS_SIN_1:        JSR              MS_NEGOP
                                                         ; --------------------------------
                                                         ; IF FALL THRU, RANGE IS -1/2...0
                                                         ; IF BRANCH HERE, RANGE IS -1/4...0
                                                         ; --------------------------------
AS_SIN_2:        LDA              #<AS_QUARTER           ; ADD 1/4 TO SHIFT RANGE
                 LDY              #>AS_QUARTER           ; TO -1/4...1/4
                 JSR              AS_FADD
                 PLA                                     ; GET SAVED SIGN FROM ABOVE
                 BPL              AS_L_SIN_2_1
                 JSR              MS_NEGOP               ; MAKE RANGE 0...1/4
AS_L_SIN_2_1:    LDA              #<AS_POLY_SIN          ; DO STANDARD SIN SERIES
                 LDY              #>AS_POLY_SIN
                 JMP              AS_POLYNOMIAL_ODD
                                                         ; --------------------------------
                                                         ; "TAN" FUNCTION

                                                         ; COMPUTE TAN(X) = SIN(X) / COS(X)
                                                         ; --------------------------------
MS_TAN:          JSR              AS_STORE_FAC_IN_TEMP1_ROUNDED
                 LDA              #0                     ; SIGNFLG WILL BE TOGGLED IF 2ND OR 3RD
                 STA              MS_Z_TANSGN            ; QUADRANT
                 JSR              MS_SIN                 ; GET SIN(X)
                 LDX              #<MS_Z_GRBPNT          ; SAVE SIN(X) IN TEMP3
                 LDY              #>MS_Z_GRBPNT
                 JSR              AS_GO_MOVMF            ; <<<FUNNY WAY TO CALL MOVMF! >>>
                 LDA              #<MS_Z_TEMPF1          ; RETRIEVE X
                 LDY              #>MS_Z_TEMPF1
                 JSR              AS_LOAD_FAC_FROM_YA
                 LDA              #0                     ; AND COMPUTE COS(X)
                 STA              MS_Z_FACSGN
                 LDA              MS_Z_TANSGN
                 JSR              AS_TAN_1               ; WEIRD & DANGEROUS WAY TO GET INTO SIN
                 LDA              #<MS_Z_GRBPNT          ; NOW FORM SIN/COS
                 LDY              #>MS_Z_GRBPNT
                 JMP              AS_FDIV
                                                         ; --------------------------------
AS_TAN_1:         PHA                    ; SHAME, SHAME!
                 JMP              AS_SIN_1
                                                         ; --------------------------------

AS_CON_PI_HALF         .BYTE $81,$49,$0F,$DA,$A2
AS_CON_PI_DOUB         .BYTE $83,$49,$0F,$DA,$A2
AS_QUARTER             .BYTE $7F,$00,$00,$00,$00
                                                         ; --------------------------------
AS_POLY_SIN            .BYTE 5                         ; POWER OF POLYNOMIAL
                    .BYTE $84,$E6,$1A,$2D,$1B       ; (2PI)^11/11!
                    .BYTE $86,$28,$07,$FB,$F8       ; (2PI)^9/9!
                    .BYTE $87,$99,$68,$89,$01       ; (2PI)^7/7!
                    .BYTE $87,$23,$35,$DF,$E1       ; (2PI)^5/5!
                    .BYTE $86,$A5,$5D,$E7,$28       ; (2PI)^3/3!
                    .BYTE $83,$49,$0F,$DA,$A2       ; 2PI

                                                         ; --------------------------------
                                                         ; <<< NEXT TEN BYTES ARE NEVER REFERENCED >>>
                                                         ; OBFUSCATED "MICROSOFT!" BY BILL GATES
                                                         ; (REVERSED, HIGH BIT SET, XOR 7)
                                                         ; --------------------------------

                    .BYTE ("!"|%10000000)^7
.BYTE ("T"|%10000000)^7
.BYTE ("F"|%10000000)^7
.BYTE ("O"|%10000000)^7
.BYTE ("S"|%10000000)^7
.BYTE ("O"|%10000000)^7
.BYTE ("R"|%10000000)^7
.BYTE ("C"|%10000000)^7
.BYTE ("I"|%10000000)^7
.BYTE ("M"|%10000000)^7

                                                         ; --------------------------------
                                                         ; "ATN" FUNCTION
                                                         ; --------------------------------
MS_ATN:          LDA              MS_Z_FACSGN            ; FOLD THE ARGUMENT RANGE FIRST
                 PHA                                     ; SAVE SIGN FOR LATER UNFOLDING
                 BPL              AS_L_ATN_1             ; .GE. 0
                 JSR              MS_NEGOP               ; .LT. 0, SO COMPLEMENT
AS_L_ATN_1:      LDA              MS_Z_FAC               ; IF .GE. 1, FORM RECIPROCAL
                 PHA                                     ; SAVE FOR LATER UNFOLDING
                 CMP              #$81                   ; (EXPONENT FOR .GE. 1
                 BCC              AS_L_ATN_2             ; X < 1
                 LDA              #<MS_FONE              ; FORM 1/X
                 LDY              #>MS_FONE
                 JSR              AS_FDIV
                                                         ; --------------------------------
                                                         ; 0 <= X <= 1
                                                         ; 0 <= ATN(X) <= PI/8
                                                         ; --------------------------------
AS_L_ATN_2:      LDA              #<AS_POLY_ATN          ; COMPUTE POLYNOMIAL APPROXIMATION
                 LDY              #>AS_POLY_ATN
                 JSR              AS_POLYNOMIAL_ODD
                 PLA                                     ; START TO UNFOLD
                 CMP              #$81                   ; WAS IT .GE. 1?
                 BCC              AS_L_ATN_3             ; NO
                 LDA              #<AS_CON_PI_HALF       ; YES, SUBTRACT FROM PI/2
                 LDY              #>AS_CON_PI_HALF
                 JSR              AS_FSUB
AS_L_ATN_3:       PLA                    ; WAS IT NEGATIVE?
                 BPL              AS_RTS_20              ; NO
                 JMP              MS_NEGOP               ; YES, COMPLEMENT
AS_RTS_20:        RTS
                                                         ; --------------------------------
AS_POLY_ATN            .BYTE 11                        ; POWER OF POLYNOMIAL
                    .BYTE $76,$B3,$83,$BD,$D3
                    .BYTE $79,$1E,$F4,$A6,$F5
                    .BYTE $7B,$83,$FC,$B0,$10
                    .BYTE $7C,$0C,$1F,$67,$CA
                    .BYTE $7C,$DE,$53,$CB,$C1
                    .BYTE $7D,$14,$64,$70,$4C
                    .BYTE $7D,$B7,$EA,$51,$7A
                    .BYTE $7D,$63,$30,$88,$7E
                    .BYTE $7E,$92,$44,$99,$3A
                    .BYTE $7E,$4C,$CC,$91,$C7
                    .BYTE $7F,$AA,$AA,$AA,$13
                    .BYTE $81,$00,$00,$00,$00
                                                         ; --------------------------------
                                                         ; GENERIC COPY OF CHRGET SUBROUTINE, WHICH
                                                         ; IS COPIED INTO $00B1...$00C8 DURING INITIALIZATION

                                                         ; CORNELIS BONGERS DESCRIBED SEVERAL IMPROVEMENTS
                                                         ; TO CHRGET IN MICRO MAGAZINE OR CALL A.P.P.L.E.
                                                         ; (I DON'T REMEMBER WHICH OR EXACTLY WHEN)
                                                         ; --------------------------------
AS_GENERIC_CHRGET:
                 INC              MS_Z_TXTPTR
                 BNE              AS_L_GENERIC_CHRGET_1
                 INC              MS_Z_TXTPTR + 1
AS_L_GENERIC_CHRGET_1: LDA              $EA60                  ; <<< ACTUAL ADDRESS FILLED IN LATER >>>
                 CMP              #":" & %01111111       ; EOS, ALSO TOP OF NUMERIC RANGE
                 BCS              AS_L_GENERIC_CHRGET_2  ; NOT NUMBER, MIGHT BE EOS
                 CMP              #" " & %01111111       ; IGNORE BLANKS
                 BEQ              AS_GENERIC_CHRGET
                 SEC                                     ; TEST FOR NUMERIC RANGE IN WAY THAT
                 SBC              #"0" & %01111111       ; CLEARS CARRY IF CHAR IS DIGIT
                 SEC                                     ; AND LEAVES CHAR IN A-REG
                 SBC              #$D0
AS_L_GENERIC_CHRGET_2: RTS
                                                         ; --------------------------------
                                                         ; INITIAL VALUE FOR RANDOM NUMBER, ALSO COPIED
                                                         ; IN ALONG WITH CHRGET, BUT ERRONEOUSLY:
                                                         ; <<< THE LAST BYTE IS NOT COPIED >>>
                                                         ; --------------------------------

                    .BYTE $80,$4F,$C7,$52,$58       ; APPROX. = L_GENERIC_CHRGET_811635157
AS_GENERIC_END:
                                                         ; --------------------------------
AS_COLD_START:
                 LDX              #$FF                   ; SET DIRECT MODE FLAG
                 STX              MS_Z_CURLIN + 1
                 LDX              #$FB                   ; SET STACK POINTER, LEAVING ROOM FOR
                 TXS                                     ; LINE BUFFER DURING PARSING
                 LDA              #<AS_COLD_START        ; SET RESTART TO COLD.START
                 LDY              #>AS_COLD_START        ; UNTIL COLDSTART IS COMPLETED
                 STA              MS_Z_START + 1
                 STY              MS_Z_START + 2
                 STA              MS_Z_RDYJSR + 1        ; ALSO SECOND USER VECTOR...
                 STY              MS_Z_RDYJSR + 2        ; ..WE SIMPLY MUST FINISH COLD.START!
                 JSR              AS_NORMAL              ; SET NORMAL DISPLAY MODE
                 LDA              #$4C                   ; "JMP" OPCODE FOR 4 VECTORS
                 STA              MS_Z_START             ; WARM START
                 STA              MS_Z_RDYJSR            ; ANYONE EVER USE THIS ONE?
                 STA              MS_Z_JMPER             ; USED BY FUNCTIONS (JSR JMPADRS)
AS_L_USR1:       STA              MS_Z_USRPOK            ; "USR" FUNCTION VECTOR
                 LDA              #<AS_IQERR             ; POINT "USR" TO ILLEGAL QUANTITY
                 LDY              #>AS_IQERR             ; ERROR, UNTIL USER SETS IT UP
                 STA              MS_Z_USRPOK + 1
                 STY              MS_Z_USRPOK + 2
AS_L_USR2:                               ; --------------------------------
                                                         ; MOVE GENERIC CHRGET AND RANDOM SEED INTO PLACE

                                                         ; <<< NOTE THAT LOOP VALUE IS WRONG!          >>>
                                                         ; <<< THE LAST BYTE OF THE RANDOM SEED IS NOT >>>
                                                         ; <<< COPIED INTO PAGE ZERO!                  >>>
                                                         ; --------------------------------
                 LDX              #AS_GENERIC_END - AS_GENERIC_CHRGET - 1
AS_L_COLD_START_1: LDA              AS_GENERIC_CHRGET - 1,X
                 STA              MS_Z_CHRGET - 1,X
                 STX              AS_SPEEDZ              ; ON LAST PASS STORES $01)
                 DEX
                 BNE              AS_L_COLD_START_1
                                                         ; --------------------------------
                 STX              AS_TRCFLG              ; X=0, TURN OFF TRACING
                 TXA                                     ; A=0
                 STA              MS_Z_BITS
                 STA              MS_Z_LASTPT + 1
                 PHA                                     ; PUT $00 ON STACK (WHAT FOR?)
                 LDA              #3                     ; SET LENGTH OF TEMP. STRING DESCRIPTORS
                 STA              MS_Z_FOUR6             ; FOR GARBAGE COLLECTION SUBROUTINE
                 JSR              MS_CRDO                ; PRINT <RETURN>
                 LDA              #1                     ; SET UP FAKE FORWARD LINK
                 STA              MS_A_BUFOFS - 3
                 STA              MS_A_BUFOFS - 4
                 LDX              #MS_Z_TEMPST           ; INIT INDEX TO TEMP STRING DESCRIPTORS
                 STX              MS_Z_TEMPPT
                                                         ; --------------------------------
                                                         ; FIND HIGH END OF RAM
                                                         ; --------------------------------
                 LDA              #<$0800                ; SET UP POINTER TO LOW END OF RAM
                 LDY              #>$0800
                 STA              MS_Z_LINNUM
                 STY              MS_Z_LINNUM + 1
                 LDY              #0
AS_L_COLD_START_2: INC              MS_Z_LINNUM + 1        ; TEST FIRST BYTE OF EACH PAGE
                 LDA              (MS_Z_LINNUM),Y        ; BY COMPLEMENTING IT AND WATCHING
                 EOR              #$FF                   ; IT CHANGE THE SAME WAY
                 STA              (MS_Z_LINNUM),Y
                 CMP              (MS_Z_LINNUM),Y        ; ROM OR EMPTY SOCKETS WON'T TRACK
                 BNE              AS_L_COLD_START_3      ; NOT RAM HERE
                 EOR              #$FF                   ; RESTORE ORIGINAL VALUE
                 STA              (MS_Z_LINNUM),Y
                 CMP              (MS_Z_LINNUM),Y        ; DID IT TRACK AGAIN?
                 BEQ              AS_L_COLD_START_2      ; YES, STILL IN RAM
AS_L_COLD_START_3: LDY              MS_Z_LINNUM            ; NO, END OF RAM
                 LDA              MS_Z_LINNUM + 1
                 AND              #$F0                   ; FORCE A MULTIPLE OF 4096 BYTES
                 STY              MS_Z_MEMSIZ            ; (BAD RAM MAY HAVE YIELDED NON-MULTIPLE)
                 STA              MS_Z_MEMSIZ + 1
                 STY              MS_Z_FRETOP            ; SET HIMEM AND BOTTOM OF STRINGS
                 STA              MS_Z_FRETOP + 1
                 LDX              #<$0800                ; SET PROGRAM POINTER TO $0800
                 LDY              #>$0800
                 STX              MS_Z_TXTTAB
                 STY              MS_Z_TXTTAB + 1
                 LDY              #0                     ; TURN OFF SEMI-SECRET LOCK FLAG
                 STY              AS_LOCK
                 TYA                                     ; A=0 TOO
                 STA              (MS_Z_TXTTAB),Y        ; FIRST BYTE IN PROGRAM SPACE = 0
                 INC              MS_Z_TXTTAB            ; ADVANCE PAST THE $00
                 BNE              AS_L_COLD_START_4
                 INC              MS_Z_TXTTAB + 1
AS_L_COLD_START_4: LDA              MS_Z_TXTTAB
                 LDY              MS_Z_TXTTAB + 1
                 JSR              MS_REASON              ; SET REST OF POINTERS UP
                 JSR              MS_SCRTCH              ; MORE POINTERS
                 LDA              #<AS_STROUT            ; PUT CORRECT ADDRESSES IN TWO
                 LDY              #>AS_STROUT            ; USER VECTORS
                 STA              MS_Z_RDYJSR + 1
                 STY              MS_Z_RDYJSR + 2
                 LDA              #<MS_MAIN
                 LDY              #>MS_MAIN
                 STA              MS_Z_START + 1
                 STY              MS_Z_START + 2
                 JMP              (MS_Z_START + 1)       ; SILLY, WHY NOT JUST "JMP RESTART"
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; "CALL" STATEMENT

                                                         ; EFFECTIVELY PERFORMS A "JSR" TO THE SPECIFIED
                                                         ; ADDRESS, WITH THE FOLLOWING REGISTER CONTENTS:
                                                         ; (A,Y) = CALL ADDRESS
                                                         ; (X)   = $9D

                                                         ; THE CALLED ROUTINE CAN RETURN WITH "RTS",
                                                         ; AND APPLESOFT WILL CONTINUE WITH THE NEXT
                                                         ; STATEMENT.
                                                         ; --------------------------------
AS_CALL:         JSR              AS_FRMNUM              ; EVALUATE EXPRESSION FOR CALL ADDRESS
                 JSR              AS_GETADR              ; CONVERT EXPRESSION TO 16-BIT INTEGER
                 JMP              (MS_Z_LINNUM)          ; IN LINNUM, AND JUMP THERE.
                                                         ; --------------------------------
                                                         ; "IN#" STATEMENT

                                                         ; NOTE:  NO CHECK FOR VALID SLOT #, AS LONG
                                                         ; AS VALUE IS < 256 IT IS ACCEPTED.
                                                         ; MONITOR MASKS VALUE TO 4 BITS (0-15).
                                                         ; --------------------------------
AS_IN_NUMBER:
                 JSR              AS_GETBYT              ; GET SLOT NUMBER IN X-REG
                 TXA                                     ; MONITOR WILL INSTALL IN VECTOR
                 JMP              MON_INPORT             ; AT $38,39.
                                                         ; --------------------------------
                                                         ; "PR#" STATEMENT

                                                         ; NOTE:  NO CHECK FOR VALID SLOT #, AS LONG
                                                         ; AS VALUE IS < 256 IT IS ACCEPTED.
                                                         ; MONITOR MASKS VALUE TO 4 BITS (0-15).
                                                         ; --------------------------------
AS_PR_NUMBER:
                 JSR              AS_GETBYT              ; GET SLOT NUMBER IN X-REG
                 TXA                                     ; MONITOR WILL INSTALL IN VECTOR
                 JMP              MON_OUTPORT            ; AT $36,37
                                                         ; --------------------------------
                                                         ; GET TWO VALUES < 48, WITH COMMA SEPARATOR

                                                         ; CALLED FOR "PLOT X,Y"
                                                         ; AND "HLIN A,B AT Y"
                                                         ; AND "VLIN A,B AT X"

                                                         ; --------------------------------
AS_PLOTFNS:
                 JSR              AS_GETBYT              ; GET FIRST VALUE IN X-REG
                 CPX              #48                    ; MUST BE < 48
                 BCS              AS_GOERR               ; TOO LARGE
                 STX              AS_FIRST               ; SAVE FIRST VALUE
                 LDA              #"," & %01111111       ; MUST HAVE A COMMA
                 JSR              AS_SYNCHR
                 JSR              AS_GETBYT              ; GET SECOND VALUE IN X-REG
                 CPX              #48                    ; MUST BE < 48
                 BCS              AS_GOERR               ; TOO LARGE
                 STX              MON_H2                 ; SAVE SECOND VALUE
                 STX              MON_V2
                 RTS                                     ; SECOND VALUE STILL IN X-REG
                                                         ; --------------------------------
AS_GOERR:        JMP              AS_IQERR               ; ILLEGAL QUANTITY ERROR
                                                         ; --------------------------------
                                                         ; GET "A,B AT C" VALUES FOR "HLIN" AND "VLIN"

                                                         ; PUT SMALLER OF (A,B) IN FIRST,
                                                         ; AND LARGER  OF (A,B) IN H2 AND V2.
                                                         ; RETURN WITH (X) = C-VALUE.
                                                         ; --------------------------------
AS_LINCOOR:
                 JSR              AS_PLOTFNS             ; GET A,B VALUES
                 CPX              AS_FIRST               ; IS A < B?
                 BCS              AS_L_LINCOOR_1         ; YES, IN RIGHT ORDER
                 LDA              AS_FIRST               ; NO, INTERCHANGE THEM
                 STA              MON_H2
                 STA              MON_V2
                 STX              AS_FIRST
AS_L_LINCOOR_1:  LDA              #AS_TOKENDB            ; MUST HAVE "AT" NEXT
                 JSR              AS_SYNCHR
                 JSR              AS_GETBYT              ; GET C-VALUE IN X-REG
                 CPX              #48                    ; MUST BE < 48
                 BCS              AS_GOERR               ; TOO LARGE
                 RTS                                     ; C-VALUE IN X-REG
                                                         ; --------------------------------
                                                         ; "PLOT" STATEMENT
                                                         ; --------------------------------
AS_PLOT:         JSR              AS_PLOTFNS             ; GET X,Y VALUES
                 TXA                                     ; Y-COORD TO A-REG FOR MONITOR
                 LDY              AS_FIRST               ; X-COORD TO Y-YEG FOR MONITOR
                 CPY              #40                    ; X-COORD MUST BE < 40
                 BCS              AS_GOERR               ; X-COORD IS TOO LARGE
                 JMP              MON_PLOT               ; PLOT!
                                                         ; --------------------------------
                                                         ; "HLIN" STATEMENT
                                                         ; --------------------------------
AS_HLIN:         JSR              AS_LINCOOR             ; GET "A,B AT C"
                 TXA                                     ; Y-COORD IN A-REG
                 LDY              MON_H2                 ; RIGHT END OF LINE
                 CPY              #40                    ; MUST BE < 40
                 BCS              AS_GOERR               ; TOO LARGE
                 LDY              AS_FIRST               ; LEFT END OF LINE IN Y-REG
                 JMP              MON_HLINE              ; LET MONITOR DRAW LINE
                                                         ; --------------------------------
                                                         ; "VLIN" STATEMENT
                                                         ; --------------------------------
AS_VLIN:         JSR              AS_LINCOOR             ; GET "A,B AT C"
                 TXA                                     ; X-COORD IN Y-REG
                 TAY
                 CPY              #40                    ; X-COORD MUST BE < 40
                 BCS              AS_GOERR               ; TOO LARGE
                 LDA              AS_FIRST               ; TOP END OF LINE IN A-REG
                 JMP              MON_VLINE              ; LET MONITOR DRAW LINE
                                                         ; --------------------------------
                                                         ; "COLOR=" STATEMENT
                                                         ; --------------------------------
AS_COLOR:        JSR              AS_GETBYT              ; GET COLOR VALUE IN X-REG
                 TXA
                 JMP              MON_SETCOL             ; LET MONITOR STORE COLOR
                                                         ; --------------------------------
                                                         ; "VTAB" STATEMENT
                                                         ; --------------------------------
AS_VTAB:         JSR              AS_GETBYT              ; GET LINE # IN X-REG
                 DEX                                     ; CONVERT TO ZERO BASE
                 TXA
                 CMP              #24                    ; MUST BE 0-23
                 BCS              AS_GOERR               ; TOO LARGE, OR WAS "VTAB 0"
                 JMP              MON_TABV               ; LET MONITOR COMPUTE BASE
                                                         ; --------------------------------
                                                         ; "SPEED=" STATEMENT
                                                         ; --------------------------------
AS_SPEED:        JSR              AS_GETBYT              ; GET SPEED SETTING IN X-REG
                 TXA                                     ; SPEEDZ = $100-SPEED
                 EOR              #$FF                   ; SO "SPEED=255" IS FASTEST
                 TAX
                 INX
                 STX              AS_SPEEDZ
                 RTS
                                                         ; --------------------------------
                                                         ; "TRACE" STATEMENT
                                                         ; SET SIGN BIT IN TRCFLG
                                                         ; --------------------------------
AS_TRACE:         SEC
                    .BYTE $90                       ; FAKE BCC TO SKIP NEXT OPCODE
                                                         ; --------------------------------
                                                         ; "NOTRACE" STATEMENT
                                                         ; CLEAR SIGN BIT IN TRCFLG
                                                         ; --------------------------------
AS_NOTRACE:
                 CLC
                 ROR              AS_TRCFLG              ; SHIFT CARRY INTO TRCFLG
                 RTS
                                                         ; --------------------------------
                                                         ; "NORMAL" STATEMENT
                                                         ; --------------------------------
AS_NORMAL:       LDA              #$FF                   ; SET INVFLG = $FF
                 BNE              AS_N_I_                ; AND FLASH.BIT = $00
                                                         ; --------------------------------
                                                         ; "INVERSE" STATEMENT
                                                         ; --------------------------------
AS_INVERSE:
                 LDA              #$3F                   ; SET INVFLG = $3F
AS_N_I_:         LDX              #0                     ; AND FLASH.BIT = $00
AS_N_I_F_:       STA              MON_INVFLG
                 STX              AS_FLASH_BIT
                 RTS
                                                         ; --------------------------------
                                                         ; "FLASH" STATEMENT
                                                         ; --------------------------------
AS_FLASH:        LDA              #$7F                   ; SET INVFLG = $7F
                 LDX              #$40                   ; AND FLASH.BIT = $40
                 BNE              AS_N_I_F_              ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; "HIMEM:" STATEMENT
                                                         ; --------------------------------
AS_HIMEM:        JSR              AS_FRMNUM              ; GET VALUE SPECIFIED FOR HIMEM
                 JSR              AS_GETADR              ; AS 16-BIT INTEGER
                 LDA              MS_Z_LINNUM            ; MUST BE ABOVE VARIABLES AND ARRAYS
                 CMP              MS_Z_STREND
                 LDA              MS_Z_LINNUM + 1
                 SBC              MS_Z_STREND + 1
                 BCS              AS_SETHI               ; IT IS ABOVE THEM
AS_JMM:          JMP              MS_OMERR               ; NOT ENOUGH MEMORY
AS_SETHI:        LDA              MS_Z_LINNUM            ; STORE NEW HIMEM: VALUE
                 STA              MS_Z_MEMSIZ
                 STA              MS_Z_FRETOP            ; <<<NOTE THAT "HIMEM:" DOES NOT>>>
                 LDA              MS_Z_LINNUM + 1        ; <<<CLEAR STRING VARIABLES.    >>>
                 STA              MS_Z_MEMSIZ + 1        ; <<<THIS COULD BE DISASTROUS.  >>>
                 STA              MS_Z_FRETOP + 1
                 RTS
                                                         ; --------------------------------
                                                         ; "LOMEM:" STATEMENT
                                                         ; --------------------------------
AS_LOMEM:        JSR              AS_FRMNUM              ; GET VALUE SPECIFIED FOR LOMEM
                 JSR              AS_GETADR              ; AS 16-BIT INTEGER IN LINNUM
                 LDA              MS_Z_LINNUM            ; MUST BE BELOW HIMEM
                 CMP              MS_Z_MEMSIZ
                 LDA              MS_Z_LINNUM + 1
                 SBC              MS_Z_MEMSIZ + 1
                 BCS              AS_JMM                 ; ABOVE HIMEM, MEMORY ERROR
                 LDA              MS_Z_LINNUM            ; MUST BE ABOVE PROGRAM
                 CMP              MS_Z_VARTAB
                 LDA              MS_Z_LINNUM + 1
                 SBC              MS_Z_VARTAB + 1
                 BCC              AS_JMM                 ; NOT ABOVE PROGRAM, ERROR
                 LDA              MS_Z_LINNUM            ; STORE NEW LOMEM VALUE
                 STA              MS_Z_VARTAB
                 LDA              MS_Z_LINNUM + 1
                 STA              MS_Z_VARTAB + 1
                 JMP              MS_CLEARC              ; LOMEM CLEARS VARIABLES AND ARRAYS
                                                         ; --------------------------------
                                                         ; "ON ERR GO TO" STATEMENT
                                                         ; --------------------------------
AS_ONERR:        LDA              #MS_GOTOTK             ; MUST BE "GOTO" NEXT
                 JSR              AS_SYNCHR
                 LDA              MS_Z_TXTPTR            ; SAVE TXTPTR FOR HANDLERR
                 STA              AS_TXTPSV
                 LDA              MS_Z_TXTPTR + 1
                 STA              AS_TXTPSV + 1
                 SEC                                     ; SET SIGN BIT OF ERRFLG
                 ROR              AS_ERRFLG
                 LDA              MS_Z_CURLIN            ; SAVE LINE # OF CURRENT LINE
                 STA              AS_CURLSV
                 LDA              MS_Z_CURLIN + 1
                 STA              AS_CURLSV + 1
                 JSR              MS_REMN                ; IGNORE REST OF LINE <<<WHY?>>>
                 JMP              MS_ADDON               ; CONTINUE PROGRAM
                                                         ; --------------------------------
                                                         ; ROUTINE TO HANDLE ERRORS IF ONERR GOTO ACTIVE
                                                         ; --------------------------------
AS_HANDLERR:
                 STX              AS_ERRNUM              ; SAVE ERROR CODE NUMBER
                 LDX              AS_REMSTK              ; GET STACK PNTR SAVED AT NEWSTT
                 STX              AS_ERRSTK              ; REMEMBER IT
                                                         ; <<<COULD ALSO HAVE DONE TXS  >>>
                                                         ; <<<HERE; SEE ONERR CORRECTION>>>
                                                         ; <<<IN APPLESOFT MANUAL.      >>>
                 LDA              MS_Z_CURLIN            ; GET LINE # OF OFFENDING STATEMENT
                 STA              AS_ERRLIN              ; SO USER CAN SEE IT IF DESIRED
                 LDA              MS_Z_CURLIN + 1
                 STA              AS_ERRLIN + 1
                 LDA              MS_Z_OLDTXT            ; ALSO THE POSITION IN THE LINE
                 STA              AS_ERRPOS              ; IN CASE USER WANTS TO "RESUME"
                 LDA              MS_Z_OLDTXT + 1
                 STA              AS_ERRPOS + 1
                 LDA              AS_TXTPSV              ; SET UP TXTPTR TO READ TARGET LINE #
                 STA              MS_Z_TXTPTR            ; IN "ON ERR GO TO XXXX"
                 LDA              AS_TXTPSV + 1
                 STA              MS_Z_TXTPTR + 1
                 LDA              AS_CURLSV
                 STA              MS_Z_CURLIN            ; LINE # OF "ON ERR" STATEMENT
                 LDA              AS_CURLSV + 1
                 STA              MS_Z_CURLIN + 1
                 JSR              MS_Z_CHRGOT            ; START CONVERSION
                 JSR              MS_GOTO                ; GOTO SPECIFIED ONERR LINE
                 JMP              AS_NEWSTT
                                                         ; --------------------------------
                                                         ; "RESUME" STATEMENT
                                                         ; --------------------------------
AS_RESUME:       LDA              AS_ERRLIN              ; RESTORE LINE # AND TXTPTR
                 STA              MS_Z_CURLIN            ; TO RE-TRY OFFENDING LINE
                 LDA              AS_ERRLIN + 1
                 STA              MS_Z_CURLIN + 1
                 LDA              AS_ERRPOS
                 STA              MS_Z_TXTPTR
                 LDA              AS_ERRPOS + 1
                 STA              MS_Z_TXTPTR + 1
                                                         ; <<< ONERR CORRECTION IN MANUAL IS EASILY >>>
                                                         ; <<< BY "CALL -3288", WHICH IS $F328 HERE >>>
                 LDX              AS_ERRSTK              ; RETRIEVE STACK PNTR AS IT WAS
                 TXS                                     ; BEFORE STATEMENT SCANNED
                 JMP              AS_NEWSTT              ; DO STATEMENT AGAIN
                                                         ; --------------------------------
AS_JSYN:         JMP              AS_SYNERR
                                                         ; --------------------------------
                                                         ; "DEL" STATEMENT
                                                         ; --------------------------------
AS_DEL:          BCS              AS_JSYN                ; ERROR IF # NOT SPECIFIED
                 LDX              AS_PRGEND
                 STX              MS_Z_VARTAB
                 LDX              AS_PRGEND + 1
                 STX              MS_Z_VARTAB + 1
                 JSR              MS_LINGET              ; GET BEGINNING OF RANGE
                 JSR              MS_FNDLIN              ; FIND THIS LINE OR NEXT
                 LDA              MS_Z_LOWTR             ; UPPER PORTION OF PROGRAM WILL
                 STA              AS_DEST                ; BE MOVED DOWN TO HERE
                 LDA              MS_Z_LOWTR + 1
                 STA              AS_DEST + 1
                 LDA              #"," & %01111111       ; MUST HAVE A COMMA NEXT
                 JSR              AS_SYNCHR
                 JSR              MS_LINGET              ; GET END RANGE
                                                         ; (DOES NOTHING IF END RANGE
                                                         ; IS NOT SPECIFIED)
                 INC              MS_Z_LINNUM            ; POINT ONE PAST IT
                 BNE              AS_L_DEL_1
                 INC              MS_Z_LINNUM + 1
AS_L_DEL_1:      JSR              MS_FNDLIN              ; FIND START LINE AFTER SPECIFIED LINE
                 LDA              MS_Z_LOWTR             ; WHICH IS BEGINNING OF PORTION
                 CMP              AS_DEST                ; TO BE MOVED DOWN
                 LDA              MS_Z_LOWTR + 1         ; IT MUST BE ABOVE THE TARGET
                 SBC              AS_DEST + 1
                 BCS              AS_L_DEL_2             ; IT IS OKAY
                 RTS                                     ; NOTHING TO DELETE
AS_L_DEL_2:      LDY              #0                     ; MOVE UPPER PORTION DOWN NOW
AS_L_DEL_3:      LDA              (MS_Z_LOWTR),Y         ; SOURCE . . .
                 STA              (AS_DEST),Y            ; ...TO DESTINATION
                 INC              MS_Z_LOWTR             ; BUMP SOURCE PNTR
                 BNE              AS_L_DEL_4
                 INC              MS_Z_LOWTR + 1
AS_L_DEL_4:      INC              AS_DEST                ; BUMP DESTINATION PNTR
                 BNE              AS_L_DEL_5
                 INC              AS_DEST + 1
AS_L_DEL_5:      LDA              MS_Z_VARTAB            ; REACHED END OF PROGRAM YET?
                 CMP              MS_Z_LOWTR
                 LDA              MS_Z_VARTAB + 1
                 SBC              MS_Z_LOWTR + 1
                 BCS              AS_L_DEL_3             ; NO, KEEP MOVING
                 LDX              AS_DEST + 1            ; STORE NEW END OF PROGRAM
                 LDY              AS_DEST                ; MUST SUBTRACT 1 FIRST
                 BNE              AS_L_DEL_6
                 DEX
AS_L_DEL_6:       DEY
                 STX              MS_Z_VARTAB + 1
                 STY              MS_Z_VARTAB
                 JMP              MS_FINI                ; RESET LINKS AFTER A DELETE
                                                         ; --------------------------------
                                                         ; "GR" STATEMENT
                                                         ; --------------------------------
AS_GR:           LDA              AS_SW_LORES
                 LDA              AS_SW_MIXSET
                 JMP              MON_SETGR
                                                         ; --------------------------------
                                                         ; "TEXT" STATEMENT
                                                         ; --------------------------------
AS_TEXT:         LDA              AS_SW_LOWSCR           ; JMP $FB36 WOULD HAVE
                 JMP              MON_SETTXT             ; DONE BOTH OF THESE
                                                         ; <<<       BETTER CODE WOULD BE:   >>>
                                                         ; <<<  LDA SW.MIXSET                >>>
                                                         ; <<<  JMP $FB33                    >>>
                                                         ; --------------------------------
                                                         ; "STORE" STATEMENT
                                                         ; --------------------------------
AS_STORE:        JSR              AS_GETARYPT            ; GET ADDRESS OF ARRAY TO BE SAVED
                 LDY              #3                     ; FORWARD OFFSET - 1 IS SIZE OF
                 LDA              (MS_Z_LOWTR),Y         ; THIS ARRAY
                 TAX
                 DEY
                 LDA              (MS_Z_LOWTR),Y
                 SBC              #1
                 BCS              AS_L_STORE_1
                 DEX
AS_L_STORE_1:    STA              MS_Z_LINNUM
                 STX              MS_Z_LINNUM + 1
                 JSR              MON_WRITE
                 JSR              AS_TAPEPNT
                 JMP              MON_WRITE
                                                         ; --------------------------------
                                                         ; "RECALL" STATEMENT
                                                         ; --------------------------------
AS_RECALL:       JSR              AS_GETARYPT            ; FIND ARRAY IN MEMORY
                 JSR              MON_READ               ; READ HEADER
                 LDY              #2                     ; MAKE SURE THE NEW DATA FITS
                 LDA              (MS_Z_LOWTR),Y
                 CMP              MS_Z_LINNUM
                 INY
                 LDA              (MS_Z_LOWTR),Y
                 SBC              MS_Z_LINNUM + 1
                 BCS              AS_L_RECALL_1          ; IT FITS
                 JMP              MS_OMERR               ; DOESN'T FIT
AS_L_RECALL_1:   JSR              AS_TAPEPNT             ; READ THE DATA
                 JMP              MON_READ
                                                         ; --------------------------------
                                                         ; "HGR" AND "HGR2" STATEMENTS
                                                         ; --------------------------------
AS_HGR2:         BIT              AS_SW_HISCR            ; SELECT PAGE 2 ($4000-5FFF)
                 BIT              AS_SW_MIXCLR           ; DEFAULT TO FULL SCREEN
                 LDA              #>$4000                ; SET STARTING PAGE FOR HIRES
                 BNE              AS_SETHPG              ; ...ALWAYS
AS_HGR:          LDA              #>$2000                ; SET STARTING PAGE FOR HIRES
                 BIT              AS_SW_LOWSCR           ; SELECT PAGE 1 ($2000-3FFF)
                 BIT              AS_SW_MIXSET           ; DEFAULT TO MIXED SCREEN
AS_SETHPG:       STA              AS_HGR_PAGE            ; BASE PAGE OF HIRES BUFFER
                 LDA              AS_SW_HIRES            ; TURN ON HIRES
                 LDA              AS_SW_TXTCLR           ; TURN ON GRAPHICS
                                                         ; --------------------------------
                                                         ; CLEAR SCREEN
                                                         ; --------------------------------
AS_HCLR:         LDA              #0                     ; SET FOR BLACK BACKGROUND
                 STA              AS_HGR_BITS
                                                         ; --------------------------------
                                                         ; FILL SCREEN WITH (HGR.BITS)
                                                         ; --------------------------------
AS_BKGND:        LDA              AS_HGR_PAGE            ; PUT BUFFER ADDRESS IN HGR.SHAPE
                 STA              AS_HGR_SHAPE + 1
                 LDY              #0
                 STY              AS_HGR_SHAPE
AS_L_BKGND_1:    LDA              AS_HGR_BITS            ; COLOR BYTE
                 STA              (AS_HGR_SHAPE),Y       ; CLEAR HIRES TO HGR.BITS
                 JSR              AS_COLOR_SHIFT         ; CORRECT FOR COLOR SHIFT
                 INY                                     ; (SLOWS CLEAR BY FACTOR OF 2)
                 BNE              AS_L_BKGND_1
                 INC              AS_HGR_SHAPE + 1
                 LDA              AS_HGR_SHAPE + 1
                 AND              #$1F                   ; DONE?  ($40 OR$60)
                 BNE              AS_L_BKGND_1           ; NO
                 RTS                                     ; YES, RETURN
                                                         ; --------------------------------
                                                         ; SET THE HIRES CURSOR POSITION

                                                         ; (Y,X) = HORIZONTAL COORDINATE  (0-279)
                                                         ; (A)   = VERTICAL COORDINATE    (0-191)
                                                         ; --------------------------------
AS_HPOSN:        STA              AS_HGR_Y               ; SAVE Y- AND X-POSITIONS
                 STX              AS_HGR_X
                 STY              AS_HGR_X + 1
                 PHA                                     ; Y-POS ALSO ON STACK
                 AND              #$C0                   ; CALCULATE BASE ADDRESS FOR Y-POS
                 STA              MON_GBASL              ; FOR Y=ABCDEFGH
                 LSR                                     ; GBASL=ABAB0000
                 LSR
                 ORA              MON_GBASL
                 STA              MON_GBASL
                 PLA                                     ; (A)      (GBASH)   (GBASL)
                 STA              MON_GBASH              ; ?-ABCDEFGH  ABCDEFGH  ABAB0000
                 ASL                                     ; A-BCDEFGH0  ABCDEFGH  ABAB0000
                 ASL                                     ; B-CDEFGH00  ABCDEFGH  ABAB0000
                 ASL                                     ; C-DEFGH000  ABCDEFGH  ABAB0000
                 ROL              MON_GBASH              ; A-DEFGH000  BCDEFGHC  ABAB0000
                 ASL                                     ; D-EFGH0000  BCDEFGHC  ABAB0000
                 ROL              MON_GBASH              ; B-EFGH0000  CDEFGHCD  ABAB0000
                 ASL                                     ; E-FGH00000  CDEFGHCD  ABAB0000
                 ROR              MON_GBASL              ; 0-FGH00000  CDEFGHCD  EABAB000
                 LDA              MON_GBASH              ; 0-CDEFGHCD  CDEFGHCD  EABAB000
                 AND              #$1F                   ; 0-000FGHCD  CDEFGHCD  EABAB000
                 ORA              AS_HGR_PAGE            ; 0-PPPFGHCD  CDEFGHCD  EABAB000
                 STA              MON_GBASH              ; 0-PPPFGHCD  PPPFGHCD  EABAB000
                 TXA                                     ; DIVIDE X-POS BY 7 FOR INDEX FROM BASE
                 CPY              #0                     ; IS X-POS < 256?
                 BEQ              AS_L_HPOSN_2           ; YES
                 LDY              #35                    ; NO: 256/7 = 36 REM 4
                                                         ; CARRY=1, SO ADC #4 IS TOO LARGE;
                                                         ; HOWEVER, ADC #4 CLEARS CARRY
                                                         ; WHICH MAKES SBC #7 ONLY -6
                                                         ; BALANCING IT OUT.
                 ADC              #4                     ; FOLLOWING INY MAKES Y=36
AS_L_HPOSN_1:     INY
AS_L_HPOSN_2:    SBC              #7
                 BCS              AS_L_HPOSN_1
                 STY              AS_HGR_HORIZ           ; HORIZONTAL INDEX
                 TAX                                     ; USE REMAINDER-7 TO LOOK UP THE
                 LDA              AS_MSKTBL - $100 + 7,X ; BIT MASK
                 STA              MON_HMASK
                 TYA                                     ; QUOTIENT GIVES BYTE INDEX
                 LSR                                     ; ODD OR EVEN COLUMN?
                 LDA              AS_HGR_COLOR           ; IF ON ODD BYTE (CARRY SET)
                 STA              AS_HGR_BITS            ; THEN ROTATE BITS
                 BCS              AS_COLOR_SHIFT         ; ODD COLUMN
                 RTS                                     ; EVEN COLUMN
                                                         ; --------------------------------
                                                         ; PLOT A DOT

                                                         ; (Y,X) = HORIZONTAL POSITION
                                                         ; (A)   = VERTICAL POSITION
                                                         ; --------------------------------
AS_HPLOT0:       JSR              AS_HPOSN
                 LDA              AS_HGR_BITS            ; CALCULATE BIT POSN IN GBAS,
                 EOR              (MON_GBASL),Y          ; HGR.HORIZ, AND HMASK FROM
                 AND              MON_HMASK              ; Y-COOR IN A-REG,
                 EOR              (MON_GBASL),Y          ; X-COOR IN X,Y REGS.
                 STA              (MON_GBASL),Y          ; FOR ANY 1-BITS, SUBSTITUTE
                 RTS                                     ; CORRESPONDING BIT OF HGR.BITS
                                                         ; --------------------------------
                                                         ; MOVE LEFT OR RIGHT ONE PIXEL

                                                         ; IF STATUS IS +, MOVE RIGHT; IF -, MOVE LEFT
                                                         ; IF ALREADY AT LEFT OR RIGHT EDGE, WRAP AROUND

                                                         ; REMEMBER BITS IN HI-RES BYTE ARE BACKWARDS ORDER:
                                                         ; BYTE N   BYTE N+1
                                                         ; S7654321   SEDCBA98
                                                         ; --------------------------------
AS_MOVE_LEFT_OR_RIGHT:
                 BPL              AS_MOVE_RIGHT          ; + MOVE RIGHT, - MOVE LEFT
                 LDA              MON_HMASK              ; MOVE LEFT ONE PIXEL
                 LSR                                     ; SHIFT MASK RIGHT, MOVES DOT LEFT
                 BCS              AS_LR_2                ; ...DOT MOVED TO NEXT BYTE
                 EOR              #$C0                   ; MOVE SIGN BIT BACK WHERE IT WAS
AS_LR_1:         STA              MON_HMASK              ; NEW MASK VALUE
                 RTS
AS_LR_2:          DEY                    ; MOVED TO NEXT BYTE, SO DECR INDEX
                 BPL              AS_LR_3                ; STILL NOT PAST EDGE
                 LDY              #39                    ; OFF LEFT EDGE, SO WRAP AROUND SCREEN
AS_LR_3:         LDA              #$C0                   ; NEW HMASK, RIGHTMOST BIT ON SCREEN
AS_LR_4:         STA              MON_HMASK              ; NEW MASK AND INDEX
                 STY              AS_HGR_HORIZ
                 LDA              AS_HGR_BITS            ; ALSO NEED TO ROTATE COLOR
                                                         ; --------------------------------
AS_COLOR_SHIFT:
                 ASL                                     ; ROTATE LOW-ORDER 7 BITS
                 CMP              #$C0                   ; OF HGR.BITS ONE BIT POSN.
                 BPL              AS_L_COLOR_SHIFT_1
                 LDA              AS_HGR_BITS
                 EOR              #$7F
                 STA              AS_HGR_BITS
AS_L_COLOR_SHIFT_1: RTS
                                                         ; --------------------------------
                                                         ; MOVE RIGHT ONE PIXEL
                                                         ; IF ALREADY AT RIGHT EDGE, WRAP AROUND
                                                         ; --------------------------------
AS_MOVE_RIGHT:
                 LDA              MON_HMASK
                 ASL                                     ; SHIFTING BYTE LEFT MOVES PIXEL RIGHT
                 EOR              #$80
                                                         ; ORIGINAL:  C0 A0 90 88 84 82 81
                                                         ; SHIFTED:   80 40 20 10 08 02 01
                                                         ; EOR #$80:  00 C0 A0 90 88 84 82
                 BMI              AS_LR_1                ; FINISHED
                 LDA              #$81                   ; NEW MASK VALUE
                 INY                                     ; MOVE TO NEXT BYTE RIGHT
                 CPY              #40                    ; UNLESS THAT IS TOO FAR
                 BCC              AS_LR_4                ; NOT TOO FAR
                 LDY              #0                     ; TOO FAR, SO WRAP AROUND
                 BCS              AS_LR_4                ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; --------------------------------
                                                         ; "XDRAW" ONE BIT
                                                         ; --------------------------------
AS_LRUDX1:        CLC                    ; C=0 MEANS NO 90 DEGREE ROTATION
AS_LRUDX2:       LDA              AS_HGR_DX + 1          ; C=1 MEANS ROTATE 90 DEGREES
                 AND              #4                     ; IF BIT2=0 THEN DON'T PLOT
                 BEQ              AS_LRUD4               ; YES, DO NOT PLOT
                 LDA              #$7F                   ; NO, LOOK AT WHAT IS ALREADY THERE
                 AND              MON_HMASK
                 AND              (MON_GBASL),Y          ; SCREEN BIT = 1?
                 BNE              AS_LRUD3               ; YES, GO CLEAR IT
                 INC              AS_HGR_COLLISIONS      ; NO, COUNT THE COLLISION
                 LDA              #$7F                   ; AND TURN THE BIT ON
                 AND              MON_HMASK
                 BPL              AS_LRUD3               ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; "DRAW" ONE BIT
                                                         ; --------------------------------
AS_LRUD1:         CLC                    ; C=0 MEANS NO 90 DEGREE ROTATION
AS_LRUD2:        LDA              AS_HGR_DX + 1          ; C=1 MEANS ROTATE
                 AND              #4                     ; IF BIT2=0 THEN DO NOT PLOT
                 BEQ              AS_LRUD4               ; DO NOT PLOT
                 LDA              (MON_GBASL),Y
                 EOR              AS_HGR_BITS            ; 1'S WHERE ANY BITS NOT IN COLOR
                 AND              MON_HMASK              ; LOOK AT JUST THIS BIT POSITION
                 BNE              AS_LRUD3               ; THE BIT WAS ZERO, SO PLOT IT
                 INC              AS_HGR_COLLISIONS      ; BIT IS ALREADY 1; COUNT COLLSN
                                                         ; --------------------------------
                                                         ; TOGGLE BIT ON SCREEN WITH (A)
                                                         ; --------------------------------
AS_LRUD3:        EOR              (MON_GBASL),Y
                 STA              (MON_GBASL),Y
                                                         ; --------------------------------
                                                         ; DETERMINE WHERE NEXT POINT WILL BE, AND MOVE THERE
                                                         ; C=0 IF NO 90 DEGREE ROTATION
                                                         ; C=1 ROTATES 90 DEGREES
                                                         ; --------------------------------
AS_LRUD4:        LDA              AS_HGR_DX + 1          ; CALCULATE THE DIRECTION TO MOVE
                 ADC              AS_HGR_QUADRANT
                 AND              #3                     ; WRAP AROUND THE CIRCLE
AS_CON_03        =                * - 1                  ; (( A CONSTANT ))

                                                         ; 00 -- UP
                                                         ; 01 -- DOWN
                                                         ; 10 -- RIGHT
                                                         ; 11 -- LEFT

                 CMP              #2                     ; C=0 IF 0 OR 1, C=1 IF 2 OR 3
                 ROR                                     ; PUT C INTO SIGN, ODD/EVEN INTO C
                 BCS              AS_MOVE_LEFT_OR_RIGHT
                                                         ; --------------------------------
AS_MOVE_UP_OR_DOWN:
                 BMI              AS_MOVE_DOWN           ; SIGN FOR UP/DOWN SELECT_
                                                         ; --------------------------------
                                                         ; MOVE UP ONE PIXEL
                                                         ; IF ALREADY AT TOP, GO TO BOTTOM

                                                         ; REMEMBER:  Y-COORD   GBASH     GBASL
                                                         ; ABCDEFGH  PPPFGHCD  EABAB000
                                                         ; --------------------------------
                 CLC                                     ; MOVE UP
                 LDA              MON_GBASH              ; CALC. BASE ADDRESS OF PREV. LINE
                 BIT              AS_CON_1C              ; LOOK AT BITS 000FGH00 IN GBASH
                 BNE              AS_L_MOVE_UP_OR_DOWN_5 ; SIMPLE, JUST FGH=FGH-1
                                                         ; GBASH=PPP000CD, GBASL=EABAB000
                 ASL              MON_GBASL              ; WHAT IS "E"?
                 BCS              AS_L_MOVE_UP_OR_DOWN_3 ; E=1, THEN EFGH=EFGH-1
                 BIT              AS_CON_03              ; LOOK AT 000000CD IN GBASH
                 BEQ              AS_L_MOVE_UP_OR_DOWN_1 ; Y-POS IS AB000000 FORM
                 ADC              #$1F                   ; CD <> 0, SO CDEFGH=CDEFGH-1
                 SEC
                 BCS              AS_L_MOVE_UP_OR_DOWN_4 ; ...ALWAYS
AS_L_MOVE_UP_OR_DOWN_1: ADC              #$23                   ; ENOUGH TO MAKE GBASH=PPP11111 LATER
                 PHA                                     ; SAVE FOR LATER
                 LDA              MON_GBASL              ; GBASL IS NOW ABAB0000 (AB=00,01,10)
                 ADC              #$B0                   ; 0000+1011=1011 AND CARRY CLEAR
                                                         ; OR 0101+1011=0000 AND CARRY SET
                                                         ; OR 1010+1011=0101 AND CARRY SET
                 BCS              AS_L_MOVE_UP_OR_DOWN_2 ; NO WRAP-AROUND NEEDED
                 ADC              #$F0                   ; CHANGE 1011 TO 1010 (WRAP-AROUND)
AS_L_MOVE_UP_OR_DOWN_2: STA              MON_GBASL              ; FORM IS NOW STILL ABAB0000
                 PLA                                     ; PARTIALLY MODIFIED GBASH
                 BCS              AS_L_MOVE_UP_OR_DOWN_4 ; ...ALWAYS
AS_L_MOVE_UP_OR_DOWN_3: ADC              #$1F
AS_L_MOVE_UP_OR_DOWN_4: ROR              MON_GBASL              ; SHIFT IN E, TO GET EABAB000 FORM
AS_L_MOVE_UP_OR_DOWN_5: ADC              #$FC                   ; FINISH GBASH MODS
AS_UD_1:         STA              MON_GBASH
                 RTS
                                                         ; --------------------------------
                 CLC                                     ; <<<NEVER USED>>>
                                                         ; --------------------------------
                                                         ; MOVE DOWN ONE PIXEL
                                                         ; IF ALREADY AT BOTTOM, GO TO TOP

                                                         ; REMEMBER:  Y-COORD   GBASH     GBASL
                                                         ; ABCDEFGH  PPPFGHCD  EABAB000
                                                         ; --------------------------------
AS_MOVE_DOWN:
                 LDA              MON_GBASH              ; TRY IT FIRST, BY FGH=FGH+1
                 ADC              #4                     ; GBASH = PPPFGHCD
AS_CON_04        =                * - 1                  ; (( CONSTANT ))
                 BIT              AS_CON_1C              ; IS FGH FIELD NOW ZERO?
                 BNE              AS_UD_1                ; NO, SO WE ARE FINISHED
                                                         ; YES, RIPPLE THE CARRY AS HIGH
                                                         ; AS NECESSARY
                 ASL              MON_GBASL              ; LOOK AT "E" BIT
                 BCC              AS_L_CON_04_2          ; NOW ZERO; MAKE IT 1 AND LEAVE
                 ADC              #$E0                   ; CARRY = 1, SO ADDS $E1
                 CLC                                     ; IS "CD" NOT ZERO?
                 BIT              AS_CON_04              ; TESTS BIT 2 FOR CARRY OUT OF "CD"
                 BEQ              AS_L_CON_04_3          ; NO CARRY, FINISHED
                                                         ; INCREMENT "AB" THEN
                                                         ; 0000 --> 0101
                                                         ; 0101 --> 1010
                                                         ; 1010 --> WRAP AROUND TO LINE 0
                 LDA              MON_GBASL              ; 0000  0101  1010
                 ADC              #$50                   ; 0101  1010  1111
                 EOR              #$F0                   ; 1010  0101  0000
                 BEQ              AS_L_CON_04_1
                 EOR              #$F0                   ; 0101  1010
AS_L_CON_04_1:   STA              MON_GBASL              ; NEW ABAB0000
                 LDA              AS_HGR_PAGE            ; WRAP AROUND TO LINE ZERO OF GROUP
                 BCC              AS_L_CON_04_3          ; ...ALWAYS
AS_L_CON_04_2:   ADC              #$E0
AS_L_CON_04_3:   ROR              MON_GBASL
                 BCC              AS_UD_1                ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; HLINRL IS NEVER CALLED BY APPLESOFT

                                                         ; ENTER WITH:  (A,X) = DX FROM CURRENT POINT
                                                         ; (Y)   = DY FROM CURRENT POINT
                                                         ; --------------------------------
AS_HLINRL:        PHA                    ; SAVE (A)
                 LDA              #0                     ; CLEAR CURRENT POINT SO HGLIN WILL
                 STA              AS_HGR_X               ; ACT RELATIVELY
                 STA              AS_HGR_X + 1
                 STA              AS_HGR_Y
                 PLA                                     ; RESTORE (A)
                                                         ; --------------------------------
                                                         ; DRAW LINE FROM LAST PLOTTED POINT TO (A,X),(Y)

                                                         ; ENTER WITH:  (A,X) = X OF TARGET POINT
                                                         ; (Y)   = Y OF TARGET POINT
                                                         ; --------------------------------
AS_HGLIN:         PHA                    ; COMPUTE DX = X- X0
                 SEC
                 SBC              AS_HGR_X
                 PHA
                 TXA
                 SBC              AS_HGR_X + 1
                 STA              AS_HGR_QUADRANT        ; SAVE DX SIGN (+ = RIGHT, - = LEFT)
                 BCS              AS_L_HGLIN_1           ; NOW FIND ABS (DX)
                 PLA                                     ; FORMS 2'S COMPLEMENT
                 EOR              #$FF
                 ADC              #1
                 PHA
                 LDA              #0
                 SBC              AS_HGR_QUADRANT
AS_L_HGLIN_1:    STA              AS_HGR_DX + 1
                 STA              AS_HGR_E + 1           ; INIT HGR.E TO ABS(X-X0)
                 PLA
                 STA              AS_HGR_DX
                 STA              AS_HGR_E
                 PLA
                 STA              AS_HGR_X               ; TARGET X POINT
                 STX              AS_HGR_X + 1
                 TYA                                     ; TARGET Y POINT
                 CLC                                     ; COMPUTE DY = Y-HGR.Y
                 SBC              AS_HGR_Y               ; AND SAVE -ABS(Y-HGR.Y)-1 IN HGR.DY
                 BCC              AS_L_HGLIN_2           ; (SO + MEANS UP, - MEANS DOWN)
                 EOR              #$FF                   ; 2'S COMPLEMENT OF DY
                 ADC              #$FE
AS_L_HGLIN_2:    STA              AS_HGR_DY
                 STY              AS_HGR_Y               ; TARGET Y POINT
                 ROR              AS_HGR_QUADRANT        ; SHIFT Y-DIRECTION INTO QUADRANT
                 SEC                                     ; COUNT = DX -(-DY) = # OF DOTS NEEDED
                 SBC              AS_HGR_DX
                 TAX                                     ; COUNTL IS IN X-REG
                 LDA              #$FF
                 SBC              AS_HGR_DX + 1
                 STA              AS_HGR_COUNT
                 LDY              AS_HGR_HORIZ           ; HORIZONTAL INDEX
                 BCS              AS_MOVEX2              ; ...ALWAYS
                                                         ; --------------------------------
                                                         ; MOVE LEFT OR RIGHT ONE PIXEL
                                                         ; (A) BIT 6 HAS DIRECTION
                                                         ; --------------------------------
AS_MOVEX:         ASL                    ; PUT BIT 6 INTO SIGN POSITION
                 JSR              AS_MOVE_LEFT_OR_RIGHT
                 SEC
                                                         ; --------------------------------
                                                         ; DRAW LINE NOW
                                                         ; --------------------------------
AS_MOVEX2:       LDA              AS_HGR_E               ; CARRY IS SET
                 ADC              AS_HGR_DY              ; E = E-DELTY
                 STA              AS_HGR_E               ; NOTE: DY IS (-DELTA Y)-1
                 LDA              AS_HGR_E + 1           ; CARRY CLR IF HGR.E GOES NEGATIVE
                 SBC              #0
AS_L_MOVEX2_1:   STA              AS_HGR_E + 1
                 LDA              (MON_GBASL),Y
                 EOR              AS_HGR_BITS            ; PLOT A DOT
                 AND              MON_HMASK
                 EOR              (MON_GBASL),Y
                 STA              (MON_GBASL),Y
                 INX                                     ; FINISHED ALL THE DOTS?
                 BNE              AS_L_MOVEX2_2          ; NO
                 INC              AS_HGR_COUNT           ; TEST REST OF COUNT
                 BEQ              AS_RTS_22              ; YES, FINISHED.
AS_L_MOVEX2_2:   LDA              AS_HGR_QUADRANT        ; TEST DIRECTION
                 BCS              AS_MOVEX               ; NEXT MOVE IS IN THE X DIRECTION
                 JSR              AS_MOVE_UP_OR_DOWN     ; IF CLR, NEG, MOVE
                 CLC                                     ; E = E+DX
                 LDA              AS_HGR_E
                 ADC              AS_HGR_DX
                 STA              AS_HGR_E
                 LDA              AS_HGR_E + 1
                 ADC              AS_HGR_DX + 1
                 BVC              AS_L_MOVEX2_1          ; ...ALWAYS
                                                         ; --------------------------------

AS_MSKTBL              .BYTE %10000001
                    .BYTE %10000010
                    .BYTE %10000100
                    .BYTE %10001000
                    .BYTE %10010000
                    .BYTE %10100000
                    .BYTE %11000000
                                                         ; --------------------------------
AS_CON_1C              .BYTE %00011100                ; MASK FOR "FGH" BITS
                                                         ; --------------------------------

                                                         ; --------------------------------
                                                         ; TABLE OF COS(90*X/16 DEGREES)*$100 - 1
                                                         ; WITH ONE BYTE PRECISION, X=0 TO 16:
                                                         ; --------------------------------
AS_COSINE_TABLE        .BYTE $FF,$FE,$FA,$F4,$EC,$E1,$D4,$C5
                    .BYTE $B4,$A1,$8D,$78,$61,$49,$31,$18
                    .BYTE $FF
                                                         ; --------------------------------
                                                         ; HFIND -- CALCULATES CURRENT POSITION OF HI-RES CURSOR
                                                         ; (NOT CALLED BY ANY APPLESOFT ROUTINE)

                                                         ; CALCULATE Y-COORD FROM GBASL,H
                                                         ; AND X-COORD FROM HORIZ AND HMASK
                                                         ; --------------------------------
AS_HFIND:        LDA              MON_GBASL              ; GBASL = EABAB000
                 ASL                                     ; E INTO CARRY
                 LDA              MON_GBASH              ; GBASH = PPPFGHCD
                 AND              #3                     ; 000000CD
                 ROL                                     ; 00000CDE
                 ORA              MON_GBASL              ; EABABCDE
                 ASL                                     ; ABABCDE0
                 ASL                                     ; BABCDE00
                 ASL                                     ; ABCDE000
                 STA              AS_HGR_Y               ; ALL BUT FGH
                 LDA              MON_GBASH              ; PPPFGHCD
                 LSR                                     ; 0PPPFGHC
                 LSR                                     ; 00PPPFGH
                 AND              #7                     ; 00000FGH
                 ORA              AS_HGR_Y               ; ABCDEFGH
                 STA              AS_HGR_Y               ; THAT TAKES CARE OF Y-COORDINATE!
                 LDA              AS_HGR_HORIZ           ; X = 7*HORIZ + BIT POS. IN HMASK
                 ASL                                     ; MULTIPLY BY 7
                 ADC              AS_HGR_HORIZ           ; 3* SO FAR
                 ASL                                     ; 6*
                 TAX                                     ; SINCE 7* MIGHT NOT FIT IN 1 BYTE,
                                                         ; WAIT TILL LATER FOR LAST ADD
                 DEX
                 LDA              MON_HMASK              ; NOW FIND BIT POSITION IN HMASK
                 AND              #$7F                   ; ONLY LOOK AT LOW SEVEN
AS_L_HFIND_1:     INX                    ; COUNT A SHIFT
                 LSR
                 BNE              AS_L_HFIND_1           ; STILL IN THERE
                 STA              AS_HGR_X + 1           ; ZERO TO HI-BYTE
                 TXA                                     ; 6*HORIZ+LOG2(HMASK)
                 CLC                                     ; ADD HORIZ ONE MORE TIME
                 ADC              AS_HGR_HORIZ           ; 7*HORIZ+LOG2(HMASK)
                 BCC              AS_L_HFIND_2           ; UPPER BYTE = 0
                 INC              AS_HGR_X + 1           ; UPPER BYTE = 1
AS_L_HFIND_2:    STA              AS_HGR_X               ; STORE LOWER BYTE
AS_RTS_22:        RTS
                                                         ; --------------------------------
                                                         ; DRAW A SHAPE

                                                         ; (Y,X) = SHAPE STARTING ADDRESS
                                                         ; (A)   = ROTATION (0-3F)
                                                         ; --------------------------------
                                                         ; APPLESOFT DOES NOT CALL DRAW0
                                                         ; --------------------------------
AS_DRAW0:        STX              AS_HGR_SHAPE           ; SAVE SHAPE ADDRESS
                 STY              AS_HGR_SHAPE + 1
                                                         ; --------------------------------
                                                         ; APPLESOFT ENTERS HERE
                                                         ; --------------------------------
AS_DRAW1:         TAX                    ; SAVE ROTATION (0-$3F)
                 LSR                                     ; DIVIDE ROTATION BY 16 TO GET
                 LSR                                     ; QUADRANT (0=UP, 1=RT, 2=DWN, 3=LFT)
                 LSR
                 LSR
                 STA              AS_HGR_QUADRANT
                 TXA                                     ; USE LOW 4 BITS OF ROTATION TO INDEX
                 AND              #$0F                   ; THE TRIG TABLE
                 TAX
                 LDY              AS_COSINE_TABLE,X      ; SAVE COSINE IN HGR.DX
                 STY              AS_HGR_DX
                 EOR              #$F                    ; AND SINE IN DY
                 TAX
                 LDY              AS_COSINE_TABLE + 1,X
                 INY
                 STY              AS_HGR_DY
                 LDY              AS_HGR_HORIZ           ; INDEX FROM GBASL,H TO BYTE WE'RE IN
                 LDX              #0
                 STX              AS_HGR_COLLISIONS      ; CLEAR COLLISION COUNTER
                 LDA              (AS_HGR_SHAPE,X)       ; GET FIRST BYTE OF SHAPE DEFN
AS_L_DRAW1_1:    STA              AS_HGR_DX + 1          ; KEEP SHAPE BYTE IN HGR.DX+1
                 LDX              #$80                   ; INITIAL VALUES FOR FRACTIONAL VECTORS
                 STX              AS_HGR_E               ; L_DRAW1_5 IN COSINE COMPONENT
                 STX              AS_HGR_E + 1           ; L_DRAW1_5 IN SINE COMPONENT
                 LDX              AS_HGR_SCALE           ; SCALE FACTOR
AS_L_DRAW1_2:    LDA              AS_HGR_E               ; ADD COSINE VALUE TO X-VALUE
                 SEC                                     ; IF >= 1, THEN DRAW
                 ADC              AS_HGR_DX
                 STA              AS_HGR_E               ; ONLY SAVE FRACTIONAL PART
                 BCC              AS_L_DRAW1_3           ; NO INTEGRAL PART
                 JSR              AS_LRUD1               ; TIME TO PLOT COSINE COMPONENT
                 CLC
AS_L_DRAW1_3:    LDA              AS_HGR_E + 1           ; ADD SINE VALUE TO Y-VALUE
                 ADC              AS_HGR_DY              ; IF >= 1, THEN DRAW
                 STA              AS_HGR_E + 1           ; ONLY SAVE FRACTIONAL PART
                 BCC              AS_L_DRAW1_4           ; NO INTEGRAL PART
                 JSR              AS_LRUD2               ; TIME TO PLOT SINE COMPONENT
AS_L_DRAW1_4:     DEX                    ; LOOP ON SCALE FACTOR.
                 BNE              AS_L_DRAW1_2           ; STILL ON SAME SHAPE ITEM
                 LDA              AS_HGR_DX + 1          ; GET NEXT SHAPE ITEM
                 LSR                                     ; NEXT 3 BIT VECTOR
                 LSR
                 LSR
                 BNE              AS_L_DRAW1_1           ; MORE IN THIS SHAPE BYTE
                 INC              AS_HGR_SHAPE           ; GO TO NEXT SHAPE BYTE
                 BNE              AS_L_DRAW1_5
                 INC              AS_HGR_SHAPE + 1
AS_L_DRAW1_5:    LDA              (AS_HGR_SHAPE,X)       ; NEXT BYTE OF SHAPE DEFINITION
                 BNE              AS_L_DRAW1_1           ; PROCESS IF NOT ZERO
                 RTS                                     ; FINISHED
                                                         ; --------------------------------
                                                         ; XDRAW A SHAPE (SAME AS DRAW, EXCEPT TOGGLES SCREEN)

                                                         ; (Y,X) = SHAPE STARTING ADDRESS
                                                         ; (A)   = ROTATION (0-3F)
                                                         ; --------------------------------
                                                         ; APPLESOFT DOES NOT CALL XDRAW0
                                                         ; --------------------------------
AS_XDRAW0:       STX              AS_HGR_SHAPE           ; SAVE SHAPE ADDRESS
                 STY              AS_HGR_SHAPE + 1
                                                         ; --------------------------------
                                                         ; APPLESOFT ENTERS HERE
                                                         ; --------------------------------
AS_XDRAW1:        TAX                    ; SAVE ROTATION (0-$3F)
                 LSR                                     ; DIVIDE ROTATION BY 16 TO GET
                 LSR                                     ; QUADRANT (0=UP, 1=RT, 2=DWN, 3=LFT)
                 LSR
                 LSR
                 STA              AS_HGR_QUADRANT
                 TXA                                     ; USE LOW 4 BITS OF ROTATION TO INDEX
                 AND              #$0F                   ; THE TRIG TABLE
                 TAX
                 LDY              AS_COSINE_TABLE,X      ; SAVE COSINE IN HGR.DX
                 STY              AS_HGR_DX
                 EOR              #$F                    ; AND SINE IN DY
                 TAX
                 LDY              AS_COSINE_TABLE + 1,X
                 INY
                 STY              AS_HGR_DY
                 LDY              AS_HGR_HORIZ           ; INDEX FROM GBASL,H TO BYTE WE'RE IN
                 LDX              #0
                 STX              AS_HGR_COLLISIONS      ; CLEAR COLLISION COUNTER
                 LDA              (AS_HGR_SHAPE,X)       ; GET FIRST BYTE OF SHAPE DEFN
AS_L_XDRAW1_1:   STA              AS_HGR_DX + 1          ; KEEP SHAPE BYTE IN HGR.DX+1
                 LDX              #$80                   ; INITIAL VALUES FOR FRACTIONAL VECTORS
                 STX              AS_HGR_E               ; L_XDRAW1_5 IN COSINE COMPONENT
                 STX              AS_HGR_E + 1           ; L_XDRAW1_5 IN SINE COMPONENT
                 LDX              AS_HGR_SCALE           ; SCALE FACTOR
AS_L_XDRAW1_2:   LDA              AS_HGR_E               ; ADD COSINE VALUE TO X-VALUE
                 SEC                                     ; IF >= 1, THEN DRAW
                 ADC              AS_HGR_DX
                 STA              AS_HGR_E               ; ONLY SAVE FRACTIONAL PART
                 BCC              AS_L_XDRAW1_3          ; NO INTEGRAL PART
                 JSR              AS_LRUDX1              ; TIME TO PLOT COSINE COMPONENT
                 CLC
AS_L_XDRAW1_3:   LDA              AS_HGR_E + 1           ; ADD SINE VALUE TO Y-VALUE
                 ADC              AS_HGR_DY              ; IF >= 1, THEN DRAW
                 STA              AS_HGR_E + 1           ; ONLY SAVE FRACTIONAL PART
                 BCC              AS_L_XDRAW1_4          ; NO INTEGRAL PART
                 JSR              AS_LRUDX2              ; TIME TO PLOT SINE COMPONENT
AS_L_XDRAW1_4:    DEX                    ; LOOP ON SCALE FACTOR.
                 BNE              AS_L_XDRAW1_2          ; STILL ON SAME SHAPE ITEM
                 LDA              AS_HGR_DX + 1          ; GET NEXT SHAPE ITEM
                 LSR                                     ; NEXT 3 BIT VECTOR
                 LSR
                 LSR
                 BNE              AS_L_XDRAW1_1          ; MORE IN THIS SHAPE BYTE
                 INC              AS_HGR_SHAPE           ; GO TO NEXT SHAPE BYTE
                 BNE              AS_L_XDRAW1_5
                 INC              AS_HGR_SHAPE + 1
AS_L_XDRAW1_5:   LDA              (AS_HGR_SHAPE,X)       ; NEXT BYTE OF SHAPE DEFINITION
                 BNE              AS_L_XDRAW1_1          ; PROCESS IF NOT ZERO
                 RTS                                     ; FINISHED
                                                         ; --------------------------------
                                                         ; GET HI-RES PLOTTING COORDINATES (0-279,0-191) FROM
                                                         ; TXTPTR.  LEAVE REGISTERS SET UP FOR HPOSN:
                                                         ; (Y,X)=X-COORD
                                                         ; (A)  =Y-COORD
                                                         ; --------------------------------
AS_HFNS:         JSR              AS_FRMNUM              ; EVALUATE EXPRESSION, MUST BE NUMERIC
                 JSR              AS_GETADR              ; CONVERT TO 2-BYTE INTEGER IN LINNUM
                 LDY              MS_Z_LINNUM + 1        ; GET HORIZ COOR IN X,Y
                 LDX              MS_Z_LINNUM
                 CPY              #>280                  ; MAKE SURE IT IS < 280
                 BCC              AS_L_HFNS_1            ; IN RANGE
                 BNE              AS_GGERR
                 CPX              #<280
                 BCS              AS_GGERR
AS_L_HFNS_1:      TXA                    ; SAVE HORIZ COOR ON STACK
                 PHA
                 TYA
                 PHA
                 LDA              #"," & %01111111       ; REQUIRE A COMMA
                 JSR              AS_SYNCHR
                 JSR              AS_GETBYT              ; EVAL EXP TO SINGLE BYTE IN X-REG
                 CPX              #192                   ; CHECK FOR RANGE
                 BCS              AS_GGERR               ; TOO BIG
                 STX              MS_Z_FAC               ; SAVE Y-COORD
                 PLA                                     ; RETRIEVE HORIZONTAL COORDINATE
                 TAY
                 PLA
                 TAX
                 LDA              MS_Z_FAC               ; AND VERTICAL COORDINATE
                 RTS
                                                         ; --------------------------------
AS_GGERR:        JMP              AS_GOERR               ; ILLEGAL QUANTITY ERROR
                                                         ; --------------------------------
                                                         ; "HCOLOR=" STATEMENT
                                                         ; --------------------------------
AS_HCOLOR:       JSR              AS_GETBYT              ; EVAL EXP TO SINGLE BYTE IN X
                 CPX              #8                     ; VALUE MUST BE 0-7
                 BCS              AS_GGERR               ; TOO BIG
                 LDA              AS_COLORTBL,X          ; GET COLOR PATTERN
                 STA              AS_HGR_COLOR
AS_RTS_23:        RTS
                                                         ; --------------------------------

AS_COLORTBL            .BYTE %00000000
                    .BYTE %00101010
                    .BYTE %01010101
                    .BYTE %01111111
                    .BYTE %00000000 | %10000000
                    .BYTE %00101010 | %10000000
                    .BYTE %01010101 | %10000000
                    .BYTE %01111111 | %10000000

                                                         ; --------------------------------
                                                         ; "HPLOT" STATEMENT

                                                         ; HPLOT X,Y
                                                         ; HPLOT TO X,Y
                                                         ; HPLOT X1,Y1 TO X2,Y2
                                                         ; --------------------------------
AS_HPLOT:        CMP              #MS_TOTK               ; "PLOT TO" FORM?
                 BEQ              AS_L_HPLOT_2           ; YES, START FROM CURRENT LOCATION
                 JSR              AS_HFNS                ; NO, GET STARTING POINT OF LINE
                 JSR              AS_HPLOT0              ; PLOT THE POINT, AND SET UP FOR
                                                         ; DRAWING A LINE FROM THAT POINT
AS_L_HPLOT_1:    JSR              MS_Z_CHRGOT            ; CHARACTER AT END OF EXPRESSION
                 CMP              #MS_TOTK               ; IS A LINE SPECIFIED?
                 BNE              AS_RTS_23              ; NO, EXIT
AS_L_HPLOT_2:    JSR              AS_SYNCHR              ; YES. ADV. TXTPTR (WHY NOT CHRGET)
                 JSR              AS_HFNS                ; GET COORDINATES OF LINE END
                 STY              MS_Z_DSCTMP            ; SET UP FOR LINE
                 TAY
                 TXA
                 LDX              MS_Z_DSCTMP
                 JSR              AS_HGLIN               ; PLOT LINE
                 JMP              AS_L_HPLOT_1           ; LOOP TILL NO MORE "TO" PHRASES
                                                         ; --------------------------------
                                                         ; "ROT=" STATEMENT
                                                         ; --------------------------------
AS_ROT:          JSR              AS_GETBYT              ; EVAL EXP TO A BYTE IN X-REG
                 STX              AS_HGR_ROTATION
                 RTS
                                                         ; --------------------------------
                                                         ; "SCALE=" STATEMENT
                                                         ; --------------------------------
AS_SCALE:        JSR              AS_GETBYT              ; EVAL EXP TO A BYTE IN X-REG
                 STX              AS_HGR_SCALE
                 RTS
                                                         ; --------------------------------
                                                         ; SET UP FOR DRAW AND XDRAW
                                                         ; --------------------------------
AS_DRWPNT:       JSR              AS_GETBYT              ; GET SHAPE NUMBER IN X-REG
                 LDA              AS_HGR_SHAPE_PNTR      ; SEARCH FOR THAT SHAPE
                 STA              AS_HGR_SHAPE           ; SET UP PNTR TO BEGINNING OF TABLE
                 LDA              AS_HGR_SHAPE_PNTR + 1
                 STA              AS_HGR_SHAPE + 1
                 TXA
                 LDX              #0
                 CMP              (AS_HGR_SHAPE,X)       ; COMPARE TO # OF SHAPES IN TABLE
                 BEQ              AS_L_DRWPNT_1          ; LAST SHAPE IN TABLE
                 BCS              AS_GGERR               ; SHAPE # TOO LARGE
AS_L_DRWPNT_1:    ASL                    ; DOUBLE SHAPE# TO MAKE AN INDEX
                 BCC              AS_L_DRWPNT_2          ; ADD 256 IF SHAPE # > 127
                 INC              AS_HGR_SHAPE + 1
                 CLC
AS_L_DRWPNT_2:    TAY                    ; USE INDEX TO LOOK UP OFFSET FOR SHAPE
                 LDA              (AS_HGR_SHAPE),Y       ; IN OFFSET TABLE
                 ADC              AS_HGR_SHAPE
                 TAX
                 INY
                 LDA              (AS_HGR_SHAPE),Y
                 ADC              AS_HGR_SHAPE_PNTR + 1
                 STA              AS_HGR_SHAPE + 1       ; SAVE ADDRESS OF SHAPE
                 STX              AS_HGR_SHAPE
                 JSR              MS_Z_CHRGOT            ; IS THERE ANY "AT" PHRASE?
                 CMP              #AS_TOKENDB
                 BNE              AS_L_DRWPNT_3          ; NO, DRAW RIGHT WHERE WE ARE
                 JSR              AS_SYNCHR              ; SCAN OVER "AT"
                 JSR              AS_HFNS                ; GET X- AND Y-COORDS TO START DRAWING AT
                 JSR              AS_HPOSN               ; SET UP CURSOR THERE
AS_L_DRWPNT_3:   LDA              AS_HGR_ROTATION        ; ROTATION VALUE
                 RTS
                                                         ; --------------------------------
                                                         ; "DRAW" STATEMENT
                                                         ; --------------------------------
AS_DRAW:         JSR              AS_DRWPNT
                 JMP              AS_DRAW1
                                                         ; --------------------------------
                                                         ; "XDRAW" STATEMENT
                                                         ; --------------------------------
AS_XDRAW:        JSR              AS_DRWPNT
                 JMP              AS_XDRAW1
                                                         ; --------------------------------
                                                         ; "SHLOAD" STATEMENT

                                                         ; READS A SHAPE TABLE FROM CASSETTE TAPE
                                                         ; TO A POSITION JUST BELOW HIMEM.
                                                         ; HIMEM IS THEN MOVED TO JUST BELOW THE TABLE
                                                         ; --------------------------------
AS_SHLOAD:       LDA              #>MS_Z_LINNUM          ; SET UP TO READ TWO BYTES
                 STA              MON_A1H                ; INTO LINNUM,LINNUM+1
                 STA              MON_A2H
                 LDY              #MS_Z_LINNUM
                 STY              MON_A1L
                 INY                                     ; LINNUM+1
                 STY              MON_A2L
                 JSR              MON_READ               ; READ TAPE
                 CLC                                     ; SETUP TO READ (LINNUM) BYTES
                 LDA              MS_Z_MEMSIZ            ; ENDING AT HIMEM-1
                 TAX
                 DEX                                     ; FORMING HIMEM-1
                 STX              MON_A2L
                 SBC              MS_Z_LINNUM            ; FORMING HIMEM-(LINNUM)
                 PHA
                 LDA              MS_Z_MEMSIZ + 1
                 TAY
                 INX                                     ; SEE IF HIMEM LOW-BYTE WAS ZERO
                 BNE              AS_L_SHLOAD_1          ; NO
                 DEY                                     ; YES, HAVE TO DECREMENT HIGH BYTE
AS_L_SHLOAD_1:   STY              MON_A2H
                 SBC              MS_Z_LINNUM + 1
                 CMP              MS_Z_STREND + 1        ; RUNNING INTO VARIABLES?
                 BCC              AS_L_SHLOAD_2          ; YES, OUT OF MEMORY
                 BNE              AS_L_SHLOAD_3          ; NO, STILL ROOM
AS_L_SHLOAD_2:   JMP              MS_OMERR               ; MEM FULL ERR
AS_L_SHLOAD_3:   STA              MS_Z_MEMSIZ + 1
                 STA              MS_Z_FRETOP + 1        ; CLEAR STRING SPACE
                 STA              MON_A1H                ; (BUT NAMES ARE STILL IN VARTBL!)
                 STA              AS_HGR_SHAPE_PNTR + 1
                 PLA
                 STA              AS_HGR_SHAPE_PNTR
                 STA              MS_Z_MEMSIZ
                 STA              MS_Z_FRETOP
                 STA              MON_A1L
                 JSR              MON_RD2BIT             ; READ TO TAPE TRANSITIONS
                 LDA              #3                     ; SHORT DELAY FOR INTERMEDIATE HEADER
                 JMP              MON_READ2              ; READ SHAPES
                                                         ; --------------------------------
                                                         ; CALLED FROM STORE AND RECALL
                                                         ; --------------------------------
AS_TAPEPNT:
                 CLC
                 LDA              MS_Z_LOWTR
                 ADC              MS_Z_LINNUM
                 STA              MON_A2L
                 LDA              MS_Z_LOWTR + 1
                 ADC              MS_Z_LINNUM + 1
                 STA              MON_A2H
                 LDY              #4
                 LDA              (MS_Z_LOWTR),Y
                 JSR              AS_GETARY2
                 LDA              MS_Z_HIGHDS
                 STA              MON_A1L
                 LDA              MS_Z_HIGHDS + 1
                 STA              MON_A1H
                 RTS
                                                         ; --------------------------------
                                                         ; CALLED FROM STORE AND RECALL
                                                         ; --------------------------------
AS_GETARYPT:
                 LDA              #$40
                 STA              MS_Z_SUBFLG
                 JSR              AS_PTRGET
                 LDA              #0
                 STA              MS_Z_SUBFLG
                 JMP              AS_VARTIO
                                                         ; --------------------------------
                                                         ; "HTAB" STATEMENT

                                                         ; NOTE THAT IF WNDLEFT IS NOT 0, HTAB CAN PRINT
                                                         ; OUTSIDE THE SCREEN (EG., IN THE PROGRAM)
                                                         ; --------------------------------
AS_HTAB:         JSR              AS_GETBYT
                 DEX
                 TXA
AS_L_HTAB_1:     CMP              #40
                 BCC              AS_L_HTAB_2
                 SBC              #40
                 PHA
                 JSR              MS_CRDO
                 PLA
                 JMP              AS_L_HTAB_1
AS_L_HTAB_2:     STA              MON_CH
                 RTS
                                                         ; --------------------------------
                    .BYTE ("K"|%10000000)
.BYTE ("R"|%10000000)
.BYTE ("W"|%10000000)
                                                         ; UNKNOWN
; Source assembly code for the Apple ][ System Monitor

MON_LORESHEIGHT  =                24 * 2

;-----------------------------------------------------------------------

; LO-RES GRAPHICS

; Some low-resolution-graphics routines.

;-----------------------------------------------------------------------

MON_PLOT:         LSR                    ;Y-COORD/2
                 PHP                                     ;SAVE LSB IN CARRY
                 JSR              MON_GBASCALC           ;CALC BASE ADR IN GBASL,H
                 PLP                                     ;RESTORE LSB FROM CARRY
                 LDA              #%00001111             ;MASK $0F IF EVEN
                 BCC              MON_RTMASK
                 ADC              #%11100000             ;MASK $F0 IF ODD
MON_RTMASK:      STA              MON_MASK
MON_PLOT1:       LDA              (MON_GBASL),Y          ;DATA
                 EOR              MON_COLOR              ; EOR COLOR
                 AND              MON_MASK               ;  AND MASK
                 EOR              (MON_GBASL),Y          ;   EOR DATA
                 STA              (MON_GBASL),Y          ;    TO DATA
                 RTS

MON_HLINE:       JSR              MON_PLOT               ;PLOT SQUARE
MON_HLINE1:      CPY              MON_H2                 ;DONE?
                 BCS              MON_RTS1               ; YES, RETURN
                 INY                                     ; NO, INC INDEX (X-COORD)
                 JSR              MON_PLOT1              ;PLOT NEXT SQUARE
                 BCC              MON_HLINE1             ;ALWAYS TAKEN
MON_VLINEZ:      ADC              #1                     ;NEXT Y-COORD
MON_VLINE:        PHA                    ; SAVE ON STACK
                 JSR              MON_PLOT               ; PLOT SQUARE
                 PLA
                 CMP              MON_V2                 ;DONE?
                 BCC              MON_VLINEZ             ; NO, LOOP
MON_RTS1:         RTS

MON_CLRSCR:      LDY              #MON_LORESHEIGHT - 1   ;MAX Y, FULL SCRN CLR
                 BNE              MON_CLRSC2             ;ALWAYS TAKEN
MON_CLRTOP:      LDY              #40 - 1                ;MAX Y, TOP SCREEN CLR
MON_CLRSC2:      STY              MON_V2                 ;STORE AS BOTTOM COORD
                                                         ; FOR VLINE CALLS
                 LDY              #40 - 1                ;RIGHTMOST X-COORD (COLUMN)
MON_CLRSC3:      LDA              #0                     ;TOP COORD FOR VLINE CALLS
                 STA              MON_COLOR              ;CLEAR COLOR (BLACK)
                 JSR              MON_VLINE              ;DRAW VLINE
                 DEY                                     ;NEXT LEFTMOST X-COORD
                 BPL              MON_CLRSC3             ;LOOP UNTIL DONE
                 RTS

MON_GBASCALC:     PHA                    ;FOR INPUT 000DEFGH
                 LSR
                 AND              #%00000011
                 ORA              #%00000100             ;  GENERATE GBASH=000001FG
                 STA              MON_GBASH
                 PLA                                     ;  AND GBASL=HDEDE000
                 AND              #%00011000
                 BCC              MON_GBCALC
                 ADC              #$80 - 1
MON_GBCALC:      STA              MON_GBASL
                 ASL
                 ASL
                 ORA              MON_GBASL
                 STA              MON_GBASL
                 RTS

MON1_NXTCOL:     LDA              MON_COLOR              ;INCREMENT COLOR BY 3
                 CLC
                 ADC              #3
MON_SETCOL:      AND              #%00001111             ;SETS COLOR=17*A MOD 16
                 STA              MON_COLOR
                 ASL                                     ;BOTH HALF BYTES OF COLOR EQUAL
                 ASL
                 ASL
                 ASL
                 ORA              MON_COLOR
                 STA              MON_COLOR
                 RTS

MON_SCRN:         LSR                    ;READ SCREEN Y-COORD/2
                 PHP                                     ;SAVE LSB (CARRY)
                 JSR              MON_GBASCALC           ;CALC BASE ADDRESS
                 LDA              (MON_GBASL),Y          ;GET BYTE
                 PLP                                     ;RESTORE LSB FROM CARRY

MON_SCRN2:       BCC              MON_RTMSKZ             ;IF EVEN, USE LO H
                 LSR
                 LSR
                 LSR                                     ;SHIFT HIGH HALF BYTE DOWN
                 LSR
MON_RTMSKZ:      AND              #%00001111             ;MASK 4-BITS
                 RTS

;-----------------------------------------------------------------------

; DISASSEMBLER

; Handles disassembling 6502 instructions.

;-----------------------------------------------------------------------

MON_INSDS1:      LDX              $3A                    ;PRINT PCL,H
                 LDY              $3B
                 JSR              MON_PRYX2
                 JSR              MON_PRBLNK             ;FOLLOWED BY A BLANK
                 LDA              ($3A,X)                ;GET OP CODE
MON_INSDS2:       TAY
                 LSR                                     ;EVEN/ODD TEST
                 BCC              MON_IEVEN
                 ROR                                     ;BIT 1 TEST
                 BCS              MON_ERR                ;XXXXXX11 INVALID OP
                 CMP              #$A2
                 BEQ              MON_ERR                ;OPCODE $89 INVALID
                 AND              #$87                   ;MASK BITS
MON_IEVEN:        LSR                    ;LSB INTO CARRY FOR L/R TEST
                 TAX
                 LDA              MON_FMT1,X             ;GET FORMAT INDEX BYTE
                 JSR              MON_SCRN2              ;R/L H-BYTE ON CARRY
                 BNE              MON_GETFMT
MON_ERR:         LDY              #$80                   ;SUBSTITUTE $80 FOR INVALID OPS
                 LDA              #$00                   ;SET PRINT FORMAT INDEX TO 0
MON_GETFMT:       TAX
                 LDA              MON_FMT2,X             ;INDEX INTO PRINT FORMAT TABLE
                 STA              MON_MASK               ;SAVE FOR ADR FIELD FORMATTING
                 AND              #$03                   ;MASK FOR 2-BIT (LENGTH-1)
                 STA              $2F
                 TYA                                     ;OPCODE
                 AND              #$8F                   ;MASK FOR 1XXX1010 TEST
                 TAX                                     ; SAVE IT
                 TYA                                     ;OPCODE TO A AGAIN
                 LDY              #$03
                 CPX              #$8A
                 BEQ              MON_MNNDX3
MON_MNNDX1:       LSR
                 BCC              MON_MNNDX3             ;FORM INDEX INTO MNEMONIC TABLE
                 LSR
MON_MNNDX2:       LSR                    ;1) 1XXX1010->00101XXX
                 ORA              #$20                   ;2) XXXYYY01->00111XXX
                 DEY                                     ;3) XXXYYY10->00110XXX
                 BNE              MON_MNNDX2             ;4) XXXYY100->00100XXX
                 INY                                     ;5) XXXXX000->000XXXXX
MON_MNNDX3:       DEY
                 BNE              MON_MNNDX1
                 RTS

         .BYTE $FF,$FF,$FF

MON_INSTDSP:     JSR              MON_INSDS1             ;GEN FMT, LEN BYTES
                 PHA                                     ;SAVE MNEMONIC TABLE INDEX
MON_PRNTOP:      LDA              ($3A),Y
                 JSR              MON_PRBYTE
                 LDX              #1                     ;PRINT 2 BLANKS
MON_PRNTBL:      JSR              MON_PRBL2
                 CPY              $2F                    ;PRINT INST (1-3 BYTES)
                 INY                                     ;IN A 12 CHR FIELD
                 BCC              MON_PRNTOP
                 LDX              #3                     ;CHAR COUNT FOR MNEMONIC PRINT
                 CPY              #4
                 BCC              MON_PRNTBL
                 PLA                                     ;RECOVER MNEMONIC INDEX
                 TAY
                 LDA              MON_MNEML,Y
                 STA              MON_H2                 ;FETCH 3-CHAR MNEMONIC
                 LDA              MON_MNEMR,Y            ;  (PACKED IN 2-BYTES)
                 STA              MON_V2
MON_NXTCOL:      LDA              #0
                 LDY              #5
MON_PRMN2:       ASL              MON_V2                 ;SHIFT 5 BITS OF
                 ROL              MON_H2                 ;  CHARACTER INTO A
                 ROL                                     ;    (CLEARS CARRY)
                 DEY
                 BNE              MON_PRMN2
                 ADC              #"?" | %10000000       ;ADD "?" OFFSET
                 JSR              MON_COUT               ;OUTPUT A CHAR OF MNEM
                 DEX
                 BNE              MON_NXTCOL
                 JSR              MON_PRBLNK             ;OUTPUT 3 BLANKS
                 LDY              $2F
                 LDX              #6                     ;CNT FOR 6 FORMAT BITS
MON_PRADR1:      CPX              #3
                 BEQ              MON_PRADR5             ;IF X=3 THEN ADDR.
MON_PRADR2:      ASL              MON_MASK
                 BCC              MON_PRADR3
                 LDA              MON_CHAR1 - 1,X
                 JSR              MON_COUT
                 LDA              MON_CHAR2 - 1,X
                 BEQ              MON_PRADR3
                 JSR              MON_COUT
MON_PRADR3:       DEX
                 BNE              MON_PRADR1
                 RTS
MON_PRADR4:       DEY
                 BMI              MON_PRADR2
                 JSR              MON_PRBYTE
MON_PRADR5:      LDA              MON_MASK
                 CMP              #$E8                   ;HANDLE REL ADR MODE
                 LDA              ($3A),Y                ;SPECIAL (PRINT TARGET,
                 BCC              MON_PRADR4             ;  NOT OFFSET)
MON_RELADR:      JSR              MON_PCADJ3
                 TAX                                     ;PCL,PCH+OFFSET+1 TO A,Y
                 INX
                 BNE              MON_PRNTYX             ;+1 TO Y,X
                 INY

MON_PRNTYX:       TYA
MON_PRNTAX:      JSR              MON_PRBYTE             ;OUTPUT TARGET ADR
MON_PRNTX:        TXA                    ;  OF BRANCH AND RETURN
                 JMP              MON_PRBYTE

MON_PRBLNK:      LDX              #3                     ;BLANK COUNT
MON_PRBL2:       LDA              #" " | %10000000       ;LOAD A SPACE
MON_PRBL3:       JSR              MON_COUT               ;OUTPUT A BLANK
                 DEX
                 BNE              MON_PRBL2              ;LOOP UNTIL COUNT=0
                 RTS

MON_PCADJ:        SEC                    ;0=1-BYTE, 1=2-BYTE
MON_PCADJ2:      LDA              $2F                    ;  2=3-BYTE
MON_PCADJ3:      LDY              $3B
                 TAX                                     ;TEST DISPLACEMENT SIGN
                 BPL              MON_PCADJ4             ;  (FOR REL BRANCH)
                 DEY                                     ;EXTEND NEG BY DEC PCH
MON_PCADJ4:      ADC              $3A
                 BCC              MON_RTS2               ;PCL+LENGTH(OR DISPL)+1 TO A
                 INY                                     ;  CARRY INTO Y (PCH)
MON_RTS2:         RTS

                                                         ; * FMT1 BYTES:    XXXXXXY0 INSTRS
                                                         ; * IF Y=0         THEN LEFT HALF BYTE
                                                         ; * IF Y=1         THEN RIGHT HALF BYTE
                                                         ; *                   (X=INDEX)
MON_FMT1     .BYTE $04,$20,$54,$30,$0D
         .BYTE $80,$04,$90,$03,$22
         .BYTE $54,$33,$0D,$80,$04
         .BYTE $90,$04,$20,$54,$33
         .BYTE $0D,$80,$04,$90,$04
         .BYTE $20,$54,$3B,$0D,$80
         .BYTE $04,$90,$00,$22,$44
         .BYTE $33,$0D,$C8,$44,$00
         .BYTE $11,$22,$44,$33,$0D
         .BYTE $C8,$44,$A9,$01,$22
         .BYTE $44,$33,$0D,$80,$04
         .BYTE $90,$01,$22,$44,$33
         .BYTE $0D,$80,$04,$90
         .BYTE $26,$31,$87,$9A ;$ZZXXXY01 INSTR'S

MON_FMT2     .BYTE $00        ;ERR
         .BYTE $21        ;IMM
         .BYTE $81        ;Z-PAGE
         .BYTE $82        ;ABS
         .BYTE $00        ;IMPLIED
         .BYTE $00        ;ACCUMULATOR
         .BYTE $59        ;(ZPAG,X)
         .BYTE $4D        ;(ZPAG),Y
         .BYTE $91        ;ZPAG,X
         .BYTE $92        ;ABS,X
         .BYTE $86        ;ABS,Y
         .BYTE $4A        ;(ABS)
         .BYTE $85        ;ZPAG,Y
         .BYTE $9D        ;RELATIVE
MON_CHAR1:
         .BYTE (","|%10000000)
         .BYTE (")"|%10000000)
         .BYTE (","|%10000000)
         .BYTE ("#"|%10000000)
         .BYTE ("("|%10000000)
         .BYTE ("$"|%10000000)

MON_CHAR2    .BYTE ("Y"|%10000000)
         .BYTE 0
         .BYTE ("X"|%10000000)
.BYTE ("$"|%10000000)
.BYTE ("$"|%10000000)

         .BYTE 0

                                                         ; * MNEML IS OF FORM:
                                                         ; *  (A) XXXXX000
                                                         ; *  (B) XXXYY100
                                                         ; *  (C) 1XXX1010
                                                         ; *  (D) XXXYYY10
                                                         ; *  (E) XXXYYY01
                                                         ; *      (X=INDEX)
MON_MNEML    .BYTE $1C,$8A,$1C,$23,$5D,$8B
         .BYTE $1B,$A1,$9D,$8A,$1D,$23
         .BYTE $9D,$8B,$1D,$A1,$00,$29
         .BYTE $19,$AE,$69,$A8,$19,$23
         .BYTE $24,$53,$1B,$23,$24,$53
         .BYTE $19,$A1    ;(A) FORMAT ABOVE

         .BYTE $00,$1A,$5B,$5B,$A5,$69
         .BYTE $24,$24    ;(B) FORMAT

         .BYTE $AE,$AE,$A8,$AD,$29,$00
         .BYTE $7C,$00    ;(C) FORMAT

         .BYTE $15,$9C,$6D,$9C,$A5,$69
         .BYTE $29,$53    ;(D) FORMAT

         .BYTE $84,$13,$34,$11,$A5,$69
         .BYTE $23,$A0    ;(E) FORMAT

MON_MNEMR    .BYTE $D8,$62,$5A,$48,$26,$62
         .BYTE $94,$88,$54,$44,$C8,$54
         .BYTE $68,$44,$E8,$94,$00,$B4
         .BYTE $08,$84,$74,$B4,$28,$6E
         .BYTE $74,$F4,$CC,$4A,$72,$F2
         .BYTE $A4,$8A    ;(A) FORMAT

         .BYTE $00,$AA,$A2,$A2,$74,$74
         .BYTE $74,$72    ;(B) FORMAT

         .BYTE $44,$68,$B2,$32,$B2,$00
         .BYTE $22,$00    ;(C) FORMAT

         .BYTE $1A,$1A,$26,$26,$72,$72
         .BYTE $88,$C8    ;(D) FORMAT

         .BYTE $C4,$CA,$26,$48,$44,$44
         .BYTE $A2,$C8    ;(E) FORMAT

;-----------------------------------------------------------------------

; DEBUGGER

; Handles stepping, register display, IRQ, BRK.

;-----------------------------------------------------------------------

MON_IRQ:         STA              $45
                 PLA
                 PHA
                 ASL
                 ASL
                 ASL
                 BMI              MON_BREAK
                 JMP              ($03FE)

MON_BREAK:        PLP
                 JSR              MON_SAV1
                 PLA
                 STA              $3A
                 PLA
                 STA              $3B
                 JMP              ($03F0)
MON_OLDBRK:      JSR              MON_INSDS1
                 JSR              MON_RGDSP1
                 JMP              MON_MON

MON_RESET2:       CLD
                 JSR              MON_SETNORM
                 JSR              MON_INIT
                 JSR              MON_SETVID
                 JSR              MON_SETKBD
                 LDA              $C058
                 LDA              $C05A
                 LDA              $C05D
                 LDA              $C05F
                 LDA              $CFFF
                 BIT              $C010
                 CLD
                 JSR              MON_BELL
                 LDA              $03F3
                 EOR              #%10100101
                 CMP              $03F4
                 BNE              MON_PWRUP
                 LDA              $03F2
                 BNE              MON_NOFIX
                 LDA              #$E0
                 CMP              $03F3
                 BNE              MON_NOFIX
MON_FIXSEV:      LDY              #$03
                 STY              $03F2
                 JMP              $E000

MON_NOFIX:       JMP              ($03F2)
MON_PWRUP:       JSR              MON_APPLEII
                 LDX              #$05
MON_SETPLP:      LDA              MON_PWRCON - 1,X
                 STA              $03EF,X
                 DEX
                 BNE              MON_SETPLP
                 LDA              #$C8
                 STX              $00
                 STA              $01
MON_SLOOP:       LDY              #$07
                 DEC              $01
                 LDA              $01
                 CMP              #$C0
                 BEQ              MON_FIXSEV
                 STA              $07F8
MON_NXTBYT:      LDA              ($00),Y
                 CMP              MON_DISKID - 1,Y
                 BNE              MON_SLOOP
                 DEY
                 DEY
                 BPL              MON_NXTBYT
                 JMP              ($0000)
                 NOP
                 NOP

MON_REGDSP:      JSR              MON_CROUT              ;DISPLAY USER REG
MON_RGDSP1:      LDA              #<$45                  ;  CONTENTS WITH
                 STA              $40                    ;  LABELS
                 LDA              #>$45
                 STA              $41
                 LDX              #$FB
MON_RDSP1:       LDA              #" " | %10000000
                 JSR              MON_COUT
                 LDA              MON_RTBL - $FB,X
                                                         ;LDA   MON_RTBL+$FF05,X

                 JSR              MON_COUT
                 LDA              #"=" | %10000000
                 JSR              MON_COUT
                 LDA              $45 + 5,X
                 JSR              MON_PRBYTE
                 INX
                 BMI              MON_RDSP1
                 RTS

MON_PWRCON:      .word            MON_OLDBRK
                 .word            AS_BASIC
    .BYTE $45
MON_DISKID    .BYTE $20,$FF,$00,$FF,$03,$FF
    .BYTE $3C
MON_TITLE         .BYTE ("A"|%10000000)
.BYTE ("P"|%10000000)
.BYTE ("P"|%10000000)
.BYTE ("L"|%10000000)
.BYTE ("E"|%10000000)
.BYTE (" "|%10000000)
.BYTE ("]"|%10000000)
.BYTE ("["|%10000000)
MON_XLTBL:
         .BYTE ("D"|%10000000)
.BYTE ("B"|%10000000)
.BYTE ("A"|%10000000)

         .BYTE $FF
         .BYTE ("C"|%10000000)

         .BYTE $FF,$FF,$FF

MON_RTBL     .BYTE ("A"|%10000000)
.BYTE ("X"|%10000000)
.BYTE ("Y"|%10000000)
.BYTE ("P"|%10000000)
.BYTE ("S"|%10000000)

MON_PADDL0       =                $C064
MON_PTRIG        =                $C070

;-----------------------------------------------------------------------

; PADDLES

; Handles the paddles.

;-----------------------------------------------------------------------

MON_PREAD:       LDA              MON_PTRIG              ;TRIGGER PADDLES
                 LDY              #$00                   ;INIT COUNT
                 NOP                                     ;COMPENSATE FOR 1ST COUNT
                 NOP
MON_PREAD2:      LDA              MON_PADDL0,X           ;COUNT Y-REG EVERY
                 BPL              MON_RTS2D              ;  12 USEC
                 INY
                 BNE              MON_PREAD2             ;  EXIT AT 255 MAX
                 DEY
MON_RTS2D:        RTS

;-----------------------------------------------------------------------

; INITIALIZE DISPLAY

; Handles initializing the display.

;-----------------------------------------------------------------------

MON_TXTCLR       =                $C050
MON_TXTSET       =                $C051
MON_MIXSET       =                $C053
MON_LOWSCR       =                $C054
MON_LORES        =                $C056

MON_TEXTBOTTOMLINES =                4

MON_INIT:        LDA              #0                     ;CLR STATUS FOR DEBUG
                 STA              $48                    ;  SOFTWARE
                 LDA              MON_LORES
                 LDA              MON_LOWSCR             ;INIT VIDEO MODE

MON_SETTXT:      LDA              MON_TXTSET             ;SET FOR TEXT MODE
                 LDA              #0                     ;  FULL SCREEN WINDOW
                 BEQ              MON_SETWND

MON_SETGR:       LDA              MON_TXTCLR             ;SET FOR GRAPHICS MODE
                 LDA              MON_MIXSET             ;  LOWER 4 LINES AS
                 JSR              MON_CLRTOP             ;  TEXT WINDOW
                 LDA              #24 - MON_TEXTBOTTOMLINES

MON_SETWND:      STA              $22                    ;SET FOR 40 COL WINDOW
                 LDA              #0                     ;  TOP IN A-REG,
                 STA              $20                    ;  BTTM AT LINE 24
                 LDA              #40
                 STA              $21
                 LDA              #24
                 STA              $23                    ;  VTAB TO ROW 23
                 LDA              #24 - 1
MON_TABV:        STA              $25                    ;VTABS TO ROW IN A-REG
                 JMP              MON_VTAB

MON_APPLEII:     JSR              MON_HOME
                 LDY              #$08
MON_STITLE:      LDA              MON_TITLE - 1,Y
                 STA              $040E,Y
                 DEY
                 BNE              MON_STITLE
                 RTS
                 LDA              $03F3
                 EOR              #$A5
                 STA              $03F4
                 RTS
MON_VIDWAIT:     CMP              #$8D
                 BNE              MON_NOWAIT
                 LDY              $C000
                 BPL              MON_NOWAIT
                 CPY              #$93
                 BNE              MON_NOWAIT
                 BIT              $C010
MON_KBDWAIT:     LDY              $C000
                 BPL              MON_KBDWAIT
                 CPY              #$83
                 BEQ              MON_NOWAIT
                 BIT              $C010
MON_NOWAIT:      JMP              MON_VIDOUT
MON_ESCOLD:       SEC
                 JMP              MON_ESC1
MON_ESCNOW:       TAY
                 LDA              MON_XLTBL - $C9,Y      ; TODO
                 JSR              MON_ESCOLD
                 JSR              MS_CQINCH
MON_ESCNEW:      CMP              #$CE
                 BCS              MON_ESCOLD
                 CMP              #$C9
                 BCC              MON_ESCOLD
                 CMP              #$CC
                 BEQ              MON_ESCOLD
                 BNE              MON_ESCNOW
                 NOP
                 NOP
                 NOP
                 NOP
                 NOP
                 NOP
                 NOP
                 NOP
                 NOP
                 NOP
                 NOP
                 NOP
                 NOP
                 NOP

MON_ASCBEL       =                $07 | %10000000
MON_ASCBS        =                $08 | %10000000

;-----------------------------------------------------------------------

; DISPLAY AND READ KEYS

; Handles reading keypresses, escape, displaying characters, scrolling,
; clearing, etc. (Also includes cassette tape handler.)

;-----------------------------------------------------------------------

MON_SPKR         =                $C030

MON_BASCALC:      PHA                    ;CALC BASE ADR IN BASL,H
                 LSR                                     ;  FOR GIVEN LINE NO
                 AND              #%00000011             ;  0<=LINE NO.<=$17
                 ORA              #%00000100             ;ARG=000ABCDE, GENERATE
                 STA              $29                    ;  BASH=000001CD
                 PLA                                     ;  AND
                 AND              #%00011000             ;  BASL=EABAB000
                 BCC              MON_BSCLC2
                 ADC              #$80 - 1
MON_BSCLC2:      STA              $28
                 ASL
                 ASL
                 ORA              $28
                 STA              $28
                 RTS

MON_BELL1:       CMP              #MON_ASCBEL            ;BELL CHAR? (CNTRL-G)
                 BNE              MON_RTS2B              ;  NO, RETURN
                 LDA              #$40                   ;DELAY .01 SECONDS
                 JSR              MON_WAIT
                 LDY              #$C0
MON_BELL2:       LDA              #$0C                   ;TOGGLE SPEAKER AT
                 JSR              MON_WAIT               ;  1 KHZ FOR .1 SEC.
                 LDA              MON_SPKR
                 DEY
                 BNE              MON_BELL2
MON_RTS2B:        RTS

MON_STOADV:      LDY              $24                    ;CURSOR H INDEX TO Y-REG
                 STA              ($28),Y                ;STORE CHAR IN LINE
MON_ADVANCE:     INC              $24                    ;INCREMENT CURSOR H INDEX
                 LDA              $24                    ;  (MOVE RIGHT)
                 CMP              $21                    ;BEYOND WINDOW WIDTH?
                 BCS              MON_CR                 ;  YES CR TO NEXT LINE
MON_RTS3:         RTS                    ;  NO,RETURN

MON_VIDOUT:      CMP              #$A0                   ;CONTROL CHAR?
                 BCS              MON_STOADV             ;  NO,OUTPUT IT.

                 TAY                                     ;INVERSE VIDEO?
                 BPL              MON_STOADV             ;  YES, OUTPUT IT.

                 CMP              #$8D                   ;CR?
                 BEQ              MON_CR                 ;  YES.
                 CMP              #$8A                   ;LINE FEED?
                 BEQ              MON_LF                 ;  IF SO, DO IT.
                 CMP              #MON_ASCBS             ;BACK SPACE? (CNTRL-H)
                 BNE              MON_BELL1              ;  NO, CHECK FOR BELL.

MON_BS:          DEC              $24                    ;DECREMENT CURSOR H INDEX
                 BPL              MON_RTS3               ;IF POS, OK. ELSE MOVE UP
                 LDA              $21                    ;SET CH TO WNDWDTH-1
                 STA              $24
                 DEC              $24                    ;(RIGHTMOST SCREEN POS)
MON_UP:          LDA              $22                    ;CURSOR V INDEX
                 CMP              $25
                 BCS              MON_RTS4               ;IF TOP LINE THEN RETURN
                 DEC              $25                    ;DEC CURSOR V-INDEX

MON_VTAB:        LDA              $25                    ;GET CURSOR V-INDEX
MON_VTABZ:       JSR              MON_BASCALC            ;GENERATE BASE ADR
                 ADC              $20                    ;ADD WINDOW LEFT INDEX
                 STA              $28                    ;TO BASL
MON_RTS4:         RTS

MON_ESC1:        EOR              #$C0                   ;ESC?
                 BEQ              MON_HOME               ;  IF SO, DO HOME AND CLEAR
                 ADC              #$FD                   ;ESC-A OR B CHECK
                 BCC              MON_ADVANCE            ;  A, ADVANCE
                 BEQ              MON_BS                 ;  B, BACKSPACE
                 ADC              #$FD                   ;ESC-C OR D CHECK
                 BCC              MON_LF                 ;  C, DOWN
                 BEQ              MON_UP                 ;  D, GO UP
                 ADC              #$FD                   ;ESC-E OR F CHECK
                 BCC              MON_CLREOL             ;  E, CLEAR TO END OF LINE
                 BNE              MON_RTS4               ;  NOT F, RETURN
                                                         ;  F, CLEAR TO END OF PAGE
MON_CLREOP:      LDY              $24                    ;CURSOR H TO Y INDEX
                 LDA              $25                    ;CURSOR V TO A-REGISTER
MON_CLEOP1:       PHA                    ;SAVE CURRENT LINE ON STK
                 JSR              MON_VTABZ              ;CALC BASE ADDRESS
                 JSR              MON_CLEOLZ             ;CLEAR TO EOL, SET CARRY
                 LDY              #0                     ;CLEAR FROM H INDEX=0 FOR REST
                 PLA                                     ;INCREMENT CURRENT LINE
                 ADC              #0                     ;(CARRY IS SET)
                 CMP              $23                    ;DONE TO BOTTOM OF WINDOW?
                 BCC              MON_CLEOP1             ;  NO, KEEP CLEARING LINES
                 BCS              MON_VTAB               ;  YES, TAB TO CURRENT LINE

MON_HOME:        LDA              $22                    ;INIT CURSOR V
                 STA              $25                    ;  AND H-INDICES
                 LDY              #0
                 STY              $24                    ;THEN CLEAR TO END OF PAGE
                 BEQ              MON_CLEOP1

MON_CR:          LDA              #0                     ;CURSOR TO LEFT OF INDEX
                 STA              $24                    ;(RET CURSOR H=0)
MON_LF:          INC              $25                    ;INCR CURSOR V(DOWN 1 LINE)
                 LDA              $25
                 CMP              $23                    ;OFF SCREEN?
                 BCC              MON_VTABZ              ;  NO, SET BASE ADDR
                 DEC              $25                    ;DECR CURSOR V (BACK TO BOTTOM)

MON_SCROLL:      LDA              $22                    ;START AT TOP OF SCRL WNDW
                 PHA
                 JSR              MON_VTABZ              ;GENERATE BASE ADR
MON_SCRL1:       LDA              $28                    ;COPY BASL,H
                 STA              $2A                    ;  TO BAS2L,H
                 LDA              $29
                 STA              $2B
                 LDY              $21                    ;INIT Y TO RIGHTMOST INDEX
                 DEY                                     ;  OF SCROLLING WINDOW
                 PLA
                 ADC              #1                     ;INCR LINE NUMBER
                 CMP              $23                    ;DONE?
                 BCS              MON_SCRL3              ;  YES, FINISH
                 PHA
                 JSR              MON_VTABZ              ;FORM BASL,H (BASE ADDR)
MON_SCRL2:       LDA              ($28),Y                ;MOVE A CHR UP ON LINE
                 STA              ($2A),Y
                 DEY                                     ;NEXT CHAR OF LINE
                 BPL              MON_SCRL2
                 BMI              MON_SCRL1              ;NEXT LINE (ALWAYS TAKEN)

MON_SCRL3:       LDY              #0                     ;CLEAR BOTTOM LINE
                 JSR              MON_CLEOLZ             ;GET BASE ADDR FOR BOTTOM LINE
                 BCS              MON_VTAB               ;CARRY IS SET
MON_CLREOL:      LDY              $24                    ;CURSOR H INDEX
MON_CLEOLZ:      LDA              #" " | %10000000
MON_CLEOL2:      STA              ($28),Y                ;STORE BLANKS FROM 'HERE'
                 INY                                     ;  TO END OF LINES (WNDWDTH)
                 CPY              $21
                 BCC              MON_CLEOL2
                 RTS

MON_WAIT:         SEC
MON_WAIT2:        PHA
MON_WAIT3:       SBC              #1
                 BNE              MON_WAIT3              ;1.0204 USEC
                 PLA                                     ;(13+27/2*A+5/2*A*A)
                 SBC              #1
                 BNE              MON_WAIT2
                 RTS

MON_NXTA4:       INC              $42                    ;INCR 2-BYTE A4
                 BNE              MON_NXTA1              ;  AND A1
                 INC              $43
MON_NXTA1:       LDA              $3C                    ;INCR 2-BYTE A1.
                 CMP              $3E
                 LDA              $3D                    ;  AND COMPARE TO A2
                 SBC              $3F
                 INC              $3C                    ;  (CARRY SET IF >=)
                 BNE              MON_RTS4B
                 INC              $3D
MON_RTS4B:        RTS

MON_TAPEOUT      =                $C020
MON_TAPEIN       =                $C060

MON_HEADR:       LDY              #$4B                   ;WRITE A*256 'LONG 1'
                 JSR              MON_ZERDLY             ;  HALF CYCLES
                 BNE              MON_HEADR              ;  (650 USEC EACH)
                 ADC              #$FE
                 BCS              MON_HEADR              ;THEN A 'SHORT 0'
                 LDY              #$21                   ;  (400 USEC)
MON_WRBIT:       JSR              MON_ZERDLY             ;WRITE TWO HALF CYCLES
                 INY                                     ;  OF 250 USEC ('0')
                 INY                                     ;  OR 500 USEC ('0')
MON_ZERDLY:       DEY
                 BNE              MON_ZERDLY
                 BCC              MON_WRTAPE             ;Y IS COUNT FOR
                 LDY              #$32                   ;  TIMING LOOP
MON_ONEDLY:       DEY
                 BNE              MON_ONEDLY
MON_WRTAPE:      LDY              MON_TAPEOUT
                 LDY              #$2C
                 DEX
                 RTS

MON_RDBYTE:      LDX              #$08                   ;8 BITS TO READ
MON_RDBYT2:       PHA                    ;READ TWO TRANSITIONS
                 JSR              MON_RD2BIT             ;  (FIND EDGE)
                 PLA
                 ROL                                     ;NEXT BIT
                 LDY              #$3A                   ;COUNT FOR SAMPLES
                 DEX
                 BNE              MON_RDBYT2
                 RTS

MON_RD2BIT:      JSR              MON_RDBIT
MON_RDBIT:        DEY                    ;DECR Y UNTIL
                 LDA              MON_TAPEIN             ; TAPE TRANSITION
                 EOR              $2F
                 BPL              MON_RDBIT
                 EOR              $2F
                 STA              $2F
                 CPY              #$80                   ;SET CARRY ON Y
                 RTS

MON_KBD          =                $C000
MON_KBDSTRB      =                $C010

MS_CQINCH:       LDY              $24
                 LDA              ($28),Y                ;SET SCREEN TO FLASH
                 PHA
                 AND              #$3F
                 ORA              #$40
                 STA              ($28),Y
                 PLA

                 JMP              ($38)                  ;GO TO USER KEY-IN
MON_KEYIN:       INC              $4E
                 BNE              MON_KEYIN2             ;INCR RND NUMBER
                 INC              $4F
MON_KEYIN2:      BIT              MON_KBD                ;KEY DOWN?
                 BPL              MON_KEYIN              ;  LOOP
                 STA              ($28),Y                ;REPLACE FLASHING SCREEN
                 LDA              MON_KBD                ;GET KEYCODE
                 BIT              MON_KBDSTRB            ;CLR KEY STROBE
                 RTS

MON_ESC:         JSR              MS_CQINCH              ;GET KEYCODE

                 JSR              MON_ESCNEW

MON_RDCHAR:      JSR              MS_CQINCH              ;READ KEY
                 CMP              #$9B                   ;ESC?
                 BEQ              MON_ESC                ;  YES, DON'T RETURN
                 RTS

MON_NOTCR:       LDA              $32
                 PHA
                 LDA              #$FF
                 STA              $32                    ;ECHO USER LINE
                 LDA              $0200,X                ;  NON INVERSE
                 JSR              MON_COUT
                 PLA
                 STA              $32

                 LDA              $0200,X
                 CMP              #$88                   ;CHECK FOR EDIT KEYS
                 BEQ              MON_BCKSPC             ;  BS, CTRL-X
                 CMP              #$98
                 BEQ              MON_CANCEL
                 CPX              #$F8                   ;MARGIN?
                 BCC              MON_NOTCR1
                 JSR              MON_BELL               ;  YES, SOUND BELL
MON_NOTCR1:       INX                    ;ADVANCE INPUT INDEX
                 BNE              MON_NXTCHAR

MON_CANCEL:      LDA              #"\\" | %10000000      ;BACKSLASH AFTER CANCELLED LINE
                 JSR              MON_COUT
MON_GETLNZ:      JSR              MON_CROUT              ;OUTPUT CR

MON_GETLN:       LDA              $33
                 JSR              MON_COUT               ;OUTPUT PROMPT CHAR
                 LDX              #$01                   ;INIT INPUT INDEX
MON_BCKSPC:       TXA                    ;  WILL BACKSPACE TO 0
                 BEQ              MON_GETLNZ
                 DEX

MON_NXTCHAR:     JSR              MON_RDCHAR
MON_NXTCHAR1:    CMP              #$95                   ;USE SCREEN CHAR
                 BNE              MON_CAPTST             ;  FOR CTRL-U
                 LDA              ($28),Y
MON_CAPTST:      CMP              #$E0
                 BCC              MON_ADDINP             ;CONVERT TO CAPS
                 AND              #$DF
MON_ADDINP:      STA              $0200,X                ;ADD TO INPUT BUF
                 CMP              #$8D
                 BNE              MON_NOTCR
                 JSR              MON_CLREOL             ;CLR TO EOL IF CR

;-----------------------------------------------------------------------

; MONITOR COMMANDS

; Handles monitor commands, such as L (list) and G (go).

;-----------------------------------------------------------------------

MON_IOADR        =                $C000

                                                         ; ASCII
MON_CTRL_B       =                $02 | %10000000
MON_CTRL_C       =                $03 | %10000000
MON_CTRL_E       =                $05 | %10000000
MON_CTRL_K       =                $0B | %10000000
MON_CTRL_P       =                $10 | %10000000
MON_CTRL_Y       =                $19 | %10000000

MON_CROUT:       LDA              #$8D
                 BNE              MON_COUT
MON_PRA1:        LDY              $3D                    ;PRINT CR,A1 IN HEX
                 LDX              $3C
MON_PRYX2:       JSR              MON_CROUT
                 JSR              MON_PRNTYX
                 LDY              #$00
                 LDA              #"-" | %10000000       ;PRINT '-'
                 JMP              MON_COUT

MON_XAM8:        LDA              $3C
                 ORA              #%00000111             ;SET TO FINISH AT
                 STA              $3E                    ;  MOD 8=7
                 LDA              $3D
                 STA              $3F
MON_MODSCHK:     LDA              $3C
                 AND              #%00000111
                 BNE              MON_DATAOUT
MON_XAM:         JSR              MON_PRA1
MON_DATAOUT:     LDA              #" " | %10000000
                 JSR              MON_COUT               ;OUTPUT BLANK
                 LDA              ($3C),Y
                 JSR              MON_PRBYTE             ;OUTPUT BYTE IN HEX
                 JSR              MON_NXTA1
                 BCC              MON_MODSCHK            ;CHECK IF TIME TO,
MON_RTS4C:        RTS                    ;  PRINT ADDR

MON_XAMPM:        LSR                    ;DETERMINE IF MON
                 BCC              MON_XAM                ;  MODE IS XAM
                 LSR                                     ;  ADD, OR SUB
                 LSR
                 LDA              $3E
                 BCC              MON_ADD
                 EOR              #$FF                   ;SUB: FORM 2S COMPLEMENT
MON_ADD:         ADC              $3C
                 PHA
                 LDA              #"=" | %10000000
                 JSR              MON_COUT               ;PRINT =, THEN RESULT
                 PLA

MON_PRBYTE:       PHA                    ;PRINT BYTE AS 2 HEX
                 LSR                                     ;  DIGITS, DESTROYS A-REG
                 LSR
                 LSR
                 LSR
                 JSR              MON_PRHEXZ
                 PLA
MON_PRHEX:       AND              #%00001111             ;PRINT HEX DIG IN A-REG
MON_PRHEXZ:      ORA              #"0" | %10000000       ;  LSB'S
                 CMP              #("9" | %10000000) + 1
                 BCC              MON_COUT
                 ADC              #$06

MON_COUT:        JMP              ($36)                  ;VECTOR TO USER OUTPUT ROUTINE
MON_COUT1:       CMP              #" " | %10000000
                 BCC              MON_COUTZ              ;DONT OUTPUT CTRLS INVERSE
                 AND              $32                    ;MASK WITH INVERSE FLAG
MON_COUTZ:       STY              $35                    ;SAV Y-REG
                 PHA                                     ;SAV A-REG

                 JSR              MON_VIDWAIT

                 PLA                                     ;RESTORE A-REG
                 LDY              $35                    ;  AND Y-REG
                 RTS                                     ;  THEN RETURN

MON_BL1:         DEC              $34
                 BEQ              MON_XAM8

MON_BLANK:        DEX                    ;BLANK TO MON
                 BNE              MON_SETMDZ             ;AFTER BLANK

                 CMP              #$BA                   ;DATA STORE MODE?
                 BNE              MON_XAMPM              ;  NO, XAM, ADD, OR SUB
MON_STOR:        STA              $31                    ;KEEP IN STORE MODE
                 LDA              $3E
                 STA              ($40),Y                ;STORE AS LOW BYTE AS (A3)
                 INC              $40
                 BNE              MON_RTS5               ;INCR A3, RETURN
                 INC              $41
MON_RTS5:         RTS

MON_SETMODE:     LDY              $34                    ;SAVE CONVERTED :, +,
                 LDA              $0200 - 1,Y            ;  -, . AS MODE.
MON_SETMDZ:      STA              $31
                 RTS

MON_LT:          LDX              #$01
MON_LT2:         LDA              $3E,X                  ;COPY A2 (2 BYTES) TO
                 STA              $42,X                  ;  A4 AND A5
                 STA              $44,X
                 DEX
                 BPL              MON_LT2
                 RTS

MON_MOVE:        LDA              ($3C),Y                ;MOVE (A1 TO A2) TO
                 STA              ($42),Y                ;  (A4)
                 JSR              MON_NXTA4
                 BCC              MON_MOVE
                 RTS

MON_VFY:         LDA              ($3C),Y                ;VERIFY (A1 TO A2) WITH
                 CMP              ($42),Y                ;  (A4)
                 BEQ              MON_VFYOK
                 JSR              MON_PRA1
                 LDA              ($3C),Y
                 JSR              MON_PRBYTE
                 LDA              #" " | %10000000
                 JSR              MON_COUT
                 LDA              #"(" | %10000000
                 JSR              MON_COUT
                 LDA              ($42),Y
                 JSR              MON_PRBYTE
                 LDA              #")" | %10000000
                 JSR              MON_COUT
MON_VFYOK:       JSR              MON_NXTA4
                 BCC              MON_VFY
                 RTS

MON_LIST1:       JSR              MON_A1PC               ;MOVE A1 (2 BYTES) TO
                 LDA              #24 - 4                ;  PC IF SPECD AND
MON_LIST2:        PHA                    ;  DISEMBLE 20 INSTRS
                 JSR              MON_INSTDSP
                 JSR              MON_PCADJ              ;ADJUST PC EACH INSTR
                 STA              $3A
                 STY              $3B
                 PLA
                 SEC
                 SBC              #1                     ;NEXT OF 20 INSTRS
                 BNE              MON_LIST2
                 RTS

MON_A1PC:         TXA                    ;IF USER SPECD ADR
                 BEQ              MON_A1PCRTS            ;  COPY FROM A1 TO PC
MON_A1PCLP:      LDA              $3C,X
                 STA              $3A,X
                 DEX
                 BPL              MON_A1PCLP
MON_A1PCRTS:      RTS

MON_SETINV:      LDY              #$3F                   ;SET FOR INVERSE VID
                 BNE              MON_SETIFLG            ; VIA COUT1
MON_SETNORM:     LDY              #$FF                   ;SET FOR NORMAL VID
MON_SETIFLG:     STY              $32
                 RTS

MON_SETKBD:      LDA              #$00                   ;SIMULATE PORT #0 INPUT (IN#0)
MON_INPORT:      STA              $3E                    ;  SPECIFIED (KEYIN ROUTINE)
MON_INPRT:       LDX              #$38
                 LDY              #<MON_KEYIN
                 BNE              MON_IOPRT
MON_SETVID:      LDA              #$00                   ;SIMULATE PORT #0 OUTPUT (PR#0)
MON_OUTPORT:     STA              $3E                    ;  SPECIFIED (COUT1 ROUTINE)
MON_OUTPRT:      LDX              #$36
                 LDY              #<MON_COUT1
MON_IOPRT:       LDA              $3E                    ;SET RAM IN/OUT VECTORS
                 AND              #%00001111
                 BEQ              MON_IOPRT1
                 ORA              #>MON_IOADR
                 LDY              #$00
                 BEQ              MON_IOPRT2
MON_IOPRT1:      LDA              #>MON_COUT1
MON_IOPRT2:      STY              $00,X
                 STA              $01,X
                 RTS

                 NOP
                 NOP

MON_XBASIC:      JMP              $E000                  ;TO BASIC WITH SCRATCH

MON_BASCONT:     JMP              $E003                  ;CONTINUE BASIC

MON_GO:          JSR              MON_A1PC               ;ADR TO PC IF SPECD
                 JSR              MON_RESTORE            ;RESTORE META REGS
                 JMP              ($3A)                  ;GO TO USER SUBR

MON_REGZ:        JMP              MON_REGDSP             ;TO REG DISPLAY

MON_TRACE:

                 RTS
                 NOP
                 RTS
MON_STEPZ:        NOP
                 NOP
                 NOP
                 NOP
                 NOP

MON_USR:         JMP              $03F8                  ;TO USR SUBR AT USRADR

MON_WRITE:       LDA              #$40
                 JSR              MON_HEADR              ;WRITE 10-SEC HEADER
                 LDY              #$27
MON_WR1:         LDX              #$00
                 EOR              ($3C,X)
                 PHA
                 LDA              ($3C,X)
                 JSR              MON_WRBYTE
                 JSR              MON_NXTA1
                 LDY              #$1D
                 PLA
                 BCC              MON_WR1
                 LDY              #$22
                 JSR              MON_WRBYTE
                 BEQ              MON_BELL
MON_WRBYTE:      LDX              #$10
MON_WRBYT2:       ASL
                 JSR              MON_WRBIT
                 BNE              MON_WRBYT2
                 RTS

MON_CRMON:       JSR              MON_BL1                ;HANDLE A CR AS BLANK
                 PLA                                     ;  THEN POP STACK
                 PLA                                     ;  AND RTN TO MON
                 BNE              MON_MONZ

MON_READ:        JSR              MON_RD2BIT             ;FIND TAPEIN EDGE
                 LDA              #$16
MON_READ2:       JSR              MON_HEADR              ;DELAY 3.5 SECONDS
                 STA              MON_MASK               ;INIT CHKSUM=$FF
                 JSR              MON_RD2BIT             ;FIND TAPEIN EDGE
MON_RD2:         LDY              #$24                   ;LOOK FOR SYNC BIT
                 JSR              MON_RDBIT              ;  (SHORT 0)
                 BCS              MON_RD2                ;  LOOP UNTIL FOUND
                 JSR              MON_RDBIT              ;SKIP SECOND SYNC H-CYCLE
                 LDY              #$3B                   ;INDEX FOR 0/1 TEST
MON_RD3:         JSR              MON_RDBYTE             ;READ A BYTE
                 STA              ($3C,X)                ;STORE AT (A1)
                 EOR              MON_MASK
                 STA              MON_MASK               ;UPDATE RUNNING CHKSUM
                 JSR              MON_NXTA1              ;INC A1, COMPARE TO A2
                 LDY              #$35                   ;COMPENSATE 0/1 INDEX
                 BCC              MON_RD3                ;LOOP UNTIL DONE
                 JSR              MON_RDBYTE             ;READ CHKSUM BYTE
                 CMP              MON_MASK
                 BEQ              MON_BELL               ;GOOD, SOUND BELL AND RETURN
MON_PRERR:       LDA              #"E" | %10000000
                 JSR              MON_COUT               ;PRINT "ERR", THEN BELL
                 LDA              #"R" | %10000000
                 JSR              MON_COUT
                 JSR              MON_COUT

MON_BELL:        LDA              #$87                   ;OUTPUT BELL AND RETURN
                 JMP              MON_COUT

MON_RESTORE:     LDA              $48                    ;RESTORE 6502 REG CONTENTS
                 PHA                                     ;  USED BY DEBUG SOFTWARE
                 LDA              $45
MON_RESTR1:      LDX              $46
                 LDY              $47
                 PLP
                 RTS
MON_SAVE:        STA              $45                    ;SAVE 6502 REG CONTENTS
MON_SAV1:        STX              $46
                 STY              $47
                 PHP
                 PLA
                 STA              $48
                 TSX
                 STX              $49
                 CLD
                 RTS

MON_RESET:       JSR              MON_SETNORM            ;NORMAL
                 JSR              MON_INIT
                 JSR              MON_SETVID             ;PR#0
                 JSR              MON_SETKBD             ;IN#0
MON_MON:          CLD                    ;MUST SET HEX MODE!
                 JSR              MON_BELL
MON_MONZ:        LDA              #$AA                   ;* PROMPT FOR MON
                 STA              $33
                 JSR              MON_GETLNZ             ;READ A LINE
                 JSR              MON_ZMODE              ;CLEAR MON MODE, SCAN IDX
MON_NXTITM:      JSR              MON_GETNUM             ;GET ITEM, NON-HEX
                 STY              $34                    ;  CHAR IN A-REG
                 LDY              #$17                   ;  X-REG=0 IF NO HEX INPUT
MON_CHRSRCH:      DEY
                 BMI              MON_MON                ;NOT FOUND, GO TO MON
                 CMP              MON_CHRTBL,Y           ;FIND CMND CHAR IN TEL
                 BNE              MON_CHRSRCH
                 JSR              MON_TOSUB              ;FOUND, CALL CORRESPONDING
                 LDY              $34                    ;  SUBROUTINE
                 JMP              MON_NXTITM

MON_DIG:         LDX              #$03
                 ASL
                 ASL                                     ;GOT HEX DIG,
                 ASL                                     ;  SHIFT INTO A2
                 ASL
MON_NXTBIT:       ASL
                 ROL              $3E
                 ROL              $3F
                 DEX                                     ;LEAVE X=$FF IF DIG
                 BPL              MON_NXTBIT
MON_NXTBAS:      LDA              $31
                 BNE              MON_NXTBS2             ;IF MODE IS ZERO
                 LDA              $3F,X                  ; THEN COPY A2 TO
                 STA              $3D,X                  ; A1 AND A3
                 STA              $41,X
MON_NXTBS2:       INX
                 BEQ              MON_NXTBAS
                 BNE              MON_NXTCHR

MON_GETNUM:      LDX              #$00                   ;CLEAR A2
                 STX              $3E
                 STX              $3F
MON_NXTCHR:      LDA              $0200,Y                ;GET CHAR
                 INY
                 EOR              #$B0
                 CMP              #$0A
                 BCC              MON_DIG                ;IF HEX DIG, THEN
                 ADC              #$88
                 CMP              #$FA
                 BCS              MON_DIG
                 RTS

MON_TOSUB:       LDA              #>MON_GO               ;PUSH HIGH-ORDER
                 PHA                                     ;  SUBR ADR ON STK
                 LDA              MON_SUBTBL,Y           ;PUSH LOW-ORDER
                 PHA                                     ;  SUBR ADR ON STK
                 LDA              $31
MON_ZMODE:       LDY              #$00                   ;CLR MODE, OLD MODE
                 STY              $31                    ;  TO A-REG
                 RTS                                     ; GO TO SUBR VIA RTS

;DEFINE F(CHR) <(CHR^$B0+$89)

MON_CHRTBL   .BYTE <((MON_CTRL_C^$B0)+$89)
         .BYTE <((MON_CTRL_Y^$B0)+$89)
         .BYTE <((MON_CTRL_E^$B0)+$89)

         .BYTE <((MON_CTRL_Y^$B0)+$89)

         .BYTE <((("V"|%10000000)^$B0)+$89)
         .BYTE <((MON_CTRL_K^$B0)+$89)

         .BYTE <((MON_CTRL_Y^$B0)+$89)

         .BYTE <((MON_CTRL_P^$B0)+$89)
         .BYTE <((MON_CTRL_B^$B0)+$89)
         .BYTE <((("-"|%10000000)^$B0)+$89)
         .BYTE <((("+"|%10000000)^$B0)+$89)
         .BYTE <((("M"|%10000000)^$B0)+$89)
         .BYTE <((("<"|%10000000)^$B0)+$89)
         .BYTE <((("N"|%10000000)^$B0)+$89)
         .BYTE <((("I"|%10000000)^$B0)+$89)
         .BYTE <((("L"|%10000000)^$B0)+$89)
         .BYTE <((("W"|%10000000)^$B0)+$89)
         .BYTE <((("G"|%10000000)^$B0)+$89)
         .BYTE <((("R"|%10000000)^$B0)+$89)
         .BYTE <(((":"|%10000000)^$B0)+$89)
         .BYTE <((("."|%10000000)^$B0)+$89)
         .BYTE <(($8D^$B0)+$89)
         .BYTE <(((" "|%10000000)^$B0)+$89)

MON_SUBTBL   .BYTE <MON_BASCONT-1
         .BYTE <MON_USR-1
         .BYTE <MON_REGZ-1
         .BYTE <MON_TRACE-1
         .BYTE <MON_VFY-1
         .BYTE <MON_INPRT-1
         .BYTE <MON_STEPZ-1
         .BYTE <MON_OUTPRT-1
         .BYTE <MON_XBASIC-1
         .BYTE <MON_SETMODE-1
         .BYTE <MON_SETMODE-1
         .BYTE <MON_MOVE-1
         .BYTE <MON_LT-1
         .BYTE <MON_SETNORM-1
         .BYTE <MON_SETINV-1
         .BYTE <MON_LIST1-1
         .BYTE <MON_WRITE-1
         .BYTE <MON_GO-1
         .BYTE <MON_READ-1
         .BYTE <MON_SETMODE-1
         .BYTE <MON_SETMODE-1
         .BYTE <MON_CRMON-1
         .BYTE <MON_BLANK-1

MON_M6502VEC:    .word            $03FB                  ;NMI VECTOR

                 .word            MON_RESET2             ;RESET VECTOR

                 .word            MON_IRQ                ;IRQ VECTOR

