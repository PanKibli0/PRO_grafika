extends Node


@onready var mouseController = %MouseController
@onready var grid = %Grid

var active_unit_index = -1
var units_list = []
var change_cell: Vector3

func _ready():
	units_list = get_children()
	units_list.sort_custom(Callable(self, "_compare_initiative"))
		
	for unit in units_list:
		unit.connect("movement_finished", Callable(self, "_change_active_unit"))
		var r_pos = _get_random_grid_position()
		unit.global_transform.origin = r_pos # USUNAC 
		unit.target_position = r_pos # USUNAC 
		
	_change_active_unit()
	
func _compare_initiative(unit1: Node, unit2: Node) -> int:
	if unit1.stats.initiative > unit2.stats.initiative:
		return 1
	elif unit1.stats.initiative < unit2.stats.initiative:
		return -1
	return 0
	
# USUNAC LOSOWA POZYCJA
func _get_random_grid_position() -> Vector3:
	var grid_size = grid.gridSize
	var random_x = randi_range(0, grid_size.x - 1)
	var random_z = randi_range(0, grid_size.y - 1)
	var local_position = grid.map_to_local(Vector3i(random_x, 0, random_z))
	return Vector3(local_position.x, 0, local_position.z)
	

func _change_active_unit():
#	RYSWNIAE KOKNRETNEGO RUCHU i ATKAU DLA JEDNOSTKEK
#	WYWOALNIE FUNKCJI Z GRID (REFERENCJA)
	grid.set_cell_item(change_cell, 0) # wyjebac
		
	active_unit_index = (active_unit_index + 1) % units_list.size()
	mouseController.unit = units_list[active_unit_index]
	
	change_cell = grid.local_to_map(units_list[active_unit_index].global_transform.origin)
	grid.set_cell_item(change_cell, 2) # wyjebac
	
