extends Node

signal S_end_turn

@onready var direction = %Direction
@onready var CAMERA =  %Camera


var unit: Unit = null

func _hover_input(event):
	var r_cell = _get_cell_at_mouse_position(event.position)
	if r_cell.is_empty(): 
		direction.text = ""
		return
	
	var cell = r_cell[0]
	var id = r_cell[1]
	
	GLOBAL.GRID.select_cell(cell)
	
	if id == GLOBAL.GRID.cell_type.ENEMY:
		var attack_direction = update_attack_direction(cell, event.position)
		print_direction(attack_direction)
		if attack_direction != Vector3.ZERO:
			var attack_move_cell = cell + attack_direction
			if _can_attack_from_position(attack_move_cell):
				GLOBAL.GRID.select_cell(cell)
				GLOBAL.GRID.select_cell(attack_move_cell)
				
					
	elif unit != null:
		direction.text = ""
		
	
func print_direction(attack_direction: Vector3i):
	match attack_direction:
		Vector3i(-1, 0, 0):
			direction.text = "Lewo"
		Vector3i(1, 0, 0):
			direction.text = "Prawo"
		Vector3i(0, 0, -1):
			direction.text = "Góra"
		Vector3i(0, 0, 1):
			direction.text = "Dół"
		Vector3i(-1, 0, -1):
			direction.text = "Lewo-Góra"
		Vector3i(1, 0, -1):
			direction.text = "Prawo-Góra"
		Vector3i(-1, 0, 1):
			direction.text = "Lewo-Dół"
		Vector3i(1, 0, 1):
			direction.text = "Prawo-Dół"
		_:
			direction.text = ""
	

func _can_attack_from_position(move_cell: Vector3i) -> bool:
	
	return (
		GLOBAL.GRID.get_cell_item(move_cell) in [GLOBAL.GRID.cell_type.MOVE, GLOBAL.GRID.cell_type.UNIT] and
		(not GLOBAL.GRID._is_cell_occupied(move_cell) or GLOBAL.GRID.get_unit(move_cell) == GLOBAL.active_unit) and
		(
			move_cell == GLOBAL.GRID.local_to_map(GLOBAL.active_unit.global_transform.origin) or
			not GLOBAL.GRID._is_cell_occupied(move_cell) or
			GLOBAL.GRID.get_unit(move_cell) == GLOBAL.active_unit
		)
	)


func _click_input(event):
	var r_cell = _get_cell_at_mouse_position(event.position)
	if r_cell.is_empty(): return
	var cell = r_cell[0]
	var id = r_cell[1]

	if id == GLOBAL.GRID.cell_type.SELECT: 
		op_move(cell)
		emit_signal("S_end_turn")
	elif id == GLOBAL.GRID.cell_type.ENEMY:
		if op_attack(cell, event.position): 
			emit_signal("S_end_turn")


func _input(event):
	if GLOBAL.active_skill:
		if event.is_action_pressed("LMB"):
			_skill_input(event)
			
	
	if event is InputEventMouseMotion:  
		_hover_input(event)		
		
	if event.is_action_pressed("LMB") and !GLOBAL.active_unit.is_moving and not GLOBAL.active_skill:
		_click_input(event)
		
	if event.is_action_pressed("RMB"):
		if not _click_info_input(event):
			if GLOBAL.unit_panel:
				GLOBAL.unit_panel.panel_view(false)
				GLOBAL.unit_panel.skillsList.skills_list(false)
				
	
		
	
func _skill_input(event):
	var r_cell = _get_cell_at_mouse_position(event.position)
	if r_cell.is_empty():
		return

	var cell = r_cell[0]
	var id = r_cell[1]

	if id in [GLOBAL.GRID.cell_type.ENEMY, GLOBAL.GRID.cell_type.INFO_SELF]:
		var target = GLOBAL.GRID.get_unit(cell)
		if target and not target in GLOBAL.targets:
			GLOBAL.targets.append(target)

		if GLOBAL.targets.size() >= GLOBAL.active_skill.targets_number or \
		   GLOBAL.targets.size() >= GLOBAL.active_skill.total_available:
			GLOBAL.active_skill.real_work()
			GLOBAL.active_skill = null


		
	
