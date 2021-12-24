        global _start

        section .data
input_file:
        db "../input" ; we're trying to read "../input"
player_one_score:
        dq 0
player_two_score:
        dq 0
rolls:
        dq 0
i:
        dq 0

        section .bss
buffer:
        resb 62 ; the input data can be at most 62 bytes long
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

game_loop:
        ; player 1 rolls
        movzx rax, byte [player_one_position] ; load player position into rax
        mov rbx, [i] ; load the roll value into rbx
        call inc_loop_100_rbx
        add rax, rbx
        call inc_loop_100_rbx
        add rax, rbx
        call inc_loop_100_rbx
        add rax, rbx
        mov [i], rbx ; save resulting i back

        ; player 1 new position and score
        cqo ; initialize rdx with sign extended rax
        mov rcx, 10 ; used for division and conditional m ove
        idiv rcx ; divide current position by 10
        cmp rdx, 0 ; check if the remainder is 0
        cmove rdx, rcx ; if it is, bump it to 10
        mov [player_one_position], dl ; save player position
        mov rbx, [player_one_score] ; load player one score to rbx
        add rbx, rdx ; add position to score
        mov [player_one_score], rbx ; save new score
        cmp rbx, 1000 ; check the current score
        jge player_one_wins ; jump to player 1 win label if their new score is greater than or equal

        ; player 2 rolls
        movzx rax, byte [player_two_position] ; load player position into rax
        mov rbx, [i] ; load the roll value into rbx
        call inc_loop_100_rbx
        add rax, rbx
        call inc_loop_100_rbx
        add rax, rbx
        call inc_loop_100_rbx
        add rax, rbx
        mov [i], rbx ; save resulting i back

        ; player 2 new position and score
        cqo ; avoid overflows or something?
        mov rcx, 10 ; used for division and conditional m ove
        idiv rcx ; divide current position by 10
        cmp rdx, 0 ; check if the remainder is 0
        cmove rdx, rcx ; if it is, bump it to 10
        mov [player_two_position], dl ; save player position
        mov rbx, [player_two_score] ; load player one score to rbx
        add rbx, rdx ; add position to score
        mov [player_two_score], rbx ; save new score
        cmp rbx, 1000 ; check the current score
        jge player_two_wins ; jump to player 1 win label if their new score is greater than or equal

        jmp game_loop

player_one_wins:
        mov rax, [player_two_score]
        mov rbx, [rolls]
        imul rax, rbx
        mov [result], rax

        jmp format_result

player_two_wins:
        mov rax, [player_one_score]
        mov rbx, [rolls]
        imul rax, rbx
        mov [result], rax

        jmp format_result

; {{{ functions
inc_loop_100_rbx:
        inc qword [rolls]

        inc rbx
        cmp rbx, 101
        jne skip_wrap
        mov rbx, 1
skip_wrap:
        ret
; }}}

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
