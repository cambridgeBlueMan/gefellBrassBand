
//Granular Synthesis

Server.default=s=Server.internal;



//simple playbuf grain synthdef - note the all important doneAction
(
SynthDef(\sfgrain, {arg bufnum=0, pan=0.0, startPos=0.0, amp=0.1, dur=0.04;
var grain;

grain= PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum), 1, BufFrames.ir(bufnum)*startPos, 0)*(EnvGen.kr(Env.perc(0.01,dur),doneAction:2)-0.001);

Out.ar(0,Pan2.ar(grain, pan))}).add ; // send(s);
)

b = Buffer.read(s,thisProcess.nowExecutingPath.dirname ++ "/gefellBrassBand1.aif");

(
var w, slid, lastval;
lastval=0.0;

w=Window("My Window", Rect(100,500,200,200));
//A 200 by 200 window appears at screen co-ordinates (100, 500)

slid=Slider(w,Rect(10,10,150,40)); //a basic slider object
slid.action_({lastval= slid.value;}); //this is the callback- the function is called whenever you move the slider


{

inf.do{arg i;

var prop, timestart, timeend;

prop= (i%300)/300;
//prop.postln;
// prop wil generate values up to 1, and then drops to zero
lastval.postln;
timestart= prop*0.8;
timeend= prop*(0.8+(0.1*lastval));

	Synth(\sfgrain,[\bufnum, b.bufnum, \startPos,rrand(timestart,timeend),\amp, exprand(0.005,0.1), \pan, lastval.rand2, \dur, 0.1+(lastval*0.5)]);
	//max in this to avoid ever going near 0.0 wait time, which would crash the computer!
	(((lastval*0.2)+0.01).max(0.01)).wait
};
}.fork;

slid.valueAction = 0.5;


w.front;
)
























Some classes to explore:

[PitchShift] //A granular pitchshifter

[TGrains]	//efficient granular synthesis on a buffer, from a single UGen



Also see various granular UGens by Josh Parmenter added for SC3.2: "SC://GrainSin"GrainSin, "SC://GrainFM"GrainFM, "SC://GrainBuf"GrainBuf, "SC://GrainIn"GrainIn, "SC://Warp1"Warp1


To read more on these techniques, Curtis Roads's Computer Music Tutorial is a good introduction, and his Microsound book explores many more possibilities.




