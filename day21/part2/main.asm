        global _start

        section .data
input_file:
        db "../input" ; we're trying to read "../input"

        section .bss
buffer:
        resb 62 ; the input data can be at most 62 bytes long
; memo: ; pcs .. pcp .. pps .. ppp .. rs .. r
;         resz 8388608
player_one_position:
        resb 1
player_two_position:
        resb 1
result:
        resq 1

        section .text
_start:
        ; open the file
        mov rax, 2 ; rax = 2, the syscall for opening
        mov rdi, input_file ; the path to the file to open
        xor rdx, rdx ; rdx = 0, we want readonly mode
        syscall

        ; read the file contents
        mov rdi, rax ; move the file descriptor resulting from the open
        mov rax, 0 ; rax = 0, the syscall number for read
        mov rsi, buffer ; read to the buffer
        mov rdx, 62 ; read 62 bytes, the size of the buffer
        syscall

        ; close the file
        mov rax, 3 ; rax = 3, the syscall for closing
        ; rdi already contains the file descriptor cause we just read it
        syscall

set_initial_values:
        movzx rax, byte [buffer + 28] ; load the 28th character of the input text
        sub rax, 0x30 ; turn it into the actual numerical value
        cmp al, 1 ; check if it's 1
        jne set_player_one ; if it's not, set the value
        movzx rbx, byte [buffer + 29] ; load the 29th character of the input text
        cmp bl, 0x30 ; check if it's the digit 0
        mov rcx, 10
        cmove rax, rcx ; if it is, set the value to 0
set_player_one:
        mov [player_one_position], al ; put it in the player 1 position memory location
        je set_player_two_abnormal ; if we got here with an equal value, the first digit was 1 and the second was 0, so we have to offset the second bytes by 1

set_player_two_normal:
        movzx rax, byte [buffer + 58] ; load the 58th character of the input text
        sub rax, 0x30 ; turn it into the actual numerical value
        cmp al, 1 ; check if it's 1
        jne set_player_two ; if it's not, set the value
        movzx rbx, byte [buffer + 59] ; load the 59th character of the input text
        cmp bl, 0x30 ; check if it's the digit 0
        mov rcx, 10
        cmove rax, rcx ; if it is, set the value to 0
        jmp set_player_two

set_player_two_abnormal:
        movzx rax, byte [buffer + 59] ; load the 59th character of the input text
        sub rax, 0x30 ; turn it into the actual numerical value
        cmp al, 1 ; check if it's 1
        jne set_player_two ; if it's not, set the value
        movzx rbx, byte [buffer + 60] ; load the 60th character of the input text
        cmp bl, 0x30 ; check if it's the digit 0
        mov rcx, 10
        cmove rax, rcx ; if it is, set the value to 0
set_player_two:
        mov [player_two_position], al ; put it in the player 1 position memory location

first_call:
        ; push the values for the first call, everything is zero except the positions
        push 0
        movzx rax, byte [player_two_position]
        push rax
        push 0
        movzx rax, byte [player_one_position]
        push rax
        push 0
        push 0

        ; make the call
        call f

        ; pop the results
        pop rax
        pop rbx

        ; move the greater value into rax
        cmp rbx, rax
        cmovg rax, rbx

        ; make that the result
        mov [result], rax

        ; display result
        jmp format_result

f: ; expects stack to contain pps, ppp, pcs, pcp, rs, r
        pop r15 ; store return address in r15

        ; put r in r8
        pop r8

        cmp r8, 2
        jle f_i_thought_it_was_simple_recurse ; if it's less than or equal to 2, preform a simple recursion

        ; unpack necessary values things
        pop r9 ; rs
        pop r10 ; old pcp
        pop r11 ; old pcs

        ; increase pcp
        mov r14, r10 ; r14 is the new pcp
        add r14, r9 ; add rs to pcp
        mov rax, r14 ; move result to rax
        mov rbx, 10 ; divisor and moved go in rbx
        cqo ; prepare rdx?
        idiv rbx ; divide by 10
        cmp rdx, 0 ; check if the remainder is 0
        cmove rdx, rbx ; if it is, set it to 10
        mov r14, rdx ; the result back into r14

        ; increase pcs
        mov rax, r11 ; rax is the new pcs
        add rax, r14 ; add new pcp to pcs

        ; mov [result], r14
        ; jmp format_result

        cmp rax, 9
        jge f_return_one ; if the new score is greater than or equal to 21, return 1 for the current player

        ; if we're still here, we're swapping values and making a recursive call, unlike in the "simple" case, we have to create a whole new stack "frame", if that's the right word

        ; get out other values
        pop r12
        pop r13

        ; put everything back the way we found it
        push r13
        push r12
        push r11
        push r10
        push r9
        push r8

        ; also stick the return address on there
        push r15

        ; then stick the new values on
        ; push rax ; new pcs, which is becoming the pps
        push 21
        push r14 ; new pcp, which is becoming the ppp
        ; push r13 ; make pps pcs
        push 21
        push r12 ; make ppp pcp
        ; things reset at 0
        push 0
        push 3

        call f ; make the call, we have two new values

        ; pop results
        pop rax
        pop rbx

        ; remove now uneeded arguments from stack
        pop rcx
        pop rcx
        pop rcx
        pop rcx
        pop rcx
        pop rcx

        ; get original return value back
        pop r15

        ; put results back in reversed order
        push rax
        push rbx

        push r15
        ret

