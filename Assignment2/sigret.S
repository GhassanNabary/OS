#include "syscall.h"
#include "traps.h"
#include "asm.h"


.globl startof_sigreturn
startof_sigreturn:
	pushl %eax
    movl $SYS_sigreturn, %eax
    int $T_SYSCALL
	ret

.globl endof_sigreturn
 endof_sigreturn: