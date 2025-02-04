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
    test rax, rax       ; check if open was successful
    js .exit            ; if negative, exit
    mov r12, rax        ; save file descriptor in r12

.read_loop:
    ; Read the file
    mov rax, 0          ; syscall: read
    mov rdi, r12        ; file descriptor
    mov rsi, buffer     ; buffer
    mov rdx, 1024       ; buffer size
    syscall
    test rax, rax       ; check if end of file or error
    jle .close_file     ; if zero or negative, close the file
    mov r13, rax        ; number of bytes read

    ; Write to stdout
    mov r14, buffer     ; start of buffer to write

.write_loop:
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, r14        ; buffer to write
    mov rdx, r13        ; number of bytes to write
    syscall
    test rax, rax       ; check if write was successful
    js .close_file      ; if negative, close the file
    add r14, rax        ; move buffer pointer forward
    sub r13, rax        ; decrease remaining bytes to write
    jnz .write_loop     ; if not all bytes were written, try again

    jmp .read_loop      ; repeat the loop

.close_file:
    ; Close the file
    mov rax, 3          ; syscall: close
    mov rdi, r12        ; file descriptor
    syscall

.exit:
    ; Exit the program
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; exit code: 0
    syscall
