	.inesprg 1
	.ineschr 1
	.inesmap 0
	.inesmir 1
	.bank 0
	
	.rsset $0000  ;love you amimi <3
param1  .rs 1 ; local parameters for functions when you cant use a register
param2  .rs 1 ;
param3  .rs 1 ;        ####     ####
param4  .rs 1 ;       #    #   #    #
param5  .rs 1 ;      #      # #      #
param6  .rs 1 ;      #       #       #
param7  .rs 1 ;       #             #
param8  .rs 1 ;        #           #
param9  .rs 1 ;         #         #
param10 .rs 1 ;          #       #
param11 .rs 1 ;           #     #
param12 .rs 1 ;            #   #
param13 .rs 1 ;             ###
param14 .rs 1 ;
param15 .rs 1 ;
param16 .rs 1 ;

	.org $8000  ;org is GO TO this ADDRESS
X_Pos   .db 20  ;X position for the sprite, start at 20
Y_Pos   .db 20  ;Y position for the sprite, start at 20
irq:
nmi:
	lda #%00011110   ; in order of 1's: BG enabled, SPRITES enabled, PPU increment by 32, last 2 bits are "10 = $2800 (VRAM)"
    sta $2001
    lda #$00 
    sta $2005  ;2005 is scrolling address so we load $00 which is no scrolling
    sta $2005  ;__________________________________
    lda #$00
    sta $2003  
    lda #$02
    sta $4014  ;oam dma (Object Attribute Memory, where the 64 sprites are!)
	
controllerInput:
	lda #$01  ;these four setup Pad for reading.
	sta $4016
	lda #$00
	sta $4016 

	lda $4016  ; read for A key.
	and #1     ; check to see if down.
	bne WasDown  ; branch if it was down.
	; I'm not sure why it's a BNE for a bit AND, it just is, SO USE IT! :)

	lda $4016  ; read for B key.
	lda $4016  ; read for SELECT
	lda $4016  ; read START status
	and #1     ; see if down.
	bne StartDown  ; branch if down.

	lda $4016  ; UP
	lda $4016  ; DOWN
	lda $4016  ; LEFT
	lda $4016  ; RIGHT
	
	jmp NothingDown  ; the JMP instruction jumps no matter what.
	
StartDown:
	; Do stuff if START is pressed.

WasDown:
	; Do stuff if A is pressed.

NothingDown:
	; Nothing was down
	
    rti
reset:

vblankwait1:
    bit $2002
    bpl vblankwait1
    
clearmemLoop:  ;this clears RAM on startup (thanks Amelia!)
    lda #$00
    sta $0000, x
    sta $0100, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    lda #$fe
    sta $0200, x
    inx
    bne clearmemLoop
    
vblankwait2:
    bit $2002
    bpl vblankwait2
	
	lda #$90
    sta $2000   ;enable NMIs (Non-Maskable Interrupt)
    
    lda #%00011110 ; background and sprites enabled
    sta $2001
;i think the following loads palettes
	lda #$3F   ; these 4 lines tell $2006 that we
	sta $2006  ; want the stuff we load $2007 with
	lda #$00   ; to start at memory location $3F00.
	sta $2006  ; Note that since we can only store a byte at a 
	ldx #$00   ; time we store twice to get the whole address in there.
	
loadpal:
	lda palette, x
	sta $2007
	inx
	cpx #32
	bne loadpal

start:     ; from here on would be code as usual
	
infin:
	jmp infin
	
	palette:  ;background palettes
    .db $31, $21, $11, $01, $38, $28, $18, $08, $35, $25, $15, $05, $3b, $2b, $1b, $0b
    
spritePalette:  ;sprite palettes
    .db $31, $05, $27, $30, $38, $03, $24, $30, $35, $0f, $30, $21, $3b, $14, $22, $34

	.bank 1     ; change to bank 1
	.org $FFFA  ; start at $FFFA
	.dw nmi
	.dw reset 
	.dw irq
	.bank 2
    .org $0000
    .incbin "shart.chr"