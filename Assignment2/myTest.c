#include "types.h"
#include "stat.h"
#include "user.h"
#include "uthread.c"

void foo1() {
  while(1==1){
    printf("foo1\n");
  }
}

void foo2() {
  while(1==1){
    printf("foo2\n");
  }
}

int
main(int argc, char *argv[])
{
  uthread_init();
  uthread_create(&foo1, 0);
  uthread_create(&foo2, 0);
  uthread_schedule();
}