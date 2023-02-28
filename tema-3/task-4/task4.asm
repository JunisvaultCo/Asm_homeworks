section .text

global expression
global term
global factor

; concept: walk the expression from left to right (the
; index i gets increased with 1 every time)
; First, try to read the "lesser" token (if you are inside expression,
; read a term), then check if indeed the current position is the wanted
; symbol (for expression, it is + or -). If it is, read another "lesser
; token". Otherwise, return.

; `factor(char *p, int *i)`
;       Evaluates "(expression)" or "number" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression

factor:
        push    ebp
        mov     ebp, esp
        mov ebx, [ebp + 8]; read the first term
        mov ecx, [ebp + 12]; read the position
; let's verify if the first term is '(' so as to
; see if it is (expression) or number
        mov eax, [ecx]
        xor edx, edx
        mov dl, [ebx + eax]
        cmp edx, '('
        jne read_number_prep
        
        inc dword [ecx]; don't need the bracket anymore
        push ecx
        push ebx
        call expression
        pop ebx
        pop ecx

        inc dword [ecx]; skip the ')' 
        leave
        ret
read_number_prep:
        xor edi, edi; our number
read_number:
; just do the classic edi = edi * 10 + 'digit' - '0'
        xor edx, edx; make edx 0 since we are working with only 4 bytes
        mov eax, 10
        imul edi
        mov edi, eax; edi = edi * 10 done

        mov eax, [ecx]     ; in order to properly take care
        xor edx, edx       ; of the overflow, I will first
        mov dl, [ebx + eax]; zero all the 32bits then add
                           ; the 
        sub dl, '0'
        add edi, edx

        inc dword [ecx]; move onward
;now verify if the next one is a digit. if it isn't, stop
        mov edx, [ecx]
        xor eax, eax        ; similarly I would like to do
        mov al, [ebx + edx] ; the comparison on 32 bits in case
        cmp eax, '0'        ; the characters are negative as numbers
        jl end
        cmp eax, '9'
        jg end
        jmp read_number
end:
        mov eax, edi
        leave
        ret

; `term(char *p, int *i)`
;       Evaluates "factor" * "factor" or "factor" / "factor" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression

term:
        push    ebp
        mov     ebp, esp
;first, just call the factor
        push dword [ebp + 12]
        push dword [ebp + 8]
        call factor
        pop ebx; first element
        pop ecx; current position

        push eax; wouldn't want to lose the first factor

next_factor:
; now verify if we are dealing with * or /
        xor edx, edx
        mov eax, [ecx]
        mov dl, [ebx + eax]
        cmp edx, '*'
        jne is_division
; first call factor so we have with what to multiply
; and then multiply
        inc dword [ecx]
        push ecx
        push ebx
        call factor
        add esp, 8
        pop edi; get back the first factor
        xor edx, edx     ; yes... edx is technically empty
        cmp eax, 0       ; HOWEVER, in signed numbers edx is all 1
        jge positive_mul ; and this is what these jumps are supposed to fix
        not edx
positive_mul:
        imul edi
        jmp increment
is_division:
        cmp edx, '/'
        jne end_term
; first call factor so we have with what to divide
; and then divide
        inc dword [ecx]
        push ecx
        push ebx
        call factor
        add esp, 8
        pop edi; get back the first factor
        xor edx, edx
        cmp edi, 0
        jge positive_div
        not edx
positive_div:
        xchg eax, edi
        idiv edi
increment:
        push eax; wouldn't want to lose the division
        jmp next_factor
end_term:
        pop eax
        leave
        ret

; `expression(char *p, int *i)`
;       Evaluates "term" + "term" or "term" - "term" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression

expression:
        push    ebp
        mov     ebp, esp
;first, just call the term
        push dword [ebp + 12]
        push dword [ebp + 8]
        call term
        pop ebx; first element
        pop ecx; current position

        push eax; wouldn't want to lose the first term

next_expression:
; now verify if we are dealing with + or -
        xor edx, edx
        mov eax, [ecx]
        mov dl, [ebx + eax]
        cmp edx, '+'
        jne is_subtraction
; first call term so we have with what to add
; and then add if it is the case
        inc dword [ecx]
        push ecx
        push ebx
        call term
        add esp, 8
        pop edx; get back the first term
        add eax, edx
        jmp increment_exp
is_subtraction:
        cmp edx, '-'
        jne end_expression
; first call term so we have with what to subtract
; and then subtract
        inc dword [ecx]
        push ecx
        push ebx
        call term
        add esp, 8
        pop edx; get back the sum
        xchg eax, edx
        sub eax, edx
increment_exp:
        push eax; wouldn't want to lose the sum
        jmp next_expression
end_expression:
        pop eax

        leave
        ret
