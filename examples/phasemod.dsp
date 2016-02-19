
declare name "phasemod";
declare description "phase modulation synth";
declare author "Albert Graef";
declare version "1.0";
declare nvoices "16";

import("music.lib");

// groups

mstr(x)	= hgroup("[1]", x); // master
modl(x)	= hgroup("[2]", x); // modulation (aux synth params)
env1(x)	= vgroup("[3]", x); // (first) envelop
note(x)	= hgroup("[4]", x); // note a.k.a. per-voice params

// control variables

// master volume and pan
vol	= hslider("vol [style:knob] [midi:ctrl 7]", 0.3, 0, 10, 0.01);	// %
pan	= hslider("pan [style:knob] [midi:ctrl 8]", 0.5, 0, 1, 0.01);	// %

// ADSR envelop
attack	= hslider("[1] attack", 0.01, 0, 1, 0.001);	// sec
decay	= hslider("[2] decay", 0.3, 0, 1, 0.001);	// sec
sustain = hslider("[3] sustain", 0.5, 0, 1, 0.01);	// %
release = hslider("[4] release", 0.2, 0, 1, 0.001);	// sec

// voice parameters
freq	= nentry("freq", 440, 20, 20000, 1);	// Hz
gain	= nentry("gain", 1, 0, 10, 0.01);	// %
gate	= button("gate");			// 0/1

// generic table-driven oscillator with phase modulation

// n	= the size of the table, must be a power of 2
// f	= the wave function, must be defined on the range [0,2*PI]
// freq	= the desired frequency in Hz
// mod	= the phase modulation signal, in radians

tblosc(n,f,freq,mod)	= (1-d)*rdtable(n,wave,i&(n-1)) +
			  d*rdtable(n,wave,(i+1)&(n-1))
with {
	wave	 	= time*(2.0*PI)/n : f;
	phase		= freq/SR : (+ : decimal) ~ _;
	modphase	= decimal(phase+mod/(2*PI))*n;
	i		= int(floor(modphase));
	d		= decimal(modphase);
};

// phase modulation synth (sine modulated by another sine)

smooth(c) = *(1-c) : +~*(c);

process	= tblosc(1<<16, sin, note(freq), mod) * env * (note(gain))
  :  mstr(*(vol:smooth(0.99)) : panner(pan:smooth(0.99)))
with {
	env = note(gate) : env1(adsr(attack, decay, sustain, release));
	mod = 2*PI*tblosc(1<<16, sin, note(freq), 0)*env;
};
