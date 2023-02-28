section .text
	global vectorial_ops

;; void vectorial_ops(int s, int A[], int B[], int C[], int n, int D[])
;  
;  Compute the result of s * A + B .* C, and store it in D. n is the size of
;  A, B, C and D. n is a multiple of 16. The result of any multiplication will
;  fit in 32 bits. Use MMX, SSE or AVX instructions for this task.

; different OSes use different calling conventions. Linux here
; will save the arguments s,   A,   B,   C,   n,  D into
;                         rdi, rsi, rdx, rcx, r8, r9
; Concept: vectorisation uses xmm[1..15] which are 128 bits
; long and can hold 4 integers at once in a single register
; therefore you can do the same operation 

vectorial_ops:
	push		rbp
	mov		rbp, rsp
walk_through:
	movdqa xmm1, [rdx + 4 * r8 - 16]; move the B in xmm1
	pmulld xmm1, [rcx + 4 * r8 - 16]; now we have B .* C in xmm1

; I couldn't find any operation that multiplies
; with a scalar. So I have to insert s at every position in
; xmm2 (therefore effectively calculating [s s s s] * A)
	pinsrd xmm2, edi, 0
	pinsrd xmm2, edi, 1
	pinsrd xmm2, edi, 2
	pinsrd xmm2, edi, 3
	pmulld xmm2, [rsi + 4 * r8 - 16]; now we have s * A in xmm2

	paddd xmm1, xmm2; now we have s * A + B .* C in xmm1
	movdqa [r9 + 4 * r8 - 16], xmm1; move the result into D
	sub r8, 4
	cmp r8, 0
	jg walk_through

	leave
	ret
