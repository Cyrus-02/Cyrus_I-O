global _start

section .data
      LF equ 10
      SYS_EXIT equ 60
      NULL equ 0
      STDOUT equ 1
      SYS_WRITE equ 1
      STDIN equ 0
      SYS_READ equ 0

      menu db 10, "************MENU***********" , 10, "[1] Convert to Minutes", 10, "[2] Convert to Hours", 10, "[0] Exit", 10, "***************************", 10, "", 10, "Choice: " 
	menuLength equ $-menu

      input db "Enter time in seconds (5digits): "
      inputLength equ $-input

      

      newLine db LF, NULL
      newLineLen equ $-newLine

      choice db 0
      convertedInput dd 0
      minutes db 60
      Hours equ 60
      ten db 10
      temp dd 0;
      remain db 0;

section .bss
      seconds resb 5

section .text
_start: 
      mov rax, SYS_WRITE
      mov rdi, STDOUT
      mov rsi, menu
      mov rdx, menuLength
      syscall

      mov rax, SYS_READ
      mov rdi, STDIN
      mov rsi, choice
      mov rdx, 2
      syscall


      cmp byte[choice], "0"
      je exit_here
      cmp byte[choice], "1"
      je convert_to_minutes
      cmp byte[choice], "2"
      je convert_to_hours

      jmp _start

convert_to_minutes:
      mov rax, SYS_WRITE
      mov rdi, STDOUT
      mov rsi, input
      mov rdx, inputLength
      syscall
      
      mov rax, SYS_READ
      mov rdi, STDIN
      mov rsi, seconds
      mov rdx, 6
      syscall

      mov rcx, 5
      mov rbx, 0

convert:
      sub byte[seconds+rbx], 30h
      inc rbx
      loop convert

      mov ebx, 10000
      mov dword[convertedInput], 0
      
      mov ecx, dword[convertedInput]
      mov al, byte[seconds]
      mul ebx
      mov dword[temp], eax
      add ecx, dword[temp]

      mov ebx, 1000
      mov rax, 0
      mov al, byte[seconds+1]
      mul ebx
      mov dword[temp], eax
      add ecx, dword[temp]

      mov ebx, 100
      mov rax, 0
      mov al, byte[seconds+2]
      mul ebx
      mov dword[temp], eax
      add ecx, dword[temp]

      mov ebx, 10
      mov rax, 0
      mov al, byte[seconds+3]
      mul ebx
      mov dword[temp], eax
      add ecx, dword[temp]

      mov ebx, 1
      mov rax, 0
      mov al, byte[seconds+4]
      mul ebx
      mov dword[temp], eax
      add ecx, dword[temp]

divide:
      mov ebx, 0
      mov bl, byte[minutes] 
      mov rax, 0
      mov eax, ecx
      div ebx
      mov dword[temp], eax

back:
      mov bl, 10
      mov rax, 0
      mov eax, dword[temp]
      div ebx
      

      jmp exit_here

convert_to_hours:
      mov rax, SYS_WRITE
      mov rdi, STDOUT
      mov rsi, input
      mov rdx, inputLength
      syscall
      
      mov rax, SYS_READ
      mov rdi, STDIN
      mov rsi, seconds
      mov rdx, 6
      syscall

      jmp _start

exit_here:
      mov rax, SYS_EXIT
      xor rdi, rdi
      syscall
