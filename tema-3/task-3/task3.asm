global get_words
global compare_func
global sort

section .data
    delims db " ,.", 13, 10, 0

section .text
    extern strtok
    extern strcmp
    extern qsort
    extern strlen

; I can't just use strcmp, since I first
; have to compare the lengths with strlen
; and also dereference the parameters

compare_func:
    enter 0, 0

    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    mov eax, [eax]; dereference parameters
    mov ebx, [ebx]

    push ebx; leaving them on the stack
    push eax; for the strcmp
    
    push ebx
    call strlen
    add esp, 4
    mov edx, eax; moving the length of ebx
    
    pop eax
    push eax; leaving it on the stack for strcmp
    push edx; saving edx just in case
    push eax
    call strlen
    add esp, 4
    mov ecx, eax; moving the length of eax

    pop edx

    sub ecx, edx
    je calling_strcmp
    jl lower
    mov eax, ecx
    add esp, 8; don't need to do the comparison anymore
    leave
    ret
lower:
    mov eax, ecx
    add esp, 8; don't need to do the comparison anymore
    leave
    ret
calling_strcmp:
    call strcmp
    add esp, 8

    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografic

sort:
    enter 0, 0

    push compare_func
    push dword 4         ; size of elements (pointers)
    push dword [ebp + 12]; number of words
    push dword [ebp + 8] ; words
    call qsort
    add esp, 16

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte

get_words:
    enter 0, 0
; just use strtok to break it based on delimiters
    push delims
    push dword [ebp + 8]
    call strtok
    add esp, 8

    mov edx, [ebp + 12]; current element in the array of words
get_tokens:

    mov [edx], eax; update the words with a pointer inside s
    add edx, 4

    push edx; wouldn't want anything to happen to edx
            ; as a result of the call to strtok
    push delims
    push 0; this time it gets called with NULL
    call strtok
    add esp, 8
    pop edx

    cmp eax, 0
    jne get_tokens

    leave
    ret
