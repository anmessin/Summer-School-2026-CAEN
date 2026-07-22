#include "RegisterFile.h"
#include "Def.h"
#include <stdint.h>
#include <stdlib.h>
#include  <stdbool.h>

#ifdef __cplusplus
#ifdef SCICOMPILER_EXPORTS
#define SCILIB extern "C" __declspec(dllexport) 
#else
#define SCILIB extern "C" __declspec(dllimport)
#endif
#else
#define SCILIB __declspec(dllexport) 
#endif

typedef struct
{
	uint64_t Time_Code;
	uint32_t Id;
	uint32_t Pack_Id;
	uint32_t *Energy;
	uint32_t Valid;
} t_FRAME_packet;


typedef struct
{
	t_FRAME_packet *packets;
	int allocated_packets;
	int valid_packets;
} t_FRAME_packet_collection;



typedef struct
{
	int board;
	uint64_t timestamp;
	uint64_t triggerid;
	void *payload;
}t_generic_event;

typedef struct
{
	t_generic_event *packets;
	int allocated_packets;
	int valid_packets;
} t_generic_event_collection;


SCILIB int USB2_ListDevices(char *ListOfDevice, char *model,  int *Count);
SCILIB int USB2_ConnectDevice(char *serial_number, NI_HANDLE *handle);
SCILIB int USB2_CloseConnection(NI_HANDLE *handle);

SCILIB int __abstracted_mem_write(uint32_t *data, uint32_t count, 
										uint32_t address,  
										uint32_t timeout_ms, NI_HANDLE *handle, 
										uint32_t *written_data);
SCILIB int __abstracted_fifo_read(uint32_t *data, uint32_t count, 
										uint32_t address, 
										uint32_t timeout_ms, NI_HANDLE *handle, 
										uint32_t *read_data, uint32_t *valid_data);
SCILIB int __abstracted_fifo_write(uint32_t *data, uint32_t count, 
										uint32_t address,  
										uint32_t timeout_ms, NI_HANDLE *handle, 
										uint32_t *written_data);
SCILIB int __abstracted_fifo_read(uint32_t *data, uint32_t count, 
										uint32_t address, 
										uint32_t address_status, 
										bool blocking,
										uint32_t timeout_ms, NI_HANDLE *handle, 
										uint32_t *read_data, uint32_t *valid_data);
										
SCILIB int __abstracted_reg_write(uint32_t data, uint32_t address, NI_HANDLE *handle);
SCILIB int __abstracted_reg_read(uint32_t *data, uint32_t address, NI_HANDLE *handle);

SCILIB int Utility_PEAK_DATA_FORM_DOWNLOAD_BUFFER(void *buffer_handle, int32_t *val);

SCILIB int Utility_ENQUEUE_DATA_IN_DOWNLOAD_BUFFER(void *buffer_handle, int32_t *val, uint32_t size, uint32_t *enqueued_data);

SCILIB int Utility_ALLOCATE_DOWNLOAD_BUFFER(void **buffer_handle, uint32_t buffer_size);

SCILIB void free_FRAME_packet_collectionvoid(t_FRAME_packet_collection *decoded_packets);
SCILIB void free_packet_collection(t_generic_event_collection *decoded_packets);

SCILIB int IICUser_OpenControllerInit(uint32_t ControlAddress, uint32_t StatusAddress, NI_HANDLE *handle,  NI_IIC_HANDLE *IIC_Handle);
SCILIB int IICUser_ReadData(uint8_t address, uint8_t *value, int len, uint8_t *value_read, int len_read, NI_IIC_HANDLE *IIC_Handle);
SCILIB int IICUser_WriteData(uint8_t address, uint8_t *value, int len, NI_IIC_HANDLE *IIC_Handle);

SCILIB char *ReadFirmwareInformation(NI_HANDLE *handle);








