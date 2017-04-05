#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

struct perf {
  int ctime;
  int ttime;
  int stime;
  int retime;
  int rutime;
} p;


void timeConsuming(){
  int init = uptime();
  int curr = init;
  int counter =0;
  while(counter<30){
    if(uptime()!=curr){
      curr=uptime();
      counter++;
    }
  }
  exit(0);
}

void blockOnly(){
  int i;
  for(i=0;i<30;i++)
    sleep(1);
  exit(0);
}

void mixed(){
  int i;
  int init = uptime();
  int curr = init;
  int counter =0;
  for(i=0;i<5;i++){
    while(counter<30){
    if(uptime()!=curr){
      curr=uptime();
      counter++;
    }
  }
    sleep(1);
  }
  exit(0);
}

void printPerf(struct perf p ,int pid){
  printf(2,"PID: %d\n",pid );
  printf(2,"ttime: %d\n",p.ttime);
  printf(2,"stime %d\n",p.stime);
  printf(2,"retime: %d\n",p.retime);
  printf(2,"rutime: %d\n\n",p.rutime);

}

int
main(int argc, char *argv[])
{ 
  printf(1,"Sanity test:\n");
  int i,pid;
  int* status=0;

  for(i=0;i<5;i++){
    pid =fork();
    if(pid==0)
      timeConsuming();
  }
  for(i=0;i<5;i++){
    pid =fork();
    if(pid==0)
      blockOnly();
  }
  for(i=0;i<5;i++){
    pid =fork();
    if(pid==0)
      mixed();
  }

  // printing all of the children of the process (15 children)
  for(i=0;i<15;i++){
    printPerf(p,wait_stat(status,&p));
  }

  return 1;
}