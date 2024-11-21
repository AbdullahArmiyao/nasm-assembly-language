; Introduction to Assembly Language


; For starters, each directive must start with the key word section
; There is the text section for code, data section for initialized data, and block started by symbol(bss)
; for uninitialized data, and more. Order doesn't matter
; bss section only serves to block off memory, does not generate code


; Take note of the following
; mov x, y  = x <- y        : after execution, x will hold the result
; and x, y  = x <- x and y  : after execution, x will hold the result
; or x, y   = x <- x or y   : after execution, x will hold the result
; xor x, y  = x <- x xor y  : after execution, x will hold the result
; add x, y  = x <- x + y    : after execution, x will hold the result
; sub x, y  = x <- x - y    : after execution, x will hold the result
; inc x  = x <- x + 1       : after execution, x will hold the result
; dec x  = x <- x - 1       : after execution, x will hold the result

; For any given instruction there are 3 given operands: Register, Memory, and Immediate values


; Registers: are the processors primary work horse, they are variables built into the processor, they are fast

; Categories x64:
; General Purpose => RAX(Accumulator Register), RBX(Base Register), RCX(Counter Register), RDX(Data Register)
; RAX stores arithematical results, RBX is used as base pointer for memory addressing, RCX is used for loop
; counting and string operations, RDX is used for arithmetc and logical operations
; Index Registers => RSI(Source Index), RDI(Destination Index), RBP(Base Pointer), RSP(Stack Pointer)
; RSI points to source data in string operations, RDI points to destination data in string operations, RSP points to
; the top of the stack, RBP is used as a base pointer for stack frames
; Integer Registers => R8 ... R15

; Categories x32:
; General Purpose => EAX(Accumulator Register), EBX(Base Register), ECX(Counter Register), EDX(Data Register)
; Index Registers => ESI(Source Index), EDI(Destination Index), EBP(Base Pointer), ESP(Stack Pointer)
; Integer Registers => R8D ... R15D

; Categories x16:
; General Purpose => AX(Accumulator Register), BX(Base Register), CX(Counter Register), DX(Data Register)
; Index Registers => SI(Source Index), DI(Destination Index), BP(Base Pointer), SP(Stack Pointer)
; Integer Registers => R8W ... R15W


; Memomry: memory addressing is also known as effective addressing. It is the memory locations that are referenced
; or an offset location to the data and bss sections. When an instruction requires 2 or more operands, the source
; and destination will never be memory locations, but rather there's alternation
; eg:
; mov [mv], [mv] : mem to mem - not allowed
; mov [mv], ecx  : reg to mem - allowed
; mov ecx, [mv]  : mem to reg - allowed
; Remember, if you use [] around an expression, it means you are reading/setting the content of a memory location of the expression
; To obtain the address, use one of the following
; mov eax, mv   : sets eax to the address of mv
; lea eax, [mv] : sets eax to the address of mv


; Immediate Values: are of 4 types
; Numeric Constant: can be of any base, you can use prefixes, and suffixes to change the base. you can also use underscore to breakup long
; constants to improve readability
; Character Constant: are 8 characters or more enclosed in a '' or "". They are a max of 8 bytes long and can only be used in expression context
; String Constant: are only used within data and bss section
; Floating Point Constant

; Processes in Memory
; Programs when ran, is given an isolated block of continuous logical address space(not the same as RAM). The space is segmented into:
; Low Memory -> High Memory
; So in ascendong order, .text = code -> .data, .bss -> .heap -> .ss(stack)
; Since the process memory is virtual, a memory management unit is responsible for mapping to and from process virtual address space to physical address
; space

; Now writing C program in assembly

global main
extern printf, scanf        ; include externs...like including stdio.h in c

section .text
main:
    ; Defining function
    push rbp            ; Keep stack aligned
    mov rbp, rsp
    sub rsp, 16         ; reserving space for local variable i. must be 16 byte increments

    ; body
    ; prompt the user to enter number
    xor rax, rax        ; clear RAX for variadic functions
    lea rdi, [msg]      ; first param
    call printf
    ; taking user input
    mov rax, 0          ; clear RAX
    mov rdi, format     ; RDI is always the first parameter
    mov rsi, number     ; Set storage to address of x
    call scanf
    ; setting i to 0
    mov DWORD   [rbp - 4], 0     ; local variable
    ; creating loop
loop:
    mov edx, [number]
    mov rsi, [rbp - 4]
    lea rdi, [msg2]
    xor rax, rax
    call printf

    ; increment i + 1
    mov rcx, DWORD [number]
    add DWORD [rbp - 4], 1

    cmp [rbp - 4], rcx          ; compare i [rbp -4] with ecx[number]
    jle loop                    ; jump if i < number

    ; Closing function
    add rsp, 16
    leave               ; mov rsp, rbp, pop rbp...just undo what we did at the start
    ret

section .data
    ; creating the global variables
    msg: db "Enter a number: ", 0
    msg2: db "Looping %d of %d", 10, 0
    format: db "%d", 0

section .bss
    number resb 4