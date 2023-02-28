#include "positions.h"
.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */

add_vect:
	pushl %ebp
	movl %esp, %ebp
// just reading from the stack
	movl 16(%ebp), %ecx // length
	movl 8(%ebp), %eax  // first vector
	movl 12(%ebp), %ebx // second vector
	movl 20(%ebp), %edi // destination

// first let's just walk through both arrays at once and
// sum them up
	xor %edx, %edx      // our vector position
sum_up:
	movl (%eax, %edx, 4), %esi
	addl (%ebx, %edx, 4), %esi
	movl %esi, (%edi, %edx, 4)
	inc %edx
	cmp %ecx, %edx
	jl sum_up

// now calculate the scale (n * position) / 10
	movl $FIRST_POSITION, %eax
	xor %edx, %edx  /* need it zero since we are working only
	                 * with the lower 4 bytes
					 */
	mul %ecx
	movl $10, %ebx
	div %ebx
	movl $FIRST_VALUE, %ebx
	sub %ebx, (%edi, %eax, 4)
// similarly for the other positions...

	movl $SECOND_POSITION, %eax
	xor %edx, %edx
	mul %ecx
	movl $10, %ebx
	div %ebx
	movl $SECOND_VALUE, %ebx
	subl %ebx, (%edi, %eax, 4)

	movl $THIRD_POSITION, %eax
	xor %edx, %edx
	mul %ecx
	movl $10, %ebx
	div %ebx
	movl $THIRD_VALUE, %ebx
	subl %ebx, (%edi, %eax, 4)

	leave
	ret
