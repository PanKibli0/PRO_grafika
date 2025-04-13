extends Node

signal units_loaded

@onready var mouseController = %MouseController
@onready var grid = %Grid

var active_unit_index = -1
var units_list = []


func _ready():
	units_list = get_children()
	units_list.sort_custom(_compare_initiative)
	emit_signal("units_loaded")
	
	for unit in units_list:
		unit.connect("movement_finished", _change_active_unit)
		var r_pos = _get_random_grid_position()
		unit.global_transform.origin = r_pos # USUNAC 
		unit.target_position = r_pos # USUNAC 
		
		var cell_pos = grid.local_to_map(r_pos)
		grid.occupy_cell(cell_pos, unit)
		
	_change_active_unit()
	
func _compare_initiative(unit1: Node, unit2: Node) -> int:
	if unit1.stats.initiative > unit2.stats.initiative:
		return 1
	elif unit1.stats.initiative < unit2.stats.initiative:
		return -1
	return 0
	
# USUNAC LOSOWA POZYCJA
func _get_random_grid_position() -> Vector3:
	var grid_size = grid.grid_size
	var random_x = randi_range(0, grid_size.x - 1)
	var random_z = randi_range(0, grid_size.y - 1)
	var local_position = grid.map_to_local(Vector3i(random_x, 0, random_z))
	return Vector3(local_position.x, 0, local_position.z)
	

func _change_active_unit():
	grid.clear_grid()
		
	active_unit_index = (active_unit_index + 1) % units_list.size()
	mouseController.unit = units_list[active_unit_index]
	
	var unit_position = grid.local_to_map(units_list[active_unit_index].global_transform.origin)
	grid.draw_move(unit_position, units_list[active_unit_index].stats.movement)
	
	print(units_list)
	
func _add_unit():
	var new_unit_scene = preload("res://units/Unit.tscn")  # podmień ścieżkę
	var unit = new_unit_scene.instantiate()
	
	var stats = UnitStats.new()
	stats.name = "Debug Unit"
	stats.max_health = 100
	stats.attack = 10
	stats.defense = 5
	stats.damage_min = 4
	stats.damage_max = 7
	stats.initiative = randi_range(1, 20)
	stats.movement = 3
	stats.color = Color(randf(), randf(), randf())  # losowy kolor

	unit.stats = stats

	add_child(unit)

	var r_pos = _get_random_grid_position()
	unit.global_transform.origin = r_pos
	unit.target_position = r_pos

	var cell_pos = grid.local_to_map(r_pos)
	grid.occupy_cell(cell_pos, unit)

	unit.connect("movement_finished", _change_active_unit)
	units_list.append(unit)
	units_list.sort_custom(_compare_initiative)
	
	
func _input(event: InputEvent):
	if event.is_action_pressed("DEBUG1"):
		_add_unit()
	if event.is_action_pressed("WAIT") and units_list[active_unit_index].player == true:
		print(units_list)
		
		print("WAIT")
		units_list.append(units_list[active_unit_index])
		units_list.remove_at(active_unit_index)
		print(units_list)
		
	if event.is_action_pressed("DEFENSE") and units_list[active_unit_index].player == true:
		_change_active_unit()