f_return_one:
        ; put things back
        push r10
        push r11
        push r9
        push r8

        ; return just 1 for the current player
        push 1
        push 0

        push r15
        ret

f_i_thought_it_was_simple_recurse: ; return the sum of recursing with r incremented by 1 and rs incremented by 1 through 3
        inc r8 ; increment the rolls
        pop r9 ; put rs in r9
        inc r9 ; increment the sum so it's 1 greater

        ; save return address before arguments on stack
        pop r10
        pop r11
        pop r12
        pop r13
        push r15
        push r13
        push r12
        push r11
        push r10
        push r9
        push r8

        call f ; produces two new values on the stack, each containing the wins of the previous players

        ; store results in rax and rbx respectively
        pop rax ; in the base case, stores 0
        pop rbx

        ; pop everything and put the results between the return address and the arguments on the stack
        pop r8
        pop r9
        pop r10
        pop r11
        pop r12
        pop r13
        push rbx
        push rax ; now the zero is stored as the second result on the stack
        push r13
        push r12
        push r11
        push r10
        inc r9 ; increment the sum so it's 2 greater
        push r9
        push r8

        call f ; again, 2 more values on the stack to deal with

        ; put results in rax and rbx again
        pop rax ; contains zero in the base case
        pop rbx

        ; pop everything and add the results to the results currently in the stack
        pop r8
        pop r9
        pop r10
        pop r11
        pop r12
        pop r13

        ; pop old results, add, and push new results
        pop rcx ; contains zero given the previous base case
        pop rdx
        ; we don't quite get down to the return value so it stays beneath here
        add rcx, rax ; the base zero pairs
        add rdx, rbx
        push rdx
        push rcx ; zero pair goes back second

        ; put things back
        push r13
        push r12
        push r11
        push r10
        inc r9 ; increment the sum so it's 3 greater
        push r9
        push r8

        call f

        ; put results in rax and rbx again
        pop rax ; again zero in base case
        pop rbx

        ; pop everything and add the results to the results currently in the stack
        pop r8
        pop r9
        pop r10
        pop r11
        pop r12
        pop r13

        ; pop old results, add, and push new results
        pop rcx ; zero
        pop rdx
        add rcx, rax ; zero pairs
        add rdx, rbx

        pop r15 ; save the stack cause its going back where it belongs

        ; put things back
        push r13
        push r12
        push r11
        push r10
        add r9, -3 ; reset r8
        push r9
        dec r8 ; reset r8
        push r8

        push rdx
        push rcx ; zero goes on second

        push r15
        ret

format_result:
        mov rbx, 10 ; we're converting to base 10
        mov rax, [result]
        mov r8, 8 ; we're printing 8 bits
        xor rcx, rcx ; clear rcx
format_loop:
        cmp rax, 0
        je save_formatted_result
        cqo ; prep for division
        idiv rbx ; divide by 10
        shl rcx, 8 ; shift previous bits over
        add rcx, rdx ; add to result
        add rcx, 0x30 ; the offset to get to the numerical character
        dec r8
        cmp r8, 0
        jne format_loop

save_formatted_result:
        mov [result], rcx

print_result:
        mov rax, 1 ; system call for write
        mov rdi, 1 ; file handle 1 is stdout
        mov rsi, result ; address of string to output
        mov rdx, 8 ; number of bytes
        syscall ; invoke operating system to do the write

exit:
        mov rax, 60 ; system call for exit
        xor rdi, rdi ; exit code 0
        syscall ; invoke operating system to exit
