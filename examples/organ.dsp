
declare name "organ";
declare description "a simple additive synth";
declare author "Albert Graef";
declare version "1.0";

// This declares that the module is an instrument with 16-voice polyphony.
// (Right now this meta key is only supported in the faustvst architecture.)
declare nvoices "16";

import("music.lib");

// groups

mstr(x)	= hgroup("[1]", x); // master
modl(x)	= hgroup("[2]", x); // modulation (aux synth params)
env1(x)	= vgroup("[3]", x); // (first) envelop
note(x)	= hgroup("[4]", x); // note a.k.a. per-voice params

// control variables

vol	= vslider("vol [style:knob] [midi:ctrl 7]", 0.3, 0, 10, 0.01);	// %
pan	= vslider("pan [style:knob] [midi:ctrl 8]", 0.5, 0, 1, 0.01); // %
attack	= hslider("[1] attack", 0.01, 0, 1, 0.001);	// sec
decay	= hslider("[2] decay", 0.3, 0, 1, 0.001);	// sec
sustain = hslider("[3] sustain", 0.5, 0, 1, 0.01);	// %
release = hslider("[4] release", 0.2, 0, 1, 0.001);	// sec
freq	= nentry("freq", 440, 20, 20000, 1);	// Hz
gain	= nentry("gain", 0.3, 0, 10, 0.01);	// %
gate	= button("gate");			// 0/1

// relative amplitudes of the different partials

amp(1)	= vslider("amp1 [style:knob]", 1.0, 0, 3, 0.01);
amp(2)	= vslider("amp2 [style:knob]", 0.5, 0, 3, 0.01);
amp(3)	= vslider("amp3 [style:knob]", 0.25, 0, 3, 0.01);

// additive synth: 3 sine oscillators with adsr envelop

partial(i) = modl(amp(i+1))*osc((i+1)*note(freq));

// smoothing filter for vol/pan to avoid zipper noise
smooth(c) = *(1-c) : +~*(c);

process	= sum(i, 3, partial(i))
  * (note(gate) : env1(adsr(attack, decay, sustain, release)))
  * note(gain) : mstr(*(vol:smooth(0.99)) : panner(pan:smooth(0.99)));
