#### Typhonn systems	
#### crazy dj nasal from many sources...
#### and also, almursi work




setlistener("/controls/engines/engine[0]/throttle", func(n) {
    setprop("/controls/engines/engine[0]/reheat", n.getValue() >= 0.75);
},1);


setlistener("/controls/engines/engine[1]/throttle", func(n) {
    setprop("/controls/engines/engine[1]/reheat", n.getValue() >= 0.75);
},1);


# turn off hud in external views
# setlistener("/sim/current-view/view-number", func(n) { setprop("/sim/hud/visibility[1]", n.getValue() == 0) },1);

var canopy = aircraft.door.new ("/controls/canopy/", 3);

aircraft.livery.init("Aircraft/Jaguar/Models/Liveries");



### Stall warning
### 
#var s_warning_state = getprop("/sim/alarms/stall-warning");
#
#var stall_warning = func {
#    # WOW =getprop ("/gear/gear[1]/wow") or getprop ("/gear/gear[2]/wow");
#    var Estado = 0;
#    if ( and !WOW) {
#    } else { 
#    };
#   setprop("/sim/alarms/stall-warning", Estado);
#};


# ================================== Chute ==================================================

controls.deployChute = func(v){

	# Deploy
	if (v > 0){
		setprop("sim/model/lightning/controls/flight/chute_deployed",1);
		setprop("sim/model/lightning/controls/flight/chute_open",1);
		chuteAngle();
	}
	# Jettison
	if (v < 0){ 
		var voltage = getprop("systems/electrical/outputs/chute_jett");
		if (voltage > 20) {
			setprop("sim/model/lightning/controls/flight/chute_jettisoned",1);
			setprop("sim/model/lightning/controls/flight/chute_open",0);
		}
	}
}


var chuteAngle = func {

	var chute_open = getprop('sim/model/lightning/controls/flight/chute_open');
	
	if (chute_open != '1') {return();}

	var speed = getprop('velocities/airspeed-kt');
	var aircraftpitch = getprop('orientation/pitch-deg[0]');
	var aircraftyaw = -getprop('orientation/side-slip-deg'); <!-- inverted after a change in side-slip sign (bug #901) -->
	var chuteyaw = getprop("sim/model/lightning/orientation/chute_yaw");
	var aircraftroll = getprop('orientation/roll-deg');

	if (speed > 210) {
		setprop("sim/model/lightning/controls/flight/chute_jettisoned", 1); # Model Shear Pin
		return();
	}

	# Chute Pitch
	var chutepitch = aircraftpitch * -1;
	setprop("sim/model/lightning/orientation/chute_pitch", chutepitch);

	# Damped yaw from Vivian's A4 work
	var n = 0.01;
	if (aircraftyaw == nil) {aircraftyaw = 0;}
	if (chuteyaw == nil) {chuteyaw = 0;}
	var chuteyaw = ( aircraftyaw * n) + ( chuteyaw * (1 - n));	
	setprop("sim/model/lightning/orientation/chute_yaw", chuteyaw);

	# Chute Roll - no twisting for now
	var chuteroll = aircraftroll;
	setprop("sim/model/lightning/orientation/chute_roll", chuteroll*rand()*-1 );

	return registerTimerControlsNil(chuteAngle);	# Keep watching

} # end function

var chuteRepack = func{

	setprop('sim/model/lightning/controls/flight/chute_open', 0);
	setprop('sim/model/lightning/controls/flight/chute_deployed', 0);
	setprop('sim/model/lightning/controls/flight/chute_jettisoned', 0);

} # end func	



