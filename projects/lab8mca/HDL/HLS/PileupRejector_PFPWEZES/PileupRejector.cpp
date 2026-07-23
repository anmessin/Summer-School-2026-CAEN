#define BIT_SIZE 16
#define STAT_SIZE 32

#include "ap_int.h"
#include <stdio.h>
#include <string.h>

void PileupRejector(
	ap_uint<BIT_SIZE> data_in,
	bool dv_in,
	ap_uint<32> pileup_inib_double,
	ap_uint<32> pileup_inib,
	ap_uint<4> mode,
	bool prarallizable,
	bool rst_stat,
	ap_uint<BIT_SIZE>* data_out,
	bool* dv_out,
	bool* inib,
	bool* rej,
	bool* drej,
	ap_uint<STAT_SIZE>* ic,
	ap_uint<STAT_SIZE>* oc,
	ap_uint<STAT_SIZE>* rejected,
	ap_uint<STAT_SIZE>* rejected_double) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_ovld port=data_out
#pragma HLS INTERFACE ap_none port=dv_out
#pragma HLS INTERFACE ap_none port=inib
#pragma HLS INTERFACE ap_none port=rej
#pragma HLS INTERFACE ap_none port=drej
#pragma HLS INTERFACE ap_ovld port=ic
#pragma HLS INTERFACE ap_ovld port=oc
#pragma HLS INTERFACE ap_ovld port=rejected
#pragma HLS INTERFACE ap_ovld port=rejected_double
#pragma HLS INTERFACE ap_stable port=pileup_inib_double
#pragma HLS INTERFACE ap_stable port=pileup_inib
#pragma HLS INTERFACE ap_stable port=mode
#pragma HLS INTERFACE ap_stable port=prarallizable
#pragma HLS INTERFACE ap_none port=rst_stat
#pragma HLS INTERFACE ap_none port=data_in
#pragma HLS INTERFACE ap_none port=dv_in

#pragma HLS PIPELINE II=1
//#pragma HLS TOP

	static ap_uint<24> inib_counter1 = 0;
	static ap_uint<24> inib_counter2 = 0;
	static ap_uint<24> inib_counter3 = 0;
	static ap_uint<BIT_SIZE> data_in_cache;
	static bool old_dvin = 0;
	static bool int_dv_out = 0;
	static ap_uint<STAT_SIZE> _ic = 0;
	static ap_uint<STAT_SIZE> _oc = 0;
	static ap_uint<STAT_SIZE> _rejected = 0;
	static ap_uint<STAT_SIZE> _rejected_double = 0;


	bool ddvin = dv_in and (not old_dvin);
	old_dvin = dv_in;

	static short SM = 0;
	static bool _rej = false;
	*ic = _ic;
	*oc = _oc;
	*rejected = _rejected;
	*rejected_double = _rejected_double;

	if (ddvin) {
		_ic++;
	}
	*rej = _rej;
	_rej = false;
	static bool _drej = false;
	*drej = _drej;
	_drej = false;

	if (mode == 0) {
		*data_out = data_in;
		int_dv_out = ddvin;
		SM = 0;
		*inib = false;
	}
	else if (mode == 1) {
		if (inib_counter1 > 0) {
			int_dv_out = false;
			if (ddvin) {
				if (prarallizable) {
					inib_counter1 = pileup_inib;
				}
				else {
					inib_counter1--;
				}
				_rej = true;
				_rejected++;
			}
			else {
				inib_counter1--;
			}
			*inib = true;
		}
		else {
			if (ddvin) {
				*data_out = data_in;
				int_dv_out = true;
				inib_counter1 = pileup_inib;
			}
			else{
				int_dv_out = false;
			}
			*inib = false;
		}
		SM = 0;
	}
	else if (mode == 2) {
		switch (SM) {
		case 0:
			int_dv_out = false;
			if (ddvin) {
				inib_counter2 = pileup_inib;
				inib_counter3 = pileup_inib_double;
				data_in_cache = data_in;
				SM = 1;
				*inib = true;
			}
			else {
				*inib = false;
			}
			break;
		case 1:
			*inib = true;
			if (ddvin) {
				if (prarallizable) {
					inib_counter2 = pileup_inib;
				}
				else
				{
					if (inib_counter3 > 0) {
						inib_counter3--;
					}
					if (inib_counter2 > 0) {
						inib_counter2--;
					}
				}
				SM = 2;
				//_rej = true;
				_drej = true;
				//_rejected++;
				_rejected_double++;
			}
			else
			{
				if (inib_counter3 > 0) {
					inib_counter3--;
				}
				else {
					*data_out = data_in_cache;
					int_dv_out = true;
					SM = 2;
				}
				if (inib_counter2 > 0) {
					inib_counter2--;
				}
			}
			break;
		case 2:
			int_dv_out = false;
			if (ddvin) {
				if (prarallizable) {
					*inib = true;
					inib_counter2 = pileup_inib;
				}
				else{
					if (inib_counter2 > 0) {
						*inib = true;
						inib_counter2--;
					}
					else {
						SM = 0;
						*inib = false;
					}
				}
				_rej = true;
				_rejected++;
			}
			else {
				if (inib_counter2 > 0) {
					*inib = true;
					inib_counter2--;
				}
				else {
					SM = 0;
					*inib = false;
				}
			}
			break;

		default:
			SM = 0;
			break;
		}
	}


	if (int_dv_out) {
		_oc++;
	}

	*dv_out = int_dv_out;
	if (rst_stat) {

		_ic = 0;
		_oc = 0;
		_rejected = 0;
		_rejected_double = 0;
	}
}