func _click_info_input(event):
	var r_cell = _get_cell_at_mouse_position(event.position)
	if r_cell.is_empty(): return false
	var cell = r_cell[0]
	unit = GLOBAL.GRID.get_unit(cell)
	
	if unit and unit != GLOBAL.active_unit:
		if GLOBAL.unit_panel: GLOBAL.unit_panel.panel_view(false)
		
		unit.panel_view(true, true)
		unit.skillsList.skills_list(false)
		GLOBAL.unit_panel = unit
		return true
		
	return false

func _raycast(mouse_position: Vector2) -> Dictionary:
	var space_state = CAMERA.get_world_3d().direct_space_state
	var from = CAMERA.project_ray_origin(mouse_position)
	var to = from + CAMERA.project_ray_normal(mouse_position) * 1000
	return space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
		
		
func _get_cell_at_mouse_position(mouse_position: Vector2) -> Array:
	var result = _raycast(mouse_position)
	if result.has("position"):
		return [GLOBAL.GRID.map_to_local(result.position), GLOBAL.GRID.get_cell_item(result.position)]
	return []
	
func get_mouse_world_position(mouse_position: Vector2) -> Vector3:
	var result = _raycast(mouse_position)
	if result.has("position"):
		return result.position
	
	return Vector3(-1,-1,-1)
			
func op_move(cell):
	var world_pos = GLOBAL.GRID.map_to_local(cell)
			
	GLOBAL.GRID.free_oc_cell(GLOBAL.GRID.local_to_map(GLOBAL.active_unit.global_transform.origin))
	GLOBAL.GRID.occupy_cell(cell, GLOBAL.active_unit)
			
	GLOBAL.active_unit.move(world_pos)
	

func op_attack(cell: Vector3i, mouse_position: Vector2) -> bool:
	var attacked_unit = GLOBAL.GRID.get_unit(cell)
	if attacked_unit == null: 
		return false


	var enemy_pos = GLOBAL.GRID.map_to_local(cell)
	var mouse_world_pos = get_mouse_world_position(mouse_position)
	if mouse_world_pos == Vector3(-1,-1,-1): return false
	
	var click_dir = (mouse_world_pos - enemy_pos).normalized()


	var delta = Vector3i(
		1 if click_dir.x > 0.3 else (-1 if click_dir.x < -0.3 else 0),
		0,
		1 if click_dir.z > 0.3 else (-1 if click_dir.z < -0.3 else 0)
	)


	var desired_cell = cell + delta
	var player_cell = GLOBAL.GRID.local_to_map(GLOBAL.active_unit.global_transform.origin)
	var standing_direction = cell - player_cell

	var damage_deal: int = 0
	if standing_direction == -delta:
		damage_deal = attacked_unit.calculate_attack()
	elif GLOBAL.active_unit.actual_stats.ammo > 0 and GLOBAL.active_unit.d_attack:
		GLOBAL.active_unit.actual_stats.ammo -= 1
		damage_deal = attacked_unit.calculate_attack(1, true)
	elif GLOBAL.GRID.get_cell_item(desired_cell) == GLOBAL.GRID.cell_type.SELECT:
		op_move(desired_cell)
		damage_deal = attacked_unit.calculate_attack()
	else:
		return false

	GLOBAL.active_unit.effects.on_attack(damage_deal, attacked_unit)

	return true


func update_attack_direction(cell: Vector3i, mouse_position: Vector2) -> Vector3:
	var enemy_pos = GLOBAL.GRID.map_to_local(cell)
	var mouse_world_pos = get_mouse_world_position(mouse_position)
	if mouse_world_pos == Vector3(-1,-1,-1): 
		direction.text = ""
		return Vector3i.ZERO
	
	var click_dir = (mouse_world_pos - enemy_pos).normalized()
	
	var delta = Vector3i(
		1 if click_dir.x > 0.3 else (-1 if click_dir.x < -0.3 else 0),
		0,
		1 if click_dir.z > 0.3 else (-1 if click_dir.z < -0.3 else 0)
	)
	
	return delta
