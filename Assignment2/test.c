#include "types.h"
#include "user.h"
#include "stat.h"
typedef void (*sighandler_t)(int);

void
test(int sigNum){
 sighandler_t handler=(sighandler_t)test;
signal(14,handler);
 printf(1, "\n fucking alarm_Hendler \n");
 //printf(1,"\n=======================Signal Handler===================================\n Process id:  %d  Signal number: %d \n\n", getpid(),sigNum);
}


int
main(int argc, char *argv[]){

sighandler_t handler=(sighandler_t)test;
signal(14,handler);
//sleep(5);
//printf(1,"pid is %d\n",getpid() );
  int p;
  printf(1, " start  alarmtest \n");
  alarm(100);
  printf(1, "\n alarm_Hendler \n");
  for(p = 0; p < 50*500000; p++){
    if((p++ % 500000) == 0)
      write(2, ".", 1);
  }
//sigsend(getpid(),14);
//alarm(10);
exit();
}
