section .data
    msg db 'Resultado: ', 0
    newline db 0xA
    
section .bss
    res resb 4
    
section .text
    global _start
    
_start:

    mov eax, 10
    mov ebx, 5
    add eax, ebx
    
    and eax, 0xF
    shl eax, 1
    
    mov [res], eax
    mov eax, 4
    mov ebx, 1 
    mov ecx, msg
    mov edx, 11
    int 0x80
    
    mov eax, [res]
    add eax, '0
    mov [res], eax 
    mov eax, 4
    mov ebx, 1 
    mov ecx, res 
    mov edx, 1 
    int 0x80 
    
    mov eax, 4
    mov ebx, 1 
    mov ecx, newline
    mov edx, 1 
    int 0x80 
   
    mov eax, 1 
    xor ebx, ebx 
    int 0x80 