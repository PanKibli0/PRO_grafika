extends Node

@onready var GRID = %Grid

var active_unit_index = -1
var units_list = []

var position_left = Vector3i(0, 0, 0)
var position_right = Vector3i(11, 0, 0)

func _get_position(for_player: bool) -> Vector3:
	while true:  
		var pos
		
		if for_player:
			if position_left.z  > 10:
				position_left.z = 0
				position_left.x += 2
			pos = position_left
			
			position_left.z += 2
		else:
			if position_right.z > 10:
				position_right.z = 0
				position_right.x -= 2
			 
			pos = position_right

			print_rich()
			position_right.z += 2

		if not GRID._is_cell_occupied(pos):
			return GRID.local_to_map(pos)
		
	return Vector3(-1,-1,-1)
		
func _ready():
	units_list = get_children()
	
	#for i in range(6):
		#_add_unit(i, i % 2 == 0)
	

	
	
	for unit in units_list:
		unit.connect("S_death", Callable(self, "_unit_death").bind(unit))
		unit.connect("S_death", Callable(GRID, "_unit_death").bind(unit))
		
		
		var r_pos: Vector3i
		if unit.target_position != Vector3(-1, -1, -1):
			r_pos = GRID.map_to_local(unit.target_position)
		else: r_pos = _get_position(unit.player)
		print(unit, r_pos)
		
		
		var cell_pos = Vector3(GRID.local_to_map(r_pos)) + Vector3(0.5, 0, 0.5)
		
		unit.global_transform.origin = Vector3(cell_pos)  
		unit.target_position = cell_pos 
		
		
		if unit.player: unit.look_at(Vector3(cell_pos.x + 1, cell_pos.y, cell_pos.z) )
		else: unit.look_at(Vector3(cell_pos.x - 1, cell_pos.y, cell_pos.z))
		
		GRID.occupy_cell(r_pos, unit)
	
	units_list.sort_custom(_compare_initiative)
	print_rich("[color=red]", units_list, "[/color]")	
	_change_active_unit()

	
func _compare_initiative(unit1: Node, unit2: Node):
	return unit1.actual_stats.initiative > unit2.actual_stats.initiative

	
func _change_active_unit():
	GRID.clear_grid()

	if BATTLE.active_unit:
		if BATTLE.active_unit.waited and BATTLE.active_unit.end_self_turn:
			BATTLE.active_unit.end_self_turn = false
		else:
			BATTLE.active_unit.end_self_turn = true
	
	if BATTLE.active_unit and BATTLE.active_unit.end_self_turn: 
		BATTLE.active_unit.effects.on_turn_end()
		BATTLE.active_unit.panel_view(false)
	
	
	if active_unit_index == units_list.size()-1:
		units_list.sort_custom(_compare_initiative)
		for unit in units_list:
			unit.waited = false
		print_rich("[color=lightgreen]NEW TURN![/color]")
	
	'''ZMIANA GRACZA'''
	active_unit_index = (active_unit_index + 1) % units_list.size()
	BATTLE.active_unit = units_list[active_unit_index]
	BATTLE.active_unit.panel_view(true)

	if not BATTLE.active_unit.waited:
		BATTLE.active_unit.effects.on_turn_start()
	
	
	var unit_position = GRID.local_to_map(BATTLE.active_unit.global_transform.origin - Vector3(0.5,0,0.5))
	GRID.draw_move(unit_position, BATTLE.active_unit.actual_stats.movement)	
	if BATTLE.active_unit.actual_stats.ammo > 0: 
		BATTLE.active_unit.d_attack = true
		%Distance.text = "DALEKO"
		_distance_unit(unit_position)
		
	GRID.draw_all_units()

func _distance_unit(unit_position):
	if BATTLE.active_unit.d_attack and not GRID.enemy_next_to(unit_position): 	
		GRID.draw_all_enemies()

func _input(event: InputEvent):	
	if event.is_action_pressed("DEFENSE"):
		_change_active_unit()
	
	if event.is_action_pressed("WAIT"):
		_unit_wait()
		
	if event.is_action_pressed("DISTANCE_CLOSE"):
		_distance_close()
	

func _distance_close():
	if BATTLE.active_unit.actual_stats.ammo <=0: return
	BATTLE.active_unit.d_attack = !BATTLE.active_unit.d_attack
	print(BATTLE.active_unit.d_attack)
	%Distance.text = "DALEKO" if BATTLE.active_unit.d_attack else "BLISKO" 
	
	GRID.clear_grid()
	var unit_position = GRID.local_to_map(BATTLE.active_unit.global_transform.origin - Vector3(0.5,0,0.5))
	GRID.draw_move(unit_position, BATTLE.active_unit.actual_stats.movement)	
	GRID.draw_all_units()
	_distance_unit(unit_position)


func _unit_wait():
	if BATTLE.active_unit.waited: return
	BATTLE.active_unit.waited = true
	units_list.remove_at(active_unit_index)
	units_list.append(BATTLE.active_unit)
	
	active_unit_index = active_unit_index-1

	_change_active_unit()


func _unit_death(unit):
	units_list.erase(unit)
	_end_game()

func _end_game():
	return
	@warning_ignore("unreachable_code")
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
