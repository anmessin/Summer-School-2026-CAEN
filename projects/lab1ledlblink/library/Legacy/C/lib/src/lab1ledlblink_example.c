#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include "SCIDK_Lib.h"

#include  "lab1ledlblink_lib.h"

#define BOARD_SERIAL_NUMBER "0001"




int main(int argc, char* argv[])
{
	NI_HANDLE handle;
	int ret;
	uint32_t    val;

	if(USB2_ConnectDevice(BOARD_SERIAL_NUMBER, &handle) != 0) { printf("Unable to connect to the board!\n"); return (-1); };
#ifndef CUSTOM_EXAMPLE		
	
	

	
#else

#endif

	return 0;
}

 