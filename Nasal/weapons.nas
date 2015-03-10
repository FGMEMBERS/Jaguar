fire_MG = func {
	setprop("/controls/armament/trigger", 1);
}

stop_MG = func {
	setprop("/controls/armament/trigger", 0); 
}
var flash_trigger = props.globals.getNode("controls/armament/trigger", 0);

reload_Cannon = func {
        setprop("ai/submodels/submodel/count",1028);
        setprop("ai/submodels/submodel[1]/count",1028);
        setprop("ai/submodels/submodel[2]/count",1028);
        setprop("ai/submodels/submodel[3]/count",1028);
}

