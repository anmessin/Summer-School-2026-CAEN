#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include "SCIDK_Lib.h"

#include  "lab8mca_lib.h"

#define BOARD_SERIAL_NUMBER "0001"




int main(int argc, char* argv[])
{
	NI_HANDLE handle;
	int ret;
	uint32_t    val;

	if(USB2_ConnectDevice(BOARD_SERIAL_NUMBER, &handle) != 0) { printf("Unable to connect to the board!\n"); return (-1); };
#ifndef CUSTOM_EXAMPLE		
	
	/* //REMOVE THIS COMMENT TO ENABLE THE EXAMPLE CODE

	uint32_t status_spectrum= 0;
	int32_t Rebin = 0;
	int32_t LimitMode = 0;
	int32_t LimitValue = 0;
	uint32_t data_spectrum[4096];
	uint32_t read_data_spectrum;
	uint32_t valid_data_spectrum;
	uint32_t bins = 4096;
	int32_t timeout_spectrum = 1000;
	uint32_t spectrum[4096];

	if (SPECTRUM_Spectrum_0_SET_PARAMETERS(Rebin, LimitMode, LimitValue, &handle) != 0) printf("Set Parameters Error");
	if (SPECTRUM_Spectrum_0_FLUSH(&handle) != 0) printf("Flush Error");
	if (SPECTRUM_Spectrum_0_RESET(&handle) != 0) printf("Reset Error");
	if (SPECTRUM_Spectrum_0_START(&handle) == 0) {
		if (SPECTRUM_Spectrum_0_STATUS(&status_spectrum, &handle) == 0) {
			while (status_spectrum != 0)
			{
				if (SPECTRUM_Spectrum_0_DOWNLOAD(&data_spectrum, bins, timeout_spectrum, &handle, &read_data_spectrum, &valid_data_spectrum) == 0)
				{
					for (int i = 0; i < 4096; i++)
						spectrum[i] = data_spectrum[i];
				}
				else  printf("Data Download Error");
			}
			if (SPECTRUM_Spectrum_0_STOP(&handle) != 0) printf("Stop Error");
		}
	}
	else printf("Start Error");
*/
/* //REMOVE THIS COMMENT TO ENABLE THE EXAMPLE CODE

	uint32_t status_osc = 0;
	uint32_t data_osc[2048];
	uint32_t read_data_osc;
	uint32_t valid_data_osc;
	uint32_t position = 0;
	int32_t decimator = 0;
	int32_t pre_trigger = 100;
	int32_t software_trigger = 0;
	int32_t analog_trigger = 1;
	int32_t digital0_trigger = 0;
	int32_t digital1_trigger = 0;
	int32_t digital2_trigger = 0;
	int32_t digital3_trigger = 0;
	int32_t trigger_channel = 0;
	int32_t trigger_edge = 0;
	int32_t trigger_level = 1000;
	int32_t timeout_osc = 1000;
	int32_t size_osc = 2048;
	uint32_t read_analog[2048];
	uint32_t read_digital0[2048];
	uint32_t read_digital1[2048];
	uint32_t read_digital2[2048];
	uint32_t read_digital3[2048];
	int Osc_Events = 10;
	int e = 0;
	while (e<Osc_Events)
	{
		if (OSCILLOSCOPE_Oscilloscope_0_SET_PARAMETERS(decimator, pre_trigger, software_trigger, analog_trigger, digital0_trigger, digital1_trigger,
			digital2_trigger, digital3_trigger, trigger_channel, trigger_edge, trigger_level, &handle) != 0) printf("Set Parameters Error");
		if (OSCILLOSCOPE_Oscilloscope_0_START(&handle) != 0) printf("Start Error");
		while (status_osc != 1)
			if (OSCILLOSCOPE_Oscilloscope_0_STATUS(&status_osc, &handle) != 0) printf("Status Error");

		if (OSCILLOSCOPE_Oscilloscope_0_POSITION(&position, &handle) != 0) printf("Position Error");
		if (OSCILLOSCOPE_Oscilloscope_0_DOWNLOAD(data_osc, size_osc, timeout_osc, &handle, &read_data_osc, &valid_data_osc) != 0) printf("Get Data Error");
		if (OSCILLOSCOPE_Oscilloscope_0_RECONSTRUCT(data_osc, position, pre_trigger, read_analog, read_digital0, read_digital1, read_digital2, read_digital3) != 0) printf("Reconstruction Error");
		e++;
	}
	printf("Download Finished");
*/


	
#else

#endif

	return 0;
}

 