section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression

par:
; similarly to part 1, we have to be careful
	pop eax; instruction pointer
	pop ebx; length
	pop ecx; expression

	push ecx
	push ebx
	push eax; done with setting the stack back

; concept: we count how many '(' brackets don't have a
; matching ')' yet in eax. If at the end there are brackets
; still unmatched, then it is incorrect. Or, if there is a
; ')' but there are no '('s before it.

	xor edx, edx; current position
	xor eax, eax; current unmatched
walk_through_array:
	push dword [ecx + edx]; unfortunately can't push just 1 byte
	pop edi
	and edi, 255; get only the last 8 bits
	cmp edi, ')'
	je closing
	inc eax
	jmp increment
closing:
	dec eax
	cmp eax, 0
	jl incorrect
increment:
	inc edx
	cmp edx, ebx
	jl walk_through_array

	cmp eax, 0
	jg incorrect
; correct route
	push 1
	pop eax
	ret

incorrect:
	xor eax, eax
	ret
