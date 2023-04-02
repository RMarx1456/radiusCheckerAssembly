section .data
rad DQ 10.0
xOffset DQ 3.0
yOffset DQ 2.0

global failMsg
 failMsg db '(10, 1) is not inside a circle at (3,2) with a radius of ten', 0
global passMsg
 passMsg db '(10, 1) is inside a circle at (3,2) with a radius of ten', 0
 
len1 equ $- failMsg
len2 equ $- passMsg

guess dq 8.0

twox dq 2.0

zero dq 0.0

section .bss
xCord DQ 1.0
yCord DQ 10.0




section .text


global main

main:
    ; move x, y coordinate to xmm0, 1
    movsd xmm0, [xCord]
    movsd xmm1, [yCord]
    subsd xmm0, [xOffset]
    subsd xmm1, [yOffset]
    
    ;calculate # in sqroot
    
    ;x
    movsd xmm3, xmm0
    mulsd xmm3, xmm3
    movsd xmm2, xmm3
    xorps xmm3, xmm3 ;clear register
    
    ;y
    movsd xmm3, xmm1
    mulsd xmm3, xmm3
    addsd xmm2, xmm3
    xorps xmm3, xmm3 ;clear register
    
    ; 0,1 holds coordinates, 2 holds sqrt#
    
    ; ready xmm3 for loop
    
    movsd xmm3, qword [guess]
    mov ecx, 3
    loop_iteration:
    ; 4 for x^2 - guess, 5 for 2x
        movsd xmm4, xmm3
        movsd xmm5, xmm3
        ;x^2 - guess
        mulsd xmm4, xmm4
        subsd xmm4, xmm3
        ;2x
        mulsd xmm5, [twox]
        ;push f(x) to xmm3
        movsd xmm3, xmm4
        ;divide f(x) by f'(x)
        divsd xmm3, xmm5
        
    loop loop_iteration
    ;clear xmm4 and xmm5 registers
    xorps xmm4, xmm4
    xorps xmm5, xmm5
        
    ;move dereferenced radius to xmm5
    movsd xmm5, qword [rad]
    
    ;compare approximated root to rad
    ucomisd xmm3, xmm5
    
    jbe good
    
    ja bad
    
    
    good:
    mov rdi, 1
    mov rsi, passMsg
    mov rdx, len2
    mov rax, 1
    syscall
    jmp end
    
    bad:
    mov rdi, 1
    mov rsi, failMsg
    mov rdx, len1
    mov rax, 1
    syscall
    jmp end
    
    end:
    mov rax, 60
    xor rdi, rdi
    syscall
        
    
    