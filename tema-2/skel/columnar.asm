section .data
    extern len_cheie, len_haystack

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; TODO: Implement columnar_transposition
    ;; FREESTYLE STARTS HERE
    xor ecx, ecx; current collumn
create_cipher:
    mov edx, [edi + ecx * 4]; position in haystack
write_collumn:
    ;first we figure out if the position is valid
    cmp edx, [len_haystack]
    jge increase_collumn

    ; we will use ebx as a pointer inside ciphertext
    mov al, [esi + edx]
    mov [ebx], al; update ciphertext
    inc ebx
    add edx, [len_cheie]
    jmp write_collumn

increase_collumn:
    inc ecx
    cmp ecx, [len_cheie]
    jl create_cipher

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY