#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
    if (fork() >0) {
        policy(2);
        for(;;)
            printf(1, "*****    1 ********\n");
    } else {
        if (fork() >0) {
            priority(100);
            for(;;)
                printf(1, "*****    2 ********\n");
        }
    }
}