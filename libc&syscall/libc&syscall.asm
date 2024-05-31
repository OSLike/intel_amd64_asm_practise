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
	str1 db "Hello %s!", 0ah
	len1 equ $ - str1

section .text
	global _start
	some_gadget:
		pop rdi
		ret
		pop rsi
		ret
		pop rdx
		ret
		pop rax
		ret
		syscall
		ret
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
		sub rsp, 0x30; char buf[0x30]
		
		call init; init()

		xor eax, eax
		xor edi, edi
		mov rsi, rsp
		mov edx, 0x80
		syscall; read(0, buf, 0x80)

		lea rdi, [rbp-0x30]
		call puts; puts(buf)
		
		xor eax, eax
		leave
		ret

	_start:
		call main
		mov al, 60
		xor edi, edi
		syscall; exit(0)
