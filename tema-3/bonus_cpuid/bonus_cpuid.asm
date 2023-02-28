section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string

cpu_manufact_id:
	enter 	0, 0
	pusha
	mov	eax, 00h; this will, according to documentation,
	            ; put in little endian in ECX, EDX, EBX
				; the vendor ID. 
	cpuid
	mov eax, [ebp + 8]; current position in id_string
	mov [eax], ebx; since it is already in little endian
	              ; we can take all 4 bytes at once
	add eax, 4
	mov [eax], edx
	add eax, 4
	mov [eax], ecx
	add eax, 4
	popa
	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise

features:
	enter 	0, 0
	pusha
	mov eax, 1; this "parameter" to cpuid will make cpuid put
	          ; feature flags in ECX and EDX
	cpuid
; getting VMX. According to documentation, it should be in ECX's
; 6th bit
	mov edx, ecx
	shr edx, 5
	and edx, 1
	mov eax, [ebp + 8]; get vmx
	mov [eax], edx
; getting RDRAND. According to documentation, it should be in ECX's
; 31th bit
	mov edx, ecx
	shr edx, 30
	and edx, 1
	mov eax, [ebp + 12]; get rdrand 
	mov [eax], edx
; getting AVX. According to documentation, it should be in ECX's
; 29th bit
	mov edx, ecx
	shr edx, 28
	and edx, 1
	mov eax, [ebp + 16]; get avx
	mov [eax], edx
	popa
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters

l2_cache_info:
	enter 	0, 0
	pusha
	mov eax, 80000006h; this "parameter" to cpuid will make cpuid put
	                  ; L2 cache details in the ECX register
	cpuid

; cache line size should be saved in the lower 8 bits of ecx
; according to documentation
	mov ebx, ecx
	and ebx, 255
	mov edx, [ebp + 8]; get line_size
	mov [edx], ebx
; cache size should be saved in the upper 16 bits of ecx
; according to documentation
	mov ebx, ecx
	shr ebx, 16
	mov edx, [ebp + 12]; get cache_size
	mov [edx], ebx
	popa	
	leave
	ret
