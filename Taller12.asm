section .data
    prompt db "Ingrese un numero entero: ", 0   ; Mensaje de solicitud
    even_msg db "El numero es par.", 0           ; Mensaje si el número es par
    odd_msg db "El numero es impar.", 0          ; Mensaje si el número es impar
    error_msg db "Entrada no valida. Solo se permiten numeros.", 0 ; Mensaje de error

section .bss
    num resb 10                                  ; Reservar espacio para la entrada del usuario
    result resq 1                                 ; Reservar espacio para el resultado del número entero

section .text
    global _start

_start:
    ; Imprimir el mensaje solicitando un número
    mov rax, 0x1             ; syscall número 1 (write)
    mov rdi, 0x1             ; file descriptor 1 (stdout)
    lea rsi, [prompt]        ; dirección del mensaje
    mov rdx, 25              ; longitud del mensaje
    syscall                  ; llamada al sistema (sys_write)

    ; Leer el número ingresado por el usuario
    mov rax, 0x0             ; syscall número 0 (read)
    mov rdi, 0x0             ; file descriptor 0 (stdin)
    lea rsi, [num]           ; dirección del buffer
    mov rdx, 10              ; longitud máxima del buffer
    syscall                  ; llamada al sistema (sys_read)

    ; Inicializar el número resultante en 0
    xor rbx, rbx             ; Limpiar el registro RBX (usaremos RBX para acumular el número)

    ; Apuntar al primer carácter de la entrada
    lea rsi, [num]           ; Apuntamos al primer carácter del buffer

convert_loop:
    ; Leer un carácter de la cadena
    movzx rax, byte [rsi]    ; Cargar el siguiente carácter
    test rax, rax            ; Verificar si es el final de la cadena (NULL)
    jz check_parity          ; Si es NULL (fin de la cadena), verificar si es par o impar

    ; Verificar si el carácter es un número
    cmp rax, '0'             ; Comparar con '0'
    jl invalid_input         ; Si es menor que '0', entrada inválida
    cmp rax, '9'             ; Comparar con '9'
    jg invalid_input         ; Si es mayor que '9', entrada inválida

    ; Convertir el carácter de ASCII a número
    sub rax, '0'             ; Convertir de ASCII a número

    ; Acumular el número (multiplicamos por 10 y sumamos el nuevo dígito)
    imul rbx, rbx, 10        ; Multiplicar el número acumulado por 10
    add rbx, rax             ; Sumar el nuevo dígito

    inc rsi                  ; Avanzar al siguiente carácter
    jmp convert_loop         ; Continuar el ciclo de conversión

check_parity:
    ; Verificar si el número es par o impar
    test rbx, 1              ; Verificar el bit menos significativo de RBX (si es 0, es par)
    jz even                  ; Si el bit menos significativo es 0, es par

    ; Si el número es impar, imprimir el mensaje
    mov rax, 0x1             ; syscall número 1 (write)
    mov rdi, 0x1             ; file descriptor 1 (stdout)
    lea rsi, [odd_msg]       ; Dirección del mensaje impar
    mov rdx, 20              ; Longitud del mensaje impar
    syscall                  ; Llamada al sistema (sys_write)
    jmp _exit                 ; Salir del programa

even:
    ; Si el número es par, imprimir el mensaje
    mov rax, 0x1             ; syscall número 1 (write)
    mov rdi, 0x1             ; file descriptor 1 (stdout)
    lea rsi, [even_msg]      ; Dirección del mensaje par
    mov rdx, 18              ; Longitud del mensaje par
    syscall                  ; Llamada al sistema (sys_write)

_exit:
    ; Salir del programa
    mov rax, 60              ; syscall número 60 (exit)
    xor rdi, rdi             ; Código de salida 0
    syscall                  ; Llamada al sistema (sys_exit)

invalid_input:
    ; Si la entrada no es válida, mostrar mensaje de error
    mov rax, 0x1             ; syscall número 1 (write)
    mov rdi, 0x1             ; file descriptor 1 (stdout)
    lea rsi, [error_msg]     ; Dirección del mensaje de error
    mov rdx, 38              ; Longitud del mensaje de error
    syscall                  ; Llamada al sistema (sys_write)
    jmp _exit                 ; Salir del programa
