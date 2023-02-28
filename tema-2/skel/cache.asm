;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS


section .text
    global load

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; TODO: Implement load
    ;; FREESTYLE STARTS HERE
    ; first go through the cache looking at tags
    xor ecx, ecx ; position in tags
    shr edx, 3 ; lose last 3 bits
find_tag:
    mov eax, [ebx + ecx * 4]; get current tag
    cmp eax, edx; compare with current tag
    jne increment_tag_pos

    ; we found the required tag so we just extract the byte at the current
    ; line and at the correct offset
    jmp update_register

increment_tag_pos:
    inc ecx
    cmp ecx, CACHE_LINES
    jl find_tag

    ; couldn't find it, so add entry in cache and tags
    mov eax, [ebp + 16] ; get back the cache
    mov ebx, [ebp + 24] ; get back the replace
    mov edx, [ebp + 20] ; get back the address
    shr edx, 3 ; get rid of the last 3 bits
    shl edx, 3 ; move back zeroes
    mov ecx, [edx]
    mov [eax + ebx * CACHE_LINE_SIZE], ecx ; update cache's first 4 bytes
    add edx, 4; next 4 bytes
    mov ecx, [edx]
    mov [eax + ebx * CACHE_LINE_SIZE + 4], ecx ; update cache's last 4 bytes

    mov eax, [ebp + 12] ; get back tags
    shr edx, 3 ; get rid of the last 3 bits
    mov [eax + ebx * 4], edx ; update tag
    mov ecx, [ebp + 24] ; get back the replace

    ; This assumes that the index of the found line is stored in ecx.
    ; In case it doesn't, ripperoni
update_register:
    mov edx, [ebp + 16] ; get back the cache
    lea edx, [edx + ecx * CACHE_LINE_SIZE] ; get the line
    mov eax, [ebp + 20] ; get back the address
    and eax, 7 ; get last 3 bits for offset
    mov dl, [edx + eax] ; get the byte
    mov eax, [ebp + 8] ; get the reg address
    mov [eax], dl
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY


