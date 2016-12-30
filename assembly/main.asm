INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 100000

.data

	buffer BYTE BUFFER_SIZE DUP(?)
	buffer1 BYTE BUFFER_SIZE DUP(?)
	filename BYTE 80 DUP(0)
	fileHandle HANDLE ?
	sz1 dword ?
	Numbers byte BUFFER_SIZE Dup(0)
	Counter DWORD 0
	temp dword ?
	lb byte ?
	rb byte ?
	alvar byte ?
	sz word ?
	pntr dword ?
	Message byte " "

.code
ReadF PROC
	                                           ; Let user input a filename.
	mWrite "Enter an input filename: "
	mov edx,OFFSET filename
	mov ecx,SIZEOF filename
	call ReadString
		                                       ; Open the file for input.
	mov edx,OFFSET filename
	call OpenInputFile
	mov fileHandle,eax
		                                     ; Check for errors.
	cmp eax,INVALID_HANDLE_VALUE                ; error opening file?
	jne file_ok                                  ; no: skip
	mWrite <"Cannot open file",0dh,0ah>
	jmp quit                                     ; and quit
	file_ok:
                                            ; Read the file into a buffer.
	mov edx,OFFSET buffer
	mov ecx,BUFFER_SIZE
	call ReadFromFile
	jnc check_buffer_size                        ; error reading?
	mWrite "Error reading file. "                ; yes: show error message
	call WriteWindowsMsg
	jmp close_file
	check_buffer_size:
	cmp eax,BUFFER_SIZE                          ; buffer large enough?
	jb buf_size_ok ; yes
	mWrite <"Error: Buffer too small for the file",0dh,0ah>
	jmp quit                                     ; and quit
	buf_size_ok:
	mov buffer[eax],0                            ; insert null terminator
	mWrite "File size: "
	call WriteDec                                ; display file size
	call Crlf
			                                    
	mov sz1, eax
	close_file:
	mov eax,fileHandle
	call CloseFile
	quit:
RET
ReadF ENDP

ConvertString proc

	mov eax, 0
	mov edi, offset Buffer
	mov ecx, lengthof Buffer
	mov esi, offset Numbers

	mov edx, 0
	mov ebx, 0

	dem:
	cmp ebx, 2
	je q1
	mov al, buffer[edx]
	cmp al, 0dh
	je cnt
	inc edx
	inc edi
	jmp dem
	cnt :
	inc edx
	inc ebx
	inc edi
	jmp dem
	q1 :
	inc edi
	inc edx
	mov pntr, edx
	sub ecx, edx
	mov eax, 0

	Num :
	movzx ebx, byte ptr[edi]
	cmp ebx, 0dh; Line finished ?
	jE NumEnded; yes
	sub ebx, '0'
	mov edx, 10
	mul edx
	Add eax, ebx
	jmp skip

	NumEnded :
	mov[esi], Al
	inc esi
	inc counter
	mov eax, 0
	inc edi; to skip 0Ah
	dec ecx

	Skip :
	inc edi; to read next byte

	Loop Num

ret
ConvertString EndP


HideMessage Proc

mov esi, offset numbers
mov ecx,16             ; to store size in 16 bit
mov BX,sz              ;sz is defined as word in .data

HideSize:

SHR BX,1                     
mov AL,[esi]                 

JNC Z

O:
mov Ah,00000000b
RCL AH,1
OR AL,AH
JMP N

Z:
mov Ah,11111111b
RCL AH,1
AND AL,AH
     
N:
mov [esi],AL
inc esi

Loop HideSize


mov edx,0
movzx ecx,sz

OuterLoop:          ;Loop on the Message characters

mov temp,ecx
mov ecx,8
mov bl,message[edx]

InnerLoop:          ;Loop on bits of each character

SHR bl,1            
mov AL,[esi]  

JNC ZERO

ONE:
mov Ah,00000000b
RCL AH,1
OR AL,AH
JMP NEXT

Zero:
mov Ah,11111111b
RCL AH,1
AND AL,AH
     
Next:
mov [esi],AL
inc esi

Loop InnerLoop

mov ecx,temp
inc edx

Loop OuterLoop


;Display:

;movzx eax,byte ptr [edx]
;Call WriteINT
;Call CRLF
;inc edx
;Loop  Display


ret
HideMessage ENDP


ConvertBytes PROC
	MOV ECX, pntr
	MOV ESI, 0
	LLL:
		MOV AL, buffer[ESI]
		MOV buffer1[ESI], AL
		INC ESI
	LOOP LLL
	
	MOV ECX, Counter
	;MOV ESI, pntr
	MOV EDI, 0

	LL:
		MOVZX AX, Numbers[EDI]
		MOV EDX, 0
		W:
			MOV BL, 10
			DIV BL
			ADD AH, '0'
			;MOV Buffer1[ESI], AH
			;INC ESI
			MOVZX EBX, AH
			PUSH EBX
			INC EDX
			MOVZX AX, AL
			CMP AX, 0
			JE EndW
			JMP W
		EndW:
		MOV EBX, ECX
		MOV ECX, EDX
		SSS:
			POP EAX
			MOV buffer1[ESI], AL
			INC ESI
		LOOP SSS
		MOV ECX, EBX
		MOV Buffer1[ESI], 0dh
		INC ESI
		MOV Buffer1[ESI],0ah
		INC ESI
		INC EDI
	LOOP LL
RET
ConvertBytes ENDP

WriteF PROC
	
	mov edx,OFFSET filename
	mov ecx, sizeof filename
	call CreateOutputFile
	MOV EDX, OFFSET Buffer1
	MOV ECX, ESI
	;call writestring
	call WriteToFile
	call CloseFile
RET
WriteF ENDP

RetrieveHiddenMessage PROC
	MOV ECX, 16
	MOV ESI, 0
	MOV EBX, 0
	MOV EDI, 0
	MOV DI, 1

	HideSize:
		MOV AL, Numbers[ESI]
		SHR AL, 1
		JC O
		JMP skip
		O:
		ADD BX, DI
		skip:
		SHL DI, 1 ;DI * 2
		INC ESI
	LOOP HideSize

	MOV ECX, EBX ; size of the message
	L:  ;retrieve the message
		PUSH ECX
		MOV DL, 1
		MOV ECX, 8
		MOV AL, 0
		cha:
			MOV BL, Numbers[ESI]
			SHR BL, 1
			JC ON
			JMP OFF
			ON:
			ADD AL, DL
			OFF:
			SHL DL, 1
			INC ESI
		LOOP cha
		POP ECX
		call writechar
	LOOP L
RET
RetrieveHiddenMessage ENDP


main PROC
	; to hide message
	;call ReadF
	;call ConvertString
	;call HideMessage
	;call ConvertBytes
	;call WriteF

	; to retrieve message
	;call ReadF
	;call ConvertString
	;call RetrieveHiddenMessage
	
	mWrite <"To hide a message enter h",0dh,0ah>
	mWrite <"To retrieve hidden message enter r",0dh,0ah>
	call readchar
	cmp al, 'h'
	je hide
	call ReadF
	call ConvertString
	mWrite <"The hidden message is : ">
	call RetrieveHiddenMessage
	call crlf
	jmp skip
	hide:
	call ReadF
	call ConvertString
	mWrite <"Enter the message : ">
	mov edx, offset Message
	mov ecx, 1000
	call readstring
	mov sz, ax
	call HideMessage
	call ConvertBytes
	call WriteF
	mWrite <"done",0dh,0ah>
	skip:
exit
main ENDP
END main