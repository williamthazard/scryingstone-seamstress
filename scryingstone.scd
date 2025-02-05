(
Task(
	{
		Server.default = Server.local;
		o = Server.default.options;
		o.inDevice_("Scarlett 4i4 USB");
		o.outDevice_("Scarlett 4i4 USB");
		s.reboot;
		s.waitForBoot(
			{
				SynthDef(
					\wn,
					{
						arg sig,out,amp=0.2,pan=0;
						sig=Pan2.ar(WhiteNoise.ar(amp),pan);
						Out.ar(out,sig)
					}
				).add;
				SynthDef(
					\pn,
					{
						arg sig,out,amp=0.2,pan=0;
						sig=Pan2.ar(PinkNoise.ar(amp),pan);
						Out.ar(out,sig)
					}
				).add;
				SynthDef(
					\bn,
					{
						arg sig,out,amp=0.2,pan=0;
						sig=Pan2.ar(BrownNoise.ar(amp),pan);
						Out.ar(out,sig)
					}
				).add;
				s.sync;
				a = [Synth(\wn),Synth(\pn),Synth(\bn)];
				OSCdef(
					\amps_receiver,
					{
						arg msg;
						msg.postln;
						3.do(
							{
								arg i;
								if(
									msg[1] == i,
									{
										a[i].set(\amp,msg[2]);
									}
								);
							},
						);
					},
					\amps
				);
				OSCdef(
					\pans_receiver,
					{
						arg msg;
						msg.postln;
						3.do(
							{
								arg i;
								if(
									msg[1] == i,
									{
										a[i].set(\pan,msg[2]);
									}
								);
							},
						);
					},
					\pans
				);
			}
		)
	}
).play(AppClock)
)