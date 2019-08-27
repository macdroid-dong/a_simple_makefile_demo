#include <stdio.h>
#include "add.h"
#include "sub.h"
#include "mul.h"
#include "div.h"

int main (int argc,void *argv) {
    printf("This is add function: 1+1=%d\n",add(1,1));
    printf("This is sub function: 5-2=%d\n",sub(5,2));
    printf("This is mul function: 3*7=%d\n",mul(3,7));
    printf("This is div function: 8/4=%d\n",div(8,4));
    return 0;
}
