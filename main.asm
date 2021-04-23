;	This is a mash of code from the nesdev wiki, gbaguy's
;	NES ASM tutorials (https://patater.com/gbaguy/nesasm.htm)
;   and help from my friend anakrusis. I do not take credit	
;	for...much of anything.
;
;   I'm just learning! This will NEVER be sold!
;   
;   -kipptune
;
;
;
	.inesprg 1
	.ineschr 1
	.inesmap 0
	.inesmir 1
	.bank 0
	
	.rsset $0000  ;love you amimi <3
param1  .rs 1 ; local parameters for functions when you cant use a register
param2  .rs 1 ; idk if ill use these or not but theyre here if i need them
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

globalTick .rs 1
buttons1 .rs 1
buttons2 .rs 1
prevButtons1 .rs 1
prevButtons2 .rs 1

JOYPAD1 = $4016
JOYPAD2 = $4017

	.rsset $0100
playfield  .rs 256

	.org $8000  ;org is GO TO this ADDRESS
playerX   .db 20  ;X position for the sprite, start at 20
playerY   .db 20  ;Y position for the sprite, start at 20
irq:
nmi:
		lda #%00011110   ; in order of 1's: BG enabled, SPRITES enabled, PPU increment by 32, last 2 bits are "10 = $2800 (VRAM)"
		sta $2001
		lda #$00 
		sta $2005  ;2005 is scrolling address so we LDA $00 which is no scrolling
		sta $2005  ;__________________________________
		lda #$00
		sta $2003  
		lda #$02
		sta $4014  ;oam dma (Object Attribute Memory, where the 64 sprites are!)
	
ReadControllers:  ;From: http://wiki.nesdev.com/w/index.php/Controller_reading_code
		lda #$01
		sta JOYPAD1
		sta buttons2  ; player 2's buttons double as a ring counter
		lsr a         ; now A is 0
		sta JOYPAD1
ReadControllerLoop:
		lda JOYPAD1
		and #%00000011  ; ignore bits other than controller
		cmp #$01        ; Set carry if and only if nonzero
		rol buttons1    ; Carry -> bit 0; bit 7 -> Carry
		lda JOYPAD2     ; Repeat
		and #%00000011
		cmp #$01
		rol buttons2    ; Carry -> bit 0; bit 7 -> Carry
		bcc ReadControllerLoop
	
		rti

reset:
		sei
		cld
		
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
		lda Palette, x
		sta $2007
		inx
		cpx #32
		bne loadpal

start:     ;HERE IS CODE AND SUBROUTINES AND CRAP

	.org $8100
level1:
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
		.db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01

infin:
		jmp infin
	
BackgroundMetaTiles:
		.db $0f, $0f, $0f, $0f  ;air
		.db $30, $31, $03, $32  ;ground (blocks)
		.db $33, $33, $00, $00  ;platform
		.db $34, $35, $36, $37  ;spike
	
SpriteMetaTiles:
		.db $00, $01, $04, $05  ;standing
		.db $00, $01, $02, $03  ;walking animation frame
		.db $06, $07, $08, $09  ;triangle man
		.db $0a, $0b, $0c, $0d  ;diamond collectible
	
Palette:  ;background palettes
    .db $31, $21, $11, $01, $0f, $28, $18, $08, $0f, $15, $25, $35, $0f, $20, $10, $00
    
SpritePalette:  ;sprite palettes
    .db $31, $19, $1a, $0f, $0f, $30, $26, $05, $0f, $20, $10, $00, $0f, $23, $13, $03

	.bank 1     ; change to bank 1
	.org $FFFA  ; start at $FFFA
	.dw nmi
	.dw reset 
	.dw irq
	.bank 2
    .org $0000
    .incbin "shart.chr"