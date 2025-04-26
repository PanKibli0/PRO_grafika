extends Node

signal end_turn

@onready var GRID = %Grid
@onready var CAMERA =  %Camera

@onready var MARKER = $Marker

var unit: Unit = null

func _input(event):
	if event is InputEventMouseMotion:  
		var r_cell = _get_tile_at_mouse_position(event.position)
		if r_cell == []: return
		var cell = r_cell[0]
		var id = r_cell[1]
		
		if id == GRID.cell_type.MOVE:
			GRID.select_cell(cell)
		

		if id == GRID.cell_type.ENEMY:
			GRID.set_cell_item(GRID.selected_cell, 0)
			GRID.selected_cell = Vector3i(-1,-1,-1)
			unit = GRID.get_unit(cell)
			unit.hp_debug(true)
		elif unit != null:
			unit.hp_debug(false)
		
	if event.is_action_pressed("LMB") and !BATTLE.active_unit.is_moving:
		var r_cell = _get_tile_at_mouse_position(event.position)
		if r_cell == []: return
		var cell = r_cell[0]
		var id = r_cell[1]
		
		if id == GRID.cell_type.SELECT: 
			op_move(cell)
			emit_signal("end_turn")
		elif id == GRID.cell_type.ENEMY:
			op_attack(cell)
			emit_signal("end_turn")
		
			
func op_move(cell): 
	var world_pos = GRID.map_to_local(cell)
			
	GRID.free_oc_cell(GRID.local_to_map(BATTLE.active_unit.global_transform.origin))
	GRID.occupy_cell(cell, BATTLE.active_unit)
			
	BATTLE.active_unit.move(world_pos) # PORUSZANIE JEDNSOTKA
	

func op_attack(cell: Vector3i):
	var attacked_unit = GRID.get_unit(cell)
	if attacked_unit == null: return
	
	var enemy_cell = cell
	var enemy_pos = GRID.map_to_local(enemy_cell)
	var player_cell = GRID.local_to_map(BATTLE.active_unit.global_transform.origin)

	var from = CAMERA.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + CAMERA.project_ray_normal(get_viewport().get_mouse_position()) * 1000

	var space_state = CAMERA.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)

	var mouse_world_pos = Vector3.ZERO
	if result.has("position"):
		mouse_world_pos = result.position

	var click_dir = (mouse_world_pos - enemy_pos).normalized()

	var delta = Vector3i(
		1 if click_dir.x > 0.3 else (-1 if click_dir.x < -0.3 else 0),
		0,
		1 if click_dir.z > 0.3 else (-1 if click_dir.z < -0.3 else 0)
	)

	var desired_cell = enemy_cell + delta
	var standing_direction = enemy_cell - player_cell

	if standing_direction == delta:
		perform_attack(attacked_unit, delta)
	else:
		op_move(desired_cell)
		perform_attack(attacked_unit, delta)
		

func perform_attack(attacked_unit, direction: Vector3i):
	attacked_unit.take_damage()
	match direction:
		Vector3i(1,0,0):
			print("Atak od lewej")
		Vector3i(-1,0,0):
			print("Atak od prawej")
		Vector3i(0,0,1):
			print("Atak od przodu")
		Vector3i(0,0,-1):
			print("Atak od tyłu")
		_:
			print("Atak po skosie:", direction)



func _get_tile_at_mouse_position(mouse_position) -> Array:
	var space_state = CAMERA.get_world_3d().direct_space_state
	var from = CAMERA.project_ray_origin(mouse_position)
	var to = from + CAMERA.project_ray_normal(mouse_position) * 1000
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	

	var hit_position: Vector3
	if result.has("position"):
		hit_position = result.position
	else:
		var ray_dir = (to - from).normalized()
		var t = -from.y / ray_dir.y 
		hit_position = from + ray_dir * t
		hit_position.y = 0.55

	MARKER.position = hit_position
	
	if result.has("position"):
		return [GRID.map_to_local(result.position), GRID.get_cell_item(result.position)]
		
	return [GRID.selected_cell, GRID.get_cell_item(GRID.selected_cell)]
