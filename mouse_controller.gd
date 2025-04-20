extends Node

@onready var grid = %Grid
@onready var camera =  %Camera

@onready var marker = $Marker

func _input(event):
	if event is InputEventMouseMotion:  
		var cell = _get_tile_at_mouse_position(event.position)[0]
		grid.select_cell(cell)
		
		
		
	if event.is_action_pressed("LMB") and !GLOBAL.active_unit.is_moving:
		var r_cell = _get_tile_at_mouse_position(event.position)
		var cell = r_cell[0]
		var id = r_cell[1]
		
		if id == 1: # ZMIENIC NA TYP CELL +> MOZE GLOBAL
			op_move(cell)
			
		if id == 3: # DAC NA TYP CELL +> MOZE GLOBAL
			print(cell)
			op_attack(cell)
			
			
func op_move(cell): 
	var world_pos = grid.map_to_local(cell)
			
	grid.free_oc_cell(grid.local_to_map(GLOBAL.active_unit.global_transform.origin))
	grid.occupy_cell(cell, GLOBAL.active_unit)
			
	GLOBAL.active_unit.move(world_pos) # PORUSZANIE JEDNSOTKA
	
func op_attack(cell):
	var attacked_unit = grid.get_unit(cell)
	
	attacked_unit.take_damage()
	print_rich("[color=red]ATACKED[/color]")
	pass

func _get_tile_at_mouse_position(mouse_position) -> Array:
	var space_state = camera.get_world_3d().direct_space_state
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * 1000
	
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

	marker.position = hit_position
	
	if result.has("position"):
		return [grid.map_to_local(result.position), grid.get_cell_item(result.position)]
		
	return [grid.selected_cell, grid.get_cell_item(grid.selected_cell)]
