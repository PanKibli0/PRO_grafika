extends Node

@onready var grid = %Grid
@onready var camera =  %Camera

@onready var marker = $Marker

func _input(event):
	if event is InputEventMouseMotion:  
		var cell = _get_tile_at_mouse_position(event.position)
		grid.select_cell(cell)
		
	if event.is_action_pressed("LMB") and !GLOBAL.active_unit.is_moving:
		var cell = _get_tile_at_mouse_position(event.position)
		print_rich("[color=red]Unit is in cell:[/color] ", cell)
		
		if cell != Vector3i(-1,-1,-1):
			var world_pos = grid.map_to_local(cell)
			world_pos.y = GLOBAL.active_unit.global_transform.origin.y
			
			grid.free_oc_cell(grid.local_to_map(GLOBAL.active_unit.global_transform.origin))
			grid.occupy_cell(cell, GLOBAL.active_unit)
			
			print_rich("[color=red]CELL:[/color] ", cell)
			print_rich("[color=blue]map_to_local(cell):[/color] ", grid.map_to_local(cell))
			print_rich("[color=purple]GRID pos:[/color] ", grid.global_transform.origin)
			
			GLOBAL.active_unit.move(world_pos) # PORUSZANIE JEDNSOTKA
			
		
func _get_tile_at_mouse_position(mouse_position) -> Vector3i:
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

	marker.position = hit_position

	if result.has("position"):
		#print_rich("[color=yellow]",result.position,"[/color]")
		#print_rich("[color=red]",grid.local_to_map(result.position),"[/color]")
		#return grid.local_to_map(result.position)
		return result.position
	
	
	return grid.selected_cell
