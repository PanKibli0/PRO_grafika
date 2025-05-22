extends Node

signal S_end_turn

@onready var direction = %Direction

@onready var GRID = %Grid
@onready var CAMERA =  %Camera


var unit: Unit = null

func _hover_input(event):
	var r_cell = _get_cell_at_mouse_position(event.position)
	if r_cell.is_empty(): 
		direction.text = ""
		return
	
	var cell = r_cell[0]
	var id = r_cell[1]
	
	GRID.select_cell(cell)
	
	if id == GRID.cell_type.ENEMY:
		unit = GRID.get_unit(cell)
		unit.panel_view(true, true)

		
		var attack_direction = update_attack_direction(cell, event.position)
		print_direction(attack_direction)
		if attack_direction != Vector3.ZERO:
			var attack_move_cell = cell + attack_direction
			if _can_attack_from_position(attack_move_cell):
				GRID.select_cell(cell)
				GRID.select_cell(attack_move_cell)
				
					
	elif unit != null:
		unit.panel_view(false)
		direction.text = ""
		
	if id in [GRID.cell_type.INFO_ENEMY, GRID.cell_type.INFO_SELF]:
		unit = GRID.get_unit(cell)
		if unit:
			unit.panel_view(true, true)

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
		GRID.get_cell_item(move_cell) in [GRID.cell_type.MOVE, GRID.cell_type.UNIT] and
		(not GRID._is_cell_occupied(move_cell) or GRID.get_unit(move_cell) == BATTLE.active_unit) and
		(
			move_cell == GRID.local_to_map(BATTLE.active_unit.global_transform.origin) or
			not GRID._is_cell_occupied(move_cell) or
			GRID.get_unit(move_cell) == BATTLE.active_unit
		)
	)


func _click_input(event):
	var r_cell = _get_cell_at_mouse_position(event.position)
	if r_cell.is_empty(): return
	var cell = r_cell[0]
	var id = r_cell[1]

	if id == GRID.cell_type.SELECT: 
		op_move(cell)
		emit_signal("S_end_turn")
	elif id == GRID.cell_type.ENEMY:
		if op_attack(cell, event.position): 
			emit_signal("S_end_turn")


func _input(event):
	if event is InputEventMouseMotion:  
		_hover_input(event)		
		
	if event.is_action_pressed("LMB") and !BATTLE.active_unit.is_moving:
		_click_input(event)
		
	
func _raycast(mouse_position: Vector2) -> Dictionary:
	var space_state = CAMERA.get_world_3d().direct_space_state
	var from = CAMERA.project_ray_origin(mouse_position)
	var to = from + CAMERA.project_ray_normal(mouse_position) * 1000
	return space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
		
		
func _get_cell_at_mouse_position(mouse_position: Vector2) -> Array:
	var result = _raycast(mouse_position)
	if result.has("position"):
		return [GRID.map_to_local(result.position), GRID.get_cell_item(result.position)]
	return []
	
func get_mouse_world_position(mouse_position: Vector2) -> Vector3:
	var result = _raycast(mouse_position)
	if result.has("position"):
		return result.position
	
	return Vector3(-1,-1,-1)
			
func op_move(cell):
	var world_pos = GRID.map_to_local(cell)
			
	GRID.free_oc_cell(GRID.local_to_map(BATTLE.active_unit.global_transform.origin))
	GRID.occupy_cell(cell, BATTLE.active_unit)
			
	BATTLE.active_unit.move(world_pos)
	

func op_attack(cell: Vector3i, mouse_position: Vector2) -> bool:
	var attacked_unit = GRID.get_unit(cell)
	if attacked_unit == null: 
		return false


	var enemy_pos = GRID.map_to_local(cell)
	var mouse_world_pos = get_mouse_world_position(mouse_position)
	if mouse_world_pos == Vector3(-1,-1,-1): return false
	
	var click_dir = (mouse_world_pos - enemy_pos).normalized()


	var delta = Vector3i(
		1 if click_dir.x > 0.3 else (-1 if click_dir.x < -0.3 else 0),
		0,
		1 if click_dir.z > 0.3 else (-1 if click_dir.z < -0.3 else 0)
	)


	var desired_cell = cell + delta
	var player_cell = GRID.local_to_map(BATTLE.active_unit.global_transform.origin)
	var standing_direction = cell - player_cell


	if standing_direction == -delta:
		attacked_unit.calculate_attack()
	elif BATTLE.active_unit.actual_stats.ammo > 0 and BATTLE.active_unit.d_attack:
		BATTLE.active_unit.actual_stats.ammo -= 1
		attacked_unit.calculate_attack()
	elif GRID.get_cell_item(desired_cell) == GRID.cell_type.SELECT:
		op_move(desired_cell)
		attacked_unit.calculate_attack()
	else:
		return false

	attacked_unit.effects.on_attack(attacked_unit)

	return true


func update_attack_direction(cell: Vector3i, mouse_position: Vector2) -> Vector3:
	var enemy_pos = GRID.map_to_local(cell)
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
