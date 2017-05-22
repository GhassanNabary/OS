#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"

#define PGSIZE 4096
#define COUNT 10

char* m1[COUNT];

//Allocates 20 pages and uses them.

volatile int
main(int argc, char *argv[])
{

	int i,j;
/*		if(fork() > 0){
		printf(1,"Parent %d\n");
	}
	else {
		printf(1,"Child %d\n");
	}
*/
	//creating 'COUNT' pages
	for (i = 0; i < COUNT ; ++i)
	{
		m1[i] = malloc(PGSIZE);
		printf(1, "allocated page #%d at address: %x\n", i, m1[i]);
	}

	//using all pages
	for ( i = 0; i < COUNT; ++i)
	{
		printf(1,"in Page Num: %d\n",i);
		for ( j = 0; j < PGSIZE; ++j)
		{
			m1[i][j] = 0;
		}
	}
	uint forkRes = fork();
	if(forkRes > 0){
		printf(1,"Parent %d\n",forkRes);
	}
	else {
		printf(1,"Child %d\n",forkRes);
	}

	for ( i = 0; i < COUNT; ++i)
	{
		printf(1,"2nd in Page Num: %d\n",i);
		for ( j = 0; j < PGSIZE; ++j)
		{
			if(forkRes > 0){
			m1[i][j] = 1;
			}
			else{
				m1[i][j] = 2;	
			}
		}
	}
	printf(1,"m1[0][0] %d\n",m1[0][0] );

	printf(1,"Finished Successfuly!!! %d\n");


	exit();
	return 0;
}