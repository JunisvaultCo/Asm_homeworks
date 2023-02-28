section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; TODO: Implement rotp
    ;; FREESTYLE STARTS HERE
    xor eax, eax; position in key
walk_through_array:
    mov bl, [esi + ecx - 1]; we're careful since we're working with chars
                           ; so we need to use bl (8 bit register)
    xor bl, [edi + eax]
    mov [edx + ecx - 1], bl 
    inc eax
    loop walk_through_array

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY