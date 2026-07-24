#define PRE_LEN 128
#define N_BIT_IN 16
#define N_BIT_OUT 16

#include "ap_int.h"
#include <stdbool.h>
#include <stdio.h>

#ifndef PRE_LEN
#define PRE_LEN 128
#endif

#ifndef N_BIT_IN
#define N_BIT_IN 16
#endif

#ifndef N_BIT_OUT
#define N_BIT_OUT 16
#endif


typedef ap_uint<N_BIT_IN> din_t;
typedef ap_uint<N_BIT_OUT> dout_t;

// Tutti i bit a 1 per un ap_uint<N_BIT_OUT>
static const ap_uint<N_BIT_OUT> MAX_VAL = ~ap_uint<N_BIT_OUT>(0)

void charge_integration(din_t in1,
	din_t base_line,
	bool  trigger,
	ap_uint<16> int_length,
	ap_uint<16> pre_length,
	dout_t gain,
	din_t offset,
	ap_uint<16> pileup_inib,
	bool pileup_rj_enable,
	bool ce_enable,
	din_t* monitor,
	dout_t* energy_out,
	ap_uint<N_BIT_IN + 16>* charge_monitor,
	bool* energy_trigger,
	bool* p_integrate,
	bool* p_pileup,
	bool* p_busy,
	bool* p_lost_flag
) {


#pragma HLS PIPELINE II=1
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_none port=in1
#pragma HLS INTERFACE ap_none port=base_line
#pragma HLS INTERFACE ap_none port=trigger
#pragma HLS INTERFACE ap_stable port=int_length
#pragma HLS INTERFACE ap_stable port=pre_length
#pragma HLS INTERFACE ap_stable port=pileup_inib
#pragma HLS INTERFACE ap_stable port=pileup_rj_enable
#pragma HLS INTERFACE ap_stable port=gain
#pragma HLS INTERFACE ap_stable port=offset
#pragma HLS INTERFACE ap_stable port=ce_enable

#pragma HLS INTERFACE ap_ovld port=monitor
#pragma HLS INTERFACE ap_ovld port=energy_out
#pragma HLS INTERFACE ap_ovld port=charge_monitor
#pragma HLS INTERFACE ap_ovld port=energy_trigger
#pragma HLS INTERFACE ap_ovld port=p_integrate
#pragma HLS INTERFACE ap_ovld port=p_pileup
#pragma HLS INTERFACE ap_ovld port=p_busy
#pragma HLS INTERFACE ap_ovld port=p_lost_flag



	dout_t temp;

	static ap_uint<16> _int_length = 100;
	static ap_uint<16> _pre_length = 10;
	static ap_int< N_BIT_OUT + 1> _gain = 600;
	static ap_int< N_BIT_OUT + 1>  _offset = 0;
	static ap_uint<16> _pileup_inib = 0;
	static din_t baseline;
	static bool  i_busy;
	static bool  i_integrate;
	static bool  i_pileup;


	static enum dState { D_IDLE = 0, D_INTEGRATE, D_CHECKVALUE, D_HIST, D_PILEUP_REJ_1, D_PILEUP_REJ_2 } intState;

	static ap_int<N_BIT_IN + 16> integration;
	static ap_uint<16> icounter;
	static din_t pre_intbuff[PRE_LEN];


	//static short unsigned int i_pre_delay = 3;
	static ap_int<16> write_pointer = 0;
	static ap_int<16> read_pointer = 0;
	static din_t data_delayed;
	static din_t Bdata_delayed1;
	static din_t Bdata_delayed2;
	static din_t Bdata_delayed3;
	//static bool u_trigger_signal;
	static int energy;
	ap_int<33> energy_b;
	ap_int<33> energy_max;
	din_t current_data;

	static ap_uint<16> pile_up_counter;

	bool  trigger_signal = false;
	static bool  old_trigger = false;
	bool   _energy_trigger = false;
	static dout_t _energy_out = 0;

	trigger_signal = trigger and (!old_trigger);
	old_trigger = trigger;


	if (ce_enable)
	{
		//invert data
		current_data = in1;



//		//input prebuffer
//#pragma HLS PIPELINE II=1
//		pre_intbuff[write_pointer] = current_data;
//#pragma HLS PIPELINE II=1
//#pragma HLS DEPENDENCE variable=pre_intbuff inter false
//		data_delayed = pre_intbuff[read_pointer];
//
//		read_pointer = (write_pointer - _pre_length);
//		write_pointer = (write_pointer + 1);







		switch (intState)
		{
		case D_IDLE:
			// on trigger start integration
			if (trigger_signal == true)
			{
				integration = ((int)data_delayed) - ((int)base_line);
				baseline = base_line;

				i_integrate = true;
				i_busy = true;

				icounter = 0;
				intState = D_INTEGRATE;
			}

			break;

		case D_INTEGRATE:

			//check for pileup
			if ((trigger_signal == true) && (pileup_rj_enable == true))
			{
				i_pileup = true;
				i_integrate = false;
				intState = D_PILEUP_REJ_1;
			}
			else
			{
				integration += ((int)data_delayed) - ((int)baseline);
				icounter++;
				if (icounter == _int_length)
				{
					i_integrate = false;
					intState = D_CHECKVALUE;
				}
			}
			break;

		case D_CHECKVALUE:

#pragma HLS pipeline

			energy = (integration * _gain) >> 16;

			intState = D_HIST;


			break;
		case D_HIST:
			//sum offset and generate output
			integration = 0;
			energy_b = (ap_int<33>)energy + (ap_int<33>)_offset;
			energy_max = (ap_int<33>)MAX_VAL;
			if (energy_b  > energy_max)
			{
				_energy_out = MAX_VAL;
				_energy_trigger = true;
				i_busy = false;
			}
			else if (energy_b < 0) {
				_energy_out = 0;
				_energy_trigger = true;
				i_busy = false;
			}
			else {
				_energy_out = (dout_t)(energy_b);
				_energy_trigger = true;
				i_busy = false;
			}

			intState = D_IDLE;
			break;

			//pileup rejector
		case D_PILEUP_REJ_1:
			pile_up_counter = _pileup_inib;
			intState = D_PILEUP_REJ_2;
			break;
		case D_PILEUP_REJ_2:
			if (trigger_signal)
			{
				intState = D_PILEUP_REJ_1;
			}
			else
			{
				if (pile_up_counter == 0)
				{
					intState = D_IDLE;
					i_pileup = false;
					i_busy = false;
				}
				else
					pile_up_counter--;
			}

			break;
		}

		*charge_monitor = integration;
		//pileup rejector enable


		if (write_pointer  < _pre_length)
			read_pointer = PRE_LEN + (write_pointer - _pre_length);
		else
			read_pointer = write_pointer - _pre_length;

		if (_pre_length == 0) {
			data_delayed = current_data;
		}
		else if (_pre_length == 1) {
			data_delayed = Bdata_delayed1;
		}
		else if (_pre_length == 2) {
			data_delayed = Bdata_delayed2;
		} else{
			data_delayed = pre_intbuff[read_pointer];
		}

		Bdata_delayed3 = Bdata_delayed2;
		Bdata_delayed2 = Bdata_delayed1;
		Bdata_delayed1 = current_data;

		pre_intbuff[write_pointer] = current_data;
#pragma HLS DEPENDENCE variable=pre_intbuff inter false


		if (write_pointer == PRE_LEN - 1)
			write_pointer = 0;
		else
			write_pointer++;

	}
	else
	{
		//intState= D_IDLE;

	}

	_int_length = int_length;
	_pre_length = pre_length;
	_gain = (int)gain;
	_offset = (int)offset;
	_pileup_inib = pileup_inib;

	*p_integrate = i_integrate;
	*p_busy = i_busy;
	*p_pileup = i_pileup;
	*monitor = data_delayed;
	*p_lost_flag = i_busy and trigger_signal;
	*energy_trigger = _energy_trigger;
	*energy_out = _energy_out;
}

