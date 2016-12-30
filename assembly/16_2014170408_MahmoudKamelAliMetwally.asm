

INCLUDE Irvine32.inc
.data
arr1 dword 10 dup  (?)
arr dword 50 dup  (?)
s byte '12',0
x dword "F"
r dword "B"
q dword "bf"
arr3 dword 100 dup  (?)
arr5 dword 100 dup  (?)
arr35 dword 100 dup  (?)

.code
prop1 proc
	call readint 
	sub eax,1
	mov ecx,eax
	mov edi,0
	add eax,1
	mov ebx,0
	mov esi,eax
	l:
	mov edx,0
	cmp ecx,1
	jbe a
	div ecx

    cmp edx,0
    jnz a
    mov arr1[edi],eax
    add ebx,1
	add edi,4
    a:
	mov eax,esi
	loop l
	mov ecx,ebx
	mov edi,0
	l1:
	mov eax,arr1[edi]
    add edi,4
	call writeint 
		call crlf

	loop l1
ret 
prop1 endp

prop2 proc
mov edi,0
	mov esi,0
	mov edx,0
	b:
	call readint
	cmp eax,0
	jl a
		add esi,1
	mov ebx,eax
    cmp edi,0
    jnz m
	mov edi,eax
	jmp b
	m:
	sub eax,edi
		mov edi,ebx
	cmp edx,eax
	jg b
	l:
	mov edx,eax
	mov ecx,esi
	mov edi,ebx
	jmp b

	a:
		sub ecx,2

	mov eax,edx
	call writeint
	call crlf
	mov eax,ecx
	call writeint
	call crlf
ret 
prop2 endp
prop3 proc
call readint
	mov edi,0
	mov ecx,0
	mov esi,10
	cmp eax,esi
	ja A
	call writeint

	
	A:
	mov edx,0
	div esi
	cmp edx,0
	ja h

h:
mov arr[edi],edx
add edi,4
cmp eax,esi
ja a
 mov arr[edi],eax
add edi,4
sub edi,4
mov ecx,edi
	l:
	mov eax,arr[edi]
    sub edi,4
	call writeint 
		call crlf
		cmp edi,ecx
		ja n
		cmp edi,0
		jae l
		 n:
	call crlf
ret 
prop3 endp
prop4 proc
mov edx,offset s
	mov ecx,100
	call readstring 
	mov edi,0
	mov esi,0
	mov ebx,0
	l:
	cmp eax,0
	je m
mov bl,[edx]
  cmp bl,'a'
  je c1
   cmp bl,'A'
  je c1
   cmp bl,'e'
  je c1
   cmp bl,'E'
  je c1
   cmp bl,'i'
  je c1
   cmp bl,'I'
  je c1
   cmp bl,'o'
  je c1
   cmp bl,'O'
  je c1
   cmp bl,'u'
  je c1
   cmp bl,'U'
  je c1
  cmp bl,'0'
  jae n
  
  dec eax
  inc edx
  jmp l

  n:
   cmp bl,'9'
  jbe c2
inc edx
dec eax
  jmp l
	c1:
	inc edi
    dec eax
    inc edx
  jmp l
	c2:
	inc esi
	 dec eax
	   inc edx

  jmp l

  m:
  mov eax ,edi
  call writeint
  call crlf
   mov eax ,esi
  call writeint
  call crlf
ret 
prop4 endp
prop5 proc
mov edi,0
mov ecx,1
mov esi,0
mov ebx,1
l:
mov eax,3
mul ecx
mov arr3[edi],eax
add edi,4
inc ecx
cmp eax,100
jae l1
jmp l

l1:
mov eax,5
mul ebx
mov arr5[esi],eax
add esi,4
inc ebx
cmp eax,100
jae prog1
jmp l1

prog1:
call readint
mov ecx,0
mov edi,0
mov esi,0
mov ebx,eax
mov eax,0
prog:
inc eax
mov edi,0
mov esi,0
mov edx,0
inc ecx
cmp ecx,ebx
ja p
m:
cmp eax,arr3[edi]
je n1
cmp eax,arr3[edi]
jb n2
cmp eax,arr3[edi]
add edi,4
ja m
n1:
cmp eax,arr5[esi]
je cout1
cmp eax,arr5[esi]
jb cout3
cmp eax,arr5[esi]
add esi,4
ja n1
n2:
cmp eax,arr5[edx]
je cout2
cmp eax,arr5[edx]
jb z
cmp eax,arr5[edx]
add edx,4
ja n2


cout1:
mov edx,offset q
call writestring
call crlf

jmp prog

cout2:
mov edx,offset r
call writestring
call crlf

jmp prog

cout3:
mov edx,offset x
call writestring
call crlf
jmp prog

z:
mov eax,ecx
call writeint 
call crlf

jmp prog
p:
ret 
prop5 endp
main PROC
call prop1
call prop2
call prop3
call prop4
call prop5


	exit
main ENDP

END main
