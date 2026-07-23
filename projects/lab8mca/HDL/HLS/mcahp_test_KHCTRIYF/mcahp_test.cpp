#define PRE_LEN 2048
#define TRIGGER_PRE_LEN 256
#define BASELINE_PRE_LEN 2048
#include <stdio.h>
#include <string.h>
#include "ap_int.h"

#define LARGE_ACC_BITS 96
#define TR_RESET_EXTRA_TRIGGER 20

void HLSDPP_trigger(ap_uint<16> adc_data, ap_int<32> threshold, ap_int<16> k, ap_int<16> m, ap_int<24> M, bool* trigger_sig, bool* trigger_sig_bl, ap_int<32>* trigger_delta_monitor, ap_int<32>* trigger_trap_monitor, bool run_cfg, bool tr_reset, ap_uint<4> bl_len, bool* tr_inhibit_trigger)
{
	static bool initialized = false;
	static ap_int<17> preroll = TRIGGER_PRE_LEN * 2;
	static ap_int<17> delay1[TRIGGER_PRE_LEN];
	static ap_int<17> delay2[TRIGGER_PRE_LEN];
	static ap_int<32> delay3[TRIGGER_PRE_LEN];

	static ap_int<17> write_pointer1;
	static ap_int<17> write_pointer2;
	static ap_int<17> write_pointer3;

	static ap_int<17> read_pointer1;
	static ap_int<17> read_pointer2;
	static ap_int<17> read_pointer3;

	ap_int<17> adc_data_b;
	static ap_int<17> adc_data_c1;
	ap_int<17> adc_data_c2;
	ap_int<17> data_delayed1;
	ap_int<17> data_delayed2;
	ap_int<32> data_delayed3;

	ap_int<17> s1;
	ap_int<17> s2;
	ap_int<48> s3;
	ap_int<48> s4;
	ap_int<48> m1;

	static bool trigger_candidate = false;

	static ap_int<16> trigger_window = 0;
	static ap_int<32> delta;

	static ap_int<32> acc1;
	//float m1;
	//float g1;
	static ap_int<64> acc2;
	int i;
	static ap_int<16> baseline_lendec;
	static ap_int<16> tr_preroll = 0;
	static bool _tr_inhibit_trigger = false;
	static bool _trigger_sig = false;

	bool tr_trig_filt = false;

	adc_data_c1 = adc_data;
	adc_data_b = adc_data_c1 > 0 ? adc_data_c1 : (ap_int<17>)0;
	if ((initialized == true) && (run_cfg == true))
	{
		delay1[write_pointer1] = adc_data_b;
#pragma HLS DEPENDENCE variable=delay1 inter false
		read_pointer1 = write_pointer1 - k;
		if (read_pointer1 < 0)
			read_pointer1 = TRIGGER_PRE_LEN + read_pointer1;
		data_delayed1 = delay1[read_pointer1];

		if (write_pointer1 == TRIGGER_PRE_LEN - 1)
			write_pointer1 = 0;
		else
			write_pointer1++;

		if (preroll == 0)
			s1 = -data_delayed1 + adc_data_b;
		else
			s1 = 0;

		delay2[write_pointer2] = s1;
#pragma HLS DEPENDENCE variable=delay2 inter false
		read_pointer2 = write_pointer2 - m;
		if (read_pointer2 < 0)
			read_pointer2 = TRIGGER_PRE_LEN + read_pointer2;
		data_delayed2 = delay2[read_pointer2];

		if (write_pointer2 == TRIGGER_PRE_LEN - 1)
			write_pointer2 = 0;
		else
			write_pointer2++;

		if (preroll == 0)
			s2 = s1 - data_delayed2;
		else
		{
			s2 = 0;
			preroll = preroll - 1;
		}

		acc1 = acc1 + s2;
		m1 = s2 * M;
		s3 = (acc1 << 8) + m1;
		acc2 = acc2 + s3;
		s4 = (acc2 >> 24);

		delay3[write_pointer3] = s4;
#pragma HLS DEPENDENCE variable=delay3 inter false
		read_pointer3 = write_pointer3 - k;
		if (read_pointer3 < 0)
			read_pointer3 = TRIGGER_PRE_LEN + read_pointer3;
		data_delayed3 = delay3[read_pointer3];

		if (write_pointer3 == TRIGGER_PRE_LEN - 1)
			write_pointer3 = 0;
		else
			write_pointer3++;

		if (tr_reset == true)
		{
			tr_preroll = baseline_lendec;
			_tr_inhibit_trigger = true;
			tr_trig_filt = false;
		}
		else
		{
			if (tr_preroll != 0)
			{
				tr_preroll--;
				_tr_inhibit_trigger = true;
				tr_trig_filt = false;
			}
			else
			{
				tr_trig_filt = true;
				_tr_inhibit_trigger = false;
			}
		}
		if (trigger_candidate == true)
		{
			if (trigger_window > 0)
			{
				if (delta < 0)
				{
					_trigger_sig = true;
					trigger_candidate = false;
				}
				else {
					_trigger_sig = false;
				}
				trigger_window--;
			}
			else
			{
				_trigger_sig = false;
				trigger_candidate = false;
			}
		}
		else
		{
			_trigger_sig = false;
			if (delta > threshold)
			{
				trigger_window = k << 4;
				trigger_candidate = true;
			}
		}
		delta = s4 - data_delayed3;

		*trigger_delta_monitor = delta;
		*trigger_trap_monitor = s4;
		*trigger_sig = _trigger_sig and tr_trig_filt;
		*trigger_sig_bl = _trigger_sig ;
		*tr_inhibit_trigger = _tr_inhibit_trigger;
	}
	else
	{
		preroll = 2 * TRIGGER_PRE_LEN;
		initialized = true;
		write_pointer1 = 0;
		write_pointer2 = 0;
		data_delayed1 = 0;
		data_delayed2 = 0;
		s1 = 0;
		s2 = 0;
		s3 = 0;
		s4 = 0;
		acc1 = 0;
		acc2 = 0;
		m1 = 0;
		baseline_lendec = (1 << bl_len) + TR_RESET_EXTRA_TRIGGER;
	}
}

void HLSDPP_trapezio(ap_uint<16> adc_data,
	ap_uint<16> baseline,
	ap_int<16> k,
	ap_int<16> m,
	ap_int<24> M,
	ap_int<24> G,
	ap_int<32>* dataout,
	ap_int<17>* deconv2_sig,
	bool run_cfg)
{
	//#pragma HLS INTERFACE s_axilite port=return
	static bool initialized = false;
	static ap_int<16> preroll = PRE_LEN * 2;
	static ap_int<18> delay1[PRE_LEN];
	static ap_int<18> delay2[PRE_LEN];
	static ap_int<16> write_pointer1;
	static ap_int<16> write_pointer2;
	static ap_int<16> read_pointer1;
	static ap_int<16> read_pointer2;

	ap_int<18> adc_data_b;
	static ap_int<18> adc_data_c1;
	ap_int<18> adc_data_c2;
	ap_int<18>  data_delayed1;
	ap_int<18> data_delayed2;

	ap_int<18> s1;
	ap_int<18> s2;
	ap_int<64> s3;
	ap_int<64> s4;
	ap_int<64> m1;

	static  ap_int<64> acc1;
	static ap_int<LARGE_ACC_BITS> acc2;
	int i;

	*deconv2_sig = adc_data;
	adc_data_b = adc_data;

	if ((initialized == true) && (run_cfg == true))
	{
		//#pragma HLS PIPELINE II=1
		if (preroll == 0)
			delay1[write_pointer1] = adc_data_b;
		else
			delay1[write_pointer1] = 0;
#pragma HLS DEPENDENCE variable=delay1 inter false
		read_pointer1 = write_pointer1 - k;
		if (read_pointer1 < 0)
			read_pointer1 = PRE_LEN + read_pointer1;
		data_delayed1 = delay1[read_pointer1];

		if (write_pointer1 == PRE_LEN - 1)
			write_pointer1 = 0;
		else
			write_pointer1++;

		if (preroll == 0)
			s1 = -data_delayed1 + adc_data_b;
		else
			s1 = 0;

		delay2[write_pointer2] = s1;
#pragma HLS DEPENDENCE variable=delay2 inter false
		read_pointer2 = write_pointer2 - m;
		if (read_pointer2 < 0)
			read_pointer2 = PRE_LEN + read_pointer2;
		data_delayed2 = delay2[read_pointer2];

		if (write_pointer2 == PRE_LEN - 1)
			write_pointer2 = 0;
		else
			write_pointer2++;

		if (preroll == 0)
		{
			s2 = s1 - data_delayed2;
			acc1 = acc1 + ((ap_int<64>)s2);
			m1 = ((ap_int<32>) s2) * ((ap_int<32>) M);
			s3 = (acc1 << 8) + m1;
			acc2 = acc2 + (ap_int<LARGE_ACC_BITS>)s3;
			s4 = (acc2 >> 24);
		}
		else
		{
			s4 = 0;
			preroll = preroll - 1;
		}

		*dataout = (s4 * G) >> 16;
	}
	else
	{
		preroll = 2 * PRE_LEN;
		initialized = true;
		write_pointer1 = 0;
		write_pointer2 = 0;
		data_delayed1 = 0;
		data_delayed2 = 0;
		s1 = 0;
		s2 = 0;
		s3 = 0;
		s4 = 0;
		acc1 = 0;
		acc2 = 0;
		m1 = 0;
		//g1=0;
	}
	//return 0;
}

void HLSDPP_baseline_restorer(ap_int<32> trapezoidal_out,
	bool trigger_sig,
	ap_uint<4> baseline_len,
	ap_int<16> inib,
	ap_int<32>* baseline_out,
	bool* baseline_hold,
	bool run_cfg,
	bool tr_reset
)
{
	static bool initialized = false;
	static ap_int<16> preroll = BASELINE_PRE_LEN * 2;
	static ap_int<32> delay1[BASELINE_PRE_LEN];

	static ap_int<16> write_pointer1;
	static ap_int<16> read_pointer1;
	static ap_int<16> baseline_lendec;
	static ap_int<48> BL_ACCUMULATOR;

	static ap_int<16> tr_preroll = 0;

	static bool _baseline_hold;
	ap_int<32>  data_delayed1;

	static ap_int<16> trig_dead_counter = 0;

	if ((initialized == true) && (run_cfg == true))
	{

		if ((trigger_sig) || (tr_reset))
		{
			if (trigger_sig) {
				trig_dead_counter = inib;
			}
			
			_baseline_hold = true;
		}
		else
		{
			if (trig_dead_counter == 0)
			{
				if (preroll == 0)
					delay1[write_pointer1] = trapezoidal_out;
				else
					delay1[write_pointer1] = 0;

				#pragma HLS DEPENDENCE variable=delay1 inter false
				read_pointer1 = write_pointer1 - baseline_lendec;
				if (read_pointer1 < 0)
					read_pointer1 = BASELINE_PRE_LEN + read_pointer1;
				data_delayed1 = delay1[read_pointer1];

				if (write_pointer1 == BASELINE_PRE_LEN - 1)
					write_pointer1 = 0;
				else
					write_pointer1++;

				if (preroll == 0)
				{
					BL_ACCUMULATOR += (trapezoidal_out - data_delayed1);
				}
				else
					preroll--;

				_baseline_hold = false;
			}
			else
			{
				trig_dead_counter--;
				_baseline_hold = true;
			}
		}
		*baseline_out = BL_ACCUMULATOR >> baseline_len;
		*baseline_hold = _baseline_hold;
	}
	else
	{
		preroll = 2 * BASELINE_PRE_LEN;
		initialized = true;
		write_pointer1 = 0;
		read_pointer1 = 0;
		trig_dead_counter = 0;
		baseline_lendec = (1 << baseline_len);
		BL_ACCUMULATOR = 0;
	}
}

void HLSDPP_energysampler(ap_int<32> trapezoidal_in,
	ap_int<32> baseline,
	bool trigger_sig,
	ap_int<16> sample_delay,
	ap_int<32>* trapezoidal_out,
	ap_int<32>* energy_out,
	ap_uint<64> t_tag,
	ap_uint<64>* t_out,
	bool* energy_strobe,
	bool run_cfg
)
{
	static bool initialized = false;
	static ap_int<16> preroll = PRE_LEN * 2;
	static bool delay1[PRE_LEN];

	static ap_int<16> write_pointer1;
	static ap_int<16> read_pointer1;

	ap_int<32> data_delayed1;

	static ap_int<32> Trap_minus_bl = 0;
	static ap_int<16> trig_dead_counter = 0;
	static ap_uint<64> time_tmp = 0;
	*t_out = time_tmp;

	if ((initialized == true) && (run_cfg == true))
	{
		if (preroll == 0)
			delay1[write_pointer1] = trigger_sig;
		else
			delay1[write_pointer1] = 0;

		#pragma HLS DEPENDENCE variable=delay1 inter false
		read_pointer1 = write_pointer1 - sample_delay;
		if (read_pointer1 < 0)
			read_pointer1 = PRE_LEN + read_pointer1;
		data_delayed1 = delay1[read_pointer1];

		if (write_pointer1 == PRE_LEN - 1)
			write_pointer1 = 0;
		else
			write_pointer1++;

		if (preroll == 0)
		{
			if (data_delayed1)
			{
				*energy_out = Trap_minus_bl;
				*energy_strobe = true;
				time_tmp = t_tag;
			}
			else
				*energy_strobe = false;
		}
		else
		{
			preroll--;
			*energy_strobe = false;
		}
	}
	else
	{
		preroll = 2 * PRE_LEN;
		initialized = true;
		*energy_strobe = false;
		write_pointer1 = 0;
	}

	*trapezoidal_out = Trap_minus_bl;
	Trap_minus_bl = trapezoidal_in - baseline;
}

void HLSDPP(ap_uint<16> adc_data,
	bool positive,
	ap_int<16> digital_offset,
	ap_int<32> threshold,
	ap_int<16> trig_k,
	ap_int<16> trig_m,
	ap_int<16> e_k,
	ap_int<16> e_m,
	ap_int<24> e_MDec,
	ap_int<24> e_G,
	ap_int<16> e_sample_delay,
	ap_uint<4> baseline_len,
	ap_int<16> baseline_inib,
	ap_uint<64> timetag,
	bool run_cfg,
	bool tr_reset,
	ap_uint<16>* adc_data_out,
	ap_int<32>* deconv2_sig,
	ap_int<32>* trigger_delta_monitor,
	ap_int<32>* trigger_trap_monitor,
	ap_int<32>* trap,
	ap_int<32>* trap_minus_baseline,
	ap_int<32>* baseline_out,
	ap_int<32>* energy,
	ap_uint<64>* timestamp,
	bool* energy_strobe,
	bool* trigger_sig,
	bool* baseline_hold,
	ap_int<4>* GIN_SELECT,
	bool gin,
	bool* tr_inhibit_trigger)
{
#pragma HLS PIPELINE II=1
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_none port=adc_data
#pragma HLS INTERFACE ap_stable port=positive
#pragma HLS INTERFACE ap_stable port=digital_offset
#pragma HLS INTERFACE ap_stable port=threshold
#pragma HLS INTERFACE ap_stable port=trig_k
#pragma HLS INTERFACE ap_stable port=trig_m
#pragma HLS INTERFACE ap_stable port=e_k
#pragma HLS INTERFACE ap_stable port=e_m
#pragma HLS INTERFACE ap_stable port=e_MDec
#pragma HLS INTERFACE ap_stable port=e_G
#pragma HLS INTERFACE ap_stable port=e_sample_delay
#pragma HLS INTERFACE ap_stable port=baseline_len
#pragma HLS INTERFACE ap_stable port=baseline_inib
#pragma HLS INTERFACE ap_stable port=timetag
#pragma HLS INTERFACE ap_stable port=run_cfg
#pragma HLS INTERFACE ap_stable port=tr_reset
#pragma HLS INTERFACE ap_stable port=GIN_SELECT
#pragma HLS INTERFACE ap_ovld port=adc_data_out
#pragma HLS INTERFACE ap_ovld port=trigger_delta_monitor
#pragma HLS INTERFACE ap_ovld port=trigger_trap_monitor
#pragma HLS INTERFACE ap_ovld port=trap
#pragma HLS INTERFACE ap_ovld port=trap_minus_baseline
#pragma HLS INTERFACE ap_ovld port=baseline_out
#pragma HLS INTERFACE ap_ovld port=energy
#pragma HLS INTERFACE ap_ovld port=timestamp
#pragma HLS INTERFACE ap_none port=energy_strobe
#pragma HLS INTERFACE ap_none port=trigger_sig
#pragma HLS INTERFACE ap_none port=baseline_hold
#pragma HLS INTERFACE ap_none port=tr_inhibit_trigger
#pragma HLS INTERFACE ap_none port=gin

	static ap_int<16> delay1[TRIGGER_PRE_LEN * 2];
	static  ap_int<17> write_pointer1;
	static  ap_int<17> read_pointer1;

	bool run_cfg2;
	static bool satreset = true;
	bool i_trig_sig = false;
	bool i_trig_sig_int = false;
	bool i_trig_sig_bl = false;
	bool i_baseline_hold = false;
	bool i_energy_strobe = false;
	ap_int<32> i_trap = 0;
	ap_int<32> i_baseline_out = 0;
	ap_int<17> i_deconv2_sig;
	ap_uint<64> i_timestamp_out = 0;

	static ap_uint<16> i_adc_data;
	static ap_uint<16> i_adc_data_delayed;

	bool i_tr_trigger = false;
	bool i_tr_baseline = false;


	run_cfg2 = run_cfg and satreset;
	//void trigger(ap_uint<16> adc_data, ap_int<32> threshold, ap_int<16> k,  ap_int<16> m, ap_int<24> M, bool *trigger_sig,  ap_int<32> *trigger_delta_monitor,  ap_int<32> *trigger_trap_monitor)

	HLSDPP_trigger(i_adc_data, threshold, trig_k, trig_m, e_MDec, &i_trig_sig_int, &i_trig_sig_bl, trigger_delta_monitor, trigger_trap_monitor, run_cfg2, tr_reset, baseline_len, &i_tr_trigger);

	if (*GIN_SELECT == 1)
		i_trig_sig = gin;
	else
		if (*GIN_SELECT == 2)
			i_trig_sig = i_trig_sig_int and gin;
		else
			if (*GIN_SELECT == 3)
				i_trig_sig = i_trig_sig_int and (not gin);
			else
				i_trig_sig = i_trig_sig_int;

	HLSDPP_trapezio(i_adc_data_delayed, 0, e_k, e_m, e_MDec, e_G, &i_trap, &i_deconv2_sig, run_cfg2);
	HLSDPP_baseline_restorer(i_trap, i_trig_sig_bl, baseline_len, baseline_inib, &i_baseline_out, &i_baseline_hold, run_cfg2, tr_reset);
	//	 HLSDPP_energysampler(i_trap, i_baseline_out, i_trig_sig, e_sample_delay, trap_minus_baseline, energy, timetag, &i_timestamp_out, &i_energy_strobe, run_cfg2);
	HLSDPP_energysampler(i_trap, i_baseline_out, i_trig_sig, e_sample_delay, trap_minus_baseline, energy, timetag, timestamp, &i_energy_strobe, run_cfg2);

	*trigger_sig = i_trig_sig;
	*trap = i_trap;
	*baseline_out = i_baseline_out;
	*deconv2_sig = (ap_int<32>) i_deconv2_sig;
	*energy_strobe = i_energy_strobe;
	*baseline_hold = i_baseline_hold;
	//*timestamp = i_timestamp_out;
	//*timestamp = timetag;
	*adc_data_out = i_adc_data_delayed;

	*tr_inhibit_trigger = i_tr_trigger;

	if (positive == true)
		i_adc_data = adc_data + digital_offset;
	else
		i_adc_data = (0xFFFF - adc_data) + digital_offset;

	delay1[write_pointer1] = i_adc_data;
	#pragma HLS DEPENDENCE variable=delay1 inter false
	read_pointer1 = write_pointer1 - (trig_k + trig_m);
	if (read_pointer1 < 0)
		read_pointer1 = (2 * TRIGGER_PRE_LEN) + read_pointer1; //CORREGGERE CON UN X2 TRIGGER_PRE_LEN

	if (*GIN_SELECT == 1)
		i_adc_data_delayed = i_adc_data;
	else
		i_adc_data_delayed = delay1[read_pointer1];

	if (write_pointer1 == (2 * TRIGGER_PRE_LEN) - 1)
		write_pointer1 = 0;
	else
		write_pointer1++;

	if ((i_adc_data & 0xF000) == 0xF000)
	{
		satreset = false;
	}
	else
		satreset = true;
}

