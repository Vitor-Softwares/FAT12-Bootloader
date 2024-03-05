jmp short main
nop

OEMname:					db "VITORSOS"
bytesPerSector: 			dw 512
sectPerCluster: 			db 1
reservedSectors:			dw 1
numFATs:					db 2
numRootDirEntries:			dw 224
numSectors:					dw 2880
mediaType:					db 0xf0
numFATSectors:				dw 9
sectorsPerTrack:			dw 18
numHeads:					dw 2
numHiddenSectors:			dd 0	
numSectorsHuge:				dd 0
driveNum:					db 0
reserved:					db 0
extendedBootSignature: 		db 0x29
volumeId:					dd 0xa1b2c3d4
volumeLabel:				db "WIKIOS     "
fileSysType:				db "FAT12   "

nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop

;---------------------------------------------------------------------------------------------------------------------
main:

mov [drvnum], dl

mov ax, 0x7c00
mov ds, ax

mov ax, 0x7c0
mov es, ax

sub ax, 0x200
mov sp, ax
mov bp, ax
;---------------------------------------------------------------------------------------------------------------------


; gerar modo de video
xor ax, ax
mov al, 0x13
int 0x10
; finalizado

; chamar fundo branco

call DesenhaFundoBranco


; agora que o fundo está branco, precisa escrever a frase

call ColocaFrase

; O espaço acabou, vamos para a parte 2!

call ChamaParte2

jmp $

;---------------------------------------------------------------------------------------------------------------------

DesenhaFundoBranco:
push bp
mov bp, sp
pusha

xor cx, cx ; Posicao horizontal 0
mov dx, 0x1e ; Posicao vertical 30
mov ah, 0x0c
mov al, 0x0f

recomeca:
int 0x10
inc cx
cmp cx, 0x140 ; Compara se chegou a 320px
je zeraHorizontal
jmp recomeca

popa
mov sp, bp
pop bp
ret
;---------------------------------------------------------------------------------------------------------------------

zeraHorizontal:
xor cx, cx
inc dx
cmp dx, 0xc8 ; Compara se chegou a 200px
je fim
jmp recomeca

;---------------------------------------------------------------------------------------------------------------------

ColocaFrase:
push bp
mov bp, sp
pusha

mov ah, 0x13
mov al, 0x01
xor bx, bx
mov bl, 0x0f
mov cx, 0x15 ; Quantidade de caracteres na frase
mov dh, 0x1c
mov dl, 0x04
mov bp, mensagem
; add bp, 0x7c00
int 0x10

fim:
popa
mov sp, bp
pop bp
ret
;---------------------------------------------------------------------------------------------------------------------

ChamaParte2:

mov ah, 2
mov al, 3 ; Número de setores para leitura
mov ch, 0 ; Numero do cilindro
mov cl, 2 ; Inicia o setor 2, pois o setor 1 já está carregado em memoria
mov dh, 0 ; Numero do head
mov dl, [drvnum]
mov bx, stage2
int 0x13
jmp stage2

;---------------------------------------------------------------------------------------------------------------------
drvnum: db 0

; Variaveis

mensagem: db 'ALTERE AQUI A MENSAGEM'


;finalizando
times (510 - ($ - $$)) db 0x00
dw 0xAA55

;---------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------FIM DA PARTE 1------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------




;---------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------COMEÇA A PARTE 2------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------


stage2:

call desenha


final:
jmp $


;---------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------DESENHA------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------

desenha:
push bp
mov bp, sp
pusha

xor ax, ax
mov ds, ax
mov si, ax

push 0x0f	; Cor pixel - [sp + 0x06]
push 0x00	; x - horizontal - [sp + 0x04]
push  0xc7	; y - vertical - [sp + 0x02]
push 0x00	; Numero repetições - [sp]

mov di, sp
mov bl, byte [0x7c00 + dados + si] ; Repetições

inicio:
mov dx, [di + 0x02] ; Vertical - Y

volta1:
xor bh, bh
mov cx, [di + 0x04] ; horizontal- xor
mov al, [di + 0x06]
mov ah, 0x0c
int 0x10
dec bl ; Diminui uma repetição
mov [di], bl ; Salva o numero de repetições que faltam

cmp bl, 0
je trocaCor
volta2:

xor ax, ax
mov ax, word[di + 0x04] ; x - horizontal - [sp + 0x04]
inc ax
cmp ax, 0x13f ; 319
je preparaRetorno
mov [di + 0x04], ax  ;x - horizontal - [sp + 0x04]
jmp volta1


preparaRetorno:
xor ax, ax
mov [di + 0x04], ax  ; x - horizontal - [sp + 0x04]
mov ax, [di + 0x02] ; y - vertical - [sp + 0x02]
dec ax
mov [di + 0x02], ax
inc si
mov bl, byte [0x7c00 + dados + si] ; repetição
cmp bl, 0xff
je final
jmp inicio


trocaCor:
mov al, [di + 0x06]
cmp al, 0x0f
je preto
mov al, 0x0f
jmp salva


preto:
mov al, 0x00


salva:
mov [di + 0x06], al
inc si
mov bl, byte [0x7c00 + dados + si] ; Repetições
cmp bl, 0xff
je final
mov [di], bl
jmp volta2


popa
mov sp, bp
pop bp
ret


dados:	; DE ACORDO COM O CODIGO GERADO PELO COMPRESSOR BMP
db 22,144,5,145,4,23,143,3,1,1,142,7,24,142,4
db 142,8,25,141,4,140,10,26,139,2,2,1,138,12,27
db 138,5,137,13,28,137,5,136,14,29,136,5,135,15,30
db 135,5,133,17,30,135,5,132,18,31,134,5,130,20,32
db 133,1,2,2,128,22,33,131,2,2,1,127,24,35,129
db 2,2,1,126,25,36,128,1,1,3,124,27,37,127,1
db 1,4,122,28,38,126,1,1,4,121,29,39,250,31,40
db 123,1,124,32,42,244,34,43,242,35,46,237,37,49,233,38,51
db 229,40,53,226,41,54,224,42,54,223,43,57,219,44,59,98,5,2,4
db 106,46,61,94,16,101,48,62,91,20,98,49,66,86,22,94,52,68,82
db 25,91,54,70,77,29,87,57,72,71,34,82,61,74,66,40,79,61,75,63,43
