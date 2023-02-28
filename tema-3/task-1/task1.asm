struc node
	.val: resd 1
	.next: resd 1
endstruc

section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list

sort:
	enter 0, 0
; concept: first find the address of the smallest element
; (with val 1) so that it becomes the head of the list.
; Then for each element who position is already "fixed"
; (we have a correct next field that leads to it), figure
; out its next by looping through the entire array and
; comparing to the val field

; looping for the element with value 1
	mov eax, [esp + 8]             ; get the length of the array
    mov ebx, [esp + 12]            ; get the address of the first element
	lea eax, [ebx + eax * node_size]
	sub eax, node_size             ; now eax stores the address of the last element
find_min:
	mov edx, [eax + node.val]
	cmp edx, 1
	je selection_preparations

	sub eax, node_size
	jmp find_min
; now eax holds the address of the minimum element
selection_preparations:
	mov ecx, eax ; the address of the previous element
selection_sort:
	xor edx, edx
search_next:
	mov edi, [ebx + edx * node_size + node.val]
	dec edi
	cmp edi, [ecx + node.val]; see if it is the next in line
	je found_next
; just increment...
	inc edx
	cmp edx, [esp + 8]; compare with the length of the array
	jl search_next
found_next:
	lea edx, [ebx + edx * node_size]
	mov [ecx + node.next], edx ; save next
	mov ecx, edx
	mov edx, [ecx + node.val]
	cmp edx, [esp + 8]; see if it is last
	jl selection_sort

	leave
	ret
