extends Node

@onready var GRID = %Grid

var active_unit_index = -1
var units_list = []

var position_left = Vector3i(0, 0, -1)
var position_right = Vector3i(11, 0, -1)

func _get_position(for_player: bool) -> Vector3:
	if for_player:
		if position_left.z == 9:
			position_left.z = -1
			position_left.x += 1
		position_left.z += 1
		return Vector3(GRID.local_to_map(position_left))
	else:
		if position_right.z == 9:
			position_right.z = -1
			position_right.x -= 1
		position_right.z += 1
		return Vector3(GRID.local_to_map(position_right))


func _ready():
	units_list = get_children()
	
	for i in range(20):
		_add_unit(i, i % 2 == 0)
	
	if units_list.size() > 1:	
		units_list.sort_custom(_compare_initiative)
	
	for unit in units_list:
		unit.connect("S_death", Callable(self, "_unit_death").bind(unit))
		unit.connect("S_death", Callable(GRID, "_unit_death").bind(unit))
		
		
		var r_pos: Vector3i
		if unit.target_position != Vector3(-1, -1, -1):
			r_pos = GRID.map_to_local(unit.target_position)
		else: r_pos = _get_position(unit.player)
		
		var cell_pos = Vector3(GRID.local_to_map(r_pos)) + Vector3(0.5, 0, 0.5)
		
		unit.global_transform.origin = Vector3(cell_pos)  
		unit.target_position = cell_pos 
		
		if unit.player: unit.look_at(Vector3(cell_pos.x + 1, cell_pos.y, cell_pos.z) )
		else: unit.look_at(Vector3(cell_pos.x - 1, cell_pos.y, cell_pos.z))
		
		GRID.occupy_cell(r_pos, unit)
		
	_change_active_unit()

	
func _compare_initiative(unit1: Node, unit2: Node):
	return unit1.stats.initiative > unit2.stats.initiative

	
func _change_active_unit():
	GRID.clear_grid()
	
	active_unit_index = (active_unit_index + 1) % units_list.size()
	if BATTLE.active_unit: BATTLE.active_unit.hp_debug(false)
	BATTLE.active_unit = units_list[active_unit_index]
	BATTLE.active_unit.hp_debug(true)
	
	var unit_position = GRID.local_to_map(BATTLE.active_unit.global_transform.origin)
	GRID.draw_move(unit_position, BATTLE.active_unit.stats.movement)	

func _unit_death(unit):
	units_list.erase(unit)
	_end_game()

func _end_game():
	var player_count = 0
	var enemy_count = 0

	for unit in units_list:
		if unit.player == true: player_count += 1
		else: enemy_count += 1

	if player_count == units_list.size():
		print_rich("[color=#1984c0]PLAYER WIN![/color]")
	elif enemy_count == units_list.size():
		print_rich("[color=#FF0000]ENEMY WIN![/color]")
	else:
		return

	get_tree().quit()


func _input(event: InputEvent):	
	#if event.is_action_pressed("DEFENSE") and BATTLE.active_unit.player == true:
	if event.is_action_pressed("DEFENSE"):
		_change_active_unit()
	
	if event.is_action_pressed("WAIT"):
		var random = randi_range(0, units_list.size())
		while random == active_unit_index:
			random = randi_range(0, units_list.size())
		units_list[random].death()

func _add_unit(DV: int = 0, player = true):
	var new_unit_scene = preload("res://units/Unit.tscn")  
	var unit = new_unit_scene.instantiate()
	
	var stats = UnitStats.new(
		"Debug Unit" + str(DV),
		randi_range(5, 100),
		randi_range(1, 10),
		randi_range(1, 10),
		randi_range(1, 20),
		randi_range(1, 30),
		randi_range(1, 20),
		randi_range(1, 12),
		Color(randf(), randf(), randf())
	)

	unit.stats = stats
	unit.player = player
	
	add_child(unit)
	
	units_list.append(unit)
