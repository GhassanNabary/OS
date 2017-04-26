#include "types.h"
#include "stat.h"
#include "user.h"

#define FREE        0
#define RUNNING     1
#define RUNNABLE    2

#define STACK_SIZE  4096
#define MAX_UTHREAD  64
#define UTHREAD_QUANTA 5


typedef struct thread thread_t, *thread_p;

struct thread {
  int		 id;
  int    sp;
  char 	 stack[STACK_SIZE];
  int    state;
};

static thread_t all_thread[MAX_THREAD];
thread_p  current_thread;
thread_p  next_thread;
extern void thread_switch(void);

void 
uthread_init(void)
{
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
  current_thread->state = RUNNING;
  // init all the threads except the main thread
  int counter = 0;
  thread_p t;
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  	t->id = counter;
  	t->sp = 0;
  	if(counter != 0)
  		t->state = FREE;
  	counter++;
  }
  // TODO: -post1- make sure it is the correct syntax
  register_signal(SIGALRM, uthread_schedule);
  signal(SIGALRM, UTHREAD_QUANTA);
}

void()
wrap_and_start_function((void*) func)
{
  func();
  uthread_exit();
}

// TODO: add args support
void 
uthread_create(void (*func)())
{
  thread_p t;
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE)
      break;
  }
  if (t > all_thread + MAX_THREAD)
    return; // replace with some exception - No free thread has been found
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
  t->sp -= 4;                              // space for return address
  * (int *) (t->sp) = (int)func;           // push return address on stack
  t->sp -= 32;                             // space for registers that thread_switch expects
  t->state = RUNNABLE;
}