extends Node

signal S_end_turn

@onready var direction = %Direction

@onready var GRID = %Grid
@onready var CAMERA =  %Camera


var unit: Unit = null

func _input(event):
	if event is InputEventMouseMotion:  
		var r_cell = _get_cell_at_mouse_position(event.position)
		if r_cell.is_empty(): 
			direction.text = ""
			return
		var cell = r_cell[0]
		var id = r_cell[1]
		
		if id in [GRID.cell_type.MOVE,GRID.cell_type.SELECT, GRID.cell_type.UNIT]:
			GRID.select_cell(cell)
		
		if id == GRID.cell_type.ENEMY:
			for c in GRID.selected_area:
				GRID.set_cell_item(c, 0)
			GRID.selected_area.clear()
			unit = GRID.get_unit(cell)
			unit.hp_debug(true)
			update_attack_direction(cell, event.position)
		elif unit != null:
			unit.hp_debug(false)
			direction.text = ""
		
		
	if event.is_action_pressed("LMB") and !BATTLE.active_unit.is_moving:
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
	
#	?? COS POPRAWIC
	var old_pos = GRID.local_to_map(BATTLE.active_unit.global_transform.origin)
	GRID.free_oc_area(BATTLE.active_unit)
	GRID.occupy_area(cell, BATTLE.active_unit)
			
	BATTLE.active_unit.move(world_pos) # PORUSZANIE JEDNSOTKA
	
	
	
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
		attacked_unit.take_damage()

	elif GRID.get_cell_item(desired_cell) in [GRID.cell_type.MOVE, GRID.cell_type.UNIT]:
		if not GRID._is_cell_occupied(desired_cell) or GRID.get_unit(desired_cell) == BATTLE.active_unit:
			op_move(desired_cell)
			attacked_unit.take_damage()
	else:
		return false

	return true




func update_attack_direction(cell: Vector3i, mouse_position: Vector2):
	var enemy_pos = GRID.map_to_local(cell)
	var mouse_world_pos = get_mouse_world_position(mouse_position)
	if mouse_world_pos == Vector3(-1,-1,-1): return 
	var click_dir = (mouse_world_pos - enemy_pos).normalized()

	var delta = Vector3i(
		1 if click_dir.x > 0.3 else (-1 if click_dir.x < -0.3 else 0),
		0,
		1 if click_dir.z > 0.3 else (-1 if click_dir.z < -0.3 else 0)
	)

	match delta:
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
