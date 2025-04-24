extends Node

@onready var GRID = %Grid
@onready var CAMERA =  %Camera

@onready var MARKER = $Marker

func _input(event):
	if event is InputEventMouseMotion:  
		var cell = _get_tile_at_mouse_position(event.position)[0]
		GRID.select_cell(cell)
		
		
		
	if event.is_action_pressed("LMB") and !BATTLE.active_unit.is_moving:
		var r_cell = _get_tile_at_mouse_position(event.position)
		var cell = r_cell[0]
		var id = r_cell[1]
		
		if id == 1: # ZMIENIC NA TYP CELL +> MOZE GLOBAL
			op_move(cell)
			
		if id == 3: # DAC NA TYP CELL +> MOZE GLOBAL
			print(cell)
			op_attack(cell)
			
			
func op_move(cell): 
	var world_pos = GRID.map_to_local(cell)
			
	GRID.free_oc_cell(GRID.local_to_map(BATTLE.active_unit.global_transform.origin))
	GRID.occupy_cell(cell, BATTLE.active_unit)
			
	BATTLE.active_unit.move(world_pos) # PORUSZANIE JEDNSOTKA
	
func op_attack(cell):
	var attacked_unit = GRID.get_unit(cell)
	
	attacked_unit.take_damage()
	print_rich("[color=red]ATACKED[/color]")
	pass

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
