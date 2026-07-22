#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include "SCIDK_Lib.h"

#include  "lab5peakdetector_lib.h"

#define BOARD_SERIAL_NUMBER "0001"




int main(int argc, char* argv[])
{
	NI_HANDLE handle;
	int ret;
	uint32_t    val;

	if(USB2_ConnectDevice(BOARD_SERIAL_NUMBER, &handle) != 0) { printf("Unable to connect to the board!\n"); return (-1); };
#ifndef CUSTOM_EXAMPLE		
	
	/* //REMOVE THIS COMMENT TO ENABLE THE EXAMPLE CODE

		uint32_t status_list = 0;
		uint32_t data_list[16000];
		uint32_t read_data_list;
		uint32_t valid_data_list;
		uint32_t size_list = 10;
		uint32_t count = 0;
		int32_t timeout_list = 1000;
		uint32_t ReadListNumber = 0;
		uint32_t TargetDataNumber = 1000;
		uint32_t DownloadDataValues[1000];
		int i = 0;

		if (LISTMODULE_List_0_RESET(&handle) != 0) printf("Reset Error");
		if (LISTMODULE_List_0_START(&handle) != 0) printf("Start Error");
		while (ReadListNumber < TargetDataNumber) {
			if (LISTMODULE_List_0_STATUS(&status_list, &count, &handle) != 0) printf("Status Error");
			int dr = count < size_list ? count : size_list;
			if (dr > 0) {
				if (LISTMODULE_List_0_DOWNLOAD(data_list, dr, timeout_list, &handle, &read_data_list, &valid_data_list) != 0) printf("Get Data Error");
				for (int i = 0; i < dr; i ++) {
					printf("%8x\n", data_list[i]);
				}
				ReadListNumber = ReadListNumber + size_list;
			}
		}
		printf("Download Finished");
*/


	
#else

#endif

	return 0;
}

 