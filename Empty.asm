TITLE Program Template     (template.asm)
; Author: Duncan M. Freeman
; Class: CS 271
; Date: 2/7/20
; Description: Homework #3
INCLUDE Irvine32.inc

USER_NAME_MAX_LEN equ 100
NUM_ENTRIES equ 5
NUM_ENTRIES_FLOAT equ 5.0

.data
    title_string_1 BYTE "Integer and Floating-Point Arithmetic", 0
    title_string_2 BYTE "Programmed by Duncan Freeman", 0
    name_prompt_string BYTE "What is your name? ", 0
    hello BYTE "Hello, ", 0
    float_arith_prompt_string BYTE "Would you like to use integer (0) or floating point (1) arithmetic? ", 0 
    prompt_finished BYTE "Do you want to perform another calculation? Please enter 0 for no or 1 for yes: ", 0
    instructions BYTE "Please enter 5 numbers below, each ending with the enter key:", 0
    sum_msg BYTE "Sum of entered numbers: ",0
    average_msg BYTE "Average of entered numbers: ",0
    user_name DWORD USER_NAME_MAX_LEN DUP(0)
    num_entries_word QWORD 1 DUP(NUM_ENTRIES_FLOAT) 
    goodbye BYTE "See ya later alligator!", 0

.code
main PROC
; Introduction
    mov edx, OFFSET title_string_1
    call WriteString
    call Crlf

    mov edx, OFFSET title_string_2
    call WriteString
    call Crlf

    ; Prompt for user name
    mov edx, OFFSET name_prompt_string
    call WriteString
    mov edx, OFFSET user_name
    mov ecx, USER_NAME_MAX_LEN
    call ReadString

    ; Write hello, <name>
    mov edx, OFFSET hello
    call WriteString
    mov edx, OFFSET user_name
    call WriteString
    call Crlf

    ; Ask if they want floating point arithmetic
    PromptArithmetic:
        ; Prompt
        mov edx, OFFSET float_arith_prompt_string
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
        ; Print instructions
        mov edx, OFFSET instructions 
        call WriteString
        call Crlf

        ; Read NUM_ENTRIES inputs into the floating point stack
        mov ecx, NUM_ENTRIES
        float_read_loop:
            call ReadFloat
            loop float_read_loop

        ; Sum inputs into the top of the stack
        fldz
        mov ecx, NUM_ENTRIES
        float_sum_loop:
            fadd
            loop float_sum_loop

        ; Calculate average
        fld st(0)
        fld num_entries_word
        fdivp

        ; Display average
        mov edx, OFFSET average_msg
        call WriteString
        call WriteFloat
        call Crlf

        fstp st(0)

        ; Display sum
        mov eax, ecx
        mov edx, OFFSET sum_msg
        call WriteString
        call WriteFloat
        call Crlf
        
        ; Clear the floating-point stack
        mov ecx, NUM_ENTRIES + 1
        clear_fp_stack_loop:
            fstp st(0)
            loop clear_fp_stack_loop

        jmp EndPrompt

    ; Average integers
    Integers:
        ; Print instructions
        mov edx, OFFSET instructions 
        call WriteString
        call Crlf

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
        mov edx, OFFSET average_msg
        call WriteString
        call WriteDec
        call Crlf

        ; Display sum
        mov eax, ecx
        mov edx, OFFSET sum_msg
        call WriteString
        call WriteDec
        call Crlf

        jmp EndPrompt

    EndPrompt:
        ; Prompt if the user wants to do it again
        mov edx, OFFSET prompt_finished
        call WriteString
        call ReadInt
        ; Decide where to jump
        cmp eax, 1
        je PromptArithmetic
        cmp eax, 0
        je Stop
        jmp EndPrompt

    Stop:
        mov edx, OFFSET goodbye
        call WriteString
        call Crlf
exit

main ENDP
END main
