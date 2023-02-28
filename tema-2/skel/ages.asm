; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; TODO: Implement ages
    ;; FREESTYLE STARTS HERE
    xchg edx, ecx; I want ecx as loop counter to use for loop
walk_through_array:
    ; first we calculate the difference in years.
    mov eax, [esi + my_date.year]; current year

    ;year in date
    sub eax, [edi + ecx * my_date_size - my_date_size + my_date.year]

    ; then we see if the current month is smaller or (in case of equality)
    ; the day is smaller. Then we subtract one.

    mov bx, [esi + my_date.month]
    cmp bx, [edi + ecx * my_date_size - my_date_size + my_date.month]
    jg finish_calculating_age
    je compare_days
    dec eax;
    jmp finish_calculating_age

compare_days:
    mov bx, [esi + my_date.day]
    cmp bx, [edi + ecx * my_date_size - my_date_size + my_date.day]
    jge finish_calculating_age
    dec eax;
    jmp finish_calculating_age
    
finish_calculating_age:
    cmp eax, 0; if it's smaller than 0 put 0 instead
    jge update_array
    xor eax, eax

update_array:
    mov [edx + ecx * 4 - 4], eax
    loop walk_through_array

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
