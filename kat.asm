section .bss
    buffer resb 1024

section .text
    global _start

_start:
    ; Get the address of the first command-line argument (argv[1])
    mov rsi, [rsp + 16]

    ; Open the file
    mov rax, 2          ; syscall: open
    mov rdi, rsi        ; filename
    mov rsi, 0          ; flags: O_RDONLY
    syscall
    mov rdi, rax        ; file descriptor

    ; Read the file
    mov rax, 0          ; syscall: read
    mov rsi, buffer     ; buffer
    mov rdx, 1024       ; buffer size
    syscall
    mov rdx, rax        ; number of bytes read

    ; Write to stdout
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, buffer     ; buffer
    syscall

    ; Exit the program
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; exit code: 0
    syscall

