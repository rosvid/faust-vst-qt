
declare name "karplus";
declare description "Karplus-Strong string synth";
declare author "Yann Orlarey";
declare version "1.0";
declare nvoices "16";

import("music.lib");

// groups

mstr(x)	= hgroup("[1]", x); // master
mod1(x)	= hgroup("[2]", x); // modulation 1 (excitator+resonator)
mod2(x)	= hgroup("[3]", x); // modulation 2 (pitch bend control)
note(x)	= hgroup("[4]", x); // note a.k.a. per-voice params

// control variables

// master volume and pan
vol	= hslider("vol [style:knob] [midi:ctrl 7] [unit:dB]",
	  	  -10, -96, 96, 0.1);	// dB
pan	= hslider("pan [style:knob] [midi:ctrl 8]", 0, -1, 1, 0.01);	// %

// excitator and resonator parameters
size	= hslider("samples [style:knob]", 512, 1, 1024, 1);	// #samples
dtime	= hslider("decay time [style:knob]", 4, 0, 10, 0.01);	// -60db decay time

// voice parameters
freq	= nentry("freq", 440, 20, 20000, 1);	// Hz
gain	= nentry("gain", 1, 0, 10, 0.01);	// %
gate	= button("gate");			// 0/1

bend	= hslider("pitch bend", 0, -2, 2, 0.01);// pitch bend/semitones

/* The excitator: */

upfront(x) 	= (x-x') > 0.0;
decay(n,x)	= x - (x>0)/n;
release(n)	= + ~ decay(n);
trigger(n) 	= upfront : release(n) : >(0.0) : +(leak);
leak		= 1.0/65536.0; // avoid denormals on Pentium
excitator	= trigger(mod1(size));

/* The resonator: */

average(x)	= (x+x')/2;
att(d,t)	= 1-1/pow(db2linear(60), d/(SR*t));
comb(d,a)	= (+ : fdelay(4096, d-1.5)) ~ (average : *(1.0-a));
resonator(d)	= comb(d,att(d,mod1(dtime)));

/* DC blocker (see http://ccrma.stanford.edu/~jos/filters/DC_Blocker.html): */

dcblocker(x)	= (x-x') : (+ ~ *(0.995));

/* Karplus-Strong string synthesizer: */

smooth(c)	= *(1-c) : +~*(c);

process	= noise*note(gain) : *(note(gate) : excitator)
	: resonator(SR/(note(freq)*pow(2,mod2(bend)/12)))
	: dcblocker
	: mstr(*(smooth(0.99, db2linear(vol))) :
	       panner(smooth(0.99, (pan+1)/2)));
