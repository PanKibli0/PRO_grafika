extends Node

@onready var units = %Units
@onready var mouseController = %MouseController

var active_unit_index = -1
var units_list = []

func _ready():
	units_list = get_children()
		
	_change_active_unit()
	_set_active_unit()
		
	#for unit in units_list:
		#unit.connect("movement_finished", self, "_change_active_unit")
	
#	POLACZENIE SYGNALOW COS NIE WCHODZI ABY ZmIENIAC JEDNOSTKI
		
func sig():
	print("SIGNAl")
	
func _change_active_unit():
	
	active_unit_index = (active_unit_index + 1) % units_list.size()
	mouseController.unit = units_list[active_unit_index]
	
func _set_active_unit():
	for i in range(units_list.size()):
		if i == active_unit_index:
			units_list[i].set_process(true)  
		else:
			units_list[i].set_process(false)
