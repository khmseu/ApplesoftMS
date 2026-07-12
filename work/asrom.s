                      .org  $D000

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
                                                       ; and released (on cassette) in Nov. 1977.

                                                       ; Version 2 was written by Randy Wigginton and
                                                       ; others at Apple in spring 1978. This version
                                                       ; was released in several different forms. The
                                                       ; one reproduced by this source assembly file is
                                                       ; the main-board ROM form, which appeared in the
                                                       ; Apple ][ plus ROM at $D000-$F7FF.

                                                       ; --------------------------------

                                                       ; --------------------------------
                                                       ; Zero page locations:
                                                       ; --------------------------------
MS_Z_0000_START             =     $00                        ; Gets "jmp restart"
MS_Z_0003_RDYJSR           =     $03                        ; Gets "jmp strout"
MS_Z_000A_USRPOK                =     $0A                        ; Gets "jmp <user addr>"
                                                       ; (Initially $E199)
MS_Z_000D_CHARAC             =     $0D                        ; Alternate string terminator
MS_Z_000E_ENDCHR             =     $0E                        ; String terminator
MS_Z_000F_COUNT           =     $0F                        ; Used in parse
AS_EOL_PNTR           =     $0F                        ; Used in nxlin
AS_NUMDIM             =     $0F                        ; Used in array routines
MS_Z_0010_DIMFLG             =     $10
MS_Z_0011_VALTYP             =     $11                        ; $:Valtyp=$FF; %:valtyp+1=$80
AS_DATAFLG            =     $13                        ; Used in parse
MS_Z_0013_GARBFL             =     $13                        ; Used in garbag
MS_Z_0014_SUBFLG             =     $14
MS_Z_0015_INPFLG           =     $15                        ; = $40 For get, $98 for read
AS_CPRMASK            =     $16                        ; Receives cprtyp in frmevl
MS_Z_0016_TANSGN            =     $16                        ; Flags sign in tan
AS_HGR_SHAPE          =     $1A
AS_HGR_BITS           =     $1C
AS_HGR_COUNT          =     $1D
MON_CH                =     $24
MON_GBASL             =     $26
MON_GBASH             =     $27
MON_H2                =     $2C
MON_V2                =     $2D
MON_MASK              =     $2E
MON_HMASK             =     $30
MON_COLOR             =     $30
MON_INVFLG            =     $32
MS_Z_0033_CQPRMP            =     $33
MON_A1L               =     $3C                        ; Used by tape i/o routines
MON_A1H               =     $3D                        ; "
MON_A2L               =     $3E                        ; "
MON_A2H               =     $3F                        ; "
MS_Z_0050_LINNUM             =     $50                        ; Converted line #
MS_Z_0052_TEMPPT             =     $52                        ; Last used temp string desc
MS_Z_0053_LASTPT             =     $53                        ; Last used temp string pntr
MS_Z_0055_TEMPST             =     $55                        ; Holds up to 3 descriptors
MS_Z_005E_INDEX              =     $5E
AS_DEST               =     $60
AS_RESULT             =     $62                        ; Result of last * or /
MS_Z_0067_TXTTAB             =     $67                        ; Start of program text
MS_Z_0069_VARTAB             =     $69                        ; Start of variable storage
MS_Z_006B_ARYTAB             =     $6B                        ; Start of array storage
MS_Z_006D_STREND             =     $6D                        ; End of array storage
MS_Z_006F_FRETOP             =     $6F                        ; Start of string storage
MS_Z_0071_FRESPC             =     $71                        ; Temp pntr, string routines
MS_Z_0073_MEMSIZ             =     $73                        ; End of string space (himem)
MS_Z_0075_CURLIN             =     $75                        ; Current line number
                                                       ; ( = $FFxx if in direct mode)
MS_Z_0077_OLDLIN             =     $77                        ; Addr. of last line executed
MS_Z_0079_OLDTXT            =     $79
MS_Z_007B_DATLIN             =     $7B                        ; Line # of current data stt.
MS_Z_007D_DATPTR             =     $7D                        ; Addr of current data stt.
MS_Z_007F_INPPTR              =     $7F
MS_Z_0081_VARNAM             =     $81                        ; Name of variable
MS_Z_0083_VARPNT             =     $83                        ; Addr of variable
MS_Z_0085_FORPNT             =     $85
MS_Z_0087_VARTXT              =     $87                        ; Used in input
MS_Z_0087_OPPTR             =     $87                        ; Scratch flag used in frmevl
MS_Z_0089_OPMASK             =     $89                        ; >,=,< Flag in frmevl
MS_Z_008A_GRBPNT              =     $8A
MS_Z_008A_DEFPNT             =     $8A
MS_Z_008C_DSCPNT             =     $8C
AS_DSCLEN             =     $8F                        ; Used in garbag
MS_Z_0090_JMPER            =     $90                        ; Gets "jmp ...."
MS_Z_0091_SIZE             =     $91                        ; Used in garbag
MS_Z_0092_OLDOV      =     $92                        ; Fp extra precision
MS_Z_0093_TEMPF1              =     $93                        ; Save areas for fac
MS_Z_0094_ARYPNT             =     $94                        ; Used in garbag
MS_Z_0094_HIGHDS             =     $94                        ; Pntr for bltu
MS_Z_0096_HIGHTR             =     $96                        ; Pntr for bltu
MS_Z_0098_TEMPF2              =     $98
AS_TMPEXP             =     $99                        ; Used in fin (eval)
AS_INDX               =     $99                        ; Used by array rtns
MS_Z_009A_TENEXP              =     $9A                        ; "
MS_Z_009B_DPTFLG              =     $9B                        ; Flags dec pnt in fin
MS_Z_009B_LOWTR              =     $9B
MS_Z_009C_EXPSGN             =     $9C
MS_Z_009D_FAC                =     $9D                        ; Main flt pt accumulator
MS_Z_009D_DSCTMP             =     $9D
AS_VPNT               =     $A0                        ; Temp var ptr
MS_Z_00A2_FACSGN           =     $A2                        ; Holds unpacked sign
AS_SERLEN             =     $A3                        ; Holds length of series-1
AS_SHIFT_SIGN_EXT     =     $A4                        ; Sign extension, right shifts
MS_Z_00A5_ARGEXP                =     $A5                        ; Secondary fp acc
MS_Z_00AA_ARGSGN           =     $AA
MS_Z_00AB_ARISGN             =     $AB                        ; Flags opp sign in fp rout.
MS_Z_00AC_FACOV      =     $AC                        ; Fac extension byte
AS_SERPNT             =     $AD                        ; Pntr to series data in fp
MS_Z_00AB_STRNG1             =     $AB
MS_Z_00AD_STRNG2             =     $AD
AS_PRGEND             =     $AF
MS_Z_00B1_CHRGET             =     $B1
MS_Z_00B7_CHRGOT             =     $B7
MS_Z_00B8_TXTPTR             =     $B8
MS_Z_00C9_RNDX            =     $C9
AS_HGR_DX             =     $D0
AS_HGR_DY             =     $D2
AS_HGR_QUADRANT       =     $D3
AS_HGR_E              =     $D4
AS_LOCK               =     $D6                        ; No user access if > 127
AS_ERRFLG             =     $D8                        ; $80 If on err active
AS_ERRLIN             =     $DA                        ; Line # where error occurred
AS_ERRPOS             =     $DC                        ; Txtptr save for handlerr
AS_ERRNUM             =     $DE                        ; Which error occurred
AS_ERRSTK             =     $DF                        ; Stack pntr before error
AS_HGR_X              =     $E0
AS_HGR_Y              =     $E2
AS_HGR_COLOR          =     $E4
AS_HGR_HORIZ          =     $E5                        ; Byte index from gbash,l
AS_HGR_PAGE           =     $E6                        ; Hgr=$20, hgr2=$40
AS_HGR_SCALE          =     $E7
AS_HGR_SHAPE_PNTR     =     $E8
AS_HGR_COLLISIONS     =     $EA
AS_FIRST              =     $F0
AS_SPEEDZ             =     $F1                        ; Output speed
AS_TRCFLG             =     $F2
AS_FLASH_BIT          =     $F3                        ; = $40 For flash, else =$00
AS_TXTPSV             =     $F4
AS_CURLSV             =     $F6
AS_REMSTK             =     $F8                        ; Stack pntr before each stt.
AS_HGR_ROTATION       =     $F9
                                                       ; $FF is also used by the string out routines
                                                       ; --------------------------------
AS_STACK              =     $0100
MS_BUF       =     $0200
AS_AMPERSAND_VECTOR   =     $03F5                      ; - 3F7   gets "jmp ...."
                                                       ; --------------------------------
                                                       ; I/o & soft switches
                                                       ; --------------------------------
AS_KEYBOARD           =     $C000
AS_SW_TXTCLR          =     $C050
AS_SW_MIXCLR          =     $C052
AS_SW_MIXSET          =     $C053
AS_SW_LOWSCR          =     $C054
AS_SW_HISCR           =     $C055
AS_SW_LORES           =     $C056
AS_SW_HIRES           =     $C057
                                                       ; --------------------------------
                                                       ; Monitor subroutines
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
;MS_OUTCH            = $FDED
;MON_INPORT          = $FE8B
;MON_OUTPORT         = $FE95
;MS_CQCOUT           = $FECD
;MS_CQCSIN            = $FEFD
;MON_READ2           = $FF02
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; Applesoft tokens
                                                       ; --------------------------------
MS_T_FORTK          =     $81
MS_T_DATATK          =     $83
AS_TOKEN_POP          =     $A1
MS_T_GOTOTK         =     $AB
MS_T_GOSUTK        =     $B0
MS_T_REMTK          =     $B2
MS_T_PRINTK        =     $BA
MS_T_TABTK          =     $C0
MS_T_TOTK           =     $C1
MS_T_FNTK           =     $C2
MS_T_SPCTK          =     $C3
MS_T_THENTK         =     $C4
AS_TOKENDB            =     $C5
MS_T_NOTTK          =     $C6
MS_T_STEPTK         =     $C7
MS_T_PLUSTK         =     $C8
MS_T_MINUTK        =     $C9
MS_T_GREATK      =     $CF
MS_T_EQULTK        =     $D0
MS_T_ONEFUN          =     $D2
AS_TOKEN_SCRN         =     $D7
AS_TOKEN_LEFTSTR      =     $E8
                                                       ; --------------------------------
                                                       ; Branch table for tokens
                                                       ; --------------------------------
MS_STMDSP: .word MS_END - 1                ; $80...128...End
                      .word MS_FOR - 1                 ; $81...129...For
                      .word MS_NEXT - 1                ; $82...130...Next
                      .word MS_DATA - 1                ; $83...131..Dwta
                      .word MS_INPUT - 1               ; $84...132...Input
                      .word AS_DEL - 1                 ; $85...133...Del
                      .word MS_DIM - 1                 ; $86...134...Dim
                      .word MS_READ - 1                ; $87...135...Read
                      .word AS_GR - 1                  ; $88...136...Gr
                      .word AS_TEXT - 1                ; $89...137...Text
                      .word AS_PR_NUMBER - 1           ; $8A...138...pr#
                      .word AS_IN_NUMBER - 1           ; $8B...139...in#
                      .word AS_CALL - 1                ; $8C...140...call
                      .word AS_PLOT - 1                ; $8D...141...plot
                      .word AS_HLIN - 1                ; $8E...142...hlin
                      .word AS_VLIN - 1                ; $8F...143...vlin
                      .word AS_HGR2 - 1                ; $90...144...Hgr2
                      .word AS_HGR - 1                 ; $91...145...Hgr
                      .word AS_HCOLOR - 1              ; $92...146...Hcolor=
                      .word AS_HPLOT - 1               ; $93...147...Hplot
                      .word AS_DRAW - 1                ; $94...148...Draw
                      .word AS_XDRAW - 1               ; $95...149...Xdraw
                      .word AS_HTAB - 1                ; $96...150...Htab
                      .word MON_HOME - 1               ; $97...151...Home
                      .word AS_ROT - 1                 ; $98...152...Rot=
                      .word AS_SCALE - 1               ; $99...153...Scale=
                      .word AS_SHLOAD - 1              ; $9A...154...shload
                      .word AS_TRACE - 1               ; $9B...155...trace
                      .word AS_NOTRACE - 1             ; $9C...156...notrace
                      .word AS_NORMAL - 1              ; $9D...157...normal
                      .word AS_INVERSE - 1             ; $9E...158...inverse
                      .word AS_FLASH - 1               ; $9F...159...flash
                      .word AS_COLOR - 1               ; $A0...160...color=
                      .word MS_RETURN - 1                 ; $A1...161...pop
                      .word AS_VTAB - 1                ; $A2...162...vtab
                      .word AS_HIMEM - 1               ; $A3...163...himem:
                      .word AS_LOMEM - 1               ; $A4...164...lomem:
                      .word AS_ONERR - 1               ; $A5...165...onerr
                      .word AS_RESUME - 1              ; $A6...166...resume
                      .word AS_RECALL - 1              ; $A7...167...recall
                      .word AS_STORE - 1               ; $A8...168...store
                      .word AS_SPEED - 1               ; $A9...169...speed=
                      .word MS_LET - 1                 ; $AA...170...let
                      .word MS_GOTO - 1                ; $AB...171...goto
                      .word MS_RUN - 1                 ; $AC...172...run
                      .word MS_IF - 1                  ; $AD...173...if
                      .word MS_RESTOR - 1             ; $AE...174...restore
                      .word AS_AMPERSAND_VECTOR - 1    ; $AF...175...&
                      .word MS_GOSUB - 1               ; $B0...176...gosub
                      .word MS_RETURN - 1                 ; $B1...177...return
                      .word MS_REM - 1                 ; $B2...178...rem
                      .word MS_STOP - 1                ; $B3...179...stop
                      .word MS_ONGOTO - 1              ; $B4...180...on
                      .word MS_FNWAIT - 1                ; $B5...181...wait
                      .word MS_LOAD - 1                ; $B6...182...load
                      .word MS_SAVE - 1                ; $B7...183...save
                      .word MS_DEF - 1                 ; $B8...184...def
                      .word MS_POKE - 1                ; $B9...185...poke
                      .word MS_PRINT - 1               ; $BA...186...print
                      .word MS_CONT - 1                ; $BB...187...cont
                      .word MS_LIST - 1                ; $BC...188...list
                      .word MS_CLEAR - 1               ; $BD...189...clear
                      .word MS_GET - 1                 ; $BE...190...get
                      .word MS_SCRATH - 1                 ; $BF...191...new
                                                       ; --------------------------------
MS_FUNDSP:             .word MS_SGN                     ; $D2...210...sgn
                      .word MS_INT                     ; $D3...211...int
                      .word MS_ABS                     ; $D4...212...abs
                      .word MS_Z_000A_USRPOK                     ; $D5...213...usr
                      .word MS_FRE                     ; $D6...214...fre
                      .word MS_ERROR                   ; $D7...215...scrn(
                      .word AS_PDL                     ; $D8...216...pdl
                      .word MS_POS                     ; $D9...217...pos
                      .word MS_SQR                     ; $DA...218...sqr
                      .word MS_RND                     ; $DB...219...rnd
                      .word MS_LOG                     ; $DC...220...log
                      .word MS_EXP                     ; $DD...221...exp
                      .word MS_COS                     ; $DE...222...cos
                      .word MS_SIN                     ; $DF...223...sin
                      .word MS_TAN                     ; $E0...224...tan
                      .word MS_ATN                     ; $E1...225...atn
                      .word MS_PEEK                    ; $E2...226...peek
                      .word MS_LEN                     ; $E3...227...len
                      .word MS_STR                     ; $E4...228...str$
                      .word MS_VAL                     ; $E5...229...val
                      .word MS_ASC                     ; $E6...230...asc
                      .word MS_CHR                  ; $E7...231...chr$
                      .word MS_LEFT                 ; $E8...232...left$
                      .word MS_RIGHT                ; $E9...233...right$
                      .word MS_MID                  ; $EA...234...mid$
                                                       ; --------------------------------
                                                       ; Math operator branch table

                                                       ; One-byte precedence code
                                                       ; Two-byte address
                                                       ; --------------------------------
AS_P_OR               =     $46                        ; "Or" is lowest precedence
AS_P_AND              =     $50
AS_P_REL              =     $64                        ; Relational operators
AS_P_ADD              =     $79                        ; Binary + and -
AS_P_MUL              =     $7B                        ; * And /
AS_P_PWR              =     $7D                        ; Exponentiation
AS_P_NEQ              =     $7F                        ; Unary - and comparison =
                                                       ; --------------------------------
MS_OPTAB:           .byte AS_P_ADD
                      .word MS_FADDT - 1               ; $C8...200...+
                      .byte AS_P_ADD
                      .word MS_FSUBT - 1               ; $C9...201...-
                      .byte AS_P_MUL
                      .word MS_FMULTT - 1              ; $CA...202...*
                      .byte AS_P_MUL
                      .word MS_FDIVT - 1               ; $CB...203.../
                      .byte AS_P_PWR
                      .word MS_FPWRT - 1               ; $CC...204...^
                      .byte AS_P_AND
                      .word MS_ANDOP - 1               ; $CD...205...and
                      .byte AS_P_OR
                      .word MS_OROP - 1                  ; $CE...206...or
MS_NEGTAB:             .byte AS_P_NEQ
                      .word MS_NEGOP - 1               ; $CF...207...>
MS_NOTTAB:             .byte AS_P_NEQ
                      .word MS_NOTOP - 1               ; $D0...208...=
MS_PTDORL:             .byte AS_P_REL
                      .word MS_DOREL - 1              ; $D1...209...<

                                                       ; --------------------------------
                                                       ; Token name table
                                                       ; --------------------------------

MS_RESLST:  .byte "E" & %01111111
                      .byte "N" & %01111111
                      .byte "D" | %10000000
                                                       ; $80...128
                      .byte "F" & %01111111
                      .byte "O" & %01111111
                      .byte "R" | %10000000
                                                       ; $81...129
                      .byte "N" & %01111111
                      .byte "E" & %01111111
                      .byte "X" & %01111111
                      .byte "T" | %10000000
                                                       ; $82...130
                      .byte "D" & %01111111
                      .byte "A" & %01111111
                      .byte "T" & %01111111
                      .byte "A" | %10000000
                                                       ; $83...131
                      .byte "I" & %01111111
                      .byte "N" & %01111111
                      .byte "P" & %01111111
                      .byte "U" & %01111111
                      .byte "T" | %10000000
                                                       ; $84...132
                      .byte "D" & %01111111
                      .byte "E" & %01111111
                      .byte "L" | %10000000
                                                       ; $85...133
                      .byte "D" & %01111111
                      .byte "I" & %01111111
                      .byte "M" | %10000000
                                                       ; $86...134
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "A" & %01111111
                      .byte "D" | %10000000
                                                       ; $87...135
                      .byte "G" & %01111111
                      .byte "R" | %10000000
                                                       ; $88...136
                      .byte "T" & %01111111
                      .byte "E" & %01111111
                      .byte "X" & %01111111
                      .byte "T" | %10000000
                                                       ; $89...137
                      .byte "P" & %01111111
                      .byte "R" & %01111111
                      .byte "#" | %10000000
                                                       ; $8A...138
                      .byte "I" & %01111111
                      .byte "N" & %01111111
                      .byte "#" | %10000000
                                                       ; $8B...139
                      .byte "C" & %01111111
                      .byte "A" & %01111111
                      .byte "L" & %01111111
                      .byte "L" | %10000000
                                                       ; $8C...140
                      .byte "P" & %01111111
                      .byte "L" & %01111111
                      .byte "O" & %01111111
                      .byte "T" | %10000000
                                                       ; $8D...141
                      .byte "H" & %01111111
                      .byte "L" & %01111111
                      .byte "I" & %01111111
                      .byte "N" | %10000000
                                                       ; $8E...142
                      .byte "V" & %01111111
                      .byte "L" & %01111111
                      .byte "I" & %01111111
                      .byte "N" | %10000000
                                                       ; $8F...143
                      .byte "H" & %01111111
                      .byte "G" & %01111111
                      .byte "R" & %01111111
                      .byte "2" | %10000000
                                                       ; $90...144
                      .byte "H" & %01111111
                      .byte "G" & %01111111
                      .byte "R" | %10000000
                                                       ; $91...145
                      .byte "H" & %01111111
                      .byte "C" & %01111111
                      .byte "O" & %01111111
                      .byte "L" & %01111111
                      .byte "O" & %01111111
                      .byte "R" & %01111111
                      .byte "=" | %10000000
                                                       ; $92...146
                      .byte "H" & %01111111
                      .byte "P" & %01111111
                      .byte "L" & %01111111
                      .byte "O" & %01111111
                      .byte "T" | %10000000
                                                       ; $93...147
                      .byte "D" & %01111111
                      .byte "R" & %01111111
                      .byte "A" & %01111111
                      .byte "W" | %10000000
                                                       ; $94...148
                      .byte "X" & %01111111
                      .byte "D" & %01111111
                      .byte "R" & %01111111
                      .byte "A" & %01111111
                      .byte "W" | %10000000
                                                       ; $95...149
                      .byte "H" & %01111111
                      .byte "T" & %01111111
                      .byte "A" & %01111111
                      .byte "B" | %10000000
                                                       ; $96...150
                      .byte "H" & %01111111
                      .byte "O" & %01111111
                      .byte "M" & %01111111
                      .byte "E" | %10000000
                                                       ; $97...151
                      .byte "R" & %01111111
                      .byte "O" & %01111111
                      .byte "T" & %01111111
                      .byte "=" | %10000000
                                                       ; $98...152
                      .byte "S" & %01111111
                      .byte "C" & %01111111
                      .byte "A" & %01111111
                      .byte "L" & %01111111
                      .byte "E" & %01111111
                      .byte "=" | %10000000
                                                       ; $99...153
                      .byte "S" & %01111111
                      .byte "H" & %01111111
                      .byte "L" & %01111111
                      .byte "O" & %01111111
                      .byte "A" & %01111111
                      .byte "D" | %10000000
                                                       ; $9A...154
                      .byte "T" & %01111111
                      .byte "R" & %01111111
                      .byte "A" & %01111111
                      .byte "C" & %01111111
                      .byte "E" | %10000000
                                                       ; $9B...155
                      .byte "N" & %01111111
                      .byte "O" & %01111111
                      .byte "T" & %01111111
                      .byte "R" & %01111111
                      .byte "A" & %01111111
                      .byte "C" & %01111111
                      .byte "E" | %10000000
                                                       ; $9C...156
                      .byte "N" & %01111111
                      .byte "O" & %01111111
                      .byte "R" & %01111111
                      .byte "M" & %01111111
                      .byte "A" & %01111111
                      .byte "L" | %10000000
                                                       ; $9D...157
                      .byte "I" & %01111111
                      .byte "N" & %01111111
                      .byte "V" & %01111111
                      .byte "E" & %01111111
                      .byte "R" & %01111111
                      .byte "S" & %01111111
                      .byte "E" | %10000000
                                                       ; $9E...158
                      .byte "F" & %01111111
                      .byte "L" & %01111111
                      .byte "A" & %01111111
                      .byte "S" & %01111111
                      .byte "H" | %10000000
                                                       ; $9F...159
                      .byte "C" & %01111111
                      .byte "O" & %01111111
                      .byte "L" & %01111111
                      .byte "O" & %01111111
                      .byte "R" & %01111111
                      .byte "=" | %10000000
                                                       ; $A0...160
                      .byte "P" & %01111111
                      .byte "O" & %01111111
                      .byte "P" | %10000000
                                                       ; $A1...161
                      .byte "V" & %01111111
                      .byte "T" & %01111111
                      .byte "A" & %01111111
                      .byte "B" | %10000000
                                                       ; $A2...162
                      .byte "H" & %01111111
                      .byte "I" & %01111111
                      .byte "M" & %01111111
                      .byte "E" & %01111111
                      .byte "M" & %01111111
                      .byte ":" | %10000000
                                                       ; $A3...163
                      .byte "L" & %01111111
                      .byte "O" & %01111111
                      .byte "M" & %01111111
                      .byte "E" & %01111111
                      .byte "M" & %01111111
                      .byte ":" | %10000000
                                                       ; $A4...164
                      .byte "O" & %01111111
                      .byte "N" & %01111111
                      .byte "E" & %01111111
                      .byte "R" & %01111111
                      .byte "R" | %10000000
                                                       ; $A5...165
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "S" & %01111111
                      .byte "U" & %01111111
                      .byte "M" & %01111111
                      .byte "E" | %10000000
                                                       ; $A6...166
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "C" & %01111111
                      .byte "A" & %01111111
                      .byte "L" & %01111111
                      .byte "L" | %10000000
                                                       ; $A7...167
                      .byte "S" & %01111111
                      .byte "T" & %01111111
                      .byte "O" & %01111111
                      .byte "R" & %01111111
                      .byte "E" | %10000000
                                                       ; $A8...168
                      .byte "S" & %01111111
                      .byte "P" & %01111111
                      .byte "E" & %01111111
                      .byte "E" & %01111111
                      .byte "D" & %01111111
                      .byte "=" | %10000000
                                                       ; $A9...169
                      .byte "L" & %01111111
                      .byte "E" & %01111111
                      .byte "T" | %10000000
                                                       ; $AA...170
                      .byte "G" & %01111111
                      .byte "O" & %01111111
                      .byte "T" & %01111111
                      .byte "O" | %10000000
                                                       ; $AB...171
                      .byte "R" & %01111111
                      .byte "U" & %01111111
                      .byte "N" | %10000000
                                                       ; $AC...172
                      .byte "I" & %01111111
                      .byte "F" | %10000000
                                                       ; $AD...173
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "S" & %01111111
                      .byte "T" & %01111111
                      .byte "O" & %01111111
                      .byte "R" & %01111111
                      .byte "E" | %10000000
                                                       ; $AE...174
                      .byte "&" | %10000000
                                                       ; $AF...175
                      .byte "G" & %01111111
                      .byte "O" & %01111111
                      .byte "S" & %01111111
                      .byte "U" & %01111111
                      .byte "B" | %10000000
                                                       ; $B0...176
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "T" & %01111111
                      .byte "U" & %01111111
                      .byte "R" & %01111111
                      .byte "N" | %10000000
                                                       ; $B1...177
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "M" | %10000000
                                                       ; $B2...178
                      .byte "S" & %01111111
                      .byte "T" & %01111111
                      .byte "O" & %01111111
                      .byte "P" | %10000000
                                                       ; $B3...179
                      .byte "O" & %01111111
                      .byte "N" | %10000000
                                                       ; $B4...180
                      .byte "W" & %01111111
                      .byte "A" & %01111111
                      .byte "I" & %01111111
                      .byte "T" | %10000000
                                                       ; $B5...181
                      .byte "L" & %01111111
                      .byte "O" & %01111111
                      .byte "A" & %01111111
                      .byte "D" | %10000000
                                                       ; $B6...182
                      .byte "S" & %01111111
                      .byte "A" & %01111111
                      .byte "V" & %01111111
                      .byte "E" | %10000000
                                                       ; $B7...183
                      .byte "D" & %01111111
                      .byte "E" & %01111111
                      .byte "F" | %10000000
                                                       ; $B8...184
                      .byte "P" & %01111111
                      .byte "O" & %01111111
                      .byte "K" & %01111111
                      .byte "E" | %10000000
                                                       ; $B9...185
                      .byte "P" & %01111111
                      .byte "R" & %01111111
                      .byte "I" & %01111111
                      .byte "N" & %01111111
                      .byte "T" | %10000000
                                                       ; $BA...186
                      .byte "C" & %01111111
                      .byte "O" & %01111111
                      .byte "N" & %01111111
                      .byte "T" | %10000000
                                                       ; $BB...187
                      .byte "L" & %01111111
                      .byte "I" & %01111111
                      .byte "S" & %01111111
                      .byte "T" | %10000000
                                                       ; $BC...188
                      .byte "C" & %01111111
                      .byte "L" & %01111111
                      .byte "E" & %01111111
                      .byte "A" & %01111111
                      .byte "R" | %10000000
                                                       ; $BD...189
                      .byte "G" & %01111111
                      .byte "E" & %01111111
                      .byte "T" | %10000000
                                                       ; $BE...190
                      .byte "N" & %01111111
                      .byte "E" & %01111111
                      .byte "W" | %10000000
                                                       ; $BF...191
                      .byte "T" & %01111111
                      .byte "A" & %01111111
                      .byte "B" & %01111111
                                                       ; $C0...192
                      .byte $A8
                      .byte "T" & %01111111
                      .byte "O" | %10000000
                                                       ; $C1...193
                      .byte "F" & %01111111
                      .byte "N" | %10000000
                                                       ; $C2...194
                      .byte "S" & %01111111
                      .byte "P" & %01111111
                      .byte "C" & %01111111
                                                       ; $C3...195
                      .byte $A8
                      .byte "T" & %01111111
                      .byte "H" & %01111111
                      .byte "E" & %01111111
                      .byte "N" | %10000000
                                                       ; $C4...196
                      .byte "A" & %01111111
                      .byte "T" | %10000000
                                                       ; $C5...197
                      .byte "N" & %01111111
                      .byte "O" & %01111111
                      .byte "T" | %10000000
                                                       ; $C6...198
                      .byte "S" & %01111111
                      .byte "T" & %01111111
                      .byte "E" & %01111111
                      .byte "P" | %10000000
                                                       ; $C7...199
                      .byte "+" | %10000000
                                                       ; $C8...200
                      .byte "-" | %10000000
                                                       ; $C9...201
                      .byte "*" | %10000000
                                                       ; $CA...202
                      .byte "/" | %10000000
                                                       ; $CB...203
                      .byte $DE
;                    Lhascii(`^')                     ; $CC...204
                      .byte "A" & %01111111
                      .byte "N" & %01111111
                      .byte "D" | %10000000
                                                       ; $CD...205
                      .byte "O" & %01111111
                      .byte "R" | %10000000
                                                       ; $CE...206
                      .byte ">" | %10000000
                                                       ; $CF...207
                      .byte "=" | %10000000
                                                       ; $D0...208
                      .byte "<" | %10000000
                                                       ; $D1...209
                      .byte "S" & %01111111
                      .byte "G" & %01111111
                      .byte "N" | %10000000
                                                       ; $D2...210
                      .byte "I" & %01111111
                      .byte "N" & %01111111
                      .byte "T" | %10000000
                                                       ; $D3...211
                      .byte "A" & %01111111
                      .byte "B" & %01111111
                      .byte "S" | %10000000
                                                       ; $D4...212
                      .byte "U" & %01111111
                      .byte "S" & %01111111
                      .byte "R" | %10000000
                                                       ; $D5...213
                      .byte "F" & %01111111
                      .byte "R" & %01111111
                      .byte "E" | %10000000
                                                       ; $D6...214
                      .byte "S" & %01111111
                      .byte "C" & %01111111
                      .byte "R" & %01111111
                      .byte "N" & %01111111
                                                       ; $D7...215
                      .byte $A8
                      .byte "P" & %01111111
                      .byte "D" & %01111111
                      .byte "L" | %10000000
                                                       ; $D8...216
                      .byte "P" & %01111111
                      .byte "O" & %01111111
                      .byte "S" | %10000000
                                                       ; $D9...217
                      .byte "S" & %01111111
                      .byte "Q" & %01111111
                      .byte "R" | %10000000
                                                       ; $DA...218
                      .byte "R" & %01111111
                      .byte "N" & %01111111
                      .byte "D" | %10000000
                                                       ; $DB...219
                      .byte "L" & %01111111
                      .byte "O" & %01111111
                      .byte "G" | %10000000
                                                       ; $DC...220
                      .byte "E" & %01111111
                      .byte "X" & %01111111
                      .byte "P" | %10000000
                                                       ; $DD...221
                      .byte "C" & %01111111
                      .byte "O" & %01111111
                      .byte "S" | %10000000
                                                       ; $DE...222
                      .byte "S" & %01111111
                      .byte "I" & %01111111
                      .byte "N" | %10000000
                                                       ; $DF...223
                      .byte "T" & %01111111
                      .byte "A" & %01111111
                      .byte "N" | %10000000
                                                       ; $E0...224
                      .byte "A" & %01111111
                      .byte "T" & %01111111
                      .byte "N" | %10000000
                                                       ; $E1...225
                      .byte "P" & %01111111
                      .byte "E" & %01111111
                      .byte "E" & %01111111
                      .byte "K" | %10000000
                                                       ; $E2...226
                      .byte "L" & %01111111
                      .byte "E" & %01111111
                      .byte "N" | %10000000
                                                       ; $E3...227
                      .byte "S" & %01111111
                      .byte "T" & %01111111
                      .byte "R" & %01111111
                      .byte "$" | %10000000
                                                       ; $E4...228
                      .byte "V" & %01111111
                      .byte "A" & %01111111
                      .byte "L" | %10000000
                                                       ; $E5...229
                      .byte "A" & %01111111
                      .byte "S" & %01111111
                      .byte "C" | %10000000
                                                       ; $E6...230
                      .byte "C" & %01111111
                      .byte "H" & %01111111
                      .byte "R" & %01111111
                      .byte "$" | %10000000
                                                       ; $E7...231
                      .byte "L" & %01111111
                      .byte "E" & %01111111
                      .byte "F" & %01111111
                      .byte "T" & %01111111
                      .byte "$" | %10000000
                                                       ; $E8...232
                      .byte "R" & %01111111
                      .byte "I" & %01111111
                      .byte "G" & %01111111
                      .byte "H" & %01111111
                      .byte "T" & %01111111
                      .byte "$" | %10000000
                                                       ; $E9...233
                      .byte "M" & %01111111
                      .byte "I" & %01111111
                      .byte "D" & %01111111
                      .byte "$" | %10000000
                                                       ; $EA...234

                      .byte 0                          ; End of token name table
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; Error messages
                                                       ; --------------------------------
MS_ERRTAB:
MS_E_ERRNF          =     * - MS_ERRTAB
                      .byte "N" & %01111111
                      .byte "E" & %01111111
                      .byte "X" & %01111111
                      .byte "T" & %01111111
                      .byte " " & %01111111
                      .byte "W" & %01111111
                      .byte "I" & %01111111
                      .byte "T" & %01111111
                      .byte "H" & %01111111
                      .byte "O" & %01111111
                      .byte "U" & %01111111
                      .byte "T" & %01111111
                      .byte " " & %01111111
                      .byte "F" & %01111111
                      .byte "O" & %01111111
                      .byte "R" | %10000000

MS_E_ERRSN         =     * - MS_ERRTAB
                      .byte "S" & %01111111
                      .byte "Y" & %01111111
                      .byte "N" & %01111111
                      .byte "T" & %01111111
                      .byte "A" & %01111111
                      .byte "X" | %10000000

MS_E_ERRRG        =     * - MS_ERRTAB
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "T" & %01111111
                      .byte "U" & %01111111
                      .byte "R" & %01111111
                      .byte "N" & %01111111
                      .byte " " & %01111111
                      .byte "W" & %01111111
                      .byte "I" & %01111111
                      .byte "T" & %01111111
                      .byte "H" & %01111111
                      .byte "O" & %01111111
                      .byte "U" & %01111111
                      .byte "T" & %01111111
                      .byte " " & %01111111
                      .byte "G" & %01111111
                      .byte "O" & %01111111
                      .byte "S" & %01111111
                      .byte "U" & %01111111
                      .byte "B" | %10000000

MS_E_ERROD         =     * - MS_ERRTAB
                      .byte "O" & %01111111
                      .byte "U" & %01111111
                      .byte "T" & %01111111
                      .byte " " & %01111111
                      .byte "O" & %01111111
                      .byte "F" & %01111111
                      .byte " " & %01111111
                      .byte "D" & %01111111
                      .byte "A" & %01111111
                      .byte "T" & %01111111
                      .byte "A" | %10000000

MS_E_ERRFC         =     * - MS_ERRTAB
                      .byte "I" & %01111111
                      .byte "L" & %01111111
                      .byte "L" & %01111111
                      .byte "E" & %01111111
                      .byte "G" & %01111111
                      .byte "A" & %01111111
                      .byte "L" & %01111111
                      .byte " " & %01111111
                      .byte "Q" & %01111111
                      .byte "U" & %01111111
                      .byte "A" & %01111111
                      .byte "N" & %01111111
                      .byte "T" & %01111111
                      .byte "I" & %01111111
                      .byte "T" & %01111111
                      .byte "Y" | %10000000

MS_E_ERROV       =     * - MS_ERRTAB
                      .byte "O" & %01111111
                      .byte "V" & %01111111
                      .byte "E" & %01111111
                      .byte "R" & %01111111
                      .byte "F" & %01111111
                      .byte "L" & %01111111
                      .byte "O" & %01111111
                      .byte "W" | %10000000

MS_E_ERROM        =     * - MS_ERRTAB
                      .byte "O" & %01111111
                      .byte "U" & %01111111
                      .byte "T" & %01111111
                      .byte " " & %01111111
                      .byte "O" & %01111111
                      .byte "F" & %01111111
                      .byte " " & %01111111
                      .byte "M" & %01111111
                      .byte "E" & %01111111
                      .byte "M" & %01111111
                      .byte "O" & %01111111
                      .byte "R" & %01111111
                      .byte "Y" | %10000000

MS_E_ERRUS      =     * - MS_ERRTAB
                      .byte "U" & %01111111
                      .byte "N" & %01111111
                      .byte "D" & %01111111
                      .byte "E" & %01111111
                      .byte "F" & %01111111

                      .byte $27
                      .byte "D" & %01111111
                      .byte " " & %01111111
                      .byte "S" & %01111111
                      .byte "T" & %01111111
                      .byte "A" & %01111111
                      .byte "T" & %01111111
                      .byte "E" & %01111111
                      .byte "M" & %01111111
                      .byte "E" & %01111111
                      .byte "N" & %01111111
                      .byte "T" | %10000000

MS_E_ERRBS        =     * - MS_ERRTAB
                      .byte "B" & %01111111
                      .byte "A" & %01111111
                      .byte "D" & %01111111
                      .byte " " & %01111111
                      .byte "S" & %01111111
                      .byte "U" & %01111111
                      .byte "B" & %01111111
                      .byte "S" & %01111111
                      .byte "C" & %01111111
                      .byte "R" & %01111111
                      .byte "I" & %01111111
                      .byte "P" & %01111111
                      .byte "T" | %10000000

MS_E_ERRDD         =     * - MS_ERRTAB
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "D" & %01111111
                      .byte "I" & %01111111
                      .byte "M" & %01111111

                      .byte $27
                      .byte "D" & %01111111
                      .byte " " & %01111111
                      .byte "A" & %01111111
                      .byte "R" & %01111111
                      .byte "R" & %01111111
                      .byte "A" & %01111111
                      .byte "Y" | %10000000

MS_E_ERRDV0        =     * - MS_ERRTAB
                      .byte "D" & %01111111
                      .byte "I" & %01111111
                      .byte "V" & %01111111
                      .byte "I" & %01111111
                      .byte "S" & %01111111
                      .byte "I" & %01111111
                      .byte "O" & %01111111
                      .byte "N" & %01111111
                      .byte " " & %01111111
                      .byte "B" & %01111111
                      .byte "Y" & %01111111
                      .byte " " & %01111111
                      .byte "Z" & %01111111
                      .byte "E" & %01111111
                      .byte "R" & %01111111
                      .byte "O" | %10000000

MS_E_ERRID         =     * - MS_ERRTAB
                      .byte "I" & %01111111
                      .byte "L" & %01111111
                      .byte "L" & %01111111
                      .byte "E" & %01111111
                      .byte "G" & %01111111
                      .byte "A" & %01111111
                      .byte "L" & %01111111
                      .byte " " & %01111111
                      .byte "D" & %01111111
                      .byte "I" & %01111111
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "C" & %01111111
                      .byte "T" | %10000000

MS_E_ERRTM        =     * - MS_ERRTAB
                      .byte "T" & %01111111
                      .byte "Y" & %01111111
                      .byte "P" & %01111111
                      .byte "E" & %01111111
                      .byte " " & %01111111
                      .byte "M" & %01111111
                      .byte "I" & %01111111
                      .byte "S" & %01111111
                      .byte "M" & %01111111
                      .byte "A" & %01111111
                      .byte "T" & %01111111
                      .byte "C" & %01111111
                      .byte "H" | %10000000

MS_E_ERRLS        =     * - MS_ERRTAB
                      .byte "S" & %01111111
                      .byte "T" & %01111111
                      .byte "R" & %01111111
                      .byte "I" & %01111111
                      .byte "N" & %01111111
                      .byte "G" & %01111111
                      .byte " " & %01111111
                      .byte "T" & %01111111
                      .byte "O" & %01111111
                      .byte "O" & %01111111
                      .byte " " & %01111111
                      .byte "L" & %01111111
                      .byte "O" & %01111111
                      .byte "N" & %01111111
                      .byte "G" | %10000000

MS_E_ERRST         =     * - MS_ERRTAB
                      .byte "F" & %01111111
                      .byte "O" & %01111111
                      .byte "R" & %01111111
                      .byte "M" & %01111111
                      .byte "U" & %01111111
                      .byte "L" & %01111111
                      .byte "A" & %01111111
                      .byte " " & %01111111
                      .byte "T" & %01111111
                      .byte "O" & %01111111
                      .byte "O" & %01111111
                      .byte " " & %01111111
                      .byte "C" & %01111111
                      .byte "O" & %01111111
                      .byte "M" & %01111111
                      .byte "P" & %01111111
                      .byte "L" & %01111111
                      .byte "E" & %01111111
                      .byte "X" | %10000000

MS_E_ERRCN       =     * - MS_ERRTAB
                      .byte "C" & %01111111
                      .byte "A" & %01111111
                      .byte "N" & %01111111

                      .byte $27
                      .byte "T" & %01111111
                      .byte " " & %01111111
                      .byte "C" & %01111111
                      .byte "O" & %01111111
                      .byte "N" & %01111111
                      .byte "T" & %01111111
                      .byte "I" & %01111111
                      .byte "N" & %01111111
                      .byte "U" & %01111111
                      .byte "E" | %10000000

MS_E_ERRUF      =     * - MS_ERRTAB
                      .byte "U" & %01111111
                      .byte "N" & %01111111
                      .byte "D" & %01111111
                      .byte "E" & %01111111
                      .byte "F" & %01111111

                      .byte $27
                      .byte "D" & %01111111
                      .byte " " & %01111111
                      .byte "F" & %01111111
                      .byte "U" & %01111111
                      .byte "N" & %01111111
                      .byte "C" & %01111111
                      .byte "T" & %01111111
                      .byte "I" & %01111111
                      .byte "O" & %01111111
                      .byte "N" | %10000000

                                                       ; --------------------------------

MS_ERR:          .byte " " & %01111111
                      .byte "E" & %01111111
                      .byte "R" & %01111111
                      .byte "R" & %01111111
                      .byte "O" & %01111111
                      .byte "R" & %01111111

                      .byte $07, 0

MS_INTXT:             .byte " " & %01111111
                      .byte "I" & %01111111
                      .byte "N" & %01111111
                      .byte " " & %01111111

                      .byte 0

MS_BRKTXT:          .byte $0D
                      .byte "B" & %01111111
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "A" & %01111111
                      .byte "K" & %01111111

                      .byte $07, 0
                                                       ; --------------------------------
                                                       ; Called by "next" and "for" to scan through
                                                       ; The stack for a frame with the same variable.

                                                       ; (Forpnt) = address of variable if "for" or "next"
                                                       ; = $Xxff if called from "return"
                                                       ; <<< Bug: should be $FFxx >>>

                                                       ; Returns .ne. if variable not found,
                                                       ; (X) = stack pntr after skipping all frames

                                                       ; Equ. if found
                                                       ; (X) = stack pntr of frame found
                                                       ; --------------------------------
MS_FNDFOR:
                      TSX
                      INX
                      INX
                      INX
                      INX
MS_FFLOOP:      LDA   AS_STACK + 1,X             ; "For" frame here?
                      CMP   #MS_T_FORTK
                      BNE   AS_L_GTFORPNT_4            ; No
                      LDA   MS_Z_0085_FORPNT + 1              ; Yes -- "next" with no variable?
                      BNE   MS_CMPFOR            ; No, variable specified
                      LDA   AS_STACK + 2,X             ; Yes, so use this frame
                      STA   MS_Z_0085_FORPNT
                      LDA   AS_STACK + 3,X
                      STA   MS_Z_0085_FORPNT + 1
MS_CMPFOR:      CMP   AS_STACK + 3,X             ; Is variable in this frame?
                      BNE   AS_L_GTFORPNT_3            ; No
                      LDA   MS_Z_0085_FORPNT                  ; Look at 2nd byte too
                      CMP   AS_STACK + 2,X             ; Same variable?
                      BEQ   AS_L_GTFORPNT_4            ; Yes
AS_L_GTFORPNT_3:      TXA                              ; No, so try next frame (if any)
                      CLC                              ; 18 Bytes per frame
                      ADC   #18
                      TAX
                      BNE   MS_FFLOOP            ; ...Always?
AS_L_GTFORPNT_4:      RTS
                                                       ; --------------------------------
                                                       ; Move block of memory up

                                                       ; On entry:
                                                       ; (Y,a) = (highds) = destination end+1
                                                       ; (Lowtr) = lowest address of source
                                                       ; (Hightr) = highest source address+1
                                                       ; --------------------------------
AS_BLTU:              JSR   AS_REASON                  ; Be sure (y,a) < fretop
                      STA   MS_Z_006D_STREND                  ; New top of array storage
                      STY   MS_Z_006D_STREND + 1
AS_BLTU2:             SEC
                      LDA   MS_Z_0096_HIGHTR                  ; Compute # of bytes to be moved
                      SBC   MS_Z_009B_LOWTR                   ; (From lowtr thru hightr-1)
                      STA   MS_Z_005E_INDEX                   ; Partial page amount
                      TAY
                      LDA   MS_Z_0096_HIGHTR + 1
                      SBC   MS_Z_009B_LOWTR + 1
                      TAX                              ; # Of whole pages in x-reg
                      INX
                      TYA                              ; # Bytes in partial page
                      BEQ   AS_L_BLTU2_4               ; No partial page
                      LDA   MS_Z_0096_HIGHTR                  ; Back up hightr # bytes in partial page
                      SEC
                      SBC   MS_Z_005E_INDEX
                      STA   MS_Z_0096_HIGHTR
                      BCS   AS_L_BLTU2_1
                      DEC   MS_Z_0096_HIGHTR + 1
                      SEC
AS_L_BLTU2_1:         LDA   MS_Z_0094_HIGHDS                  ; Back up highds # bytes in partial page
                      SBC   MS_Z_005E_INDEX
                      STA   MS_Z_0094_HIGHDS
                      BCS   AS_L_BLTU2_3
                      DEC   MS_Z_0094_HIGHDS + 1
                      BCC   AS_L_BLTU2_3               ; ...Always
AS_L_BLTU2_2:         LDA   (MS_Z_0096_HIGHTR),Y              ; Move the bytes
                      STA   (MS_Z_0094_HIGHDS),Y
AS_L_BLTU2_3:         DEY
                      BNE   AS_L_BLTU2_2               ; Loop to end of this 256 bytes
                      LDA   (MS_Z_0096_HIGHTR),Y              ; Move one more byte
                      STA   (MS_Z_0094_HIGHDS),Y
AS_L_BLTU2_4:         DEC   MS_Z_0096_HIGHTR + 1              ; Down to next block of 256
                      DEC   MS_Z_0094_HIGHDS + 1
                      DEX                              ; Another block of 256 to move?
                      BNE   AS_L_BLTU2_3               ; Yes
                      RTS                              ; No, finished
                                                       ; --------------------------------
                                                       ; Check if enough room left on stack
                                                       ; For "for", "gosub", or expression evaluation
                                                       ; --------------------------------
AS_CHKMEM:            ASL
                      ADC   #54
                      BCS   AS_MEMERR                  ; ...Mem full err
                      STA   MS_Z_005E_INDEX
                      TSX
                      CPX   MS_Z_005E_INDEX
                      BCC   AS_MEMERR                  ; ...Mem full err
                      RTS
                                                       ; --------------------------------
                                                       ; Check if enough room between arrays and strings
                                                       ; (Y,a) = addr arrays need to grow to
                                                       ; --------------------------------
AS_REASON:            CPY   MS_Z_006F_FRETOP + 1              ; High byte
                      BCC   AS_L_REASON_4              ; Plenty of room
                      BNE   AS_L_REASON_1              ; Not enough, try garbage collection
                      CMP   MS_Z_006F_FRETOP                  ; Low byte
                      BCC   AS_L_REASON_4              ; Enough room
                                                       ; --------------------------------
AS_L_REASON_1:        PHA                              ; Save (y,a), temp1, and temp2
                      LDX   #MS_Z_009D_FAC - MS_Z_0093_TEMPF1 - 1
                      TYA
AS_L_REASON_2:        PHA
                      LDA   MS_Z_0093_TEMPF1,X
                      DEX
                      BPL   AS_L_REASON_2
                      JSR   AS_GARBAG                  ; Make as much room as possible
                      LDX   #MS_Z_0093_TEMPF1 + 256 - MS_Z_009D_FAC + 1 ; Restore temp1 and temp2
AS_L_REASON_3:        PLA                              ; And (y,a)
                      STA   MS_Z_009D_FAC,X
                      INX
                      BMI   AS_L_REASON_3
                      PLA
                      TAY
                      PLA                              ; Did we find enough room?
                      CPY   MS_Z_006F_FRETOP + 1              ; High byte
                      BCC   AS_L_REASON_4              ; Yes, at least a page
                      BNE   AS_MEMERR                  ; No, mem full err
                      CMP   MS_Z_006F_FRETOP                  ; Low byte
                      BCS   AS_MEMERR                  ; No, mem full err
AS_L_REASON_4:        RTS                              ; Yes, return
                                                       ; --------------------------------
AS_MEMERR:            LDX   #MS_E_ERROM
                                                       ; --------------------------------
                                                       ; Handle an error

                                                       ; (X)=offset in error message table
                                                       ; (Errflg) > 128 if "on err" turned on
                                                       ; (Curlin+1) = $FF if in direct mode
                                                       ; --------------------------------
MS_ERROR:             BIT   AS_ERRFLG                  ; "On err" turned on?
                      BPL   AS_L_ERROR_1               ; No
                      JMP   AS_HANDLERR                ; Yes
AS_L_ERROR_1:         JSR   AS_CRDO                    ; Print <return>
                      JSR   AS_OUTQUES                 ; Print "?"
AS_L_ERROR_2:         LDA   MS_ERRTAB,X
                      PHA                              ; Print message
                      JSR   AS_OUTDO
                      INX
                      PLA
                      BPL   AS_L_ERROR_2
                      JSR   AS_STKINI                  ; Fix stack, et al
                      LDA   #<MS_ERR              ; Print " error" and bell
                      LDY   #>MS_ERR
                                                       ; --------------------------------
                                                       ; Print string at (y,a)
                                                       ; Print current line # unless in direct mode
                                                       ; Fall into warm restart
                                                       ; --------------------------------
AS_PRINT_ERROR_LINNUM:
                      JSR   AS_STROUT                  ; Print string at (y,a)
                      LDY   MS_Z_0075_CURLIN + 1              ; Running, or direct?
                      INY
                      BEQ   AS_RESTART                 ; Was $FF, so direct mode
                      JSR   AS_INPRT                   ; Running, so print line number
                                                       ; --------------------------------
                                                       ; Warm restart entry

                                                       ; Come here from monitor by ctl-c, 0g, 3d0g, or e003g
                                                       ; --------------------------------
AS_RESTART:
                      JSR   AS_CRDO                    ; Print <return>
                      LDX   #"]" | %10000000           ; Prompt character
                      JSR   AS_INLIN2                  ; Read a line
                      STX   MS_Z_00B8_TXTPTR                  ; Set up chrget to scan the line
                      STY   MS_Z_00B8_TXTPTR + 1
                      LSR   AS_ERRFLG                  ; Clear flag
                      JSR   MS_Z_00B1_CHRGET
                      TAX
                      BEQ   AS_RESTART                 ; Empty line
                      LDX   #$FF                       ; $FF in hi-byte of curlin means
                      STX   MS_Z_0075_CURLIN + 1              ; We are in direct mode
                      BCC   AS_NUMBERED_LINE           ; Chrget saw digit, numbered line
                      JSR   AS_PARSE_INPUT_LINE        ; No number, so parse it
                      JMP   AS_TRACE_                  ; And try executing it
                                                       ; --------------------------------
                                                       ; Handle numbered line
                                                       ; --------------------------------
AS_NUMBERED_LINE:
                      LDX   AS_PRGEND                  ; Squash variable table
                      STX   MS_Z_0069_VARTAB
                      LDX   AS_PRGEND + 1
                      STX   MS_Z_0069_VARTAB + 1
                      JSR   AS_LINGET                  ; Get line #
                      JSR   AS_PARSE_INPUT_LINE        ; And parse the input line
                      STY   AS_EOL_PNTR                ; Save index to input buffer
                      JSR   AS_FNDLIN                  ; Is this line # already in program?
                      BCC   AS_PUT_NEW_LINE            ; No
                      LDY   #1                         ; Yes, so delete it
                      LDA   (MS_Z_009B_LOWTR),Y               ; Lowtr points at line
                      STA   MS_Z_005E_INDEX + 1               ; Get high byte of forward pntr
                      LDA   MS_Z_0069_VARTAB
                      STA   MS_Z_005E_INDEX
                      LDA   MS_Z_009B_LOWTR + 1
                      STA   AS_DEST + 1
                      LDA   MS_Z_009B_LOWTR
                      DEY
                      SBC   (MS_Z_009B_LOWTR),Y
                      CLC
                      ADC   MS_Z_0069_VARTAB
                      STA   MS_Z_0069_VARTAB
                      STA   AS_DEST
                      LDA   MS_Z_0069_VARTAB + 1
                      ADC   #$FF
                      STA   MS_Z_0069_VARTAB + 1
                      SBC   MS_Z_009B_LOWTR + 1
                      TAX
                      SEC
                      LDA   MS_Z_009B_LOWTR
                      SBC   MS_Z_0069_VARTAB
                      TAY
                      BCS   AS_L_NUMBERED_LINE_1
                      INX
                      DEC   AS_DEST + 1
AS_L_NUMBERED_LINE_1: CLC
                      ADC   MS_Z_005E_INDEX
                      BCC   AS_L_NUMBERED_LINE_2
                      DEC   MS_Z_005E_INDEX + 1
                      CLC
                                                       ; --------------------------------
AS_L_NUMBERED_LINE_2: LDA   (MS_Z_005E_INDEX),Y               ; Move higher lines of program
                      STA   (AS_DEST),Y                ; Down over the deleted line.
                      INY
                      BNE   AS_L_NUMBERED_LINE_2
                      INC   MS_Z_005E_INDEX + 1
                      INC   AS_DEST + 1
                      DEX
                      BNE   AS_L_NUMBERED_LINE_2
                                                       ; --------------------------------
AS_PUT_NEW_LINE:
                      LDA   MS_BUF            ; Any characters after line #?
                      BEQ   AS_FIX_LINKS               ; No, so nothing to insert.
                      LDA   MS_Z_0073_MEMSIZ                  ; Yes, so make room and insert line
                      LDY   MS_Z_0073_MEMSIZ + 1              ; Wipe string area clean
                      STA   MS_Z_006F_FRETOP
                      STY   MS_Z_006F_FRETOP + 1
                      LDA   MS_Z_0069_VARTAB                  ; Set up bltu subroutine
                      STA   MS_Z_0096_HIGHTR                  ; Insert new line.
                      ADC   AS_EOL_PNTR
                      STA   MS_Z_0094_HIGHDS
                      LDY   MS_Z_0069_VARTAB + 1
                      STY   MS_Z_0096_HIGHTR + 1
                      BCC   AS_L_PUT_NEW_LINE_1
                      INY
AS_L_PUT_NEW_LINE_1:  STY   MS_Z_0094_HIGHDS + 1
                      JSR   AS_BLTU                    ; Make room for the line
                      LDA   MS_Z_0050_LINNUM                  ; Put line number in line image
                      LDY   MS_Z_0050_LINNUM + 1
                      STA   MS_BUF - 2
                      STY   MS_BUF - 1
                      LDA   MS_Z_006D_STREND
                      LDY   MS_Z_006D_STREND + 1
                      STA   MS_Z_0069_VARTAB
                      STY   MS_Z_0069_VARTAB + 1
                      LDY   AS_EOL_PNTR
                                                       ; ---Copy line into program-------
AS_L_PUT_NEW_LINE_2:  LDA   MS_BUF - 5,Y
                      DEY
                      STA   (MS_Z_009B_LOWTR),Y
                      BNE   AS_L_PUT_NEW_LINE_2
                                                       ; --------------------------------
                                                       ; Clear all variables
                                                       ; Re-establish all forward links
                                                       ; --------------------------------
AS_FIX_LINKS:
                      JSR   AS_SETPTRS                 ; Clear all variables
                      LDA   MS_Z_0067_TXTTAB                  ; Point index at start of program
                      LDY   MS_Z_0067_TXTTAB + 1
                      STA   MS_Z_005E_INDEX
                      STY   MS_Z_005E_INDEX + 1
                      CLC
AS_L_FIX_LINKS_1:     LDY   #1                         ; Hi-byte of next forward pntr
                      LDA   (MS_Z_005E_INDEX),Y               ; End of program yet?
                      BNE   AS_L_FIX_LINKS_2           ; No, keep going
                      LDA   MS_Z_0069_VARTAB                  ; Yes
                      STA   AS_PRGEND
                      LDA   MS_Z_0069_VARTAB + 1
                      STA   AS_PRGEND + 1
                      JMP   AS_RESTART
AS_L_FIX_LINKS_2:     LDY   #4                         ; Find end of this line
AS_L_FIX_LINKS_3:     INY                              ; (Note maximum length < 256)
                      LDA   (MS_Z_005E_INDEX),Y
                      BNE   AS_L_FIX_LINKS_3
                      INY                              ; Compute address of next line
                      TYA
                      ADC   MS_Z_005E_INDEX
                      TAX
                      LDY   #0                         ; Store forward pntr in this line
                      STA   (MS_Z_005E_INDEX),Y
                      LDA   MS_Z_005E_INDEX + 1
                      ADC   #0                         ; (Note: this clears carry)
                      INY
                      STA   (MS_Z_005E_INDEX),Y
                      STX   MS_Z_005E_INDEX
                      STA   MS_Z_005E_INDEX + 1
                      BCC   AS_L_FIX_LINKS_1           ; ...Always
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; Read a line, and strip off sign bits
                                                       ; --------------------------------
AS_INLIN:             LDX   #$80                       ; Null prompt
AS_INLIN2:            STX   MS_Z_0033_CQPRMP
                      JSR   MON_GETLN
                      CPX   #239                       ; Maximum line length
                      BCC   AS_L_INLIN2_1
                      LDX   #239                       ; Truncate at 239 chars
AS_L_INLIN2_1:        LDA   #0                         ; Mark end of line with $00 byte
                      STA   MS_BUF,X
                      TXA
                      BEQ   AS_L_INLIN2_3              ; Null input line
AS_L_INLIN2_2:        LDA   MS_BUF - 1,X      ; Drop sign bits
                      AND   #$7F
                      STA   MS_BUF - 1,X
                      DEX
                      BNE   AS_L_INLIN2_2
AS_L_INLIN2_3:        LDA   #0                         ; (Y,x) points at buffer-1
                      LDX   #<(MS_BUF - 1)
                      LDY   #>(MS_BUF - 1)
                      RTS
                                                       ; --------------------------------
AS_INCHR:             JSR   MS_CQINCH                  ; *** Ought to be "bit $C010" ***
                      AND   #$7F
                      RTS
                                                       ; --------------------------------
                                                       ; Tokenize the input line
                                                       ; --------------------------------
AS_PARSE_INPUT_LINE:
                      LDX   MS_Z_00B8_TXTPTR                  ; Index into unparsed line
                      DEX                              ; Prepare for inx at "parse"
                      LDY   #4                         ; Index to parsed output line
                      STY   AS_DATAFLG                 ; Clear sign-bit of dataflg
                      BIT   AS_LOCK                    ; Is this program locked?
                      BPL   AS_PARSE                   ; No, go ahead and parse the line
                      PLA                              ; Yes, ignore input and "run"
                      PLA                              ; The program
                      JSR   AS_SETPTRS                 ; Clear all variables
                      JMP   AS_NEWSTT                  ; Start running
                                                       ; --------------------------------
AS_PARSE:             INX                              ; Next input character
AS_L_PARSE_1:         LDA   MS_BUF,X
                      BIT   AS_DATAFLG                 ; In a "data" statement?
                      BVS   AS_L_PARSE_2               ; Yes (dataflg = $49)
                      CMP   #" " & %01111111           ; Ignore blanks
                      BEQ   AS_PARSE
AS_L_PARSE_2:         STA   MS_Z_000E_ENDCHR
                      CMP   #$22                       ; Start of quotation?
                      BEQ   AS_L_PARSE_13
                      BVS   AS_L_PARSE_9               ; Branch if in "data" statement
                      CMP   #"?" & %01111111           ; Shorthand for "print"?
                      BNE   AS_L_PARSE_3               ; No
                      LDA   #MS_T_PRINTK            ; Yes, replace with "print" token
                      BNE   AS_L_PARSE_9               ; ...Always
AS_L_PARSE_3:         CMP   #"0" & %01111111           ; Is it a digit, colon, or semi-colon?
                      BCC   AS_L_PARSE_4               ; No, punctuation !"#$%&'()*+,-./
                      CMP   #(";" & %01111111) + 1     ;"&%01111111)+1
                      BCC   AS_L_PARSE_9               ; Yes, not a token
                                                       ; --------------------------------
                                                       ; Search token name table for match starting
                                                       ; With current char from input line
                                                       ; --------------------------------
AS_L_PARSE_4:         STY   MS_Z_00AD_STRNG2                  ; Save index to output line
                      LDA   #<(MS_RESLST - $100)
                      STA   MS_Z_009D_FAC                     ; Make pntr for search
                      LDA   #>(MS_RESLST - $100)
                      STA   MS_Z_009D_FAC + 1
                      LDY   #0                         ; Use y-reg with (fac) to address table
                      STY   MS_Z_000F_COUNT                ; Holds current token-$80
                      DEY                              ; Prepare for "iny" a few lines down
                      STX   MS_Z_00B8_TXTPTR                  ; Save position in input line
                      DEX                              ; Prepare for "inx" a few lines down
AS_L_PARSE_5:         INY                              ; Advance pointer to token table
                      BNE   AS_L_PARSE_6               ; Y=y+1 is enough
                      INC   MS_Z_009D_FAC + 1                 ; Also need to bump the page
AS_L_PARSE_6:         INX                              ; Advance pointer to input line
AS_L_PARSE_7:         LDA   MS_BUF,X          ; Next char from input line
                      CMP   #" " & %01111111           ; This char a blank?
                      BEQ   AS_L_PARSE_6               ; Yes, ignore all blanks
                      SEC                              ; No, compare to char in table
                      SBC   (MS_Z_009D_FAC),Y                 ; Same as next char of token name?
                      BEQ   AS_L_PARSE_5               ; Yes, continue matching
                      CMP   #$80                       ; Maybe; was it same except for bit 7?
                      BNE   AS_L_PARSE_14              ; No, skip to next token
                      ORA   MS_Z_000F_COUNT                ; Yes, end of token; get token #
                      CMP   #AS_TOKENDB                ; Did we match "at"?
                      BNE   AS_L_PARSE_8               ; No, so no ambiguity
                      LDA   MS_BUF + 1,X      ; "At" could be "atn" or "a to"
                      CMP   #"N" & %01111111           ; "Atn" has precedence over "at"
                      BEQ   AS_L_PARSE_14              ; It is "atn", find it the hard way
                      CMP   #"O" & %01111111           ; "To" has precedence over "at"
                      BEQ   AS_L_PARSE_14              ; It is "a to", fin it the hard way
                      LDA   #AS_TOKENDB                ; Not "atn" or "a to", so use "at"
                                                       ; --------------------------------
                                                       ; Store character or token in output line
                                                       ; --------------------------------
AS_L_PARSE_8:         LDY   MS_Z_00AD_STRNG2                  ; Get index to output line in y-reg
AS_L_PARSE_9:         INX                              ; Advance input index
                      INY                              ; Advance output index
                      STA   MS_BUF - 5,Y      ; Store char or token
                      LDA   MS_BUF - 5,Y      ; Test for eol or eos
                      BEQ   AS_L_PARSE_17              ; End of line
                      SEC
                      SBC   #":" & %01111111           ; End of statement?
                      BEQ   AS_L_PARSE_10              ; Yes, clear dataflg
                      CMP   #MS_T_DATATK + 128 - $BA  ; "Data" token?
                      BNE   AS_L_PARSE_11              ; No, leave dataflg alone
AS_L_PARSE_10:        STA   AS_DATAFLG                 ; Dataflg = 0 or $83-$3A = $49
AS_L_PARSE_11:        SEC                              ; Is it a "rem" token?
                      SBC   #MS_T_REMTK + 128 - $BA
                      BNE   AS_L_PARSE_1               ; No, continue parsing line
                      STA   MS_Z_000E_ENDCHR                  ; Yes, clear literal flag
                                                       ; --------------------------------
                                                       ; Handle literal (between quotes) or remark,
                                                       ; By copying chars up to endchr.
                                                       ; --------------------------------
AS_L_PARSE_12:        LDA   MS_BUF,X
                      BEQ   AS_L_PARSE_9               ; End of line
                      CMP   MS_Z_000E_ENDCHR
                      BEQ   AS_L_PARSE_9               ; Found endchr
AS_L_PARSE_13:        INY                              ; Next output char
                      STA   MS_BUF - 5,Y
                      INX                              ; Next input char
                      BNE   AS_L_PARSE_12              ; ...Always
                                                       ; --------------------------------
                                                       ; Advance pointer to next token name
                                                       ; --------------------------------
AS_L_PARSE_14:        LDX   MS_Z_00B8_TXTPTR                  ; Get pointer to input line in x-reg
                      INC   MS_Z_000F_COUNT                ; Bump (token # - $80)
AS_L_PARSE_15:        LDA   (MS_Z_009D_FAC),Y                 ; Scan through table for bit7 = 1
                      INY                              ; Next token one beyond that
                      BNE   AS_L_PARSE_16              ; ...Usually enough to bump y-reg
                      INC   MS_Z_009D_FAC + 1                 ; Next set of 256 token chars
AS_L_PARSE_16:        ASL                              ; See if sign bit set on char
                      BCC   AS_L_PARSE_15              ; No, more in this name
                      LDA   (MS_Z_009D_FAC),Y                 ; Yes, at next name.  end of table?
                      BNE   AS_L_PARSE_7               ; No, not end of table
                      LDA   MS_BUF,X          ; Yes, so not a keyword
                      BPL   AS_L_PARSE_8               ; ...Always, copy char as is
                                                       ; ---End of line------------------
AS_L_PARSE_17:        STA   MS_BUF - 3,Y      ; Store another 00 on end
                      DEC   MS_Z_00B8_TXTPTR + 1              ; Set txtptr = input.buffer-1
                      LDA   #<(MS_BUF - 1)
                      STA   MS_Z_00B8_TXTPTR
                      RTS
                                                       ; --------------------------------
                                                       ; Search for line

                                                       ; (Linnum) = line # to find
                                                       ; If not found:  carry = 0
                                                       ; Lowtr points at next line
                                                       ; If found:      carry = 1
                                                       ; Lowtr points at line
                                                       ; --------------------------------
AS_FNDLIN:            LDA   MS_Z_0067_TXTTAB                  ; Search from beginning of program
                      LDX   MS_Z_0067_TXTTAB + 1
AS_FL1:               LDY   #1                         ; Search from (x,a)
                      STA   MS_Z_009B_LOWTR
                      STX   MS_Z_009B_LOWTR + 1
                      LDA   (MS_Z_009B_LOWTR),Y
                      BEQ   AS_L_FL1_3                 ; End of program, and not found
                      INY
                      INY
                      LDA   MS_Z_0050_LINNUM + 1
                      CMP   (MS_Z_009B_LOWTR),Y
                      BCC   AS_RTS_1                   ; If not found
                      BEQ   AS_L_FL1_1
                      DEY
                      BNE   AS_L_FL1_2
AS_L_FL1_1:           LDA   MS_Z_0050_LINNUM
                      DEY
                      CMP   (MS_Z_009B_LOWTR),Y
                      BCC   AS_RTS_1                   ; Past line, not found
                      BEQ   AS_RTS_1                   ; If found
AS_L_FL1_2:           DEY
                      LDA   (MS_Z_009B_LOWTR),Y
                      TAX
                      DEY
                      LDA   (MS_Z_009B_LOWTR),Y
                      BCS   AS_FL1                     ; Always
AS_L_FL1_3:           CLC                              ; Return carry = 0
AS_RTS_1:             RTS
                                                       ; --------------------------------
                                                       ; "New" statement
                                                       ; --------------------------------
MS_SCRATH:               BNE   AS_RTS_1                   ; Ignore if more to the statement
AS_SCRTCH:            LDA   #0
                      STA   AS_LOCK
                      TAY
                      STA   (MS_Z_0067_TXTTAB),Y
                      INY
                      STA   (MS_Z_0067_TXTTAB),Y
                      LDA   MS_Z_0067_TXTTAB
                      ADC   #2                         ; (Carry wasn't cleared, so "new" usually
                      STA   MS_Z_0069_VARTAB                  ; Adds 3, whereas "fp" adds 2.)
                      STA   AS_PRGEND
                      LDA   MS_Z_0067_TXTTAB + 1
                      ADC   #0
                      STA   MS_Z_0069_VARTAB + 1
                      STA   AS_PRGEND + 1
                                                       ; --------------------------------
AS_SETPTRS:
                      JSR   AS_STXTPT                  ; Set txtptr to txttab - 1
                      LDA   #0                         ; (This could have been ".hs 2c")
                                                       ; --------------------------------
                                                       ; "Clear" statement
                                                       ; --------------------------------
MS_CLEAR:             BNE   AS_RTS_2                   ; Ignore if not at end of statement
AS_CLEARC:            LDA   MS_Z_0073_MEMSIZ                  ; Clear string area
                      LDY   MS_Z_0073_MEMSIZ + 1
                      STA   MS_Z_006F_FRETOP
                      STY   MS_Z_006F_FRETOP + 1
                      LDA   MS_Z_0069_VARTAB                  ; Clear array area
                      LDY   MS_Z_0069_VARTAB + 1
                      STA   MS_Z_006B_ARYTAB
                      STY   MS_Z_006B_ARYTAB + 1
                      STA   MS_Z_006D_STREND                  ; Low end of free space
                      STY   MS_Z_006D_STREND + 1
                      JSR   MS_RESTOR                 ; Set "data" pointer to beginning
                                                       ; --------------------------------
AS_STKINI:            LDX   #MS_Z_0055_TEMPST
                      STX   MS_Z_0052_TEMPPT
                      PLA                              ; Save return address
                      TAY
                      PLA
                      LDX   #$F8                       ; Start stack at $F8,
                      TXS                              ; Leaving room for parsing lines
                      PHA                              ; Restore return address
                      TYA
                      PHA
                      LDA   #0
                      STA   MS_Z_0079_OLDTXT + 1
                      STA   MS_Z_0014_SUBFLG
AS_RTS_2:             RTS
                                                       ; --------------------------------
                                                       ; Set txtptr to beginning of program
                                                       ; --------------------------------
AS_STXTPT:            CLC                              ; Txtptr = txttab - 1
                      LDA   MS_Z_0067_TXTTAB
                      ADC   #$FF
                      STA   MS_Z_00B8_TXTPTR
                      LDA   MS_Z_0067_TXTTAB + 1
                      ADC   #$FF
                      STA   MS_Z_00B8_TXTPTR + 1
                      RTS
                                                       ; --------------------------------
                                                       ; "List" statement
                                                       ; --------------------------------
MS_LIST:              BCC   AS_L_LIST_1                ; No  line # specified
                      BEQ   AS_L_LIST_1                ; ---Ditto---
                      CMP   #MS_T_MINUTK            ; If dash or comma, start at line 0
                      BEQ   AS_L_LIST_1                ; Is is a dash
                      CMP   #"," & %01111111           ; Comma?
                      BNE   AS_RTS_2                   ; No, error
AS_L_LIST_1:          JSR   AS_LINGET                  ; Convert line number if any
                      JSR   AS_FNDLIN                  ; Point lowtr to 1st line
                      JSR   MS_Z_00B7_CHRGOT                  ; Range specified?
                      BEQ   AS_L_LIST_3                ; No
                      CMP   #MS_T_MINUTK
                      BEQ   AS_L_LIST_2
                      CMP   #"," & %01111111
                      BNE   AS_RTS_1
AS_L_LIST_2:          JSR   MS_Z_00B1_CHRGET                  ; Get next char
                      JSR   AS_LINGET                  ; Convert second line #
                      BNE   AS_RTS_2                   ; Branch if syntax err
AS_L_LIST_3:          PLA                              ; Pop return adress
                      PLA                              ; (Get back by "jmp newstt")
                      LDA   MS_Z_0050_LINNUM                  ; If no second number, use $FFFF
                      ORA   MS_Z_0050_LINNUM + 1
                      BNE   AS_LIST_0                  ; There was a second number
                      LDA   #$FF                       ; Max end range
                      STA   MS_Z_0050_LINNUM
                      STA   MS_Z_0050_LINNUM + 1
AS_LIST_0:            LDY   #1
                      LDA   (MS_Z_009B_LOWTR),Y               ; High byte of link
                      BEQ   AS_LIST_3                  ; End of program
                      JSR   AS_ISCNTC                  ; Check if control-c has been typed
                      JSR   AS_CRDO                    ; No, print <return>
                      INY
                      LDA   (MS_Z_009B_LOWTR),Y               ; Get line #, compare with end range
                      TAX
                      INY
                      LDA   (MS_Z_009B_LOWTR),Y
                      CMP   MS_Z_0050_LINNUM + 1
                      BNE   AS_L_LIST_0_5
                      CPX   MS_Z_0050_LINNUM
                      BEQ   AS_L_LIST_0_6              ; On last line of range
AS_L_LIST_0_5:        BCS   AS_LIST_3                  ; Finished the range
                                                       ; ---List one line----------------
AS_L_LIST_0_6:        STY   MS_Z_0085_FORPNT
                      JSR   AS_LINPRT                  ; Print line # from x,a
                      LDA   #" " & %01111111           ; Print space after line #
AS_LIST_1:            LDY   MS_Z_0085_FORPNT
                      AND   #$7F
AS_LIST_2:            JSR   AS_OUTDO
                      LDA   MON_CH                     ; If past column 33, start a new line
                      CMP   #33
                      BCC   AS_L_LIST_2_1              ; < 33
                      JSR   AS_CRDO                    ; Print <return>
                      LDA   #5                         ; And tab over 5
                      STA   MON_CH
AS_L_LIST_2_1:        INY
                      LDA   (MS_Z_009B_LOWTR),Y
                      BNE   AS_LIST_4                  ; Not end of line yet
                      TAY                              ; End of line
                      LDA   (MS_Z_009B_LOWTR),Y               ; Get link to next line
                      TAX
                      INY
                      LDA   (MS_Z_009B_LOWTR),Y
                      STX   MS_Z_009B_LOWTR                   ; Point to next line
                      STA   MS_Z_009B_LOWTR + 1
                      BNE   AS_LIST_0                  ; Branch if not end of program
AS_LIST_3:            LDA   #$0D                       ; Print <return>
                      JSR   AS_OUTDO
                      JMP   AS_NEWSTT                  ; To next statement
                                                       ; --------------------------------
AS_GETCHR:            INY                              ; Pick up char from table
                      BNE   AS_L_GETCHR_1
                      INC   MS_Z_009D_FAC + 1
AS_L_GETCHR_1:        LDA   (MS_Z_009D_FAC),Y
                      RTS
                                                       ; --------------------------------
AS_LIST_4:            BPL   AS_LIST_2                  ; Branch if not a token
                      SEC
                      SBC   #$7F                       ; Convert token to index
                      TAX
                      STY   MS_Z_0085_FORPNT                  ; Save line pointer
                      LDY   #<(MS_RESLST - $100)
                      STY   MS_Z_009D_FAC                     ; Point fac to table
                      LDY   #>(MS_RESLST - $100)
                      STY   MS_Z_009D_FAC + 1
                      LDY   #$FF
AS_L_LIST_4_1:        DEX                              ; Skip keywords until reach this one
                      BEQ   AS_L_LIST_4_3
AS_L_LIST_4_2:        JSR   AS_GETCHR                  ; Bump y, get char from table
                      BPL   AS_L_LIST_4_2              ; Not at end of keyword yet
                      BMI   AS_L_LIST_4_1              ; End of keyword, always branches
AS_L_LIST_4_3:        LDA   #" " & %01111111           ; Found the right keyword
                      JSR   AS_OUTDO                   ; Print leading space
AS_L_LIST_4_4:        JSR   AS_GETCHR                  ; Print the keyword
                      BMI   AS_L_LIST_4_5              ; Last char of keyword
                      JSR   AS_OUTDO
                      BNE   AS_L_LIST_4_4              ; ...Always
AS_L_LIST_4_5:        JSR   AS_OUTDO                   ; Print last char of keyword
                      LDA   #" " & %01111111           ; Print trailing space
                      BNE   AS_LIST_1                  ; ...Always, back to actual line
                                                       ; --------------------------------
                                                       ; "For" statement

                                                       ; For pushes 18 bytes on the stack:
                                                       ; 2 -- Txtptr
                                                       ; 2 -- Line number
                                                       ; 5 -- Initial (current)  for variable value
                                                       ; 1 -- Step sign
                                                       ; 5 -- Step value
                                                       ; 2 -- Address of for variable in vartab
                                                       ; 1 -- For token ($81)
                                                       ; --------------------------------
MS_FOR:               LDA   #$80
                      STA   MS_Z_0014_SUBFLG                  ; Subscripts not allowed
                      JSR   MS_LET                     ; Do <var> = <exp>, store addr in forpnt
                      JSR   MS_FNDFOR                ; Is this for variable active?
                      BNE   AS_L_FOR_1                 ; No
                      TXA                              ; Yes, cancel it and enclosed loops
                      ADC   #15                        ; Carry=1, this adds 16
                      TAX                              ; X was already s+2
                      TXS
AS_L_FOR_1:           PLA                              ; Pop return address too
                      PLA
                      LDA   #9                         ; Be certain enough room in stack
                      JSR   AS_CHKMEM
                      JSR   AS_DATAN                   ; Scan ahead to next statement
                      CLC                              ; Push statement address on stack
                      TYA
                      ADC   MS_Z_00B8_TXTPTR
                      PHA
                      LDA   MS_Z_00B8_TXTPTR + 1
                      ADC   #0
                      PHA
                      LDA   MS_Z_0075_CURLIN + 1              ; Push line number on stack
                      PHA
                      LDA   MS_Z_0075_CURLIN
                      PHA
                      LDA   #MS_T_TOTK
                      JSR   AS_SYNCHR                  ; Require "to"
                      JSR   AS_CHKNUM                  ; <Var> = <exp> must be numeric
                      JSR   AS_FRMNUM                  ; Get final value, must be numeric
                      LDA   MS_Z_00A2_FACSGN                ; Put sign into value in fac
                      ORA   #$7F
                      AND   MS_Z_009D_FAC + 1
                      STA   MS_Z_009D_FAC + 1
                      LDA   #<AS_STEP                  ; Set up for return
                      LDY   #>AS_STEP                  ; To step
                      STA   MS_Z_005E_INDEX
                      STY   MS_Z_005E_INDEX + 1
                      JMP   AS_FRM_STACK_3             ; Returns by "jmp (index)"
                                                       ; --------------------------------
                                                       ; "Step" phrase of "for" statement
                                                       ; --------------------------------
AS_STEP:              LDA   #<AS_CON_ONE               ; Step default=1
                      LDY   #>AS_CON_ONE
                      JSR   AS_LOAD_FAC_FROM_YA
                      JSR   MS_Z_00B7_CHRGOT
                      CMP   #MS_T_STEPTK
                      BNE   AS_L_STEP_1                ; Use default value of 1.0
                      JSR   MS_Z_00B1_CHRGET                  ; Step specified, get it
                      JSR   AS_FRMNUM
AS_L_STEP_1:          JSR   AS_SIGN
                      JSR   AS_FRM_STACK_2
                      LDA   MS_Z_0085_FORPNT + 1
                      PHA
                      LDA   MS_Z_0085_FORPNT
                      PHA
                      LDA   #MS_T_FORTK
                      PHA
                                                       ; --------------------------------
                                                       ; Perform next statement
                                                       ; --------------------------------
AS_NEWSTT:            TSX                              ; Remember the stack position
                      STX   AS_REMSTK
                      JSR   AS_ISCNTC                  ; See if control-c has been typed
                      LDA   MS_Z_00B8_TXTPTR                  ; No, keep executing
                      LDY   MS_Z_00B8_TXTPTR + 1
                      LDX   MS_Z_0075_CURLIN + 1              ; =$FF if in direct mode
                      INX                              ; $FF turns into $00
                      BEQ   AS_L_NEWSTT_1              ; In direct mode
                      STA   MS_Z_0079_OLDTXT                 ; In running mode
                      STY   MS_Z_0079_OLDTXT + 1
AS_L_NEWSTT_1:        LDY   #0
                      LDA   (MS_Z_00B8_TXTPTR),Y              ; End of line yet?
                      BNE   AS_COLON_                  ; No
                      LDY   #2                         ; Yes, see if end of program
                      LDA   (MS_Z_00B8_TXTPTR),Y
                      CLC
                      BEQ   AS_GOEND                   ; Yes, end of program
                      INY
                      LDA   (MS_Z_00B8_TXTPTR),Y              ; Get line # of next line
                      STA   MS_Z_0075_CURLIN
                      INY
                      LDA   (MS_Z_00B8_TXTPTR),Y
                      STA   MS_Z_0075_CURLIN + 1
                      TYA                              ; Adjust txtptr to start
                      ADC   MS_Z_00B8_TXTPTR                  ; Of new line
                      STA   MS_Z_00B8_TXTPTR
                      BCC   AS_L_NEWSTT_2
                      INC   MS_Z_00B8_TXTPTR + 1
AS_L_NEWSTT_2:
                                                       ; --------------------------------
AS_TRACE_:            BIT   AS_TRCFLG                  ; Is trace on?
                      BPL   AS_L_TRACE__1              ; No
                      LDX   MS_Z_0075_CURLIN + 1              ; Yes, are we running?
                      INX
                      BEQ   AS_L_TRACE__1              ; Not running, so don't trace
                      LDA   #"#" & %01111111           ; Print "#"
                      JSR   AS_OUTDO
                      LDX   MS_Z_0075_CURLIN
                      LDA   MS_Z_0075_CURLIN + 1
                      JSR   AS_LINPRT                  ; Print line number
                      JSR   AS_OUTSP                   ; Print trailing space
AS_L_TRACE__1:        JSR   MS_Z_00B1_CHRGET                  ; Get first chr of statement
                      JSR   AS_EXECUTE_STATEMENT       ; And start processing
                      JMP   AS_NEWSTT                  ; Back for more
                                                       ; --------------------------------
AS_GOEND:             BEQ   AS_END4
                                                       ; --------------------------------
                                                       ; Execute a statement

                                                       ; (A) is first char of statement
                                                       ; Carry is set
                                                       ; --------------------------------
AS_EXECUTE_STATEMENT:
                      BEQ   AS_RTS_3                   ; End of line, null statement
AS_EXECUTE_STATEMENT_1:
                      SBC   #$80                       ; First char a token?
                      BCC   AS_L_EXECUTE_STATEMENT_1_1 ; Not token, must be "let"
                      CMP   #$40                       ; Statement-type token?
                      BCS   AS_SYNERR_1                ; No, syntax error
                      ASL                              ; Double to get index
                      TAY                              ; Into address table
                      LDA   MS_STMDSP + 1,Y
                      PHA                              ; Put address on stack
                      LDA   MS_STMDSP,Y
                      PHA
                      JMP   MS_Z_00B1_CHRGET                  ; Get next chr & rts to routine
                                                       ; --------------------------------
AS_L_EXECUTE_STATEMENT_1_1: JMP   MS_LET                     ; Must be <var> = <exp>
                                                       ; --------------------------------
AS_COLON_:            CMP   #":" & %01111111
                      BEQ   AS_TRACE_
AS_SYNERR_1:          JMP   AS_SYNERR
                                                       ; --------------------------------
                                                       ; "Restore" statement
                                                       ; --------------------------------
MS_RESTOR:
                      SEC                              ; Set datptr to beginning of program
                      LDA   MS_Z_0067_TXTTAB
                      SBC   #1
                      LDY   MS_Z_0067_TXTTAB + 1
                      BCS   AS_SETDA
                      DEY
                                                       ; ---Set datptr to y,a------------
AS_SETDA:             STA   MS_Z_007D_DATPTR
                      STY   MS_Z_007D_DATPTR + 1
AS_RTS_3:             RTS
                                                       ; --------------------------------
                                                       ; See if control-c typed
                                                       ; --------------------------------
AS_ISCNTC:            LDA   AS_KEYBOARD
                      CMP   #$83
                      BEQ   AS_L_ISCNTC_1
                      RTS
AS_L_ISCNTC_1:        JSR   AS_INCHR                   ; <<< Should be "bit $C010" >>>
AS_CONTROL_C_TYPED:
                      LDX   #$FF                       ; Control c attempted
                      BIT   AS_ERRFLG                  ; "On err" enabled?
                      BPL   AS_L_CONTROL_C_TYPED_2     ; No
                      JMP   AS_HANDLERR                ; Yes, return err code = 255
AS_L_CONTROL_C_TYPED_2: CMP   #3                         ; Since it is ctrl-c, set z and c bits
                                                       ; --------------------------------
                                                       ; "Stop" statement
                                                       ; --------------------------------
MS_STOP:              BCS   AS_END2                    ; Carry=1 to force printing "break at.."
                                                       ; --------------------------------
                                                       ; "End" statement
                                                       ; --------------------------------
MS_END:              CLC                              ; Carry=0 to avoid printing message
AS_END2:              BNE   AS_RTS_4                   ; If not end of statement, do nothing
                      LDA   MS_Z_00B8_TXTPTR
                      LDY   MS_Z_00B8_TXTPTR + 1
                      LDX   MS_Z_0075_CURLIN + 1
                      INX                              ; Running?
                      BEQ   AS_L_END2_1                ; No, direct mode
                      STA   MS_Z_0079_OLDTXT
                      STY   MS_Z_0079_OLDTXT + 1
                      LDA   MS_Z_0075_CURLIN
                      LDY   MS_Z_0075_CURLIN + 1
                      STA   MS_Z_0077_OLDLIN
                      STY   MS_Z_0077_OLDLIN + 1
AS_L_END2_1:          PLA
                      PLA
AS_END4:              LDA   #<MS_BRKTXT              ; " Break" and bell
                      LDY   #>MS_BRKTXT
                      BCC   AS_L_END4_1
                      JMP   AS_PRINT_ERROR_LINNUM
AS_L_END4_1:          JMP   AS_RESTART
                                                       ; --------------------------------
                                                       ; "Cont" command
                                                       ; --------------------------------
MS_CONT:              BNE   AS_RTS_4                   ; If not end of statement, do nothing
                      LDX   #MS_E_ERRCN
                      LDY   MS_Z_0079_OLDTXT + 1             ; Meaningful re-entry?
                      BNE   AS_L_CONT_1                ; Yes
                      JMP   MS_ERROR                   ; No
AS_L_CONT_1:          LDA   MS_Z_0079_OLDTXT                 ; Restore txtptr
                      STA   MS_Z_00B8_TXTPTR
                      STY   MS_Z_00B8_TXTPTR + 1
                      LDA   MS_Z_0077_OLDLIN                  ; Restore line number
                      LDY   MS_Z_0077_OLDLIN + 1
                      STA   MS_Z_0075_CURLIN
                      STY   MS_Z_0075_CURLIN + 1
AS_RTS_4:             RTS
                                                       ; --------------------------------
                                                       ; "Save" command
                                                       ; Writes program on cassette tape
                                                       ; --------------------------------
MS_SAVE:              SEC
                      LDA   AS_PRGEND                  ; Compute program length
                      SBC   MS_Z_0067_TXTTAB
                      STA   MS_Z_0050_LINNUM
                      LDA   AS_PRGEND + 1
                      SBC   MS_Z_0067_TXTTAB + 1
                      STA   MS_Z_0050_LINNUM + 1
                      JSR   AS_VARTIO                  ; Set up to write 3 byte header
                      JSR   MS_CQCOUT                  ; Write 'em
                      JSR   AS_PROGIO                  ; Set up to write the program
                      JMP   MS_CQCOUT                  ; Write it
                                                       ; --------------------------------
                                                       ; "Load" command
                                                       ; Reads a program from cassette tape
                                                       ; --------------------------------
MS_LOAD:              JSR   AS_VARTIO                  ; Set up to read 3 byte header
                      JSR   MS_CQCSIN                   ; Read length, lock byte
                      CLC
                      LDA   MS_Z_0067_TXTTAB                  ; Compute end address
                      ADC   MS_Z_0050_LINNUM
                      STA   MS_Z_0069_VARTAB
                      LDA   MS_Z_0067_TXTTAB + 1
                      ADC   MS_Z_0050_LINNUM + 1
                      STA   MS_Z_0069_VARTAB + 1
                      LDA   MS_Z_0052_TEMPPT                  ; Lock byte
                      STA   AS_LOCK
                      JSR   AS_PROGIO                  ; Set up to read program
                      JSR   MS_CQCSIN                   ; Read it
                      BIT   AS_LOCK                    ; If locked, start running now
                      BPL   AS_L_LOAD_1                ; Not locked
                      JMP   AS_SETPTRS                 ; Locked, start running
AS_L_LOAD_1:          JMP   AS_FIX_LINKS               ; Just fix forward pointers
                                                       ; --------------------------------
AS_VARTIO:            LDA   #MS_Z_0050_LINNUM                 ; Set up to read/write 3 byte header
                      LDY   #0
                      STA   MON_A1L
                      STY   MON_A1H
                      LDA   #MS_Z_0052_TEMPPT
                      STA   MON_A2L
                      STY   MON_A2H
                      STY   AS_LOCK
                      RTS
                                                       ; --------------------------------
AS_PROGIO:            LDA   MS_Z_0067_TXTTAB                  ; Set up to read/write program
                      LDY   MS_Z_0067_TXTTAB + 1
                      STA   MON_A1L
                      STY   MON_A1H
                      LDA   MS_Z_0069_VARTAB
                      LDY   MS_Z_0069_VARTAB + 1
                      STA   MON_A2L
                      STY   MON_A2H
                      RTS
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; "Run" command
                                                       ; --------------------------------
MS_RUN:               PHP                              ; Save status while subtracting
                      DEC   MS_Z_0075_CURLIN + 1              ; If was $FF (meaning direct mode)
                                                       ; Make it "running mode"
                      PLP                              ; Get status again (from chrget)
                      BNE   AS_L_RUN_1                 ; Probably a line number
                      JMP   AS_SETPTRS                 ; Start at beginning of program
AS_L_RUN_1:           JSR   AS_CLEARC                  ; Clear variables
                      JMP   AS_GO_TO_LINE              ; Join gosub statement
                                                       ; --------------------------------
                                                       ; "Gosub" statement

                                                       ; Leaves 7 bytes on stack:
                                                       ; 2 -- Return address (newstt)
                                                       ; 2 -- Txtptr
                                                       ; 2 -- Line #
                                                       ; 1 -- Gosub token ($B0)
                                                       ; --------------------------------
MS_GOSUB:             LDA   #3                         ; Be sure enough room on stack
                      JSR   AS_CHKMEM
                      LDA   MS_Z_00B8_TXTPTR + 1
                      PHA
                      LDA   MS_Z_00B8_TXTPTR
                      PHA
                      LDA   MS_Z_0075_CURLIN + 1
                      PHA
                      LDA   MS_Z_0075_CURLIN
                      PHA
                      LDA   #MS_T_GOSUTK
                      PHA
AS_GO_TO_LINE:
                      JSR   MS_Z_00B7_CHRGOT
                      JSR   MS_GOTO
                      JMP   AS_NEWSTT
                                                       ; --------------------------------
                                                       ; "Goto" statement
                                                       ; Also used by "run" and "gosub"
                                                       ; --------------------------------
MS_GOTO:              JSR   AS_LINGET                  ; Get goto line
                      JSR   AS_REMN                    ; Point y to eol
                      LDA   MS_Z_0075_CURLIN + 1              ; Is current page < goto page?
                      CMP   MS_Z_0050_LINNUM + 1
                      BCS   AS_L_GOTO_1                ; Search from prog start if not
                      TYA                              ; Otherwise search from next line
                      SEC
                      ADC   MS_Z_00B8_TXTPTR
                      LDX   MS_Z_00B8_TXTPTR + 1
                      BCC   AS_L_GOTO_2
                      INX
                      BCS   AS_L_GOTO_2
AS_L_GOTO_1:          LDA   MS_Z_0067_TXTTAB                  ; Get program beginning
                      LDX   MS_Z_0067_TXTTAB + 1
AS_L_GOTO_2:          JSR   AS_FL1                     ; Search for goto line
                      BCC   AS_UNDERR                  ; Error if not there
                      LDA   MS_Z_009B_LOWTR                   ; Txtptr = start of the destination line
                      SBC   #1
                      STA   MS_Z_00B8_TXTPTR
                      LDA   MS_Z_009B_LOWTR + 1
                      SBC   #0
                      STA   MS_Z_00B8_TXTPTR + 1
AS_RTS_5:             RTS                              ; Return to newstt or gosub
                                                       ; --------------------------------
                                                       ; "Pop" and "return" statements
                                                       ; --------------------------------
MS_RETURN:               BNE   AS_RTS_5
                      LDA   #$FF
                      STA   MS_Z_0085_FORPNT                  ; <<< Bug: should be forpnt+1 >>>
                                                       ; <<< See "all about applesoft", pages 100,101 >>>
                      JSR   MS_FNDFOR                ; To cancel for/next in sub
                      TXS
                      CMP   #MS_T_GOSUTK            ; Last gosub found?
                      BEQ   AS_RETURN
                      LDX   #MS_E_ERRRG
                      .byte $2C                        ; Fake
AS_UNDERR:            LDX   #MS_E_ERRUS
                      JMP   MS_ERROR
                                                       ; --------------------------------
AS_SYNERR_2:          JMP   AS_SYNERR
                                                       ; --------------------------------
AS_RETURN:            PLA                              ; Discard gosub token
                      PLA
                      CPY   #<(AS_TOKEN_POP * 2)
                      BEQ   AS_PULL3                   ; Branch if a pop
                      STA   MS_Z_0075_CURLIN                  ; Pull line #
                      PLA
                      STA   MS_Z_0075_CURLIN + 1
                      PLA
                      STA   MS_Z_00B8_TXTPTR                  ; Pull txtptr
                      PLA
                      STA   MS_Z_00B8_TXTPTR + 1
                                                       ; --------------------------------
                                                       ; "Data" statement
                                                       ; Executed by skipping to next colon or eol
                                                       ; --------------------------------
MS_DATA:              JSR   AS_DATAN                   ; Move to next statement
                                                       ; --------------------------------
                                                       ; Add (y) to txtptr
                                                       ; --------------------------------
AS_ADDON:             TYA
                      CLC
                      ADC   MS_Z_00B8_TXTPTR
                      STA   MS_Z_00B8_TXTPTR
                      BCC   AS_L_ADDON_1
                      INC   MS_Z_00B8_TXTPTR + 1
AS_L_ADDON_1:
AS_RTS_6:             RTS
                                                       ; --------------------------------
                                                       ; Scan ahead to next ":" or eol
                                                       ; --------------------------------
AS_DATAN:             LDX   #":" & %01111111           ; Get offset in y to eol or ":"
                      .byte $2C                        ; Fake
                                                       ; --------------------------------
AS_REMN:              LDX   #0                         ; To eol only
                      STX   MS_Z_000D_CHARAC
                      LDY   #0
                      STY   MS_Z_000E_ENDCHR
AS_L_REMN_1:          LDA   MS_Z_000E_ENDCHR                  ; Trick to count quote parity
                      LDX   MS_Z_000D_CHARAC
                      STA   MS_Z_000D_CHARAC
                      STX   MS_Z_000E_ENDCHR
AS_L_REMN_2:          LDA   (MS_Z_00B8_TXTPTR),Y
                      BEQ   AS_RTS_6                   ; End of line
                      CMP   MS_Z_000E_ENDCHR
                      BEQ   AS_RTS_6                   ; Colon if looking for colons
                      INY
                      CMP   #$22
                      BNE   AS_L_REMN_2
                      BEQ   AS_L_REMN_1                ; ...Always
                                                       ; --------------------------------
AS_PULL3:             PLA
                      PLA
                      PLA
                      RTS
                                                       ; --------------------------------
                                                       ; "If" statement
                                                       ; --------------------------------
MS_IF:                JSR   AS_FRMEVL
                      JSR   MS_Z_00B7_CHRGOT
                      CMP   #MS_T_GOTOTK
                      BEQ   AS_L_IF_1
                      LDA   #MS_T_THENTK
                      JSR   AS_SYNCHR
AS_L_IF_1:            LDA   MS_Z_009D_FAC                     ; Condition true or false?
                      BNE   AS_IF_TRUE                 ; Branch if true
                                                       ; --------------------------------
                                                       ; "Rem" statement, or false "if" statement
                                                       ; --------------------------------
MS_REM:               JSR   AS_REMN                    ; Skip rest of line
                      BEQ   AS_ADDON                   ; ...Always
                                                       ; --------------------------------
AS_IF_TRUE:
                      JSR   MS_Z_00B7_CHRGOT                  ; Command or number?
                      BCS   AS_L_IF_TRUE_1             ; Command
                      JMP   MS_GOTO                    ; Number
AS_L_IF_TRUE_1:       JMP   AS_EXECUTE_STATEMENT
                                                       ; --------------------------------
                                                       ; "On" statement

                                                       ; On <exp> goto <list>
                                                       ; On <exp> gosub <list>
                                                       ; --------------------------------
MS_ONGOTO:            JSR   AS_GETBYT                  ; Evaluate <exp>, as byte in fac+4
                      PHA                              ; Save next char on stack
                      CMP   #MS_T_GOSUTK
                      BEQ   AS_ON_2
AS_ON_1:              CMP   #MS_T_GOTOTK
                      BNE   AS_SYNERR_2
AS_ON_2:              DEC   MS_Z_009D_FAC + 4                 ; Counted to right one yet?
                      BNE   AS_L_ON_2_3                ; No, keep looking
                      PLA                              ; Yes, retrieve cmd
                      JMP   AS_EXECUTE_STATEMENT_1     ; And go.
AS_L_ON_2_3:          JSR   MS_Z_00B1_CHRGET                  ; Prime convert subroutine
                      JSR   AS_LINGET                  ; Convert line #
                      CMP   #"," & %01111111           ; Terminate with comma?
                      BEQ   AS_ON_2                    ; Yes
                      PLA                              ; No, end of list, so ignore
AS_RTS_7:             RTS
                                                       ; --------------------------------
                                                       ; Convert line number
                                                       ; --------------------------------
AS_LINGET:            LDX   #0                         ; Asc # to hex address
                      STX   MS_Z_0050_LINNUM                  ; In linnum.
                      STX   MS_Z_0050_LINNUM + 1
AS_L_LINGET_1:        BCS   AS_RTS_7                   ; Not a digit
                      SBC   #("0" & %01111111) - 1     ; Convert digit to binary
                      STA   MS_Z_000D_CHARAC                  ; Save the digit
                      LDA   MS_Z_0050_LINNUM + 1              ; Check range
                      STA   MS_Z_005E_INDEX
                      CMP   #>6400                     ; Line # too large?
                      BCS   AS_ON_1                    ; Yes, > 63999, go indirectly to
                                                       ; "Syntax error".
                                                       ; <<<<<Dangerous code>>>>>
                                                       ; Note that if (a) = $AB on the line above,
                                                       ; On_1 will compare = and cause a catastrophic
                                                       ; Jump to $22D9 (for goto), or other locations
                                                       ; For other calls to linget.

                                                       ; You can see this is you first put "brk" in $22D9,
                                                       ; Then type "go to 437761".

                                                       ; Any value from 437760 through 440319 will cause
                                                       ; The problem.  ($AB00 - $ABFF)
                                                       ; <<<<<Dangerous code>>>>>
                      LDA   MS_Z_0050_LINNUM                  ; Multiply by ten
                      ASL
                      ROL   MS_Z_005E_INDEX
                      ASL
                      ROL   MS_Z_005E_INDEX
                      ADC   MS_Z_0050_LINNUM
                      STA   MS_Z_0050_LINNUM
                      LDA   MS_Z_005E_INDEX
                      ADC   MS_Z_0050_LINNUM + 1
                      STA   MS_Z_0050_LINNUM + 1
                      ASL   MS_Z_0050_LINNUM
                      ROL   MS_Z_0050_LINNUM + 1
                      LDA   MS_Z_0050_LINNUM
                      ADC   MS_Z_000D_CHARAC                  ; Add digit
                      STA   MS_Z_0050_LINNUM
                      BCC   AS_L_LINGET_2
                      INC   MS_Z_0050_LINNUM + 1
AS_L_LINGET_2:        JSR   MS_Z_00B1_CHRGET                  ; Get next char
                      JMP   AS_L_LINGET_1              ; More converting
                                                       ; --------------------------------
                                                       ; "Let" statement

                                                       ; Let <var> = <exp>
                                                       ; <Var> = <exp>
                                                       ; --------------------------------
MS_LET:               JSR   AS_PTRGET                  ; Get <var>
                      STA   MS_Z_0085_FORPNT
                      STY   MS_Z_0085_FORPNT + 1
                      LDA   #MS_T_EQULTK
                      JSR   AS_SYNCHR
                      LDA   MS_Z_0011_VALTYP + 1              ; Save variable type
                      PHA
                      LDA   MS_Z_0011_VALTYP
                      PHA
                      JSR   AS_FRMEVL                  ; Evaluate <exp>
                      PLA
                      ROL
                      JSR   AS_CHKVAL
                      BNE   AS_LET_STRING
                      PLA
                                                       ; --------------------------------
AS_LET2:              BPL   AS_L_LET2_1                ; Real variable
                      JSR   AS_ROUND_FAC               ; Integer var: round to 32 bits
                      JSR   AS_AYINT                   ; Truncate to 16-bits
                      LDY   #0
                      LDA   MS_Z_009D_FAC + 3
                      STA   (MS_Z_0085_FORPNT),Y
                      INY
                      LDA   MS_Z_009D_FAC + 4
                      STA   (MS_Z_0085_FORPNT),Y
                      RTS
                                                       ; --------------------------------
                                                       ; Real variable = expression
                                                       ; --------------------------------
AS_L_LET2_1:          JMP   AS_SETFOR
                                                       ; --------------------------------
AS_LET_STRING:
                      PLA
                                                       ; --------------------------------
                                                       ; Install string, descriptor address is at fac+3,4
                                                       ; --------------------------------
AS_PUTSTR:            LDY   #2                         ; String data already in string area?
                      LDA   (MS_Z_009D_FAC + 3),Y             ; (String area is btwn fretop
                      CMP   MS_Z_006F_FRETOP + 1              ; Himem)
                      BCC   AS_L_PUTSTR_2              ; Yes, data already up there
                      BNE   AS_L_PUTSTR_1              ; No
                      DEY                              ; Maybe, test low byte of pointer
                      LDA   (MS_Z_009D_FAC + 3),Y
                      CMP   MS_Z_006F_FRETOP
                      BCC   AS_L_PUTSTR_2              ; Yes, already there
AS_L_PUTSTR_1:        LDY   MS_Z_009D_FAC + 4                 ; No. descriptor already among variables?
                      CPY   MS_Z_0069_VARTAB + 1
                      BCC   AS_L_PUTSTR_2              ; No
                      BNE   AS_L_PUTSTR_3              ; Yes
                      LDA   MS_Z_009D_FAC + 3                 ; Maybe, compare lo-byte
                      CMP   MS_Z_0069_VARTAB
                      BCS   AS_L_PUTSTR_3              ; Yes, descriptor is among variables
AS_L_PUTSTR_2:        LDA   MS_Z_009D_FAC + 3                 ; Either string already on top, or
                      LDY   MS_Z_009D_FAC + 4                 ; Descriptor is not a variable
                      JMP   AS_L_PUTSTR_4              ; So just store the descriptor
                                                       ; --------------------------------
                                                       ; String not yet in string area,
                                                       ; And descriptor is a variable
                                                       ; --------------------------------
AS_L_PUTSTR_3:        LDY   #0                         ; Point at length in descriptor
                      LDA   (MS_Z_009D_FAC + 3),Y             ; Get length
                      JSR   AS_STRINI                  ; Make a string that long up above
                      LDA   MS_Z_008C_DSCPNT                  ; Set up source pntr for monins
                      LDY   MS_Z_008C_DSCPNT + 1
                      STA   MS_Z_00AB_STRNG1
                      STY   MS_Z_00AB_STRNG1 + 1
                      JSR   AS_MOVINS                  ; Move string data to new area
                      LDA   #<MS_Z_009D_FAC                   ; Address of descriptor is in fac
                      LDY   #>MS_Z_009D_FAC
AS_L_PUTSTR_4:        STA   MS_Z_008C_DSCPNT
                      STY   MS_Z_008C_DSCPNT + 1
                      JSR   AS_FRETMS                  ; Discard descriptor if 'twas temporary
                      LDY   #0                         ; Copy string descriptor
                      LDA   (MS_Z_008C_DSCPNT),Y
                      STA   (MS_Z_0085_FORPNT),Y
                      INY
                      LDA   (MS_Z_008C_DSCPNT),Y
                      STA   (MS_Z_0085_FORPNT),Y
                      INY
                      LDA   (MS_Z_008C_DSCPNT),Y
                      STA   (MS_Z_0085_FORPNT),Y
                      RTS
                                                       ; --------------------------------
AS_PR_STRING:
                      JSR   AS_STRPRT
                      JSR   MS_Z_00B7_CHRGOT
                                                       ; --------------------------------
                                                       ; "Print" statement
                                                       ; --------------------------------
MS_PRINT:             BEQ   AS_CRDO                    ; No more list, print <return>
                                                       ; --------------------------------
AS_PRINT2:            BEQ   AS_RTS_8                   ; No more list, don't print <return>
                      CMP   #MS_T_TABTK
                      BEQ   AS_PR_TAB_OR_SPC           ; C=1 for tab(
                      CMP   #MS_T_SPCTK
                      CLC
                      BEQ   AS_PR_TAB_OR_SPC           ; C=0 for spc(
                      CMP   #"," & %01111111
                      CLC                              ; <<< No purpose to this >>>
                      BEQ   AS_PR_COMMA
                      CMP   #";" & %01111111           ;"&%01111111)
                      BEQ   AS_PR_NEXT_CHAR
                      JSR   AS_FRMEVL                  ; Evaluate expression
                      BIT   MS_Z_0011_VALTYP                  ; String or fp value?
                      BMI   AS_PR_STRING               ; String
                      JSR   AS_FOUT                    ; Fp: convert into buffer
                      JSR   AS_STRLIT                  ; Make buffer into string
                      JMP   AS_PR_STRING               ; Print the string
                                                       ; --------------------------------
AS_CRDO:              LDA   #$0D                       ; Print <return>
                      JSR   AS_OUTDO
AS_NEGATE:            EOR   #$FF                       ; <<< Why??? >>>
AS_RTS_8:             RTS
                                                       ; --------------------------------
                                                       ; Tab to next comma column
                                                       ; <<< Note bug if width of window less than 33 >>>
AS_PR_COMMA:
                      LDA   MON_CH
                      CMP   #24                        ; <<< Bug:  it should be 32 >>>
                      BCC   AS_L_PR_COMMA_1            ; Next column, same line
                      JSR   AS_CRDO                    ; First column, next lint
                      BNE   AS_PR_NEXT_CHAR            ; ...Always
AS_L_PR_COMMA_1:      ADC   #16
                      AND   #$F0                       ; Round to 16 or 32
                      STA   MON_CH
                      BCC   AS_PR_NEXT_CHAR            ; ...Always
                                                       ; --------------------------------
AS_PR_TAB_OR_SPC:
                      PHP                              ; C=0 for spc(, c=1 for tab(
                      JSR   AS_GTBYTC                  ; Get value
                      CMP   #")" & %01111111           ; Trailing parenthesis
                      BEQ   AS_L_PR_TAB_OR_SPC_1       ; Good
                      JMP   AS_SYNERR                  ; No, syntax error
AS_L_PR_TAB_OR_SPC_1: PLP                              ; Tab( or spc(
                      BCC   AS_L_PR_TAB_OR_SPC_2       ; Spc(
                      DEX                              ; Tab(
                      TXA                              ; Calculate spaces needed for tab(
                      SBC   MON_CH
                      BCC   AS_PR_NEXT_CHAR            ; Already past that column
                      TAX                              ; Now do a spc( to the specified column
AS_L_PR_TAB_OR_SPC_2: INX
AS_NXSPC:             DEX
                      BNE   AS_DOSPC                   ; More spaces to print
                                                       ; --------------------------------
AS_PR_NEXT_CHAR:
                      JSR   MS_Z_00B1_CHRGET
                      JMP   AS_PRINT2                  ; Continue parsing print list
                                                       ; --------------------------------
AS_DOSPC:             JSR   AS_OUTSP
                      BNE   AS_NXSPC                   ; ...Always
                                                       ; --------------------------------
                                                       ; Print string at (y,a)
AS_STROUT:            JSR   AS_STRLIT                  ; Make (y,a) printable
                                                       ; --------------------------------
                                                       ; Print string at (facmo,faclo)
                                                       ; --------------------------------
AS_STRPRT:            JSR   AS_FREFAC                  ; Get address into index, (a)=length
                      TAX                              ; Use x-reg for counter
                      LDY   #0                         ; Use y-reg for scanner
                      INX
AS_L_STRPRT_1:        DEX
                      BEQ   AS_RTS_8                   ; Finished
                      LDA   (MS_Z_005E_INDEX),Y               ; Next char from string
                      JSR   AS_OUTDO                   ; Print the char
                      INY
                                                       ; <<< Next three lines are useless >>>
                      CMP   #$0D                       ; Was it <return>?
                      BNE   AS_L_STRPRT_1              ; No
                      JSR   AS_NEGATE                  ; Eor #$FF would do it, but why?
                                                       ; <<< Above three lines are useless >>>
                      JMP   AS_L_STRPRT_1
                                                       ; --------------------------------
AS_OUTSP:             LDA   #" " & %01111111           ; Print a space
                      .byte $2C                        ; Skip over next line
AS_OUTQUES:           LDA   #"?" & %01111111           ; Print question mark
                                                       ; --------------------------------
                                                       ; Print char from (a)

                                                       ; Note: poke 243,32 ($20 in $F3) will convert
                                                       ; Output to lower case.  this can be cancelled
                                                       ; By normal, inverse, or flash or poke 243,0.
                                                       ; --------------------------------
AS_OUTDO:             ORA   #$80                       ; Print (a)
                      CMP   #$A0                       ; Control chr?
                      BCC   AS_L_OUTDO_1               ; Skip if so
                      ORA   AS_FLASH_BIT               ; =$40 For flash, else $00
AS_L_OUTDO_1:         JSR   MS_OUTCH                   ; "And"s with $3F (inverse), $7F (flash)
                      AND   #$7F
                      PHA
                      LDA   AS_SPEEDZ                  ; Complement of speed #
                      JSR   MON_WAIT                   ; So speed=255 becomes (a)=1
                      PLA
                      RTS
                                                       ; --------------------------------
                                                       ; Input conversion error:  illegal character
                                                       ; In numeric field.  must distinguish
                                                       ; Between input, read, and get
                                                       ; --------------------------------
AS_INPUTERR:
                      LDA   MS_Z_0015_INPFLG
                      BEQ   AS_RESPERR                 ; Taken if input
                      BMI   AS_READERR                 ; Taken if read
                      LDY   #$FF                       ; From a get
                      BNE   AS_ERLIN                   ; ...Always
                                                       ; --------------------------------
AS_READERR:
                      LDA   MS_Z_007B_DATLIN                  ; Tell where the "data" is, rather
                      LDY   MS_Z_007B_DATLIN + 1              ; Than the "read"
                                                       ; --------------------------------
AS_ERLIN:             STA   MS_Z_0075_CURLIN
                      STY   MS_Z_0075_CURLIN + 1
                      JMP   AS_SYNERR
                                                       ; --------------------------------
AS_INPERR:            PLA
                                                       ; --------------------------------
AS_RESPERR:
                      BIT   AS_ERRFLG                  ; "On err" turned on?
                      BPL   AS_L_RESPERR_1             ; No, give reentry a try
                      LDX   #254                       ; Error code = 254
                      JMP   AS_HANDLERR
AS_L_RESPERR_1:       LDA   #<AS_ERR_REENTRY           ; "?Reenter"
                      LDY   #>AS_ERR_REENTRY
                      JSR   AS_STROUT
                      LDA   MS_Z_0079_OLDTXT                 ; Re-execute the whole input statement
                      LDY   MS_Z_0079_OLDTXT + 1
                      STA   MS_Z_00B8_TXTPTR
                      STY   MS_Z_00B8_TXTPTR + 1
                      RTS
                                                       ; --------------------------------
                                                       ; "Get" statement
                                                       ; --------------------------------
MS_GET:               JSR   AS_ERRDIR                  ; Illegal if in direct mode
                      LDX   #<(MS_BUF + 1)    ; Simulate input
                      LDY   #>(MS_BUF + 1)
                      LDA   #0
                      STA   MS_BUF + 1
                      LDA   #$40                       ; Set up inputflg
                      JSR   AS_PROCESS_INPUT_LIST      ; <<< Can save 1 byte here>>>
                      RTS                              ; <<<By "jmp process.input.list">>>
                                                       ; --------------------------------
                                                       ; "Input" statement
                                                       ; --------------------------------
MS_INPUT:             CMP   #$22                       ; Check for optional prompt string
                      BNE   AS_L_INPUT_1               ; No, print "?" prompt
                      JSR   AS_STRTXT                  ; Make a printable string out of it
                      LDA   #";" & %01111111           ;"&%01111111)                        ; Must have ; now
                      JSR   AS_SYNCHR
                      JSR   AS_STRPRT                  ; Print the string
                      JMP   AS_L_INPUT_2
AS_L_INPUT_1:         JSR   AS_OUTQUES                 ; No string, print "?"
AS_L_INPUT_2:         JSR   AS_ERRDIR                  ; Illegal if in direct mode
                      LDA   #"," & %01111111           ; Prime the buffer
                      STA   MS_BUF - 1
                      JSR   AS_INLIN
                      LDA   MS_BUF
                      CMP   #$03                       ; Control c?
                      BNE   AS_INPUT_FLAG_ZERO         ; No
                      JMP   AS_CONTROL_C_TYPED
                                                       ; --------------------------------
AS_NXIN:              JSR   AS_OUTQUES                 ; Print "?"
                      JMP   AS_INLIN
                                                       ; --------------------------------
                                                       ; "Read" statement
                                                       ; --------------------------------
MS_READ:              LDX   MS_Z_007D_DATPTR                  ; Y,x points at next data statement
                      LDY   MS_Z_007D_DATPTR + 1
                      LDA   #$98                       ; Set inputflg = $98
                      .byte $2C                        ; Trick to process.input.list
                                                       ; --------------------------------
AS_INPUT_FLAG_ZERO:   LDA   #0                         ; Set inputflg = $00
                                                       ; --------------------------------
                                                       ; Process input list

                                                       ; (Y,x) is address of input data string
                                                       ; (A) = value for inputflg:  $00 for input
                                                       ; $40 For get
                                                       ; $98 For read
                                                       ; --------------------------------
AS_PROCESS_INPUT_LIST: STA   MS_Z_0015_INPFLG
                      STX   MS_Z_007F_INPPTR                   ; Address of input string
                      STY   MS_Z_007F_INPPTR + 1
                                                       ; --------------------------------
AS_PROCESS_INPUT_ITEM: JSR   AS_PTRGET                  ; Get address of variable
                      STA   MS_Z_0085_FORPNT
                      STY   MS_Z_0085_FORPNT + 1
                      LDA   MS_Z_00B8_TXTPTR                  ; Save current txtptr,
                      LDY   MS_Z_00B8_TXTPTR + 1              ; Which points into program
                      STA   MS_Z_0087_VARTXT
                      STY   MS_Z_0087_VARTXT + 1
                      LDX   MS_Z_007F_INPPTR                   ; Set txtptr to point at input buffer
                      LDY   MS_Z_007F_INPPTR + 1               ; Or "data" line
                      STX   MS_Z_00B8_TXTPTR
                      STY   MS_Z_00B8_TXTPTR + 1
                      JSR   MS_Z_00B7_CHRGOT                  ; Get char at pntr
                      BNE   AS_INSTART                 ; Not end of line or colon
                      BIT   MS_Z_0015_INPFLG                ; Doing a "get"?
                      BVC   AS_L_PROCESS_INPUT_ITEM_1  ; No
                      JSR   MS_CQINCH                  ; Yes, get char
                      AND   #$7F
                      STA   MS_BUF
                      LDX   #<(MS_BUF - 1)
                      LDY   #>(MS_BUF - 1)
                      BNE   AS_L_PROCESS_INPUT_ITEM_2  ; ...Always
                                                       ; --------------------------------
AS_L_PROCESS_INPUT_ITEM_1: BMI   AS_FINDATA                 ; Doing a "read"
                      JSR   AS_OUTQUES                 ; Doing an "input", print "?"
                      JSR   AS_NXIN                    ; Print another "?", and input a line
AS_L_PROCESS_INPUT_ITEM_2: STX   MS_Z_00B8_TXTPTR
                      STY   MS_Z_00B8_TXTPTR + 1
                                                       ; --------------------------------
AS_INSTART:
                      JSR   MS_Z_00B1_CHRGET                  ; Get next input char
                      BIT   MS_Z_0011_VALTYP                  ; String or numeric?
                      BPL   AS_L_INSTART_5             ; Numeric
                      BIT   MS_Z_0015_INPFLG                ; String -- now what input type?
                      BVC   AS_L_INSTART_1             ; Not a "get"
                      INX                              ; "Get"
                      STX   MS_Z_00B8_TXTPTR
                      LDA   #0
                      STA   MS_Z_000D_CHARAC                  ; No other terminators than $00
                      BEQ   AS_L_INSTART_2             ; ...Always
                                                       ; --------------------------------
AS_L_INSTART_1:       STA   MS_Z_000D_CHARAC
                      CMP   #$22                       ; Terminate on $00 or quote
                      BEQ   AS_L_INSTART_3
                      LDA   #":" & %01111111           ; Terminate on $00, colon, or comma
                      STA   MS_Z_000D_CHARAC
                      LDA   #"," & %01111111
AS_L_INSTART_2:       CLC
AS_L_INSTART_3:       STA   MS_Z_000E_ENDCHR
                      LDA   MS_Z_00B8_TXTPTR
                      LDY   MS_Z_00B8_TXTPTR + 1
                      ADC   #0                         ; Skip over quotation mark, if
                      BCC   AS_L_INSTART_4             ; There was one
                      INY
AS_L_INSTART_4:       JSR   AS_STRLT2                  ; Build string starting at (y,a)
                                                       ; Terminated by $00, (charac), or (endchr)
                      JSR   AS_POINT                   ; Set txtptr to point at string
                      JSR   AS_PUTSTR                  ; Store string in variable
                      JMP   AS_INPUT_MORE
                                                       ; --------------------------------
AS_L_INSTART_5:       PHA
                      LDA   MS_BUF            ; Anything in buffer?
                      BEQ   AS_INPFIN                  ; No, see if read or input
                                                       ; --------------------------------
AS_INPUTDWTA:
                      PLA                              ; "Read"
                      JSR   AS_FIN                     ; Get fp number at txtptr
                      LDA   MS_Z_0011_VALTYP + 1
                      JSR   AS_LET2                    ; Store result in variable
                                                       ; --------------------------------
AS_INPUT_MORE:
                      JSR   MS_Z_00B7_CHRGOT
                      BEQ   AS_L_INPUT_MORE_1          ; End of line or colon
                      CMP   #"," & %01111111           ; Comma in input?
                      BEQ   AS_L_INPUT_MORE_1          ; Yes
                      JMP   AS_INPUTERR                ; Nothing else will do
AS_L_INPUT_MORE_1:    LDA   MS_Z_00B8_TXTPTR                  ; Save position in input buffer
                      LDY   MS_Z_00B8_TXTPTR + 1
                      STA   MS_Z_007F_INPPTR
                      STY   MS_Z_007F_INPPTR + 1
                      LDA   MS_Z_0087_VARTXT                   ; Restore program pointer
                      LDY   MS_Z_0087_VARTXT + 1
                      STA   MS_Z_00B8_TXTPTR
                      STY   MS_Z_00B8_TXTPTR + 1
                      JSR   MS_Z_00B7_CHRGOT                  ; Next char from program
                      BEQ   AS_INPDONE                 ; End of statement
                      JSR   AS_CHKCOM                  ; Better be a comma then
                      JMP   AS_PROCESS_INPUT_ITEM
                                                       ; --------------------------------
AS_INPFIN:            LDA   MS_Z_0015_INPFLG                ; "Input" or "read"
                      BNE   AS_INPUTDWTA               ; "Read"
                      JMP   AS_INPERR
                                                       ; --------------------------------
AS_FINDATA:
                      JSR   AS_DATAN                   ; Get offset to next colon or eol
                      INY                              ; To first char of next line
                      TAX                              ; Which:  eol or colon?
                      BNE   AS_L_FINDATA_1             ; Colon
                      LDX   #MS_E_ERROD             ; Eol: might be out of data
                      INY                              ; Check hi-byte of forward pntr
                      LDA   (MS_Z_00B8_TXTPTR),Y              ; End of program?
                      BEQ   AS_GERR                    ; Yes, we are out of data
                      INY                              ; Pick up the line #
                      LDA   (MS_Z_00B8_TXTPTR),Y
                      STA   MS_Z_007B_DATLIN
                      INY
                      LDA   (MS_Z_00B8_TXTPTR),Y
                      INY                              ; Point at first text char in line
                      STA   MS_Z_007B_DATLIN + 1
AS_L_FINDATA_1:       LDA   (MS_Z_00B8_TXTPTR),Y              ; Get 1st token of statement
                      TAX                              ; Save token in x-reg
                      JSR   AS_ADDON                   ; Add (y) to txtptr
                      CPX   #MS_T_DATATK              ; Did we find a "data" statement?
                      BNE   AS_FINDATA                 ; Not yet
                      JMP   AS_INSTART                 ; Yes, read it
                                                       ; ---No more input requested------
AS_INPDONE:
                      LDA   MS_Z_007F_INPPTR                   ; Get pointer in case it was "read"
                      LDY   MS_Z_007F_INPPTR + 1
                      LDX   MS_Z_0015_INPFLG                ; "Read" or "input"?
                      BPL   AS_L_INPDONE_1             ; "Input"
                      JMP   AS_SETDA                   ; "Data", so store (y,x) at datptr
AS_L_INPDONE_1:       LDY   #0                         ; "Input":  any more chars on line?
                      LDA   (MS_Z_007F_INPPTR),Y
                      BEQ   AS_L_INPDONE_2             ; No, all is well
                      LDA   #<AS_ERR_EXTRA             ; Yes, error
                      LDY   #>AS_ERR_EXTRA             ; "Extra ignored"
                      JMP   AS_STROUT
AS_L_INPDONE_2:       RTS
                                                       ; --------------------------------
AS_ERR_EXTRA:         .byte "?" & %01111111
                      .byte "E" & %01111111
                      .byte "X" & %01111111
                      .byte "T" & %01111111
                      .byte "R" & %01111111
                      .byte "A" & %01111111
                      .byte " " & %01111111
                      .byte "I" & %01111111
                      .byte "G" & %01111111
                      .byte "N" & %01111111
                      .byte "O" & %01111111
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "D" & %01111111

                      .byte $0D, 0

AS_ERR_REENTRY:       .byte "?" & %01111111
                      .byte "R" & %01111111
                      .byte "E" & %01111111
                      .byte "E" & %01111111
                      .byte "N" & %01111111
                      .byte "T" & %01111111
                      .byte "E" & %01111111
                      .byte "R" & %01111111

                      .byte $0D, 0
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; "Next" statement
                                                       ; --------------------------------
MS_NEXT:              BNE   AS_NEXT_1                  ; Variable after "next"
                      LDY   #0                         ; Flag by setting forpnt+1 = 0
                      BEQ   AS_NEXT_2                  ; ...Always
                                                       ; --------------------------------
AS_NEXT_1:            JSR   AS_PTRGET                  ; Get pntr to variable in (y,a)
AS_NEXT_2:            STA   MS_Z_0085_FORPNT
                      STY   MS_Z_0085_FORPNT + 1
                      JSR   MS_FNDFOR                ; Find for-frame for this variable
                      BEQ   AS_NEXT_3                  ; Found it
                      LDX   #MS_E_ERRNF              ; Not there, abort
AS_GERR:              BEQ   AS_JERROR                  ; ...Always
AS_NEXT_3:            TXS                              ; Set stack ptr to point to this frame,
                      INX                              ; Which trims off any inner loops
                      INX
                      INX
                      INX
                      TXA                              ; Low byte of adrs of step value
                      INX
                      INX
                      INX
                      INX
                      INX
                      INX
                      STX   AS_DEST                    ; Low byte adrs of for var value
                      LDY   #>AS_STACK                 ; (Y,a) is address of step value
                      JSR   AS_LOAD_FAC_FROM_YA        ; Step to fac
                      TSX
                      LDA   AS_STACK + 9,X
                      STA   MS_Z_00A2_FACSGN
                      LDA   MS_Z_0085_FORPNT
                      LDY   MS_Z_0085_FORPNT + 1
                      JSR   AS_FADD                    ; Add to for value
                      JSR   AS_SETFOR                  ; Put new value back
                      LDY   #>AS_STACK                 ; (Y,a) is address of end value
                      JSR   AS_FCOMP2                  ; Compare to end value
                      TSX
                      SEC
                      SBC   AS_STACK + 9,X             ; Sign of step
                      BEQ   AS_L_NEXT_3_2              ; Branch if for complete
                      LDA   AS_STACK + 15,X            ; Otherwise set up
                      STA   MS_Z_0075_CURLIN                  ; For line #
                      LDA   AS_STACK + 16,X
                      STA   MS_Z_0075_CURLIN + 1
                      LDA   AS_STACK + 18,X            ; And set txtptr to just
                      STA   MS_Z_00B8_TXTPTR                  ; After for statement
                      LDA   AS_STACK + 17,X
                      STA   MS_Z_00B8_TXTPTR + 1
AS_L_NEXT_3_1:        JMP   AS_NEWSTT
AS_L_NEXT_3_2:        TXA                              ; Pop off for-frame, loop is done
                      ADC   #17                        ; Carry is set, so adds 18
                      TAX
                      TXS
                      JSR   MS_Z_00B7_CHRGOT                  ; Char after variable
                      CMP   #"," & %01111111           ; Another variable in next_
                      BNE   AS_L_NEXT_3_1              ; No, go to next statement
                      JSR   MS_Z_00B1_CHRGET                  ; Yes, prime for next variable
                      JSR   AS_NEXT_1                  ; (Does not return)
                                                       ; --------------------------------
                                                       ; Evaluate expression, make sure it is numeric
                                                       ; --------------------------------
AS_FRMNUM:            JSR   AS_FRMEVL
                                                       ; --------------------------------
                                                       ; Make sure (fac) is numeric
                                                       ; --------------------------------
AS_CHKNUM:            CLC
                      .byte $24                        ; Dummy for skip
                                                       ; --------------------------------
                                                       ; Make sure (fac) is string
                                                       ; --------------------------------
AS_CHKSTR:            SEC
                                                       ; --------------------------------
                                                       ; Make sure (fac) is correct type
                                                       ; If c=0, type must be numeric
                                                       ; If c=1, type must be string
                                                       ; --------------------------------
AS_CHKVAL:            BIT   MS_Z_0011_VALTYP                  ; $00 If numeric, $FF if string
                      BMI   AS_L_CHKVAL_2              ; Type is string
                      BCS   AS_L_CHKVAL_3              ; Not string, but we need string
AS_L_CHKVAL_1:        RTS                              ; Type is correct
AS_L_CHKVAL_2:        BCS   AS_L_CHKVAL_1              ; Is string and we wanted string
AS_L_CHKVAL_3:        LDX   #MS_E_ERRTM            ; Type mismatch
AS_JERROR:            JMP   MS_ERROR
                                                       ; --------------------------------
                                                       ; Evaluate the expression at txtptr, leaving the
                                                       ; Result in fac.  works for both string and numeric
                                                       ; Expressions.
                                                       ; --------------------------------
AS_FRMEVL:            LDX   MS_Z_00B8_TXTPTR                  ; Decrement txtptr
                      BNE   AS_L_FRMEVL_1
                      DEC   MS_Z_00B8_TXTPTR + 1
AS_L_FRMEVL_1:        DEC   MS_Z_00B8_TXTPTR
                      LDX   #0                         ; Start with precedence = 0
                      .byte $24                        ; Trick to skip following "pha"
                                                       ; --------------------------------
AS_FRMEVL_1:
                      PHA                              ; Push relops flags
                      TXA
                      PHA                              ; Save last precedence
                      LDA   #1
                      JSR   AS_CHKMEM                  ; Check if enough room on stack
                      JSR   AS_FRM_ELEMENT             ; Get an element
                      LDA   #0
                      STA   MS_Z_0089_OPMASK                  ; Clear comparison operator flags
                                                       ; --------------------------------
AS_FRMEVL_2:
                      JSR   MS_Z_00B7_CHRGOT                  ; Check for relational operators
AS_L_FRMEVL_2_1:      SEC                              ; > Is $CF, = is $D0, < is $D1
                      SBC   #MS_T_GREATK          ; > Is 0, = is 1, < is 2
                      BCC   AS_L_FRMEVL_2_2            ; Not relational operator
                      CMP   #3
                      BCS   AS_L_FRMEVL_2_2            ; Not relational operator
                      CMP   #1                         ; Set carry if "=" or "<"
                      ROL                              ; Now > is 0, = is 3, < is 5
                      EOR   #1                         ; Now > is 1, = is 2, < is 4
                      EOR   MS_Z_0089_OPMASK                  ; Set bits of cprtyp:  00000<=>
                      CMP   MS_Z_0089_OPMASK                  ; Check for illegal combinations
                      BCC   AS_SNTXERR                 ; If less than, a relop was repeated
                      STA   MS_Z_0089_OPMASK
                      JSR   MS_Z_00B1_CHRGET                  ; Another operator?
                      JMP   AS_L_FRMEVL_2_1            ; Check for <,=,> again
                                                       ; --------------------------------
AS_L_FRMEVL_2_2:      LDX   MS_Z_0089_OPMASK                  ; Did we find a relational operator?
                      BNE   AS_FRM_RELATIONAL          ; Yes
                      BCS   AS_NOTMATH                 ; No, and next token is > $D1
                      ADC   #$CF - MS_T_PLUSTK       ; No, and next token < $CF
                      BCC   AS_NOTMATH                 ; If next token < "+"
                      ADC   MS_Z_0011_VALTYP                  ; + And last result a string?
                      BNE   AS_L_FRMEVL_2_3            ; Branch if not
                      JMP   AS_CAT                     ; Concatenate if so.
                                                       ; --------------------------------
AS_L_FRMEVL_2_3:      ADC   #$FF                       ; +-*/ Is 0123
                      STA   MS_Z_005E_INDEX
                      ASL                              ; Multiply by 3
                      ADC   MS_Z_005E_INDEX                   ; +-*/ Is 0,3,6,9
                      TAY
                                                       ; --------------------------------
AS_FRM_PRECEDENCE_TEST:
                      PLA                              ; Get last precedence
                      CMP   MS_OPTAB,Y
                      BCS   AS_FRM_PERFORM_1           ; Do now if higher precedence
                      JSR   AS_CHKNUM                  ; Was last result a #?
AS_NXOP:              PHA                              ; Yes, save precedence on stack
AS_SAVOP:             JSR   AS_FRM_RECURSE             ; Save rest, call frmevl recursively
                      PLA
                      LDY   MS_Z_0087_OPPTR
                      BPL   AS_PREFNC
                      TAX
                      BEQ   AS_GOEX                    ; Exit if no math in expression
                      BNE   AS_FRM_PERFORM_2           ; ...Always
                                                       ; --------------------------------
                                                       ; Found one or more relational operators <,=,>
                                                       ; --------------------------------
AS_FRM_RELATIONAL:
                      LSR   MS_Z_0011_VALTYP                  ; (Valtyp) = 0 (numeric), = $FF (string)
                      TXA                              ; Set cprtyp to 0000<=>c
                      ROL                              ; Where c=0 if #, c=1 if string
                      LDX   MS_Z_00B8_TXTPTR                  ; Back up txtptr
                      BNE   AS_L_FRM_RELATIONAL_1
                      DEC   MS_Z_00B8_TXTPTR + 1
AS_L_FRM_RELATIONAL_1: DEC   MS_Z_00B8_TXTPTR
                      LDY   #MS_PTDORL - MS_OPTAB     ; Point at relops entry
                      STA   MS_Z_0089_OPMASK
                      BNE   AS_FRM_PRECEDENCE_TEST     ; ...Always
                                                       ; --------------------------------
AS_PREFNC:            CMP   MS_OPTAB,Y
                      BCS   AS_FRM_PERFORM_2           ; Do now if higher precedence
                      BCC   AS_NXOP                    ; ...Always
                                                       ; --------------------------------
                                                       ; Stack this operation and call frmevl for
                                                       ; Another one
                                                       ; --------------------------------
AS_FRM_RECURSE:
                      LDA   MS_OPTAB + 2,Y
                      PHA                              ; Push address of operation performer
                      LDA   MS_OPTAB + 1,Y
                      PHA
                      JSR   AS_FRM_STACK_1             ; Stack fac.sign and fac
                      LDA   MS_Z_0089_OPMASK                  ; A=relop flags, x=precedence byte
                      JMP   AS_FRMEVL_1                ; Recursively call frmevl
                                                       ; --------------------------------
AS_SNTXERR:           JMP   AS_SYNERR
                                                       ; --------------------------------
                                                       ; Stack (fac)

                                                       ; Three entry points:
                                                       ; L_sntxerr_1, from frmevl
                                                       ; L_sntxerr_2, from "step"
                                                       ; L_sntxerr_3, from "for"
                                                       ; --------------------------------
AS_FRM_STACK_1:
                      LDA   MS_Z_00A2_FACSGN                ; Get fac.sign to push it
; Note: XA65 assembler (Andre Fachat) requires ! here when asm with "xa -R -bt 0" for some reason:
                      LDX   MS_OPTAB,Y              ; Precedence byte from mathtbl
                                                       ; --------------------------------
                                                       ; Enter here from "step", to push step sign and value
                                                       ; --------------------------------
AS_FRM_STACK_2:
                      TAY                              ; Fac.sign or sgn(step value)
                      PLA                              ; Pull return address and add 1
                      STA   MS_Z_005E_INDEX                   ; <<< Assumes not on page boundary! >>>
                      INC   MS_Z_005E_INDEX                   ; Place bumped return address in
                      PLA                              ; Index,index+1
                      STA   MS_Z_005E_INDEX + 1
                      TYA                              ; Fac.sign or sgn(step value)
                      PHA                              ; Push fac.sign or sgn(step value)
                                                       ; --------------------------------
                                                       ; Enter here from "for", with (index) = step,
                                                       ; To push initial value of "for" variable
                                                       ; --------------------------------
AS_FRM_STACK_3:
                      JSR   AS_ROUND_FAC               ; Round to 32 bits
                      LDA   MS_Z_009D_FAC + 4                 ; Push (fac)
                      PHA
                      LDA   MS_Z_009D_FAC + 3
                      PHA
                      LDA   MS_Z_009D_FAC + 2
                      PHA
                      LDA   MS_Z_009D_FAC + 1
                      PHA
                      LDA   MS_Z_009D_FAC
                      PHA
                      JMP   (MS_Z_005E_INDEX)                 ; Do rts funny way
                                                       ; --------------------------------

                                                       ; --------------------------------
AS_NOTMATH:           LDY   #$FF                       ; Set up to exit routine
                      PLA
AS_GOEX:              BEQ   AS_EXIT                    ; Exit if no math to do
                                                       ; --------------------------------
                                                       ; Perform stacked operation

                                                       ; (A) = precedence byte
                                                       ; Stack:  1 -- cprmask
                                                       ; 5 -- (Arg)
                                                       ; 2 -- Addr of performer
                                                       ; --------------------------------
AS_FRM_PERFORM_1:
                      CMP   #AS_P_REL                  ; Was it relational operator?
                      BEQ   AS_L_FRM_PERFORM_1_1       ; Yes, allow string compare
                      JSR   AS_CHKNUM                  ; Must be numeric value
AS_L_FRM_PERFORM_1_1: STY   MS_Z_0087_OPPTR
                                                       ; --------------------------------
AS_FRM_PERFORM_2:
                      PLA                              ; Get 0000<=>c from stack
                      LSR                              ; Shift to 00000<=> form
                      STA   AS_CPRMASK                 ; 00000<=>
                      PLA
                      STA   MS_Z_00A5_ARGEXP                     ; Get floating point value off stack,
                      PLA                              ; And put it in arg
                      STA   MS_Z_00A5_ARGEXP + 1
                      PLA
                      STA   MS_Z_00A5_ARGEXP + 2
                      PLA
                      STA   MS_Z_00A5_ARGEXP + 3
                      PLA
                      STA   MS_Z_00A5_ARGEXP + 4
                      PLA
                      STA   MS_Z_00A5_ARGEXP + 5
                      EOR   MS_Z_00A2_FACSGN                ; Save eor of signs of the operands,
                      STA   MS_Z_00AB_ARISGN                  ; In case of multiply or divide
AS_EXIT:              LDA   MS_Z_009D_FAC                     ; Fac exponent in a-reg
                      RTS                              ; Status equ. if (fac)=0
                                                       ; Rts goes to perform operation
                                                       ; --------------------------------
                                                       ; Get element in expression

                                                       ; Get value of variable or number at txtpnt, or point
                                                       ; To string descriptor if a string, and put in fac.
                                                       ; --------------------------------
AS_FRM_ELEMENT:
                      LDA   #0                         ; Assume numeric
                      STA   MS_Z_0011_VALTYP
AS_L_FRM_ELEMENT_1:   JSR   MS_Z_00B1_CHRGET
                      BCS   AS_L_FRM_ELEMENT_3         ; Not a digit
AS_L_FRM_ELEMENT_2:   JMP   AS_FIN                     ; Numeric constant
AS_L_FRM_ELEMENT_3:   JSR   AS_ISLETC                  ; Variable name?
                      BCS   AS_FRM_VARIABLE            ; Yes
                      CMP   #"." & %01111111           ; Decimal point
                      BEQ   AS_L_FRM_ELEMENT_2         ; Yes, numeric constant
                      CMP   #MS_T_MINUTK            ; Unary minus?
                      BEQ   AS_MIN                     ; Yes
                      CMP   #MS_T_PLUSTK             ; Unary plus
                      BEQ   AS_L_FRM_ELEMENT_1         ; Yes
                      CMP   #$22                       ; String constant?
                      BNE   AS_NOT_                    ; No
                                                       ; --------------------------------
                                                       ; String constant element

                                                       ; Set y,a = (txtptr)+carry
                                                       ; --------------------------------
AS_STRTXT:            LDA   MS_Z_00B8_TXTPTR                  ; Add (carry) to get address of 1st char
                      LDY   MS_Z_00B8_TXTPTR + 1              ; Of string in y,a
                      ADC   #0
                      BCC   AS_L_STRTXT_1
                      INY
AS_L_STRTXT_1:        JSR   AS_STRLIT                  ; Build descriptor to string
                                                       ; Get address of descriptor in fac
                      JMP   AS_POINT                   ; Point txtptr after trailing quote
                                                       ; --------------------------------
                                                       ; "Not" function
                                                       ; If fac=0, return fac=1
                                                       ; If fac<>0, return fac=0
                                                       ; --------------------------------
AS_NOT_:              CMP   #MS_T_NOTTK
                      BNE   AS_FN_                     ; Not "not", try "fn"
                      LDY   #MS_NOTTAB - MS_OPTAB     ; Point at = comparison
                      BNE   AS_EQUL                    ; ...Always
                                                       ; --------------------------------
                                                       ; Comparison for equality (= operator)
                                                       ; Also used to evaluate "not" function
                                                       ; --------------------------------
MS_NOTOP:             LDA   MS_Z_009D_FAC                     ; Set "true" if (fac) = zero
                      BNE   AS_L_EQUOP_1               ; False
                      LDY   #1                         ; True
                      .byte $2C                        ; Trick to skip next 2 bytes
AS_L_EQUOP_1:         LDY   #0                         ; False
                      JMP   AS_SNGFLT
                                                       ; --------------------------------
AS_FN_:               CMP   #MS_T_FNTK
                      BNE   AS_SGN_
                      JMP   AS_FUNCT
                                                       ; --------------------------------
AS_SGN_:              CMP   #MS_T_ONEFUN
                      BCC   AS_PARCHK
                      JMP   AS_UNARY
                                                       ; --------------------------------
                                                       ; Evaluate "(expression)"
                                                       ; --------------------------------
AS_PARCHK:            JSR   AS_CHKOPN                  ; Is there a '(' at txtptr?
                      JSR   AS_FRMEVL                  ; Yes, evaluate expression
                                                       ; --------------------------------
AS_CHKCLS:            LDA   #$29                       ; Check for ')'
                      .byte $2C                        ; Trick
                                                       ; --------------------------------
AS_CHKOPN:            LDA   #$28
                      .byte $2C                        ; Trick
                                                       ; --------------------------------
AS_CHKCOM:            LDA   #"," & %01111111           ; Comma at txtptr?
                                                       ; --------------------------------
                                                       ; Unless char at txtptr = (a), syntax error
                                                       ; --------------------------------
AS_SYNCHR:            LDY   #0
                      CMP   (MS_Z_00B8_TXTPTR),Y
                      BNE   AS_SYNERR
                      JMP   MS_Z_00B1_CHRGET                  ; Match, get next char & return
                                                       ; --------------------------------
AS_SYNERR:            LDX   #MS_E_ERRSN
                      JMP   MS_ERROR
                                                       ; --------------------------------
AS_MIN:               LDY   #MS_NEGTAB - MS_OPTAB     ; Point at unary minus
AS_EQUL:              PLA
                      PLA
                      JMP   AS_SAVOP
                                                       ; --------------------------------
AS_FRM_VARIABLE:
                      JSR   AS_PTRGET
AS_FRM_VARIABLE_CALL  =     * - 1                      ; So ptrget can tell we called
                      STA   AS_VPNT                    ; Address of variable
                      STY   AS_VPNT + 1
                      LDX   MS_Z_0011_VALTYP                  ; Numeric or string?
                      BEQ   AS_L_FRM_VARIABLE_CALL_1   ; Numeric
                      LDX   #0                         ; String
                      STX   MS_Z_00AB_STRNG1 + 1
                      RTS
AS_L_FRM_VARIABLE_CALL_1: LDX   MS_Z_0011_VALTYP + 1              ; Numeric, which type?
                      BPL   AS_L_FRM_VARIABLE_CALL_2   ; Floating point
                      LDY   #0                         ; Integer
                      LDA   (AS_VPNT),Y
                      TAX                              ; Get value in a,y
                      INY
                      LDA   (AS_VPNT),Y
                      TAY
                      TXA
                      JMP   AS_GIVAYF                  ; Convert a,y to floating point
AS_L_FRM_VARIABLE_CALL_2: JMP   AS_LOAD_FAC_FROM_YA
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; "Scrn(" function
                                                       ; --------------------------------
AS_SCREEN:            JSR   MS_Z_00B1_CHRGET
                      JSR   AS_PLOTFNS                 ; Get column and row
                      TXA                              ; Row
                      LDY   AS_FIRST                   ; Column
                      JSR   MON_SCRN                   ; Get 4-bit color there
                      TAY
                      JSR   AS_SNGFLT                  ; Convert (y) to real in fac
                      JMP   AS_CHKCLS                  ; Require ")"
                                                       ; --------------------------------
                                                       ; Process unary operators (functions)
                                                       ; --------------------------------
AS_UNARY:             CMP   #AS_TOKEN_SCRN             ; Not unary, do special
                      BEQ   AS_SCREEN
                      ASL                              ; Double token to get index
                      PHA
                      TAX
                      JSR   MS_Z_00B1_CHRGET
                      CPX   #<(AS_TOKEN_LEFTSTR * 2 - 1) ; Left$, right$, and mid$
                      BCC   AS_L_UNARY_1               ; Not one of the string functions
                      JSR   AS_CHKOPN                  ; String function, need "("
                      JSR   AS_FRMEVL                  ; Evaluate expression for string
                      JSR   AS_CHKCOM                  ; Require a comma
                      JSR   AS_CHKSTR                  ; Make sure expression is a string
                      PLA
                      TAX                              ; Retrieve routine pointer
                      LDA   AS_VPNT + 1                ; Stack address of string
                      PHA
                      LDA   AS_VPNT
                      PHA
                      TXA
                      PHA                              ; Stack doubled token
                      JSR   AS_GETBYT                  ; Convert next expression to byte in x-reg
                      PLA                              ; Get doubled token off stack
                      TAY                              ; Use as index to branch
                      TXA                              ; Value of second parameter
                      PHA                              ; Push 2nd param
                      JMP   AS_L_UNARY_2               ; Join unary functions
AS_L_UNARY_1:         JSR   AS_PARCHK                  ; Require "(expression)"
                      PLA
                      TAY                              ; Index into function address table
AS_L_UNARY_2:         LDA   MS_FUNDSP - MS_T_ONEFUN - MS_T_ONEFUN + $100,Y
                      STA   MS_Z_0090_JMPER + 1             ; Prepare to jsr to address
                      LDA   MS_FUNDSP - MS_T_ONEFUN - MS_T_ONEFUN + $101,Y
                      STA   MS_Z_0090_JMPER + 2
                      JSR   MS_Z_0090_JMPER                 ; Does not return for
                                                       ; Chr$, left$, right$, or mid$
                      JMP   AS_CHKNUM                  ; Require numeric result
                                                       ; --------------------------------
MS_OROP:                LDA   MS_Z_00A5_ARGEXP                     ; "Or" operator
                      ORA   MS_Z_009D_FAC                     ; If result nonzero, it is true
                      BNE   AS_TRUE
                                                       ; --------------------------------
MS_ANDOP:             LDA   MS_Z_00A5_ARGEXP                     ; "And" operator
                      BEQ   AS_FALSE                   ; If either is zero, result is false
                      LDA   MS_Z_009D_FAC
                      BNE   AS_TRUE
                                                       ; --------------------------------
AS_FALSE:             LDY   #0                         ; Return fac=0
                      .byte $2C                        ; Trick
                                                       ; --------------------------------
AS_TRUE:              LDY   #1                         ; Return fac=1
                      JMP   AS_SNGFLT
                                                       ; --------------------------------
                                                       ; Perform relational operations
                                                       ; --------------------------------
MS_DOREL:            JSR   AS_CHKVAL                  ; Make sure fac is correct type
                      BCS   AS_STRCMP                  ; Type matches, branch if strings
                      LDA   MS_Z_00AA_ARGSGN                ; Numeric comparison
                      ORA   #$7F                       ; Re-pack value in arg for fcomp
                      AND   MS_Z_00A5_ARGEXP + 1
                      STA   MS_Z_00A5_ARGEXP + 1
                      LDA   #<MS_Z_00A5_ARGEXP
                      LDY   #>MS_Z_00A5_ARGEXP
                      JSR   AS_FCOMP                   ; Return a-reg = -1,0,1
                      TAX                              ; As arg <,=,> fac
                      JMP   AS_NUMCMP
                                                       ; --------------------------------
                                                       ; String comparison
                                                       ; --------------------------------
AS_STRCMP:            LDA   #0                         ; Set result type to numeric
                      STA   MS_Z_0011_VALTYP
                      DEC   MS_Z_0089_OPMASK                  ; Make cprtyp 0000<=>0
                      JSR   AS_FREFAC
                      STA   MS_Z_009D_FAC                     ; String length
                      STX   MS_Z_009D_FAC + 1
                      STY   MS_Z_009D_FAC + 2
                      LDA   MS_Z_00A5_ARGEXP + 3
                      LDY   MS_Z_00A5_ARGEXP + 4
                      JSR   AS_FRETMP
                      STX   MS_Z_00A5_ARGEXP + 3
                      STY   MS_Z_00A5_ARGEXP + 4
                      TAX                              ; Len (arg) string
                      SEC
                      SBC   MS_Z_009D_FAC                     ; Set x to smaller len
                      BEQ   AS_L_STRCMP_1
                      LDA   #1
                      BCC   AS_L_STRCMP_1
                      LDX   MS_Z_009D_FAC
                      LDA   #$FF
AS_L_STRCMP_1:        STA   MS_Z_00A2_FACSGN                ; Flag which shorter
                      LDY   #$FF
                      INX
AS_STRCMP_1:
                      INY
                      DEX
                      BNE   AS_STRCMP_2                ; More chars in both strings
                      LDX   MS_Z_00A2_FACSGN                ; If = so far, decide by length
                                                       ; --------------------------------
AS_NUMCMP:            BMI   AS_CMPDONE
                      CLC
                      BCC   AS_CMPDONE                 ; ...Always
                                                       ; --------------------------------
AS_STRCMP_2:
                      LDA   (MS_Z_00A5_ARGEXP + 3),Y
                      CMP   (MS_Z_009D_FAC + 1),Y
                      BEQ   AS_STRCMP_1                ; Same, keep comparing
                      LDX   #$FF                       ; In case arg greater
                      BCS   AS_CMPDONE                 ; It is
                      LDX   #1                         ; Fac greater
                                                       ; --------------------------------
AS_CMPDONE:
                      INX                              ; Convert ff,0,1 to 0,1,2
                      TXA
                      ROL                              ; And to 0,2,4 if c=0, else 1,2,5
                      AND   AS_CPRMASK                 ; 00000<=>
                      BEQ   AS_L_CMPDONE_1             ; If no match: false
                      LDA   #1                         ; At least one match: true
AS_L_CMPDONE_1:       JMP   AS_FLOAT
                                                       ; --------------------------------
                                                       ; "Pdl" function
                                                       ; <<< Note: arg<4 is not checked >>>
                                                       ; --------------------------------
AS_PDL:               JSR   AS_CONINT                  ; Get # in x
                      JSR   MON_PREAD                  ; Read paddle
                      JMP   AS_SNGFLT                  ; Float result
                                                       ; --------------------------------
                                                       ; "Dim" statement
                                                       ; --------------------------------
AS_NXDIM:             JSR   AS_CHKCOM                  ; Separated by commas
MS_DIM:               TAX                              ; Non-zero, flags ptrget dim called
                      JSR   AS_PTRGET2                 ; Allocate the array
                      JSR   MS_Z_00B7_CHRGOT                  ; Next char
                      BNE   AS_NXDIM                   ; Not end of statement
                      RTS
                                                       ; --------------------------------
                                                       ; Ptrget -- general variable scan

                                                       ; Scans variable name at txtptr, and searches the
                                                       ; Vartab and arytab for the name.
                                                       ; If not found, create variable of appropriate type.
                                                       ; Return with address in varpnt and y,a

                                                       ; Actual activity controlled somewhat by two flags:
                                                       ; Dimflg -- nonzero if called from "dim"
                                                       ; Else = 0

                                                       ; Subflg -- = $00
                                                       ; = $40 If called from "getarypt"
                                                       ; = $80 If called from "def fn"
                                                       ; = $C1-da if called from "fn"
                                                       ; --------------------------------
AS_PTRGET:            LDX   #0
                      JSR   MS_Z_00B7_CHRGOT                  ; Get first char of variable name
                                                       ; --------------------------------
AS_PTRGET2:
                      STX   MS_Z_0010_DIMFLG                  ; X is nonzero if from dim
                                                       ; --------------------------------
AS_PTRGET3:
                      STA   MS_Z_0081_VARNAM
                      JSR   MS_Z_00B7_CHRGOT
                      JSR   AS_ISLETC                  ; Is it a letter?
                      BCS   AS_NAMOK                   ; Yes, okay so far
AS_BADNAM:            JMP   AS_SYNERR                  ; No, syntax error
AS_NAMOK:             LDX   #0
                      STX   MS_Z_0011_VALTYP
                      STX   MS_Z_0011_VALTYP + 1
                      JMP   AS_PTRGET4                 ; To branch across $E000 vectors
                                                       ; --------------------------------
                                                       ; Dos and monitor call basic at $E000 and $E003
                                                       ; --------------------------------
AS_BASIC:             JMP   AS_COLD_START
AS_BASIC2:            JMP   AS_RESTART
                      BRK                              ; <<< Wasted byte >>>
                                                       ; --------------------------------
AS_PTRGET4:
                      JSR   MS_Z_00B1_CHRGET                  ; Second char of variable name
                      BCC   AS_L_PTRGET4_1             ; Numeric
                      JSR   AS_ISLETC                  ; Letter?
                      BCC   AS_L_PTRGET4_3             ; No, end of name
AS_L_PTRGET4_1:       TAX                              ; Save second char of name in x
AS_L_PTRGET4_2:       JSR   MS_Z_00B1_CHRGET                  ; Scan to end of variable name
                      BCC   AS_L_PTRGET4_2             ; Numeric
                      JSR   AS_ISLETC
                      BCS   AS_L_PTRGET4_2             ; Alpha
AS_L_PTRGET4_3:       CMP   #"$" & %01111111           ; String?
                      BNE   AS_L_PTRGET4_4             ; No
                      LDA   #$FF
                      STA   MS_Z_0011_VALTYP
                      BNE   AS_L_PTRGET4_5             ; ...Always
AS_L_PTRGET4_4:       CMP   #"%" & %01111111           ; Integer?
                      BNE   AS_L_PTRGET4_6             ; No
                      LDA   MS_Z_0014_SUBFLG                  ; Yes; integer variable allowed?
                      BMI   AS_BADNAM                  ; No, syntax error
                      LDA   #$80                       ; Yes
                      STA   MS_Z_0011_VALTYP + 1              ; Flag integer mode
                      ORA   MS_Z_0081_VARNAM
                      STA   MS_Z_0081_VARNAM                  ; Set sign bit on varname
AS_L_PTRGET4_5:       TXA                              ; Second char of name
                      ORA   #$80                       ; Set sign
                      TAX
                      JSR   MS_Z_00B1_CHRGET                  ; Get terminating char
AS_L_PTRGET4_6:       STX   MS_Z_0081_VARNAM + 1              ; Store second char of name
                      SEC
                      ORA   MS_Z_0014_SUBFLG                  ; $00 Or $40 if subscripts ok, else $80
                      SBC   #$28                       ; If subflg=$00 and char="("...
                      BNE   AS_L_PTRGET4_8             ; Nope
AS_L_PTRGET4_7:       JMP   AS_ARRAY                   ; Yes
AS_L_PTRGET4_8:       BIT   MS_Z_0014_SUBFLG                  ; Check top two bits of subflg
                      BMI   AS_L_PTRGET4_9             ; $80
                      BVS   AS_L_PTRGET4_7             ; $40, Called from getarypt
AS_L_PTRGET4_9:       LDA   #0                         ; Clear subflg
                      STA   MS_Z_0014_SUBFLG
                      LDA   MS_Z_0069_VARTAB                  ; Start lowtr at simple variable table
                      LDX   MS_Z_0069_VARTAB + 1
                      LDY   #0
AS_L_PTRGET4_10:      STX   MS_Z_009B_LOWTR + 1
AS_L_PTRGET4_11:      STA   MS_Z_009B_LOWTR
                      CPX   MS_Z_006B_ARYTAB + 1              ; End of simple variables?
                      BNE   AS_L_PTRGET4_12            ; No, go on
                      CMP   MS_Z_006B_ARYTAB                  ; Yes; end of arrays?
                      BEQ   AS_NAME_NOT_FOUND          ; Yes, make one
AS_L_PTRGET4_12:      LDA   MS_Z_0081_VARNAM                  ; Same first letter?
                      CMP   (MS_Z_009B_LOWTR),Y
                      BNE   AS_L_PTRGET4_13            ; Not same first letter
                      LDA   MS_Z_0081_VARNAM + 1              ; Same second letter?
                      INY
                      CMP   (MS_Z_009B_LOWTR),Y
                      BEQ   AS_SET_VARPNT_AND_YA       ; Yes, same variable name
                      DEY                              ; No, bump to next name
AS_L_PTRGET4_13:      CLC
                      LDA   MS_Z_009B_LOWTR
                      ADC   #7
                      BCC   AS_L_PTRGET4_11
                      INX
                      BNE   AS_L_PTRGET4_10            ; ...Always
                                                       ; --------------------------------
                                                       ; Check if (a) is ascii letter a-z

                                                       ; Return carry = 1 if a-z
                                                       ; = 0 If not

                                                       ; <<<Note faster and shorter code:    >>>
                                                       ; <<<    Cmp #lochar(`z')+1  compare hi end
                                                       ; <<<    Bcs l_ptrget4_1      above a-z
                                                       ; <<<    Cmp #lochar(`a')    compare lo end
                                                       ; <<<    Rts         c=0 if lo, c=1 if a-z
                                                       ; <<<L_ptrget4_1  clc         c=0 if hi
                                                       ; <<<    Rts
                                                       ; --------------------------------
AS_ISLETC:            CMP   #"A" & %01111111           ; Compare lo end
                      BCC   AS_L_ISLETC_1              ; C=0 if low
                      SBC   #("Z" & %01111111) + 1     ; Prepare hi end test
                      SEC                              ; Test hi end, restoring (a)
                      SBC   #255 - 'Z'                 ; C=0 if lo, c=1 if a-z
AS_L_ISLETC_1:        RTS
                                                       ; --------------------------------
                                                       ; Variable not found, so make one
                                                       ; --------------------------------
AS_NAME_NOT_FOUND:
                      PLA                              ; Look at return address on stack to
                      PHA                              ; See if called from frm.variable
                      CMP   #<AS_FRM_VARIABLE_CALL
                      BNE   AS_MAKE_NEW_VARIABLE       ; No
                      TSX
                      LDA   AS_STACK + 2,X
                      CMP   #>AS_FRM_VARIABLE_CALL
                      BNE   AS_MAKE_NEW_VARIABLE       ; No
                      LDA   #<AS_C_ZERO                ; Yes, called from frm.variable
                      LDY   #>AS_C_ZERO                ; Point to a constant zero
                      RTS                              ; New variable used in expression = 0
                                                       ; --------------------------------
AS_C_ZERO:            .byte 00, 00                     ; Integer or real zero, or null string
                                                       ; --------------------------------
                                                       ; Make a new simple variable

                                                       ; Move arrays up 7 bytes to make room for new variable
                                                       ; Enter 7-byte variable data in the hole
                                                       ; --------------------------------
AS_MAKE_NEW_VARIABLE:
                      LDA   MS_Z_006B_ARYTAB                  ; Set up call to bltu to
                      LDY   MS_Z_006B_ARYTAB + 1              ; To move from arytab thru strend-1
                      STA   MS_Z_009B_LOWTR                   ; 7 Bytes higher
                      STY   MS_Z_009B_LOWTR + 1
                      LDA   MS_Z_006D_STREND
                      LDY   MS_Z_006D_STREND + 1
                      STA   MS_Z_0096_HIGHTR
                      STY   MS_Z_0096_HIGHTR + 1
                      CLC
                      ADC   #7
                      BCC   AS_L_MAKE_NEW_VARIABLE_1
                      INY
AS_L_MAKE_NEW_VARIABLE_1: STA   MS_Z_0094_ARYPNT
                      STY   MS_Z_0094_ARYPNT + 1
                      JSR   AS_BLTU                    ; Move array block up
                      LDA   MS_Z_0094_ARYPNT                  ; Store new start of arrays
                      LDY   MS_Z_0094_ARYPNT + 1
                      INY
                      STA   MS_Z_006B_ARYTAB
                      STY   MS_Z_006B_ARYTAB + 1
                      LDY   #0
                      LDA   MS_Z_0081_VARNAM                  ; First char of name
                      STA   (MS_Z_009B_LOWTR),Y
                      INY
                      LDA   MS_Z_0081_VARNAM + 1              ; Second char of name
                      STA   (MS_Z_009B_LOWTR),Y
                      LDA   #0                         ; Set five-byte value to 0
                      INY
                      STA   (MS_Z_009B_LOWTR),Y
                      INY
                      STA   (MS_Z_009B_LOWTR),Y
                      INY
                      STA   (MS_Z_009B_LOWTR),Y
                      INY
                      STA   (MS_Z_009B_LOWTR),Y
                      INY
                      STA   (MS_Z_009B_LOWTR),Y
                                                       ; --------------------------------
                                                       ; Put address of value of variable in varpnt and y,a
                                                       ; --------------------------------
AS_SET_VARPNT_AND_YA:
                      LDA   MS_Z_009B_LOWTR                   ; Lowtr points at name of variable,
                      CLC                              ; So add 2 to get to value
                      ADC   #2
                      LDY   MS_Z_009B_LOWTR + 1
                      BCC   AS_L_SET_VARPNT_AND_YA_1
                      INY
AS_L_SET_VARPNT_AND_YA_1: STA   MS_Z_0083_VARPNT                  ; Address in varpnt and y,a
                      STY   MS_Z_0083_VARPNT + 1
                      RTS
                                                       ; --------------------------------
                                                       ; Compute address of first value in array
                                                       ; Arypnt = (lowtr) + #dims*2 + 5
                                                       ; --------------------------------
AS_GETARY:            LDA   AS_NUMDIM                  ; Get # of dimensions
                                                       ; --------------------------------
AS_GETARY2:
                      ASL                              ; #Dims*2 (size of each dim in 2 bytes)
                      ADC   #5                         ; + 5 (2 For name, 2 for offset to next
                                                       ; Array, and 1 for #dims
                      ADC   MS_Z_009B_LOWTR                   ; Address of th is array in arytab
                      LDY   MS_Z_009B_LOWTR + 1
                      BCC   AS_L_GETARY2_1
                      INY
AS_L_GETARY2_1:       STA   MS_Z_0094_ARYPNT                  ; Address of first value in array
                      STY   MS_Z_0094_ARYPNT + 1
                      RTS
                                                       ; --------------------------------

AS_NEG32768:          .byte $90, $80, $00, $00         ; -32768.00049 In floating point
                                                       ; <<<  Meant to be -32768, which would be 9080000000 >>>
                                                       ; <<<  1 Byte short, so picks up $20 from next instruction
                                                       ; --------------------------------
                                                       ; Evaluate numeric formula at txtptr
                                                       ; Converting result to integer 0 <= x <= 32767
                                                       ; In fac+3,4
                                                       ; --------------------------------
AS_MAKINT:            JSR   MS_Z_00B1_CHRGET
                      JSR   AS_FRMNUM
                                                       ; --------------------------------
                                                       ; Convert fac to integer
                                                       ; Must be positive and less than 32768
                                                       ; --------------------------------
AS_MKINT:             LDA   MS_Z_00A2_FACSGN                ; Error if -
                      BMI   AS_MI1
                                                       ; --------------------------------
                                                       ; Convert fac to integer
                                                       ; Must be -32767 <= fac <= 32767
                                                       ; --------------------------------
AS_AYINT:             LDA   MS_Z_009D_FAC                     ; Exponent of value in fac
                      CMP   #$90                       ; Abs(value) < 32768?
                      BCC   AS_MI2                     ; Yes, ok for integer
                      LDA   #<AS_NEG32768              ; No; next few lines are supposed to
                      LDY   #>AS_NEG32768              ; Allow -32768 ($8000), but do not!
                      JSR   AS_FCOMP                   ; Because compared to -32768.00049
                                                       ; <<< Bug:  a=-32768.00049:a%=a is accepted >>>
                                                       ; <<<       But print a,a% shows that       >>>
                                                       ; <<<       A=-32768.0005 (ok), a%=32767    >>>
                                                       ; <<<       Wrong! wrong! wrong!            >>>
                                                       ; --------------------------------
AS_MI1:               BNE   AS_IQERR                   ; Illegal quantity
AS_MI2:               JMP   AS_QINT                    ; Convert to integer
                                                       ; --------------------------------
                                                       ; Locate array element or create an array
                                                       ; --------------------------------
AS_ARRAY:             LDA   MS_Z_0014_SUBFLG                  ; Subscripts given?
                      BNE   AS_L_ARRAY_2               ; No
                                                       ; --------------------------------
                                                       ; Parse the subscript list
                                                       ; --------------------------------
                      LDA   MS_Z_0010_DIMFLG                  ; Yes
                      ORA   MS_Z_0011_VALTYP + 1              ; Set high bit if %
                      PHA                              ; Save valtyp and dimflg on stack
                      LDA   MS_Z_0011_VALTYP
                      PHA
                      LDY   #0                         ; Count # dimensions in y-reg
AS_L_ARRAY_1:         TYA                              ; Save #dims on stack
                      PHA
                      LDA   MS_Z_0081_VARNAM + 1              ; Save variable name on stack
                      PHA
                      LDA   MS_Z_0081_VARNAM
                      PHA
                      JSR   AS_MAKINT                  ; Evaluate subscript as integer
                      PLA                              ; Restore variable name
                      STA   MS_Z_0081_VARNAM
                      PLA
                      STA   MS_Z_0081_VARNAM + 1
                      PLA                              ; Restore # dims to y-reg
                      TAY
                      TSX                              ; Copy valtyp and dimflg on stack
                      LDA   AS_STACK + 2,X             ; To leave room for the subscript
                      PHA
                      LDA   AS_STACK + 1,X
                      PHA
                      LDA   MS_Z_009D_FAC + 3                 ; Get subscript value and place in the
                      STA   AS_STACK + 2,X             ; Stack where valtyp & dimflg were
                      LDA   MS_Z_009D_FAC + 4
                      STA   AS_STACK + 1,X
                      INY                              ; Count the subscript
                      JSR   MS_Z_00B7_CHRGOT                  ; Next char
                      CMP   #"," & %01111111
                      BEQ   AS_L_ARRAY_1               ; Comma, parse another subscript
                      STY   AS_NUMDIM                  ; No more subscripts, save #
                      JSR   AS_CHKCLS                  ; Now need ")"
                      PLA                              ; Restore valtype and dimflg
                      STA   MS_Z_0011_VALTYP
                      PLA
                      STA   MS_Z_0011_VALTYP + 1
                      AND   #$7F                       ; Isolate dimflg
                      STA   MS_Z_0010_DIMFLG
                                                       ; --------------------------------
                                                       ; Search array table for this array name
                                                       ; --------------------------------
AS_L_ARRAY_2:         LDX   MS_Z_006B_ARYTAB                  ; (A,x) = start of array table
                      LDA   MS_Z_006B_ARYTAB + 1
AS_L_ARRAY_3:         STX   MS_Z_009B_LOWTR                   ; Use lowtr for running pointer
                      STA   MS_Z_009B_LOWTR + 1
                      CMP   MS_Z_006D_STREND + 1              ; Did we reach the end of arrays yet?
                      BNE   AS_L_ARRAY_4               ; No, keep searching
                      CPX   MS_Z_006D_STREND
                      BEQ   AS_MAKE_NEW_ARRAY          ; Yes, this is a new array name
AS_L_ARRAY_4:         LDY   #0                         ; Point at 1st char of array name
                      LDA   (MS_Z_009B_LOWTR),Y               ; Get 1st char of name
                      INY                              ; Point at 2nd char
                      CMP   MS_Z_0081_VARNAM                  ; 1St char same?
                      BNE   AS_L_ARRAY_5               ; No, move to next array
                      LDA   MS_Z_0081_VARNAM + 1              ; Yes, try 2nd char
                      CMP   (MS_Z_009B_LOWTR),Y               ; Same?
                      BEQ   AS_USE_OLD_ARRAY           ; Yes, array found
AS_L_ARRAY_5:         INY                              ; Point at offset to next array
                      LDA   (MS_Z_009B_LOWTR),Y               ; Add offset to running pointer
                      CLC
                      ADC   MS_Z_009B_LOWTR
                      TAX
                      INY
                      LDA   (MS_Z_009B_LOWTR),Y
                      ADC   MS_Z_009B_LOWTR + 1
                      BCC   AS_L_ARRAY_3               ; ...Always
                                                       ; --------------------------------
                                                       ; Error:  bad subscripts
                                                       ; --------------------------------
AS_SUBERR:            LDX   #MS_E_ERRBS
                      .byte $2C                        ; Trick to skip next line
                                                       ; --------------------------------
                                                       ; Error:  illegal quantity
                                                       ; --------------------------------
AS_IQERR:             LDX   #MS_E_ERRFC
AS_JER:               JMP   MS_ERROR
                                                       ; --------------------------------
                                                       ; Found the array
                                                       ; --------------------------------
AS_USE_OLD_ARRAY:
                      LDX   #MS_E_ERRDD             ; Set up for redim'd array error
                      LDA   MS_Z_0010_DIMFLG                  ; Called from "dim" statement?
                      BNE   AS_JER                     ; Yes, error
                      LDA   MS_Z_0014_SUBFLG                  ; No, check if any subscripts
                      BEQ   AS_L_USE_OLD_ARRAY_1       ; Yes, need to check the number
                      SEC                              ; No, signal array found
                      RTS
                                                       ; --------------------------------
AS_L_USE_OLD_ARRAY_1: JSR   AS_GETARY                  ; Set (arypnt) = addr of first element
                      LDA   AS_NUMDIM                  ; Compare number of dimensions
                      LDY   #4
                      CMP   (MS_Z_009B_LOWTR),Y
                      BNE   AS_SUBERR                  ; Not same, subscript error
                      JMP   AS_FIND_ARRAY_ELEMENT
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; Create a new array, unless called from getarypt
                                                       ; --------------------------------
AS_MAKE_NEW_ARRAY:
                      LDA   MS_Z_0014_SUBFLG                  ; Called from getarypt?
                      BEQ   AS_L_MAKE_NEW_ARRAY_1      ; No
                      LDX   #MS_E_ERROD             ; Yes, give "out of data" error
                      JMP   MS_ERROR
AS_L_MAKE_NEW_ARRAY_1: JSR   AS_GETARY                  ; Put addr of 1st element in arypnt
                      JSR   AS_REASON                  ; Make sure enough memory left
                                                       ; --------------------------------
                                                       ; <<< Next 3 lines could be written:   >>>
                                                       ; Ldy #0
                                                       ; Sty strng2+1
                                                       ; --------------------------------
                      LDA   #0                         ; Point y-reg at variable name slot
                      TAY
                      STA   MS_Z_00AD_STRNG2 + 1              ; Start size computation
                      LDX   #5                         ; Assume 5-bytes per element
                      LDA   MS_Z_0081_VARNAM                  ; Stuff variable name in array
                      STA   (MS_Z_009B_LOWTR),Y
                      BPL   AS_L_MAKE_NEW_ARRAY_2      ; Not integer array
                      DEX                              ; Integer array, decr. size to 4-bytes
AS_L_MAKE_NEW_ARRAY_2: INY                              ; Point y-reg at next char of name
                      LDA   MS_Z_0081_VARNAM + 1              ; Rest of array name
                      STA   (MS_Z_009B_LOWTR),Y
                      BPL   AS_L_MAKE_NEW_ARRAY_3      ; Real array, stick with size = 5 bytes
                      DEX                              ; Integer or string array, adjust size
                      DEX                              ; To integer=3, string=2 bytes
AS_L_MAKE_NEW_ARRAY_3: STX   MS_Z_00AD_STRNG2                  ; Store low-byte of array element size
                      LDA   AS_NUMDIM                  ; Store number of dimensions
                      INY                              ; In 5th byte of array
                      INY
                      INY
                      STA   (MS_Z_009B_LOWTR),Y
AS_L_MAKE_NEW_ARRAY_4: LDX   #11                        ; Default dimension = 11 elements
                      LDA   #0                         ; For hi-byte of dimension if default
                      BIT   MS_Z_0010_DIMFLG                  ; Dimensioned array?
                      BVC   AS_L_MAKE_NEW_ARRAY_5      ; No, use default value
                      PLA                              ; Get specified dim in a,x
                      CLC                              ; # Elements is 1 larger than
                      ADC   #1                         ; Dimension value
                      TAX
                      PLA
                      ADC   #0
AS_L_MAKE_NEW_ARRAY_5: INY                              ; Add this dimension to array descriptor
                      STA   (MS_Z_009B_LOWTR),Y
                      INY
                      TXA
                      STA   (MS_Z_009B_LOWTR),Y
                      JSR   AS_MULTIPLY_SUBSCRIPT      ; Multiply this
                                                       ; Dimension by running size
                                                       ; ((Lowtr)) * (strng2) --> a,x
                      STX   MS_Z_00AD_STRNG2                  ; Store running size in strng2
                      STA   MS_Z_00AD_STRNG2 + 1
                      LDY   MS_Z_005E_INDEX                   ; Retrieve y saved by multiply.subscript
                      DEC   AS_NUMDIM                  ; Count down # dims
                      BNE   AS_L_MAKE_NEW_ARRAY_4      ; Loop till done
                                                       ; --------------------------------
                                                       ; Now a,x has total # bytes of array elements
                                                       ; --------------------------------
                      ADC   MS_Z_0094_ARYPNT + 1              ; Compute address of end of this array
                      BCS   AS_GME                     ; ...Too large, error
                      STA   MS_Z_0094_ARYPNT + 1
                      TAY
                      TXA
                      ADC   MS_Z_0094_ARYPNT
                      BCC   AS_L_MAKE_NEW_ARRAY_6
                      INY
                      BEQ   AS_GME                     ; ...Too large, error
AS_L_MAKE_NEW_ARRAY_6: JSR   AS_REASON                  ; Make sure there is room up to y,a
                      STA   MS_Z_006D_STREND                  ; There is room so save new end of table
                      STY   MS_Z_006D_STREND + 1              ; And zero the array
                      LDA   #0
                      INC   MS_Z_00AD_STRNG2 + 1              ; Prepare for fast zeroing loop
                      LDY   MS_Z_00AD_STRNG2                  ; # Bytes mod 256
                      BEQ   AS_L_MAKE_NEW_ARRAY_8      ; Full page
AS_L_MAKE_NEW_ARRAY_7: DEY                              ; Clear page full
                      STA   (MS_Z_0094_ARYPNT),Y
                      BNE   AS_L_MAKE_NEW_ARRAY_7
AS_L_MAKE_NEW_ARRAY_8: DEC   MS_Z_0094_ARYPNT + 1              ; Point to next page
                      DEC   MS_Z_00AD_STRNG2 + 1              ; Count the pages
                      BNE   AS_L_MAKE_NEW_ARRAY_7      ; Still more to clear
                      INC   MS_Z_0094_ARYPNT + 1              ; Recover last dec, point at 1st element
                      SEC
                      LDA   MS_Z_006D_STREND                  ; Compute offset to end of arrays
                      SBC   MS_Z_009B_LOWTR                   ; And store in array descriptor
                      LDY   #2
                      STA   (MS_Z_009B_LOWTR),Y
                      LDA   MS_Z_006D_STREND + 1
                      INY
                      SBC   MS_Z_009B_LOWTR + 1
                      STA   (MS_Z_009B_LOWTR),Y
                      LDA   MS_Z_0010_DIMFLG                  ; Was this called from "dim" statement?
                      BNE   AS_RTS_9                   ; Yes, we are finished
                      INY                              ; No, now need to find the element
                                                       ; --------------------------------
                                                       ; Find specified array element

                                                       ; (Lowtr),y points at # of dims in array descriptor
                                                       ; The subscripts are all on the stack as integers
                                                       ; --------------------------------
AS_FIND_ARRAY_ELEMENT:
                      LDA   (MS_Z_009B_LOWTR),Y               ; Get # of dimensions
                      STA   AS_NUMDIM
                      LDA   #0                         ; Zero subscript accumulator
                      STA   MS_Z_00AD_STRNG2
AS_FAE_1:             STA   MS_Z_00AD_STRNG2 + 1
                      INY
                      PLA                              ; Pull next subscript from stack
                      TAX                              ; Save in fac+3,4
                      STA   MS_Z_009D_FAC + 3                 ; And compare with dimensioned size
                      PLA
                      STA   MS_Z_009D_FAC + 4
                      CMP   (MS_Z_009B_LOWTR),Y
                      BCC   AS_FAE_2                   ; Subscript not too large
                      BNE   AS_GSE                     ; Subscript is too large
                      INY                              ; Check low-byte of subscript
                      TXA
                      CMP   (MS_Z_009B_LOWTR),Y
                      BCC   AS_FAE_3                   ; Not too large
                                                       ; --------------------------------
AS_GSE:               JMP   AS_SUBERR                  ; Bad subscripts error
AS_GME:               JMP   AS_MEMERR                  ; Mem full error
                                                       ; --------------------------------
AS_FAE_2:             INY                              ; Bump pointer into descriptor
AS_FAE_3:             LDA   MS_Z_00AD_STRNG2 + 1              ; Bypass multiplication if value so
                      ORA   MS_Z_00AD_STRNG2                  ; Far = 0
                      CLC
                      BEQ   AS_L_FAE_3_1               ; It is zero so far
                      JSR   AS_MULTIPLY_SUBSCRIPT      ; Not zero, so multiply
                      TXA                              ; Add current subscript
                      ADC   MS_Z_009D_FAC + 3
                      TAX
                      TYA
                      LDY   MS_Z_005E_INDEX                   ; Retrieve y saved by multiply.subscript
AS_L_FAE_3_1:         ADC   MS_Z_009D_FAC + 4                 ; Finish adding current subscript
                      STX   MS_Z_00AD_STRNG2                  ; Store accumulated offset
                      DEC   AS_NUMDIM                  ; Last subscript yet?
                      BNE   AS_FAE_1                   ; No, loop till done
                      STA   MS_Z_00AD_STRNG2 + 1              ; Yes, now multiply be element size
                      LDX   #5                         ; Start with size = 5
                      LDA   MS_Z_0081_VARNAM                  ; Determine variable type
                      BPL   AS_L_FAE_3_2               ; Not integer
                      DEX                              ; Integer, back down size to 4 bytes
AS_L_FAE_3_2:         LDA   MS_Z_0081_VARNAM + 1              ; Discriminate between real and str
                      BPL   AS_L_FAE_3_3               ; It is real
                      DEX                              ; Size = 3 if string, =2 if integer
                      DEX
AS_L_FAE_3_3:         STX   AS_RESULT + 2              ; Set up multiplier
                      LDA   #0                         ; Hi-byte of multiplier
                      JSR   AS_MULTIPLY_SUBS_1         ; (Strng2) by element size
                      TXA                              ; Add accumulated offset
                      ADC   MS_Z_0094_ARYPNT                  ; To address of 1st element
                      STA   MS_Z_0083_VARPNT                  ; To get address of specified element
                      TYA
                      ADC   MS_Z_0094_ARYPNT + 1
                      STA   MS_Z_0083_VARPNT + 1
                      TAY                              ; Return with addr in varpnt
                      LDA   MS_Z_0083_VARPNT                  ; And in y,a
AS_RTS_9:             RTS
                                                       ; --------------------------------
                                                       ; Multiply (strng2) by ((lowtr),y)
                                                       ; Leaving product in a,x.  (hi-byte also in y.)
                                                       ; Used only by array subscript routines
                                                       ; --------------------------------
AS_MULTIPLY_SUBSCRIPT:
                      STY   MS_Z_005E_INDEX                   ; Save y-reg
                      LDA   (MS_Z_009B_LOWTR),Y               ; Get multiplier
                      STA   AS_RESULT + 2              ; Save in result+2,3
                      DEY
                      LDA   (MS_Z_009B_LOWTR),Y
                                                       ; --------------------------------
AS_MULTIPLY_SUBS_1:
                      STA   AS_RESULT + 3              ; Low byte of multiplier
                      LDA   #16                        ; Multiply 16 bits
                      STA   AS_INDX
                      LDX   #0                         ; Product = 0 initially
                      LDY   #0
AS_L_MULTIPLY_SUBS_1_1: TXA                              ; Double product
                      ASL                              ; Low byte
                      TAX
                      TYA                              ; High byte
                      ROL                              ; If too large, set carry
                      TAY
                      BCS   AS_GME                     ; Too large, "mem full error"
                      ASL   MS_Z_00AD_STRNG2                  ; Next bit of mutlplicand
                      ROL   MS_Z_00AD_STRNG2 + 1              ; Into carry
                      BCC   AS_L_MULTIPLY_SUBS_1_2     ; Bit=0, don't need to add
                      CLC                              ; Bit=1, add into partial product
                      TXA
                      ADC   AS_RESULT + 2
                      TAX
                      TYA
                      ADC   AS_RESULT + 3
                      TAY
                      BCS   AS_GME                     ; Too large, "mem full error"
AS_L_MULTIPLY_SUBS_1_2: DEC   AS_INDX                    ; 16-Bits yet?
                      BNE   AS_L_MULTIPLY_SUBS_1_1     ; No, keep shuffling
                      RTS                              ; Yes, product in y,x and a,x
                                                       ; --------------------------------
                                                       ; "Fre" function

                                                       ; Collects garbage and returns # bytes of memory left
                                                       ; --------------------------------
MS_FRE:               LDA   MS_Z_0011_VALTYP                  ; Look at value of argument
                      BEQ   AS_L_FRE_1                 ; =0 Means real, =$FF means string
                      JSR   AS_FREFAC                  ; String, so set it free is temp
AS_L_FRE_1:           JSR   AS_GARBAG                  ; Collect all the garbage in sight
                      SEC                              ; Compute space between arrays and
                      LDA   MS_Z_006F_FRETOP                  ; String temp area
                      SBC   MS_Z_006D_STREND
                      TAY
                      LDA   MS_Z_006F_FRETOP + 1
                      SBC   MS_Z_006D_STREND + 1              ; Free space in y,a
                                                       ; Fall into givayf to float the value
                                                       ; Note that values over 32767 will return as negative
                                                       ; --------------------------------
                                                       ; Float the signed integer in a,y
                                                       ; --------------------------------
AS_GIVAYF:            LDX   #0                         ; Mark fac value type real
                      STX   MS_Z_0011_VALTYP
                      STA   MS_Z_009D_FAC + 1                 ; Save value from a,y in mantissa
                      STY   MS_Z_009D_FAC + 2
                      LDX   #$90                       ; Set exponent to 2^16
                      JMP   AS_FLOAT_1                 ; Convert to signed fp
                                                       ; --------------------------------
                                                       ; "Pos" function

                                                       ; Returns current line position from mon.ch
                                                       ; --------------------------------
MS_POS:               LDY   MON_CH                     ; Get a,y = (mon.ch, go to givayf
                                                       ; --------------------------------
                                                       ; Float (y) into fac, giving value 0-255
                                                       ; --------------------------------
AS_SNGFLT:            LDA   #0                         ; Msb = 0
                      SEC                              ; <<< No purpose whatsoever >>>
                      BEQ   AS_GIVAYF                  ; ...Always
                                                       ; --------------------------------
                                                       ; Check for direct or running mode
                                                       ; Giving error if direct mode
                                                       ; --------------------------------
AS_ERRDIR:            LDX   MS_Z_0075_CURLIN + 1              ; =$FF if direct mode
                      INX                              ; Makes $FF into zero
                      BNE   AS_RTS_9                   ; Return if running mode
                      LDX   #MS_E_ERRID             ; Direct mode, give error
                      .byte $2C                        ; Trick to skip next 2 bytes
                                                       ; --------------------------------
AS_UNDFNC:            LDX   #MS_E_ERRUF          ; Undefinded function error
                      JMP   MS_ERROR
                                                       ; --------------------------------
                                                       ; "Def" statement
                                                       ; --------------------------------
MS_DEF:               JSR   AS_FNC_                    ; Parse "fn", function name
                      JSR   AS_ERRDIR                  ; Error if in direct mode
                      JSR   AS_CHKOPN                  ; Need "("
                      LDA   #$80                       ; Flag ptrget that called from "def fn"
                      STA   MS_Z_0014_SUBFLG                  ; Allow only simple fp variable for arg
                      JSR   AS_PTRGET                  ; Get pntr to argument
                      JSR   AS_CHKNUM                  ; Must be numeric
                      JSR   AS_CHKCLS                  ; Must have ")" now
                      LDA   #MS_T_EQULTK            ; Now need "="
                      JSR   AS_SYNCHR                  ; Or else syntax error
                      PHA                              ; Save char after "="
                      LDA   MS_Z_0083_VARPNT + 1              ; Save pntr to argument
                      PHA
                      LDA   MS_Z_0083_VARPNT
                      PHA
                      LDA   MS_Z_00B8_TXTPTR + 1              ; Save txtptr
                      PHA
                      LDA   MS_Z_00B8_TXTPTR
                      PHA
                      JSR   MS_DATA                    ; Scan to next statement
                      JMP   AS_FNCDATA                 ; Store above 5 bytes in "value"
                                                       ; --------------------------------
                                                       ; Common routine for "deffn" and "fn", to
                                                       ; Parse "fn" and the function name
                                                       ; --------------------------------
AS_FNC_:              LDA   #MS_T_FNTK               ; Must now see "fn" token
                      JSR   AS_SYNCHR                  ; Or else syntax error
                      ORA   #$80                       ; Set sign bit on 1st char of name,
                      STA   MS_Z_0014_SUBFLG                  ; Making $C0 < subflg < $DB
                      JSR   AS_PTRGET3                 ; Which tells ptrget who called
                      STA   MS_Z_008A_DEFPNT                  ; Found valid function name, so
                      STY   MS_Z_008A_DEFPNT + 1              ; Save address
                      JMP   AS_CHKNUM                  ; Must be numeric
                                                       ; --------------------------------
                                                       ; "Fn" function call
                                                       ; --------------------------------
AS_FUNCT:             JSR   AS_FNC_                    ; Parse "fn", function name
                      LDA   MS_Z_008A_DEFPNT + 1              ; Stack function address
                      PHA                              ; In case of a nested fn call
                      LDA   MS_Z_008A_DEFPNT
                      PHA
                      JSR   AS_PARCHK                  ; Must now have "(expression)"
                      JSR   AS_CHKNUM                  ; Must be numeric expression
                      PLA                              ; Get function address back
                      STA   MS_Z_008A_DEFPNT
                      PLA
                      STA   MS_Z_008A_DEFPNT + 1
                      LDY   #2                         ; Point at add of argument variable
                      LDA   (MS_Z_008A_DEFPNT),Y
                      STA   MS_Z_0083_VARPNT
                      TAX
                      INY
                      LDA   (MS_Z_008A_DEFPNT),Y
                      BEQ   AS_UNDFNC                  ; Undefined function
                      STA   MS_Z_0083_VARPNT + 1
                      INY                              ; Y=4 now
AS_L_FUNCT_1:         LDA   (MS_Z_0083_VARPNT),Y              ; Save old value of argument variable
                      PHA                              ; On stack, in case also used as
                      DEY                              ; A normal variable!
                      BPL   AS_L_FUNCT_1
                      LDY   MS_Z_0083_VARPNT + 1              ; (Y,x)= address, store fac in variable
                      JSR   AS_STORE_FACDB_YX_ROUNDED
                      LDA   MS_Z_00B8_TXTPTR + 1              ; Remember txtptr after fn call
                      PHA
                      LDA   MS_Z_00B8_TXTPTR
                      PHA
                      LDA   (MS_Z_008A_DEFPNT),Y              ; Y=0 from movmf
                      STA   MS_Z_00B8_TXTPTR                  ; Point to function def'n
                      INY
                      LDA   (MS_Z_008A_DEFPNT),Y
                      STA   MS_Z_00B8_TXTPTR + 1
                      LDA   MS_Z_0083_VARPNT + 1              ; Save address of argument variable
                      PHA
                      LDA   MS_Z_0083_VARPNT
                      PHA
                      JSR   AS_FRMNUM                  ; Evaluate the function expression
                      PLA                              ; Get address of argument variable
                      STA   MS_Z_008A_DEFPNT                  ; And save it
                      PLA
                      STA   MS_Z_008A_DEFPNT + 1
                      JSR   MS_Z_00B7_CHRGOT                  ; Must be at ":" or eol
                      BEQ   AS_L_FUNCT_2               ; We are
                      JMP   AS_SYNERR                  ; We are not, slyntax error
AS_L_FUNCT_2:         PLA                              ; Retrieve txtptr after "fn" call
                      STA   MS_Z_00B8_TXTPTR
                      PLA
                      STA   MS_Z_00B8_TXTPTR + 1
                                                       ; Stack now has 5-byte value
                                                       ; Of the argument variable,
                                                       ; And fncnam points at the variable
                                                       ; --------------------------------
                                                       ; Store five bytes from stack at (fncnam)
                                                       ; --------------------------------
AS_FNCDATA:
                      LDY   #0
                      PLA
                      STA   (MS_Z_008A_DEFPNT),Y
                      PLA
                      INY
                      STA   (MS_Z_008A_DEFPNT),Y
                      PLA
                      INY
                      STA   (MS_Z_008A_DEFPNT),Y
                      PLA
                      INY
                      STA   (MS_Z_008A_DEFPNT),Y
                      PLA
                      INY
                      STA   (MS_Z_008A_DEFPNT),Y
                      RTS
                                                       ; --------------------------------
                                                       ; "Str$" function
                                                       ; --------------------------------
MS_STR:               JSR   AS_CHKNUM                  ; Expression must be numeric
                      LDY   #0                         ; Start string at stack-1 ($00FF)
                                                       ; So strlit can diffrentiate str$ calls
                      JSR   AS_FOUT_1                  ; Convert fac to string
                      PLA                              ; Pop return off stack
                      PLA
                      LDA   #<AS_STACK - 1             ; Point to stack-1
                      LDY   #>AS_STACK - 1             ; (Which=0)
                      BEQ   AS_STRLIT                  ; ...Always, create desc & move string
                                                       ; --------------------------------
                                                       ; Get space and make descriptor for string whose
                                                       ; Address is in fac+3,4 and whose length is in a-reg
                                                       ; --------------------------------
AS_STRINI:            LDX   MS_Z_009D_FAC + 3                 ; Y,x = string address
                      LDY   MS_Z_009D_FAC + 4
                      STX   MS_Z_008C_DSCPNT
                      STY   MS_Z_008C_DSCPNT + 1
                                                       ; --------------------------------
                                                       ; Get space and make descriptor for string whose
                                                       ; Address is in y,x and whose length is in a-reg
                                                       ; --------------------------------
AS_STRSPA:            JSR   AS_GETSPA                  ; A holds length
                      STX   MS_Z_009D_FAC + 1                 ; Save descriptor in fac
                      STY   MS_Z_009D_FAC + 2                 ; ---Fac--- --fac+1-- --fac+2--
                      STA   MS_Z_009D_FAC                     ; <Length>  <addr-lo> <addr-hi>
                      RTS
                                                       ; --------------------------------
                                                       ; Build a descriptor for string starting at y,a
                                                       ; And terminated by $00 or quotation mark
                                                       ; Return with descriptor in a temporary
                                                       ; And address of descriptor in fac+3,4
                                                       ; --------------------------------
AS_STRLIT:            LDX   #$22                       ; Set up literal scan to stop on
                      STX   MS_Z_000D_CHARAC                  ; Quotation mark or $00
                      STX   MS_Z_000E_ENDCHR
                                                       ; --------------------------------
                                                       ; Build a descriptor for string starting at y,a
                                                       ; And terminated by $00, (charac), or (endchr)

                                                       ; Return with descriptor in a temporary
                                                       ; And address of descriptor in fac+3,4
                                                       ; --------------------------------
AS_STRLT2:            STA   MS_Z_00AB_STRNG1                  ; Save address of string
                      STY   MS_Z_00AB_STRNG1 + 1
                      STA   MS_Z_009D_FAC + 1                 ; ...Again
                      STY   MS_Z_009D_FAC + 2
                      LDY   #$FF
AS_L_STRLT2_1:        INY                              ; Find end of string
                      LDA   (MS_Z_00AB_STRNG1),Y              ; Next string char
                      BEQ   AS_L_STRLT2_3              ; End of string
                      CMP   MS_Z_000D_CHARAC                  ; Alternate terminator # 1?
                      BEQ   AS_L_STRLT2_2              ; Yes
                      CMP   MS_Z_000E_ENDCHR                  ; Alternate terminator # 2?
                      BNE   AS_L_STRLT2_1              ; No, keep scanning
AS_L_STRLT2_2:        CMP   #$22                       ; Is string ended with quote mark?
                      BEQ   AS_L_STRLT2_4              ; Yes, c=1 to include " in string
AS_L_STRLT2_3:        CLC
AS_L_STRLT2_4:        STY   MS_Z_009D_FAC                     ; Save length
                      TYA
                      ADC   MS_Z_00AB_STRNG1                  ; Compute address of end of string
                      STA   MS_Z_00AD_STRNG2                  ; (Of 00 byte, or just after ")
                      LDX   MS_Z_00AB_STRNG1 + 1
                      BCC   AS_L_STRLT2_5
                      INX
AS_L_STRLT2_5:        STX   MS_Z_00AD_STRNG2 + 1
                      LDA   MS_Z_00AB_STRNG1 + 1              ; Where does the string start?
                      BEQ   AS_L_STRLT2_6              ; Page 0, must be from str$ function
                      CMP   #2                         ; Page 2?
                      BNE   AS_PUTNEW                  ; No, not page 0 or 2
AS_L_STRLT2_6:        TYA                              ; Length of string
                      JSR   AS_STRINI                  ; Make space for string
                      LDX   MS_Z_00AB_STRNG1
                      LDY   MS_Z_00AB_STRNG1 + 1
                      JSR   AS_MOVSTR                  ; Move it in
                                                       ; --------------------------------
                                                       ; Store descriptor in temporary descriptor stack

                                                       ; The descriptor is now in fac, fac+1, fac+2
                                                       ; Put address of temp descriptor in fac+3,4
                                                       ; --------------------------------
AS_PUTNEW:            LDX   MS_Z_0052_TEMPPT                  ; Pointer to next temp string slot
                      CPX   #MS_Z_0055_TEMPST + 9             ; Max of 3 temp strings
                      BNE   AS_PUTEMP                  ; Room for another one
                      LDX   #MS_E_ERRST             ; Too many, formula too complex
AS_JERR:              JMP   MS_ERROR
                                                       ; --------------------------------
AS_PUTEMP:            LDA   MS_Z_009D_FAC                     ; Copy temp descriptor into temp stack
                      STA   0,X
                      LDA   MS_Z_009D_FAC + 1
                      STA   1,X
                      LDA   MS_Z_009D_FAC + 2
                      STA   2,X
                      LDY   #0
                      STX   MS_Z_009D_FAC + 3                 ; Address of temp descriptor
                      STY   MS_Z_009D_FAC + 4                 ; In y,x and fac+3,4
                      DEY                              ; Y=$FF
                      STY   MS_Z_0011_VALTYP                  ; Flag (fac ) as string
                      STX   MS_Z_0053_LASTPT                  ; Index of last pointer
                      INX                              ; Update for next temp entry
                      INX
                      INX
                      STX   MS_Z_0052_TEMPPT
                      RTS
                                                       ; --------------------------------
                                                       ; Make space for string at bottom of string space
                                                       ; (A)=# bytes space to make

                                                       ; Return with (a) same,
                                                       ; And y,x = address of space allocated
                                                       ; --------------------------------
AS_GETSPA:            LSR   MS_Z_0013_GARBFL                  ; Clear signbit of flag
AS_L_GETSPA_1:        PHA                              ; A holds length
                      EOR   #$FF                       ; Get -length
                      SEC
                      ADC   MS_Z_006F_FRETOP                  ; Compute starting address of space
                      LDY   MS_Z_006F_FRETOP + 1              ; For the string
                      BCS   AS_L_GETSPA_2
                      DEY
AS_L_GETSPA_2:        CPY   MS_Z_006D_STREND + 1              ; See if fits in remaining memory
                      BCC   AS_L_GETSPA_4              ; No, try garbage
                      BNE   AS_L_GETSPA_3              ; Yes, it fits
                      CMP   MS_Z_006D_STREND                  ; Have to check lower bytes
                      BCC   AS_L_GETSPA_4              ; Not enuf room yet
AS_L_GETSPA_3:        STA   MS_Z_006F_FRETOP                  ; There is room so save new fretop
                      STY   MS_Z_006F_FRETOP + 1
                      STA   MS_Z_0071_FRESPC
                      STY   MS_Z_0071_FRESPC + 1
                      TAX                              ; Addr in y,x
                      PLA                              ; Length in a
                      RTS
AS_L_GETSPA_4:        LDX   #MS_E_ERROM
                      LDA   MS_Z_0013_GARBFL                  ; Garbage done yet?
                      BMI   AS_JERR                    ; Yes, memory is really full
                      JSR   AS_GARBAG                  ; No, try collecting now
                      LDA   #$80                       ; Flag that collected garbage already
                      STA   MS_Z_0013_GARBFL
                      PLA                              ; Get string length again
                      BNE   AS_L_GETSPA_1              ; ...Always
                                                       ; --------------------------------
                                                       ; Shove all referenced strings as high as possible
                                                       ; In memory (against himem), freeing up space
                                                       ; Below string area down to strend.
                                                       ; --------------------------------
AS_GARBAG:            LDX   MS_Z_0073_MEMSIZ                  ; Collect from top down
                      LDA   MS_Z_0073_MEMSIZ + 1
AS_FIND_HIGHEST_STRING:
                      STX   MS_Z_006F_FRETOP                  ; One pass through all vars
                      STA   MS_Z_006F_FRETOP + 1              ; For each active string!
                      LDY   #0
                      STY   MS_Z_008A_DEFPNT + 1              ; Flag in case no strings to collect
                      LDA   MS_Z_006D_STREND
                      LDX   MS_Z_006D_STREND + 1
                      STA   MS_Z_009B_LOWTR
                      STX   MS_Z_009B_LOWTR + 1
                                                       ; --------------------------------
                                                       ; Start by collecting temporaries
                                                       ; --------------------------------
                      LDA   #<MS_Z_0055_TEMPST
                      LDX   #>MS_Z_0055_TEMPST
                      STA   MS_Z_005E_INDEX
                      STX   MS_Z_005E_INDEX + 1
AS_L_FIND_HIGHEST_STRING_1: CMP   MS_Z_0052_TEMPPT                  ; Finished with temps yet?
                      BEQ   AS_L_FIND_HIGHEST_STRING_2 ; Yes, now do simple variables
                      JSR   AS_CHECK_VARIABLE          ; Do a temp
                      BEQ   AS_L_FIND_HIGHEST_STRING_1 ; ...Always
                                                       ; --------------------------------
                                                       ; Now collect simple variables
                                                       ; --------------------------------
AS_L_FIND_HIGHEST_STRING_2: LDA   #7                         ; Length of each variable is 7 bytes
                      STA   AS_DSCLEN
                      LDA   MS_Z_0069_VARTAB                  ; Start at beginning of vartab
                      LDX   MS_Z_0069_VARTAB + 1
                      STA   MS_Z_005E_INDEX
                      STX   MS_Z_005E_INDEX + 1
AS_L_FIND_HIGHEST_STRING_3: CPX   MS_Z_006B_ARYTAB + 1              ; Finished with simple variables?
                      BNE   AS_L_FIND_HIGHEST_STRING_4 ; No
                      CMP   MS_Z_006B_ARYTAB                  ; Maybe, check lo-byte
                      BEQ   AS_L_FIND_HIGHEST_STRING_5 ; Yes, now do arrays
AS_L_FIND_HIGHEST_STRING_4: JSR   AS_CHECK_SIMPLE_VARIABLE
                      BEQ   AS_L_FIND_HIGHEST_STRING_3 ; ...Always
                                                       ; --------------------------------
                                                       ; Now collect array variables
                                                       ; --------------------------------
AS_L_FIND_HIGHEST_STRING_5: STA   MS_Z_0094_ARYPNT
                      STX   MS_Z_0094_ARYPNT + 1
                      LDA   #3                         ; Descriptors in arrays are 3-bytes each
                      STA   AS_DSCLEN
AS_L_FIND_HIGHEST_STRING_6: LDA   MS_Z_0094_ARYPNT                  ; Compare to end of arrays
                      LDX   MS_Z_0094_ARYPNT + 1
AS_L_FIND_HIGHEST_STRING_7: CPX   MS_Z_006D_STREND + 1              ; Finished with arrays yet?
                      BNE   AS_L_FIND_HIGHEST_STRING_8 ; Not yet
                      CMP   MS_Z_006D_STREND                  ; Maybe, check lo-byte
                      BNE   AS_L_FIND_HIGHEST_STRING_8 ; Not finished yet
                      JMP   AS_MOVE_HIGHEST_STRING_TO_TOP ; Finished
AS_L_FIND_HIGHEST_STRING_8: STA   MS_Z_005E_INDEX                   ; Set up pntr to start of array
                      STX   MS_Z_005E_INDEX + 1
                      LDY   #0                         ; Point at name of array
                      LDA   (MS_Z_005E_INDEX),Y
                      TAX                              ; 1St letter of name in x-reg
                      INY
                      LDA   (MS_Z_005E_INDEX),Y
                      PHP                              ; Status from second letter of name
                      INY
                      LDA   (MS_Z_005E_INDEX),Y               ; Offset to next array
                      ADC   MS_Z_0094_ARYPNT                  ; (Carry always clear)
                      STA   MS_Z_0094_ARYPNT                  ; Calculate start of next array
                      INY
                      LDA   (MS_Z_005E_INDEX),Y               ; Hi-byte of offset
                      ADC   MS_Z_0094_ARYPNT + 1
                      STA   MS_Z_0094_ARYPNT + 1
                      PLP                              ; Get status from 2nd char of name
                      BPL   AS_L_FIND_HIGHEST_STRING_6 ; Not a string array
                      TXA                              ; Set status with 1st char of name
                      BMI   AS_L_FIND_HIGHEST_STRING_6 ; Not a string array
                      INY
                      LDA   (MS_Z_005E_INDEX),Y               ; # Of dimensions for this array
                      LDY   #0
                      ASL                              ; Preamble size = 2*#dims + 5
                      ADC   #5
                      ADC   MS_Z_005E_INDEX                   ; Make index point at first element
                      STA   MS_Z_005E_INDEX                   ; In the array
                      BCC   AS_L_FIND_HIGHEST_STRING_9
                      INC   MS_Z_005E_INDEX + 1
AS_L_FIND_HIGHEST_STRING_9:
                      LDX   MS_Z_005E_INDEX + 1               ; Step thru each string in this array
AS_L_FIND_HIGHEST_STRING_10: CPX   MS_Z_0094_ARYPNT + 1              ; Array done?
                      BNE   AS_L_FIND_HIGHEST_STRING_11 ; No, process next element
                      CMP   MS_Z_0094_ARYPNT                  ; Maybe, check lo-byte
                      BEQ   AS_L_FIND_HIGHEST_STRING_7 ; Yes, move to next array
AS_L_FIND_HIGHEST_STRING_11: JSR   AS_CHECK_VARIABLE          ; Process the array
                      BEQ   AS_L_FIND_HIGHEST_STRING_10 ; ...Always
                                                       ; --------------------------------
                                                       ; Process a simple variable
                                                       ; --------------------------------
AS_CHECK_SIMPLE_VARIABLE:
                      LDA   (MS_Z_005E_INDEX),Y               ; Look at 1st char of name
                      BMI   AS_CHECK_BUMP              ; Not a string variable
                      INY
                      LDA   (MS_Z_005E_INDEX),Y               ; Look at 2nd char of name
                      BPL   AS_CHECK_BUMP              ; Not a string variable
                      INY
                                                       ; --------------------------------
                                                       ; If string is not empty, check if it is highest
                                                       ; --------------------------------
AS_CHECK_VARIABLE:
                      LDA   (MS_Z_005E_INDEX),Y               ; Get length of string
                      BEQ   AS_CHECK_BUMP              ; Ignore string if length is zero
                      INY
                      LDA   (MS_Z_005E_INDEX),Y               ; Get address of string
                      TAX
                      INY
                      LDA   (MS_Z_005E_INDEX),Y
                      CMP   MS_Z_006F_FRETOP + 1              ; Check if already collected
                      BCC   AS_L_CHECK_VARIABLE_1      ; No, below fretop
                      BNE   AS_CHECK_BUMP              ; Yes, above fretop
                      CPX   MS_Z_006F_FRETOP                  ; Maybe, check lo-byte
                      BCS   AS_CHECK_BUMP              ; Yes, above fretop
AS_L_CHECK_VARIABLE_1: CMP   MS_Z_009B_LOWTR + 1               ; Above highest string found?
                      BCC   AS_CHECK_BUMP              ; No, ignore for now
                      BNE   AS_L_CHECK_VARIABLE_2      ; Yes, this is the new highest
                      CPX   MS_Z_009B_LOWTR                   ; Maybe, try lo-byte
                      BCC   AS_CHECK_BUMP              ; No, ignore for now
AS_L_CHECK_VARIABLE_2: STX   MS_Z_009B_LOWTR                   ; Make this the highest string
                      STA   MS_Z_009B_LOWTR + 1
                      LDA   MS_Z_005E_INDEX                   ; Save address of descriptor too
                      LDX   MS_Z_005E_INDEX + 1
                      STA   MS_Z_008A_DEFPNT
                      STX   MS_Z_008A_DEFPNT + 1
                      LDA   AS_DSCLEN
                      STA   MS_Z_0091_SIZE
                                                       ; --------------------------------
                                                       ; Add (dsclen) to pntr in index
                                                       ; Return with y=0, pntr also in x,a
                                                       ; --------------------------------
AS_CHECK_BUMP:
                      LDA   AS_DSCLEN                  ; Bump to next variable
                      CLC
                      ADC   MS_Z_005E_INDEX
                      STA   MS_Z_005E_INDEX
                      BCC   AS_CHECK_EXIT
                      INC   MS_Z_005E_INDEX + 1
                                                       ; --------------------------------
AS_CHECK_EXIT:
                      LDX   MS_Z_005E_INDEX + 1
                      LDY   #0
                      RTS
                                                       ; --------------------------------
                                                       ; Found highest non-empty string, so move it
                                                       ; To top and go back for another
                                                       ; --------------------------------
AS_MOVE_HIGHEST_STRING_TO_TOP:
                      LDX   MS_Z_008A_DEFPNT + 1              ; Any string found?
                      BEQ   AS_CHECK_EXIT              ; No, return
                      LDA   MS_Z_0091_SIZE                  ; Get length of variable element
                      AND   #4                         ; Was 7 or 3, make 4 or 0
                      LSR                              ; 2 0R 0; in simple variables,
                      TAY                              ; Name precedes descriptor
                      STA   MS_Z_0091_SIZE                  ; 2 Or 0
                      LDA   (MS_Z_008A_DEFPNT),Y              ; Get length from descriptor
                      ADC   MS_Z_009B_LOWTR                   ; Carry already cleared by lsr
                      STA   MS_Z_0096_HIGHTR                  ; String is btwn (lowtr) and (hightr)
                      LDA   MS_Z_009B_LOWTR + 1
                      ADC   #0
                      STA   MS_Z_0096_HIGHTR + 1
                      LDA   MS_Z_006F_FRETOP                  ; High end destination
                      LDX   MS_Z_006F_FRETOP + 1
                      STA   MS_Z_0094_HIGHDS
                      STX   MS_Z_0094_HIGHDS + 1
                      JSR   AS_BLTU2                   ; Move string up
                      LDY   MS_Z_0091_SIZE                  ; Fix its descriptor
                      INY                              ; Point at address in descriptor
                      LDA   MS_Z_0094_HIGHDS                  ; Store new address
                      STA   (MS_Z_008A_DEFPNT),Y
                      TAX
                      INC   MS_Z_0094_HIGHDS + 1              ; Correct bltu's overshoot
                      LDA   MS_Z_0094_HIGHDS + 1
                      INY
                      STA   (MS_Z_008A_DEFPNT),Y
                      JMP   AS_FIND_HIGHEST_STRING
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; Concatenate two strings
                                                       ; --------------------------------
AS_CAT:               LDA   MS_Z_009D_FAC + 4                 ; Save address of first descriptor
                      PHA
                      LDA   MS_Z_009D_FAC + 3
                      PHA
                      JSR   AS_FRM_ELEMENT             ; Get second string element
                      JSR   AS_CHKSTR                  ; Must be a string
                      PLA                              ; Recover addres of 1st descriptor
                      STA   MS_Z_00AB_STRNG1
                      PLA
                      STA   MS_Z_00AB_STRNG1 + 1
                      LDY   #0
                      LDA   (MS_Z_00AB_STRNG1),Y              ; Add lengths, get concatenated size
                      CLC
                      ADC   (MS_Z_009D_FAC + 3),Y
                      BCC   AS_L_CAT_1                 ; Ok if < $100
                      LDX   #MS_E_ERRLS
                      JMP   MS_ERROR
AS_L_CAT_1:           JSR   AS_STRINI                  ; Get space for concatenated strings
                      JSR   AS_MOVINS                  ; Move 1st string
                      LDA   MS_Z_008C_DSCPNT
                      LDY   MS_Z_008C_DSCPNT + 1
                      JSR   AS_FRETMP
                      JSR   AS_MOVSTR_1                ; Move 2nd string
                      LDA   MS_Z_00AB_STRNG1
                      LDY   MS_Z_00AB_STRNG1 + 1
                      JSR   AS_FRETMP
                      JSR   AS_PUTNEW                  ; Set up descriptor
                      JMP   AS_FRMEVL_2                ; Finish expression
                                                       ; --------------------------------
                                                       ; Get string descriptor pointed at by (strng1)
                                                       ; And move described string to (frespc)
                                                       ; --------------------------------
AS_MOVINS:            LDY   #0
                      LDA   (MS_Z_00AB_STRNG1),Y
                      PHA                              ; Length
                      INY
                      LDA   (MS_Z_00AB_STRNG1),Y
                      TAX                              ; Put string pointer in x,y
                      INY
                      LDA   (MS_Z_00AB_STRNG1),Y
                      TAY
                      PLA                              ; Retrieve length
                                                       ; --------------------------------
                                                       ; Move string at (y,x) with length (a)
                                                       ; To destination whose address is in frespc,frespc+1
                                                       ; --------------------------------
AS_MOVSTR:            STX   MS_Z_005E_INDEX                   ; Put pointer in index
                      STY   MS_Z_005E_INDEX + 1
AS_MOVSTR_1:
                      TAY                              ; Length to y-reg
                      BEQ   AS_L_MOVSTR_1_2            ; If length is zero, finished
                      PHA                              ; Save length on stack
AS_L_MOVSTR_1_1:      DEY                              ; Move bytes from (index) to (frespc)
                      LDA   (MS_Z_005E_INDEX),Y
                      STA   (MS_Z_0071_FRESPC),Y
                      TYA                              ; Test if any left to move
                      BNE   AS_L_MOVSTR_1_1            ; Yes, keep moving
                      PLA                              ; No, finished.  get length
AS_L_MOVSTR_1_2:      CLC                              ; And add to frespc, so
                      ADC   MS_Z_0071_FRESPC                  ; Frespc points to next higher
                      STA   MS_Z_0071_FRESPC                  ; Byte.  (used by concatenation)
                      BCC   AS_L_MOVSTR_1_3
                      INC   MS_Z_0071_FRESPC + 1
AS_L_MOVSTR_1_3:      RTS
                                                       ; --------------------------------
                                                       ; If (fac) is a temporary string, release descriptor
                                                       ; --------------------------------
AS_FRESTR:            JSR   AS_CHKSTR                  ; Last result a string?
                                                       ; --------------------------------
                                                       ; If string descriptor pointed to by fac+3,4 is
                                                       ; A temporary string, release it.
                                                       ; --------------------------------
AS_FREFAC:            LDA   MS_Z_009D_FAC + 3                 ; Get descriptor pointer
                      LDY   MS_Z_009D_FAC + 4
                                                       ; --------------------------------
                                                       ; If string descriptor whose address is in y,a is
                                                       ; A temporary string, release it.
                                                       ; --------------------------------
AS_FRETMP:            STA   MS_Z_005E_INDEX                   ; Save the address of the descriptor
                      STY   MS_Z_005E_INDEX + 1
                      JSR   AS_FRETMS                  ; Free descriptor if it is temporary
                      PHP                              ; Remember if temp
                      LDY   #0                         ; Point at length of string
                      LDA   (MS_Z_005E_INDEX),Y
                      PHA                              ; Save length on stack
                      INY
                      LDA   (MS_Z_005E_INDEX),Y
                      TAX                              ; Get address of string in y,x
                      INY
                      LDA   (MS_Z_005E_INDEX),Y
                      TAY
                      PLA                              ; Length in a
                      PLP                              ; Retrieve status, z=1 if temp
                      BNE   AS_L_FRETMP_2              ; Not a temporary string
                      CPY   MS_Z_006F_FRETOP + 1              ; Is it the lowest string?
                      BNE   AS_L_FRETMP_2              ; No
                      CPX   MS_Z_006F_FRETOP
                      BNE   AS_L_FRETMP_2              ; No
                      PHA                              ; Yes, push length again
                      CLC                              ; Recover the space used by
                      ADC   MS_Z_006F_FRETOP                  ; The string
                      STA   MS_Z_006F_FRETOP
                      BCC   AS_L_FRETMP_1
                      INC   MS_Z_006F_FRETOP + 1
AS_L_FRETMP_1:        PLA                              ; Retrieve length again
AS_L_FRETMP_2:        STX   MS_Z_005E_INDEX                   ; Address of string in y,x
                      STY   MS_Z_005E_INDEX + 1               ; Length of string in a-reg
                      RTS
                                                       ; --------------------------------
                                                       ; Release temporary descriptor if y,a = lastpt
                                                       ; --------------------------------
AS_FRETMS:            CPY   MS_Z_0053_LASTPT + 1              ; Compare y,a to latest temp
                      BNE   AS_L_FRETMS_1              ; Not same one, cannot release
                      CMP   MS_Z_0053_LASTPT
                      BNE   AS_L_FRETMS_1              ; Not same one, cannot release
                      STA   MS_Z_0052_TEMPPT                  ; Update tempt for next temp
                      SBC   #3                         ; Back off lastpt
                      STA   MS_Z_0053_LASTPT
                      LDY   #0                         ; Now y,a points to top temp
AS_L_FRETMS_1:        RTS                              ; Z=0 if not temp, z=1 if temp
                                                       ; --------------------------------
                                                       ; "Chr$" function
                                                       ; --------------------------------
MS_CHR:            JSR   AS_CONINT                  ; Convert argument to byte in x
                      TXA
                      PHA                              ; Save it
                      LDA   #1                         ; Get space for string of length 1
                      JSR   AS_STRSPA
                      PLA                              ; Recall the character
                      LDY   #0                         ; Put in string
                      STA   (MS_Z_009D_FAC + 1),Y
                      PLA                              ; Pop return address
                      PLA
                      JMP   AS_PUTNEW                  ; Make it a temporary string
                                                       ; --------------------------------
                                                       ; "Left$" function
                                                       ; --------------------------------
MS_LEFT:
                      JSR   AS_SUBSTRING_SETUP
                      CMP   (MS_Z_008C_DSCPNT),Y              ; Compare 1st parameter to length
                      TYA                              ; Y=a=0
AS_SUBSTRING_1:
                      BCC   AS_L_SUBSTRING_1_1         ; 1St parameter smaller, use it
                      LDA   (MS_Z_008C_DSCPNT),Y              ; 1St is longer, use string length
                      TAX                              ; In x-reg
                      TYA                              ; Y=a=0 again
AS_L_SUBSTRING_1_1:   PHA                              ; Push left end of substring
AS_SUBSTRING_2:
                      TXA
AS_SUBSTRING_3:
                      PHA                              ; Push length of substring
                      JSR   AS_STRSPA                  ; Make room for string of (a) bytes
                      LDA   MS_Z_008C_DSCPNT                  ; Release parameter string if temp
                      LDY   MS_Z_008C_DSCPNT + 1
                      JSR   AS_FRETMP
                      PLA                              ; Get length of substring
                      TAY                              ; In y-reg
                      PLA                              ; Get left end of substring
                      CLC                              ; Add to pointer to string
                      ADC   MS_Z_005E_INDEX
                      STA   MS_Z_005E_INDEX
                      BCC   AS_L_SUBSTRING_3_1
                      INC   MS_Z_005E_INDEX + 1
AS_L_SUBSTRING_3_1:   TYA                              ; Length
                      JSR   AS_MOVSTR_1                ; Copy string into space
                      JMP   AS_PUTNEW                  ; Add to temps
                                                       ; --------------------------------
                                                       ; "Right$" function
                                                       ; --------------------------------
MS_RIGHT:
                      JSR   AS_SUBSTRING_SETUP
                      CLC                              ; Compute length-width of substring
                      SBC   (MS_Z_008C_DSCPNT),Y              ; To get starting point in string
                      EOR   #$FF
                      JMP   AS_SUBSTRING_1             ; Join left$
                                                       ; --------------------------------
                                                       ; "Mid$" function
                                                       ; --------------------------------
MS_MID:            LDA   #$FF                       ; Flag whether 2nd parameter
                      STA   MS_Z_009D_FAC + 4
                      JSR   MS_Z_00B7_CHRGOT                  ; See if ")" yet
                      CMP   #")" & %01111111
                      BEQ   AS_L_MIDSTR_1              ; Yes, no 2nd parameter
                      JSR   AS_CHKCOM                  ; No, must have comma
                      JSR   AS_GETBYT                  ; Get 2nd param in x-reg
AS_L_MIDSTR_1:        JSR   AS_SUBSTRING_SETUP
                      DEX                              ; 1St parameter - 1
                      TXA
                      PHA
                      CLC
                      LDX   #0
                      SBC   (MS_Z_008C_DSCPNT),Y
                      BCS   AS_SUBSTRING_2
                      EOR   #$FF
                      CMP   MS_Z_009D_FAC + 4                 ; Use smaller of two
                      BCC   AS_SUBSTRING_3
                      LDA   MS_Z_009D_FAC + 4
                      BCS   AS_SUBSTRING_3             ; ...Always
                                                       ; --------------------------------
                                                       ; Common setup routine for left$, right$, mid$:
                                                       ; Require ")"; pop return adrs, get descriptor
                                                       ; Address, get 1st parameter of command
                                                       ; --------------------------------
AS_SUBSTRING_SETUP:
                      JSR   AS_CHKCLS                  ; Require ")"
                      PLA                              ; Save return address
                      TAY                              ; In y-reg and length
                      PLA
                      STA   MS_Z_0091_SIZE
                      PLA                              ; Pop previous return address
                      PLA                              ; (From gorout).
                      PLA                              ; Retrieve 1st parameter
                      TAX
                      PLA                              ; Get address of string descriptor
                      STA   MS_Z_008C_DSCPNT
                      PLA
                      STA   MS_Z_008C_DSCPNT + 1
                      LDA   MS_Z_0091_SIZE                  ; Restore return address
                      PHA
                      TYA
                      PHA
                      LDY   #0
                      TXA                              ; Get 1st parameter in a-reg
                      BEQ   AS_GOIQ                    ; Error if 0
                      RTS
                                                       ; --------------------------------
                                                       ; "Len" function
                                                       ; --------------------------------
MS_LEN:               JSR   AS_GETSTR                  ; Get lentgh in y-reg, make fac numeric
                      JMP   AS_SNGFLT                  ; Float y-reg into fac
                                                       ; --------------------------------
                                                       ; If last result is a temporary string, free it
                                                       ; Make valtyp numeric, return length in y-reg
                                                       ; --------------------------------
AS_GETSTR:            JSR   AS_FRESTR                  ; If last result is a string, free it
                      LDX   #0                         ; Make valtyp numeric
                      STX   MS_Z_0011_VALTYP
                      TAY                              ; Length of string to y-reg
                      RTS
                                                       ; --------------------------------
                                                       ; "Asc" function
                                                       ; --------------------------------
MS_ASC:               JSR   AS_GETSTR                  ; Get string, get length in y-reg
                      BEQ   AS_GOIQ                    ; Error if length 0
                      LDY   #0
                      LDA   (MS_Z_005E_INDEX),Y               ; Get 1st char of string
                      TAY
                      JMP   AS_SNGFLT                  ; Float y-reg into fac
                                                       ; --------------------------------
AS_GOIQ:              JMP   AS_IQERR                   ; Illegal quantity error
                                                       ; --------------------------------
                                                       ; Scan to next character and convert expression
                                                       ; To single byte in x-reg
                                                       ; --------------------------------
AS_GTBYTC:            JSR   MS_Z_00B1_CHRGET
                                                       ; --------------------------------
                                                       ; Evaluate expression at txtptr, and
                                                       ; Convert it to single byte in x-reg
                                                       ; --------------------------------
AS_GETBYT:            JSR   AS_FRMNUM
                                                       ; --------------------------------
                                                       ; Convert (fac) to single byte integer in x-reg
                                                       ; --------------------------------
AS_CONINT:            JSR   AS_MKINT                   ; Convert if in range -32767 to +32767
                      LDX   MS_Z_009D_FAC + 3                 ; Hi-byte must be zero
                      BNE   AS_GOIQ                    ; Value > 255, error
                      LDX   MS_Z_009D_FAC + 4                 ; Value in x-reg
                      JMP   MS_Z_00B7_CHRGOT                  ; Get next char in a-reg
                                                       ; --------------------------------
                                                       ; "Val" function
                                                       ; --------------------------------
MS_VAL:               JSR   AS_GETSTR                  ; Get pointer to string in index
                      BNE   AS_L_VAL_1                 ; Length non-zero
                      JMP   AS_ZERO_FAC                ; Return 0 if length=0
AS_L_VAL_1:           LDX   MS_Z_00B8_TXTPTR                  ; Save current txtptr
                      LDY   MS_Z_00B8_TXTPTR + 1
                      STX   MS_Z_00AD_STRNG2
                      STY   MS_Z_00AD_STRNG2 + 1
                      LDX   MS_Z_005E_INDEX
                      STX   MS_Z_00B8_TXTPTR                  ; Point txtptr to start of string
                      CLC
                      ADC   MS_Z_005E_INDEX                   ; Add length
                      STA   AS_DEST                    ; Point dest to end of string + 1
                      LDX   MS_Z_005E_INDEX + 1
                      STX   MS_Z_00B8_TXTPTR + 1
                      BCC   AS_L_VAL_2
                      INX
AS_L_VAL_2:           STX   AS_DEST + 1
                      LDY   #0                         ; Save byte that follows string
                      LDA   (AS_DEST),Y                ; On stack
                      PHA
                      LDA   #0                         ; And store $00 in its place
                      STA   (AS_DEST),Y
                                                       ; <<< That causes a bug if himem = $BFFF, >>>
                                                       ; <<< Because storing $00 at $C000 is no  >>>
                                                       ; <<< Use; $C000 will always be last char >>>
                                                       ; <<< Typed, so fin won't terminate until >>>
                                                       ; <<< It sees a zero at $C010!            >>>
                      JSR   MS_Z_00B7_CHRGOT                  ; Prime the pump
                      JSR   AS_FIN                     ; Evaluate string
                      PLA                              ; Get byte that should follow string
                      LDY   #0                         ; And put it back
                      STA   (AS_DEST),Y
                                                       ; Restore txtptr
                                                       ; --------------------------------
                                                       ; Copy strng2 into txtptr
                                                       ; --------------------------------
AS_POINT:             LDX   MS_Z_00AD_STRNG2
                      LDY   MS_Z_00AD_STRNG2 + 1
                      STX   MS_Z_00B8_TXTPTR
                      STY   MS_Z_00B8_TXTPTR + 1
                      RTS
                                                       ; --------------------------------
                                                       ; Evaluate "exp1,exp2"

                                                       ; Convert exp1 to 16-bit number in linnum
                                                       ; Convert exp2 to 8-bit number in x-reg
                                                       ; --------------------------------
AS_GTNUM:             JSR   AS_FRMNUM
                      JSR   AS_GETADR
                                                       ; --------------------------------
                                                       ; Evaluate ",expression"
                                                       ; Convert expression to single byte in x-reg
                                                       ; --------------------------------
AS_COMBYTE:
                      JSR   AS_CHKCOM                  ; Must have comma first
                      JMP   AS_GETBYT                  ; Convert expression to byte in x-reg
                                                       ; --------------------------------
                                                       ; Convert (fac) to a 16-bit value in linnum
                                                       ; --------------------------------
AS_GETADR:            LDA   MS_Z_009D_FAC                     ; Fac < 2^16?
                      CMP   #$91
                      BCS   AS_GOIQ                    ; No, illegal quantity
                      JSR   AS_QINT                    ; Convert to integer
                      LDA   MS_Z_009D_FAC + 3                 ; Copy it into linnum
                      LDY   MS_Z_009D_FAC + 4
                      STY   MS_Z_0050_LINNUM                  ; To linnum
                      STA   MS_Z_0050_LINNUM + 1
                      RTS
                                                       ; --------------------------------
                                                       ; "Peek" function
                                                       ; --------------------------------
MS_PEEK:              LDA   MS_Z_0050_LINNUM                  ; Save (linnum) on stack during peek
                      PHA
                      LDA   MS_Z_0050_LINNUM + 1
                      PHA
                      JSR   AS_GETADR                  ; Get address peeking at
                      LDY   #0
                      LDA   (MS_Z_0050_LINNUM),Y              ; Take a quick look
                      TAY                              ; Value in y-reg
                      PLA                              ; Restore linnum from stack
                      STA   MS_Z_0050_LINNUM + 1
                      PLA
                      STA   MS_Z_0050_LINNUM
                      JMP   AS_SNGFLT                  ; Float y-reg into fac
                                                       ; --------------------------------
                                                       ; "Poke" statement
                                                       ; --------------------------------
MS_POKE:              JSR   AS_GTNUM                   ; Get the address and value
                      TXA                              ; Value in a,
                      LDY   #0
                      STA   (MS_Z_0050_LINNUM),Y              ; Store it away,
                      RTS                              ; And that's all for today
                                                       ; --------------------------------
                                                       ; "Wait" statement
                                                       ; --------------------------------
MS_FNWAIT:              JSR   AS_GTNUM                   ; Get address in linnum, mask in x
                      STX   MS_Z_0085_FORPNT                  ; Save mask
                      LDX   #0
                      JSR   MS_Z_00B7_CHRGOT                  ; Another parameter?
                      BEQ   AS_L_WAIT_1                ; No, use $00 for exclusive-or
                      JSR   AS_COMBYTE                 ; Get xor-mask
AS_L_WAIT_1:          STX   MS_Z_0085_FORPNT + 1              ; Save xor-mask here
                      LDY   #0
AS_L_WAIT_2:          LDA   (MS_Z_0050_LINNUM),Y              ; Get byte at address
                      EOR   MS_Z_0085_FORPNT + 1              ; Invert specified bits
                      AND   MS_Z_0085_FORPNT                  ; Select specified bits
                      BEQ   AS_L_WAIT_2                ; Loop till not 0
AS_RTS_10:            RTS
                                                       ; --------------------------------
                                                       ; Add 0l_rts_10_5 to fac
                                                       ; --------------------------------
AS_FADDH:             LDA   #<AS_CON_HALF              ; Fac+1/2 -> fac
                      LDY   #>AS_CON_HALF
                      JMP   AS_FADD
                                                       ; --------------------------------
                                                       ; Fac = (y,a) - fac
                                                       ; --------------------------------
AS_FSUB:              JSR   AS_LOAD_ARG_FROM_YA
                                                       ; --------------------------------
                                                       ; Fac = arg - fac
                                                       ; --------------------------------
MS_FSUBT:             LDA   MS_Z_00A2_FACSGN                ; Complement fac and add
                      EOR   #$FF
                      STA   MS_Z_00A2_FACSGN
                      EOR   MS_Z_00AA_ARGSGN                ; Fix sgncpr too
                      STA   MS_Z_00AB_ARISGN
                      LDA   MS_Z_009D_FAC                     ; Make status show fac exponent
                      JMP   MS_FADDT                   ; Join fadd
                                                       ; --------------------------------
                                                       ; Shift smaller argument more than 7 bits
                                                       ; --------------------------------
AS_FADD_1:            JSR   AS_SHIFT_RIGHT             ; Align radix by shifting
                      BCC   AS_FADD_3                  ; ...Always
                                                       ; --------------------------------
                                                       ; Fac = (y,a) + fac
                                                       ; --------------------------------
AS_FADD:              JSR   AS_LOAD_ARG_FROM_YA
                                                       ; --------------------------------
                                                       ; Fac = arg + fac
                                                       ; --------------------------------
MS_FADDT:             BNE   AS_L_FADDT_1               ; Fac is non-zero
                      JMP   AS_COPY_ARG_TO_FAC         ; Fac = 0 + arg
AS_L_FADDT_1:         LDX   MS_Z_00AC_FACOV
                      STX   MS_Z_0092_OLDOV
                      LDX   #MS_Z_00A5_ARGEXP                    ; Set up to shift arg
                      LDA   MS_Z_00A5_ARGEXP                     ; Exponent
                                                       ; --------------------------------
AS_FADD_2:            TAY
                      BEQ   AS_RTS_10                  ; If arg=0, we are finished
                      SEC
                      SBC   MS_Z_009D_FAC                     ; Get diffnce of exp
                      BEQ   AS_FADD_3                  ; Go add if same exp
                      BCC   AS_L_FADD_2_1              ; Arg has smaller exponent
                      STY   MS_Z_009D_FAC                     ; Exp has smaller exponent
                      LDY   MS_Z_00AA_ARGSGN
                      STY   MS_Z_00A2_FACSGN
                      EOR   #$FF                       ; Complement shift count
                      ADC   #0                         ; Carry was set
                      LDY   #0
                      STY   MS_Z_0092_OLDOV
                      LDX   #MS_Z_009D_FAC                    ; Set up to shift fac
                      BNE   AS_L_FADD_2_2              ; ...Always
AS_L_FADD_2_1:        LDY   #0
                      STY   MS_Z_00AC_FACOV
AS_L_FADD_2_2:        CMP   #$F9                       ; Shift more than 7 bits?
                      BMI   AS_FADD_1                  ; Yes
                      TAY                              ; Index to # of shifts
                      LDA   MS_Z_00AC_FACOV
                      LSR   1,X                        ; Start shifting...
                      JSR   AS_SHIFT_RIGHT_4           ; ...Complete shifting
AS_FADD_3:            BIT   MS_Z_00AB_ARISGN                  ; Do fac and arg have same signs?
                      BPL   AS_FADD_4                  ; Yes, add the mantissas
                      LDY   #MS_Z_009D_FAC                    ; No, subtract smaller from larger
                      CPX   #MS_Z_00A5_ARGEXP                    ; Which was adjusted?
                      BEQ   AS_L_FADD_3_1              ; If arg, do fac-arg
                      LDY   #MS_Z_00A5_ARGEXP                    ; If fac, do arg-fac
AS_L_FADD_3_1:        SEC                              ; Subtract smaller from larger (we hope)
                      EOR   #$FF                       ; (If exponents were equal, we might be
                      ADC   MS_Z_0092_OLDOV           ; Subtracting larger from smaller)
                      STA   MS_Z_00AC_FACOV
                      LDA   4,Y
                      SBC   4,X
                      STA   MS_Z_009D_FAC + 4
                      LDA   3,Y
                      SBC   3,X
                      STA   MS_Z_009D_FAC + 3
                      LDA   2,Y
                      SBC   2,X
                      STA   MS_Z_009D_FAC + 2
                      LDA   1,Y
                      SBC   1,X
                      STA   MS_Z_009D_FAC + 1
                                                       ; --------------------------------
                                                       ; Normalize value in fac
                                                       ; --------------------------------
AS_NORMALIZE_FAC_1:
                      BCS   AS_NORMALIZE_FAC_2
                      JSR   AS_COMPLEMENT_FAC
                                                       ; --------------------------------
AS_NORMALIZE_FAC_2:
                      LDY   #0                         ; Shift up signif digit
                      TYA                              ; Start a=0, count shifts in a-reg
                      CLC
AS_L_NORMALIZE_FAC_2_1: LDX   MS_Z_009D_FAC + 1                 ; Look at most significant byte
                      BNE   AS_NORMALIZE_FAC_4         ; Some 1-bits here
                      LDX   MS_Z_009D_FAC + 2                 ; Hi-byte of mantissa still zero,
                      STX   MS_Z_009D_FAC + 1                 ; So do a fast 8-bit shuffle
                      LDX   MS_Z_009D_FAC + 3
                      STX   MS_Z_009D_FAC + 2
                      LDX   MS_Z_009D_FAC + 4
                      STX   MS_Z_009D_FAC + 3
                      LDX   MS_Z_00AC_FACOV
                      STX   MS_Z_009D_FAC + 4
                      STY   MS_Z_00AC_FACOV           ; Zero extension byte
                      ADC   #8                         ; Bump shift count
                      CMP   #32                        ; Done 4 times yet?
                      BNE   AS_L_NORMALIZE_FAC_2_1     ; No, still might be some 1's
                                                       ; Yes, value of fac is zero
                                                       ; --------------------------------
                                                       ; Set fac = 0
                                                       ; (Only necessary to zero exponent and sign cells)
                                                       ; --------------------------------
AS_ZERO_FAC:
                      LDA   #0
                                                       ; --------------------------------
AS_STA_IN_FAC_SIGN_AND_EXP:
                      STA   MS_Z_009D_FAC
                                                       ; --------------------------------
AS_STA_IN_FAC_SIGN:
                      STA   MS_Z_00A2_FACSGN
                      RTS
                                                       ; --------------------------------
                                                       ; Add mantissas of fac and arg into fac
                                                       ; --------------------------------
AS_FADD_4:            ADC   MS_Z_0092_OLDOV
                      STA   MS_Z_00AC_FACOV
                      LDA   MS_Z_009D_FAC + 4
                      ADC   MS_Z_00A5_ARGEXP + 4
                      STA   MS_Z_009D_FAC + 4
                      LDA   MS_Z_009D_FAC + 3
                      ADC   MS_Z_00A5_ARGEXP + 3
                      STA   MS_Z_009D_FAC + 3
                      LDA   MS_Z_009D_FAC + 2
                      ADC   MS_Z_00A5_ARGEXP + 2
                      STA   MS_Z_009D_FAC + 2
                      LDA   MS_Z_009D_FAC + 1
                      ADC   MS_Z_00A5_ARGEXP + 1
                      STA   MS_Z_009D_FAC + 1
                      JMP   AS_NORMALIZE_FAC_5
                                                       ; --------------------------------
                                                       ; Finish normalizing fac
                                                       ; --------------------------------
AS_NORMALIZE_FAC_3:
                      ADC   #1                         ; Count bits shifted
                      ASL   MS_Z_00AC_FACOV
                      ROL   MS_Z_009D_FAC + 4
                      ROL   MS_Z_009D_FAC + 3
                      ROL   MS_Z_009D_FAC + 2
                      ROL   MS_Z_009D_FAC + 1
                                                       ; --------------------------------
AS_NORMALIZE_FAC_4:
                      BPL   AS_NORMALIZE_FAC_3         ; Until top bit = 1
                      SEC
                      SBC   MS_Z_009D_FAC                     ; Adjust exponent by bits shifted
                      BCS   AS_ZERO_FAC                ; Underflow, return zero
                      EOR   #$FF
                      ADC   #1                         ; 2'S complement
                      STA   MS_Z_009D_FAC                     ; Carry=0 now
                                                       ; --------------------------------
AS_NORMALIZE_FAC_5:
                      BCC   AS_RTS_11                  ; Unless mantissa carried
                                                       ; --------------------------------
AS_NORMALIZE_FAC_6:
                      INC   MS_Z_009D_FAC                     ; Mantissa carried, so shift right
                      BEQ   AS_OVERFLOW                ; Overflow if exponent too big
                      ROR   MS_Z_009D_FAC + 1
                      ROR   MS_Z_009D_FAC + 2
                      ROR   MS_Z_009D_FAC + 3
                      ROR   MS_Z_009D_FAC + 4
                      ROR   MS_Z_00AC_FACOV
AS_RTS_11:            RTS
                                                       ; --------------------------------
                                                       ; 2'S complement of fac
                                                       ; --------------------------------
AS_COMPLEMENT_FAC:
                      LDA   MS_Z_00A2_FACSGN
                      EOR   #$FF
                      STA   MS_Z_00A2_FACSGN
                                                       ; --------------------------------
                                                       ; 2'S complement of fac mantissa only
                                                       ; --------------------------------
AS_COMPLEMENT_FAC_MANTISSA:
                      LDA   MS_Z_009D_FAC + 1
                      EOR   #$FF
                      STA   MS_Z_009D_FAC + 1
                      LDA   MS_Z_009D_FAC + 2
                      EOR   #$FF
                      STA   MS_Z_009D_FAC + 2
                      LDA   MS_Z_009D_FAC + 3
                      EOR   #$FF
                      STA   MS_Z_009D_FAC + 3
                      LDA   MS_Z_009D_FAC + 4
                      EOR   #$FF
                      STA   MS_Z_009D_FAC + 4
                      LDA   MS_Z_00AC_FACOV
                      EOR   #$FF
                      STA   MS_Z_00AC_FACOV
                      INC   MS_Z_00AC_FACOV           ; Start incrementing mantissa
                      BNE   AS_RTS_12
                                                       ; --------------------------------
                                                       ; Increment fac mantissa
                                                       ; --------------------------------
AS_INCREMENT_FAC_MANTISSA:
                      INC   MS_Z_009D_FAC + 4                 ; Add carry from extra
                      BNE   AS_RTS_12
                      INC   MS_Z_009D_FAC + 3
                      BNE   AS_RTS_12
                      INC   MS_Z_009D_FAC + 2
                      BNE   AS_RTS_12
                      INC   MS_Z_009D_FAC + 1
AS_RTS_12:            RTS
                                                       ; --------------------------------
AS_OVERFLOW:
                      LDX   #MS_E_ERROV
                      JMP   MS_ERROR
                                                       ; --------------------------------
                                                       ; Shift 1,x thru 5,x right
                                                       ; (A) = negative of shift count
                                                       ; (X) = pointer to bytes to be shifted

                                                       ; Return with (y)=0, carry=0, extension bits in a-reg
                                                       ; --------------------------------
AS_SHIFT_RIGHT_1:
                      LDX   #AS_RESULT - 1             ; Shift result right
AS_SHIFT_RIGHT_2:
                      LDY   4,X                        ; Shift 8 bits right
                      STY   MS_Z_00AC_FACOV
                      LDY   3,X
                      STY   4,X
                      LDY   2,X
                      STY   3,X
                      LDY   1,X
                      STY   2,X
                      LDY   AS_SHIFT_SIGN_EXT          ; $00 If +, $FF if -
                      STY   1,X
                                                       ; --------------------------------
                                                       ; Main entry to right shift subroutine
                                                       ; --------------------------------
AS_SHIFT_RIGHT:
                      ADC   #8
                      BMI   AS_SHIFT_RIGHT_2           ; Still more than 8 bits to go
                      BEQ   AS_SHIFT_RIGHT_2           ; Exactly 8 more bits to go
                      SBC   #8                         ; Undo adc above
                      TAY                              ; Remaining shift count
                      LDA   MS_Z_00AC_FACOV
                      BCS   AS_SHIFT_RIGHT_5           ; Finished shifting
AS_SHIFT_RIGHT_3:
AS_L:                 ASL   1,X                        ; Sign -> carry (sign extension)
                      BCC   AS_L_L_1                   ; Sign +
                      INC   1,X                        ; Put sign in lsb
AS_L_L_1:             ROR   1,X                        ; Restore value, sign still in carry
                      ROR   1,X                        ; Start right shift, inserting sign
                                                       ; --------------------------------
                                                       ; Enter here for short shifts with no sign extension
                                                       ; --------------------------------
AS_SHIFT_RIGHT_4:
                      ROR   2,X
                      ROR   3,X
                      ROR   4,X
                      ROR                              ; Extension
                      INY                              ; Count the shift
                      BNE   AS_SHIFT_RIGHT_3
AS_SHIFT_RIGHT_5:
                      CLC                              ; Return with carry clear
                      RTS
                                                       ; --------------------------------
                                                       ; --------------------------------

AS_CON_ONE:           .byte $81, $00, $00, $00, $00
                                                       ; --------------------------------
AS_POLY_LOG:          .byte 3                          ; # Of coefficients - 1
                      .byte $7F, $5E, $56, $CB, $79    ; * X^7 +
                      .byte $80, $13, $9B, $0B, $64    ; * X^5 +
                      .byte $80, $76, $38, $93, $16    ; * X^3 +
                      .byte $82, $38, $AA, $3B, $20    ; * X
                                                       ; --------------------------------

AS_CON_SQR_HALF:      .byte $80, $35, $04, $F3, $34
AS_CON_SQR_TWO:       .byte $81, $35, $04, $F3, $34
AS_CON_NEG_HALF:      .byte $80, $80, $00, $00, $00
AS_CON_LOG_TWO:       .byte $80, $31, $72, $17, $F8
                                                       ; --------------------------------
                                                       ; "Log" function
                                                       ; --------------------------------
MS_LOG:               JSR   AS_SIGN                    ; Get -1,0,+1 in a-reg for fac
                      BEQ   AS_GIQ                     ; Log (0) is illegal
                      BPL   AS_LOG_2                   ; >0 Is ok
AS_GIQ:               JMP   AS_IQERR                   ; <= 0 Is no good
AS_LOG_2:             LDA   MS_Z_009D_FAC                     ; First get log base 2
                      SBC   #$7F                       ; Save unbiased exponent
                      PHA
                      LDA   #$80                       ; Normalize between l_log_2_5 and 1
                      STA   MS_Z_009D_FAC
                      LDA   #<AS_CON_SQR_HALF
                      LDY   #>AS_CON_SQR_HALF
                      JSR   AS_FADD                    ; Compute via series of odd
                      LDA   #<AS_CON_SQR_TWO           ; Powers of
                      LDY   #>AS_CON_SQR_TWO           ; (Sqr(2)x-1)/(sqr(2)x+1)
                      JSR   AS_FDIV
                      LDA   #<AS_CON_ONE
                      LDY   #>AS_CON_ONE
                      JSR   AS_FSUB
                      LDA   #<AS_POLY_LOG
                      LDY   #>AS_POLY_LOG
                      JSR   AS_POLYNOMIAL_ODD
                      LDA   #<AS_CON_NEG_HALF
                      LDY   #>AS_CON_NEG_HALF
                      JSR   AS_FADD
                      PLA
                      JSR   AS_ADDACC                  ; Add original exponent
                      LDA   #<AS_CON_LOG_TWO           ; Multiply by log(2) to form
                      LDY   #>AS_CON_LOG_TWO           ; Natural log of x
                                                       ; --------------------------------
                                                       ; Fac = (y,a) * fac
                                                       ; --------------------------------
AS_FMULT:             JSR   AS_LOAD_ARG_FROM_YA
                                                       ; --------------------------------
                                                       ; Fac = arg * fac
                                                       ; --------------------------------
MS_FMULTT:            BNE   AS_L_FMULTT_1              ; Fac .ne. zero
                      JMP   AS_RTS_13                  ; Fac = 0 * arg = 0
                                                       ; <<< Why is line above just "rts"? >>>
                                                       ; --------------------------------

                                                       ; --------------------------------
AS_L_FMULTT_1:        JSR   AS_ADD_EXPONENTS
                      LDA   #0
                      STA   AS_RESULT                  ; Init product = 0
                      STA   AS_RESULT + 1
                      STA   AS_RESULT + 2
                      STA   AS_RESULT + 3
                      LDA   MS_Z_00AC_FACOV
                      JSR   AS_MULTIPLY_1
                      LDA   MS_Z_009D_FAC + 4
                      JSR   AS_MULTIPLY_1
                      LDA   MS_Z_009D_FAC + 3
                      JSR   AS_MULTIPLY_1
                      LDA   MS_Z_009D_FAC + 2
                      JSR   AS_MULTIPLY_1
                      LDA   MS_Z_009D_FAC + 1
                      JSR   AS_MULTIPLY_2
                      JMP   AS_COPY_RESULT_INTO_FAC
                                                       ; --------------------------------
                                                       ; Multiply arg by (a) into result
                                                       ; --------------------------------
AS_MULTIPLY_1:
                      BNE   AS_MULTIPLY_2              ; This byte non-zero
                      JMP   AS_SHIFT_RIGHT_1           ; (A)=0, just shift arg right 8
                                                       ; --------------------------------
AS_MULTIPLY_2:
                      LSR                              ; Shift bit into carry
                      ORA   #$80                       ; Supply sentinel bit
AS_L_MULTIPLY_2_1:    TAY                              ; Remaining multiplier to y
                      BCC   AS_L_MULTIPLY_2_2          ; This multiplier bit = 0
                      CLC                              ; = 1, So add arg to result
                      LDA   AS_RESULT + 3
                      ADC   MS_Z_00A5_ARGEXP + 4
                      STA   AS_RESULT + 3
                      LDA   AS_RESULT + 2
                      ADC   MS_Z_00A5_ARGEXP + 3
                      STA   AS_RESULT + 2
                      LDA   AS_RESULT + 1
                      ADC   MS_Z_00A5_ARGEXP + 2
                      STA   AS_RESULT + 1
                      LDA   AS_RESULT
                      ADC   MS_Z_00A5_ARGEXP + 1
                      STA   AS_RESULT
AS_L_MULTIPLY_2_2:    ROR   AS_RESULT                  ; Shift result right 1
                      ROR   AS_RESULT + 1
                      ROR   AS_RESULT + 2
                      ROR   AS_RESULT + 3
                      ROR   MS_Z_00AC_FACOV
                      TYA                              ; Remaining multiplier
                      LSR                              ; Lsb into carry
                      BNE   AS_L_MULTIPLY_2_1          ; If sentinel still here, multiply
AS_RTS_13:            RTS                              ; 8 X 32 completed
                                                       ; --------------------------------
                                                       ; Unpack number at (y,a) into arg
                                                       ; --------------------------------
AS_LOAD_ARG_FROM_YA:
                      STA   MS_Z_005E_INDEX                   ; Use index for pntr
                      STY   MS_Z_005E_INDEX + 1
                      LDY   #4                         ; Five bytes to move
                      LDA   (MS_Z_005E_INDEX),Y
                      STA   MS_Z_00A5_ARGEXP + 4
                      DEY
                      LDA   (MS_Z_005E_INDEX),Y
                      STA   MS_Z_00A5_ARGEXP + 3
                      DEY
                      LDA   (MS_Z_005E_INDEX),Y
                      STA   MS_Z_00A5_ARGEXP + 2
                      DEY
                      LDA   (MS_Z_005E_INDEX),Y
                      STA   MS_Z_00AA_ARGSGN
                      EOR   MS_Z_00A2_FACSGN                ; Set combined sign for mult/div
                      STA   MS_Z_00AB_ARISGN
                      LDA   MS_Z_00AA_ARGSGN                ; Turn on normalized invisible bit
                      ORA   #$80                       ; To complete mantissa
                      STA   MS_Z_00A5_ARGEXP + 1
                      DEY
                      LDA   (MS_Z_005E_INDEX),Y
                      STA   MS_Z_00A5_ARGEXP                     ; Exponent
                      LDA   MS_Z_009D_FAC                     ; Set status bits on fac exponent
                      RTS
                                                       ; --------------------------------
                                                       ; Add exponents of arg and fac
                                                       ; (Called by fmult and fdiv)

                                                       ; Also check for overflow, and set result sign
                                                       ; --------------------------------
AS_ADD_EXPONENTS:
                      LDA   MS_Z_00A5_ARGEXP
                                                       ; --------------------------------
AS_ADD_EXPONENTS_1:
                      BEQ   AS_ZERO                    ; If arg=0, result is zero
                      CLC
                      ADC   MS_Z_009D_FAC
                      BCC   AS_L_ADD_EXPONENTS_1_1     ; In range
                      BMI   AS_JOV                     ; Overflow
                      CLC
                      .byte $2C                        ; Trick to skip
AS_L_ADD_EXPONENTS_1_1: BPL   AS_ZERO                    ; Overflow
                      ADC   #$80                       ; Re-bias
                      STA   MS_Z_009D_FAC                     ; Result
                      BNE   AS_L_ADD_EXPONENTS_1_2
                      JMP   AS_STA_IN_FAC_SIGN         ; Result is zero
                                                       ; <<< Crazy to jump way back there! >>>
                                                       ; <<< Same identical code is below! >>>
                                                       ; <<< Instead of bne l_add_exponents_1_2, jmp sta.in.fac.sign   >>>
                                                       ; <<< Only needed beq l_add_exponents_1_3            >>>
AS_L_ADD_EXPONENTS_1_2: LDA   MS_Z_00AB_ARISGN                  ; Set sign of result
AS_L_ADD_EXPONENTS_1_3: STA   MS_Z_00A2_FACSGN
                      RTS
                                                       ; --------------------------------
                                                       ; If (fac) is positive, give "overflow" error
                                                       ; If (fac) is negative, set fac=0, pop one return, and rts
                                                       ; Called from "exp" function
                                                       ; --------------------------------
AS_OUTOFRNG:
                      LDA   MS_Z_00A2_FACSGN
                      EOR   #$FF
                      BMI   AS_JOV                     ; Error if positive #
                                                       ; --------------------------------
                                                       ; Pop return address and set fac=0
                                                       ; --------------------------------
AS_ZERO:              PLA
                      PLA
                      JMP   AS_ZERO_FAC
                                                       ; --------------------------------
AS_JOV:               JMP   AS_OVERFLOW
                                                       ; --------------------------------
                                                       ; Multiply fac by 10
                                                       ; --------------------------------
AS_MUL10:             JSR   AS_COPY_FAC_TO_ARG_ROUNDED
                      TAX                              ; Text fac exponent
                      BEQ   AS_L_MUL10_1               ; Finished if fac=0
                      CLC
                      ADC   #2                         ; Add 2 to exponent gives (fac)*4
                      BCS   AS_JOV                     ; Overflow
                      LDX   #0
                      STX   MS_Z_00AB_ARISGN
                      JSR   AS_FADD_2                  ; Makes (fac)*5
                      INC   MS_Z_009D_FAC                     ; *2, Makes (fac)*10
                      BEQ   AS_JOV                     ; Overflow
AS_L_MUL10_1:         RTS
                                                       ; --------------------------------

AS_CON_TEN:           .byte $84, $20, $00, $00, $00
                                                       ; --------------------------------
                                                       ; Divide fac by 10
                                                       ; --------------------------------
AS_DIV10:             JSR   AS_COPY_FAC_TO_ARG_ROUNDED
                      LDA   #<AS_CON_TEN               ; Set up to put
                      LDY   #>AS_CON_TEN               ; 10 In fac
                      LDX   #0
                                                       ; --------------------------------
                                                       ; Fac = arg / (y,a)
                                                       ; --------------------------------
AS_DIV:               STX   MS_Z_00AB_ARISGN
                      JSR   AS_LOAD_FAC_FROM_YA
                      JMP   MS_FDIVT                   ; Divide arg by fac
                                                       ; --------------------------------
                                                       ; Fac = (y,a) / fac
                                                       ; --------------------------------
AS_FDIV:              JSR   AS_LOAD_ARG_FROM_YA
                                                       ; --------------------------------
                                                       ; Fac = arg / fac
                                                       ; --------------------------------
MS_FDIVT:             BEQ   AS_L_FDIVT_8               ; Fac = 0, divide by zero error
                      JSR   AS_ROUND_FAC
                      LDA   #0                         ; Negate fac exponent, so
                      SEC                              ; Add.exponents forms difference
                      SBC   MS_Z_009D_FAC
                      STA   MS_Z_009D_FAC
                      JSR   AS_ADD_EXPONENTS
                      INC   MS_Z_009D_FAC
                      BEQ   AS_JOV                     ; Overflow
                      LDX   #$FC                       ; Index for result
                      LDA   #1                         ; Sentinel
AS_L_FDIVT_1:         LDY   MS_Z_00A5_ARGEXP + 1                 ; See if fac can be subtracted
                      CPY   MS_Z_009D_FAC + 1
                      BNE   AS_L_FDIVT_2
                      LDY   MS_Z_00A5_ARGEXP + 2
                      CPY   MS_Z_009D_FAC + 2
                      BNE   AS_L_FDIVT_2
                      LDY   MS_Z_00A5_ARGEXP + 3
                      CPY   MS_Z_009D_FAC + 3
                      BNE   AS_L_FDIVT_2
                      LDY   MS_Z_00A5_ARGEXP + 4
                      CPY   MS_Z_009D_FAC + 4
AS_L_FDIVT_2:         PHP                              ; Save the answer, and also roll the
                      ROL                              ; Bit into the quotient, sentinel out
                      BCC   AS_L_FDIVT_3               ; No sentinel, still not 8 trips
                      INX                              ; 8 Trips, store byte of quotient
                      STA   AS_RESULT + 3,X
                      BEQ   AS_L_FDIVT_6               ; 32-Bits completed
                      BPL   AS_L_FDIVT_7               ; Final exit when x=1
                      LDA   #1                         ; Re-start sentinel
AS_L_FDIVT_3:         PLP                              ; Get answer, can fac be subtracted?
                      BCS   AS_L_FDIVT_5               ; Yes, do it
AS_L_FDIVT_4:         ASL   MS_Z_00A5_ARGEXP + 4                 ; No, shift arg left
                      ROL   MS_Z_00A5_ARGEXP + 3
                      ROL   MS_Z_00A5_ARGEXP + 2
                      ROL   MS_Z_00A5_ARGEXP + 1
                      BCS   AS_L_FDIVT_2               ; Another trip
                      BMI   AS_L_FDIVT_1               ; Have to compare first
                      BPL   AS_L_FDIVT_2               ; ...Always
AS_L_FDIVT_5:         TAY                              ; Save quotient/sentinel byte
                      LDA   MS_Z_00A5_ARGEXP + 4                 ; Subtract fac from arg once
                      SBC   MS_Z_009D_FAC + 4
                      STA   MS_Z_00A5_ARGEXP + 4
                      LDA   MS_Z_00A5_ARGEXP + 3
                      SBC   MS_Z_009D_FAC + 3
                      STA   MS_Z_00A5_ARGEXP + 3
                      LDA   MS_Z_00A5_ARGEXP + 2
                      SBC   MS_Z_009D_FAC + 2
                      STA   MS_Z_00A5_ARGEXP + 2
                      LDA   MS_Z_00A5_ARGEXP + 1
                      SBC   MS_Z_009D_FAC + 1
                      STA   MS_Z_00A5_ARGEXP + 1
                      TYA                              ; Restore quotient/sentinel byte
                      JMP   AS_L_FDIVT_4               ; Go to shift arg and continue
                                                       ; --------------------------------
AS_L_FDIVT_6:         LDA   #$40                       ; Do a few extension bits
                      BNE   AS_L_FDIVT_3               ; ...Always
                                                       ; --------------------------------
AS_L_FDIVT_7:         ASL                              ; Left justify the extension bits we did
                      ASL
                      ASL
                      ASL
                      ASL
                      ASL
                      STA   MS_Z_00AC_FACOV
                      PLP
                      JMP   AS_COPY_RESULT_INTO_FAC
                                                       ; --------------------------------
AS_L_FDIVT_8:         LDX   #MS_E_ERRDV0
                      JMP   MS_ERROR
                                                       ; --------------------------------
                                                       ; Copy result into fac mantissa, and normalize
                                                       ; --------------------------------
AS_COPY_RESULT_INTO_FAC:
                      LDA   AS_RESULT
                      STA   MS_Z_009D_FAC + 1
                      LDA   AS_RESULT + 1
                      STA   MS_Z_009D_FAC + 2
                      LDA   AS_RESULT + 2
                      STA   MS_Z_009D_FAC + 3
                      LDA   AS_RESULT + 3
                      STA   MS_Z_009D_FAC + 4
                      JMP   AS_NORMALIZE_FAC_2
                                                       ; --------------------------------
                                                       ; Unpack (y,a) into fac
                                                       ; --------------------------------
AS_LOAD_FAC_FROM_YA:
                      STA   MS_Z_005E_INDEX                   ; Use index for pntr
                      STY   MS_Z_005E_INDEX + 1
                      LDY   #4                         ; Pick up 5 bytes
                      LDA   (MS_Z_005E_INDEX),Y
                      STA   MS_Z_009D_FAC + 4
                      DEY
                      LDA   (MS_Z_005E_INDEX),Y
                      STA   MS_Z_009D_FAC + 3
                      DEY
                      LDA   (MS_Z_005E_INDEX),Y
                      STA   MS_Z_009D_FAC + 2
                      DEY
                      LDA   (MS_Z_005E_INDEX),Y
                      STA   MS_Z_00A2_FACSGN                ; First bit is sign
                      ORA   #$80                       ; Set normalized invisible bit
                      STA   MS_Z_009D_FAC + 1
                      DEY
                      LDA   (MS_Z_005E_INDEX),Y
                      STA   MS_Z_009D_FAC                     ; Exponent
                      STY   MS_Z_00AC_FACOV           ; y=0
                      RTS
                                                       ; --------------------------------
                                                       ; Round fac, store in temp2
                                                       ; --------------------------------
AS_STORE_FAC_IN_TEMP2_ROUNDED:
                      LDX   #MS_Z_0098_TEMPF2                  ; Pack fac into temp2
                      .byte $2C                        ; Trick to branch
                                                       ; --------------------------------
                                                       ; Round fac, store in temp1
                                                       ; --------------------------------
AS_STORE_FAC_IN_TEMP1_ROUNDED:
                      LDX   #<MS_Z_0093_TEMPF1                 ; Pack fac into temp1
                      LDY   #>MS_Z_0093_TEMPF1                 ; Hi-byte of temp1 same as temp2
                      BEQ   AS_STORE_FACDB_YX_ROUNDED  ; ...Always
                                                       ; --------------------------------
                                                       ; Round fac, and store where forpnt points
                                                       ; --------------------------------
AS_SETFOR:            LDX   MS_Z_0085_FORPNT
                      LDY   MS_Z_0085_FORPNT + 1
                                                       ; --------------------------------
                                                       ; Round fac, and store at (y,x)
                                                       ; --------------------------------
AS_STORE_FACDB_YX_ROUNDED:
                      JSR   AS_ROUND_FAC               ; Round value in fac using extension
                      STX   MS_Z_005E_INDEX                   ; Use index for pntr
                      STY   MS_Z_005E_INDEX + 1
                      LDY   #4                         ; Storing 5 packed bytes
                      LDA   MS_Z_009D_FAC + 4
                      STA   (MS_Z_005E_INDEX),Y
                      DEY
                      LDA   MS_Z_009D_FAC + 3
                      STA   (MS_Z_005E_INDEX),Y
                      DEY
                      LDA   MS_Z_009D_FAC + 2
                      STA   (MS_Z_005E_INDEX),Y
                      DEY
                      LDA   MS_Z_00A2_FACSGN                ; Pack sign in top bit of mantissa
                      ORA   #$7F
                      AND   MS_Z_009D_FAC + 1
                      STA   (MS_Z_005E_INDEX),Y
                      DEY
                      LDA   MS_Z_009D_FAC                     ; Exponent
                      STA   (MS_Z_005E_INDEX),Y
                      STY   MS_Z_00AC_FACOV           ; Zero the extension
                      RTS
                                                       ; --------------------------------
                                                       ; Copy arg into fac
                                                       ; --------------------------------
AS_COPY_ARG_TO_FAC:
                      LDA   MS_Z_00AA_ARGSGN                ; Copy sign
AS_MFA:               STA   MS_Z_00A2_FACSGN
                      LDX   #5                         ; Move 5 bytes
AS_L_MFA_1:           LDA   MS_Z_00A5_ARGEXP - 1,X
                      STA   MS_Z_009D_FAC - 1,X
                      DEX
                      BNE   AS_L_MFA_1
                      STX   MS_Z_00AC_FACOV           ; Zero extension
                      RTS
                                                       ; --------------------------------
                                                       ; Round fac and copy to arg
                                                       ; --------------------------------
AS_COPY_FAC_TO_ARG_ROUNDED:
                      JSR   AS_ROUND_FAC               ; Round fac using extension
AS_MAF:               LDX   #6                         ; Copy 6 bytes, includes sign
AS_L_MAF_1:           LDA   MS_Z_009D_FAC - 1,X
                      STA   MS_Z_00A5_ARGEXP - 1,X
                      DEX
                      BNE   AS_L_MAF_1
                      STX   MS_Z_00AC_FACOV           ; Zero fac extension
AS_RTS_14:            RTS
                                                       ; --------------------------------
                                                       ; Round fac using extension byte
                                                       ; --------------------------------
AS_ROUND_FAC:
                      LDA   MS_Z_009D_FAC
                      BEQ   AS_RTS_14                  ; Fac = 0, return
                      ASL   MS_Z_00AC_FACOV           ; Is fac.extension >= 128?
                      BCC   AS_RTS_14                  ; No, finished
                                                       ; --------------------------------
                                                       ; Increment mantissa and re-normalize if carry
                                                       ; --------------------------------
AS_INCREMENT_MANTISSA:
                      JSR   AS_INCREMENT_FAC_MANTISSA  ; Yes, increment fac
                      BNE   AS_RTS_14                  ; High byte has bits, finished
                      JMP   AS_NORMALIZE_FAC_6         ; Hi-byte=0, so shift left
                                                       ; --------------------------------
                                                       ; Test fac for zero and sign

                                                       ; Fac > 0, return +1
                                                       ; Fac = 0, return  0
                                                       ; Fac < 0, return -1
                                                       ; --------------------------------
AS_SIGN:              LDA   MS_Z_009D_FAC                     ; Check sign of fac and
                      BEQ   AS_RTS_15                  ; Return -1,0,1 in a-reg
                                                       ; --------------------------------
AS_SIGN1:             LDA   MS_Z_00A2_FACSGN
                                                       ; --------------------------------
AS_SIGN2:             ROL                              ; Msbit to carry
                      LDA   #$FF                       ; -1
                      BCS   AS_RTS_15                  ; Msbit = 1
                      LDA   #1                         ; +1
AS_RTS_15:            RTS
                                                       ; --------------------------------
                                                       ; "Sgn" function
                                                       ; --------------------------------
MS_SGN:               JSR   AS_SIGN                    ; Convert fac to -1,0,1
                                                       ; --------------------------------
                                                       ; Convert (a) into fac, as signed value -128 to +127
                                                       ; --------------------------------
AS_FLOAT:             STA   MS_Z_009D_FAC + 1                 ; Put in high byte of mantissa
                      LDA   #0                         ; Clear 2nd byte of mantissa
                      STA   MS_Z_009D_FAC + 2
                      LDX   #$88                       ; Use exponent 2^9
                                                       ; --------------------------------
                                                       ; Float unsigned value in fac+1,2
                                                       ; (X) = exponent
                                                       ; --------------------------------
AS_FLOAT_1:
                      LDA   MS_Z_009D_FAC + 1                 ; Msbit=0, set carry; =1, clear carry
                      EOR   #$FF
                      ROL
                                                       ; --------------------------------
                                                       ; Float unsigned value in fac+1,2
                                                       ; (X) = exponent
                                                       ; C=0 to make value negative
                                                       ; C=1 to make value positive
                                                       ; --------------------------------
AS_FLOAT_2:
                      LDA   #0                         ; Clear lower 16-bits of mantissa
                      STA   MS_Z_009D_FAC + 4
                      STA   MS_Z_009D_FAC + 3
                      STX   MS_Z_009D_FAC                     ; Store exponent
                      STA   MS_Z_00AC_FACOV           ; Clear extension
                      STA   MS_Z_00A2_FACSGN                ; Make sign positive
                      JMP   AS_NORMALIZE_FAC_1         ; If c=0, will negate fac
                                                       ; --------------------------------
                                                       ; "Abs" function
                                                       ; --------------------------------
MS_ABS:               LSR   MS_Z_00A2_FACSGN                ; Change sign to +
                      RTS
                                                       ; --------------------------------
                                                       ; Compare fac with packed # at (y,a)
                                                       ; Return a=1,0,-1 as (y,a) is <,=,> fac
                                                       ; --------------------------------
AS_FCOMP:             STA   AS_DEST                    ; Use dest for pntr
                                                       ; --------------------------------
                                                       ; Special entry from "next" processor
                                                       ; "Dest" already set up
                                                       ; --------------------------------
AS_FCOMP2:            STY   AS_DEST + 1
                      LDY   #0                         ; Get exponent of comparand
                      LDA   (AS_DEST),Y
                      INY                              ; Point at next byte
                      TAX                              ; Exponent to x-reg
                      BEQ   AS_SIGN                    ; If comparand=0, "sign" compares fac
                      LDA   (AS_DEST),Y                ; Get hi-byte of mantissa
                      EOR   MS_Z_00A2_FACSGN                ; Compare with fac sign
                      BMI   AS_SIGN1                   ; Different signs, "sign" gives answer
                      CPX   MS_Z_009D_FAC                     ; Same sign, so compare exponents
                      BNE   AS_L_FCOMP2_1              ; Different, so sufficient test
                      LDA   (AS_DEST),Y                ; Same exponent, compare mantissa
                      ORA   #$80                       ; Set invisible normalized bit
                      CMP   MS_Z_009D_FAC + 1
                      BNE   AS_L_FCOMP2_1              ; Not same, so sufficient
                      INY                              ; Same, compare more mantissa
                      LDA   (AS_DEST),Y
                      CMP   MS_Z_009D_FAC + 2
                      BNE   AS_L_FCOMP2_1              ; Not same, so sufficient
                      INY                              ; Same, compare more mantissa
                      LDA   (AS_DEST),Y
                      CMP   MS_Z_009D_FAC + 3
                      BNE   AS_L_FCOMP2_1              ; Not same, so sufficient
                      INY                              ; Same, compare rest of mantissa
                      LDA   #$7F                       ; Artificial extension byte for comparand
                      CMP   MS_Z_00AC_FACOV
                      LDA   (AS_DEST),Y
                      SBC   MS_Z_009D_FAC + 4
                      BEQ   AS_RTS_16                  ; Numbers are equal, return (a)=0
AS_L_FCOMP2_1:        LDA   MS_Z_00A2_FACSGN                ; Numbers are different
                      BCC   AS_L_FCOMP2_2              ; Fac is larger magnitude
                      EOR   #$FF                       ; Fac is smaller magnitude
                                                       ; <<<  Note that above three lines can be shortened: >>>
                                                       ; <<<  L_fcomp2_1  ror              put carry into sign bit  >>>
                                                       ; <<<      Eor fac.sign     toggle with sign of fac  >>>
AS_L_FCOMP2_2:        JMP   AS_SIGN2                   ; Convert +1 or -1
                                                       ; --------------------------------
                                                       ; Quick integer function

                                                       ; Converts fp value in fac to integer value
                                                       ; In fac+1...fac+4, by shifting right with sign
                                                       ; Extension until fractional bits are out.

                                                       ; This subroutine assumes the exponent < 32.
                                                       ; --------------------------------
AS_QINT:              LDA   MS_Z_009D_FAC                     ; Look at fac exponent
                      BEQ   AS_QINT_3                  ; Fac=0, so finished
                      SEC                              ; Get -(number of fractional bits)
                      SBC   #$A0                       ; In a-reg for shift count
                      BIT   MS_Z_00A2_FACSGN                ; Check sign of fac
                      BPL   AS_L_QINT_1                ; Positive, continue
                      TAX                              ; Negative, so complement mantissa
                      LDA   #$FF                       ; And set sign extension for shift
                      STA   AS_SHIFT_SIGN_EXT
                      JSR   AS_COMPLEMENT_FAC_MANTISSA
                      TXA                              ; Restore bit count to a-reg
AS_L_QINT_1:          LDX   #MS_Z_009D_FAC                    ; Point shift subroutine at fac
                      CMP   #$F9                       ; More than 7 bits to shift?
                      BPL   AS_QINT_2                  ; No, short shift
                      JSR   AS_SHIFT_RIGHT             ; Yes, use general routine
                      STY   AS_SHIFT_SIGN_EXT          ; Y=0, clear sign extension
AS_RTS_16:            RTS
                                                       ; --------------------------------
AS_QINT_2:            TAY                              ; Save shift count
                      LDA   MS_Z_00A2_FACSGN                ; Get sign bit
                      AND   #$80
                      LSR   MS_Z_009D_FAC + 1                 ; Start right shift
                      ORA   MS_Z_009D_FAC + 1                 ; And merge with sign
                      STA   MS_Z_009D_FAC + 1
                      JSR   AS_SHIFT_RIGHT_4           ; Jump into middle of shifter
                      STY   AS_SHIFT_SIGN_EXT          ; Y=0, clear sign extension
                      RTS
                                                       ; --------------------------------
                                                       ; "Int" function

                                                       ; Uses qint to convert (fac) to integer form,
                                                       ; And then refloats the integer.
                                                       ; <<< A faster approach would simply clear >>>
                                                       ; <<< The fractional bits by zeroing them  >>>
                                                       ; --------------------------------
MS_INT:               LDA   MS_Z_009D_FAC                     ; Check if exponent < 32
                      CMP   #$A0                       ; Because if > 31 there is no fraction
                      BCS   AS_RTS_17                  ; No fraction, we are finished
                      JSR   AS_QINT                    ; Use general integer conversion
                      STY   MS_Z_00AC_FACOV           ; Y=0, clear extension
                      LDA   MS_Z_00A2_FACSGN                ; Get sign of value
                      STY   MS_Z_00A2_FACSGN                ; Y=0, clear sign
                      EOR   #$80                       ; Toggle actual sign
                      ROL                              ; And save in carry
                      LDA   #$A0                       ; Set exponent to 32
                      STA   MS_Z_009D_FAC                     ; Because 4-byte integer now
                      LDA   MS_Z_009D_FAC + 4                 ; Save low 8-bits of integer form
                      STA   MS_Z_000D_CHARAC                  ; For exp and power
                      JMP   AS_NORMALIZE_FAC_1         ; Normalize to finish conversion
                                                       ; --------------------------------
AS_QINT_3:            STA   MS_Z_009D_FAC + 1                 ; Fac=0, so clear all 4 bytes for
                      STA   MS_Z_009D_FAC + 2                 ; Integer version
                      STA   MS_Z_009D_FAC + 3
                      STA   MS_Z_009D_FAC + 4
                      TAY                              ; Y=0 too
AS_RTS_17:            RTS
                                                       ; --------------------------------
                                                       ; Convert string to fp value in fac

                                                       ; String pointed to by txtptr
                                                       ; First char already scanned by chrget
                                                       ; (A) = first char, c=0 if digit.
                                                       ; --------------------------------
AS_FIN:               LDY   #0                         ; Clear working area ($99...$A3)
                      LDX   #10                        ; Tmpexp, expon, dpflg, expsgn, fac, serlen
AS_L_FIN_1:           STY   AS_TMPEXP,X
                      DEX
                      BPL   AS_L_FIN_1
                                                       ; --------------------------------
                      BCC   AS_FIN_2                   ; First char is a digit
                      CMP   #"-" & %01111111           ; Check for leading sign
                      BNE   AS_L_FIN_2                 ; Not minus
                      STX   AS_SERLEN                  ; Minus, set serlen = $FF for flag
                      BEQ   AS_FIN_1                   ; ...Always
AS_L_FIN_2:           CMP   #"+" & %01111111           ; Might be plus
                      BNE   AS_FIN_3                   ; Not plus either, check decimal point
                                                       ; --------------------------------
AS_FIN_1:             JSR   MS_Z_00B1_CHRGET                  ; Get next char of string
                                                       ; --------------------------------
AS_FIN_2:             BCC   AS_FIN_9                   ; Insert this digit
                                                       ; --------------------------------
AS_FIN_3:             CMP   #"." & %01111111           ; Check for decimal point
                      BEQ   AS_FIN_10                  ; Yes
                      CMP   #"E" & %01111111           ; Check for exponent part
                      BNE   AS_FIN_7                   ; No, end of number
                      JSR   MS_Z_00B1_CHRGET                  ; Yes, start converting exponent
                      BCC   AS_FIN_5                   ; Exponent digit
                      CMP   #MS_T_MINUTK            ; Negative exponent?
                      BEQ   AS_L_FIN_3_1               ; Yes
                      CMP   #"-" & %01111111           ; Might not be tokenized yet
                      BEQ   AS_L_FIN_3_1               ; Yes, it is negative
                      CMP   #MS_T_PLUSTK             ; Optional "+"
                      BEQ   AS_FIN_4                   ; Yes
                      CMP   #"+" & %01111111           ; Might not be tokenized yet
                      BEQ   AS_FIN_4                   ; Yes, found "+"
                      BNE   AS_FIN_6                   ; ...Always, number completed
AS_L_FIN_3_1:         ROR   MS_Z_009C_EXPSGN                  ; C=1, set flag negative
                                                       ; --------------------------------
AS_FIN_4:             JSR   MS_Z_00B1_CHRGET                  ; Get next digit of exponent
                                                       ; --------------------------------
AS_FIN_5:             BCC   AS_GETEXP                  ; Char is a digit of exponent
                                                       ; --------------------------------
AS_FIN_6:             BIT   MS_Z_009C_EXPSGN                  ; End of number, check exp sign
                      BPL   AS_FIN_7                   ; Positive exponent
                      LDA   #0                         ; Negative exponent
                      SEC                              ; Make 2's complement of exponent
                      SBC   MS_Z_009A_TENEXP
                      JMP   AS_FIN_8
                                                       ; --------------------------------
                                                       ; Found a decimal point
                                                       ; --------------------------------
AS_FIN_10:            ROR   MS_Z_009B_DPTFLG                   ; C=1, set dpflg for decimal point
                      BIT   MS_Z_009B_DPTFLG                   ; Check if previous dec. pt.
                      BVC   AS_FIN_1                   ; No previous decimal point
                                                       ; A second decimal point is taken as a terminator
                                                       ; To the numeric string.
                                                       ; "A=11..22" will give a syntax error, because
                                                       ; It is two numbers with no operator between.
                                                       ; "Print 11..22" gives no error, because it is
                                                       ; Just the concatenation of two numbers.
                                                       ; --------------------------------
                                                       ; Number terminated, adjust exponent now
                                                       ; --------------------------------
AS_FIN_7:             LDA   MS_Z_009A_TENEXP                   ; E-value
AS_FIN_8:             SEC                              ; Modify with count of digits
                      SBC   AS_TMPEXP                  ; After the decimal point
                      STA   MS_Z_009A_TENEXP                   ; Complete current exponent
                      BEQ   AS_L_FIN_8_15              ; No adjust needed if exp=0
                      BPL   AS_L_FIN_8_14              ; Exp>0, multiply by ten
AS_L_FIN_8_13:        JSR   AS_DIV10                   ; Exp<0, divide by ten
                      INC   MS_Z_009A_TENEXP                   ; Until exp=0
                      BNE   AS_L_FIN_8_13
                      BEQ   AS_L_FIN_8_15              ; ...Always, we are finished
AS_L_FIN_8_14:        JSR   AS_MUL10                   ; Exp>0, multiply bky ten
                      DEC   MS_Z_009A_TENEXP                   ; Until exp=0
                      BNE   AS_L_FIN_8_14
AS_L_FIN_8_15:        LDA   AS_SERLEN                  ; Is whole number negative?
                      BMI   AS_L_FIN_8_16              ; Yes
                      RTS                              ; No, return, whole job done!
AS_L_FIN_8_16:        JMP   MS_NEGOP                   ; Negative number, so negate fac
                                                       ; --------------------------------
                                                       ; Accumulate a digit into fac
                                                       ; --------------------------------
AS_FIN_9:             PHA                              ; Save digit
                      BIT   MS_Z_009B_DPTFLG                   ; Seen a decimal point yet?
                      BPL   AS_L_FIN_9_1               ; No, still in integer part
                      INC   AS_TMPEXP                  ; Yes, count the fractional digit
AS_L_FIN_9_1:         JSR   AS_MUL10                   ; Fac = fac * 10
                      PLA                              ; Current digit
                      SEC                              ; <<<Shorter here to just "and #$0F">>>
                      SBC   #"0" & %01111111           ; <<<To convert ascii to binary form>>>
                      JSR   AS_ADDACC                  ; Add the digit
                      JMP   AS_FIN_1                   ; Go back for more
                                                       ; --------------------------------
                                                       ; Add (a) to fac
                                                       ; --------------------------------
AS_ADDACC:            PHA                              ; Save addend
                      JSR   AS_COPY_FAC_TO_ARG_ROUNDED
                      PLA                              ; Get addend again
                      JSR   AS_FLOAT                   ; Convert to fp value in fac
                      LDA   MS_Z_00AA_ARGSGN
                      EOR   MS_Z_00A2_FACSGN
                      STA   MS_Z_00AB_ARISGN
                      LDX   MS_Z_009D_FAC                     ; To signal if fac=0
                      JMP   MS_FADDT                   ; Perform the addition
                                                       ; --------------------------------
                                                       ; Accumulate digit of exponent
                                                       ; --------------------------------
AS_GETEXP:            LDA   MS_Z_009A_TENEXP                   ; Check current value
                      CMP   #10                        ; For more than 2 digits
                      BCC   AS_L_GETEXP_1              ; No, this is 1st or 2nd digit
                      LDA   #100                       ; Exponent too big
                      BIT   MS_Z_009C_EXPSGN                  ; Unless it is negative
                      BMI   AS_L_GETEXP_2              ; Large negative exponent makes fac=0
                      JMP   AS_OVERFLOW                ; Large positive exponent is error
AS_L_GETEXP_1:        ASL                              ; Exponent times 10
                      ASL
                      CLC
                      ADC   MS_Z_009A_TENEXP
                      ASL
                      CLC                              ; <<< Asl already did this! >>>
                      LDY   #0                         ; Add the new digit
                      ADC   (MS_Z_00B8_TXTPTR),Y              ; But this is in ascii,
                      SEC                              ; So adjust back to binary
                      SBC   #"0" & %01111111
AS_L_GETEXP_2:        STA   MS_Z_009A_TENEXP                   ; New value
                      JMP   AS_FIN_4                   ; Back for more
                                                       ; --------------------------------
                                                       ; --------------------------------

AS_CON_99999999P9:    .byte $9B, $3E, $BC, $1F, $FD    ; 99,999,999.9
AS_CON_999999999:     .byte $9E, $6E, $6B, $27, $FD    ; 999,999,999
AS_CON_BILLION:       .byte $9E, $6E, $6B, $28, $00    ; 1,000,000,000
                                                       ; --------------------------------
                                                       ; Print "in <line #>"
                                                       ; --------------------------------
AS_INPRT:             LDA   #<MS_INTXT                 ; Print " in "
                      LDY   #>MS_INTXT
                      JSR   AS_GO_STROUT
                      LDA   MS_Z_0075_CURLIN + 1
                      LDX   MS_Z_0075_CURLIN
                                                       ; --------------------------------
                                                       ; Print a,x as decimal integer
                                                       ; --------------------------------
AS_LINPRT:            STA   MS_Z_009D_FAC + 1                 ; Print a,x in decimal
                      STX   MS_Z_009D_FAC + 2
                      LDX   #$90                       ; Exponent = 2^16
                      SEC                              ; Convert unsigned
                      JSR   AS_FLOAT_2                 ; Convert line # to fp
                                                       ; --------------------------------
                                                       ; Convert (fac) to string, and print it
                                                       ; --------------------------------
AS_PRINT_FAC:
                      JSR   AS_FOUT                    ; Convert (fac) to string at stack
                                                       ; --------------------------------
                                                       ; Print string starting at y,a
                                                       ; --------------------------------
AS_GO_STROUT:
                      JMP   AS_STROUT                  ; Print string at a,y
                                                       ; --------------------------------
                                                       ; Convert (fac) to string starting at stack
                                                       ; Return with (y,a) pointing at string
                                                       ; --------------------------------
AS_FOUT:              LDY   #1                         ; Normal entry puts string at stack...
                                                       ; --------------------------------
                                                       ; "Str$" function enters here, with (y)=0
                                                       ; So that result string starts at stack-1
                                                       ; (This is used as a flag)
                                                       ; --------------------------------
AS_FOUT_1:            LDA   #"-" & %01111111           ; In case value negative
                      DEY                              ; Back up pntr
                      BIT   MS_Z_00A2_FACSGN
                      BPL   AS_L_FOUT_1_1              ; Value is +
                      INY                              ; Value is -
                      STA   AS_STACK - 1,Y             ; Emit "-"
AS_L_FOUT_1_1:        STA   MS_Z_00A2_FACSGN                ; Make fac.sign positive ($2D)
                      STY   MS_Z_00AD_STRNG2                  ; Save string pntr
                      INY
                      LDA   #"0" & %01111111           ; In case (fac)=0
                      LDX   MS_Z_009D_FAC                     ; Number=0?
                      BNE   AS_L_FOUT_1_2              ; No, (fac) not zero
                      JMP   AS_FOUT_4                  ; Yes, finished
                                                       ; --------------------------------
AS_L_FOUT_1_2:        LDA   #0                         ; Starting value for tmpexp
                      CPX   #$80                       ; Any integer part?
                      BEQ   AS_L_FOUT_1_3              ; No, btwn l_fout_1_5 and l_fout_1_999999999
                      BCS   AS_L_FOUT_1_4              ; Yes
                                                       ; --------------------------------
AS_L_FOUT_1_3:        LDA   #<AS_CON_BILLION           ; Multiply by 1e9
                      LDY   #>AS_CON_BILLION           ; To give adjustment a head start
                      JSR   AS_FMULT
                      LDA   #$100 - 9                  ; Exponent adjustment
AS_L_FOUT_1_4:        STA   AS_TMPEXP                  ; 0 Or -9
                                                       ; --------------------------------
                                                       ; Adjust until 1e8 <= (fac) <1e9
                                                       ; --------------------------------
AS_L_FOUT_1_5:        LDA   #<AS_CON_999999999
                      LDY   #>AS_CON_999999999
                      JSR   AS_FCOMP                   ; Compare to 1e9-1
                      BEQ   AS_L_FOUT_1_10             ; (Fac) = 1e9-1
                      BPL   AS_L_FOUT_1_8              ; Too large, divide by ten
AS_L_FOUT_1_6:        LDA   #<AS_CON_99999999P9        ; Compare to 1e8-l_fout_1_1
                      LDY   #>AS_CON_99999999P9
                      JSR   AS_FCOMP                   ; Compare to 1e8-l_fout_1_1
                      BEQ   AS_L_FOUT_1_7              ; (Fac) = 1e8-l_fout_1_1
                      BPL   AS_L_FOUT_1_9              ; In range, adjustment finished
AS_L_FOUT_1_7:        JSR   AS_MUL10                   ; Too small, multiply by ten
                      DEC   AS_TMPEXP                  ; Keep track of multiplies
                      BNE   AS_L_FOUT_1_6              ; ...Always
AS_L_FOUT_1_8:        JSR   AS_DIV10                   ; Too large, divide by ten
                      INC   AS_TMPEXP                  ; Keep track of divisions
                      BNE   AS_L_FOUT_1_5              ; ...Always
                                                       ; --------------------------------
AS_L_FOUT_1_9:        JSR   AS_FADDH                   ; Round adjusted result
AS_L_FOUT_1_10:       JSR   AS_QINT                    ; Convert adjusted value to 32-bit integer
                                                       ; --------------------------------
                                                       ; Fac+1...fac+4 is now in integer form
                                                       ; With power of ten adjustment in tmpexp

                                                       ; If -10 < tmpexp > 1, print in decimal form
                                                       ; Otherwise, print in exponential form
                                                       ; --------------------------------
AS_FOUT_2:            LDX   #1                         ; Assume 1 digit before "."
                      LDA   AS_TMPEXP                  ; Check range
                      CLC
                      ADC   #10
                      BMI   AS_L_FOUT_2_1              ; < .01, Use exponential form
                      CMP   #11
                      BCS   AS_L_FOUT_2_2              ; >= 1E10, use exponential form
                      ADC   #$FF                       ; Less 1 gives index for "."
                      TAX
                      LDA   #2                         ; Set remaining exponent = 0
AS_L_FOUT_2_1:        SEC                              ; Compute remaining exponent
AS_L_FOUT_2_2:        SBC   #2
                      STA   MS_Z_009A_TENEXP                   ; Value for "e+xx" or "e-xx"
                      STX   AS_TMPEXP                  ; Index for decimal point
                      TXA                              ; See if "." comes first
                      BEQ   AS_L_FOUT_2_3              ; Yes
                      BPL   AS_L_FOUT_2_5              ; No, later
AS_L_FOUT_2_3:        LDY   MS_Z_00AD_STRNG2                  ; Get index into string being built
                      LDA   #"." & %01111111           ; Store a decimal point
                      INY
                      STA   AS_STACK - 1,Y
                      TXA                              ; See if need ".0"
                      BEQ   AS_L_FOUT_2_4              ; No
                      LDA   #"0" & %01111111           ; Yes, store "0"
                      INY
                      STA   AS_STACK - 1,Y
AS_L_FOUT_2_4:        STY   MS_Z_00AD_STRNG2                  ; Save output index again
                                                       ; --------------------------------
                                                       ; Now divide by powers of ten to get successive digits
                                                       ; --------------------------------
AS_L_FOUT_2_5:        LDY   #0                         ; Index to table of powers of ten
                      LDX   #$80                       ; Starting value for digit with direction
AS_L_FOUT_2_6:        LDA   MS_Z_009D_FAC + 4                 ; Start by adding -100000000 until
                      CLC                              ; Overshoot.  then add +10000000,
                      ADC   AS_DECTBL + 3,Y            ; Then add -1000000, then add
                      STA   MS_Z_009D_FAC + 4                 ; +100000, And so on.
                      LDA   MS_Z_009D_FAC + 3                 ; The # of times each power is added
                      ADC   AS_DECTBL + 2,Y            ; Is 1 more than corresponding digit
                      STA   MS_Z_009D_FAC + 3
                      LDA   MS_Z_009D_FAC + 2
                      ADC   AS_DECTBL + 1,Y
                      STA   MS_Z_009D_FAC + 2
                      LDA   MS_Z_009D_FAC + 1
                      ADC   AS_DECTBL,Y
                      STA   MS_Z_009D_FAC + 1
                      INX                              ; Count the add
                      BCS   AS_L_FOUT_2_7              ; If c=1 and x negative, keep adding
                      BPL   AS_L_FOUT_2_6              ; If c=0 and x positive, keep adding
                      BMI   AS_L_FOUT_2_8              ; If c=0 and x negative, we overshot
AS_L_FOUT_2_7:        BMI   AS_L_FOUT_2_6              ; If c=1 and x positive, we overshot
AS_L_FOUT_2_8:        TXA                              ; Overshot, so make x into a digit
                      BCC   AS_L_FOUT_2_9              ; How depends on direction we were going
                      EOR   #$FF                       ; Digit = 9-x
                      ADC   #10
AS_L_FOUT_2_9:        ADC   #("0" & %01111111) - 1     ; Make digit into ascii
                      INY                              ; Advance to next smaller power of ten
                      INY
                      INY
                      INY
                      STY   MS_Z_0083_VARPNT                  ; Save pntr to powers
                      LDY   MS_Z_00AD_STRNG2                  ; Get output pntr
                      INY                              ; Store the digit
                      TAX                              ; Save digit, hi-bit is direction
                      AND   #$7F                       ; Make sure MON_COLOR...$39 for string
                      STA   AS_STACK - 1,Y
                      DEC   AS_TMPEXP                  ; Count the digit
                      BNE   AS_L_FOUT_2_10             ; Not time for "." yet
                      LDA   #"." & %01111111           ; Time, so store the decimal point
                      INY
                      STA   AS_STACK - 1,Y
AS_L_FOUT_2_10:       STY   MS_Z_00AD_STRNG2                  ; Save output pntr again
                      LDY   MS_Z_0083_VARPNT                  ; Get pntr to powers
                      TXA                              ; Get digit with hi-bit = direction
                      EOR   #$FF                       ; Change direction
                      AND   #$80                       ; $00 If adding, $80 if subtracting
                      TAX
                      CPY   #AS_DECTBL_END - AS_DECTBL
                      BNE   AS_L_FOUT_2_6              ; Not finished yet
                                                       ; --------------------------------
                                                       ; Nine digits have been stored in string.  now look
                                                       ; Back and lop off trailing zeroes and a trailing
                                                       ; Decimal point.
                                                       ; --------------------------------
AS_FOUT_3:            LDY   MS_Z_00AD_STRNG2                  ; Points at last stored char
AS_L_FOUT_3_1:        LDA   AS_STACK - 1,Y             ; See if loppable
                      DEY
                      CMP   #"0" & %01111111           ; Suppress trailing zeroes
                      BEQ   AS_L_FOUT_3_1              ; Yes, keep looping
                      CMP   #"." & %01111111           ; Suppress trailing decimal point
                      BEQ   AS_L_FOUT_3_2              ; ".", So write over it
                      INY                              ; Not ".", so include in string again
AS_L_FOUT_3_2:        LDA   #"+" & %01111111           ; Prepare for positive exponent "e+xx"
                      LDX   MS_Z_009A_TENEXP                   ; See if any e-value
                      BEQ   AS_FOUT_5                  ; No, just mark end of string
                      BPL   AS_L_FOUT_3_3              ; Yes, and it is positive
                      LDA   #0                         ; Yes, and it is negative
                      SEC                              ; Complement the value
                      SBC   MS_Z_009A_TENEXP
                      TAX                              ; Get magnitude in x
                      LDA   #"-" & %01111111           ; E sign
AS_L_FOUT_3_3:        STA   AS_STACK + 1,Y             ; Store sign in string
                      LDA   #"E" & %01111111           ; Store "e" in string before sign
                      STA   AS_STACK,Y
                      TXA                              ; Exponent magnitude in a-reg
                      LDX   #("0" & %01111111) - 1     ; Seed for exponent digit
                      SEC                              ; Convert to decimal
AS_L_FOUT_3_4:        INX                              ; Count the subtraction
                      SBC   #10                        ; Ten's digit
                      BCS   AS_L_FOUT_3_4              ; More tens to subtract
                      ADC   #("0" & %01111111) + 10    ; Convert remainder to one's digit
                      STA   AS_STACK + 3,Y             ; Store one's digit
                      TXA
                      STA   AS_STACK + 2,Y             ; Store ten's digit
                      LDA   #0                         ; Mark end of string with $00
                      STA   AS_STACK + 4,Y
                      BEQ   AS_FOUT_6                  ; ...Always
AS_FOUT_4:            STA   AS_STACK - 1,Y             ; Store "0" in ascii
AS_FOUT_5:            LDA   #0                         ; Store $00 on end of string
                      STA   AS_STACK,Y
AS_FOUT_6:            LDA   #<AS_STACK                 ; Point y,a at beginning of string
                      LDY   #>AS_STACK                 ; (Str$ started string at stack-1, but
                      RTS                              ; Str$ doesn't use y,a anyway.)
                                                       ; --------------------------------

AS_CON_HALF:          .byte $80, $00, $00, $00, $00    ; Fp constant 0l_con_half_5
                                                       ; --------------------------------
                                                       ; Powers of 10 from 1e8 down to 1,
                                                       ; As 32-bit integers, with alternating signs
                                                       ; --------------------------------

AS_DECTBL:            .byte $FA, $0A, $1F, $00         ; -100000000
                      .byte $00, $98, $96, $80         ; 10000000
                      .byte $FF, $F0, $BD, $C0         ; -1000000
                      .byte $00, $01, $86, $A0         ; 100000
                      .byte $FF, $FF, $D8, $F0         ; -10000
                      .byte $00, $00, $03, $E8         ; 1000
                      .byte $FF, $FF, $FF, $9C         ; -100
                      .byte $00, $00, $00, $0A         ; 10
                      .byte $FF, $FF, $FF, $FF         ; -1
AS_DECTBL_END:
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; "Sqr" function

                                                       ; <<< Unfortunately, rather than a newton-raphson >>>
                                                       ; <<< Iteration, applesoft uses exponentiation    >>>
                                                       ; <<< Sqr(x) = x^l_dectbl_end_5                               >>>
                                                       ; --------------------------------
MS_SQR:               JSR   AS_COPY_FAC_TO_ARG_ROUNDED
                      LDA   #<AS_CON_HALF              ; Set up power of 0l_sqr_5
                      LDY   #>AS_CON_HALF
                      JSR   AS_LOAD_FAC_FROM_YA
                                                       ; --------------------------------
                                                       ; Exponentiation operation

                                                       ; Arg ^ fac  =  exp( log(arg) * fac )
                                                       ; --------------------------------
MS_FPWRT:             BEQ   MS_EXP                     ; If fac=0, arg^fac=exp(0)
                      LDA   MS_Z_00A5_ARGEXP                     ; If arg=0, arg^fac=0
                      BNE   AS_L_FPWRT_1               ; Neither is zero
                      JMP   AS_STA_IN_FAC_SIGN_AND_EXP ; Set fac = 0
AS_L_FPWRT_1:         LDX   #MS_Z_008A_GRBPNT                  ; Save fac in temp3
                      LDY   #0
                      JSR   AS_STORE_FACDB_YX_ROUNDED
                      LDA   MS_Z_00AA_ARGSGN                ; Normally, arg must be positive
                      BPL   AS_L_FPWRT_2               ; It is positive, so all is well
                      JSR   MS_INT                     ; Negative, but ok if integral power
                      LDA   #MS_Z_008A_GRBPNT                  ; See if int(fac)=fac
                      LDY   #0
                      JSR   AS_FCOMP                   ; Is it an integer power?
                      BNE   AS_L_FPWRT_2               ; Not integral,  will cause error later
                      TYA                              ; Make arg sign + as it is moved to fac
                      LDY   MS_Z_000D_CHARAC                  ; Integral, so allow negative arg
AS_L_FPWRT_2:         JSR   AS_MFA                     ; Move argument to fac
                      TYA                              ; Save flag for negative arg (0=+)
                      PHA
                      JSR   MS_LOG                     ; Get log(arg)
                      LDA   #MS_Z_008A_GRBPNT                  ; Multiply by power
                      LDY   #0
                      JSR   AS_FMULT
                      JSR   MS_EXP                     ; E ^ log(fac)
                      PLA                              ; Get flag for negative arg
                      LSR                              ; <<<Lsr,bcc could be merely bpl>>>
                      BCC   AS_RTS_18                  ; Not negative, finished
                                                       ; Negative arg, so negate result
                                                       ; --------------------------------
                                                       ; Negate value in fac
                                                       ; --------------------------------
MS_NEGOP:             LDA   MS_Z_009D_FAC                     ; If fac=0, no need to complement
                      BEQ   AS_RTS_18                  ; Yes, fac=0
                      LDA   MS_Z_00A2_FACSGN                ; No, so toggle sign
                      EOR   #$FF
                      STA   MS_Z_00A2_FACSGN
AS_RTS_18:            RTS
                                                       ; --------------------------------

AS_CON_LOG_E:         .byte $81, $38, $AA, $3B, $29    ; Log(e) to base 2
                                                       ; --------------------------------
AS_POLY_EXP:          .byte 7                          ; ( # Of terms in polynomial) - 1
                      .byte $71, $34, $58, $3E, $56    ; (Log(2)^7)/8!
                      .byte $74, $16, $7E, $B3, $1B    ; (Log(2)^6)/7!
                      .byte $77, $2F, $EE, $E3, $85    ; (Log(2)^5)/6!
                      .byte $7A, $1D, $84, $1C, $2A    ; (Log(2)^4)/5!
                      .byte $7C, $63, $59, $58, $0A    ; (Log(2)^3)/4!
                      .byte $7E, $75, $FD, $E7, $C6    ; (Log(2)^2)/3!
                      .byte $80, $31, $72, $18, $10    ; Log(2)/2!
                      .byte $81, $00, $00, $00, $00    ; 1
                                                       ; --------------------------------
                                                       ; "Exp" function

                                                       ; Fac = e ^ fac
                                                       ; --------------------------------
MS_EXP:               LDA   #<AS_CON_LOG_E             ; Convert to power of two problem
                      LDY   #>AS_CON_LOG_E             ; E^x = 2^(log2(e)*x)
                      JSR   AS_FMULT
                      LDA   MS_Z_00AC_FACOV           ; Non-standard rounding here
                      ADC   #$50                       ; Round up if extension > $AF
                      BCC   AS_L_EXP_1                 ; No, don't round up
                      JSR   AS_INCREMENT_MANTISSA
AS_L_EXP_1:           STA   MS_Z_0092_OLDOV           ; Strange value
                      JSR   AS_MAF                     ; Copy fac into arg
                      LDA   MS_Z_009D_FAC                     ; Maximum exponent is < 128
                      CMP   #$88                       ; Within range?
                      BCC   AS_L_EXP_3                 ; Yes
AS_L_EXP_2:           JSR   AS_OUTOFRNG                ; Overflow if +, return 0.0 if -
AS_L_EXP_3:           JSR   MS_INT                     ; Get int(fac)
                      LDA   MS_Z_000D_CHARAC                  ; This is the inetgral part of the power
                      CLC                              ; Add to exponent bias + 1
                      ADC   #$81
                      BEQ   AS_L_EXP_2                 ; Overflow
                      SEC                              ; Back off to normal bias
                      SBC   #1
                      PHA                              ; Save exponent
                                                       ; --------------------------------
                      LDX   #5                         ; Swap arg and fac
AS_L_EXP_4:           LDA   MS_Z_00A5_ARGEXP,X                   ; <<< Why swap? it is doing      >>>
                      LDY   MS_Z_009D_FAC,X                   ; <<< -(A-b) when (b-a) is the   >>>
                      STA   MS_Z_009D_FAC,X                   ; <<< Same thing!                >>>
                      STY   MS_Z_00A5_ARGEXP,X
                      DEX
                      BPL   AS_L_EXP_4
                      LDA   MS_Z_0092_OLDOV
                      STA   MS_Z_00AC_FACOV
                      JSR   MS_FSUBT                   ; Power-int(power) --> fractional part
                      JSR   MS_NEGOP
                      LDA   #<AS_POLY_EXP
                      LDY   #>AS_POLY_EXP
                      JSR   AS_POLYNOMIAL              ; Compute f(x) on fractional part
                      LDA   #0
                      STA   MS_Z_00AB_ARISGN
                      PLA                              ; Get exponent
                      JSR   AS_ADD_EXPONENTS_1
                      RTS                              ; <<< Wasted byte here, could have >>>
                                                       ; <<< Just used "jmp add.expo..."  >>>
                                                       ; --------------------------------
                                                       ; Odd polynomial subroutine

                                                       ; F(x) = x * p(x^2)

                                                       ; Where:  x is value in fac
                                                       ; Y,a points at coefficient table
                                                       ; First byte of coeff. table is n
                                                       ; Coefficients follow, highest power first

                                                       ; P(x^2) computed using normal polynomial subroutine

                                                       ; --------------------------------
AS_POLYNOMIAL_ODD:
                      STA   AS_SERPNT                  ; Save address of coefficient table
                      STY   AS_SERPNT + 1
                      JSR   AS_STORE_FAC_IN_TEMP1_ROUNDED
                      LDA   #MS_Z_0093_TEMPF1                  ; Y=0 already, so y,a points at temp1
                      JSR   AS_FMULT                   ; Form x^2
                      JSR   AS_SERMAIN                 ; Do series in x^2
                      LDA   #<MS_Z_0093_TEMPF1                 ; Get x again
                      LDY   #>MS_Z_0093_TEMPF1
                      JMP   AS_FMULT                   ; Multiply x by p(x^2) and exit
                                                       ; --------------------------------
                                                       ; Normal polynomial subroutine

                                                       ; P(x) = c(0)*x^n + c(1)*x^(n-1) + ... + c(n)

                                                       ; Where:  x is value in fac
                                                       ; Y,a points at coefficient table
                                                       ; First byte of coeff. table is n
                                                       ; Coefficients follow, highest power first

                                                       ; --------------------------------
AS_POLYNOMIAL:
                      STA   AS_SERPNT                  ; Pointer to coefficient table
                      STY   AS_SERPNT + 1
                                                       ; --------------------------------
AS_SERMAIN:
                      JSR   AS_STORE_FAC_IN_TEMP2_ROUNDED
                      LDA   (AS_SERPNT),Y              ; Get n
                      STA   AS_SERLEN                  ; Save n
                      LDY   AS_SERPNT                  ; Bump pntr to highest coefficient
                      INY                              ; And get pntr into y,a
                      TYA
                      BNE   AS_L_SERMAIN_1
                      INC   AS_SERPNT + 1
AS_L_SERMAIN_1:       STA   AS_SERPNT
                      LDY   AS_SERPNT + 1
AS_L_SERMAIN_2:       JSR   AS_FMULT                   ; Accumulate series terms
                      LDA   AS_SERPNT                  ; Bump pntr to next coefficient
                      LDY   AS_SERPNT + 1
                      CLC
                      ADC   #5
                      BCC   AS_L_SERMAIN_3
                      INY
AS_L_SERMAIN_3:       STA   AS_SERPNT
                      STY   AS_SERPNT + 1
                      JSR   AS_FADD                    ; Add next coefficient
                      LDA   #MS_Z_0098_TEMPF2                  ; Point at x again
                      LDY   #0
                      DEC   AS_SERLEN                  ; If series not finished,
                      BNE   AS_L_SERMAIN_2             ; Then add another term
AS_RTS_19:            RTS                              ; Finished
                                                       ; --------------------------------

AS_CON_RND_1:         .byte $98, $35, $44, $7A         ; <<< These are missing one byte >>>
AS_CON_RND_2:         .byte $68, $28, $B1, $46         ; <<< For fp values              >>>
                                                       ; --------------------------------
                                                       ; "Rnd" function
                                                       ; --------------------------------
MS_RND:               JSR   AS_SIGN                    ; Reduce argument to -1, 0, or +1
                      TAX                              ; Save argument
                      BMI   AS_L_RND_1                 ; = -1, Use current argument for seed
                      LDA   #<MS_Z_00C9_RNDX               ; Use current seed
                      LDY   #>MS_Z_00C9_RNDX
                      JSR   AS_LOAD_FAC_FROM_YA
                      TXA                              ; Recall sign of argument
                      BEQ   AS_RTS_19                  ; =0, Return seed unchanged
                      LDA   #<AS_CON_RND_1             ; Very poor rnd algorithm
                      LDY   #>AS_CON_RND_1
                      JSR   AS_FMULT
                      LDA   #<AS_CON_RND_2             ; Also, constants are truncated
                      LDY   #>AS_CON_RND_2             ; <<<This does nothing, due to >>>
                                                       ; <<<Small exponent            >>>
                      JSR   AS_FADD
AS_L_RND_1:           LDX   MS_Z_009D_FAC + 4                 ; Shuffle hi and lo bytes
                      LDA   MS_Z_009D_FAC + 1                 ; To supposedly make it more random
                      STA   MS_Z_009D_FAC + 4
                      STX   MS_Z_009D_FAC + 1
                      LDA   #0                         ; Make it positive
                      STA   MS_Z_00A2_FACSGN
                      LDA   MS_Z_009D_FAC                     ; A somewhat random extension
                      STA   MS_Z_00AC_FACOV
                      LDA   #$80                       ; Exponent to make value < 1.0
                      STA   MS_Z_009D_FAC
                      JSR   AS_NORMALIZE_FAC_2
                      LDX   #<MS_Z_00C9_RNDX               ; Move fac to rnd seed
                      LDY   #>MS_Z_00C9_RNDX
AS_GO_MOVMF:          JMP   AS_STORE_FACDB_YX_ROUNDED
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; "Cos" function
                                                       ; --------------------------------
MS_COS:               LDA   #<AS_CON_PI_HALF           ; Cos(x)=sin(x + pi/2)
                      LDY   #>AS_CON_PI_HALF
                      JSR   AS_FADD
                                                       ; --------------------------------
                                                       ; "Sin" function
                                                       ; --------------------------------
MS_SIN:               JSR   AS_COPY_FAC_TO_ARG_ROUNDED
                      LDA   #<AS_CON_PI_DOUB           ; Remove multiples of 2*pi
                      LDY   #>AS_CON_PI_DOUB           ; By dividing and saving
                      LDX   MS_Z_00AA_ARGSGN                ; The fractional part
                      JSR   AS_DIV                     ; Use sign of argument
                      JSR   AS_COPY_FAC_TO_ARG_ROUNDED
                      JSR   MS_INT                     ; Take integer part
                      LDA   #0                         ; <<< Wasted lines, because fsubt >>>
                      STA   MS_Z_00AB_ARISGN                  ; <<< Changes sgncpr again        >>>
                      JSR   MS_FSUBT                   ; Subtract to get fractional part
                                                       ; --------------------------------
                                                       ; (Fac) = angle as a fraction of a full circle

                                                       ; Now fold the range into a quarter circle

                                                       ; <<< There are much simpler ways to do this >>>
                                                       ; --------------------------------
                      LDA   #<AS_QUARTER               ; 1/4 - Fraction makes
                      LDY   #>AS_QUARTER               ; -3/4 <= Fraction < 1/4
                      JSR   AS_FSUB
                      LDA   MS_Z_00A2_FACSGN                ; Test sign of result
                      PHA                              ; Save sign for later unfolding
                      BPL   AS_SIN_1                   ; Already 0...1/4
                      JSR   AS_FADDH                   ; Add 1/2 to shift to -1/4...1/2
                      LDA   MS_Z_00A2_FACSGN                ; Test sign
                      BMI   AS_SIN_2                   ; -1/4...0
                                                       ; 0...1/2
                      LDA   MS_Z_0016_TANSGN                 ; Signflg initialized = 0 in "tan"
                      EOR   #$FF                       ; Function
                      STA   MS_Z_0016_TANSGN                 ; "Tan" is only user of signflg too
                                                       ; --------------------------------
                                                       ; If fall thru, range is 0...1/2
                                                       ; If branch here, range is 0...1/4
                                                       ; --------------------------------
AS_SIN_1:             JSR   MS_NEGOP
                                                       ; --------------------------------
                                                       ; If fall thru, range is -1/2...0
                                                       ; If branch here, range is -1/4...0
                                                       ; --------------------------------
AS_SIN_2:             LDA   #<AS_QUARTER               ; Add 1/4 to shift range
                      LDY   #>AS_QUARTER               ; To -1/4...1/4
                      JSR   AS_FADD
                      PLA                              ; Get saved sign from above
                      BPL   AS_L_SIN_2_1
                      JSR   MS_NEGOP                   ; Make range 0...1/4
AS_L_SIN_2_1:         LDA   #<AS_POLY_SIN              ; Do standard sin series
                      LDY   #>AS_POLY_SIN
                      JMP   AS_POLYNOMIAL_ODD
                                                       ; --------------------------------
                                                       ; "Tan" function

                                                       ; Compute tan(x) = sin(x) / cos(x)
                                                       ; --------------------------------
MS_TAN:               JSR   AS_STORE_FAC_IN_TEMP1_ROUNDED
                      LDA   #0                         ; Signflg will be toggled if 2nd or 3rd
                      STA   MS_Z_0016_TANSGN                 ; Quadrant
                      JSR   MS_SIN                     ; Get sin(x)
                      LDX   #<MS_Z_008A_GRBPNT                 ; Save sin(x) in temp3
                      LDY   #>MS_Z_008A_GRBPNT
                      JSR   AS_GO_MOVMF                ; <<<Funny way to call movmf! >>>
                      LDA   #<MS_Z_0093_TEMPF1                 ; Retrieve x
                      LDY   #>MS_Z_0093_TEMPF1
                      JSR   AS_LOAD_FAC_FROM_YA
                      LDA   #0                         ; And compute cos(x)
                      STA   MS_Z_00A2_FACSGN
                      LDA   MS_Z_0016_TANSGN
                      JSR   AS_TAN_1                   ; Weird & dangerous way to get into sin
                      LDA   #<MS_Z_008A_GRBPNT                 ; Now form sin/cos
                      LDY   #>MS_Z_008A_GRBPNT
                      JMP   AS_FDIV
                                                       ; --------------------------------
AS_TAN_1:             PHA                              ; Shame, shame!
                      JMP   AS_SIN_1
                                                       ; --------------------------------

AS_CON_PI_HALF:       .byte $81, $49, $0F, $DA, $A2
AS_CON_PI_DOUB:       .byte $83, $49, $0F, $DA, $A2
AS_QUARTER:           .byte $7F, $00, $00, $00, $00
                                                       ; --------------------------------
AS_POLY_SIN:          .byte 5                          ; Power of polynomial
                      .byte $84, $E6, $1A, $2D, $1B    ; (2Pi)^11/11!
                      .byte $86, $28, $07, $FB, $F8    ; (2Pi)^9/9!
                      .byte $87, $99, $68, $89, $01    ; (2Pi)^7/7!
                      .byte $87, $23, $35, $DF, $E1    ; (2Pi)^5/5!
                      .byte $86, $A5, $5D, $E7, $28    ; (2Pi)^3/3!
                      .byte $83, $49, $0F, $DA, $A2    ; 2Pi

                                                       ; --------------------------------
                                                       ; <<< Next ten bytes are never referenced >>>
                                                       ; Obfuscated "microsoft!" by bill gates
                                                       ; (Reversed, high bit set, xor 7)
                                                       ; --------------------------------

                      .byte ("!" | %10000000) ^ 7
                      .byte ("T" | %10000000) ^ 7
                      .byte ("F" | %10000000) ^ 7
                      .byte ("O" | %10000000) ^ 7
                      .byte ("S" | %10000000) ^ 7
                      .byte ("O" | %10000000) ^ 7
                      .byte ("R" | %10000000) ^ 7
                      .byte ("C" | %10000000) ^ 7
                      .byte ("I" | %10000000) ^ 7
                      .byte ("M" | %10000000) ^ 7

                                                       ; --------------------------------
                                                       ; "Atn" function
                                                       ; --------------------------------
MS_ATN:               LDA   MS_Z_00A2_FACSGN                ; Fold the argument range first
                      PHA                              ; Save sign for later unfolding
                      BPL   AS_L_ATN_1                 ; .Ge. 0
                      JSR   MS_NEGOP                   ; .Lt. 0, so complement
AS_L_ATN_1:           LDA   MS_Z_009D_FAC                     ; If .ge. 1, form reciprocal
                      PHA                              ; Save for later unfolding
                      CMP   #$81                       ; (Exponent for .ge. 1
                      BCC   AS_L_ATN_2                 ; x < 1
                      LDA   #<AS_CON_ONE               ; Form 1/x
                      LDY   #>AS_CON_ONE
                      JSR   AS_FDIV
                                                       ; --------------------------------
                                                       ; 0 <= x <= 1
                                                       ; 0 <= Atn(x) <= pi/8
                                                       ; --------------------------------
AS_L_ATN_2:           LDA   #<AS_POLY_ATN              ; Compute polynomial approximation
                      LDY   #>AS_POLY_ATN
                      JSR   AS_POLYNOMIAL_ODD
                      PLA                              ; Start to unfold
                      CMP   #$81                       ; Was it .ge. 1?
                      BCC   AS_L_ATN_3                 ; No
                      LDA   #<AS_CON_PI_HALF           ; Yes, subtract from pi/2
                      LDY   #>AS_CON_PI_HALF
                      JSR   AS_FSUB
AS_L_ATN_3:           PLA                              ; Was it negative?
                      BPL   AS_RTS_20                  ; No
                      JMP   MS_NEGOP                   ; Yes, complement
AS_RTS_20:            RTS
                                                       ; --------------------------------
AS_POLY_ATN:          .byte 11                         ; Power of polynomial
                      .byte $76, $B3, $83, $BD, $D3
                      .byte $79, $1E, $F4, $A6, $F5
                      .byte $7B, $83, $FC, $B0, $10
                      .byte $7C, $0C, $1F, $67, $CA
                      .byte $7C, $DE, $53, $CB, $C1
                      .byte $7D, $14, $64, $70, $4C
                      .byte $7D, $B7, $EA, $51, $7A
                      .byte $7D, $63, $30, $88, $7E
                      .byte $7E, $92, $44, $99, $3A
                      .byte $7E, $4C, $CC, $91, $C7
                      .byte $7F, $AA, $AA, $AA, $13
                      .byte $81, $00, $00, $00, $00
                                                       ; --------------------------------
                                                       ; Generic copy of chrget subroutine, which
                                                       ; Is copied into $00B1...$00C8 during initialization

                                                       ; Cornelis bongers described several improvements
                                                       ; To chrget in micro magazine or call a.p.p.l.e.
                                                       ; (I don't remember which or exactly when)
                                                       ; --------------------------------
AS_GENERIC_CHRGET:
                      INC   MS_Z_00B8_TXTPTR
                      BNE   AS_L_GENERIC_CHRGET_1
                      INC   MS_Z_00B8_TXTPTR + 1
AS_L_GENERIC_CHRGET_1: LDA   $EA60                      ; <<< Actual address filled in later >>>
                      CMP   #":" & %01111111           ; Eos, also top of numeric range
                      BCS   AS_L_GENERIC_CHRGET_2      ; Not number, might be eos
                      CMP   #" " & %01111111           ; Ignore blanks
                      BEQ   AS_GENERIC_CHRGET
                      SEC                              ; Test for numeric range in way that
                      SBC   #"0" & %01111111           ; Clears carry if char is digit
                      SEC                              ; And leaves char in a-reg
                      SBC   #$D0
AS_L_GENERIC_CHRGET_2: RTS
                                                       ; --------------------------------
                                                       ; Initial value for random number, also copied
                                                       ; In along with chrget, but erroneously:
                                                       ; <<< The last byte is not copied >>>
                                                       ; --------------------------------

                      .byte $80, $4F, $C7, $52, $58    ; Approx. = l_generic_chrget_811635157
AS_GENERIC_END:
                                                       ; --------------------------------
AS_COLD_START:
                      LDX   #$FF                       ; Set direct mode flag
                      STX   MS_Z_0075_CURLIN + 1
                      LDX   #$FB                       ; Set stack pointer, leaving room for
                      TXS                              ; Line buffer during parsing
                      LDA   #<AS_COLD_START            ; Set restart to cold.start
                      LDY   #>AS_COLD_START            ; Until coldstart is completed
                      STA   MS_Z_0000_START + 1
                      STY   MS_Z_0000_START + 2
                      STA   MS_Z_0003_RDYJSR + 1            ; Also second user vector...
                      STY   MS_Z_0003_RDYJSR + 2            ; ..We simply must finish cold.start!
                      JSR   AS_NORMAL                  ; Set normal display mode
                      LDA   #$4C                       ; "Jmp" opcode for 4 vectors
                      STA   MS_Z_0000_START                  ; Warm start
                      STA   MS_Z_0003_RDYJSR                ; Anyone ever use this one?
                      STA   MS_Z_0090_JMPER                 ; Used by functions (jsr jmpadrs)
AS_L_USR1:            STA   MS_Z_000A_USRPOK                     ; "Usr" function vector
                      LDA   #<AS_IQERR                 ; Point "usr" to illegal quantity
                      LDY   #>AS_IQERR                 ; Error, until user sets it up
                      STA   MS_Z_000A_USRPOK + 1
                      STY   MS_Z_000A_USRPOK + 2
AS_L_USR2:                                             ; --------------------------------
                                                       ; Move generic chrget and random seed into place

                                                       ; <<< Note that loop value is wrong!          >>>
                                                       ; <<< The last byte of the random seed is not >>>
                                                       ; <<< Copied into page zero!                  >>>
                                                       ; --------------------------------
                      LDX   #AS_GENERIC_END - AS_GENERIC_CHRGET - 1
AS_L_COLD_START_1:    LDA   AS_GENERIC_CHRGET - 1,X
                      STA   MS_Z_00B1_CHRGET - 1,X
                      STX   AS_SPEEDZ                  ; On last pass stores $01)
                      DEX
                      BNE   AS_L_COLD_START_1
                                                       ; --------------------------------
                      STX   AS_TRCFLG                  ; x=0, turn off tracing
                      TXA                              ; a=0
                      STA   AS_SHIFT_SIGN_EXT
                      STA   MS_Z_0053_LASTPT + 1
                      PHA                              ; Put $00 on stack (what for?)
                      LDA   #3                         ; Set length of temp. string descriptors
                      STA   AS_DSCLEN                  ; For garbage collection subroutine
                      JSR   AS_CRDO                    ; Print <return>
                      LDA   #1                         ; Set up fake forward link
                      STA   MS_BUF - 3
                      STA   MS_BUF - 4
                      LDX   #MS_Z_0055_TEMPST                 ; Init index to temp string descriptors
                      STX   MS_Z_0052_TEMPPT
                                                       ; --------------------------------
                                                       ; Find high end of ram
                                                       ; --------------------------------
                      LDA   #<$0800                    ; Set up pointer to low end of ram
                      LDY   #>$0800
                      STA   MS_Z_0050_LINNUM
                      STY   MS_Z_0050_LINNUM + 1
                      LDY   #0
AS_L_COLD_START_2:    INC   MS_Z_0050_LINNUM + 1              ; Test first byte of each page
                      LDA   (MS_Z_0050_LINNUM),Y              ; By complementing it and watching
                      EOR   #$FF                       ; It change the same way
                      STA   (MS_Z_0050_LINNUM),Y
                      CMP   (MS_Z_0050_LINNUM),Y              ; Rom or empty sockets won't track
                      BNE   AS_L_COLD_START_3          ; Not ram here
                      EOR   #$FF                       ; Restore original value
                      STA   (MS_Z_0050_LINNUM),Y
                      CMP   (MS_Z_0050_LINNUM),Y              ; Did it track again?
                      BEQ   AS_L_COLD_START_2          ; Yes, still in ram
AS_L_COLD_START_3:    LDY   MS_Z_0050_LINNUM                  ; No, end of ram
                      LDA   MS_Z_0050_LINNUM + 1
                      AND   #$F0                       ; Force a multiple of 4096 bytes
                      STY   MS_Z_0073_MEMSIZ                  ; (Bad ram may have yielded non-multiple)
                      STA   MS_Z_0073_MEMSIZ + 1
                      STY   MS_Z_006F_FRETOP                  ; Set himem and bottom of strings
                      STA   MS_Z_006F_FRETOP + 1
                      LDX   #<$0800                    ; Set program pointer to $0800
                      LDY   #>$0800
                      STX   MS_Z_0067_TXTTAB
                      STY   MS_Z_0067_TXTTAB + 1
                      LDY   #0                         ; Turn off semi-secret lock flag
                      STY   AS_LOCK
                      TYA                              ; A=0 too
                      STA   (MS_Z_0067_TXTTAB),Y              ; First byte in program space = 0
                      INC   MS_Z_0067_TXTTAB                  ; Advance past the $00
                      BNE   AS_L_COLD_START_4
                      INC   MS_Z_0067_TXTTAB + 1
AS_L_COLD_START_4:    LDA   MS_Z_0067_TXTTAB
                      LDY   MS_Z_0067_TXTTAB + 1
                      JSR   AS_REASON                  ; Set rest of pointers up
                      JSR   AS_SCRTCH                  ; More pointers
                      LDA   #<AS_STROUT                ; Put correct addresses in two
                      LDY   #>AS_STROUT                ; User vectors
                      STA   MS_Z_0003_RDYJSR + 1
                      STY   MS_Z_0003_RDYJSR + 2
                      LDA   #<AS_RESTART
                      LDY   #>AS_RESTART
                      STA   MS_Z_0000_START + 1
                      STY   MS_Z_0000_START + 2
                      JMP   (MS_Z_0000_START + 1)            ; Silly, why not just "jmp restart"
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; "Call" statement

                                                       ; Effectively performs a "jsr" to the specified
                                                       ; Address, with the following register contents:
                                                       ; (A,y) = call address
                                                       ; (X)   = $9D

                                                       ; The called routine can return with "rts",
                                                       ; And applesoft will continue with the next
                                                       ; Statement.
                                                       ; --------------------------------
AS_CALL:              JSR   AS_FRMNUM                  ; Evaluate expression for call address
                      JSR   AS_GETADR                  ; Convert expression to 16-bit integer
                      JMP   (MS_Z_0050_LINNUM)                ; In linnum, and jump there.
                                                       ; --------------------------------
                                                       ; "In#" statement

                                                       ; Note:  no check for valid slot #, as long
                                                       ; As value is < 256 it is accepted.
                                                       ; Monitor masks value to 4 bits (0-15).
                                                       ; --------------------------------
AS_IN_NUMBER:
                      JSR   AS_GETBYT                  ; Get slot number in x-reg
                      TXA                              ; Monitor will install in vector
                      JMP   MON_INPORT                 ; At $38,39.
                                                       ; --------------------------------
                                                       ; "Pr#" statement

                                                       ; Note:  no check for valid slot #, as long
                                                       ; As value is < 256 it is accepted.
                                                       ; Monitor masks value to 4 bits (0-15).
                                                       ; --------------------------------
AS_PR_NUMBER:
                      JSR   AS_GETBYT                  ; Get slot number in x-reg
                      TXA                              ; Monitor will install in vector
                      JMP   MON_OUTPORT                ; At $36,37
                                                       ; --------------------------------
                                                       ; Get two values < 48, with comma separator

                                                       ; Called for "plot x,y"
                                                       ; And "hlin a,b at y"
                                                       ; And "vlin a,b at x"

                                                       ; --------------------------------
AS_PLOTFNS:
                      JSR   AS_GETBYT                  ; Get first value in x-reg
                      CPX   #48                        ; Must be < 48
                      BCS   AS_GOERR                   ; Too large
                      STX   AS_FIRST                   ; Save first value
                      LDA   #"," & %01111111           ; Must have a comma
                      JSR   AS_SYNCHR
                      JSR   AS_GETBYT                  ; Get second value in x-reg
                      CPX   #48                        ; Must be < 48
                      BCS   AS_GOERR                   ; Too large
                      STX   MON_H2                     ; Save second value
                      STX   MON_V2
                      RTS                              ; Second value still in x-reg
                                                       ; --------------------------------
AS_GOERR:             JMP   AS_IQERR                   ; Illegal quantity error
                                                       ; --------------------------------
                                                       ; Get "a,b at c" values for "hlin" and "vlin"

                                                       ; Put smaller of (a,b) in first,
                                                       ; And larger  of (a,b) in h2 and v2.
                                                       ; Return with (x) = c-value.
                                                       ; --------------------------------
AS_LINCOOR:
                      JSR   AS_PLOTFNS                 ; Get a,b values
                      CPX   AS_FIRST                   ; Is a < b?
                      BCS   AS_L_LINCOOR_1             ; Yes, in right order
                      LDA   AS_FIRST                   ; No, interchange them
                      STA   MON_H2
                      STA   MON_V2
                      STX   AS_FIRST
AS_L_LINCOOR_1:       LDA   #AS_TOKENDB                ; Must have "at" next
                      JSR   AS_SYNCHR
                      JSR   AS_GETBYT                  ; Get c-value in x-reg
                      CPX   #48                        ; Must be < 48
                      BCS   AS_GOERR                   ; Too large
                      RTS                              ; C-value in x-reg
                                                       ; --------------------------------
                                                       ; "Plot" statement
                                                       ; --------------------------------
AS_PLOT:              JSR   AS_PLOTFNS                 ; Get x,y values
                      TXA                              ; Y-coord to a-reg for monitor
                      LDY   AS_FIRST                   ; X-coord to y-yeg for monitor
                      CPY   #40                        ; X-coord must be < 40
                      BCS   AS_GOERR                   ; X-coord is too large
                      JMP   MON_PLOT                   ; Plot!
                                                       ; --------------------------------
                                                       ; "Hlin" statement
                                                       ; --------------------------------
AS_HLIN:              JSR   AS_LINCOOR                 ; Get "a,b at c"
                      TXA                              ; Y-coord in a-reg
                      LDY   MON_H2                     ; Right end of line
                      CPY   #40                        ; Must be < 40
                      BCS   AS_GOERR                   ; Too large
                      LDY   AS_FIRST                   ; Left end of line in y-reg
                      JMP   MON_HLINE                  ; Let monitor draw line
                                                       ; --------------------------------
                                                       ; "Vlin" statement
                                                       ; --------------------------------
AS_VLIN:              JSR   AS_LINCOOR                 ; Get "a,b at c"
                      TXA                              ; X-coord in y-reg
                      TAY
                      CPY   #40                        ; X-coord must be < 40
                      BCS   AS_GOERR                   ; Too large
                      LDA   AS_FIRST                   ; Top end of line in a-reg
                      JMP   MON_VLINE                  ; Let monitor draw line
                                                       ; --------------------------------
                                                       ; "Color=" statement
                                                       ; --------------------------------
AS_COLOR:             JSR   AS_GETBYT                  ; Get color value in x-reg
                      TXA
                      JMP   MON_SETCOL                 ; Let monitor store color
                                                       ; --------------------------------
                                                       ; "Vtab" statement
                                                       ; --------------------------------
AS_VTAB:              JSR   AS_GETBYT                  ; Get line # in x-reg
                      DEX                              ; Convert to zero base
                      TXA
                      CMP   #24                        ; Must be 0-23
                      BCS   AS_GOERR                   ; Too large, or was "vtab 0"
                      JMP   MON_TABV                   ; Let monitor compute base
                                                       ; --------------------------------
                                                       ; "Speed=" statement
                                                       ; --------------------------------
AS_SPEED:             JSR   AS_GETBYT                  ; Get speed setting in x-reg
                      TXA                              ; Speedz = $100-speed
                      EOR   #$FF                       ; So "speed=255" is fastest
                      TAX
                      INX
                      STX   AS_SPEEDZ
                      RTS
                                                       ; --------------------------------
                                                       ; "Trace" statement
                                                       ; Set sign bit in trcflg
                                                       ; --------------------------------
AS_TRACE:             SEC
                      .byte $90                        ; Fake bcc to skip next opcode
                                                       ; --------------------------------
                                                       ; "Notrace" statement
                                                       ; Clear sign bit in trcflg
                                                       ; --------------------------------
AS_NOTRACE:
                      CLC
                      ROR   AS_TRCFLG                  ; Shift carry into trcflg
                      RTS
                                                       ; --------------------------------
                                                       ; "Normal" statement
                                                       ; --------------------------------
AS_NORMAL:            LDA   #$FF                       ; Set invflg = $FF
                      BNE   AS_N_I_                    ; And flash.bit = $00
                                                       ; --------------------------------
                                                       ; "Inverse" statement
                                                       ; --------------------------------
AS_INVERSE:
                      LDA   #$3F                       ; Set invflg = $3F
AS_N_I_:              LDX   #0                         ; And flash.bit = $00
AS_N_I_F_:            STA   MON_INVFLG
                      STX   AS_FLASH_BIT
                      RTS
                                                       ; --------------------------------
                                                       ; "Flash" statement
                                                       ; --------------------------------
AS_FLASH:             LDA   #$7F                       ; Set invflg = $7F
                      LDX   #$40                       ; And flash.bit = $40
                      BNE   AS_N_I_F_                  ; ...Always
                                                       ; --------------------------------
                                                       ; "Himem:" statement
                                                       ; --------------------------------
AS_HIMEM:             JSR   AS_FRMNUM                  ; Get value specified for himem
                      JSR   AS_GETADR                  ; As 16-bit integer
                      LDA   MS_Z_0050_LINNUM                  ; Must be above variables and arrays
                      CMP   MS_Z_006D_STREND
                      LDA   MS_Z_0050_LINNUM + 1
                      SBC   MS_Z_006D_STREND + 1
                      BCS   AS_SETHI                   ; It is above them
AS_JMM:               JMP   AS_MEMERR                  ; Not enough memory
AS_SETHI:             LDA   MS_Z_0050_LINNUM                  ; Store new himem: value
                      STA   MS_Z_0073_MEMSIZ
                      STA   MS_Z_006F_FRETOP                  ; <<<Note that "himem:" does not>>>
                      LDA   MS_Z_0050_LINNUM + 1              ; <<<Clear string variables.    >>>
                      STA   MS_Z_0073_MEMSIZ + 1              ; <<<This could be disastrous.  >>>
                      STA   MS_Z_006F_FRETOP + 1
                      RTS
                                                       ; --------------------------------
                                                       ; "Lomem:" statement
                                                       ; --------------------------------
AS_LOMEM:             JSR   AS_FRMNUM                  ; Get value specified for lomem
                      JSR   AS_GETADR                  ; As 16-bit integer in linnum
                      LDA   MS_Z_0050_LINNUM                  ; Must be below himem
                      CMP   MS_Z_0073_MEMSIZ
                      LDA   MS_Z_0050_LINNUM + 1
                      SBC   MS_Z_0073_MEMSIZ + 1
                      BCS   AS_JMM                     ; Above himem, memory error
                      LDA   MS_Z_0050_LINNUM                  ; Must be above program
                      CMP   MS_Z_0069_VARTAB
                      LDA   MS_Z_0050_LINNUM + 1
                      SBC   MS_Z_0069_VARTAB + 1
                      BCC   AS_JMM                     ; Not above program, error
                      LDA   MS_Z_0050_LINNUM                  ; Store new lomem value
                      STA   MS_Z_0069_VARTAB
                      LDA   MS_Z_0050_LINNUM + 1
                      STA   MS_Z_0069_VARTAB + 1
                      JMP   AS_CLEARC                  ; Lomem clears variables and arrays
                                                       ; --------------------------------
                                                       ; "On err go to" statement
                                                       ; --------------------------------
AS_ONERR:             LDA   #MS_T_GOTOTK             ; Must be "goto" next
                      JSR   AS_SYNCHR
                      LDA   MS_Z_00B8_TXTPTR                  ; Save txtptr for handlerr
                      STA   AS_TXTPSV
                      LDA   MS_Z_00B8_TXTPTR + 1
                      STA   AS_TXTPSV + 1
                      SEC                              ; Set sign bit of errflg
                      ROR   AS_ERRFLG
                      LDA   MS_Z_0075_CURLIN                  ; Save line # of current line
                      STA   AS_CURLSV
                      LDA   MS_Z_0075_CURLIN + 1
                      STA   AS_CURLSV + 1
                      JSR   AS_REMN                    ; Ignore rest of line <<<why?>>>
                      JMP   AS_ADDON                   ; Continue program
                                                       ; --------------------------------
                                                       ; Routine to handle errors if onerr goto active
                                                       ; --------------------------------
AS_HANDLERR:
                      STX   AS_ERRNUM                  ; Save error code number
                      LDX   AS_REMSTK                  ; Get stack pntr saved at newstt
                      STX   AS_ERRSTK                  ; Remember it
                                                       ; <<<Could also have done txs  >>>
                                                       ; <<<Here; see onerr correction>>>
                                                       ; <<<In applesoft manual.      >>>
                      LDA   MS_Z_0075_CURLIN                  ; Get line # of offending statement
                      STA   AS_ERRLIN                  ; So user can see it if desired
                      LDA   MS_Z_0075_CURLIN + 1
                      STA   AS_ERRLIN + 1
                      LDA   MS_Z_0079_OLDTXT                 ; Also the position in the line
                      STA   AS_ERRPOS                  ; In case user wants to "resume"
                      LDA   MS_Z_0079_OLDTXT + 1
                      STA   AS_ERRPOS + 1
                      LDA   AS_TXTPSV                  ; Set up txtptr to read target line #
                      STA   MS_Z_00B8_TXTPTR                  ; In "on err go to xxxx"
                      LDA   AS_TXTPSV + 1
                      STA   MS_Z_00B8_TXTPTR + 1
                      LDA   AS_CURLSV
                      STA   MS_Z_0075_CURLIN                  ; Line # of "on err" statement
                      LDA   AS_CURLSV + 1
                      STA   MS_Z_0075_CURLIN + 1
                      JSR   MS_Z_00B7_CHRGOT                  ; Start conversion
                      JSR   MS_GOTO                    ; Goto specified onerr line
                      JMP   AS_NEWSTT
                                                       ; --------------------------------
                                                       ; "Resume" statement
                                                       ; --------------------------------
AS_RESUME:            LDA   AS_ERRLIN                  ; Restore line # and txtptr
                      STA   MS_Z_0075_CURLIN                  ; To re-try offending line
                      LDA   AS_ERRLIN + 1
                      STA   MS_Z_0075_CURLIN + 1
                      LDA   AS_ERRPOS
                      STA   MS_Z_00B8_TXTPTR
                      LDA   AS_ERRPOS + 1
                      STA   MS_Z_00B8_TXTPTR + 1
                                                       ; <<< Onerr correction in manual is easily >>>
                                                       ; <<< By "call -3288", which is $F328 here >>>
                      LDX   AS_ERRSTK                  ; Retrieve stack pntr as it was
                      TXS                              ; Before statement scanned
                      JMP   AS_NEWSTT                  ; Do statement again
                                                       ; --------------------------------
AS_JSYN:              JMP   AS_SYNERR
                                                       ; --------------------------------
                                                       ; "Del" statement
                                                       ; --------------------------------
AS_DEL:               BCS   AS_JSYN                    ; Error if # not specified
                      LDX   AS_PRGEND
                      STX   MS_Z_0069_VARTAB
                      LDX   AS_PRGEND + 1
                      STX   MS_Z_0069_VARTAB + 1
                      JSR   AS_LINGET                  ; Get beginning of range
                      JSR   AS_FNDLIN                  ; Find this line or next
                      LDA   MS_Z_009B_LOWTR                   ; Upper portion of program will
                      STA   AS_DEST                    ; Be moved down to here
                      LDA   MS_Z_009B_LOWTR + 1
                      STA   AS_DEST + 1
                      LDA   #"," & %01111111           ; Must have a comma next
                      JSR   AS_SYNCHR
                      JSR   AS_LINGET                  ; Get end range
                                                       ; (Does nothing if end range
                                                       ; Is not specified)
                      INC   MS_Z_0050_LINNUM                  ; Point one past it
                      BNE   AS_L_DEL_1
                      INC   MS_Z_0050_LINNUM + 1
AS_L_DEL_1:           JSR   AS_FNDLIN                  ; Find start line after specified line
                      LDA   MS_Z_009B_LOWTR                   ; Which is beginning of portion
                      CMP   AS_DEST                    ; To be moved down
                      LDA   MS_Z_009B_LOWTR + 1               ; It must be above the target
                      SBC   AS_DEST + 1
                      BCS   AS_L_DEL_2                 ; It is okay
                      RTS                              ; Nothing to delete
AS_L_DEL_2:           LDY   #0                         ; Move upper portion down now
AS_L_DEL_3:           LDA   (MS_Z_009B_LOWTR),Y               ; Source . . .
                      STA   (AS_DEST),Y                ; ...To destination
                      INC   MS_Z_009B_LOWTR                   ; Bump source pntr
                      BNE   AS_L_DEL_4
                      INC   MS_Z_009B_LOWTR + 1
AS_L_DEL_4:           INC   AS_DEST                    ; Bump destination pntr
                      BNE   AS_L_DEL_5
                      INC   AS_DEST + 1
AS_L_DEL_5:           LDA   MS_Z_0069_VARTAB                  ; Reached end of program yet?
                      CMP   MS_Z_009B_LOWTR
                      LDA   MS_Z_0069_VARTAB + 1
                      SBC   MS_Z_009B_LOWTR + 1
                      BCS   AS_L_DEL_3                 ; No, keep moving
                      LDX   AS_DEST + 1                ; Store new end of program
                      LDY   AS_DEST                    ; Must subtract 1 first
                      BNE   AS_L_DEL_6
                      DEX
AS_L_DEL_6:           DEY
                      STX   MS_Z_0069_VARTAB + 1
                      STY   MS_Z_0069_VARTAB
                      JMP   AS_FIX_LINKS               ; Reset links after a delete
                                                       ; --------------------------------
                                                       ; "Gr" statement
                                                       ; --------------------------------
AS_GR:                LDA   AS_SW_LORES
                      LDA   AS_SW_MIXSET
                      JMP   MON_SETGR
                                                       ; --------------------------------
                                                       ; "Text" statement
                                                       ; --------------------------------
AS_TEXT:              LDA   AS_SW_LOWSCR               ; Jmp $FB36 would have
                      JMP   MON_SETTXT                 ; Done both of these
                                                       ; <<<       Better code would be:   >>>
                                                       ; <<<  Lda sw.mixset                >>>
                                                       ; <<<  Jmp $FB33                    >>>
                                                       ; --------------------------------
                                                       ; "Store" statement
                                                       ; --------------------------------
AS_STORE:             JSR   AS_GETARYPT                ; Get address of array to be saved
                      LDY   #3                         ; Forward offset - 1 is size of
                      LDA   (MS_Z_009B_LOWTR),Y               ; This array
                      TAX
                      DEY
                      LDA   (MS_Z_009B_LOWTR),Y
                      SBC   #1
                      BCS   AS_L_STORE_1
                      DEX
AS_L_STORE_1:         STA   MS_Z_0050_LINNUM
                      STX   MS_Z_0050_LINNUM + 1
                      JSR   MS_CQCOUT
                      JSR   AS_TAPEPNT
                      JMP   MS_CQCOUT
                                                       ; --------------------------------
                                                       ; "Recall" statement
                                                       ; --------------------------------
AS_RECALL:            JSR   AS_GETARYPT                ; Find array in memory
                      JSR   MS_CQCSIN                   ; Read header
                      LDY   #2                         ; Make sure the new data fits
                      LDA   (MS_Z_009B_LOWTR),Y
                      CMP   MS_Z_0050_LINNUM
                      INY
                      LDA   (MS_Z_009B_LOWTR),Y
                      SBC   MS_Z_0050_LINNUM + 1
                      BCS   AS_L_RECALL_1              ; It fits
                      JMP   AS_MEMERR                  ; Doesn't fit
AS_L_RECALL_1:        JSR   AS_TAPEPNT                 ; Read the data
                      JMP   MS_CQCSIN
                                                       ; --------------------------------
                                                       ; "Hgr" and "hgr2" statements
                                                       ; --------------------------------
AS_HGR2:              BIT   AS_SW_HISCR                ; Select page 2 ($4000-5fff)
                      BIT   AS_SW_MIXCLR               ; Default to full screen
                      LDA   #>$4000                    ; Set starting page for hires
                      BNE   AS_SETHPG                  ; ...Always
AS_HGR:               LDA   #>$2000                    ; Set starting page for hires
                      BIT   AS_SW_LOWSCR               ; Select page 1 ($2000-3fff)
                      BIT   AS_SW_MIXSET               ; Default to mixed screen
AS_SETHPG:            STA   AS_HGR_PAGE                ; Base page of hires buffer
                      LDA   AS_SW_HIRES                ; Turn on hires
                      LDA   AS_SW_TXTCLR               ; Turn on graphics
                                                       ; --------------------------------
                                                       ; Clear screen
                                                       ; --------------------------------
AS_HCLR:              LDA   #0                         ; Set for black background
                      STA   AS_HGR_BITS
                                                       ; --------------------------------
                                                       ; Fill screen with (hgr.bits)
                                                       ; --------------------------------
AS_BKGND:             LDA   AS_HGR_PAGE                ; Put buffer address in hgr.shape
                      STA   AS_HGR_SHAPE + 1
                      LDY   #0
                      STY   AS_HGR_SHAPE
AS_L_BKGND_1:         LDA   AS_HGR_BITS                ; Color byte
                      STA   (AS_HGR_SHAPE),Y           ; Clear hires to hgr.bits
                      JSR   AS_COLOR_SHIFT             ; Correct for color shift
                      INY                              ; (Slows clear by factor of 2)
                      BNE   AS_L_BKGND_1
                      INC   AS_HGR_SHAPE + 1
                      LDA   AS_HGR_SHAPE + 1
                      AND   #$1F                       ; Done?  ($40 or$60)
                      BNE   AS_L_BKGND_1               ; No
                      RTS                              ; Yes, return
                                                       ; --------------------------------
                                                       ; Set the hires cursor position

                                                       ; (Y,x) = horizontal coordinate  (0-279)
                                                       ; (A)   = vertical coordinate    (0-191)
                                                       ; --------------------------------
AS_HPOSN:             STA   AS_HGR_Y                   ; Save y- and x-positions
                      STX   AS_HGR_X
                      STY   AS_HGR_X + 1
                      PHA                              ; Y-pos also on stack
                      AND   #$C0                       ; Calculate base address for y-pos
                      STA   MON_GBASL                  ; For y=abcdefgh
                      LSR                              ; Gbasl=abab0000
                      LSR
                      ORA   MON_GBASL
                      STA   MON_GBASL
                      PLA                              ; (A)      (gbash)   (gbasl)
                      STA   MON_GBASH                  ; ?-Abcdefgh  abcdefgh  abab0000
                      ASL                              ; A-bcdefgh0  abcdefgh  abab0000
                      ASL                              ; B-cdefgh00  abcdefgh  abab0000
                      ASL                              ; C-defgh000  abcdefgh  abab0000
                      ROL   MON_GBASH                  ; A-defgh000  bcdefghc  abab0000
                      ASL                              ; D-efgh0000  bcdefghc  abab0000
                      ROL   MON_GBASH                  ; B-efgh0000  cdefghcd  abab0000
                      ASL                              ; E-fgh00000  cdefghcd  abab0000
                      ROR   MON_GBASL                  ; 0-Fgh00000  cdefghcd  eabab000
                      LDA   MON_GBASH                  ; 0-Cdefghcd  cdefghcd  eabab000
                      AND   #$1F                       ; 0-000Fghcd  cdefghcd  eabab000
                      ORA   AS_HGR_PAGE                ; 0-Pppfghcd  cdefghcd  eabab000
                      STA   MON_GBASH                  ; 0-Pppfghcd  pppfghcd  eabab000
                      TXA                              ; Divide x-pos by 7 for index from base
                      CPY   #0                         ; Is x-pos < 256?
                      BEQ   AS_L_HPOSN_2               ; Yes
                      LDY   #35                        ; No: 256/7 = 36 rem 4
                                                       ; Carry=1, so adc #4 is too large;
                                                       ; However, adc #4 clears carry
                                                       ; Which makes sbc #7 only -6
                                                       ; Balancing it out.
                      ADC   #4                         ; Following iny makes y=36
AS_L_HPOSN_1:         INY
AS_L_HPOSN_2:         SBC   #7
                      BCS   AS_L_HPOSN_1
                      STY   AS_HGR_HORIZ               ; Horizontal index
                      TAX                              ; Use remainder-7 to look up the
                      LDA   AS_MSKTBL - $100 + 7,X     ; Bit mask
                      STA   MON_HMASK
                      TYA                              ; Quotient gives byte index
                      LSR                              ; Odd or even column?
                      LDA   AS_HGR_COLOR               ; If on odd byte (carry set)
                      STA   AS_HGR_BITS                ; Then rotate bits
                      BCS   AS_COLOR_SHIFT             ; Odd column
                      RTS                              ; Even column
                                                       ; --------------------------------
                                                       ; Plot a dot

                                                       ; (Y,x) = horizontal position
                                                       ; (A)   = vertical position
                                                       ; --------------------------------
AS_HPLOT0:            JSR   AS_HPOSN
                      LDA   AS_HGR_BITS                ; Calculate bit posn in gbas,
                      EOR   (MON_GBASL),Y              ; Hgr.horiz, and hmask from
                      AND   MON_HMASK                  ; Y-coor in a-reg,
                      EOR   (MON_GBASL),Y              ; X-coor in x,y regs.
                      STA   (MON_GBASL),Y              ; For any 1-bits, substitute
                      RTS                              ; Corresponding bit of hgr.bits
                                                       ; --------------------------------
                                                       ; Move left or right one pixel

                                                       ; If status is +, move right; if -, move left
                                                       ; If already at left or right edge, wrap around

                                                       ; Remember bits in hi-res byte are backwards order:
                                                       ; Byte n   byte n+1
                                                       ; S7654321   sedcba98
                                                       ; --------------------------------
AS_MOVE_LEFT_OR_RIGHT:
                      BPL   AS_MOVE_RIGHT              ; + Move right, - move left
                      LDA   MON_HMASK                  ; Move left one pixel
                      LSR                              ; Shift mask right, moves dot left
                      BCS   AS_LR_2                    ; ...Dot moved to next byte
                      EOR   #$C0                       ; Move sign bit back where it was
AS_LR_1:              STA   MON_HMASK                  ; New mask value
                      RTS
AS_LR_2:              DEY                              ; Moved to next byte, so decr index
                      BPL   AS_LR_3                    ; Still not past edge
                      LDY   #39                        ; Off left edge, so wrap around screen
AS_LR_3:              LDA   #$C0                       ; New hmask, rightmost bit on screen
AS_LR_4:              STA   MON_HMASK                  ; New mask and index
                      STY   AS_HGR_HORIZ
                      LDA   AS_HGR_BITS                ; Also need to rotate color
                                                       ; --------------------------------
AS_COLOR_SHIFT:
                      ASL                              ; Rotate low-order 7 bits
                      CMP   #$C0                       ; Of hgr.bits one bit posn.
                      BPL   AS_L_COLOR_SHIFT_1
                      LDA   AS_HGR_BITS
                      EOR   #$7F
                      STA   AS_HGR_BITS
AS_L_COLOR_SHIFT_1:   RTS
                                                       ; --------------------------------
                                                       ; Move right one pixel
                                                       ; If already at right edge, wrap around
                                                       ; --------------------------------
AS_MOVE_RIGHT:
                      LDA   MON_HMASK
                      ASL                              ; Shifting byte left moves pixel right
                      EOR   #$80
                                                       ; Original:  c0 a0 90 88 84 82 81
                                                       ; Shifted:   80 40 20 10 08 02 01
                                                       ; Eor #$80:  00 c0 a0 90 88 84 82
                      BMI   AS_LR_1                    ; Finished
                      LDA   #$81                       ; New mask value
                      INY                              ; Move to next byte right
                      CPY   #40                        ; Unless that is too far
                      BCC   AS_LR_4                    ; Not too far
                      LDY   #0                         ; Too far, so wrap around
                      BCS   AS_LR_4                    ; ...Always
                                                       ; --------------------------------
                                                       ; --------------------------------
                                                       ; "Xdraw" one bit
                                                       ; --------------------------------
AS_LRUDX1:            CLC                              ; C=0 means no 90 degree rotation
AS_LRUDX2:            LDA   AS_HGR_DX + 1              ; C=1 means rotate 90 degrees
                      AND   #4                         ; If bit2=0 then don't plot
                      BEQ   AS_LRUD4                   ; Yes, do not plot
                      LDA   #$7F                       ; No, look at what is already there
                      AND   MON_HMASK
                      AND   (MON_GBASL),Y              ; Screen bit = 1?
                      BNE   AS_LRUD3                   ; Yes, go clear it
                      INC   AS_HGR_COLLISIONS          ; No, count the collision
                      LDA   #$7F                       ; And turn the bit on
                      AND   MON_HMASK
                      BPL   AS_LRUD3                   ; ...Always
                                                       ; --------------------------------
                                                       ; "Draw" one bit
                                                       ; --------------------------------
AS_LRUD1:             CLC                              ; C=0 means no 90 degree rotation
AS_LRUD2:             LDA   AS_HGR_DX + 1              ; C=1 means rotate
                      AND   #4                         ; If bit2=0 then do not plot
                      BEQ   AS_LRUD4                   ; Do not plot
                      LDA   (MON_GBASL),Y
                      EOR   AS_HGR_BITS                ; 1'S where any bits not in color
                      AND   MON_HMASK                  ; Look at just this bit position
                      BNE   AS_LRUD3                   ; The bit was zero, so plot it
                      INC   AS_HGR_COLLISIONS          ; Bit is already 1; count collsn
                                                       ; --------------------------------
                                                       ; Toggle bit on screen with (a)
                                                       ; --------------------------------
AS_LRUD3:             EOR   (MON_GBASL),Y
                      STA   (MON_GBASL),Y
                                                       ; --------------------------------
                                                       ; Determine where next point will be, and move there
                                                       ; C=0 if no 90 degree rotation
                                                       ; C=1 rotates 90 degrees
                                                       ; --------------------------------
AS_LRUD4:             LDA   AS_HGR_DX + 1              ; Calculate the direction to move
                      ADC   AS_HGR_QUADRANT
                      AND   #3                         ; Wrap around the circle
AS_CON_03             =     * - 1                      ; (( A constant ))

                                                       ; 00 -- Up
                                                       ; 01 -- Down
                                                       ; 10 -- Right
                                                       ; 11 -- Left

                      CMP   #2                         ; C=0 if 0 or 1, c=1 if 2 or 3
                      ROR                              ; Put c into sign, odd/even into c
                      BCS   AS_MOVE_LEFT_OR_RIGHT
                                                       ; --------------------------------
AS_MOVE_UP_OR_DOWN:
                      BMI   AS_MOVE_DOWN               ; Sign for up/down select_
                                                       ; --------------------------------
                                                       ; Move up one pixel
                                                       ; If already at top, go to bottom

                                                       ; Remember:  y-coord   gbash     gbasl
                                                       ; Abcdefgh  pppfghcd  eabab000
                                                       ; --------------------------------
                      CLC                              ; Move up
                      LDA   MON_GBASH                  ; Calc. base address of prev. line
                      BIT   AS_CON_1C                  ; Look at bits 000fgh00 in gbash
                      BNE   AS_L_MOVE_UP_OR_DOWN_5     ; Simple, just fgh=fgh-1
                                                       ; Gbash=ppp000cd, gbasl=eabab000
                      ASL   MON_GBASL                  ; What is "e"?
                      BCS   AS_L_MOVE_UP_OR_DOWN_3     ; E=1, then efgh=efgh-1
                      BIT   AS_CON_03                  ; Look at 000000cd in gbash
                      BEQ   AS_L_MOVE_UP_OR_DOWN_1     ; Y-pos is ab000000 form
                      ADC   #$1F                       ; Cd <> 0, so cdefgh=cdefgh-1
                      SEC
                      BCS   AS_L_MOVE_UP_OR_DOWN_4     ; ...Always
AS_L_MOVE_UP_OR_DOWN_1: ADC   #$23                       ; Enough to make gbash=ppp11111 later
                      PHA                              ; Save for later
                      LDA   MON_GBASL                  ; Gbasl is now abab0000 (ab=00,01,10)
                      ADC   #$B0                       ; 0000+1011=1011 And carry clear
                                                       ; Or 0101+1011=0000 and carry set
                                                       ; Or 1010+1011=0101 and carry set
                      BCS   AS_L_MOVE_UP_OR_DOWN_2     ; No wrap-around needed
                      ADC   #$F0                       ; Change 1011 to 1010 (wrap-around)
AS_L_MOVE_UP_OR_DOWN_2: STA   MON_GBASL                  ; Form is now still abab0000
                      PLA                              ; Partially modified gbash
                      BCS   AS_L_MOVE_UP_OR_DOWN_4     ; ...Always
AS_L_MOVE_UP_OR_DOWN_3: ADC   #$1F
AS_L_MOVE_UP_OR_DOWN_4: ROR   MON_GBASL                  ; Shift in e, to get eabab000 form
AS_L_MOVE_UP_OR_DOWN_5: ADC   #$FC                       ; Finish gbash mods
AS_UD_1:              STA   MON_GBASH
                      RTS
                                                       ; --------------------------------
                      CLC                              ; <<<Never used>>>
                                                       ; --------------------------------
                                                       ; Move down one pixel
                                                       ; If already at bottom, go to top

                                                       ; Remember:  y-coord   gbash     gbasl
                                                       ; Abcdefgh  pppfghcd  eabab000
                                                       ; --------------------------------
AS_MOVE_DOWN:
                      LDA   MON_GBASH                  ; Try it first, by fgh=fgh+1
                      ADC   #4                         ; Gbash = pppfghcd
AS_CON_04             =     * - 1                      ; (( Constant ))
                      BIT   AS_CON_1C                  ; Is fgh field now zero?
                      BNE   AS_UD_1                    ; No, so we are finished
                                                       ; Yes, ripple the carry as high
                                                       ; As necessary
                      ASL   MON_GBASL                  ; Look at "e" bit
                      BCC   AS_L_CON_04_2              ; Now zero; make it 1 and leave
                      ADC   #$E0                       ; Carry = 1, so adds $E1
                      CLC                              ; Is "cd" not zero?
                      BIT   AS_CON_04                  ; Tests bit 2 for carry out of "cd"
                      BEQ   AS_L_CON_04_3              ; No carry, finished
                                                       ; Increment "ab" then
                                                       ; 0000 --> 0101
                                                       ; 0101 --> 1010
                                                       ; 1010 --> Wrap around to line 0
                      LDA   MON_GBASL                  ; 0000  0101  1010
                      ADC   #$50                       ; 0101  1010  1111
                      EOR   #$F0                       ; 1010  0101  0000
                      BEQ   AS_L_CON_04_1
                      EOR   #$F0                       ; 0101  1010
AS_L_CON_04_1:        STA   MON_GBASL                  ; New abab0000
                      LDA   AS_HGR_PAGE                ; Wrap around to line zero of group
                      BCC   AS_L_CON_04_3              ; ...Always
AS_L_CON_04_2:        ADC   #$E0
AS_L_CON_04_3:        ROR   MON_GBASL
                      BCC   AS_UD_1                    ; ...Always
                                                       ; --------------------------------
                                                       ; Hlinrl is never called by applesoft

                                                       ; Enter with:  (a,x) = dx from current point
                                                       ; (Y)   = dy from current point
                                                       ; --------------------------------
AS_HLINRL:            PHA                              ; Save (a)
                      LDA   #0                         ; Clear current point so hglin will
                      STA   AS_HGR_X                   ; Act relatively
                      STA   AS_HGR_X + 1
                      STA   AS_HGR_Y
                      PLA                              ; Restore (a)
                                                       ; --------------------------------
                                                       ; Draw line from last plotted point to (a,x),(y)

                                                       ; Enter with:  (a,x) = x of target point
                                                       ; (Y)   = y of target point
                                                       ; --------------------------------
AS_HGLIN:             PHA                              ; Compute dx = x- x0
                      SEC
                      SBC   AS_HGR_X
                      PHA
                      TXA
                      SBC   AS_HGR_X + 1
                      STA   AS_HGR_QUADRANT            ; Save dx sign (+ = right, - = left)
                      BCS   AS_L_HGLIN_1               ; Now find abs (dx)
                      PLA                              ; Forms 2's complement
                      EOR   #$FF
                      ADC   #1
                      PHA
                      LDA   #0
                      SBC   AS_HGR_QUADRANT
AS_L_HGLIN_1:         STA   AS_HGR_DX + 1
                      STA   AS_HGR_E + 1               ; Init hgr.e to abs(x-x0)
                      PLA
                      STA   AS_HGR_DX
                      STA   AS_HGR_E
                      PLA
                      STA   AS_HGR_X                   ; Target x point
                      STX   AS_HGR_X + 1
                      TYA                              ; Target y point
                      CLC                              ; Compute dy = y-hgr.y
                      SBC   AS_HGR_Y                   ; And save -abs(y-hgr.y)-1 in hgr.dy
                      BCC   AS_L_HGLIN_2               ; (So + means up, - means down)
                      EOR   #$FF                       ; 2'S complement of dy
                      ADC   #$FE
AS_L_HGLIN_2:         STA   AS_HGR_DY
                      STY   AS_HGR_Y                   ; Target y point
                      ROR   AS_HGR_QUADRANT            ; Shift y-direction into quadrant
                      SEC                              ; Count = dx -(-dy) = # of dots needed
                      SBC   AS_HGR_DX
                      TAX                              ; Countl is in x-reg
                      LDA   #$FF
                      SBC   AS_HGR_DX + 1
                      STA   AS_HGR_COUNT
                      LDY   AS_HGR_HORIZ               ; Horizontal index
                      BCS   AS_MOVEX2                  ; ...Always
                                                       ; --------------------------------
                                                       ; Move left or right one pixel
                                                       ; (A) bit 6 has direction
                                                       ; --------------------------------
AS_MOVEX:             ASL                              ; Put bit 6 into sign position
                      JSR   AS_MOVE_LEFT_OR_RIGHT
                      SEC
                                                       ; --------------------------------
                                                       ; Draw line now
                                                       ; --------------------------------
AS_MOVEX2:            LDA   AS_HGR_E                   ; Carry is set
                      ADC   AS_HGR_DY                  ; E = e-delty
                      STA   AS_HGR_E                   ; Note: dy is (-delta y)-1
                      LDA   AS_HGR_E + 1               ; Carry clr if hgr.e goes negative
                      SBC   #0
AS_L_MOVEX2_1:        STA   AS_HGR_E + 1
                      LDA   (MON_GBASL),Y
                      EOR   AS_HGR_BITS                ; Plot a dot
                      AND   MON_HMASK
                      EOR   (MON_GBASL),Y
                      STA   (MON_GBASL),Y
                      INX                              ; Finished all the dots?
                      BNE   AS_L_MOVEX2_2              ; No
                      INC   AS_HGR_COUNT               ; Test rest of count
                      BEQ   AS_RTS_22                  ; Yes, finished.
AS_L_MOVEX2_2:        LDA   AS_HGR_QUADRANT            ; Test direction
                      BCS   AS_MOVEX                   ; Next move is in the x direction
                      JSR   AS_MOVE_UP_OR_DOWN         ; If clr, neg, move
                      CLC                              ; E = e+dx
                      LDA   AS_HGR_E
                      ADC   AS_HGR_DX
                      STA   AS_HGR_E
                      LDA   AS_HGR_E + 1
                      ADC   AS_HGR_DX + 1
                      BVC   AS_L_MOVEX2_1              ; ...Always
                                                       ; --------------------------------

AS_MSKTBL:            .byte %10000001
                      .byte %10000010
                      .byte %10000100
                      .byte %10001000
                      .byte %10010000
                      .byte %10100000
                      .byte %11000000
                                                       ; --------------------------------
AS_CON_1C:            .byte %00011100                  ; Mask for "fgh" bits
                                                       ; --------------------------------

                                                       ; --------------------------------
                                                       ; Table of cos(90*x/16 degrees)*$100 - 1
                                                       ; With one byte precision, x=0 to 16:
                                                       ; --------------------------------
AS_COSINE_TABLE:      .byte $FF, $FE, $FA, $F4, $EC, $E1, $D4, $C5
                      .byte $B4, $A1, $8D, $78, $61, $49, $31, $18
                      .byte $FF
                                                       ; --------------------------------
                                                       ; Hfind -- calculates current position of hi-res cursor
                                                       ; (Not called by any applesoft routine)

                                                       ; Calculate y-coord from gbasl,h
                                                       ; And x-coord from horiz and hmask
                                                       ; --------------------------------
AS_HFIND:             LDA   MON_GBASL                  ; Gbasl = eabab000
                      ASL                              ; E into carry
                      LDA   MON_GBASH                  ; Gbash = pppfghcd
                      AND   #3                         ; 000000Cd
                      ROL                              ; 00000Cde
                      ORA   MON_GBASL                  ; Eababcde
                      ASL                              ; Ababcde0
                      ASL                              ; Babcde00
                      ASL                              ; Abcde000
                      STA   AS_HGR_Y                   ; All but fgh
                      LDA   MON_GBASH                  ; Pppfghcd
                      LSR                              ; 0Pppfghc
                      LSR                              ; 00Pppfgh
                      AND   #7                         ; 00000Fgh
                      ORA   AS_HGR_Y                   ; Abcdefgh
                      STA   AS_HGR_Y                   ; That takes care of y-coordinate!
                      LDA   AS_HGR_HORIZ               ; X = 7*horiz + bit pos. in hmask
                      ASL                              ; Multiply by 7
                      ADC   AS_HGR_HORIZ               ; 3* So far
                      ASL                              ; 6*
                      TAX                              ; Since 7* might not fit in 1 byte,
                                                       ; Wait till later for last add
                      DEX
                      LDA   MON_HMASK                  ; Now find bit position in hmask
                      AND   #$7F                       ; Only look at low seven
AS_L_HFIND_1:         INX                              ; Count a shift
                      LSR
                      BNE   AS_L_HFIND_1               ; Still in there
                      STA   AS_HGR_X + 1               ; Zero to hi-byte
                      TXA                              ; 6*Horiz+log2(hmask)
                      CLC                              ; Add horiz one more time
                      ADC   AS_HGR_HORIZ               ; 7*Horiz+log2(hmask)
                      BCC   AS_L_HFIND_2               ; Upper byte = 0
                      INC   AS_HGR_X + 1               ; Upper byte = 1
AS_L_HFIND_2:         STA   AS_HGR_X                   ; Store lower byte
AS_RTS_22:            RTS
                                                       ; --------------------------------
                                                       ; Draw a shape

                                                       ; (Y,x) = shape starting address
                                                       ; (A)   = rotation (0-3f)
                                                       ; --------------------------------
                                                       ; Applesoft does not call draw0
                                                       ; --------------------------------
AS_DRAW0:             STX   AS_HGR_SHAPE               ; Save shape address
                      STY   AS_HGR_SHAPE + 1
                                                       ; --------------------------------
                                                       ; Applesoft enters here
                                                       ; --------------------------------
AS_DRAW1:             TAX                              ; Save rotation (0-$3F)
                      LSR                              ; Divide rotation by 16 to get
                      LSR                              ; Quadrant (0=up, 1=rt, 2=dwn, 3=lft)
                      LSR
                      LSR
                      STA   AS_HGR_QUADRANT
                      TXA                              ; Use low 4 bits of rotation to index
                      AND   #$0F                       ; The trig table
                      TAX
                      LDY   AS_COSINE_TABLE,X          ; Save cosine in hgr.dx
                      STY   AS_HGR_DX
                      EOR   #$F                        ; And sine in dy
                      TAX
                      LDY   AS_COSINE_TABLE + 1,X
                      INY
                      STY   AS_HGR_DY
                      LDY   AS_HGR_HORIZ               ; Index from gbasl,h to byte we're in
                      LDX   #0
                      STX   AS_HGR_COLLISIONS          ; Clear collision counter
                      LDA   (AS_HGR_SHAPE,X)           ; Get first byte of shape defn
AS_L_DRAW1_1:         STA   AS_HGR_DX + 1              ; Keep shape byte in hgr.dx+1
                      LDX   #$80                       ; Initial values for fractional vectors
                      STX   AS_HGR_E                   ; L_draw1_5 in cosine component
                      STX   AS_HGR_E + 1               ; L_draw1_5 in sine component
                      LDX   AS_HGR_SCALE               ; Scale factor
AS_L_DRAW1_2:         LDA   AS_HGR_E                   ; Add cosine value to x-value
                      SEC                              ; If >= 1, then draw
                      ADC   AS_HGR_DX
                      STA   AS_HGR_E                   ; Only save fractional part
                      BCC   AS_L_DRAW1_3               ; No integral part
                      JSR   AS_LRUD1                   ; Time to plot cosine component
                      CLC
AS_L_DRAW1_3:         LDA   AS_HGR_E + 1               ; Add sine value to y-value
                      ADC   AS_HGR_DY                  ; If >= 1, then draw
                      STA   AS_HGR_E + 1               ; Only save fractional part
                      BCC   AS_L_DRAW1_4               ; No integral part
                      JSR   AS_LRUD2                   ; Time to plot sine component
AS_L_DRAW1_4:         DEX                              ; Loop on scale factor.
                      BNE   AS_L_DRAW1_2               ; Still on same shape item
                      LDA   AS_HGR_DX + 1              ; Get next shape item
                      LSR                              ; Next 3 bit vector
                      LSR
                      LSR
                      BNE   AS_L_DRAW1_1               ; More in this shape byte
                      INC   AS_HGR_SHAPE               ; Go to next shape byte
                      BNE   AS_L_DRAW1_5
                      INC   AS_HGR_SHAPE + 1
AS_L_DRAW1_5:         LDA   (AS_HGR_SHAPE,X)           ; Next byte of shape definition
                      BNE   AS_L_DRAW1_1               ; Process if not zero
                      RTS                              ; Finished
                                                       ; --------------------------------
                                                       ; Xdraw a shape (same as draw, except toggles screen)

                                                       ; (Y,x) = shape starting address
                                                       ; (A)   = rotation (0-3f)
                                                       ; --------------------------------
                                                       ; Applesoft does not call xdraw0
                                                       ; --------------------------------
AS_XDRAW0:            STX   AS_HGR_SHAPE               ; Save shape address
                      STY   AS_HGR_SHAPE + 1
                                                       ; --------------------------------
                                                       ; Applesoft enters here
                                                       ; --------------------------------
AS_XDRAW1:            TAX                              ; Save rotation (0-$3F)
                      LSR                              ; Divide rotation by 16 to get
                      LSR                              ; Quadrant (0=up, 1=rt, 2=dwn, 3=lft)
                      LSR
                      LSR
                      STA   AS_HGR_QUADRANT
                      TXA                              ; Use low 4 bits of rotation to index
                      AND   #$0F                       ; The trig table
                      TAX
                      LDY   AS_COSINE_TABLE,X          ; Save cosine in hgr.dx
                      STY   AS_HGR_DX
                      EOR   #$F                        ; And sine in dy
                      TAX
                      LDY   AS_COSINE_TABLE + 1,X
                      INY
                      STY   AS_HGR_DY
                      LDY   AS_HGR_HORIZ               ; Index from gbasl,h to byte we're in
                      LDX   #0
                      STX   AS_HGR_COLLISIONS          ; Clear collision counter
                      LDA   (AS_HGR_SHAPE,X)           ; Get first byte of shape defn
AS_L_XDRAW1_1:        STA   AS_HGR_DX + 1              ; Keep shape byte in hgr.dx+1
                      LDX   #$80                       ; Initial values for fractional vectors
                      STX   AS_HGR_E                   ; L_xdraw1_5 in cosine component
                      STX   AS_HGR_E + 1               ; L_xdraw1_5 in sine component
                      LDX   AS_HGR_SCALE               ; Scale factor
AS_L_XDRAW1_2:        LDA   AS_HGR_E                   ; Add cosine value to x-value
                      SEC                              ; If >= 1, then draw
                      ADC   AS_HGR_DX
                      STA   AS_HGR_E                   ; Only save fractional part
                      BCC   AS_L_XDRAW1_3              ; No integral part
                      JSR   AS_LRUDX1                  ; Time to plot cosine component
                      CLC
AS_L_XDRAW1_3:        LDA   AS_HGR_E + 1               ; Add sine value to y-value
                      ADC   AS_HGR_DY                  ; If >= 1, then draw
                      STA   AS_HGR_E + 1               ; Only save fractional part
                      BCC   AS_L_XDRAW1_4              ; No integral part
                      JSR   AS_LRUDX2                  ; Time to plot sine component
AS_L_XDRAW1_4:        DEX                              ; Loop on scale factor.
                      BNE   AS_L_XDRAW1_2              ; Still on same shape item
                      LDA   AS_HGR_DX + 1              ; Get next shape item
                      LSR                              ; Next 3 bit vector
                      LSR
                      LSR
                      BNE   AS_L_XDRAW1_1              ; More in this shape byte
                      INC   AS_HGR_SHAPE               ; Go to next shape byte
                      BNE   AS_L_XDRAW1_5
                      INC   AS_HGR_SHAPE + 1
AS_L_XDRAW1_5:        LDA   (AS_HGR_SHAPE,X)           ; Next byte of shape definition
                      BNE   AS_L_XDRAW1_1              ; Process if not zero
                      RTS                              ; Finished
                                                       ; --------------------------------
                                                       ; Get hi-res plotting coordinates (0-279,0-191) from
                                                       ; Txtptr.  leave registers set up for hposn:
                                                       ; (Y,x)=x-coord
                                                       ; (A)  =y-coord
                                                       ; --------------------------------
AS_HFNS:              JSR   AS_FRMNUM                  ; Evaluate expression, must be numeric
                      JSR   AS_GETADR                  ; Convert to 2-byte integer in linnum
                      LDY   MS_Z_0050_LINNUM + 1              ; Get horiz coor in x,y
                      LDX   MS_Z_0050_LINNUM
                      CPY   #>280                      ; Make sure it is < 280
                      BCC   AS_L_HFNS_1                ; In range
                      BNE   AS_GGERR
                      CPX   #<280
                      BCS   AS_GGERR
AS_L_HFNS_1:          TXA                              ; Save horiz coor on stack
                      PHA
                      TYA
                      PHA
                      LDA   #"," & %01111111           ; Require a comma
                      JSR   AS_SYNCHR
                      JSR   AS_GETBYT                  ; Eval exp to single byte in x-reg
                      CPX   #192                       ; Check for range
                      BCS   AS_GGERR                   ; Too big
                      STX   MS_Z_009D_FAC                     ; Save y-coord
                      PLA                              ; Retrieve horizontal coordinate
                      TAY
                      PLA
                      TAX
                      LDA   MS_Z_009D_FAC                     ; And vertical coordinate
                      RTS
                                                       ; --------------------------------
AS_GGERR:             JMP   AS_GOERR                   ; Illegal quantity error
                                                       ; --------------------------------
                                                       ; "Hcolor=" statement
                                                       ; --------------------------------
AS_HCOLOR:            JSR   AS_GETBYT                  ; Eval exp to single byte in x
                      CPX   #8                         ; Value must be 0-7
                      BCS   AS_GGERR                   ; Too big
                      LDA   AS_COLORTBL,X              ; Get color pattern
                      STA   AS_HGR_COLOR
AS_RTS_23:            RTS
                                                       ; --------------------------------

AS_COLORTBL:          .byte %00000000
                      .byte %00101010
                      .byte %01010101
                      .byte %01111111
                      .byte %00000000 | %10000000
                      .byte %00101010 | %10000000
                      .byte %01010101 | %10000000
                      .byte %01111111 | %10000000

                                                       ; --------------------------------
                                                       ; "Hplot" statement

                                                       ; Hplot x,y
                                                       ; Hplot to x,y
                                                       ; Hplot x1,y1 to x2,y2
                                                       ; --------------------------------
AS_HPLOT:             CMP   #MS_T_TOTK               ; "Plot to" form?
                      BEQ   AS_L_HPLOT_2               ; Yes, start from current location
                      JSR   AS_HFNS                    ; No, get starting point of line
                      JSR   AS_HPLOT0                  ; Plot the point, and set up for
                                                       ; Drawing a line from that point
AS_L_HPLOT_1:         JSR   MS_Z_00B7_CHRGOT                  ; Character at end of expression
                      CMP   #MS_T_TOTK               ; Is a line specified?
                      BNE   AS_RTS_23                  ; No, exit
AS_L_HPLOT_2:         JSR   AS_SYNCHR                  ; Yes. adv. txtptr (why not chrget)
                      JSR   AS_HFNS                    ; Get coordinates of line end
                      STY   MS_Z_009D_DSCTMP                  ; Set up for line
                      TAY
                      TXA
                      LDX   MS_Z_009D_DSCTMP
                      JSR   AS_HGLIN                   ; Plot line
                      JMP   AS_L_HPLOT_1               ; Loop till no more "to" phrases
                                                       ; --------------------------------
                                                       ; "Rot=" statement
                                                       ; --------------------------------
AS_ROT:               JSR   AS_GETBYT                  ; Eval exp to a byte in x-reg
                      STX   AS_HGR_ROTATION
                      RTS
                                                       ; --------------------------------
                                                       ; "Scale=" statement
                                                       ; --------------------------------
AS_SCALE:             JSR   AS_GETBYT                  ; Eval exp to a byte in x-reg
                      STX   AS_HGR_SCALE
                      RTS
                                                       ; --------------------------------
                                                       ; Set up for draw and xdraw
                                                       ; --------------------------------
AS_DRWPNT:            JSR   AS_GETBYT                  ; Get shape number in x-reg
                      LDA   AS_HGR_SHAPE_PNTR          ; Search for that shape
                      STA   AS_HGR_SHAPE               ; Set up pntr to beginning of table
                      LDA   AS_HGR_SHAPE_PNTR + 1
                      STA   AS_HGR_SHAPE + 1
                      TXA
                      LDX   #0
                      CMP   (AS_HGR_SHAPE,X)           ; Compare to # of shapes in table
                      BEQ   AS_L_DRWPNT_1              ; Last shape in table
                      BCS   AS_GGERR                   ; Shape # too large
AS_L_DRWPNT_1:        ASL                              ; Double shape# to make an index
                      BCC   AS_L_DRWPNT_2              ; Add 256 if shape # > 127
                      INC   AS_HGR_SHAPE + 1
                      CLC
AS_L_DRWPNT_2:        TAY                              ; Use index to look up offset for shape
                      LDA   (AS_HGR_SHAPE),Y           ; In offset table
                      ADC   AS_HGR_SHAPE
                      TAX
                      INY
                      LDA   (AS_HGR_SHAPE),Y
                      ADC   AS_HGR_SHAPE_PNTR + 1
                      STA   AS_HGR_SHAPE + 1           ; Save address of shape
                      STX   AS_HGR_SHAPE
                      JSR   MS_Z_00B7_CHRGOT                  ; Is there any "at" phrase?
                      CMP   #AS_TOKENDB
                      BNE   AS_L_DRWPNT_3              ; No, draw right where we are
                      JSR   AS_SYNCHR                  ; Scan over "at"
                      JSR   AS_HFNS                    ; Get x- and y-coords to start drawing at
                      JSR   AS_HPOSN                   ; Set up cursor there
AS_L_DRWPNT_3:        LDA   AS_HGR_ROTATION            ; Rotation value
                      RTS
                                                       ; --------------------------------
                                                       ; "Draw" statement
                                                       ; --------------------------------
AS_DRAW:              JSR   AS_DRWPNT
                      JMP   AS_DRAW1
                                                       ; --------------------------------
                                                       ; "Xdraw" statement
                                                       ; --------------------------------
AS_XDRAW:             JSR   AS_DRWPNT
                      JMP   AS_XDRAW1
                                                       ; --------------------------------
                                                       ; "Shload" statement

                                                       ; Reads a shape table from cassette tape
                                                       ; To a position just below himem.
                                                       ; Himem is then moved to just below the table
                                                       ; --------------------------------
AS_SHLOAD:            LDA   #>MS_Z_0050_LINNUM                ; Set up to read two bytes
                      STA   MON_A1H                    ; Into linnum,linnum+1
                      STA   MON_A2H
                      LDY   #MS_Z_0050_LINNUM
                      STY   MON_A1L
                      INY                              ; Linnum+1
                      STY   MON_A2L
                      JSR   MS_CQCSIN                   ; Read tape
                      CLC                              ; Setup to read (linnum) bytes
                      LDA   MS_Z_0073_MEMSIZ                  ; Ending at himem-1
                      TAX
                      DEX                              ; Forming himem-1
                      STX   MON_A2L
                      SBC   MS_Z_0050_LINNUM                  ; Forming himem-(linnum)
                      PHA
                      LDA   MS_Z_0073_MEMSIZ + 1
                      TAY
                      INX                              ; See if himem low-byte was zero
                      BNE   AS_L_SHLOAD_1              ; No
                      DEY                              ; Yes, have to decrement high byte
AS_L_SHLOAD_1:        STY   MON_A2H
                      SBC   MS_Z_0050_LINNUM + 1
                      CMP   MS_Z_006D_STREND + 1              ; Running into variables?
                      BCC   AS_L_SHLOAD_2              ; Yes, out of memory
                      BNE   AS_L_SHLOAD_3              ; No, still room
AS_L_SHLOAD_2:        JMP   AS_MEMERR                  ; Mem full err
AS_L_SHLOAD_3:        STA   MS_Z_0073_MEMSIZ + 1
                      STA   MS_Z_006F_FRETOP + 1              ; Clear string space
                      STA   MON_A1H                    ; (But names are still in vartbl!)
                      STA   AS_HGR_SHAPE_PNTR + 1
                      PLA
                      STA   AS_HGR_SHAPE_PNTR
                      STA   MS_Z_0073_MEMSIZ
                      STA   MS_Z_006F_FRETOP
                      STA   MON_A1L
                      JSR   MON_RD2BIT                 ; Read to tape transitions
                      LDA   #3                         ; Short delay for intermediate header
                      JMP   MON_READ2                  ; Read shapes
                                                       ; --------------------------------
                                                       ; Called from store and recall
                                                       ; --------------------------------
AS_TAPEPNT:
                      CLC
                      LDA   MS_Z_009B_LOWTR
                      ADC   MS_Z_0050_LINNUM
                      STA   MON_A2L
                      LDA   MS_Z_009B_LOWTR + 1
                      ADC   MS_Z_0050_LINNUM + 1
                      STA   MON_A2H
                      LDY   #4
                      LDA   (MS_Z_009B_LOWTR),Y
                      JSR   AS_GETARY2
                      LDA   MS_Z_0094_HIGHDS
                      STA   MON_A1L
                      LDA   MS_Z_0094_HIGHDS + 1
                      STA   MON_A1H
                      RTS
                                                       ; --------------------------------
                                                       ; Called from store and recall
                                                       ; --------------------------------
AS_GETARYPT:
                      LDA   #$40
                      STA   MS_Z_0014_SUBFLG
                      JSR   AS_PTRGET
                      LDA   #0
                      STA   MS_Z_0014_SUBFLG
                      JMP   AS_VARTIO
                                                       ; --------------------------------
                                                       ; "Htab" statement

                                                       ; Note that if wndleft is not 0, htab can print
                                                       ; Outside the screen (eg., in the program)
                                                       ; --------------------------------
AS_HTAB:              JSR   AS_GETBYT
                      DEX
                      TXA
AS_L_HTAB_1:          CMP   #40
                      BCC   AS_L_HTAB_2
                      SBC   #40
                      PHA
                      JSR   AS_CRDO
                      PLA
                      JMP   AS_L_HTAB_1
AS_L_HTAB_2:          STA   MON_CH
                      RTS
                                                       ; --------------------------------
                      .byte "K" | %10000000
                      .byte "R" | %10000000
                      .byte "W" | %10000000
                                                       ; Unknown
; Source assembly code for the Apple ][ System Monitor

MON_LORESHEIGHT       =     24 * 2

;-----------------------------------------------------------------------

; Lo-res graphics

; Some low-resolution-graphics routines.

;-----------------------------------------------------------------------

MON_PLOT:             LSR                              ;Y-coord/2
                      PHP                              ;Save lsb in carry
                      JSR   MON_GBASCALC               ;Calc base adr in gbasl,h
                      PLP                              ;Restore lsb from carry
                      LDA   #%00001111                 ;Mask $0F if even
                      BCC   MON_RTMASK
                      ADC   #%11100000                 ;Mask $F0 if odd
MON_RTMASK:           STA   MON_MASK
MON_PLOT1:            LDA   (MON_GBASL),Y              ;Data
                      EOR   MON_COLOR                  ; Eor color
                      AND   MON_MASK                   ;  And mask
                      EOR   (MON_GBASL),Y              ;   Eor data
                      STA   (MON_GBASL),Y              ;    To data
                      RTS

MON_HLINE:            JSR   MON_PLOT                   ;Plot square
MON_HLINE1:           CPY   MON_H2                     ;Done?
                      BCS   MON_RTS1                   ; Yes, return
                      INY                              ; No, inc index (x-coord)
                      JSR   MON_PLOT1                  ;Plot next square
                      BCC   MON_HLINE1                 ;Always taken
MON_VLINEZ:           ADC   #1                         ;Next y-coord
MON_VLINE:            PHA                              ; Save on stack
                      JSR   MON_PLOT                   ; Plot square
                      PLA
                      CMP   MON_V2                     ;Done?
                      BCC   MON_VLINEZ                 ; No, loop
MON_RTS1:             RTS

MON_CLRSCR:           LDY   #MON_LORESHEIGHT - 1       ;Max y, full scrn clr
                      BNE   MON_CLRSC2                 ;Always taken
MON_CLRTOP:           LDY   #40 - 1                    ;Max y, top screen clr
MON_CLRSC2:           STY   MON_V2                     ;Store as bottom coord
                                                       ; For vline calls
                      LDY   #40 - 1                    ;Rightmost x-coord (column)
MON_CLRSC3:           LDA   #0                         ;Top coord for vline calls
                      STA   MON_COLOR                  ;Clear color (black)
                      JSR   MON_VLINE                  ;Draw vline
                      DEY                              ;Next leftmost x-coord
                      BPL   MON_CLRSC3                 ;Loop until done
                      RTS

MON_GBASCALC:         PHA                              ;For input 000defgh
                      LSR
                      AND   #%00000011
                      ORA   #%00000100                 ;  Generate gbash=000001fg
                      STA   MON_GBASH
                      PLA                              ;  And gbasl=hdede000
                      AND   #%00011000
                      BCC   MON_GBCALC
                      ADC   #$80 - 1
MON_GBCALC:           STA   MON_GBASL
                      ASL
                      ASL
                      ORA   MON_GBASL
                      STA   MON_GBASL
                      RTS

MON1_NXTCOL:          LDA   MON_COLOR                  ;Increment color by 3
                      CLC
                      ADC   #3
MON_SETCOL:           AND   #%00001111                 ;Sets color=17*a mod 16
                      STA   MON_COLOR
                      ASL                              ;Both half bytes of color equal
                      ASL
                      ASL
                      ASL
                      ORA   MON_COLOR
                      STA   MON_COLOR
                      RTS

MON_SCRN:             LSR                              ;Read screen y-coord/2
                      PHP                              ;Save lsb (carry)
                      JSR   MON_GBASCALC               ;Calc base address
                      LDA   (MON_GBASL),Y              ;Get byte
                      PLP                              ;Restore lsb from carry

MON_SCRN2:            BCC   MON_RTMSKZ                 ;If even, use lo h
                      LSR
                      LSR
                      LSR                              ;Shift high half byte down
                      LSR
MON_RTMSKZ:           AND   #%00001111                 ;Mask 4-bits
                      RTS

;-----------------------------------------------------------------------

; Disassembler

; Handles disassembling 6502 instructions.

;-----------------------------------------------------------------------

MON_INSDS1:           LDX   $3A                        ;Print pcl,h
                      LDY   $3B
                      JSR   MON_PRYX2
                      JSR   MON_PRBLNK                 ;Followed by a blank
                      LDA   ($3A,X)                    ;Get op code
MON_INSDS2:           TAY
                      LSR                              ;Even/odd test
                      BCC   MON_IEVEN
                      ROR                              ;Bit 1 test
                      BCS   MON_ERR                    ;Xxxxxx11 invalid op
                      CMP   #$A2
                      BEQ   MON_ERR                    ;Opcode $89 invalid
                      AND   #$87                       ;Mask bits
MON_IEVEN:            LSR                              ;Lsb into carry for l/r test
                      TAX
                      LDA   MON_FMT1,X                 ;Get format index byte
                      JSR   MON_SCRN2                  ;R/l h-byte on carry
                      BNE   MON_GETFMT
MON_ERR:              LDY   #$80                       ;Substitute $80 for invalid ops
                      LDA   #$00                       ;Set print format index to 0
MON_GETFMT:           TAX
                      LDA   MON_FMT2,X                 ;Index into print format table
                      STA   MON_MASK                   ;Save for adr field formatting
                      AND   #$03                       ;Mask for 2-bit (length-1)
                      STA   $2F
                      TYA                              ;Opcode
                      AND   #$8F                       ;Mask for 1xxx1010 test
                      TAX                              ; Save it
                      TYA                              ;Opcode to a again
                      LDY   #$03
                      CPX   #$8A
                      BEQ   MON_MNNDX3
MON_MNNDX1:           LSR
                      BCC   MON_MNNDX3                 ;Form index into mnemonic table
                      LSR
MON_MNNDX2:           LSR                              ;1) 1Xxx1010->00101xxx
                      ORA   #$20                       ;2) Xxxyyy01->00111xxx
                      DEY                              ;3) Xxxyyy10->00110xxx
                      BNE   MON_MNNDX2                 ;4) Xxxyy100->00100xxx
                      INY                              ;5) Xxxxx000->000xxxxx
MON_MNNDX3:           DEY
                      BNE   MON_MNNDX1
                      RTS

                      .byte $FF, $FF, $FF

MON_INSTDSP:          JSR   MON_INSDS1                 ;Gen fmt, len bytes
                      PHA                              ;Save mnemonic table index
MON_PRNTOP:           LDA   ($3A),Y
                      JSR   MON_PRBYTE
                      LDX   #1                         ;Print 2 blanks
MON_PRNTBL:           JSR   MON_PRBL2
                      CPY   $2F                        ;Print inst (1-3 bytes)
                      INY                              ;In a 12 chr field
                      BCC   MON_PRNTOP
                      LDX   #3                         ;Char count for mnemonic print
                      CPY   #4
                      BCC   MON_PRNTBL
                      PLA                              ;Recover mnemonic index
                      TAY
                      LDA   MON_MNEML,Y
                      STA   MON_H2                     ;Fetch 3-char mnemonic
                      LDA   MON_MNEMR,Y                ;  (Packed in 2-bytes)
                      STA   MON_V2
MON_NXTCOL:           LDA   #0
                      LDY   #5
MON_PRMN2:            ASL   MON_V2                     ;Shift 5 bits of
                      ROL   MON_H2                     ;  Character into a
                      ROL                              ;    (Clears carry)
                      DEY
                      BNE   MON_PRMN2
                      ADC   #"?" | %10000000           ;Add "?" offset
                      JSR   MS_OUTCH                   ;Output a char of mnem
                      DEX
                      BNE   MON_NXTCOL
                      JSR   MON_PRBLNK                 ;Output 3 blanks
                      LDY   $2F
                      LDX   #6                         ;Cnt for 6 format bits
MON_PRADR1:           CPX   #3
                      BEQ   MON_PRADR5                 ;If x=3 then addr.
MON_PRADR2:           ASL   MON_MASK
                      BCC   MON_PRADR3
                      LDA   MON_CHAR1 - 1,X
                      JSR   MS_OUTCH
                      LDA   MON_CHAR2 - 1,X
                      BEQ   MON_PRADR3
                      JSR   MS_OUTCH
MON_PRADR3:           DEX
                      BNE   MON_PRADR1
                      RTS
MON_PRADR4:           DEY
                      BMI   MON_PRADR2
                      JSR   MON_PRBYTE
MON_PRADR5:           LDA   MON_MASK
                      CMP   #$E8                       ;Handle rel adr mode
                      LDA   ($3A),Y                    ;Special (print target,
                      BCC   MON_PRADR4                 ;  Not offset)
MON_RELADR:           JSR   MON_PCADJ3
                      TAX                              ;Pcl,pch+offset+1 to a,y
                      INX
                      BNE   MON_PRNTYX                 ;+1 To y,x
                      INY

MON_PRNTYX:           TYA
MON_PRNTAX:           JSR   MON_PRBYTE                 ;Output target adr
MON_PRNTX:            TXA                              ;  Of branch and return
                      JMP   MON_PRBYTE

MON_PRBLNK:           LDX   #3                         ;Blank count
MON_PRBL2:            LDA   #" " | %10000000           ;Load a space
MON_PRBL3:            JSR   MS_OUTCH                   ;Output a blank
                      DEX
                      BNE   MON_PRBL2                  ;Loop until count=0
                      RTS

MON_PCADJ:            SEC                              ;0=1-Byte, 1=2-byte
MON_PCADJ2:           LDA   $2F                        ;  2=3-Byte
MON_PCADJ3:           LDY   $3B
                      TAX                              ;Test displacement sign
                      BPL   MON_PCADJ4                 ;  (For rel branch)
                      DEY                              ;Extend neg by dec pch
MON_PCADJ4:           ADC   $3A
                      BCC   MON_RTS2                   ;Pcl+length(or displ)+1 to a
                      INY                              ;  Carry into y (pch)
MON_RTS2:             RTS

                                                       ; * Fmt1 bytes:    xxxxxxy0 instrs
                                                       ; * If y=0         then left half byte
                                                       ; * If y=1         then right half byte
                                                       ; *                   (X=index)
MON_FMT1:             .byte $04, $20, $54, $30, $0D
                      .byte $80, $04, $90, $03, $22
                      .byte $54, $33, $0D, $80, $04
                      .byte $90, $04, $20, $54, $33
                      .byte $0D, $80, $04, $90, $04
                      .byte $20, $54, $3B, $0D, $80
                      .byte $04, $90, $00, $22, $44
                      .byte $33, $0D, $C8, $44, $00
                      .byte $11, $22, $44, $33, $0D
                      .byte $C8, $44, $A9, $01, $22
                      .byte $44, $33, $0D, $80, $04
                      .byte $90, $01, $22, $44, $33
                      .byte $0D, $80, $04, $90
                      .byte $26, $31, $87, $9A         ;$Zzxxxy01 instr's

MON_FMT2:             .byte $00                        ;Err
                      .byte $21                        ;Imm
                      .byte $81                        ;Z-page
                      .byte $82                        ;Abs
                      .byte $00                        ;Implied
                      .byte $00                        ;Accumulator
                      .byte $59                        ;(Zpag,x)
                      .byte $4D                        ;(Zpag),y
                      .byte $91                        ;Zpag,x
                      .byte $92                        ;Abs,x
                      .byte $86                        ;Abs,y
                      .byte $4A                        ;(Abs)
                      .byte $85                        ;Zpag,y
                      .byte $9D                        ;Relative
MON_CHAR1:
                      .byte "," | %10000000
                      .byte ")" | %10000000
                      .byte "," | %10000000
                      .byte "#" | %10000000
                      .byte "(" | %10000000
                      .byte "$" | %10000000

MON_CHAR2:            .byte "Y" | %10000000
                      .byte 0
                      .byte "X" | %10000000
                      .byte "$" | %10000000
                      .byte "$" | %10000000

                      .byte 0

                                                       ; * Mneml is of form:
                                                       ; *  (A) xxxxx000
                                                       ; *  (B) xxxyy100
                                                       ; *  (C) 1xxx1010
                                                       ; *  (D) xxxyyy10
                                                       ; *  (E) xxxyyy01
                                                       ; *      (X=index)
MON_MNEML:            .byte $1C, $8A, $1C, $23, $5D, $8B
                      .byte $1B, $A1, $9D, $8A, $1D, $23
                      .byte $9D, $8B, $1D, $A1, $00, $29
                      .byte $19, $AE, $69, $A8, $19, $23
                      .byte $24, $53, $1B, $23, $24, $53
                      .byte $19, $A1                   ;(A) format above

                      .byte $00, $1A, $5B, $5B, $A5, $69
                      .byte $24, $24                   ;(B) format

                      .byte $AE, $AE, $A8, $AD, $29, $00
                      .byte $7C, $00                   ;(C) format

                      .byte $15, $9C, $6D, $9C, $A5, $69
                      .byte $29, $53                   ;(D) format

                      .byte $84, $13, $34, $11, $A5, $69
                      .byte $23, $A0                   ;(E) format

MON_MNEMR:            .byte $D8, $62, $5A, $48, $26, $62
                      .byte $94, $88, $54, $44, $C8, $54
                      .byte $68, $44, $E8, $94, $00, $B4
                      .byte $08, $84, $74, $B4, $28, $6E
                      .byte $74, $F4, $CC, $4A, $72, $F2
                      .byte $A4, $8A                   ;(A) format

                      .byte $00, $AA, $A2, $A2, $74, $74
                      .byte $74, $72                   ;(B) format

                      .byte $44, $68, $B2, $32, $B2, $00
                      .byte $22, $00                   ;(C) format

                      .byte $1A, $1A, $26, $26, $72, $72
                      .byte $88, $C8                   ;(D) format

                      .byte $C4, $CA, $26, $48, $44, $44
                      .byte $A2, $C8                   ;(E) format

;-----------------------------------------------------------------------

; Debugger

; Handles stepping, register display, IRQ, BRK.

;-----------------------------------------------------------------------

MON_IRQ:              STA   $45
                      PLA
                      PHA
                      ASL
                      ASL
                      ASL
                      BMI   MON_BREAK
                      JMP   ($03FE)

MON_BREAK:            PLP
                      JSR   MON_SAV1
                      PLA
                      STA   $3A
                      PLA
                      STA   $3B
                      JMP   ($03F0)
MON_OLDBRK:           JSR   MON_INSDS1
                      JSR   MON_RGDSP1
                      JMP   MON_MON

MON_RESET2:           CLD
                      JSR   MON_SETNORM
                      JSR   MON_INIT
                      JSR   MON_SETVID
                      JSR   MON_SETKBD
                      LDA   $C058
                      LDA   $C05A
                      LDA   $C05D
                      LDA   $C05F
                      LDA   $CFFF
                      BIT   $C010
                      CLD
                      JSR   MON_BELL
                      LDA   $03F3
                      EOR   #%10100101
                      CMP   $03F4
                      BNE   MON_PWRUP
                      LDA   $03F2
                      BNE   MON_NOFIX
                      LDA   #$E0
                      CMP   $03F3
                      BNE   MON_NOFIX
MON_FIXSEV:           LDY   #$03
                      STY   $03F2
                      JMP   $E000

MON_NOFIX:            JMP   ($03F2)
MON_PWRUP:            JSR   MON_APPLEII
                      LDX   #$05
MON_SETPLP:           LDA   MON_PWRCON - 1,X
                      STA   $03EF,X
                      DEX
                      BNE   MON_SETPLP
                      LDA   #$C8
                      STX   $00
                      STA   $01
MON_SLOOP:            LDY   #$07
                      DEC   $01
                      LDA   $01
                      CMP   #$C0
                      BEQ   MON_FIXSEV
                      STA   $07F8
MON_NXTBYT:           LDA   ($00),Y
                      CMP   MON_DISKID - 1,Y
                      BNE   MON_SLOOP
                      DEY
                      DEY
                      BPL   MON_NXTBYT
                      JMP   ($0000)
                      NOP
                      NOP

MON_REGDSP:           JSR   MON_CROUT                  ;Display user reg
MON_RGDSP1:           LDA   #<$45                      ;  Contents with
                      STA   $40                        ;  Labels
                      LDA   #>$45
                      STA   $41
                      LDX   #$FB
MON_RDSP1:            LDA   #" " | %10000000
                      JSR   MS_OUTCH
                      LDA   MON_RTBL - $FB,X
                                                       ;Lda   MON_RTBL+$FF05,x

                      JSR   MS_OUTCH
                      LDA   #"=" | %10000000
                      JSR   MS_OUTCH
                      LDA   $45 + 5,X
                      JSR   MON_PRBYTE
                      INX
                      BMI   MON_RDSP1
                      RTS

MON_PWRCON:           .word MON_OLDBRK
                      .word AS_BASIC
                      .byte $45
MON_DISKID:           .byte $20, $FF, $00, $FF, $03, $FF
                      .byte $3C
MON_TITLE:            .byte "A" | %10000000
                      .byte "P" | %10000000
                      .byte "P" | %10000000
                      .byte "L" | %10000000
                      .byte "E" | %10000000
                      .byte " " | %10000000
                      .byte "]" | %10000000
                      .byte "[" | %10000000
MON_XLTBL:
                      .byte "D" | %10000000
                      .byte "B" | %10000000
                      .byte "A" | %10000000

                      .byte $FF
                      .byte "C" | %10000000

                      .byte $FF, $FF, $FF

MON_RTBL:             .byte "A" | %10000000
                      .byte "X" | %10000000
                      .byte "Y" | %10000000
                      .byte "P" | %10000000
                      .byte "S" | %10000000

MON_PADDL0            =     $C064
MON_PTRIG             =     $C070

;-----------------------------------------------------------------------

; Paddles

; Handles the paddles.

;-----------------------------------------------------------------------

MON_PREAD:            LDA   MON_PTRIG                  ;Trigger paddles
                      LDY   #$00                       ;Init count
                      NOP                              ;Compensate for 1st count
                      NOP
MON_PREAD2:           LDA   MON_PADDL0,X               ;Count y-reg every
                      BPL   MON_RTS2D                  ;  12 Usec
                      INY
                      BNE   MON_PREAD2                 ;  Exit at 255 max
                      DEY
MON_RTS2D:            RTS

;-----------------------------------------------------------------------

; Initialize display

; Handles initializing the display.

;-----------------------------------------------------------------------

MON_TXTCLR            =     $C050
MON_TXTSET            =     $C051
MON_MIXSET            =     $C053
MON_LOWSCR            =     $C054
MON_LORES             =     $C056

MON_TEXTBOTTOMLINES   =     4

MON_INIT:             LDA   #0                         ;Clr status for debug
                      STA   $48                        ;  Software
                      LDA   MON_LORES
                      LDA   MON_LOWSCR                 ;Init video mode

MON_SETTXT:           LDA   MON_TXTSET                 ;Set for text mode
                      LDA   #0                         ;  Full screen window
                      BEQ   MON_SETWND

MON_SETGR:            LDA   MON_TXTCLR                 ;Set for graphics mode
                      LDA   MON_MIXSET                 ;  Lower 4 lines as
                      JSR   MON_CLRTOP                 ;  Text window
                      LDA   #24 - MON_TEXTBOTTOMLINES

MON_SETWND:           STA   $22                        ;Set for 40 col window
                      LDA   #0                         ;  Top in a-reg,
                      STA   $20                        ;  Bttm at line 24
                      LDA   #40
                      STA   $21
                      LDA   #24
                      STA   $23                        ;  Vtab to row 23
                      LDA   #24 - 1
MON_TABV:             STA   $25                        ;Vtabs to row in a-reg
                      JMP   MON_VTAB

MON_APPLEII:          JSR   MON_HOME
                      LDY   #$08
MON_STITLE:           LDA   MON_TITLE - 1,Y
                      STA   $040E,Y
                      DEY
                      BNE   MON_STITLE
                      RTS
                      LDA   $03F3
                      EOR   #$A5
                      STA   $03F4
                      RTS
MON_VIDWAIT:          CMP   #$8D
                      BNE   MON_NOWAIT
                      LDY   $C000
                      BPL   MON_NOWAIT
                      CPY   #$93
                      BNE   MON_NOWAIT
                      BIT   $C010
MON_KBDWAIT:          LDY   $C000
                      BPL   MON_KBDWAIT
                      CPY   #$83
                      BEQ   MON_NOWAIT
                      BIT   $C010
MON_NOWAIT:           JMP   MON_VIDOUT
MON_ESCOLD:           SEC
                      JMP   MON_ESC1
MON_ESCNOW:           TAY
                      LDA   MON_XLTBL - $C9,Y          ; Todo
                      JSR   MON_ESCOLD
                      JSR   MS_CQINCH
MON_ESCNEW:           CMP   #$CE
                      BCS   MON_ESCOLD
                      CMP   #$C9
                      BCC   MON_ESCOLD
                      CMP   #$CC
                      BEQ   MON_ESCOLD
                      BNE   MON_ESCNOW
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

MON_ASCBEL            =     $07 | %10000000
MON_ASCBS             =     $08 | %10000000

;-----------------------------------------------------------------------

; Display and read keys

; Handles reading keypresses, escape, displaying characters, scrolling,
; clearing, etc. (Also includes cassette tape handler.)

;-----------------------------------------------------------------------

MON_SPKR              =     $C030

MON_BASCALC:          PHA                              ;Calc base adr in basl,h
                      LSR                              ;  For given line no
                      AND   #%00000011                 ;  0<=Line no.<=$17
                      ORA   #%00000100                 ;Arg=000abcde, generate
                      STA   $29                        ;  Bash=000001cd
                      PLA                              ;  And
                      AND   #%00011000                 ;  Basl=eabab000
                      BCC   MON_BSCLC2
                      ADC   #$80 - 1
MON_BSCLC2:           STA   $28
                      ASL
                      ASL
                      ORA   $28
                      STA   $28
                      RTS

MON_BELL1:            CMP   #MON_ASCBEL                ;Bell char? (cntrl-g)
                      BNE   MON_RTS2B                  ;  No, return
                      LDA   #$40                       ;Delay .01 seconds
                      JSR   MON_WAIT
                      LDY   #$C0
MON_BELL2:            LDA   #$0C                       ;Toggle speaker at
                      JSR   MON_WAIT                   ;  1 Khz for .1 sec.
                      LDA   MON_SPKR
                      DEY
                      BNE   MON_BELL2
MON_RTS2B:            RTS

MON_STOADV:           LDY   $24                        ;Cursor h index to y-reg
                      STA   ($28),Y                    ;Store char in line
MON_ADVANCE:          INC   $24                        ;Increment cursor h index
                      LDA   $24                        ;  (Move right)
                      CMP   $21                        ;Beyond window width?
                      BCS   MON_CR                     ;  Yes cr to next line
MON_RTS3:             RTS                              ;  No,return

MON_VIDOUT:           CMP   #$A0                       ;Control char?
                      BCS   MON_STOADV                 ;  No,output it.

                      TAY                              ;Inverse video?
                      BPL   MON_STOADV                 ;  Yes, output it.

                      CMP   #$8D                       ;Cr?
                      BEQ   MON_CR                     ;  Yes.
                      CMP   #$8A                       ;Line feed?
                      BEQ   MON_LF                     ;  If so, do it.
                      CMP   #MON_ASCBS                 ;Back space? (cntrl-h)
                      BNE   MON_BELL1                  ;  No, check for bell.

MON_BS:               DEC   $24                        ;Decrement cursor h index
                      BPL   MON_RTS3                   ;If pos, ok. else move up
                      LDA   $21                        ;Set ch to wndwdth-1
                      STA   $24
                      DEC   $24                        ;(Rightmost screen pos)
MON_UP:               LDA   $22                        ;Cursor v index
                      CMP   $25
                      BCS   MON_RTS4                   ;If top line then return
                      DEC   $25                        ;Dec cursor v-index

MON_VTAB:             LDA   $25                        ;Get cursor v-index
MON_VTABZ:            JSR   MON_BASCALC                ;Generate base adr
                      ADC   $20                        ;Add window left index
                      STA   $28                        ;To basl
MON_RTS4:             RTS

MON_ESC1:             EOR   #$C0                       ;Esc?
                      BEQ   MON_HOME                   ;  If so, do home and clear
                      ADC   #$FD                       ;Esc-a or b check
                      BCC   MON_ADVANCE                ;  A, advance
                      BEQ   MON_BS                     ;  B, backspace
                      ADC   #$FD                       ;Esc-c or d check
                      BCC   MON_LF                     ;  C, down
                      BEQ   MON_UP                     ;  D, go up
                      ADC   #$FD                       ;Esc-e or f check
                      BCC   MON_CLREOL                 ;  E, clear to end of line
                      BNE   MON_RTS4                   ;  Not f, return
                                                       ;  F, clear to end of page
MON_CLREOP:           LDY   $24                        ;Cursor h to y index
                      LDA   $25                        ;Cursor v to a-register
MON_CLEOP1:           PHA                              ;Save current line on stk
                      JSR   MON_VTABZ                  ;Calc base address
                      JSR   MON_CLEOLZ                 ;Clear to eol, set carry
                      LDY   #0                         ;Clear from h index=0 for rest
                      PLA                              ;Increment current line
                      ADC   #0                         ;(Carry is set)
                      CMP   $23                        ;Done to bottom of window?
                      BCC   MON_CLEOP1                 ;  No, keep clearing lines
                      BCS   MON_VTAB                   ;  Yes, tab to current line

MON_HOME:             LDA   $22                        ;Init cursor v
                      STA   $25                        ;  And h-indices
                      LDY   #0
                      STY   $24                        ;Then clear to end of page
                      BEQ   MON_CLEOP1

MON_CR:               LDA   #0                         ;Cursor to left of index
                      STA   $24                        ;(Ret cursor h=0)
MON_LF:               INC   $25                        ;Incr cursor v(down 1 line)
                      LDA   $25
                      CMP   $23                        ;Off screen?
                      BCC   MON_VTABZ                  ;  No, set base addr
                      DEC   $25                        ;Decr cursor v (back to bottom)

MON_SCROLL:           LDA   $22                        ;Start at top of scrl wndw
                      PHA
                      JSR   MON_VTABZ                  ;Generate base adr
MON_SCRL1:            LDA   $28                        ;Copy basl,h
                      STA   $2A                        ;  To bas2l,h
                      LDA   $29
                      STA   $2B
                      LDY   $21                        ;Init y to rightmost index
                      DEY                              ;  Of scrolling window
                      PLA
                      ADC   #1                         ;Incr line number
                      CMP   $23                        ;Done?
                      BCS   MON_SCRL3                  ;  Yes, finish
                      PHA
                      JSR   MON_VTABZ                  ;Form basl,h (base addr)
MON_SCRL2:            LDA   ($28),Y                    ;Move a chr up on line
                      STA   ($2A),Y
                      DEY                              ;Next char of line
                      BPL   MON_SCRL2
                      BMI   MON_SCRL1                  ;Next line (always taken)

MON_SCRL3:            LDY   #0                         ;Clear bottom line
                      JSR   MON_CLEOLZ                 ;Get base addr for bottom line
                      BCS   MON_VTAB                   ;Carry is set
MON_CLREOL:           LDY   $24                        ;Cursor h index
MON_CLEOLZ:           LDA   #" " | %10000000
MON_CLEOL2:           STA   ($28),Y                    ;Store blanks from 'here'
                      INY                              ;  To end of lines (wndwdth)
                      CPY   $21
                      BCC   MON_CLEOL2
                      RTS

MON_WAIT:             SEC
MON_WAIT2:            PHA
MON_WAIT3:            SBC   #1
                      BNE   MON_WAIT3                  ;1.0204 Usec
                      PLA                              ;(13+27/2*A+5/2*a*a)
                      SBC   #1
                      BNE   MON_WAIT2
                      RTS

MON_NXTA4:            INC   $42                        ;Incr 2-byte a4
                      BNE   MON_NXTA1                  ;  And a1
                      INC   $43
MON_NXTA1:            LDA   $3C                        ;Incr 2-byte a1.
                      CMP   $3E
                      LDA   $3D                        ;  And compare to a2
                      SBC   $3F
                      INC   $3C                        ;  (Carry set if >=)
                      BNE   MON_RTS4B
                      INC   $3D
MON_RTS4B:            RTS

MON_TAPEOUT           =     $C020
MON_TAPEIN            =     $C060

MON_HEADR:            LDY   #$4B                       ;Write a*256 'long 1'
                      JSR   MON_ZERDLY                 ;  Half cycles
                      BNE   MON_HEADR                  ;  (650 Usec each)
                      ADC   #$FE
                      BCS   MON_HEADR                  ;Then a 'short 0'
                      LDY   #$21                       ;  (400 Usec)
MON_WRBIT:            JSR   MON_ZERDLY                 ;Write two half cycles
                      INY                              ;  Of 250 usec ('0')
                      INY                              ;  Or 500 usec ('0')
MON_ZERDLY:           DEY
                      BNE   MON_ZERDLY
                      BCC   MON_WRTAPE                 ;Y is count for
                      LDY   #$32                       ;  Timing loop
MON_ONEDLY:           DEY
                      BNE   MON_ONEDLY
MON_WRTAPE:           LDY   MON_TAPEOUT
                      LDY   #$2C
                      DEX
                      RTS

MON_RDBYTE:           LDX   #$08                       ;8 Bits to read
MON_RDBYT2:           PHA                              ;Read two transitions
                      JSR   MON_RD2BIT                 ;  (Find edge)
                      PLA
                      ROL                              ;Next bit
                      LDY   #$3A                       ;Count for samples
                      DEX
                      BNE   MON_RDBYT2
                      RTS

MON_RD2BIT:           JSR   MON_RDBIT
MON_RDBIT:            DEY                              ;Decr y until
                      LDA   MON_TAPEIN                 ; Tape transition
                      EOR   $2F
                      BPL   MON_RDBIT
                      EOR   $2F
                      STA   $2F
                      CPY   #$80                       ;Set carry on y
                      RTS

MON_KBD               =     $C000
MON_KBDSTRB           =     $C010

MS_CQINCH:            LDY   $24
                      LDA   ($28),Y                    ;Set screen to flash
                      PHA
                      AND   #$3F
                      ORA   #$40
                      STA   ($28),Y
                      PLA

                      JMP   ($38)                      ;Go to user key-in
MON_KEYIN:            INC   $4E
                      BNE   MON_KEYIN2                 ;Incr rnd number
                      INC   $4F
MON_KEYIN2:           BIT   MON_KBD                    ;Key down?
                      BPL   MON_KEYIN                  ;  Loop
                      STA   ($28),Y                    ;Replace flashing screen
                      LDA   MON_KBD                    ;Get keycode
                      BIT   MON_KBDSTRB                ;Clr key strobe
                      RTS

MON_ESC:              JSR   MS_CQINCH                  ;Get keycode

                      JSR   MON_ESCNEW

MON_RDCHAR:           JSR   MS_CQINCH                  ;Read key
                      CMP   #$9B                       ;Esc?
                      BEQ   MON_ESC                    ;  Yes, don't return
                      RTS

MON_NOTCR:            LDA   $32
                      PHA
                      LDA   #$FF
                      STA   $32                        ;Echo user line
                      LDA   $0200,X                    ;  Non inverse
                      JSR   MS_OUTCH
                      PLA
                      STA   $32

                      LDA   $0200,X
                      CMP   #$88                       ;Check for edit keys
                      BEQ   MON_BCKSPC                 ;  Bs, ctrl-x
                      CMP   #$98
                      BEQ   MON_CANCEL
                      CPX   #$F8                       ;Margin?
                      BCC   MON_NOTCR1
                      JSR   MON_BELL                   ;  Yes, sound bell
MON_NOTCR1:           INX                              ;Advance input index
                      BNE   MON_NXTCHAR

MON_CANCEL:           LDA   #"\\" | %10000000          ;Backslash after cancelled line
                      JSR   MS_OUTCH
MS_CQINLN:           JSR   MON_CROUT                  ;Output cr

MON_GETLN:            LDA   $33
                      JSR   MS_OUTCH                   ;Output prompt char
                      LDX   #$01                       ;Init input index
MON_BCKSPC:           TXA                              ;  Will backspace to 0
                      BEQ   MS_CQINLN
                      DEX

MON_NXTCHAR:          JSR   MON_RDCHAR
MON_NXTCHAR1:         CMP   #$95                       ;Use screen char
                      BNE   MON_CAPTST                 ;  For ctrl-u
                      LDA   ($28),Y
MON_CAPTST:           CMP   #$E0
                      BCC   MON_ADDINP                 ;Convert to caps
                      AND   #$DF
MON_ADDINP:           STA   $0200,X                    ;Add to input buf
                      CMP   #$8D
                      BNE   MON_NOTCR
                      JSR   MON_CLREOL                 ;Clr to eol if cr

;-----------------------------------------------------------------------

; Monitor commands

; Handles monitor commands, such as L (list) and G (go).

;-----------------------------------------------------------------------

MON_IOADR             =     $C000

                                                       ; Ascii
MON_CTRL_B            =     $02 | %10000000
MON_CTRL_C            =     $03 | %10000000
MON_CTRL_E            =     $05 | %10000000
MON_CTRL_K            =     $0B | %10000000
MON_CTRL_P            =     $10 | %10000000
MON_CTRL_Y            =     $19 | %10000000

MON_CROUT:            LDA   #$8D
                      BNE   MS_OUTCH
MON_PRA1:             LDY   $3D                        ;Print cr,a1 in hex
                      LDX   $3C
MON_PRYX2:            JSR   MON_CROUT
                      JSR   MON_PRNTYX
                      LDY   #$00
                      LDA   #"-" | %10000000           ;Print '-'
                      JMP   MS_OUTCH

MON_XAM8:             LDA   $3C
                      ORA   #%00000111                 ;Set to finish at
                      STA   $3E                        ;  Mod 8=7
                      LDA   $3D
                      STA   $3F
MON_MODSCHK:          LDA   $3C
                      AND   #%00000111
                      BNE   MON_DATAOUT
MON_XAM:              JSR   MON_PRA1
MON_DATAOUT:          LDA   #" " | %10000000
                      JSR   MS_OUTCH                   ;Output blank
                      LDA   ($3C),Y
                      JSR   MON_PRBYTE                 ;Output byte in hex
                      JSR   MON_NXTA1
                      BCC   MON_MODSCHK                ;Check if time to,
MON_RTS4C:            RTS                              ;  Print addr

MON_XAMPM:            LSR                              ;Determine if mon
                      BCC   MON_XAM                    ;  Mode is xam
                      LSR                              ;  Add, or sub
                      LSR
                      LDA   $3E
                      BCC   MON_ADD
                      EOR   #$FF                       ;Sub: form 2s complement
MON_ADD:              ADC   $3C
                      PHA
                      LDA   #"=" | %10000000
                      JSR   MS_OUTCH                   ;Print =, then result
                      PLA

MON_PRBYTE:           PHA                              ;Print byte as 2 hex
                      LSR                              ;  Digits, destroys a-reg
                      LSR
                      LSR
                      LSR
                      JSR   MON_PRHEXZ
                      PLA
MON_PRHEX:            AND   #%00001111                 ;Print hex dig in a-reg
MON_PRHEXZ:           ORA   #"0" | %10000000           ;  Lsb's
                      CMP   #("9" | %10000000) + 1
                      BCC   MS_OUTCH
                      ADC   #$06

MS_OUTCH:             JMP   ($36)                      ;Vector to user output routine
MON_COUT1:            CMP   #" " | %10000000
                      BCC   MON_COUTZ                  ;Dont output ctrls inverse
                      AND   $32                        ;Mask with inverse flag
MON_COUTZ:            STY   $35                        ;Sav y-reg
                      PHA                              ;Sav a-reg

                      JSR   MON_VIDWAIT

                      PLA                              ;Restore a-reg
                      LDY   $35                        ;  And y-reg
                      RTS                              ;  Then return

MON_BL1:              DEC   $34
                      BEQ   MON_XAM8

MON_BLANK:            DEX                              ;Blank to mon
                      BNE   MON_SETMDZ                 ;After blank

                      CMP   #$BA                       ;Data store mode?
                      BNE   MON_XAMPM                  ;  No, xam, add, or sub
MON_STOR:             STA   $31                        ;Keep in store mode
                      LDA   $3E
                      STA   ($40),Y                    ;Store as low byte as (a3)
                      INC   $40
                      BNE   MON_RTS5                   ;Incr a3, return
                      INC   $41
MON_RTS5:             RTS

MON_SETMODE:          LDY   $34                        ;Save converted :, +,
                      LDA   $0200 - 1,Y                ;  -, . As mode.
MON_SETMDZ:           STA   $31
                      RTS

MON_LT:               LDX   #$01
MON_LT2:              LDA   $3E,X                      ;Copy a2 (2 bytes) to
                      STA   $42,X                      ;  A4 and a5
                      STA   $44,X
                      DEX
                      BPL   MON_LT2
                      RTS

MON_MOVE:             LDA   ($3C),Y                    ;Move (a1 to a2) to
                      STA   ($42),Y                    ;  (A4)
                      JSR   MON_NXTA4
                      BCC   MON_MOVE
                      RTS

MON_VFY:              LDA   ($3C),Y                    ;Verify (a1 to a2) with
                      CMP   ($42),Y                    ;  (A4)
                      BEQ   MON_VFYOK
                      JSR   MON_PRA1
                      LDA   ($3C),Y
                      JSR   MON_PRBYTE
                      LDA   #" " | %10000000
                      JSR   MS_OUTCH
                      LDA   #"(" | %10000000
                      JSR   MS_OUTCH
                      LDA   ($42),Y
                      JSR   MON_PRBYTE
                      LDA   #")" | %10000000
                      JSR   MS_OUTCH
MON_VFYOK:            JSR   MON_NXTA4
                      BCC   MON_VFY
                      RTS

MON_LIST1:            JSR   MON_A1PC                   ;Move a1 (2 bytes) to
                      LDA   #24 - 4                    ;  Pc if specd and
MON_LIST2:            PHA                              ;  Disemble 20 instrs
                      JSR   MON_INSTDSP
                      JSR   MON_PCADJ                  ;Adjust pc each instr
                      STA   $3A
                      STY   $3B
                      PLA
                      SEC
                      SBC   #1                         ;Next of 20 instrs
                      BNE   MON_LIST2
                      RTS

MON_A1PC:             TXA                              ;If user specd adr
                      BEQ   MON_A1PCRTS                ;  Copy from a1 to pc
MON_A1PCLP:           LDA   $3C,X
                      STA   $3A,X
                      DEX
                      BPL   MON_A1PCLP
MON_A1PCRTS:          RTS

MON_SETINV:           LDY   #$3F                       ;Set for inverse vid
                      BNE   MON_SETIFLG                ; Via cout1
MON_SETNORM:          LDY   #$FF                       ;Set for normal vid
MON_SETIFLG:          STY   $32
                      RTS

MON_SETKBD:           LDA   #$00                       ;Simulate port #0 input (in#0)
MON_INPORT:           STA   $3E                        ;  Specified (keyin routine)
MON_INPRT:            LDX   #$38
                      LDY   #<MON_KEYIN
                      BNE   MON_IOPRT
MON_SETVID:           LDA   #$00                       ;Simulate port #0 output (pr#0)
MON_OUTPORT:          STA   $3E                        ;  Specified (cout1 routine)
MON_OUTPRT:           LDX   #$36
                      LDY   #<MON_COUT1
MON_IOPRT:            LDA   $3E                        ;Set ram in/out vectors
                      AND   #%00001111
                      BEQ   MON_IOPRT1
                      ORA   #>MON_IOADR
                      LDY   #$00
                      BEQ   MON_IOPRT2
MON_IOPRT1:           LDA   #>MON_COUT1
MON_IOPRT2:           STY   $00,X
                      STA   $01,X
                      RTS

                      NOP
                      NOP

MON_XBASIC:           JMP   $E000                      ;To basic with scratch

MON_BASCONT:          JMP   $E003                      ;Continue basic

MON_GO:               JSR   MON_A1PC                   ;Adr to pc if specd
                      JSR   MON_RESTORE                ;Restore meta regs
                      JMP   ($3A)                      ;Go to user subr

MON_REGZ:             JMP   MON_REGDSP                 ;To reg display

MON_TRACE:

                      RTS
                      NOP
                      RTS
MON_STEPZ:            NOP
                      NOP
                      NOP
                      NOP
                      NOP

MON_USR:              JMP   $03F8                      ;To usr subr at usradr

MS_CQCOUT:            LDA   #$40
                      JSR   MON_HEADR                  ;Write 10-sec header
                      LDY   #$27
MON_WR1:              LDX   #$00
                      EOR   ($3C,X)
                      PHA
                      LDA   ($3C,X)
                      JSR   MON_WRBYTE
                      JSR   MON_NXTA1
                      LDY   #$1D
                      PLA
                      BCC   MON_WR1
                      LDY   #$22
                      JSR   MON_WRBYTE
                      BEQ   MON_BELL
MON_WRBYTE:           LDX   #$10
MON_WRBYT2:           ASL
                      JSR   MON_WRBIT
                      BNE   MON_WRBYT2
                      RTS

MON_CRMON:            JSR   MON_BL1                    ;Handle a cr as blank
                      PLA                              ;  Then pop stack
                      PLA                              ;  And rtn to mon
                      BNE   MON_MONZ

MS_CQCSIN:             JSR   MON_RD2BIT                 ;Find tapein edge
                      LDA   #$16
MON_READ2:            JSR   MON_HEADR                  ;Delay 3.5 seconds
                      STA   MON_MASK                   ;Init chksum=$FF
                      JSR   MON_RD2BIT                 ;Find tapein edge
MON_RD2:              LDY   #$24                       ;Look for sync bit
                      JSR   MON_RDBIT                  ;  (Short 0)
                      BCS   MON_RD2                    ;  Loop until found
                      JSR   MON_RDBIT                  ;Skip second sync h-cycle
                      LDY   #$3B                       ;Index for 0/1 test
MON_RD3:              JSR   MON_RDBYTE                 ;Read a byte
                      STA   ($3C,X)                    ;Store at (a1)
                      EOR   MON_MASK
                      STA   MON_MASK                   ;Update running chksum
                      JSR   MON_NXTA1                  ;Inc a1, compare to a2
                      LDY   #$35                       ;Compensate 0/1 index
                      BCC   MON_RD3                    ;Loop until done
                      JSR   MON_RDBYTE                 ;Read chksum byte
                      CMP   MON_MASK
                      BEQ   MON_BELL                   ;Good, sound bell and return
MON_PRERR:            LDA   #"E" | %10000000
                      JSR   MS_OUTCH                   ;Print "err", then bell
                      LDA   #"R" | %10000000
                      JSR   MS_OUTCH
                      JSR   MS_OUTCH

MON_BELL:             LDA   #$87                       ;Output bell and return
                      JMP   MS_OUTCH

MON_RESTORE:          LDA   $48                        ;Restore 6502 reg contents
                      PHA                              ;  Used by debug software
                      LDA   $45
MON_RESTR1:           LDX   $46
                      LDY   $47
                      PLP
                      RTS
MON_SAVE:             STA   $45                        ;Save 6502 reg contents
MON_SAV1:             STX   $46
                      STY   $47
                      PHP
                      PLA
                      STA   $48
                      TSX
                      STX   $49
                      CLD
                      RTS

MON_RESET:            JSR   MON_SETNORM                ;Normal
                      JSR   MON_INIT
                      JSR   MON_SETVID                 ;Pr#0
                      JSR   MON_SETKBD                 ;In#0
MON_MON:              CLD                              ;Must set hex mode!
                      JSR   MON_BELL
MON_MONZ:             LDA   #$AA                       ;* Prompt for mon
                      STA   $33
                      JSR   MS_CQINLN                 ;Read a line
                      JSR   MON_ZMODE                  ;Clear mon mode, scan idx
MON_NXTITM:           JSR   MON_GETNUM                 ;Get item, non-hex
                      STY   $34                        ;  Char in a-reg
                      LDY   #$17                       ;  X-reg=0 if no hex input
MON_CHRSRCH:          DEY
                      BMI   MON_MON                    ;Not found, go to mon
                      CMP   MON_CHRTBL,Y               ;Find cmnd char in tel
                      BNE   MON_CHRSRCH
                      JSR   MON_TOSUB                  ;Found, call corresponding
                      LDY   $34                        ;  Subroutine
                      JMP   MON_NXTITM

MON_DIG:              LDX   #$03
                      ASL
                      ASL                              ;Got hex dig,
                      ASL                              ;  Shift into a2
                      ASL
MON_NXTBIT:           ASL
                      ROL   $3E
                      ROL   $3F
                      DEX                              ;Leave x=$FF if dig
                      BPL   MON_NXTBIT
MON_NXTBAS:           LDA   $31
                      BNE   MON_NXTBS2                 ;If mode is zero
                      LDA   $3F,X                      ; Then copy a2 to
                      STA   $3D,X                      ; A1 and a3
                      STA   $41,X
MON_NXTBS2:           INX
                      BEQ   MON_NXTBAS
                      BNE   MON_NXTCHR

MON_GETNUM:           LDX   #$00                       ;Clear a2
                      STX   $3E
                      STX   $3F
MON_NXTCHR:           LDA   $0200,Y                    ;Get char
                      INY
                      EOR   #$B0
                      CMP   #$0A
                      BCC   MON_DIG                    ;If hex dig, then
                      ADC   #$88
                      CMP   #$FA
                      BCS   MON_DIG
                      RTS

MON_TOSUB:            LDA   #>MON_GO                   ;Push high-order
                      PHA                              ;  Subr adr on stk
                      LDA   MON_SUBTBL,Y               ;Push low-order
                      PHA                              ;  Subr adr on stk
                      LDA   $31
MON_ZMODE:            LDY   #$00                       ;Clr mode, old mode
                      STY   $31                        ;  To a-reg
                      RTS                              ; Go to subr via rts

;Define f(chr) <(chr^$B0+$89)

MON_CHRTBL:           .byte <((MON_CTRL_C ^ $B0) + $89)
                      .byte <((MON_CTRL_Y ^ $B0) + $89)
                      .byte <((MON_CTRL_E ^ $B0) + $89)

                      .byte <((MON_CTRL_Y ^ $B0) + $89)

                      .byte <((("V" | %10000000) ^ $B0) + $89)
                      .byte <((MON_CTRL_K ^ $B0) + $89)

                      .byte <((MON_CTRL_Y ^ $B0) + $89)

                      .byte <((MON_CTRL_P ^ $B0) + $89)
                      .byte <((MON_CTRL_B ^ $B0) + $89)
                      .byte <((("-" | %10000000) ^ $B0) + $89)
                      .byte <((("+" | %10000000) ^ $B0) + $89)
                      .byte <((("M" | %10000000) ^ $B0) + $89)
                      .byte <((("<" | %10000000) ^ $B0) + $89)
                      .byte <((("N" | %10000000) ^ $B0) + $89)
                      .byte <((("I" | %10000000) ^ $B0) + $89)
                      .byte <((("L" | %10000000) ^ $B0) + $89)
                      .byte <((("W" | %10000000) ^ $B0) + $89)
                      .byte <((("G" | %10000000) ^ $B0) + $89)
                      .byte <((("R" | %10000000) ^ $B0) + $89)
                      .byte <(((":" | %10000000) ^ $B0) + $89)
                      .byte <((("." | %10000000) ^ $B0) + $89)
                      .byte <(($8D ^ $B0) + $89)
                      .byte <(((" " | %10000000) ^ $B0) + $89)

MON_SUBTBL:           .byte <MON_BASCONT - 1
                      .byte <MON_USR - 1
                      .byte <MON_REGZ - 1
                      .byte <MON_TRACE - 1
                      .byte <MON_VFY - 1
                      .byte <MON_INPRT - 1
                      .byte <MON_STEPZ - 1
                      .byte <MON_OUTPRT - 1
                      .byte <MON_XBASIC - 1
                      .byte <MON_SETMODE - 1
                      .byte <MON_SETMODE - 1
                      .byte <MON_MOVE - 1
                      .byte <MON_LT - 1
                      .byte <MON_SETNORM - 1
                      .byte <MON_SETINV - 1
                      .byte <MON_LIST1 - 1
                      .byte <MS_CQCOUT - 1
                      .byte <MON_GO - 1
                      .byte <MS_CQCSIN - 1
                      .byte <MON_SETMODE - 1
                      .byte <MON_SETMODE - 1
                      .byte <MON_CRMON - 1
                      .byte <MON_BLANK - 1

MON_M6502VEC:         .word $03FB                      ;Nmi vector

                      .word MON_RESET2                 ;Reset vector

                      .word MON_IRQ                    ;Irq vector

