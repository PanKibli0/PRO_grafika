extends Node


var active_unit_index = -1
var units_list = []

var position_left = Vector3i(0, 0, 0)
var position_right = Vector3i(11, 0, 0)

func _get_position(for_player: bool) -> Vector3:
	while true:  
		var pos
		
		if for_player:
			if position_left.z  > 9:
				position_left.z = 0
				position_left.x += 1
			pos = position_left
			
			position_left.z += 2
		else:
			if position_right.z > 9:
				position_right.z = 0
				position_right.x -= 1
			 
			
			
			pos = position_right

			position_right.z += 2
			
			
		if pos.x % 2: 
			pos.z += 1
			

		if not GLOBAL.GRID._is_cell_occupied(pos):
			return GLOBAL.GRID.local_to_map(pos)
		
	return Vector3(-1,-1,-1)
	
var unit_scene = preload("res://units/Unit.tscn")
		
func _add_unit(stats: UnitStats, amount: int, player: bool):
	var unit = unit_scene.instantiate()
	unit.stats = stats
	unit.player = player
	unit.amount = amount 

	add_child(unit)
	units_list.append(unit)


func _ready():
	
	for i in range(2):
		var units = GLOBAL.players_units_list[i]
		for unit in units:
			_add_unit(unit, units[unit], !i)
	
	units_list = self.get_children()
	

	for unit in units_list:
		unit.connect("S_death", Callable(self, "_unit_death").bind(unit))
		unit.connect("S_death", Callable(GLOBAL.GRID, "_unit_death").bind(unit))
		
		
		var r_pos: Vector3i
		if unit.target_position != Vector3(-1, -1, -1):
			r_pos = GLOBAL.GRID.map_to_local(unit.target_position)
		else: r_pos = _get_position(unit.player)
		
		
		
		var cell_pos = Vector3(GLOBAL.GRID.local_to_map(r_pos)) + Vector3(0.5, 0, 0.5)
		
		unit.global_transform.origin = Vector3(cell_pos)  
		unit.target_position = cell_pos 
		
		
		if unit.player: unit.look_at(Vector3(cell_pos.x + 1, cell_pos.y, cell_pos.z) )
		else: unit.look_at(Vector3(cell_pos.x - 1, cell_pos.y, cell_pos.z))
		
		GLOBAL.GRID.occupy_cell(r_pos, unit)
	
	units_list.sort_custom(_compare_initiative)
	print_rich("[color=red]", units_list, "[/color]")	
	change_active_unit()

	
func _compare_initiative(unit1: Node, unit2: Node):
	return unit1.actual_stats.initiative > unit2.actual_stats.initiative

	
func change_active_unit():
	GLOBAL.GRID.clear_grid()

	if GLOBAL.unit_panel:
		GLOBAL.unit_panel.panel_view(false)
		GLOBAL.unit_panel.skillsList.create_list(false)
		GLOBAL.unit_panel = null
		

	if GLOBAL.active_unit:
		GLOBAL.active_unit.panel_view(false)
		GLOBAL.active_unit.effects.visible = true
		GLOBAL.active_unit.effects.create_list()
		GLOBAL.active_unit.skillsList.create_list()
		GLOBAL.active_unit.actual_stats.ensure_positive_stats()
		GLOBAL.active_unit.skillsList.tick_cooldown()
		
		if GLOBAL.active_unit.waited and GLOBAL.active_unit.end_self_turn:
			GLOBAL.active_unit.end_self_turn = false
		else:
			GLOBAL.active_unit.end_self_turn = true
	
	if GLOBAL.active_unit and GLOBAL.active_unit.end_self_turn: 
		GLOBAL.active_unit.effects.on_turn_end()
		GLOBAL.active_unit.actual_stats.ensure_positive_stats()
	
	
	if active_unit_index == units_list.size()-1:
		units_list.sort_custom(_compare_initiative)
		for unit in units_list:
			unit.waited = false
		print_rich("[color=lightgreen]NEW TURN![/color]")
	
	'''ZMIANA GRACZA'''
	active_unit_index = (active_unit_index + 1) % units_list.size()
	GLOBAL.active_unit = units_list[active_unit_index]
	GLOBAL.active_unit.panel_view(true)
	GLOBAL.active_unit.skillsList.create_list()

	if not GLOBAL.active_unit.waited:
		GLOBAL.active_unit.effects.on_turn_start()
		GLOBAL.active_unit.actual_stats.ensure_positive_stats()
	
	var unit_position = GLOBAL.GRID.local_to_map(GLOBAL.active_unit.global_transform.origin - Vector3(0.5,0,0.5))
	GLOBAL.GRID.draw_move(unit_position, GLOBAL.active_unit.actual_stats.movement)	
	if GLOBAL.active_unit.actual_stats.ammo > 0: 
		GLOBAL.active_unit.d_attack = true
		%Distance.text = "DALEKO"
		_distance_unit(unit_position)
		
	GLOBAL.GRID.draw_all_units()

func _distance_unit(unit_position):
	if GLOBAL.active_unit.d_attack and not GLOBAL.GRID.enemy_next_to(unit_position): 	
		GLOBAL.GRID.draw_all_enemies()

func _input(event: InputEvent):	
	if event.is_action_pressed("DEFENSE"):
		GLOBAL.active_unit.effects.add_effect(EffectDefenseTurn.new())
		change_active_unit()
	
	if event.is_action_pressed("WAIT"):
		_unit_wait()
		
	if event.is_action_pressed("DISTANCE_CLOSE"):
		_distance_close()
		
	
	

func _distance_close():
	if GLOBAL.active_unit.actual_stats.ammo <=0: return
	GLOBAL.active_unit.d_attack = !GLOBAL.active_unit.d_attack
	%Distance.text = "DALEKO" if GLOBAL.active_unit.d_attack else "BLISKO" 
	
	GLOBAL.GRID.clear_grid()
	var unit_position = GLOBAL.GRID.local_to_map(GLOBAL.active_unit.global_transform.origin - Vector3(0.5,0,0.5))
	GLOBAL.GRID.draw_move(unit_position, GLOBAL.active_unit.actual_stats.movement)	
	GLOBAL.GRID.draw_all_units()
	_distance_unit(unit_position)


func _unit_wait():
	if GLOBAL.active_unit.waited: return
	GLOBAL.active_unit.waited = true
	units_list.remove_at(active_unit_index)
	units_list.append(GLOBAL.active_unit)
	
	active_unit_index = active_unit_index-1

	change_active_unit()


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
		%END.visible = true
		%END.text = "PLAYER WIN!"
		%END.modulate = Color("1984c0")
	elif enemy_count == units_list.size():
		print_rich("[color=#FF0000]ENEMY WIN![/color]")
		%END.visible = true
		%END.text = "ENEMY WIN!"
		%END.modulate = Color("FF0000")
	else:
		return
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  
	set_process_input(true)
	
	await get_tree().create_timer(3.0).timeout
	get_tree().quit()



func get_units(who):	
	var list = []
	
	for unit in units_list:
		if unit.player == who:
			list.append(unit)
			
	return list
