
#include "types.h"
#include "stat.h"
#include "user.h"

void alarmHendler(int signum);

void fib(int n) {
  if (n >= 0) {
    fib(n-1);
    fib(n-2);
  }
}

int
main(int argc, char *argv[])
{
  signal(14,alarmHendler);
  printf(1, " start  alarmtest \n");
  alarm(100);
  printf(1, "\n alarm_Hendler \n");
  // for(p = 0; p < 50*500000; p++){
  //   if((p++ % 500000) == 0)
  //     write(2, ".", 1);
  // }
  fib(35);
  exit();
}

void
alarmHendler(int signum)
{
  printf(1, "----------in alarm_hendler %d\n",signum);
  return ;
}
