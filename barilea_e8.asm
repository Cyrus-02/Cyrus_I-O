global _start

section .data
    menu db 10, "************MENU***********" , 10, "[1] Add Patient", 10, "[2] Edit Patient", 10, "[3] Print Patients", 10, "[4] Exit", 10, "Enter choice: "
    menuLength equ $-menu

    invalidChoice db 10, "Invalid choice!", 10
    invalidChoiceLength equ $-invalidChoice

    fullPrompt db 10, "Record is already full!", 10
    fullPromptLength equ $-fullPrompt

    addCase db 10, "Enter caseID: "		;Use this prompt for add and edit
    addCaseLength equ $-addCase

    addSex db "Enter sex (F - Female, M - Male): "
    addSexLength equ $-addSex

    addStatus db "Enter status (0 - deceased, 1 - admitted, 2 - recovered): " ;Use this prompt for add and edit
    addStatusLength equ $-addStatus

    addDate db "Enter date admitted (mm/dd/yyyy): "
    addDateLength equ $-addDate

    printCase db 10, "CaseID: "
    printCaseLength equ $-printCase

    printSex db 10, "Sex: "
    printSexLength equ $-printSex

    printStatus db 10, "Status: "
    printStatusLength equ $-printStatus

    printDate db 10, "Date Admitted: "
    printDateLength equ $-printDate

    cannotEdit db "Cannot edit records of a deceased patient.", 10
    cannotEditLength equ $-cannotEdit

    cannotFind db "Patient not found!", 10
    cannotFindPrompt equ $-cannotFind

    newLine db 10
    newLineLength equ $-newLine

    LF equ 10
    SYS_EXIT equ 60
    NULL equ 0
    STDOUT equ 1
    SYS_WRITE equ 1
    STDIN equ 0
    SYS_READ equ 0

    choice db 0
    
    patient_record equ 38
    patient_caseid equ 0
    caseidLength equ 21
    patient_sex equ 22
    sexLength equ 23
    status equ 24
    statusLength equ 25
    date equ 26
    dateLength equ 37
    arraysize equ 5

    membercount db 0
    index dq 0



section .bss
    patient resb patient_record*arraysize
    caseid resb patient_caseid

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


    cmp byte[choice], "1"
    je add_patient
    cmp byte[choice], "2"
    je edit_patient
    cmp byte[choice], "3"
    je print_patients
    cmp byte[choice], "4"
    je exit_here

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, invalidChoice
    mov rdx, invalidChoiceLength
    syscall  

    jmp _start

add_patient:
    
    cmp byte[membercount], patient_record
    je record_full
    
    mov al, patient_record
    mov rbx, qword[index]
    mul al

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, addCase
    mov rdx, addCaseLength
    syscall  

    mov rax, SYS_READ
    mov rdi, STDIN
    lea rsi, [patient + rbx + patient_caseid]
    mov rdi, caseidLength
    syscall 

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, addSex
    mov rdx, addSexLength
    syscall  

    mov rax, SYS_READ
    mov rdi, STDIN
    lea rsi, [patient + rbx + patient_sex]
    mov rdi, sexLength
    syscall 

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, addStatus
    mov rdx, addStatusLength
    syscall 

    mov rax, SYS_READ
    mov rdi, STDIN
    lea rsi, [patient + rbx + status]
    mov rdi, statusLength
    syscall 

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, addDate
    mov rdx, addDateLength
    syscall 

    mov rax, SYS_READ
    mov rdi, STDIN
    lea rsi, [patient + rbx + date]
    mov rdi, dateLength
    syscall 


    inc qword[index]
    inc byte[membercount]

    jmp exit_here

record_full:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, fullPrompt
    mov rdx, fullPromptLength
    syscall  

    jmp _start

edit_patient:
    jmp _start

cannot_find:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, cannotFind
    mov rdx, cannotFindPrompt
    syscall 

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newLine
    mov rdx, newLineLength
    syscall 

    jmp _start

cannot_edit:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, cannotEdit
    mov rdx, cannotEditLength
    syscall 

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newLine
    mov rdx, newLineLength
    syscall 

    jmp _start

print_patients:
    mov rcx, arraysize
    mov rbx, 0
    


exit_here:
	mov rax, 60
	xor rdi, rdi
	syscall