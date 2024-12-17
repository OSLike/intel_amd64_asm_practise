;Intel
;nasm -f elf64 -o 12.o 12.asm
;ld 12.o -o 12 -lc --dynamic-linker /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
;ld 12.o -o 12
extern scanf
extern printf
extern setvbuf
extern stdin
extern stdout
extern puts

section .data
	msg db "./flag", 0
	len equ $ - msg
	str1 db "%ld ", 0
	len1 equ $ - str1

section .text
	global _start
	init:; void init()
		mov rdi, &stdin
		xor esi, esi
		mov edx, 2
		xor ecx, ecx
		call setvbuf; setvbuf(stdin, 0, 2, 0)
		
		mov rdi, &stdout
		mov edx, 2
		xor ecx, ecx
		call setvbuf; setvbuf(stdout, 0, 2, 0)
		ret
	main:
		push rbp
		mov rbp, rsp
		sub rsp, 0x50; long buf[10]
		push r13
		push r12
		push rcx
		push rbx
		
		call init; init()

		xor ebx, ebx
		mov eax, 10
		jmp short initial_buf_judge
		
		initial_buf:
		dec eax
		mov [rbp+rbx*8-0x50], rax
		inc ebx
		
		initial_buf_judge:
		cmp ebx, 10
		jl short initial_buf ; for 0 to range 10 init buf[10]
		
		xor r12, r12
		jmp short buf_i_judge
		
		buf_j_i:
		xor r13, r13
		jmp short buf_j_i_judge
		
		buf_bubble:
		mov rax, [rbp+r12*8-0x50]
		mov rcx, [rbp+r13*8-0x50]
		cmp rax, rcx
		jae short bubble_continue
		
		mov [rbp+r12*8-0x50], rcx
		mov [rbp+r13*8-0x50], rax
		
		bubble_continue:
		inc r13
		
		buf_j_i_judge:
		cmp r13, r12
		jl short buf_bubble
		
		inc r12
		
		buf_i_judge:
		cmp r12, 10
		jl short buf_j_i
		
		; for 0 to range 10 buf[i] --> rax  r12 --> i
		; for 0 to range i  buf[j] --> rcx  r13 --> j
		
		xor ebx, ebx
		jmp short output_i_judge
		
		output_buf:
		lea rdi, str1
		mov rsi, [rbp+rbx*8-0x50]
		call printf
		inc ebx
		
		output_i_judge:
		cmp ebx, 10
		jl short output_buf
		
		xor eax, eax
		pop rbx
		pop rcx
		pop r12
		pop r13
		add rsp, 0x50
		pop rbp
		ret

	_start:
		call main
		mov al, 60
		xor edi, edi
		syscall; exit(0)