SCILIB int REG_EL_M_GET(uint32_t *val, NI_HANDLE *handle);
SCILIB int REG_EL_M_SET(uint32_t val, NI_HANDLE *handle);
SCILIB int REG_PEAK_DELAY_GET(uint32_t *val, NI_HANDLE *handle);
SCILIB int REG_PEAK_DELAY_SET(uint32_t val, NI_HANDLE *handle);
SCILIB int REG_BL_M_GET(uint32_t *val, NI_HANDLE *handle);
SCILIB int REG_BL_M_SET(uint32_t val, NI_HANDLE *handle);
SCILIB int REG_BL_HOLD_GET(uint32_t *val, NI_HANDLE *handle);
SCILIB int REG_BL_HOLD_SET(uint32_t val, NI_HANDLE *handle);
SCILIB int REG_ANALOG_OFFSET_SET(uint32_t val, NI_HANDLE *handle);
//-----------------------------------------------------------------
//-
//- LISTMODULE_List_0_RESET
//-
//- Clear list content
//-
//- ARGUMENTS:
//- 	          handle PARAM_INOUT  NI_HANDLE
//- 		Connection handle to the board
//- 		DEFAULT: 
//- 		OPTIONAL: False
//-
//-
//- RETURN [int]
//- 	Return if the function has been succesfully executed
//- 		0) Success
//- 		-1) Error
//-
//-----------------------------------------------------------------

SCILIB int LISTMODULE_List_0_RESET(NI_HANDLE *handle)
;
//-----------------------------------------------------------------
//-
//- LISTMODULE_List_0_START
//-
//- Start List acquisition. The list is automatically flushed upon start operation
//-
//- ARGUMENTS:
//- 	          handle PARAM_INOUT  NI_HANDLE
//- 		Connection handle to the board
//- 		DEFAULT: 
//- 		OPTIONAL: False
//-
//-
//- RETURN [int]
//- 	Return if the function has been succesfully executed
//- 		0) Success
//- 		-1) Error
//-
//-----------------------------------------------------------------

SCILIB int LISTMODULE_List_0_START(NI_HANDLE *handle)
;
//-----------------------------------------------------------------
//-
//- LISTMODULE_List_0_STATUS
//-
//- Get List status
//-
//- ARGUMENTS:
//- 	          status  PARAM_OUT    int32_t
//- 		Return the oscilloscope status
//- 		DEFAULT: 
//- 		OPTIONAL: False
//- 		0) No data available
//- 		1) Data available
//-
//- 	          handle PARAM_INOUT  NI_HANDLE
//- 		Connection handle to the board
//- 		DEFAULT: 
//- 		OPTIONAL: False
//-
//-
//- RETURN [int]
//- 	Return if the function has been succesfully executed
//- 		0) Success
//- 		-1) Error
//-
//-----------------------------------------------------------------

SCILIB int LISTMODULE_List_0_STATUS(uint32_t *status, uint32_t *data_available, NI_HANDLE *handle)
;
//-----------------------------------------------------------------
//-
//- LISTMODULE_List_0_DOWNLOAD
//-
//- Download data from fifo buffer. If data are not available the command stall until the timout occuredUSAGE: 
//-     LISTMODULE_List_0_DOWNLOAD(data_buffer, BUFFER_SIZE_List_0, 1000, handle, rd, vp);
//- 
//-
//- ARGUMENTS:
//- 	             val  PARAM_OUT   uint32_t
//- 		uint32_t buffer data with preallocated size of at list 'size' parameters + 16 word
//- 		DEFAULT: 
//- 		OPTIONAL: False
//-
//- 	            size   PARAM_IN   uint32_t
//- 		number of word to download from the buffer.
//- 		DEFAULT: 
//- 		OPTIONAL: False
//-
//- 	         timeout   PARAM_IN    int32_t
//- 		timeout in ms
//- 		DEFAULT: 
//- 		OPTIONAL: False
//-
//- 	          handle PARAM_INOUT  NI_HANDLE
//- 		Connection handle to the board
//- 		DEFAULT: 
//- 		OPTIONAL: False
//-
//- 	       read_data  PARAM_OUT   uint32_t
//- 		number of word read from the buffer
//- 		DEFAULT: 
//- 		OPTIONAL: False
//-
//- 	      valid_data  PARAM_OUT   uint32_t
//- 		number of word valid in the buffer
//- 		DEFAULT: 
//- 		OPTIONAL: False
//-
//-
//- RETURN [int]
//- 	Return if the function has been succesfully executed
//- 		0) Success
//- 		-1) Error
//-
//-----------------------------------------------------------------

SCILIB int LISTMODULE_List_0_DOWNLOAD(uint32_t *val, uint32_t size, int32_t timeout, NI_HANDLE *handle, uint32_t *read_data, uint32_t *valid_data)
;
