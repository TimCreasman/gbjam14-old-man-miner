class_name OMM_MinerNameComponent
extends Node
signal changed(new_value)
var miner_name

func change_name(new_name):
	miner_name=new_name
	changed.emit(name)
	
