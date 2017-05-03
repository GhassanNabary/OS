#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"

#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

extern int startof_sigreturn(void);
extern int endof_sigreturn(void);
extern int shit(void);

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
      //the hell im doing here!!!
      //cprintf("fuck this shit pid %d\n",proc->pid);
      alarm();
    }
     //alarm();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
void
default_handler(int sigNum){
  // cprintf("Fuck\n");
  cprintf("A signal %d was accepted by process %d \n",sigNum,proc->pid);
}

void
signals_handling(){
     // cprintf("catchya %d\n",1);
  if (proc == 0){

    return;
  }

 //  if(proc->in_sig_handling==1){
 // cprintf("signals_handling w\n");
 //    return;
 //  }
 
  if(proc->pending!=0){
     cprintf("catchya %d\n",proc->pending);
    int i;
    for (i = 0; i < NUMSIG; i++)
    {
      int mask= 0x00000001 << i;
      if ((proc->pending & mask)!=0){

        memmove(&(proc->tmp_tf),proc->tf,sizeof(struct trapframe));
        proc->pending= proc->pending & ~mask;
        proc->in_sig_handling=1;

        //copy sigretrun into sp
        int sizeof_sigreturn=endof_sigreturn-startof_sigreturn;
        proc->tf->esp=proc->tf->esp-sizeof_sigreturn;
        uint stack_pointer=proc->tf->esp;
        copyout(proc->pgdir,proc->tf->esp,startof_sigreturn,sizeof_sigreturn);
       // cprintf("sig_handler_arr[14] %d\n",proc->sig_handler_arr[i]);
        if(proc->sig_handler_arr[i]!=0){
        proc->tf->eip=(uint)proc->sig_handler_arr[i];
        }
        else{
          default_handler(i);
        }

        proc->tf->esp=proc->tf->esp-4;
        //signum arg
        *((int*) proc->tf->esp) = i;
        proc->tf->esp=proc->tf->esp-4;
        *((int*) proc->tf->esp) = stack_pointer;

        return;

      }
    }

  }
  
    return;

}