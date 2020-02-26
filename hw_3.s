%include 'Along32.inc'

; Note that this is NOT MASM code, nor does it use the 
; Ievine libraries. It's just a test bed for concepts.

extern exit

global main

USER_NAME_MAX_LEN equ 100
NUM_ENTRIES equ 5

section .data
    title_string_1 db "Integer and Floating-Point Arithmetic", 0
    title_string_2 db "Programmed by Duncan Freeman", 0
    name_prompt_string db "What is your name? ", 0
    hello db "Hello, ", 0
    float_arith_prompt_string db "Would you like to use integer (0) or floating point (1) arithmetic? ", 0 
    prompt_finished db "Do you want to perform another calculation? Please enter 0 for no or 1 for yes: ", 0
    sum_msg db "Sum of entered numbers: ",0
    average_msg db "Average of entered numbers: ",0

section .bss
    user_name resb USER_NAME_MAX_LEN

section .text
    
main:
    ; Introduction
    mov edx, title_string_1
    call WriteString
    call Crlf

    mov edx, title_string_2
    call WriteString
    call Crlf

    ; Prompt for user name
    mov edx, name_prompt_string
    call WriteString
    mov edx, user_name
    mov ecx, USER_NAME_MAX_LEN
    call ReadString

    ; Write hello, <name>
    mov edx, hello
    call WriteString
    mov edx, user_name
    call WriteString
    call Crlf

    ; Ask if they want floating point arithmetic
    PromptArithmetic:
        ; Prompt
        mov edx, float_arith_prompt_string
        call WriteString
        call ReadInt
        ; Decide where to jump
        cmp eax, 0
        je Integers 
        cmp eax, 1
        je Floats 
        jmp PromptArithmetic

    ; Average floats
    Floats:
        mov eax, 8
        call WriteDec
        call Crlf
        jmp EndPrompt

    ; Average integers
    Integers:
        ; Read NUM_ENTRIES inputs into the stack
        mov ecx, NUM_ENTRIES
        integer_read_loop:
            call ReadInt
            push eax
            loop integer_read_loop

        ; Sum inputs into eax
        mov eax, 0
        mov ecx, NUM_ENTRIES
        integer_sum_loop:
            pop ebx
            add eax, ebx
            loop integer_sum_loop

        ; Compute average
        mov ecx, eax ; ecx = sum (eax)
        mov ebx, NUM_ENTRIES
        cdq ; Sign extend eax in edx
        div ebx ; eax = sum / NUM_ENTRIES

        ; Display average
        mov edx, average_msg
        call WriteString
        call WriteDec
        call Crlf

        ; Display sum
        mov eax, ecx
        mov edx, sum_msg
        call WriteString
        call WriteDec
        call Crlf

        jmp EndPrompt

    EndPrompt:
        ; Prompt if the user wants to do it again
        mov edx, prompt_finished
        call WriteString
        call ReadInt
        ; Decide where to jump
        cmp eax, 1
        je PromptArithmetic
        cmp eax, 0
        je stop
        jmp EndPrompt

stop:
    ; Exit with EXIT_SUCCESS
    mov edi, 0
    call exit
