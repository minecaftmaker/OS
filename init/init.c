#include <unistd.h>
#include <stdio.h>
int main(void){ puts("NovaOS init: starting userspace"); execl("/sbin/nova-init","nova-init",NULL); return 1; }
