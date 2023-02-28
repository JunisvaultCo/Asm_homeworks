section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple for 2 numbers, a and b

cmmmc:
; concept: easiest way to get lcm is by doing (a * b) / gcd

; we have to be extra careful with what we took out of the stack
; (we have to put it back, since there is the previous instruction
; pointer which will be necessary for the return)
	pop eax; just the instruction pointer
	pop ebx; a
	pop ecx; b
	push ecx
	push ebx
	push eax; done setting the stack back in place

; now I have to move ebx into eax for mul
	push ebx
	pop eax	
	mul ecx; now we have a * b in eax, a in ebx and b in ecx
gcd:
; we want to have a < b at every point, so if they aren't we switch them
	push eax; make sure I don't delete eax
	cmp ebx, ecx
	jle dont_switch

	push ebx
	push ecx
	pop ebx
	pop ecx
dont_switch:
; basically, do a1 = b0 % a0, b1 = a0
	xor edx, edx; the higher part is just empty in the divide
	push ecx
	pop eax
	div ebx; a1 remains in edx, chillingly, until we are nearly
           ; done with the changes
	push ebx
	pop ecx
	push edx; get the remainder (a1)
	pop ebx

	cmp ebx, 0
	jz end
	jmp dont_switch
end:
	pop eax; finally, get back a * b that was calculated
; now gcd is in ecx and a * b is in eax. A simple div
; by gcd.
	div ecx
	ret
