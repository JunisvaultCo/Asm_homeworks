
section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v

intertwine:
	enter 0, 0
; different OSes use different calling conventions. Linux here
; will save the arguments v1, n1, v2, n2, v into rdi, rsi, rdx, rcx, r8

; concept: two pointer, we move through both arrays,
; keeping a pointer to the element that isn't yet added.
; (we use rax and rcx for that). We also make sure that
; those pointers are actually valid addresses, by keeping
; track of how many elements haven't been added yet.

walk_through_both:
	mov eax, [rdi]
	mov [r8], eax
	add r8, 4

	mov eax, [rdx]
	mov [r8], eax
	add r8, 4
; just incrementing pointers and lengths
	add rdi, 4
	add rdx, 4
	dec rsi
	dec rcx
; verifying condition (n1 > 0 && n2 > 0)

	cmp rsi, 0
	jle walk_through_first
	cmp rcx, 0
	jle walk_through_first
	jmp walk_through_both

walk_through_first:
; now verify if there are any left
	cmp rsi, 0
	jle walk_through_second
	jmp one_pointer
walk_through_second:
	cmp rcx, 0
	jle done
; preparing for one_pointer walk
	mov rdi, rdx
	mov rsi, rcx
; this expects the remaining vector information
; to be in rdi, rsi (current not added and amount
; remaining, respectively).
one_pointer:
	mov eax, [rdi]
	mov [r8], eax
	add rdi, 4
	add r8, 4
	dec rsi
	cmp rsi, 0
	jg one_pointer
done:
	leave
	ret
