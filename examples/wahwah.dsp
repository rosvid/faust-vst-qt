import("effect.lib"); 

drywet(fx) = _,_ <: *(d), *(d) , (fx : *(w), *(w)) :> _,_
	with {
		d = (1-w);
		w = vslider("dry-wet[style:knob]", 0, 0, 1, 0.01);
	};

wahwah = hgroup("wahwah", drywet(par(i,2, crybaby(wah)))) 
	with {
   		wah = vslider("wah[style:knob]",0.8,0,1,0.01) : automat(360, 10, 0.0);
	};

process = wahwah;
